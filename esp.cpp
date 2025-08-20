#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <max6675.h> // Your current library for MAX6675
#include <DHT.h>

// --- WiFi Settings ---
const char* ssid = "raptorblingx";         // <<<< CHANGE THIS
const char* password = "raptorblingx"; // <<<< CHANGE THIS

// --- MQTT Settings ---
const char* mqtt_server = "89.252.166.188";
const int mqtt_port = 2010;
const char* mqtt_user = "raptorblingx";
const char* mqtt_password = "raptorblingx";
const char* mqtt_client_id = "ESP32_SensorHub_Raptor"; // Unique client ID

// Base MQTT topic
const char* mqtt_base_topic = "esp32/raptorblingx";

// --- Sensor Objects and Pins ---
Adafruit_MPU6050 mpu;
int thermoDO = 4;
int thermoCS = 5;
int thermoCLK = 27;
MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);
#define DHTPIN 16
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// --- Global Variables ---
WiFiClient espClient;
PubSubClient mqttClient(espClient);

unsigned long previousMillisMPU = 0;
unsigned long previousMillisMAX = 0;
unsigned long previousMillisDHT = 0;
unsigned long previousMillisMQTT = 0;

const long intervalMPU = 100;
const long intervalMAX = 500;
const long intervalDHT = 2000;
const long intervalMQTT = 5000; // Publish data to MQTT every 5 seconds

float mpu_accel_x, mpu_accel_y, mpu_accel_z;
float mpu_gyro_x, mpu_gyro_y, mpu_gyro_z;
float mpu_chip_temp;
float max6675_temp_c = NAN;
float dht_humidity = NAN, dht_temp_c = NAN;

// --- Function Declarations ---
void setup_wifi();
void reconnect_mqtt();
void read_sensors(unsigned long currentMillis); // Added parameter
void publish_mqtt_data();

// =================================================================
// SETUP
// =================================================================
void setup() {
  Serial.begin(115200);
  while (!Serial) { ; }

  setup_wifi();
  mqttClient.setServer(mqtt_server, mqtt_port);

  Serial.println("Initializing MPU6050...");
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip.");
  } else {
    Serial.println("MPU6050 Found!");
    mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
    mpu.setGyroRange(MPU6050_RANGE_500_DEG);
    mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
  }
  Serial.println("------------------------------------");

  Serial.println("Initializing DHT22...");
  dht.begin();
  delay(1000);
  Serial.println("DHT22 Initialized.");
  Serial.println("------------------------------------");
  
  Serial.println("MAX6675 K-Thermocouple Initialized.");
  delay(500);
  Serial.println("------------------------------------");

  Serial.println("All sensors initialized. Starting readings.");
  Serial.println();
}

// =================================================================
// MAIN LOOP
// =================================================================
void loop() {
  if (!mqttClient.connected()) {
    reconnect_mqtt();
  }
  mqttClient.loop();

  unsigned long currentMillis = millis();
  read_sensors(currentMillis);

  if (currentMillis - previousMillisMQTT >= intervalMQTT) {
    previousMillisMQTT = currentMillis;
    publish_mqtt_data();
  }
}

// =================================================================
// WIFI SETUP (Same as before)
// =================================================================
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  int retries = 0;
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    retries++;
    if (retries > 30) {
        Serial.println("\nFailed to connect to WiFi. Retrying in 10 seconds...");
        delay(10000);
        ESP.restart();
    }
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

// =================================================================
// MQTT RECONNECT (Same as before)
// =================================================================
void reconnect_mqtt() {
  while (!mqttClient.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (mqttClient.connect(mqtt_client_id, mqtt_user, mqtt_password)) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

// =================================================================
// READ SENSORS (Same as before)
// =================================================================
void read_sensors(unsigned long currentMillis) {
  if (currentMillis - previousMillisMPU >= intervalMPU) {
    previousMillisMPU = currentMillis;
    sensors_event_t a, g, temp_event_mpu;
    if (mpu.getEvent(&a, &g, &temp_event_mpu)) {
      mpu_accel_x = a.acceleration.x;
      mpu_accel_y = a.acceleration.y;
      mpu_accel_z = a.acceleration.z;
      mpu_gyro_x = g.gyro.x;
      mpu_gyro_y = g.gyro.y;
      mpu_gyro_z = g.gyro.z;
      mpu_chip_temp = temp_event_mpu.temperature;
    } else {
      Serial.println("MPU6050 Read Failed!");
    }
  }

  if (currentMillis - previousMillisMAX >= intervalMAX) {
    previousMillisMAX = currentMillis;
    max6675_temp_c = thermocouple.readCelsius();
    if (isnan(max6675_temp_c)) {
        Serial.println("K-Type Error: Failed to read (NaN).");
        max6675_temp_c = NAN; 
    } else if (max6675_temp_c == 0.0) {
        Serial.println("K-Type Warning: Reading 0.00 C (possible open circuit).");
    }
  }

  if (currentMillis - previousMillisDHT >= intervalDHT) {
    previousMillisDHT = currentMillis;
    dht_humidity = dht.readHumidity();
    dht_temp_c = dht.readTemperature();
    if (isnan(dht_humidity) || isnan(dht_temp_c)) {
      Serial.println("Failed to read from DHT sensor!");
      dht_humidity = NAN; dht_temp_c = NAN;
    }
  }
}

// =================================================================
// PUBLISH MQTT DATA - MODIFIED FOR SEPARATE TOPICS
// =================================================================
void publish_mqtt_data() {
  if (!mqttClient.connected()) {
    Serial.println("MQTT not connected. Cannot publish.");
    return;
  }

  char topicBuffer[100]; // Buffer for constructing topic strings
  char payloadBuffer[20]; // Buffer for float/int to string conversion

  Serial.println("Publishing data to separate MQTT topics...");

  // --- MPU6050 Data ---
  if (!isnan(mpu_accel_x)) { // Check if data is valid before publishing
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/accel/x", mqtt_base_topic);
    dtostrf(mpu_accel_x, 4, 2, payloadBuffer); // Convert float to string (width 4, 2 decimal places)
    mqttClient.publish(topicBuffer, payloadBuffer);
  }
  if (!isnan(mpu_accel_y)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/accel/y", mqtt_base_topic);
    dtostrf(mpu_accel_y, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }
  if (!isnan(mpu_accel_z)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/accel/z", mqtt_base_topic);
    dtostrf(mpu_accel_z, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }

  if (!isnan(mpu_gyro_x)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/gyro/x", mqtt_base_topic);
    dtostrf(mpu_gyro_x, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }
   if (!isnan(mpu_gyro_y)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/gyro/y", mqtt_base_topic);
    dtostrf(mpu_gyro_y, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }
  if (!isnan(mpu_gyro_z)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/gyro/z", mqtt_base_topic);
    dtostrf(mpu_gyro_z, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }

  if (!isnan(mpu_chip_temp)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/mpu6050/temperature_c", mqtt_base_topic);
    dtostrf(mpu_chip_temp, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }

  // --- MAX6675 Data ---
  if (!isnan(max6675_temp_c)) { // Also check if it's not the 0.0 "open circuit" reading if you want to exclude that
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/max6675/temperature_c", mqtt_base_topic);
    dtostrf(max6675_temp_c, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }

  // --- DHT22 Data ---
  if (!isnan(dht_temp_c)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/dht22/temperature_c", mqtt_base_topic);
    dtostrf(dht_temp_c, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }
  if (!isnan(dht_humidity)) {
    snprintf(topicBuffer, sizeof(topicBuffer), "%s/dht22/humidity", mqtt_base_topic);
    dtostrf(dht_humidity, 4, 2, payloadBuffer);
    mqttClient.publish(topicBuffer, payloadBuffer);
  }
  Serial.println("Finished publishing attempts for this interval.");
}
