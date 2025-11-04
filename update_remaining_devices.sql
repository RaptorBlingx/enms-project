-- Migration script to update remaining devices with old locations
-- Date: 2025-11-02
-- Purpose: Update all remaining devices to use new location names

BEGIN;

-- Update remaining Demo FabLab devices to distribute across the three new locations
UPDATE devices SET location = 'APlus Art' WHERE device_id = 'DEMO_PrusaMK4_3';
UPDATE devices SET location = 'APlus Art' WHERE device_id = 'DEMO_PrusaMK4_4';
UPDATE devices SET location = 'APlus Engineering' WHERE device_id = 'DEMO_PrusaMini_3';
UPDATE devices SET location = 'APlus Science' WHERE device_id = 'DEMO_PrusaMini_4';
UPDATE devices SET location = 'APlus Engineering' WHERE device_id = 'DEMO_PrusaXL_1';
UPDATE devices SET location = 'APlus Science' WHERE device_id = 'DEMO_PrusaXL_2';
UPDATE devices SET location = 'APlus Art' WHERE device_id = 'DEMO_Ultimaker2Plus_1';
UPDATE devices SET location = 'APlus Engineering' WHERE device_id = 'DEMO_Ultimaker2Plus_2';
UPDATE devices SET location = 'APlus Science' WHERE device_id = 'DEMO_Voron24_1';
UPDATE devices SET location = 'APlus Art' WHERE device_id = 'DEMO_Voron24_2';

-- Update "Fab Lab Fabulous St. Pauli" devices to new locations
UPDATE devices SET location = 'APlus Science' WHERE location = 'Fab Lab Fabulous St. Pauli';

-- Update "Open Lab Microfactory" devices to new locations
UPDATE devices SET location = 'APlus Art' WHERE location = 'Open Lab Microfactory';

-- Update "FactoryFloor" to APlus Engineering
UPDATE devices SET location = 'APlus Engineering' WHERE location = 'FactoryFloor';

-- Update "FabLab" to APlus Engineering
UPDATE devices SET location = 'APlus Engineering' WHERE location = 'FabLab';

-- Update any remaining "Demo FabLab" devices
UPDATE devices SET location = 'APlus Engineering' WHERE location = 'Demo FabLab';

-- Update the Ender-3-Pro-1 device that wasn't updated yet
UPDATE devices 
SET friendly_name = 'Prusa i3 MK3S+ #2', 
    device_model = 'Prusa i3 MK3S+',
    notes = 'High-precision FDM printer with excellent print quality'
WHERE device_id = 'Ender-3-Pro-1';

COMMIT;

-- Display all devices to verify changes
SELECT device_id, friendly_name, device_model, location FROM devices ORDER BY location, friendly_name;
