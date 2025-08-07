-- ====================================================================
-- Clean and Correct Schema for ENMS Project Initialization
-- ====================================================================

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Part 1: Create the TimescaleDB Extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Part 2: Create All Standard (Non-Hypertable) Tables
CREATE TABLE public.devices (
    device_id text NOT NULL,
    device_model text NOT NULL,
    shelly_id text,
    api_ip text,
    api_key text,
    friendly_name text,
    location text,
    notes text,
    printer_size_category text,
    simplyprint_id text,
    last_seen timestamp with time zone,
    sp_company_id character varying(255),
    sp_api_key character varying(255),
    gcode_preview_host text,
    gcode_preview_api_key text,
    bed_width integer,
    bed_depth integer
);

CREATE TABLE public.print_jobs (
    job_id integer NOT NULL,
    device_id text NOT NULL,
    simplyprint_job_id text NOT NULL,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    duration_seconds integer,
    status text,
    filename text,
    filament_used_g numeric(10,2),
    kwh_consumed numeric(10,4),
    gcode_analysis_data jsonb,
    start_energy_wh numeric(10,3),
    session_energy_wh numeric,
    thumbnail_url text,
    per_part_analysis jsonb,
    part_metadata jsonb,
    nozzle_diameter real,
    filament_diameter real
);

CREATE SEQUENCE public.print_jobs_job_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.print_jobs_job_id_seq OWNED BY public.print_jobs.job_id;
ALTER TABLE ONLY public.print_jobs ALTER COLUMN job_id SET DEFAULT nextval('public.print_jobs_job_id_seq'::regclass);

-- Part 3: Create Tables That Will Become Hypertables
CREATE TABLE public.energy_data (
    "timestamp" timestamp with time zone NOT NULL,
    device_id text NOT NULL,
    power_watts double precision,
    energy_total_wh double precision,
    voltage double precision,
    current_amps double precision,
    plug_temp_c double precision,
    energy_today_kwh numeric(10,3)
);

CREATE TABLE public.printer_status (
    "timestamp" timestamp with time zone NOT NULL,
    device_id text NOT NULL,
    state_text text,
    is_operational boolean,
    is_printing boolean,
    is_paused boolean,
    is_error boolean,
    is_busy boolean,
    is_sd_ready boolean,
    nozzle_temp_actual double precision,
    nozzle_temp_target double precision,
    bed_temp_actual double precision,
    bed_temp_target double precision,
    z_height_mm double precision,
    speed_multiplier_percent double precision,
    material text,
    filename text,
    progress_percent real,
    time_left_seconds integer,
    ambient_temp_c real
);

CREATE TABLE public.environment_data (
    "timestamp" timestamp with time zone NOT NULL,
    device_id text NOT NULL,
    location_id text,
    temperature_c double precision,
    humidity_pct double precision,
    pressure_hpa double precision,
    weather_condition text,
    source text
);

CREATE TABLE public.ml_predictions (
    "timestamp" timestamp with time zone NOT NULL,
    device_id text NOT NULL,
    predicted_power_watts double precision,
    model_version text DEFAULT 'linear_regression_v1'::text
);

-- Part 4: Add All Constraints and Foreign Keys
ALTER TABLE ONLY public.devices ADD CONSTRAINT devices_pkey PRIMARY KEY (device_id);
ALTER TABLE ONLY public.devices ADD CONSTRAINT devices_shelly_id_key UNIQUE (shelly_id);
ALTER TABLE ONLY public.print_jobs ADD CONSTRAINT print_jobs_pkey PRIMARY KEY (job_id);
ALTER TABLE ONLY public.print_jobs ADD CONSTRAINT print_jobs_simplyprint_job_id_key UNIQUE (simplyprint_job_id);

ALTER TABLE ONLY public.energy_data ADD CONSTRAINT energy_data_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.printer_status ADD CONSTRAINT printer_status_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.environment_data ADD CONSTRAINT environment_data_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.print_jobs ADD CONSTRAINT print_jobs_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id);
