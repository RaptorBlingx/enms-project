-- Migration script to update device names and locations
-- Date: 2025-11-02
-- Purpose: Change device names to real 3D printer models and update location names

-- Start transaction
BEGIN;

-- Update all devices to use the new location names
-- Change "Demo FabLab" to "APlus Engineering", "APlus Science", and "APlus Art"

-- Update DEMO_Ender3Pro_1 to Prusa i3 MK3S+ at APlus Engineering
UPDATE devices 
SET friendly_name = 'Prusa i3 MK3S+ #1', 
    device_model = 'Prusa i3 MK3S+',
    location = 'APlus Engineering',
    notes = 'High-precision FDM printer with excellent print quality'
WHERE device_id = 'DEMO_Ender3Pro_1';

-- Update DEMO_Ender3Pro_2 to Creality Ender 3 V2 at APlus Engineering
UPDATE devices 
SET friendly_name = 'Creality Ender 3 V2 #1', 
    device_model = 'Creality Ender 3 V2',
    location = 'APlus Engineering',
    notes = 'Reliable budget-friendly printer with upgraded features'
WHERE device_id = 'DEMO_Ender3Pro_2';

-- Update DEMO_PrusaMK4_1 to Anycubic Kobra 2 at APlus Science
UPDATE devices 
SET friendly_name = 'Anycubic Kobra 2 #1', 
    device_model = 'Anycubic Kobra 2',
    location = 'APlus Science',
    notes = 'High-speed FDM printer with impressive acceleration'
WHERE device_id = 'DEMO_PrusaMK4_1';

-- Update DEMO_PrusaMK4_2 to Bambu Lab P1S at APlus Science
UPDATE devices 
SET friendly_name = 'Bambu Lab P1S #1', 
    device_model = 'Bambu Lab P1S',
    location = 'APlus Science',
    notes = 'Fast and reliable CoreXY printer with enclosed chamber'
WHERE device_id = 'DEMO_PrusaMK4_2';

-- Update DEMO_PrusaMK4_3 to Artillery Sidewinder X2 at APlus Art
UPDATE devices 
SET friendly_name = 'Artillery Sidewinder X2 #1', 
    device_model = 'Artillery Sidewinder X2',
    location = 'APlus Art',
    notes = 'Large format printer with direct drive extruder'
WHERE device_id = 'DEMO_PrusaMK4_3';

-- Update DEMO_PrusaMK4_4 to FLSUN QQ-S Pro at APlus Art
UPDATE devices 
SET friendly_name = 'FLSUN QQ-S Pro #1', 
    device_model = 'FLSUN QQ-S Pro',
    location = 'APlus Art',
    notes = 'Delta printer with high-speed printing capabilities'
WHERE device_id = 'DEMO_PrusaMK4_4';

-- Update DEMO_PrusaMini_1 to Elegoo Neptune 3 Pro at APlus Engineering
UPDATE devices 
SET friendly_name = 'Elegoo Neptune 3 Pro #1', 
    device_model = 'Elegoo Neptune 3 Pro',
    location = 'APlus Engineering',
    notes = 'Feature-rich printer with auto bed leveling'
WHERE device_id = 'DEMO_PrusaMini_1';

-- Update DEMO_PrusaMini_2 to Kingroon KP3S Pro at APlus Science
UPDATE devices 
SET friendly_name = 'Kingroon KP3S Pro #1', 
    device_model = 'Kingroon KP3S Pro',
    location = 'APlus Science',
    notes = 'Compact printer with direct drive and quality components'
WHERE device_id = 'DEMO_PrusaMini_2';

-- Commit transaction
COMMIT;

-- Display updated devices
SELECT device_id, friendly_name, device_model, location, notes FROM devices ORDER BY location, friendly_name;
