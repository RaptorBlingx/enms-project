-- Migration: Update print_jobs table with new device IDs
-- Date: 2025-11-03
-- Purpose: Update foreign key references in print_jobs to use new device names

BEGIN;

-- Update print_jobs device_id references
UPDATE print_jobs SET device_id = 'prusa_mk3s_plus_1' WHERE device_id = 'DEMO_Ender3Pro_1';
UPDATE print_jobs SET device_id = 'creality_ender3_v2_1' WHERE device_id = 'DEMO_Ender3Pro_2';
UPDATE print_jobs SET device_id = 'anycubic_kobra2_1' WHERE device_id = 'DEMO_PrusaMK4_1';
UPDATE print_jobs SET device_id = 'bambu_p1s_1' WHERE device_id = 'DEMO_PrusaMK4_2';
UPDATE print_jobs SET device_id = 'artillery_sidewinder_x2_1' WHERE device_id = 'DEMO_PrusaMK4_3';
UPDATE print_jobs SET device_id = 'flsun_qqs_pro_1' WHERE device_id = 'DEMO_PrusaMK4_4';
UPDATE print_jobs SET device_id = 'elegoo_neptune3_pro_1' WHERE device_id = 'DEMO_PrusaMini_1';
UPDATE print_jobs SET device_id = 'kingroon_kp3s_pro_1' WHERE device_id = 'DEMO_PrusaMini_2';
UPDATE print_jobs SET device_id = 'sovol_sv06_plus_1' WHERE device_id = 'DEMO_PrusaMini_3';
UPDATE print_jobs SET device_id = 'creality_cr10_smart_pro_1' WHERE device_id = 'DEMO_PrusaMini_4';
UPDATE print_jobs SET device_id = 'prusa_xl_1' WHERE device_id = 'DEMO_PrusaXL_1';
UPDATE print_jobs SET device_id = 'bambu_x1_carbon_1' WHERE device_id = 'DEMO_PrusaXL_2';
UPDATE print_jobs SET device_id = 'anycubic_vyper_1' WHERE device_id = 'DEMO_Ultimaker2Plus_1';
UPDATE print_jobs SET device_id = 'creality_ender5_s1_1' WHERE device_id = 'DEMO_Ultimaker2Plus_2';
UPDATE print_jobs SET device_id = 'voron_24_1' WHERE device_id = 'DEMO_Voron24_1';
UPDATE print_jobs SET device_id = 'voron_trident_1' WHERE device_id = 'DEMO_Voron24_2';

COMMIT;

-- Verify the updates
SELECT 'Updated print_jobs table' as status;
SELECT device_id, COUNT(*) as job_count FROM print_jobs GROUP BY device_id ORDER BY job_count DESC LIMIT 20;
