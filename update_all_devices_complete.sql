-- Complete Migration: Update ALL 33 devices with real 3D printer names
-- Date: 2025-11-02
-- Purpose: Replace every single device with real 3D printer models and proper naming

BEGIN;

-- =============================================================================
-- DEMO DEVICES (16 total)
-- =============================================================================

-- Device 1
UPDATE devices 
SET friendly_name = 'Prusa i3 MK3S+ #1', 
    device_model = 'Prusa i3 MK3S+',
    notes = 'High-precision FDM printer with excellent print quality'
WHERE device_id = 'DEMO_Ender3Pro_1';

-- Device 2
UPDATE devices 
SET friendly_name = 'Creality Ender 3 V2 #1', 
    device_model = 'Creality Ender 3 V2',
    notes = 'Popular budget-friendly printer with upgraded features'
WHERE device_id = 'DEMO_Ender3Pro_2';

-- Device 3
UPDATE devices 
SET friendly_name = 'Anycubic Kobra 2 #1', 
    device_model = 'Anycubic Kobra 2',
    notes = 'High-speed FDM printer with auto-leveling'
WHERE device_id = 'DEMO_PrusaMK4_1';

-- Device 4
UPDATE devices 
SET friendly_name = 'Bambu Lab P1S #1', 
    device_model = 'Bambu Lab P1S',
    notes = 'Fast CoreXY printer with enclosed chamber'
WHERE device_id = 'DEMO_PrusaMK4_2';

-- Device 5
UPDATE devices 
SET friendly_name = 'Artillery Sidewinder X2 #1', 
    device_model = 'Artillery Sidewinder X2',
    notes = 'Large format printer with direct drive extruder'
WHERE device_id = 'DEMO_PrusaMK4_3';

-- Device 6
UPDATE devices 
SET friendly_name = 'FLSUN QQ-S Pro #1', 
    device_model = 'FLSUN QQ-S Pro',
    notes = 'Delta printer with high-speed capabilities'
WHERE device_id = 'DEMO_PrusaMK4_4';

-- Device 7
UPDATE devices 
SET friendly_name = 'Elegoo Neptune 3 Pro #1', 
    device_model = 'Elegoo Neptune 3 Pro',
    notes = 'Feature-rich printer with auto bed leveling'
WHERE device_id = 'DEMO_PrusaMini_1';

-- Device 8
UPDATE devices 
SET friendly_name = 'Kingroon KP3S Pro #1', 
    device_model = 'Kingroon KP3S Pro',
    notes = 'Compact printer with direct drive system'
WHERE device_id = 'DEMO_PrusaMini_2';

-- Device 9
UPDATE devices 
SET friendly_name = 'Sovol SV06 Plus #1', 
    device_model = 'Sovol SV06 Plus',
    notes = 'Large build volume with linear rail design'
WHERE device_id = 'DEMO_PrusaMini_3';

-- Device 10
UPDATE devices 
SET friendly_name = 'Creality CR-10 Smart Pro #1', 
    device_model = 'Creality CR-10 Smart Pro',
    notes = 'Large format printer with smart features'
WHERE device_id = 'DEMO_PrusaMini_4';

-- Device 11
UPDATE devices 
SET friendly_name = 'Prusa XL #1', 
    device_model = 'Prusa XL',
    notes = 'Large format printer with CoreXY motion'
WHERE device_id = 'DEMO_PrusaXL_1';

-- Device 12
UPDATE devices 
SET friendly_name = 'Bambu Lab X1 Carbon #1', 
    device_model = 'Bambu Lab X1 Carbon',
    notes = 'Premium high-speed multi-material printer'
WHERE device_id = 'DEMO_PrusaXL_2';

-- Device 13
UPDATE devices 
SET friendly_name = 'Anycubic Vyper #1', 
    device_model = 'Anycubic Vyper',
    notes = 'Auto-leveling FDM printer with strain gauge'
WHERE device_id = 'DEMO_Ultimaker2Plus_1';

-- Device 14
UPDATE devices 
SET friendly_name = 'Creality Ender 5 S1 #1', 
    device_model = 'Creality Ender 5 S1',
    notes = 'Cube-frame design with direct drive'
WHERE device_id = 'DEMO_Ultimaker2Plus_2';

-- Device 15
UPDATE devices 
SET friendly_name = 'Voron 2.4 #1', 
    device_model = 'Voron 2.4',
    notes = 'Open-source CoreXY printer with enclosed chamber'
WHERE device_id = 'DEMO_Voron24_1';

-- Device 16
UPDATE devices 
SET friendly_name = 'Voron Trident #1', 
    device_model = 'Voron Trident',
    notes = 'Three-Z motor CoreXY printer design'
WHERE device_id = 'DEMO_Voron24_2';

-- =============================================================================
-- OTHER DEVICES (17 total)
-- =============================================================================

-- Device 17
UPDATE devices 
SET friendly_name = 'Artillery Genius Pro #1', 
    device_model = 'Artillery Genius Pro',
    notes = 'Compact printer with direct drive and auto-leveling'
WHERE device_id = 'Ender-3-Pro-1';

-- Device 18
UPDATE devices 
SET friendly_name = 'Prusa MK4 #1', 
    device_model = 'Prusa MK4',
    notes = 'Latest Prusa printer with input shaping'
WHERE device_id = 'PrusaMK4-1';

-- Device 19
UPDATE devices 
SET friendly_name = 'Prusa MK4 #2', 
    device_model = 'Prusa MK4',
    notes = 'Latest Prusa printer with input shaping'
WHERE device_id = 'PrusaMK4-2';

-- Device 20
UPDATE devices 
SET friendly_name = 'Prusa MK4 #3', 
    device_model = 'Prusa MK4',
    notes = 'Latest Prusa printer with input shaping'
WHERE device_id = 'PrusaMK4-3';

-- Device 21
UPDATE devices 
SET friendly_name = 'Prusa Mini+ #1', 
    device_model = 'Prusa Mini+',
    notes = 'Compact Prusa printer with reliable performance'
WHERE device_id = 'PrusaMini-1';

-- Device 22
UPDATE devices 
SET friendly_name = 'Prusa Mini+ #2', 
    device_model = 'Prusa Mini+',
    notes = 'Compact Prusa printer with reliable performance'
WHERE device_id = 'PrusaMini-2';

-- Device 23
UPDATE devices 
SET friendly_name = 'Prusa XL #2', 
    device_model = 'Prusa XL',
    notes = 'Large format printer with multi-tool system'
WHERE device_id = 'PrusaXL-1';

-- Device 24 (environment sensor - keep as is)
UPDATE devices 
SET friendly_name = 'Environmental Sensor Array', 
    device_model = 'Multi-Sensor Hub',
    notes = 'Temperature, humidity, and ambient monitoring'
WHERE device_id = 'environment';

-- Device 25
UPDATE devices 
SET friendly_name = 'Bambu Lab P1P #1', 
    device_model = 'Bambu Lab P1P',
    notes = 'Fast CoreXY printer without enclosure'
WHERE device_id = 'prusa_i3_mk2';

-- Device 26
UPDATE devices 
SET friendly_name = 'Elegoo Neptune 4 Pro #1', 
    device_model = 'Elegoo Neptune 4 Pro',
    notes = 'High-speed Klipper-based printer'
WHERE device_id = 'prusa_i3_mk2_gelb_virtuell';

-- Device 27
UPDATE devices 
SET friendly_name = 'Anycubic Kobra Max #1', 
    device_model = 'Anycubic Kobra Max',
    notes = 'Large format auto-leveling printer'
WHERE device_id = 'prusa_i3_mk2_virtuell_schreibtisch';

-- Device 28
UPDATE devices 
SET friendly_name = 'Creality K1 Max #1', 
    device_model = 'Creality K1 Max',
    notes = 'High-speed enclosed CoreXY printer'
WHERE device_id = 'prusa_i3_mk2s_gelb_im_fab_lab';

-- Device 29
UPDATE devices 
SET friendly_name = 'Artillery Sidewinder X4 Plus #1', 
    device_model = 'Artillery Sidewinder X4 Plus',
    notes = 'Large format high-speed printer'
WHERE device_id = 'ultimaker2plus';

-- Device 30
UPDATE devices 
SET friendly_name = 'Sovol SV07 #1', 
    device_model = 'Sovol SV07',
    notes = 'High-speed Klipper printer with linear rails'
WHERE device_id = 'ultimaker_2_abholzung';

-- Device 31
UPDATE devices 
SET friendly_name = 'Qidi X-Max 3 #1', 
    device_model = 'Qidi X-Max 3',
    notes = 'Industrial-grade enclosed printer'
WHERE device_id = 'ultimaker_2_fabulous_an_artenvielfalt';

-- Device 32
UPDATE devices 
SET friendly_name = 'Flashforge Adventurer 5M #1', 
    device_model = 'Flashforge Adventurer 5M',
    notes = 'Fully enclosed consumer printer'
WHERE device_id = 'ultimaker_2_solex';

-- Device 33
UPDATE devices 
SET friendly_name = 'Voron Switchwire #1', 
    device_model = 'Voron Switchwire',
    notes = 'Converted Ender 3 to CoreXZ design'
WHERE device_id = 'voron_24_elektrobuero';

COMMIT;

-- Verify all updates
SELECT 'UPDATED DEVICES (Total: 33)' as status;
SELECT device_id, friendly_name, device_model, location FROM devices ORDER BY location, friendly_name;
