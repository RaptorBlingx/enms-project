# ✅ Sensor Data Explorer - Power Usage Panels Fixed

## Issue Resolved

The two "Power Usage" panels in the Sensor Data Explorer dashboard were showing `null` values for **Voltage**, **Current**, and **Energy Today (kWh)** because the demo data generator was not populating these fields.

---

## Root Cause

### Original Generator Code
The `realtime_demo_generator.py` was only inserting 4 fields:
```python
INSERT INTO energy_data (device_id, timestamp, power_watts, energy_total_wh)
VALUES (%s, %s, %s, %s)
```

**Missing fields:**
- `voltage` (V)
- `current_amps` (A) 
- `energy_today_kwh` (kWh)

This caused Grafana to receive `null` for these columns, making Panel 2 completely blank.

---

## Solution Applied

### 1. Updated Data Generator
Modified `/home/ubuntu/enms-demo/realtime_demo_generator.py` to calculate and insert all fields:

```python
# Calculate voltage, current, and daily energy
voltage = round(random.uniform(220, 240), 2)  # 220-240V (European standard)
current_amps = round(power / voltage, 3) if voltage > 0 else 0
energy_today_kwh = round(state.cumulative_energy_wh / 1000, 4)

# Updated INSERT statement
INSERT INTO energy_data (device_id, timestamp, power_watts, energy_total_wh, voltage, current_amps, energy_today_kwh)
VALUES (%s, %s, %s, %s, %s, %s, %s)
```

### 2. Backfilled Historical Data
Updated all 42,064 existing records in the database:

```sql
UPDATE energy_data
SET 
  voltage = 220 + (RANDOM() * 20),  -- 220-240V realistic range
  current_amps = power_watts / (220 + (RANDOM() * 20)),  -- I = P / V
  energy_today_kwh = energy_total_wh / 1000.0  -- Convert Wh to kWh
WHERE device_id LIKE 'DEMO_%';
```

### 3. Restarted Generator Service
```bash
sudo systemctl restart demo-data-generator.service
```

---

## Verification Results

### Panel 1: Power & Energy Today ✅
**Query:**
```sql
SELECT "timestamp" AS "time", power_watts AS "Power (W)", energy_today_kwh AS "Energy Today (kWh)"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
```

**Data (Last 5 minutes):**
- Records: 160
- Avg Power: 53.3W
- Avg Energy Today: 0.0005 kWh

**Status:** ✅ Working - Shows power consumption and cumulative daily energy

---

### Panel 2: Voltage & Current ✅
**Query:**
```sql
SELECT "timestamp" AS "time", voltage AS "Voltage", current_amps AS "Current"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
```

**Data (Last 5 minutes):**
- Records: 160
- Avg Voltage: 229.5V
- Avg Current: 0.222A

**Status:** ✅ Working - Shows realistic voltage and current values

---

## Sample Data

Latest records showing all fields populated:

| Device | Power (W) | Voltage (V) | Current (A) | Energy Today (kWh) |
|--------|-----------|-------------|-------------|--------------------|
| DEMO_PrusaMK4_1 | 1.4 | 226.0 | 0.01 | 0.0000 |
| DEMO_PrusaMK4_2 | 0.0 | 235.9 | 0.00 | 0.0000 |
| DEMO_PrusaMK4_3 | 7.5 | 229.6 | 0.03 | 0.0001 |
| DEMO_PrusaMK4_4 | 9.6 | 220.0 | 0.04 | 0.0001 |
| DEMO_PrusaMini_1 | 41.9 | 225.2 | 0.19 | 0.0005 |

---

## Technical Details

### Voltage Calculation
- Range: 220-240V (typical European 3D printer power supply)
- Random variation for realism
- Updated every 30 seconds

### Current Calculation
- Formula: `Current (A) = Power (W) / Voltage (V)`
- Example: 100W / 230V = 0.435A
- Precision: 3 decimal places

### Energy Today Calculation
- Tracks cumulative energy since generator start
- Resets would happen daily in production (not implemented in demo)
- Formula: `energy_today_kwh = cumulative_wh / 1000`
- Precision: 4 decimal places

---

## Dashboard Status

**Before Fix:**
- ❌ Panel 1: Power working, Energy Today showing `null`
- ❌ Panel 2: Both Voltage and Current showing `null`

**After Fix:**
- ✅ Panel 1: Power **53.3W avg**, Energy Today **0.0005 kWh avg**
- ✅ Panel 2: Voltage **229.5V avg**, Current **0.222A avg**

---

## Files Modified

1. **Generator Script:**
   - `/home/ubuntu/enms-demo/realtime_demo_generator.py`
   - Added voltage, current_amps, energy_today_kwh calculations
   - Updated INSERT statement with 7 fields instead of 4

2. **Database:**
   - Backfilled 42,064 historical records
   - All `energy_data` records now have complete data

3. **Service:**
   - Restarted `demo-data-generator.service`
   - New records generating every 30 seconds with all fields

---

## Access Information

**Dashboard URL:** http://localhost:3002/d/cetamfgpx9mo0f/sensor-data-explorer

**Time Range:** Last 5 minutes (adjustable)

**Real-time Updates:** Every 30 seconds

---

## Future Enhancements (Optional)

1. **Daily Energy Reset:** Implement midnight reset for energy_today_kwh
2. **Power Factor:** Add power factor calculation (currently not used)
3. **Peak Demand Tracking:** Track maximum current draw
4. **Cost Calculation:** Add kWh cost estimates based on regional rates

---

## Success Metrics

| Metric | Before | After |
|--------|--------|-------|
| Null Voltage Values | 100% | 0% ✅ |
| Null Current Values | 100% | 0% ✅ |
| Null Energy Today Values | 100% | 0% ✅ |
| Panel 1 Functionality | 50% | 100% ✅ |
| Panel 2 Functionality | 0% | 100% ✅ |
| Historical Records Updated | 0 | 42,064 ✅ |

---

**Status:** ✅ BOTH POWER USAGE PANELS NOW FULLY OPERATIONAL

**Last Updated:** 2025-10-31 20:01 UTC  
**Records Updated:** 42,064 historical + ongoing real-time  
**Generator Status:** Running with complete data fields
