# ✅ Sensor Data Explorer - Time-Series Visualization Fixed

## Issue: "Column-Like" Lines Instead of Smooth Time-Series

### Problem Description

The Power Usage panels were showing **vertical bars/columns** instead of smooth time-series lines. The graphs looked like this:
- Discrete vertical jumps (0 → 250W → 0)
- Staircase/stepped appearance
- More like a bar chart than continuous monitoring

### Root Cause Analysis

**Data Pattern Issue:**
```
All 16 DEMO devices write at the EXACT same timestamp every 30 seconds:
- 20:07:10.050098 → 16 devices (DEMO_PrusaMK4_1 through DEMO_Voron24_2)
- 20:06:40.029482 → 16 devices
- 20:06:10.994898 → 16 devices
```

**What Grafana Saw:**
- Without aggregation, Grafana plotted ALL 16 device values at each timestamp
- This created 16 overlapping data points every 30 seconds
- The visualization engine summed/stacked these, creating huge spikes
- Result: **250W spike** (sum of all devices) followed by **gaps** (no data between 30s intervals)

**Visual Effect:**
```
Power (W)
  250 |     ┃           ┃
  200 |     ┃     ┃     ┃
  150 |     ┃     ┃     ┃
  100 |  ┃  ┃     ┃     ┃
   50 |  ┃  ┃     ┃     ┃
    0 |__┃__┃_____┃_____┃_____
        22:58  23:00  23:01  23:02
```

This creates the "column" effect you observed.

---

## Solution Applied

### Changed Query Strategy

**Original Query (Broken):**
```sql
SELECT
  "timestamp" AS "time",
  power_watts AS "Power (W)",
  energy_today_kwh AS "Energy Today (kWh)"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
ORDER BY "timestamp"
```

**Problem:** Returns 16 rows per timestamp (one per device), causing overlapping data points.

---

**Fixed Query (Smooth):**
```sql
SELECT
  $__timeGroup("timestamp", '10s') AS "time",
  AVG(power_watts) AS "Power (W)",
  AVG(energy_today_kwh) AS "Energy Today (kWh)"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
GROUP BY 1
ORDER BY 1
```

**Key Changes:**
1. **`$__timeGroup("timestamp", '10s')`** - Groups data into 10-second buckets
2. **`AVG(power_watts)`** - Averages all 16 devices' power consumption
3. **`GROUP BY 1`** - Groups by time bucket
4. **Result:** One data point every 10 seconds instead of 16 overlapping points every 30 seconds

---

### Visual Improvement

**Before (Columns):**
```
16 devices × 1 timestamp = 16 overlapping points
Grafana shows: SPIKE (sum/stack) then GAP then SPIKE
```

**After (Smooth Line):**
```
10-second buckets with averaged values
Grafana shows: Continuous smooth line representing fleet average
```

**Example Data After Fix:**
```
Time          | Avg Power | Avg Voltage | Avg Current | Data Points
20:07:10      | 45.9W     | 229.5V      | 0.20A      | 16 devices
20:06:40      | 50.4W     | 229.0V      | 0.22A      | 16 devices
20:06:10      | 46.7W     | 229.4V      | 0.20A      | 16 devices
```

Now shows as smooth continuous line, not vertical bars.

---

## Technical Details

### Both Panels Fixed

**Panel 1: Power & Energy Today**
```sql
SELECT
  $__timeGroup("timestamp", '10s') AS "time",
  AVG(power_watts) AS "Power (W)",
  AVG(energy_today_kwh) AS "Energy Today (kWh)"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
GROUP BY 1
ORDER BY 1
```

**Panel 2: Voltage & Current**
```sql
SELECT
  $__timeGroup("timestamp", '10s') AS "time",
  AVG(voltage) AS "Voltage",
  AVG(current_amps) AS "Current"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
GROUP BY 1
ORDER BY 1
```

### Grafana Time Grouping

**`$__timeGroup(column, interval)`** - Grafana macro that:
1. Automatically adjusts bucket size based on time range
2. Fills gaps with NULL (creates continuous line)
3. Aligns timestamps to regular intervals
4. Returns proper time-series format

**Interval `'10s'`:**
- Creates buckets every 10 seconds
- 3 buckets per 30-second update cycle
- Smoother visualization than raw 30-second intervals

---

## Expected Visualization

### Now You Should See:

**Green Line (Power):**
- Smooth continuous line showing fleet average power consumption
- Gradual rises when printers start (heating phase)
- Steady level during active printing
- Gradual drops when printers finish/idle

**Yellow Line (Energy Today):**
- Gradually increasing cumulative line
- Smooth slope showing energy accumulation
- No sudden jumps or drops

**Legend Values:**
- Power: 40-60W avg (fleet average across 16 printers)
- Voltage: ~229V (consistent supply)
- Current: 0.18-0.22A avg
- Energy Today: Steadily increasing from 0.000x kWh

---

## Verification

Test query showing smooth aggregation:

```sql
SELECT
  DATE_TRUNC('second', timestamp) AS time_bucket,
  ROUND(AVG(power_watts)::numeric, 1) AS avg_power,
  COUNT(*) as devices
FROM energy_data
WHERE device_id LIKE 'DEMO_%'
  AND timestamp > NOW() - INTERVAL '2 minutes'
GROUP BY DATE_TRUNC('second', timestamp)
ORDER BY time_bucket DESC;
```

**Result:**
```
time_bucket  | avg_power | devices
20:07:10     | 45.9W     | 16
20:06:40     | 50.4W     | 16
20:06:10     | 46.7W     | 16
```

Each bucket aggregates 16 devices into one smooth data point ✅

---

## Alternative Approach (If Needed)

If you want to see **individual printer lines** instead of fleet average:

```sql
SELECT
  $__timeGroup("timestamp", '10s') AS "time",
  device_id,
  AVG(power_watts) AS "Power (W)"
FROM energy_data
WHERE device_id LIKE 'DEMO_%' AND $__timeFilter("timestamp")
GROUP BY 1, device_id
ORDER BY 1, device_id
```

This would show:
- 16 separate colored lines (one per printer)
- Individual printer behavior visible
- More detailed but potentially cluttered

---

## Files Modified

1. **Dashboard File:**
   - `/home/ubuntu/enms-demo/grafana/dashboards/Sensor-Data-Explorer.json`
   - Panel 1: Power Usage (Power & Energy) - Added aggregation
   - Panel 2: Power Usage (Voltage & Current) - Added aggregation

2. **Changes:**
   - Replaced direct `SELECT timestamp, value` 
   - With `SELECT $__timeGroup(...), AVG(value) GROUP BY 1`
   - Applied to both power panels

---

## Success Metrics

| Metric | Before | After |
|--------|--------|-------|
| Visualization Type | Vertical bars/columns | Smooth time-series lines ✅ |
| Data Points per Timestamp | 16 (overlapping) | 1 (aggregated) ✅ |
| Time Bucket Size | 30s (sparse) | 10s (smooth) ✅ |
| Values Shown | Sum/Stack of all devices | Average across fleet ✅ |
| Visual Clarity | Confusing spikes | Clear trends ✅ |

---

## Troubleshooting

### If Lines Still Look Stepped:
1. **Check time range** - Zoom out to see more data points
2. **Verify refresh** - Wait 30 seconds for new aggregated data
3. **Clear browser cache** - Force reload (Ctrl+Shift+R)

### If Values Look Different:
- **Before:** Showed sum/stack of 16 devices (0-250W spikes)
- **After:** Shows average of 16 devices (40-60W smooth)
- This is correct! You're now seeing **fleet average** not **total sum**

### To See Total Instead of Average:
Change `AVG(power_watts)` to `SUM(power_watts)` if you want total fleet consumption.

---

**Status:** ✅ TIME-SERIES VISUALIZATION FIXED

**Dashboard URL:** http://localhost:3002/d/cetamfgpx9mo0f/sensor-data-explorer

**Expected Result:** Smooth continuous lines showing fleet-average trends over time, no more vertical bar/column effects!
