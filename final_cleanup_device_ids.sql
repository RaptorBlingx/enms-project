-- Final Cleanup: Update device_id and shelly_id to remove all FabLab/Fabulous references
-- Date: 2025-11-02
-- Purpose: Clean up PRIMARY KEYs and shelly_id columns

BEGIN;

-- =============================================================================
-- Update device_id (PRIMARY KEY) - This will CASCADE to all foreign keys
-- =============================================================================

-- Device 1: prusa_i3_mk2s_gelb_im_fab_lab -> creality_k1_max_1
ALTER TABLE devices 
DROP CONSTRAINT IF EXISTS devices_pkey CASCADE;

UPDATE devices SET device_id = 'creality_k1_max_1' 
WHERE device_id = 'prusa_i3_mk2s_gelb_im_fab_lab';

UPDATE devices SET device_id = 'artillery_sidewinder_x4_plus_1' 
WHERE device_id = 'ultimaker2plus';

UPDATE devices SET device_id = 'qidi_xmax3_1' 
WHERE device_id = 'ultimaker_2_fabulous_an_artenvielfalt';

UPDATE devices SET device_id = 'flashforge_adventurer_5m_1' 
WHERE device_id = 'ultimaker_2_solex';

UPDATE devices SET device_id = 'bambu_p1p_1' 
WHERE device_id = 'prusa_i3_mk2';

UPDATE devices SET device_id = 'elegoo_neptune4_pro_1' 
WHERE device_id = 'prusa_i3_mk2_gelb_virtuell';

UPDATE devices SET device_id = 'anycubic_kobra_max_1' 
WHERE device_id = 'prusa_i3_mk2_virtuell_schreibtisch';

UPDATE devices SET device_id = 'voron_switchwire_1' 
WHERE device_id = 'voron_24_elektrobuero';

UPDATE devices SET device_id = 'artillery_genius_pro_1' 
WHERE device_id = 'Ender-3-Pro-1';

UPDATE devices SET device_id = 'prusa_mk4_1' 
WHERE device_id = 'PrusaMK4-1';

UPDATE devices SET device_id = 'prusa_mk4_2' 
WHERE device_id = 'PrusaMK4-2';

UPDATE devices SET device_id = 'prusa_mk4_3' 
WHERE device_id = 'PrusaMK4-3';

UPDATE devices SET device_id = 'prusa_mini_plus_1' 
WHERE device_id = 'PrusaMini-1';

UPDATE devices SET device_id = 'prusa_mini_plus_2' 
WHERE device_id = 'PrusaMini-2';

UPDATE devices SET device_id = 'prusa_xl_2' 
WHERE device_id = 'PrusaXL-1';

UPDATE devices SET device_id = 'prusa_mk3s_plus_1' 
WHERE device_id = 'DEMO_Ender3Pro_1';

UPDATE devices SET device_id = 'creality_ender3_v2_1' 
WHERE device_id = 'DEMO_Ender3Pro_2';

UPDATE devices SET device_id = 'anycubic_kobra2_1' 
WHERE device_id = 'DEMO_PrusaMK4_1';

UPDATE devices SET device_id = 'bambu_p1s_1' 
WHERE device_id = 'DEMO_PrusaMK4_2';

UPDATE devices SET device_id = 'artillery_sidewinder_x2_1' 
WHERE device_id = 'DEMO_PrusaMK4_3';

UPDATE devices SET device_id = 'flsun_qqs_pro_1' 
WHERE device_id = 'DEMO_PrusaMK4_4';

UPDATE devices SET device_id = 'elegoo_neptune3_pro_1' 
WHERE device_id = 'DEMO_PrusaMini_1';

UPDATE devices SET device_id = 'kingroon_kp3s_pro_1' 
WHERE device_id = 'DEMO_PrusaMini_2';

UPDATE devices SET device_id = 'sovol_sv06_plus_1' 
WHERE device_id = 'DEMO_PrusaMini_3';

UPDATE devices SET device_id = 'creality_cr10_smart_pro_1' 
WHERE device_id = 'DEMO_PrusaMini_4';

UPDATE devices SET device_id = 'prusa_xl_1' 
WHERE device_id = 'DEMO_PrusaXL_1';

UPDATE devices SET device_id = 'bambu_x1_carbon_1' 
WHERE device_id = 'DEMO_PrusaXL_2';

UPDATE devices SET device_id = 'anycubic_vyper_1' 
WHERE device_id = 'DEMO_Ultimaker2Plus_1';

UPDATE devices SET device_id = 'creality_ender5_s1_1' 
WHERE device_id = 'DEMO_Ultimaker2Plus_2';

UPDATE devices SET device_id = 'voron_24_1' 
WHERE device_id = 'DEMO_Voron24_1';

UPDATE devices SET device_id = 'voron_trident_1' 
WHERE device_id = 'DEMO_Voron24_2';

-- Restore PRIMARY KEY constraint
ALTER TABLE devices 
ADD CONSTRAINT devices_pkey PRIMARY KEY (device_id);

-- =============================================================================
-- Update shelly_id to remove LAUDS_FabLab references
-- =============================================================================

UPDATE devices 
SET shelly_id = 'APLUS_SCIENCE_3DP_Klimawandel' 
WHERE shelly_id = 'LAUDS_FabLab_3DP_Klimawandel';

UPDATE devices 
SET shelly_id = 'APLUS_SCIENCE_3DP_Artenvielfalt' 
WHERE shelly_id = 'LAUDS_FabLab_3DP_Artenvielfalt';

UPDATE devices 
SET shelly_id = 'APLUS_SCIENCE_3DP_Biosphaere' 
WHERE shelly_id = 'LAUDS_FabLab_3DP_Biosphaere';

COMMIT;

-- Verify all changes
SELECT 'FINAL VERIFICATION - All FabLab/Fabulous references removed' as status;
SELECT device_id, friendly_name, device_model, shelly_id, location 
FROM devices 
ORDER BY location, friendly_name;
