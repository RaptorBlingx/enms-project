--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

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

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: energy_data; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE energy_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.energy_data IS 'Time-series energy readings from smart plugs';


--
-- Name: COLUMN energy_data.energy_total_wh; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.energy_data.energy_total_wh IS 'Cumulative energy consumption in Watt-hours reported by Shelly';


--
-- Name: _direct_view_5; Type: VIEW; Schema: _timescaledb_internal; Owner: -
--

CREATE VIEW _timescaledb_internal._direct_view_5 AS
 SELECT device_id,
    public.time_bucket('01:00:00'::interval, "timestamp") AS bucket,
    avg(power_watts) AS avg_power,
    min(power_watts) AS min_power,
    max(power_watts) AS max_power
   FROM public.energy_data
  GROUP BY device_id, (public.time_bucket('01:00:00'::interval, "timestamp"));


--
-- Name: _direct_view_6; Type: VIEW; Schema: _timescaledb_internal; Owner: -
--

CREATE VIEW _timescaledb_internal._direct_view_6 AS
 SELECT device_id,
    public.time_bucket('1 day'::interval, "timestamp") AS bucket,
    avg(power_watts) AS avg_power_daily,
    min(power_watts) AS min_power_daily,
    max(power_watts) AS max_power_daily
   FROM public.energy_data
  GROUP BY device_id, (public.time_bucket('1 day'::interval, "timestamp"));


--
-- Name: _hyper_1_12_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_12_chunk (
    CONSTRAINT constraint_12 CHECK ((("timestamp" >= '2025-04-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_154_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_154_chunk (
    CONSTRAINT constraint_154 CHECK ((("timestamp" >= '2025-06-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_156_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_156_chunk (
    CONSTRAINT constraint_156 CHECK ((("timestamp" >= '2025-06-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_158_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_158_chunk (
    CONSTRAINT constraint_158 CHECK ((("timestamp" >= '2025-06-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_15_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_15_chunk (
    CONSTRAINT constraint_15 CHECK ((("timestamp" >= '2025-04-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_161_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_161_chunk (
    CONSTRAINT constraint_161 CHECK ((("timestamp" >= '2025-06-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_164_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_164_chunk (
    CONSTRAINT constraint_164 CHECK ((("timestamp" >= '2025-06-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_167_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_167_chunk (
    CONSTRAINT constraint_167 CHECK ((("timestamp" >= '2025-06-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_171_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_171_chunk (
    CONSTRAINT constraint_171 CHECK ((("timestamp" >= '2025-06-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_175_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_175_chunk (
    CONSTRAINT constraint_175 CHECK ((("timestamp" >= '2025-06-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_178_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_178_chunk (
    CONSTRAINT constraint_178 CHECK ((("timestamp" >= '2025-06-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_181_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_181_chunk (
    CONSTRAINT constraint_181 CHECK ((("timestamp" >= '2025-06-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_184_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_184_chunk (
    CONSTRAINT constraint_184 CHECK ((("timestamp" >= '2025-06-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_187_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_187_chunk (
    CONSTRAINT constraint_187 CHECK ((("timestamp" >= '2025-06-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_18_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_18_chunk (
    CONSTRAINT constraint_18 CHECK ((("timestamp" >= '2025-04-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_190_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_190_chunk (
    CONSTRAINT constraint_190 CHECK ((("timestamp" >= '2025-06-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_194_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_194_chunk (
    CONSTRAINT constraint_194 CHECK ((("timestamp" >= '2025-06-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_196_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_196_chunk (
    CONSTRAINT constraint_196 CHECK ((("timestamp" >= '2025-06-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_199_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_199_chunk (
    CONSTRAINT constraint_199 CHECK ((("timestamp" >= '2025-06-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1_chunk (
    CONSTRAINT constraint_1 CHECK ((("timestamp" >= '2025-04-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_202_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_202_chunk (
    CONSTRAINT constraint_202 CHECK ((("timestamp" >= '2025-06-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_204_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_204_chunk (
    CONSTRAINT constraint_204 CHECK ((("timestamp" >= '2025-06-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_206_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_206_chunk (
    CONSTRAINT constraint_206 CHECK ((("timestamp" >= '2025-06-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_208_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_208_chunk (
    CONSTRAINT constraint_208 CHECK ((("timestamp" >= '2025-06-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_210_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_210_chunk (
    CONSTRAINT constraint_210 CHECK ((("timestamp" >= '2025-06-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_212_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_212_chunk (
    CONSTRAINT constraint_212 CHECK ((("timestamp" >= '2025-06-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_214_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_214_chunk (
    CONSTRAINT constraint_214 CHECK ((("timestamp" >= '2025-06-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_219_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_219_chunk (
    CONSTRAINT constraint_219 CHECK ((("timestamp" >= '2025-06-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_21_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_21_chunk (
    CONSTRAINT constraint_21 CHECK ((("timestamp" >= '2025-04-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_221_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_221_chunk (
    CONSTRAINT constraint_221 CHECK ((("timestamp" >= '2025-07-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_223_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_223_chunk (
    CONSTRAINT constraint_223 CHECK ((("timestamp" >= '2025-07-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_225_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_225_chunk (
    CONSTRAINT constraint_225 CHECK ((("timestamp" >= '2025-07-03 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-04 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_227_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_227_chunk (
    CONSTRAINT constraint_227 CHECK ((("timestamp" >= '2025-07-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_229_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_229_chunk (
    CONSTRAINT constraint_229 CHECK ((("timestamp" >= '2025-07-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_230_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_230_chunk (
    CONSTRAINT constraint_230 CHECK ((("timestamp" >= '2025-07-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_233_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_233_chunk (
    CONSTRAINT constraint_233 CHECK ((("timestamp" >= '2025-07-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_234_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_234_chunk (
    CONSTRAINT constraint_234 CHECK ((("timestamp" >= '2025-07-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_237_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_237_chunk (
    CONSTRAINT constraint_237 CHECK ((("timestamp" >= '2025-07-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_239_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_239_chunk (
    CONSTRAINT constraint_239 CHECK ((("timestamp" >= '2025-07-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_242_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_242_chunk (
    CONSTRAINT constraint_242 CHECK ((("timestamp" >= '2025-07-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_244_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_244_chunk (
    CONSTRAINT constraint_244 CHECK ((("timestamp" >= '2025-07-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_245_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_245_chunk (
    CONSTRAINT constraint_245 CHECK ((("timestamp" >= '2025-07-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_249_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_249_chunk (
    CONSTRAINT constraint_249 CHECK ((("timestamp" >= '2025-07-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_24_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_24_chunk (
    CONSTRAINT constraint_24 CHECK ((("timestamp" >= '2025-04-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_252_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_252_chunk (
    CONSTRAINT constraint_252 CHECK ((("timestamp" >= '2025-07-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_253_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_253_chunk (
    CONSTRAINT constraint_253 CHECK ((("timestamp" >= '2025-07-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_255_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_255_chunk (
    CONSTRAINT constraint_255 CHECK ((("timestamp" >= '2025-07-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_258_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_258_chunk (
    CONSTRAINT constraint_258 CHECK ((("timestamp" >= '2025-07-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_259_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_259_chunk (
    CONSTRAINT constraint_259 CHECK ((("timestamp" >= '2025-07-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_261_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_261_chunk (
    CONSTRAINT constraint_261 CHECK ((("timestamp" >= '2025-07-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_263_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_263_chunk (
    CONSTRAINT constraint_263 CHECK ((("timestamp" >= '2025-07-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_265_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_265_chunk (
    CONSTRAINT constraint_265 CHECK ((("timestamp" >= '2025-07-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_267_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_267_chunk (
    CONSTRAINT constraint_267 CHECK ((("timestamp" >= '2025-07-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_287_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_287_chunk (
    CONSTRAINT constraint_287 CHECK ((("timestamp" >= '2025-07-31 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_290_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_290_chunk (
    CONSTRAINT constraint_290 CHECK ((("timestamp" >= '2025-08-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_292_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_292_chunk (
    CONSTRAINT constraint_292 CHECK ((("timestamp" >= '2025-08-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_294_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_294_chunk (
    CONSTRAINT constraint_294 CHECK ((("timestamp" >= '2025-08-03 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-04 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_295_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_295_chunk (
    CONSTRAINT constraint_295 CHECK ((("timestamp" >= '2025-08-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_297_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_297_chunk (
    CONSTRAINT constraint_297 CHECK ((("timestamp" >= '2025-08-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_299_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_299_chunk (
    CONSTRAINT constraint_299 CHECK ((("timestamp" >= '2025-08-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_301_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_301_chunk (
    CONSTRAINT constraint_301 CHECK ((("timestamp" >= '2025-08-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_30_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_30_chunk (
    CONSTRAINT constraint_30 CHECK ((("timestamp" >= '2025-04-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_34_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_34_chunk (
    CONSTRAINT constraint_34 CHECK ((("timestamp" >= '2025-04-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_37_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_37_chunk (
    CONSTRAINT constraint_37 CHECK ((("timestamp" >= '2025-04-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_39_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_39_chunk (
    CONSTRAINT constraint_39 CHECK ((("timestamp" >= '2025-04-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_43_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_43_chunk (
    CONSTRAINT constraint_43 CHECK ((("timestamp" >= '2025-04-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_4_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_4_chunk (
    CONSTRAINT constraint_4 CHECK ((("timestamp" >= '2025-04-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_50_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_50_chunk (
    CONSTRAINT constraint_50 CHECK ((("timestamp" >= '2025-04-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_53_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_53_chunk (
    CONSTRAINT constraint_53 CHECK ((("timestamp" >= '2025-04-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_58_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_58_chunk (
    CONSTRAINT constraint_58 CHECK ((("timestamp" >= '2025-04-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_62_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_62_chunk (
    CONSTRAINT constraint_62 CHECK ((("timestamp" >= '2025-05-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_66_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_66_chunk (
    CONSTRAINT constraint_66 CHECK ((("timestamp" >= '2025-05-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: _hyper_1_6_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_6_chunk (
    CONSTRAINT constraint_6 CHECK ((("timestamp" >= '2025-04-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.energy_data);


--
-- Name: printer_status; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE printer_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.printer_status IS 'Time-series status and telemetry data polled from printer APIs';


--
-- Name: COLUMN printer_status.state_text; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.printer_status.state_text IS 'Printer state description from API (e.g., Operational, Printing)';


--
-- Name: _hyper_2_100_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_100_chunk (
    CONSTRAINT constraint_100 CHECK ((("timestamp" >= '2025-05-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_103_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_103_chunk (
    CONSTRAINT constraint_103 CHECK ((("timestamp" >= '2025-05-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_107_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_107_chunk (
    CONSTRAINT constraint_107 CHECK ((("timestamp" >= '2025-05-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_110_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_110_chunk (
    CONSTRAINT constraint_110 CHECK ((("timestamp" >= '2025-05-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_113_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_113_chunk (
    CONSTRAINT constraint_113 CHECK ((("timestamp" >= '2025-05-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_116_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_116_chunk (
    CONSTRAINT constraint_116 CHECK ((("timestamp" >= '2025-05-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_119_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_119_chunk (
    CONSTRAINT constraint_119 CHECK ((("timestamp" >= '2025-05-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_11_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_11_chunk (
    CONSTRAINT constraint_11 CHECK ((("timestamp" >= '2025-04-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_122_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_122_chunk (
    CONSTRAINT constraint_122 CHECK ((("timestamp" >= '2025-05-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_124_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_124_chunk (
    CONSTRAINT constraint_124 CHECK ((("timestamp" >= '2025-05-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_126_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_126_chunk (
    CONSTRAINT constraint_126 CHECK ((("timestamp" >= '2025-05-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_128_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_128_chunk (
    CONSTRAINT constraint_128 CHECK ((("timestamp" >= '2025-05-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_130_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_130_chunk (
    CONSTRAINT constraint_130 CHECK ((("timestamp" >= '2025-05-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_132_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_132_chunk (
    CONSTRAINT constraint_132 CHECK ((("timestamp" >= '2025-05-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_134_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_134_chunk (
    CONSTRAINT constraint_134 CHECK ((("timestamp" >= '2025-05-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_136_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_136_chunk (
    CONSTRAINT constraint_136 CHECK ((("timestamp" >= '2025-05-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_139_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_139_chunk (
    CONSTRAINT constraint_139 CHECK ((("timestamp" >= '2025-05-31 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_141_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_141_chunk (
    CONSTRAINT constraint_141 CHECK ((("timestamp" >= '2025-06-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_143_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_143_chunk (
    CONSTRAINT constraint_143 CHECK ((("timestamp" >= '2025-06-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_147_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_147_chunk (
    CONSTRAINT constraint_147 CHECK ((("timestamp" >= '2025-06-03 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-04 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_14_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_14_chunk (
    CONSTRAINT constraint_14 CHECK ((("timestamp" >= '2025-04-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_150_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_150_chunk (
    CONSTRAINT constraint_150 CHECK ((("timestamp" >= '2025-06-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_153_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_153_chunk (
    CONSTRAINT constraint_153 CHECK ((("timestamp" >= '2025-06-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_157_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_157_chunk (
    CONSTRAINT constraint_157 CHECK ((("timestamp" >= '2025-06-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_160_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_160_chunk (
    CONSTRAINT constraint_160 CHECK ((("timestamp" >= '2025-06-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_163_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_163_chunk (
    CONSTRAINT constraint_163 CHECK ((("timestamp" >= '2025-06-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_166_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_166_chunk (
    CONSTRAINT constraint_166 CHECK ((("timestamp" >= '2025-06-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_169_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_169_chunk (
    CONSTRAINT constraint_169 CHECK ((("timestamp" >= '2025-06-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_173_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_173_chunk (
    CONSTRAINT constraint_173 CHECK ((("timestamp" >= '2025-06-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_176_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_176_chunk (
    CONSTRAINT constraint_176 CHECK ((("timestamp" >= '2025-06-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_179_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_179_chunk (
    CONSTRAINT constraint_179 CHECK ((("timestamp" >= '2025-06-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_17_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_17_chunk (
    CONSTRAINT constraint_17 CHECK ((("timestamp" >= '2025-04-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_182_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_182_chunk (
    CONSTRAINT constraint_182 CHECK ((("timestamp" >= '2025-06-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_185_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_185_chunk (
    CONSTRAINT constraint_185 CHECK ((("timestamp" >= '2025-06-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_188_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_188_chunk (
    CONSTRAINT constraint_188 CHECK ((("timestamp" >= '2025-06-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_191_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_191_chunk (
    CONSTRAINT constraint_191 CHECK ((("timestamp" >= '2025-06-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_195_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_195_chunk (
    CONSTRAINT constraint_195 CHECK ((("timestamp" >= '2025-06-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_197_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_197_chunk (
    CONSTRAINT constraint_197 CHECK ((("timestamp" >= '2025-06-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_200_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_200_chunk (
    CONSTRAINT constraint_200 CHECK ((("timestamp" >= '2025-06-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_203_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_203_chunk (
    CONSTRAINT constraint_203 CHECK ((("timestamp" >= '2025-06-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_205_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_205_chunk (
    CONSTRAINT constraint_205 CHECK ((("timestamp" >= '2025-06-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_207_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_207_chunk (
    CONSTRAINT constraint_207 CHECK ((("timestamp" >= '2025-06-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_209_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_209_chunk (
    CONSTRAINT constraint_209 CHECK ((("timestamp" >= '2025-06-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_20_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_20_chunk (
    CONSTRAINT constraint_20 CHECK ((("timestamp" >= '2025-04-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_211_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_211_chunk (
    CONSTRAINT constraint_211 CHECK ((("timestamp" >= '2025-06-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_213_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_213_chunk (
    CONSTRAINT constraint_213 CHECK ((("timestamp" >= '2025-06-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_215_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_215_chunk (
    CONSTRAINT constraint_215 CHECK ((("timestamp" >= '2025-06-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_216_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_216_chunk (
    CONSTRAINT constraint_216 CHECK ((("timestamp" >= '2025-06-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_217_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_217_chunk (
    CONSTRAINT constraint_217 CHECK ((("timestamp" >= '2025-06-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_218_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_218_chunk (
    CONSTRAINT constraint_218 CHECK ((("timestamp" >= '2025-06-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_220_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_220_chunk (
    CONSTRAINT constraint_220 CHECK ((("timestamp" >= '2025-07-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_222_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_222_chunk (
    CONSTRAINT constraint_222 CHECK ((("timestamp" >= '2025-07-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_224_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_224_chunk (
    CONSTRAINT constraint_224 CHECK ((("timestamp" >= '2025-07-03 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-04 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_226_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_226_chunk (
    CONSTRAINT constraint_226 CHECK ((("timestamp" >= '2025-07-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_228_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_228_chunk (
    CONSTRAINT constraint_228 CHECK ((("timestamp" >= '2025-07-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_231_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_231_chunk (
    CONSTRAINT constraint_231 CHECK ((("timestamp" >= '2025-07-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_232_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_232_chunk (
    CONSTRAINT constraint_232 CHECK ((("timestamp" >= '2025-07-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_235_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_235_chunk (
    CONSTRAINT constraint_235 CHECK ((("timestamp" >= '2025-07-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_236_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_236_chunk (
    CONSTRAINT constraint_236 CHECK ((("timestamp" >= '2025-07-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_238_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_238_chunk (
    CONSTRAINT constraint_238 CHECK ((("timestamp" >= '2025-07-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_23_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_23_chunk (
    CONSTRAINT constraint_23 CHECK ((("timestamp" >= '2025-04-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_240_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_240_chunk (
    CONSTRAINT constraint_240 CHECK ((("timestamp" >= '2025-07-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_241_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_241_chunk (
    CONSTRAINT constraint_241 CHECK ((("timestamp" >= '2025-07-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_243_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_243_chunk (
    CONSTRAINT constraint_243 CHECK ((("timestamp" >= '2025-07-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_246_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_246_chunk (
    CONSTRAINT constraint_246 CHECK ((("timestamp" >= '2025-07-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_247_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_247_chunk (
    CONSTRAINT constraint_247 CHECK ((("timestamp" >= '2025-07-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_250_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_250_chunk (
    CONSTRAINT constraint_250 CHECK ((("timestamp" >= '2025-07-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_251_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_251_chunk (
    CONSTRAINT constraint_251 CHECK ((("timestamp" >= '2025-07-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_254_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_254_chunk (
    CONSTRAINT constraint_254 CHECK ((("timestamp" >= '2025-07-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_256_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_256_chunk (
    CONSTRAINT constraint_256 CHECK ((("timestamp" >= '2025-07-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_257_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_257_chunk (
    CONSTRAINT constraint_257 CHECK ((("timestamp" >= '2025-07-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_260_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_260_chunk (
    CONSTRAINT constraint_260 CHECK ((("timestamp" >= '2025-07-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_262_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_262_chunk (
    CONSTRAINT constraint_262 CHECK ((("timestamp" >= '2025-07-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_264_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_264_chunk (
    CONSTRAINT constraint_264 CHECK ((("timestamp" >= '2025-07-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_266_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_266_chunk (
    CONSTRAINT constraint_266 CHECK ((("timestamp" >= '2025-07-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_268_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_268_chunk (
    CONSTRAINT constraint_268 CHECK ((("timestamp" >= '2025-07-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_288_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_288_chunk (
    CONSTRAINT constraint_288 CHECK ((("timestamp" >= '2025-07-31 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_28_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_28_chunk (
    CONSTRAINT constraint_28 CHECK ((("timestamp" >= '2025-04-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_291_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_291_chunk (
    CONSTRAINT constraint_291 CHECK ((("timestamp" >= '2025-08-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_296_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_296_chunk (
    CONSTRAINT constraint_296 CHECK ((("timestamp" >= '2025-08-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_298_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_298_chunk (
    CONSTRAINT constraint_298 CHECK ((("timestamp" >= '2025-08-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_2_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_2_chunk (
    CONSTRAINT constraint_2 CHECK ((("timestamp" >= '2025-04-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_300_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_300_chunk (
    CONSTRAINT constraint_300 CHECK ((("timestamp" >= '2025-08-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_302_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_302_chunk (
    CONSTRAINT constraint_302 CHECK ((("timestamp" >= '2025-08-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-08-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_32_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_32_chunk (
    CONSTRAINT constraint_32 CHECK ((("timestamp" >= '2025-04-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_35_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_35_chunk (
    CONSTRAINT constraint_35 CHECK ((("timestamp" >= '2025-04-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_3_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_3_chunk (
    CONSTRAINT constraint_3 CHECK ((("timestamp" >= '2025-04-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_42_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_42_chunk (
    CONSTRAINT constraint_42 CHECK ((("timestamp" >= '2025-04-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_46_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_46_chunk (
    CONSTRAINT constraint_46 CHECK ((("timestamp" >= '2025-04-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_49_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_49_chunk (
    CONSTRAINT constraint_49 CHECK ((("timestamp" >= '2025-04-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_52_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_52_chunk (
    CONSTRAINT constraint_52 CHECK ((("timestamp" >= '2025-04-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_57_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_57_chunk (
    CONSTRAINT constraint_57 CHECK ((("timestamp" >= '2025-04-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_5_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_5_chunk (
    CONSTRAINT constraint_5 CHECK ((("timestamp" >= '2025-04-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_61_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_61_chunk (
    CONSTRAINT constraint_61 CHECK ((("timestamp" >= '2025-05-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_65_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_65_chunk (
    CONSTRAINT constraint_65 CHECK ((("timestamp" >= '2025-05-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_68_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_68_chunk (
    CONSTRAINT constraint_68 CHECK ((("timestamp" >= '2025-05-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_71_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_71_chunk (
    CONSTRAINT constraint_71 CHECK ((("timestamp" >= '2025-05-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_75_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_75_chunk (
    CONSTRAINT constraint_75 CHECK ((("timestamp" >= '2025-05-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_78_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_78_chunk (
    CONSTRAINT constraint_78 CHECK ((("timestamp" >= '2025-05-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_81_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_81_chunk (
    CONSTRAINT constraint_81 CHECK ((("timestamp" >= '2025-05-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_84_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_84_chunk (
    CONSTRAINT constraint_84 CHECK ((("timestamp" >= '2025-05-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_87_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_87_chunk (
    CONSTRAINT constraint_87 CHECK ((("timestamp" >= '2025-05-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_90_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_90_chunk (
    CONSTRAINT constraint_90 CHECK ((("timestamp" >= '2025-05-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_92_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_92_chunk (
    CONSTRAINT constraint_92 CHECK ((("timestamp" >= '2025-05-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_95_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_95_chunk (
    CONSTRAINT constraint_95 CHECK ((("timestamp" >= '2025-05-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: _hyper_2_97_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_97_chunk (
    CONSTRAINT constraint_97 CHECK ((("timestamp" >= '2025-05-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.printer_status);


--
-- Name: environment_data; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE environment_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.environment_data IS 'Time-series environmental readings (temperature, humidity)';


--
-- Name: COLUMN environment_data.location_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.environment_data.location_id IS 'Identifier for the location of the reading (e.g., FactoryFloor, Outside)';


--
-- Name: COLUMN environment_data.weather_condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.environment_data.weather_condition IS 'Text description of weather (e.g., Clouds, Rain)';


--
-- Name: COLUMN environment_data.source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.environment_data.source IS 'Origin of the environmental data (e.g., OpenWeatherMap)';


--
-- Name: _hyper_3_102_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_102_chunk (
    CONSTRAINT constraint_102 CHECK ((("timestamp" >= '2025-05-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_105_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_105_chunk (
    CONSTRAINT constraint_105 CHECK ((("timestamp" >= '2025-05-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_108_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_108_chunk (
    CONSTRAINT constraint_108 CHECK ((("timestamp" >= '2025-05-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_111_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_111_chunk (
    CONSTRAINT constraint_111 CHECK ((("timestamp" >= '2025-05-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_114_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_114_chunk (
    CONSTRAINT constraint_114 CHECK ((("timestamp" >= '2025-05-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_117_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_117_chunk (
    CONSTRAINT constraint_117 CHECK ((("timestamp" >= '2025-05-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_120_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_120_chunk (
    CONSTRAINT constraint_120 CHECK ((("timestamp" >= '2025-05-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_137_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_137_chunk (
    CONSTRAINT constraint_137 CHECK ((("timestamp" >= '2025-05-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_144_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_144_chunk (
    CONSTRAINT constraint_144 CHECK ((("timestamp" >= '2025-06-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_145_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_145_chunk (
    CONSTRAINT constraint_145 CHECK ((("timestamp" >= '2025-06-03 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-04 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_148_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_148_chunk (
    CONSTRAINT constraint_148 CHECK ((("timestamp" >= '2025-06-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_152_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_152_chunk (
    CONSTRAINT constraint_152 CHECK ((("timestamp" >= '2025-06-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_170_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_170_chunk (
    CONSTRAINT constraint_170 CHECK ((("timestamp" >= '2025-06-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_174_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_174_chunk (
    CONSTRAINT constraint_174 CHECK ((("timestamp" >= '2025-06-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_177_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_177_chunk (
    CONSTRAINT constraint_177 CHECK ((("timestamp" >= '2025-06-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_180_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_180_chunk (
    CONSTRAINT constraint_180 CHECK ((("timestamp" >= '2025-06-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_183_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_183_chunk (
    CONSTRAINT constraint_183 CHECK ((("timestamp" >= '2025-06-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_186_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_186_chunk (
    CONSTRAINT constraint_186 CHECK ((("timestamp" >= '2025-06-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_189_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_189_chunk (
    CONSTRAINT constraint_189 CHECK ((("timestamp" >= '2025-06-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_192_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_192_chunk (
    CONSTRAINT constraint_192 CHECK ((("timestamp" >= '2025-06-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_198_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_198_chunk (
    CONSTRAINT constraint_198 CHECK ((("timestamp" >= '2025-06-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_201_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_201_chunk (
    CONSTRAINT constraint_201 CHECK ((("timestamp" >= '2025-06-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_248_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_248_chunk (
    CONSTRAINT constraint_248 CHECK ((("timestamp" >= '2025-07-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-07-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_26_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_26_chunk (
    CONSTRAINT constraint_26 CHECK ((("timestamp" >= '2025-04-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_29_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_29_chunk (
    CONSTRAINT constraint_29 CHECK ((("timestamp" >= '2025-04-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_33_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_33_chunk (
    CONSTRAINT constraint_33 CHECK ((("timestamp" >= '2025-04-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_36_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_36_chunk (
    CONSTRAINT constraint_36 CHECK ((("timestamp" >= '2025-04-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_41_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_41_chunk (
    CONSTRAINT constraint_41 CHECK ((("timestamp" >= '2025-04-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_45_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_45_chunk (
    CONSTRAINT constraint_45 CHECK ((("timestamp" >= '2025-04-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_48_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_48_chunk (
    CONSTRAINT constraint_48 CHECK ((("timestamp" >= '2025-04-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_51_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_51_chunk (
    CONSTRAINT constraint_51 CHECK ((("timestamp" >= '2025-04-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_56_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_56_chunk (
    CONSTRAINT constraint_56 CHECK ((("timestamp" >= '2025-04-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_60_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_60_chunk (
    CONSTRAINT constraint_60 CHECK ((("timestamp" >= '2025-05-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_64_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_64_chunk (
    CONSTRAINT constraint_64 CHECK ((("timestamp" >= '2025-05-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_69_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_69_chunk (
    CONSTRAINT constraint_69 CHECK ((("timestamp" >= '2025-05-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_70_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_70_chunk (
    CONSTRAINT constraint_70 CHECK ((("timestamp" >= '2025-05-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_74_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_74_chunk (
    CONSTRAINT constraint_74 CHECK ((("timestamp" >= '2025-05-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_77_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_77_chunk (
    CONSTRAINT constraint_77 CHECK ((("timestamp" >= '2025-05-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_79_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_79_chunk (
    CONSTRAINT constraint_79 CHECK ((("timestamp" >= '2025-05-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_83_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_83_chunk (
    CONSTRAINT constraint_83 CHECK ((("timestamp" >= '2025-05-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_86_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_86_chunk (
    CONSTRAINT constraint_86 CHECK ((("timestamp" >= '2025-05-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_89_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_89_chunk (
    CONSTRAINT constraint_89 CHECK ((("timestamp" >= '2025-05-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_93_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_93_chunk (
    CONSTRAINT constraint_93 CHECK ((("timestamp" >= '2025-05-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_96_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_96_chunk (
    CONSTRAINT constraint_96 CHECK ((("timestamp" >= '2025-05-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: _hyper_3_99_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_99_chunk (
    CONSTRAINT constraint_99 CHECK ((("timestamp" >= '2025-05-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.environment_data);


--
-- Name: ml_predictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ml_predictions (
    "timestamp" timestamp with time zone NOT NULL,
    device_id text NOT NULL,
    predicted_power_watts double precision,
    model_version text DEFAULT 'linear_regression_v1'::text
);


--
-- Name: TABLE ml_predictions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ml_predictions IS 'Stores ML model predictions for power consumption';


--
-- Name: COLUMN ml_predictions."timestamp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ml_predictions."timestamp" IS 'Timestamp corresponding to the prediction';


--
-- Name: COLUMN ml_predictions.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ml_predictions.device_id IS 'Device the prediction is for';


--
-- Name: COLUMN ml_predictions.predicted_power_watts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ml_predictions.predicted_power_watts IS 'Power consumption predicted by the ML model';


--
-- Name: COLUMN ml_predictions.model_version; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ml_predictions.model_version IS 'Identifier for the model version used for prediction';


--
-- Name: _hyper_4_101_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_101_chunk (
    CONSTRAINT constraint_101 CHECK ((("timestamp" >= '2025-05-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_104_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_104_chunk (
    CONSTRAINT constraint_104 CHECK ((("timestamp" >= '2025-05-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_106_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_106_chunk (
    CONSTRAINT constraint_106 CHECK ((("timestamp" >= '2025-05-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_109_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_109_chunk (
    CONSTRAINT constraint_109 CHECK ((("timestamp" >= '2025-05-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_10_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_10_chunk (
    CONSTRAINT constraint_10 CHECK ((("timestamp" >= '2025-04-18 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-19 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_112_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_112_chunk (
    CONSTRAINT constraint_112 CHECK ((("timestamp" >= '2025-05-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_115_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_115_chunk (
    CONSTRAINT constraint_115 CHECK ((("timestamp" >= '2025-05-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_118_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_118_chunk (
    CONSTRAINT constraint_118 CHECK ((("timestamp" >= '2025-05-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_121_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_121_chunk (
    CONSTRAINT constraint_121 CHECK ((("timestamp" >= '2025-05-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_123_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_123_chunk (
    CONSTRAINT constraint_123 CHECK ((("timestamp" >= '2025-05-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_125_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_125_chunk (
    CONSTRAINT constraint_125 CHECK ((("timestamp" >= '2025-05-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_127_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_127_chunk (
    CONSTRAINT constraint_127 CHECK ((("timestamp" >= '2025-05-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_129_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_129_chunk (
    CONSTRAINT constraint_129 CHECK ((("timestamp" >= '2025-05-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_131_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_131_chunk (
    CONSTRAINT constraint_131 CHECK ((("timestamp" >= '2025-05-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_133_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_133_chunk (
    CONSTRAINT constraint_133 CHECK ((("timestamp" >= '2025-05-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_135_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_135_chunk (
    CONSTRAINT constraint_135 CHECK ((("timestamp" >= '2025-05-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_138_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_138_chunk (
    CONSTRAINT constraint_138 CHECK ((("timestamp" >= '2025-05-31 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_13_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_13_chunk (
    CONSTRAINT constraint_13 CHECK ((("timestamp" >= '2025-04-19 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-20 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_140_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_140_chunk (
    CONSTRAINT constraint_140 CHECK ((("timestamp" >= '2025-06-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_142_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_142_chunk (
    CONSTRAINT constraint_142 CHECK ((("timestamp" >= '2025-06-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_146_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_146_chunk (
    CONSTRAINT constraint_146 CHECK ((("timestamp" >= '2025-06-03 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-04 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_149_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_149_chunk (
    CONSTRAINT constraint_149 CHECK ((("timestamp" >= '2025-06-04 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-05 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_151_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_151_chunk (
    CONSTRAINT constraint_151 CHECK ((("timestamp" >= '2025-06-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_155_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_155_chunk (
    CONSTRAINT constraint_155 CHECK ((("timestamp" >= '2025-06-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_159_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_159_chunk (
    CONSTRAINT constraint_159 CHECK ((("timestamp" >= '2025-06-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_162_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_162_chunk (
    CONSTRAINT constraint_162 CHECK ((("timestamp" >= '2025-06-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_165_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_165_chunk (
    CONSTRAINT constraint_165 CHECK ((("timestamp" >= '2025-06-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_168_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_168_chunk (
    CONSTRAINT constraint_168 CHECK ((("timestamp" >= '2025-06-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_16_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_16_chunk (
    CONSTRAINT constraint_16 CHECK ((("timestamp" >= '2025-04-20 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_172_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_172_chunk (
    CONSTRAINT constraint_172 CHECK ((("timestamp" >= '2025-06-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_193_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_193_chunk (
    CONSTRAINT constraint_193 CHECK ((("timestamp" >= '2025-06-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-06-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_19_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_19_chunk (
    CONSTRAINT constraint_19 CHECK ((("timestamp" >= '2025-04-21 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_22_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_22_chunk (
    CONSTRAINT constraint_22 CHECK ((("timestamp" >= '2025-04-22 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-23 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_27_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_27_chunk (
    CONSTRAINT constraint_27 CHECK ((("timestamp" >= '2025-04-23 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-24 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_31_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_31_chunk (
    CONSTRAINT constraint_31 CHECK ((("timestamp" >= '2025-04-24 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-25 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_38_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_38_chunk (
    CONSTRAINT constraint_38 CHECK ((("timestamp" >= '2025-04-25 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-26 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_40_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_40_chunk (
    CONSTRAINT constraint_40 CHECK ((("timestamp" >= '2025-04-26 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-27 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_44_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_44_chunk (
    CONSTRAINT constraint_44 CHECK ((("timestamp" >= '2025-04-27 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-28 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_47_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_47_chunk (
    CONSTRAINT constraint_47 CHECK ((("timestamp" >= '2025-04-28 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-29 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_54_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_54_chunk (
    CONSTRAINT constraint_54 CHECK ((("timestamp" >= '2025-04-29 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-30 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_55_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_55_chunk (
    CONSTRAINT constraint_55 CHECK ((("timestamp" >= '2025-04-30 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_59_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_59_chunk (
    CONSTRAINT constraint_59 CHECK ((("timestamp" >= '2025-05-01 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_63_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_63_chunk (
    CONSTRAINT constraint_63 CHECK ((("timestamp" >= '2025-05-02 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-03 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_67_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_67_chunk (
    CONSTRAINT constraint_67 CHECK ((("timestamp" >= '2025-05-05 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-06 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_72_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_72_chunk (
    CONSTRAINT constraint_72 CHECK ((("timestamp" >= '2025-05-06 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-07 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_73_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_73_chunk (
    CONSTRAINT constraint_73 CHECK ((("timestamp" >= '2025-05-07 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-08 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_76_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_76_chunk (
    CONSTRAINT constraint_76 CHECK ((("timestamp" >= '2025-05-08 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-09 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_7_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_7_chunk (
    CONSTRAINT constraint_7 CHECK ((("timestamp" >= '2025-04-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_80_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_80_chunk (
    CONSTRAINT constraint_80 CHECK ((("timestamp" >= '2025-05-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_82_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_82_chunk (
    CONSTRAINT constraint_82 CHECK ((("timestamp" >= '2025-05-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_85_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_85_chunk (
    CONSTRAINT constraint_85 CHECK ((("timestamp" >= '2025-05-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_88_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_88_chunk (
    CONSTRAINT constraint_88 CHECK ((("timestamp" >= '2025-05-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_8_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_8_chunk (
    CONSTRAINT constraint_8 CHECK ((("timestamp" >= '2025-04-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_91_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_91_chunk (
    CONSTRAINT constraint_91 CHECK ((("timestamp" >= '2025-05-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_94_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_94_chunk (
    CONSTRAINT constraint_94 CHECK ((("timestamp" >= '2025-05-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_98_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_98_chunk (
    CONSTRAINT constraint_98 CHECK ((("timestamp" >= '2025-05-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-05-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _hyper_4_9_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_9_chunk (
    CONSTRAINT constraint_9 CHECK ((("timestamp" >= '2025-04-17 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2025-04-18 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.ml_predictions);


--
-- Name: _materialized_hypertable_5; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._materialized_hypertable_5 (
    device_id text,
    bucket timestamp with time zone NOT NULL,
    avg_power double precision,
    min_power double precision,
    max_power double precision
);


--
-- Name: _hyper_5_269_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_269_chunk (
    CONSTRAINT constraint_269 CHECK (((bucket >= '2025-06-21 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_270_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_270_chunk (
    CONSTRAINT constraint_270 CHECK (((bucket >= '2025-06-11 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-06-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_271_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_271_chunk (
    CONSTRAINT constraint_271 CHECK (((bucket >= '2025-04-22 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-05-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_272_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_272_chunk (
    CONSTRAINT constraint_272 CHECK (((bucket >= '2025-07-21 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_273_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_273_chunk (
    CONSTRAINT constraint_273 CHECK (((bucket >= '2025-06-01 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-06-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_274_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_274_chunk (
    CONSTRAINT constraint_274 CHECK (((bucket >= '2025-04-12 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-04-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_275_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_275_chunk (
    CONSTRAINT constraint_275 CHECK (((bucket >= '2025-07-11 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_276_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_276_chunk (
    CONSTRAINT constraint_276 CHECK (((bucket >= '2025-07-01 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_277_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_277_chunk (
    CONSTRAINT constraint_277 CHECK (((bucket >= '2025-05-02 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-05-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _hyper_5_289_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_5_289_chunk (
    CONSTRAINT constraint_289 CHECK (((bucket >= '2025-07-31 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-08-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_5);


--
-- Name: _materialized_hypertable_6; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._materialized_hypertable_6 (
    device_id text,
    bucket timestamp with time zone NOT NULL,
    avg_power_daily double precision,
    min_power_daily double precision,
    max_power_daily double precision
);


--
-- Name: _hyper_6_278_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_278_chunk (
    CONSTRAINT constraint_278 CHECK (((bucket >= '2025-04-22 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-05-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_279_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_279_chunk (
    CONSTRAINT constraint_279 CHECK (((bucket >= '2025-06-11 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-06-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_280_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_280_chunk (
    CONSTRAINT constraint_280 CHECK (((bucket >= '2025-04-12 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-04-22 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_281_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_281_chunk (
    CONSTRAINT constraint_281 CHECK (((bucket >= '2025-06-01 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-06-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_282_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_282_chunk (
    CONSTRAINT constraint_282 CHECK (((bucket >= '2025-07-21 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-31 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_283_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_283_chunk (
    CONSTRAINT constraint_283 CHECK (((bucket >= '2025-05-02 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-05-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_284_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_284_chunk (
    CONSTRAINT constraint_284 CHECK (((bucket >= '2025-07-01 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_285_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_285_chunk (
    CONSTRAINT constraint_285 CHECK (((bucket >= '2025-06-21 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-01 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_286_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_286_chunk (
    CONSTRAINT constraint_286 CHECK (((bucket >= '2025-07-11 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-07-21 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _hyper_6_293_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_6_293_chunk (
    CONSTRAINT constraint_293 CHECK (((bucket >= '2025-07-31 00:00:00+00'::timestamp with time zone) AND (bucket < '2025-08-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (_timescaledb_internal._materialized_hypertable_6);


--
-- Name: _partial_view_5; Type: VIEW; Schema: _timescaledb_internal; Owner: -
--

CREATE VIEW _timescaledb_internal._partial_view_5 AS
 SELECT device_id,
    public.time_bucket('01:00:00'::interval, "timestamp") AS bucket,
    avg(power_watts) AS avg_power,
    min(power_watts) AS min_power,
    max(power_watts) AS max_power
   FROM public.energy_data
  GROUP BY device_id, (public.time_bucket('01:00:00'::interval, "timestamp"));


--
-- Name: _partial_view_6; Type: VIEW; Schema: _timescaledb_internal; Owner: -
--

CREATE VIEW _timescaledb_internal._partial_view_6 AS
 SELECT device_id,
    public.time_bucket('1 day'::interval, "timestamp") AS bucket,
    avg(power_watts) AS avg_power_daily,
    min(power_watts) AS min_power_daily,
    max(power_watts) AS max_power_daily
   FROM public.energy_data
  GROUP BY device_id, (public.time_bucket('1 day'::interval, "timestamp"));


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE devices; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.devices IS 'Metadata for monitored devices (printers, CNCs, etc.)';


--
-- Name: COLUMN devices.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devices.device_id IS 'Unique internal identifier for the device';


--
-- Name: COLUMN devices.shelly_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devices.shelly_id IS 'MQTT ID/Topic base used by the associated Shelly Plug';


--
-- Name: COLUMN devices.api_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devices.api_ip IS 'IP Address for accessing the device''s API';


--
-- Name: COLUMN devices.simplyprint_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devices.simplyprint_id IS 'The unique ID for this printer from the SimplyPrint.io API';


--
-- Name: dht22_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dht22_data (
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(50) DEFAULT 'ESP32_SensorHub_Raptor'::character varying NOT NULL,
    printer_id character varying(50),
    temperature_c real,
    humidity_pct real
);


--
-- Name: energy_summary_daily; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.energy_summary_daily AS
 SELECT device_id,
    bucket,
    avg_power_daily,
    min_power_daily,
    max_power_daily
   FROM _timescaledb_internal._materialized_hypertable_6;


--
-- Name: energy_summary_hourly; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.energy_summary_hourly AS
 SELECT device_id,
    bucket,
    avg_power,
    min_power,
    max_power
   FROM _timescaledb_internal._materialized_hypertable_5;


--
-- Name: max6675_temperature_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.max6675_temperature_data (
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(50) DEFAULT 'ESP32_SensorHub_Raptor'::character varying NOT NULL,
    printer_id character varying(50),
    temperature_c real
);


--
-- Name: measurements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurements (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    machine_id character varying(100) NOT NULL,
    metric_name character varying(100) NOT NULL,
    metric_value double precision NOT NULL
);


--
-- Name: TABLE measurements; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.measurements IS 'Stores time-series data for machine metrics like energy consumption and operational drivers.';


--
-- Name: measurements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurements_id_seq OWNED BY public.measurements.id;


--
-- Name: monitor_readings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monitor_readings (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    power numeric(10,3),
    apparent_power numeric(10,3),
    reactive_power numeric(10,3),
    power_factor numeric(5,3),
    voltage numeric(10,3),
    current numeric(10,3),
    state_label character varying(10),
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: monitor_readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monitor_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monitor_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monitor_readings_id_seq OWNED BY public.monitor_readings.id;


--
-- Name: monitor_state_analysis; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monitor_state_analysis (
    id integer,
    "timestamp" timestamp without time zone,
    power double precision,
    apparent_power double precision,
    reactive_power double precision,
    power_factor double precision,
    voltage double precision,
    current double precision,
    device_state character varying(10),
    state_label character varying(10)
);


--
-- Name: monitor_training_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monitor_training_data (
    "timestamp" timestamp with time zone,
    actual_power numeric(10,3),
    apparent_power numeric(10,3),
    reactive_power numeric(10,3),
    power_factor numeric(5,3),
    voltage numeric(10,3),
    current numeric(10,3),
    device_state_numeric integer
);


--
-- Name: mpu6050_accelerometer_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mpu6050_accelerometer_data (
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(50) DEFAULT 'ESP32_SensorHub_Raptor'::character varying NOT NULL,
    printer_id character varying(50),
    accel_x real,
    accel_y real,
    accel_z real
);


--
-- Name: mpu6050_gyroscope_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mpu6050_gyroscope_data (
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(50) DEFAULT 'ESP32_SensorHub_Raptor'::character varying NOT NULL,
    printer_id character varying(50),
    gyro_x real,
    gyro_y real,
    gyro_z real
);


--
-- Name: mpu6050_temperature_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mpu6050_temperature_data (
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(50) DEFAULT 'ESP32_SensorHub_Raptor'::character varying NOT NULL,
    printer_id character varying(50),
    temperature_c real
);


--
-- Name: power_predictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.power_predictions (
    id integer NOT NULL,
    "timestamp" timestamp with time zone,
    actual_power numeric(10,3),
    predicted_power numeric(10,3),
    difference numeric(10,3),
    apparent_power numeric(10,3),
    reactive_power numeric(10,3),
    power_factor numeric(5,3),
    voltage numeric(10,3),
    current numeric(10,3),
    model_file character varying(100)
);


--
-- Name: power_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.power_predictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: power_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.power_predictions_id_seq OWNED BY public.power_predictions.id;


--
-- Name: print_jobs; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: TABLE print_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.print_jobs IS 'Stores historical print job data fetched from SimplyPrint';


--
-- Name: print_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.print_jobs_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: print_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.print_jobs_job_id_seq OWNED BY public.print_jobs.job_id;


--
-- Name: printer_derived_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.printer_derived_status (
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(50) DEFAULT 'ESP32_SensorHub_Raptor'::character varying NOT NULL,
    printer_id character varying(50),
    is_moving integer,
    moving_rms real,
    moving_threshold real,
    process_phase character varying(20)
);


--
-- Name: sensor_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sensor_data (
    id integer NOT NULL,
    driver_id character varying(50),
    value numeric,
    "timestamp" timestamp without time zone,
    unit character varying(20),
    device_type character varying(50)
);


--
-- Name: sensor_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sensor_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sensor_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sensor_data_id_seq OWNED BY public.sensor_data.id;


--
-- Name: smartplug_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartplug_data (
    "timestamp" timestamp with time zone NOT NULL,
    device_id character varying(50) NOT NULL,
    power_w real,
    energy_total_kwh real,
    energy_today_kwh real,
    voltage_v real,
    current_a real,
    power_factor real,
    apparent_power_va real,
    reactive_power_var real
);


--
-- Name: temperature_readings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temperature_readings (
    id integer NOT NULL,
    "timestamp" timestamp without time zone,
    temperature double precision,
    device_state character varying(10)
);


--
-- Name: temperature_readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.temperature_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temperature_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.temperature_readings_id_seq OWNED BY public.temperature_readings.id;


--
-- Name: _hyper_4_101_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_101_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_104_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_104_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_106_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_106_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_109_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_109_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_10_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_10_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_112_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_112_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_115_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_115_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_118_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_118_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_121_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_121_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_123_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_123_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_125_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_125_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_127_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_127_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_129_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_129_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_131_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_131_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_133_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_133_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_135_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_135_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_138_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_138_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_13_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_13_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_140_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_140_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_142_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_142_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_146_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_146_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_149_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_149_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_151_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_151_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_155_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_155_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_159_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_159_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_162_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_162_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_165_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_165_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_168_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_168_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_16_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_16_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_172_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_172_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_193_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_193_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_19_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_19_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_22_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_22_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_27_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_27_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_31_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_31_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_38_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_38_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_40_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_40_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_44_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_44_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_47_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_47_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_54_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_54_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_55_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_55_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_59_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_59_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_63_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_63_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_67_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_67_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_72_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_72_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_73_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_73_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_76_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_76_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_7_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_7_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_80_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_80_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_82_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_82_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_85_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_85_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_88_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_88_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_8_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_8_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_91_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_91_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_94_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_94_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_98_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_98_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: _hyper_4_9_chunk model_version; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_9_chunk ALTER COLUMN model_version SET DEFAULT 'linear_regression_v1'::text;


--
-- Name: measurements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurements ALTER COLUMN id SET DEFAULT nextval('public.measurements_id_seq'::regclass);


--
-- Name: monitor_readings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monitor_readings ALTER COLUMN id SET DEFAULT nextval('public.monitor_readings_id_seq'::regclass);


--
-- Name: power_predictions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.power_predictions ALTER COLUMN id SET DEFAULT nextval('public.power_predictions_id_seq'::regclass);


--
-- Name: print_jobs job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.print_jobs ALTER COLUMN job_id SET DEFAULT nextval('public.print_jobs_job_id_seq'::regclass);


--
-- Name: sensor_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor_data ALTER COLUMN id SET DEFAULT nextval('public.sensor_data_id_seq'::regclass);


--
-- Name: temperature_readings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temperature_readings ALTER COLUMN id SET DEFAULT nextval('public.temperature_readings_id_seq'::regclass);


--
-- Name: _hyper_2_100_chunk 100_142_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_100_chunk
    ADD CONSTRAINT "100_142_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_102_chunk 102_144_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_102_chunk
    ADD CONSTRAINT "102_144_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_103_chunk 103_146_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_103_chunk
    ADD CONSTRAINT "103_146_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_105_chunk 105_148_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_105_chunk
    ADD CONSTRAINT "105_148_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_107_chunk 107_150_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_107_chunk
    ADD CONSTRAINT "107_150_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_108_chunk 108_152_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_108_chunk
    ADD CONSTRAINT "108_152_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_110_chunk 110_154_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_110_chunk
    ADD CONSTRAINT "110_154_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_111_chunk 111_156_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_111_chunk
    ADD CONSTRAINT "111_156_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_113_chunk 113_158_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_113_chunk
    ADD CONSTRAINT "113_158_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_114_chunk 114_160_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_114_chunk
    ADD CONSTRAINT "114_160_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_116_chunk 116_162_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_116_chunk
    ADD CONSTRAINT "116_162_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_117_chunk 117_164_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_117_chunk
    ADD CONSTRAINT "117_164_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_119_chunk 119_166_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_119_chunk
    ADD CONSTRAINT "119_166_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_11_chunk 11_14_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_11_chunk
    ADD CONSTRAINT "11_14_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_120_chunk 120_168_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_120_chunk
    ADD CONSTRAINT "120_168_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_122_chunk 122_170_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_122_chunk
    ADD CONSTRAINT "122_170_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_124_chunk 124_172_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_124_chunk
    ADD CONSTRAINT "124_172_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_126_chunk 126_174_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_126_chunk
    ADD CONSTRAINT "126_174_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_128_chunk 128_176_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_128_chunk
    ADD CONSTRAINT "128_176_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_12_chunk 12_16_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_12_chunk
    ADD CONSTRAINT "12_16_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_130_chunk 130_178_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_130_chunk
    ADD CONSTRAINT "130_178_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_132_chunk 132_180_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_132_chunk
    ADD CONSTRAINT "132_180_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_134_chunk 134_182_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_134_chunk
    ADD CONSTRAINT "134_182_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_136_chunk 136_184_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_136_chunk
    ADD CONSTRAINT "136_184_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_137_chunk 137_186_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_137_chunk
    ADD CONSTRAINT "137_186_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_139_chunk 139_188_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_139_chunk
    ADD CONSTRAINT "139_188_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_141_chunk 141_190_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_141_chunk
    ADD CONSTRAINT "141_190_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_143_chunk 143_192_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_143_chunk
    ADD CONSTRAINT "143_192_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_144_chunk 144_194_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_144_chunk
    ADD CONSTRAINT "144_194_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_145_chunk 145_196_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_145_chunk
    ADD CONSTRAINT "145_196_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_147_chunk 147_198_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_147_chunk
    ADD CONSTRAINT "147_198_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_148_chunk 148_200_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_148_chunk
    ADD CONSTRAINT "148_200_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_14_chunk 14_18_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_14_chunk
    ADD CONSTRAINT "14_18_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_150_chunk 150_202_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_150_chunk
    ADD CONSTRAINT "150_202_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_152_chunk 152_204_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_152_chunk
    ADD CONSTRAINT "152_204_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_153_chunk 153_206_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_153_chunk
    ADD CONSTRAINT "153_206_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_154_chunk 154_208_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_154_chunk
    ADD CONSTRAINT "154_208_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_156_chunk 156_210_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_156_chunk
    ADD CONSTRAINT "156_210_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_157_chunk 157_212_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_157_chunk
    ADD CONSTRAINT "157_212_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_158_chunk 158_214_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_158_chunk
    ADD CONSTRAINT "158_214_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_15_chunk 15_20_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_15_chunk
    ADD CONSTRAINT "15_20_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_160_chunk 160_216_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_160_chunk
    ADD CONSTRAINT "160_216_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_161_chunk 161_218_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_161_chunk
    ADD CONSTRAINT "161_218_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_163_chunk 163_220_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_163_chunk
    ADD CONSTRAINT "163_220_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_164_chunk 164_222_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_164_chunk
    ADD CONSTRAINT "164_222_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_166_chunk 166_224_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_166_chunk
    ADD CONSTRAINT "166_224_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_167_chunk 167_226_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_167_chunk
    ADD CONSTRAINT "167_226_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_169_chunk 169_228_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_169_chunk
    ADD CONSTRAINT "169_228_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_170_chunk 170_230_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk
    ADD CONSTRAINT "170_230_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_171_chunk 171_232_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_171_chunk
    ADD CONSTRAINT "171_232_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_173_chunk 173_234_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_173_chunk
    ADD CONSTRAINT "173_234_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_174_chunk 174_236_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk
    ADD CONSTRAINT "174_236_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_175_chunk 175_238_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_175_chunk
    ADD CONSTRAINT "175_238_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_176_chunk 176_240_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_176_chunk
    ADD CONSTRAINT "176_240_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_177_chunk 177_242_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk
    ADD CONSTRAINT "177_242_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_178_chunk 178_244_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_178_chunk
    ADD CONSTRAINT "178_244_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_179_chunk 179_246_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_179_chunk
    ADD CONSTRAINT "179_246_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_17_chunk 17_22_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_17_chunk
    ADD CONSTRAINT "17_22_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_180_chunk 180_248_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk
    ADD CONSTRAINT "180_248_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_181_chunk 181_250_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_181_chunk
    ADD CONSTRAINT "181_250_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_182_chunk 182_252_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_182_chunk
    ADD CONSTRAINT "182_252_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_183_chunk 183_254_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk
    ADD CONSTRAINT "183_254_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_184_chunk 184_256_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_184_chunk
    ADD CONSTRAINT "184_256_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_185_chunk 185_258_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_185_chunk
    ADD CONSTRAINT "185_258_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_186_chunk 186_260_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk
    ADD CONSTRAINT "186_260_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_187_chunk 187_262_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_187_chunk
    ADD CONSTRAINT "187_262_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_188_chunk 188_264_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_188_chunk
    ADD CONSTRAINT "188_264_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_189_chunk 189_266_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk
    ADD CONSTRAINT "189_266_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_18_chunk 18_24_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_18_chunk
    ADD CONSTRAINT "18_24_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_190_chunk 190_268_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_190_chunk
    ADD CONSTRAINT "190_268_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_191_chunk 191_270_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_191_chunk
    ADD CONSTRAINT "191_270_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_192_chunk 192_272_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk
    ADD CONSTRAINT "192_272_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_194_chunk 194_274_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_194_chunk
    ADD CONSTRAINT "194_274_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_195_chunk 195_276_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_195_chunk
    ADD CONSTRAINT "195_276_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_196_chunk 196_278_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_196_chunk
    ADD CONSTRAINT "196_278_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_197_chunk 197_280_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_197_chunk
    ADD CONSTRAINT "197_280_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_198_chunk 198_282_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk
    ADD CONSTRAINT "198_282_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_199_chunk 199_284_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_199_chunk
    ADD CONSTRAINT "199_284_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_1_chunk 1_2_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1_chunk
    ADD CONSTRAINT "1_2_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_200_chunk 200_286_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_200_chunk
    ADD CONSTRAINT "200_286_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_201_chunk 201_288_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk
    ADD CONSTRAINT "201_288_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_202_chunk 202_290_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_202_chunk
    ADD CONSTRAINT "202_290_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_203_chunk 203_292_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_203_chunk
    ADD CONSTRAINT "203_292_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_204_chunk 204_294_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_204_chunk
    ADD CONSTRAINT "204_294_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_205_chunk 205_296_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_205_chunk
    ADD CONSTRAINT "205_296_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_206_chunk 206_298_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_206_chunk
    ADD CONSTRAINT "206_298_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_207_chunk 207_300_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_207_chunk
    ADD CONSTRAINT "207_300_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_208_chunk 208_302_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_208_chunk
    ADD CONSTRAINT "208_302_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_209_chunk 209_304_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_209_chunk
    ADD CONSTRAINT "209_304_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_20_chunk 20_26_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_20_chunk
    ADD CONSTRAINT "20_26_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_210_chunk 210_306_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_210_chunk
    ADD CONSTRAINT "210_306_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_211_chunk 211_308_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_211_chunk
    ADD CONSTRAINT "211_308_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_212_chunk 212_310_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_212_chunk
    ADD CONSTRAINT "212_310_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_213_chunk 213_312_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_213_chunk
    ADD CONSTRAINT "213_312_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_214_chunk 214_314_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_214_chunk
    ADD CONSTRAINT "214_314_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_215_chunk 215_316_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_215_chunk
    ADD CONSTRAINT "215_316_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_216_chunk 216_318_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_216_chunk
    ADD CONSTRAINT "216_318_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_217_chunk 217_320_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_217_chunk
    ADD CONSTRAINT "217_320_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_218_chunk 218_322_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_218_chunk
    ADD CONSTRAINT "218_322_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_219_chunk 219_324_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_219_chunk
    ADD CONSTRAINT "219_324_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_21_chunk 21_28_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_21_chunk
    ADD CONSTRAINT "21_28_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_220_chunk 220_326_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_220_chunk
    ADD CONSTRAINT "220_326_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_221_chunk 221_328_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_221_chunk
    ADD CONSTRAINT "221_328_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_222_chunk 222_330_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_222_chunk
    ADD CONSTRAINT "222_330_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_223_chunk 223_332_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_223_chunk
    ADD CONSTRAINT "223_332_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_224_chunk 224_334_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_224_chunk
    ADD CONSTRAINT "224_334_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_225_chunk 225_336_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_225_chunk
    ADD CONSTRAINT "225_336_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_226_chunk 226_338_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_226_chunk
    ADD CONSTRAINT "226_338_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_227_chunk 227_340_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_227_chunk
    ADD CONSTRAINT "227_340_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_228_chunk 228_342_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_228_chunk
    ADD CONSTRAINT "228_342_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_229_chunk 229_344_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_229_chunk
    ADD CONSTRAINT "229_344_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_230_chunk 230_346_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_230_chunk
    ADD CONSTRAINT "230_346_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_231_chunk 231_348_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_231_chunk
    ADD CONSTRAINT "231_348_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_232_chunk 232_350_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_232_chunk
    ADD CONSTRAINT "232_350_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_233_chunk 233_352_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_233_chunk
    ADD CONSTRAINT "233_352_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_234_chunk 234_354_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_234_chunk
    ADD CONSTRAINT "234_354_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_235_chunk 235_356_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_235_chunk
    ADD CONSTRAINT "235_356_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_236_chunk 236_358_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_236_chunk
    ADD CONSTRAINT "236_358_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_237_chunk 237_360_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_237_chunk
    ADD CONSTRAINT "237_360_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_238_chunk 238_362_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_238_chunk
    ADD CONSTRAINT "238_362_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_239_chunk 239_364_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_239_chunk
    ADD CONSTRAINT "239_364_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_23_chunk 23_30_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_23_chunk
    ADD CONSTRAINT "23_30_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_240_chunk 240_366_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_240_chunk
    ADD CONSTRAINT "240_366_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_241_chunk 241_368_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_241_chunk
    ADD CONSTRAINT "241_368_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_242_chunk 242_370_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_242_chunk
    ADD CONSTRAINT "242_370_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_243_chunk 243_372_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_243_chunk
    ADD CONSTRAINT "243_372_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_244_chunk 244_374_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_244_chunk
    ADD CONSTRAINT "244_374_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_245_chunk 245_376_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_245_chunk
    ADD CONSTRAINT "245_376_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_246_chunk 246_378_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_246_chunk
    ADD CONSTRAINT "246_378_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_247_chunk 247_380_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_247_chunk
    ADD CONSTRAINT "247_380_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_248_chunk 248_382_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_248_chunk
    ADD CONSTRAINT "248_382_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_249_chunk 249_384_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_249_chunk
    ADD CONSTRAINT "249_384_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_24_chunk 24_32_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_24_chunk
    ADD CONSTRAINT "24_32_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_250_chunk 250_386_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_250_chunk
    ADD CONSTRAINT "250_386_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_251_chunk 251_388_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_251_chunk
    ADD CONSTRAINT "251_388_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_252_chunk 252_390_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_252_chunk
    ADD CONSTRAINT "252_390_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_253_chunk 253_392_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_253_chunk
    ADD CONSTRAINT "253_392_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_254_chunk 254_394_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_254_chunk
    ADD CONSTRAINT "254_394_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_255_chunk 255_396_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_255_chunk
    ADD CONSTRAINT "255_396_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_256_chunk 256_398_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_256_chunk
    ADD CONSTRAINT "256_398_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_257_chunk 257_400_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_257_chunk
    ADD CONSTRAINT "257_400_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_258_chunk 258_402_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_258_chunk
    ADD CONSTRAINT "258_402_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_259_chunk 259_404_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_259_chunk
    ADD CONSTRAINT "259_404_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_260_chunk 260_406_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_260_chunk
    ADD CONSTRAINT "260_406_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_261_chunk 261_408_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_261_chunk
    ADD CONSTRAINT "261_408_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_262_chunk 262_410_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_262_chunk
    ADD CONSTRAINT "262_410_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_263_chunk 263_412_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_263_chunk
    ADD CONSTRAINT "263_412_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_264_chunk 264_414_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_264_chunk
    ADD CONSTRAINT "264_414_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_265_chunk 265_416_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_265_chunk
    ADD CONSTRAINT "265_416_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_266_chunk 266_418_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_266_chunk
    ADD CONSTRAINT "266_418_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_267_chunk 267_420_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_267_chunk
    ADD CONSTRAINT "267_420_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_268_chunk 268_422_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_268_chunk
    ADD CONSTRAINT "268_422_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_26_chunk 26_36_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_26_chunk
    ADD CONSTRAINT "26_36_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_287_chunk 287_424_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_287_chunk
    ADD CONSTRAINT "287_424_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_288_chunk 288_426_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_288_chunk
    ADD CONSTRAINT "288_426_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_28_chunk 28_38_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_28_chunk
    ADD CONSTRAINT "28_38_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_290_chunk 290_428_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_290_chunk
    ADD CONSTRAINT "290_428_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_291_chunk 291_430_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_291_chunk
    ADD CONSTRAINT "291_430_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_292_chunk 292_432_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_292_chunk
    ADD CONSTRAINT "292_432_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_294_chunk 294_434_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_294_chunk
    ADD CONSTRAINT "294_434_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_295_chunk 295_436_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_295_chunk
    ADD CONSTRAINT "295_436_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_296_chunk 296_438_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_296_chunk
    ADD CONSTRAINT "296_438_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_297_chunk 297_440_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_297_chunk
    ADD CONSTRAINT "297_440_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_298_chunk 298_442_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_298_chunk
    ADD CONSTRAINT "298_442_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_299_chunk 299_444_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_299_chunk
    ADD CONSTRAINT "299_444_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_29_chunk 29_40_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_29_chunk
    ADD CONSTRAINT "29_40_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_2_chunk 2_4_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_2_chunk
    ADD CONSTRAINT "2_4_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_300_chunk 300_446_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_300_chunk
    ADD CONSTRAINT "300_446_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_301_chunk 301_448_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_301_chunk
    ADD CONSTRAINT "301_448_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_302_chunk 302_450_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_302_chunk
    ADD CONSTRAINT "302_450_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_30_chunk 30_42_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_30_chunk
    ADD CONSTRAINT "30_42_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_32_chunk 32_44_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_32_chunk
    ADD CONSTRAINT "32_44_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_33_chunk 33_46_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_33_chunk
    ADD CONSTRAINT "33_46_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_34_chunk 34_48_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_34_chunk
    ADD CONSTRAINT "34_48_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_35_chunk 35_50_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_35_chunk
    ADD CONSTRAINT "35_50_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_36_chunk 36_52_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_36_chunk
    ADD CONSTRAINT "36_52_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_37_chunk 37_54_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_37_chunk
    ADD CONSTRAINT "37_54_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_39_chunk 39_56_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_39_chunk
    ADD CONSTRAINT "39_56_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_3_chunk 3_6_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_3_chunk
    ADD CONSTRAINT "3_6_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_41_chunk 41_58_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_41_chunk
    ADD CONSTRAINT "41_58_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_42_chunk 42_60_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_42_chunk
    ADD CONSTRAINT "42_60_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_43_chunk 43_62_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_43_chunk
    ADD CONSTRAINT "43_62_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_45_chunk 45_64_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_45_chunk
    ADD CONSTRAINT "45_64_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_46_chunk 46_66_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_46_chunk
    ADD CONSTRAINT "46_66_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_48_chunk 48_68_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_48_chunk
    ADD CONSTRAINT "48_68_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_49_chunk 49_70_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_49_chunk
    ADD CONSTRAINT "49_70_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_4_chunk 4_8_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_4_chunk
    ADD CONSTRAINT "4_8_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_50_chunk 50_72_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_50_chunk
    ADD CONSTRAINT "50_72_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_51_chunk 51_74_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_51_chunk
    ADD CONSTRAINT "51_74_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_52_chunk 52_76_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_52_chunk
    ADD CONSTRAINT "52_76_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_53_chunk 53_78_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_53_chunk
    ADD CONSTRAINT "53_78_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_56_chunk 56_80_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_56_chunk
    ADD CONSTRAINT "56_80_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_57_chunk 57_82_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_57_chunk
    ADD CONSTRAINT "57_82_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_58_chunk 58_84_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_58_chunk
    ADD CONSTRAINT "58_84_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_5_chunk 5_10_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_5_chunk
    ADD CONSTRAINT "5_10_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_60_chunk 60_86_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_60_chunk
    ADD CONSTRAINT "60_86_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_61_chunk 61_88_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_61_chunk
    ADD CONSTRAINT "61_88_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_62_chunk 62_90_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_62_chunk
    ADD CONSTRAINT "62_90_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_64_chunk 64_92_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_64_chunk
    ADD CONSTRAINT "64_92_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_65_chunk 65_94_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_65_chunk
    ADD CONSTRAINT "65_94_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_66_chunk 66_96_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_66_chunk
    ADD CONSTRAINT "66_96_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_68_chunk 68_98_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_68_chunk
    ADD CONSTRAINT "68_98_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_69_chunk 69_100_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_69_chunk
    ADD CONSTRAINT "69_100_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_1_6_chunk 6_12_energy_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_6_chunk
    ADD CONSTRAINT "6_12_energy_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_70_chunk 70_102_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_70_chunk
    ADD CONSTRAINT "70_102_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_71_chunk 71_104_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_71_chunk
    ADD CONSTRAINT "71_104_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_74_chunk 74_106_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_74_chunk
    ADD CONSTRAINT "74_106_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_75_chunk 75_108_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_75_chunk
    ADD CONSTRAINT "75_108_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_77_chunk 77_110_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_77_chunk
    ADD CONSTRAINT "77_110_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_78_chunk 78_112_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_78_chunk
    ADD CONSTRAINT "78_112_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_79_chunk 79_114_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_79_chunk
    ADD CONSTRAINT "79_114_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_81_chunk 81_116_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_81_chunk
    ADD CONSTRAINT "81_116_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_83_chunk 83_118_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_83_chunk
    ADD CONSTRAINT "83_118_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_84_chunk 84_120_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_84_chunk
    ADD CONSTRAINT "84_120_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_86_chunk 86_122_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_86_chunk
    ADD CONSTRAINT "86_122_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_87_chunk 87_124_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_87_chunk
    ADD CONSTRAINT "87_124_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_89_chunk 89_126_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_89_chunk
    ADD CONSTRAINT "89_126_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_90_chunk 90_128_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_90_chunk
    ADD CONSTRAINT "90_128_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_92_chunk 92_130_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_92_chunk
    ADD CONSTRAINT "92_130_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_93_chunk 93_132_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_93_chunk
    ADD CONSTRAINT "93_132_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_95_chunk 95_134_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_95_chunk
    ADD CONSTRAINT "95_134_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_96_chunk 96_136_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_96_chunk
    ADD CONSTRAINT "96_136_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_2_97_chunk 97_138_printer_status_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_97_chunk
    ADD CONSTRAINT "97_138_printer_status_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: _hyper_3_99_chunk 99_140_environment_data_pkey; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_99_chunk
    ADD CONSTRAINT "99_140_environment_data_pkey" PRIMARY KEY ("timestamp", device_id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (device_id);


--
-- Name: devices devices_shelly_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_shelly_id_key UNIQUE (shelly_id);


--
-- Name: dht22_data dht22_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dht22_data
    ADD CONSTRAINT dht22_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: energy_data energy_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.energy_data
    ADD CONSTRAINT energy_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: environment_data environment_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.environment_data
    ADD CONSTRAINT environment_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: max6675_temperature_data max6675_temperature_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.max6675_temperature_data
    ADD CONSTRAINT max6675_temperature_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: measurements measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (id);


--
-- Name: monitor_readings monitor_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monitor_readings
    ADD CONSTRAINT monitor_readings_pkey PRIMARY KEY (id);


--
-- Name: mpu6050_accelerometer_data mpu6050_accelerometer_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mpu6050_accelerometer_data
    ADD CONSTRAINT mpu6050_accelerometer_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: mpu6050_gyroscope_data mpu6050_gyroscope_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mpu6050_gyroscope_data
    ADD CONSTRAINT mpu6050_gyroscope_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: mpu6050_temperature_data mpu6050_temperature_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mpu6050_temperature_data
    ADD CONSTRAINT mpu6050_temperature_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: power_predictions power_predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.power_predictions
    ADD CONSTRAINT power_predictions_pkey PRIMARY KEY (id);


--
-- Name: print_jobs print_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.print_jobs
    ADD CONSTRAINT print_jobs_pkey PRIMARY KEY (job_id);


--
-- Name: print_jobs print_jobs_simplyprint_job_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.print_jobs
    ADD CONSTRAINT print_jobs_simplyprint_job_id_key UNIQUE (simplyprint_job_id);


--
-- Name: printer_derived_status printer_derived_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.printer_derived_status
    ADD CONSTRAINT printer_derived_status_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: printer_status printer_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.printer_status
    ADD CONSTRAINT printer_status_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: sensor_data sensor_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT sensor_data_pkey PRIMARY KEY (id);


--
-- Name: smartplug_data smartplug_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartplug_data
    ADD CONSTRAINT smartplug_data_pkey PRIMARY KEY ("timestamp", device_id);


--
-- Name: temperature_readings temperature_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temperature_readings
    ADD CONSTRAINT temperature_readings_pkey PRIMARY KEY (id);


--
-- Name: _hyper_1_12_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_12_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_12_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_154_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_154_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_154_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_156_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_156_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_156_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_158_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_158_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_158_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_15_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_15_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_15_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_161_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_161_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_161_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_164_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_164_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_164_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_167_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_167_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_167_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_171_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_171_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_171_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_175_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_175_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_175_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_178_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_178_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_178_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_181_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_181_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_181_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_184_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_184_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_184_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_187_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_187_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_187_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_18_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_18_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_18_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_190_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_190_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_190_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_194_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_194_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_194_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_196_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_196_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_196_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_199_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_199_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_199_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_1_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_1_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_202_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_202_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_202_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_204_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_204_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_204_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_206_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_206_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_206_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_208_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_208_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_208_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_210_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_210_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_210_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_212_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_212_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_212_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_214_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_214_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_214_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_219_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_219_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_219_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_21_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_21_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_21_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_221_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_221_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_221_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_223_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_223_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_223_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_225_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_225_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_225_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_227_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_227_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_227_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_229_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_229_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_229_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_230_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_230_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_230_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_233_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_233_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_233_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_234_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_234_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_234_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_237_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_237_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_237_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_239_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_239_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_239_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_242_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_242_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_242_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_244_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_244_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_244_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_245_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_245_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_245_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_249_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_249_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_249_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_24_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_24_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_24_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_252_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_252_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_252_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_253_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_253_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_253_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_255_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_255_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_255_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_258_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_258_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_258_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_259_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_259_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_259_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_261_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_261_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_261_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_263_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_263_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_263_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_265_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_265_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_265_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_267_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_267_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_267_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_287_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_287_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_287_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_290_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_290_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_290_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_292_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_292_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_292_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_294_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_294_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_294_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_295_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_295_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_295_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_297_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_297_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_297_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_299_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_299_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_299_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_301_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_301_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_301_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_30_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_30_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_30_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_34_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_34_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_34_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_37_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_37_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_37_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_39_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_39_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_39_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_43_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_43_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_43_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_4_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_4_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_4_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_50_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_50_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_50_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_53_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_53_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_53_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_58_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_58_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_58_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_62_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_62_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_62_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_66_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_66_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_66_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_6_chunk_energy_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_6_chunk_energy_data_timestamp_idx ON _timescaledb_internal._hyper_1_6_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_100_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_100_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_100_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_103_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_103_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_103_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_107_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_107_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_107_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_110_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_110_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_110_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_113_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_113_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_113_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_116_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_116_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_116_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_119_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_119_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_119_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_11_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_11_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_11_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_122_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_122_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_122_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_124_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_124_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_124_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_126_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_126_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_126_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_128_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_128_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_128_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_130_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_130_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_130_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_132_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_132_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_132_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_134_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_134_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_134_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_136_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_136_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_136_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_139_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_139_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_139_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_141_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_141_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_141_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_143_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_143_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_143_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_147_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_147_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_147_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_14_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_14_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_14_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_150_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_150_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_150_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_153_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_153_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_153_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_157_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_157_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_157_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_160_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_160_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_160_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_163_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_163_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_163_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_166_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_166_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_166_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_169_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_169_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_169_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_173_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_173_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_173_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_176_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_176_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_176_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_179_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_179_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_179_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_17_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_17_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_17_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_182_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_182_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_182_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_185_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_185_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_185_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_188_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_188_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_188_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_191_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_191_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_191_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_195_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_195_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_195_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_197_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_197_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_197_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_200_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_200_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_200_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_203_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_203_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_203_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_205_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_205_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_205_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_207_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_207_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_207_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_209_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_209_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_209_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_20_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_20_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_20_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_211_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_211_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_211_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_213_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_213_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_213_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_215_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_215_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_215_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_216_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_216_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_216_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_217_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_217_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_217_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_218_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_218_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_218_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_220_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_220_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_220_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_222_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_222_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_222_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_224_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_224_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_224_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_226_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_226_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_226_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_228_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_228_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_228_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_231_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_231_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_231_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_232_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_232_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_232_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_235_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_235_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_235_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_236_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_236_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_236_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_238_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_238_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_238_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_23_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_23_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_23_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_240_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_240_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_240_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_241_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_241_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_241_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_243_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_243_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_243_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_246_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_246_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_246_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_247_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_247_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_247_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_250_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_250_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_250_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_251_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_251_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_251_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_254_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_254_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_254_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_256_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_256_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_256_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_257_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_257_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_257_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_260_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_260_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_260_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_262_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_262_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_262_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_264_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_264_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_264_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_266_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_266_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_266_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_268_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_268_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_268_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_288_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_288_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_288_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_28_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_28_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_28_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_291_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_291_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_291_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_296_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_296_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_296_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_298_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_298_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_298_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_2_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_2_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_2_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_300_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_300_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_300_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_302_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_302_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_302_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_32_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_32_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_32_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_35_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_35_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_35_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_3_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_3_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_3_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_42_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_42_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_42_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_46_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_46_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_46_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_49_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_49_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_49_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_52_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_52_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_52_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_57_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_57_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_57_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_5_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_5_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_5_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_61_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_61_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_61_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_65_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_65_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_65_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_68_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_68_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_68_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_71_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_71_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_71_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_75_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_75_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_75_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_78_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_78_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_78_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_81_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_81_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_81_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_84_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_84_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_84_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_87_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_87_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_87_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_90_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_90_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_90_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_92_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_92_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_92_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_95_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_95_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_95_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_2_97_chunk_printer_status_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_97_chunk_printer_status_timestamp_idx ON _timescaledb_internal._hyper_2_97_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_102_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_102_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_102_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_105_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_105_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_105_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_108_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_108_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_108_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_111_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_111_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_111_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_114_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_114_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_114_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_117_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_117_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_117_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_120_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_120_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_120_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_137_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_137_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_137_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_144_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_144_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_144_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_145_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_145_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_145_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_148_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_148_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_148_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_152_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_152_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_152_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_170_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_170_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_170_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_174_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_174_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_174_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_177_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_177_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_177_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_180_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_180_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_180_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_183_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_183_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_183_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_186_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_186_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_186_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_189_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_189_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_189_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_192_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_192_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_192_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_198_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_198_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_198_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_201_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_201_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_201_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_248_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_248_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_248_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_26_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_26_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_26_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_29_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_29_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_29_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_33_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_33_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_33_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_36_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_36_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_36_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_41_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_41_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_41_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_45_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_45_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_45_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_48_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_48_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_48_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_51_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_51_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_51_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_56_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_56_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_56_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_60_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_60_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_60_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_64_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_64_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_64_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_69_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_69_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_69_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_70_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_70_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_70_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_74_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_74_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_74_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_77_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_77_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_77_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_79_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_79_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_79_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_83_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_83_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_83_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_86_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_86_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_86_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_89_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_89_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_89_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_93_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_93_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_93_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_96_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_96_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_96_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_3_99_chunk_environment_data_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_99_chunk_environment_data_timestamp_idx ON _timescaledb_internal._hyper_3_99_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_101_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_101_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_101_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_101_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_101_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_101_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_101_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_101_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_101_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_104_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_104_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_104_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_104_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_104_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_104_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_104_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_104_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_104_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_106_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_106_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_106_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_106_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_106_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_106_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_106_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_106_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_106_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_109_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_109_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_109_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_109_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_109_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_109_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_109_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_109_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_109_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_10_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_10_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_10_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_10_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_10_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_10_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_10_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_10_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_10_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_112_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_112_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_112_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_112_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_112_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_112_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_112_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_112_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_112_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_115_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_115_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_115_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_115_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_115_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_115_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_115_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_115_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_115_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_118_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_118_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_118_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_118_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_118_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_118_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_118_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_118_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_118_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_121_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_121_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_121_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_121_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_121_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_121_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_121_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_121_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_121_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_123_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_123_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_123_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_123_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_123_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_123_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_123_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_123_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_123_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_125_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_125_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_125_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_125_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_125_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_125_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_125_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_125_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_125_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_127_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_127_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_127_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_127_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_127_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_127_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_127_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_127_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_127_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_129_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_129_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_129_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_129_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_129_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_129_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_129_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_129_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_129_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_131_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_131_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_131_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_131_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_131_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_131_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_131_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_131_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_131_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_133_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_133_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_133_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_133_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_133_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_133_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_133_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_133_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_133_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_135_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_135_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_135_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_135_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_135_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_135_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_135_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_135_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_135_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_138_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_138_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_138_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_138_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_138_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_138_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_138_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_138_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_138_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_13_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_13_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_13_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_13_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_13_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_13_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_13_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_13_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_13_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_140_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_140_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_140_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_140_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_140_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_140_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_140_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_140_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_140_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_142_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_142_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_142_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_142_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_142_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_142_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_142_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_142_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_142_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_146_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_146_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_146_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_146_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_146_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_146_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_146_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_146_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_146_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_149_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_149_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_149_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_149_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_149_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_149_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_149_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_149_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_149_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_151_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_151_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_151_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_151_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_151_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_151_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_151_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_151_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_151_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_155_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_155_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_155_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_155_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_155_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_155_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_155_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_155_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_155_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_159_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_159_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_159_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_159_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_159_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_159_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_159_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_159_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_159_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_162_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_162_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_162_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_162_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_162_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_162_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_162_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_162_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_162_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_165_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_165_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_165_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_165_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_165_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_165_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_165_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_165_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_165_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_168_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_168_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_168_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_168_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_168_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_168_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_168_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_168_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_168_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_16_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_16_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_16_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_16_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_16_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_16_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_16_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_16_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_16_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_172_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_172_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_172_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_172_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_172_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_172_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_172_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_172_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_172_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_193_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_193_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_193_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_193_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_193_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_193_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_193_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_193_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_193_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_19_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_19_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_19_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_19_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_19_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_19_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_19_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_19_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_19_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_22_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_22_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_22_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_22_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_22_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_22_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_22_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_22_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_22_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_27_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_27_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_27_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_27_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_27_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_27_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_27_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_27_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_27_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_31_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_31_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_31_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_31_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_31_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_31_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_31_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_31_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_31_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_38_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_38_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_38_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_38_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_38_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_38_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_38_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_38_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_38_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_40_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_40_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_40_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_40_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_40_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_40_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_40_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_40_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_40_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_44_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_44_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_44_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_44_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_44_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_44_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_44_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_44_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_44_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_47_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_47_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_47_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_47_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_47_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_47_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_47_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_47_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_47_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_54_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_54_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_54_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_54_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_54_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_54_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_54_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_54_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_54_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_55_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_55_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_55_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_55_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_55_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_55_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_55_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_55_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_55_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_59_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_59_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_59_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_59_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_59_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_59_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_59_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_59_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_59_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_63_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_63_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_63_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_63_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_63_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_63_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_63_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_63_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_63_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_67_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_67_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_67_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_67_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_67_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_67_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_67_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_67_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_67_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_72_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_72_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_72_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_72_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_72_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_72_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_72_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_72_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_72_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_73_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_73_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_73_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_73_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_73_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_73_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_73_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_73_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_73_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_76_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_76_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_76_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_76_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_76_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_76_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_76_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_76_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_76_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_7_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_7_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_7_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_7_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_7_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_7_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_7_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_7_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_7_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_80_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_80_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_80_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_80_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_80_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_80_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_80_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_80_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_80_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_82_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_82_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_82_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_82_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_82_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_82_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_82_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_82_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_82_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_85_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_85_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_85_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_85_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_85_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_85_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_85_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_85_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_85_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_88_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_88_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_88_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_88_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_88_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_88_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_88_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_88_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_88_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_8_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_8_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_8_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_8_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_8_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_8_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_8_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_8_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_8_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_91_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_91_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_91_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_91_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_91_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_91_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_91_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_91_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_91_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_94_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_94_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_94_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_94_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_94_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_94_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_94_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_94_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_94_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_98_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_98_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_98_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_98_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_98_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_98_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_98_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_98_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_98_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_9_chunk_ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_9_chunk_ml_predictions_device_id_timestamp_idx ON _timescaledb_internal._hyper_4_9_chunk USING btree (device_id, "timestamp" DESC);


--
-- Name: _hyper_4_9_chunk_ml_predictions_timestamp_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_9_chunk_ml_predictions_timestamp_idx ON _timescaledb_internal._hyper_4_9_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_4_9_chunk_ml_predictions_timestamp_idx1; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_9_chunk_ml_predictions_timestamp_idx1 ON _timescaledb_internal._hyper_4_9_chunk USING btree ("timestamp" DESC);


--
-- Name: _hyper_5_269_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_269_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_269_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_269_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_269_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_269_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_270_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_270_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_270_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_270_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_270_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_270_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_271_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_271_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_271_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_271_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_271_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_271_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_272_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_272_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_272_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_272_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_272_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_272_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_273_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_273_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_273_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_273_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_273_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_273_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_274_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_274_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_274_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_274_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_274_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_274_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_275_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_275_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_275_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_275_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_275_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_275_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_276_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_276_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_276_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_276_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_276_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_276_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_277_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_277_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_277_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_277_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_277_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_277_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_5_289_chunk__materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_289_chunk__materialized_hypertable_5_bucket_idx ON _timescaledb_internal._hyper_5_289_chunk USING btree (bucket DESC);


--
-- Name: _hyper_5_289_chunk__materialized_hypertable_5_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_5_289_chunk__materialized_hypertable_5_device_id_bucket_ ON _timescaledb_internal._hyper_5_289_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_278_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_278_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_278_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_278_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_278_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_278_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_279_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_279_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_279_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_279_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_279_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_279_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_280_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_280_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_280_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_280_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_280_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_280_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_281_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_281_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_281_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_281_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_281_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_281_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_282_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_282_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_282_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_282_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_282_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_282_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_283_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_283_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_283_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_283_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_283_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_283_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_284_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_284_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_284_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_284_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_284_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_284_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_285_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_285_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_285_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_285_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_285_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_285_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_286_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_286_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_286_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_286_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_286_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_286_chunk USING btree (device_id, bucket DESC);


--
-- Name: _hyper_6_293_chunk__materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_293_chunk__materialized_hypertable_6_bucket_idx ON _timescaledb_internal._hyper_6_293_chunk USING btree (bucket DESC);


--
-- Name: _hyper_6_293_chunk__materialized_hypertable_6_device_id_bucket_; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_6_293_chunk__materialized_hypertable_6_device_id_bucket_ ON _timescaledb_internal._hyper_6_293_chunk USING btree (device_id, bucket DESC);


--
-- Name: _materialized_hypertable_5_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _materialized_hypertable_5_bucket_idx ON _timescaledb_internal._materialized_hypertable_5 USING btree (bucket DESC);


--
-- Name: _materialized_hypertable_5_device_id_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _materialized_hypertable_5_device_id_bucket_idx ON _timescaledb_internal._materialized_hypertable_5 USING btree (device_id, bucket DESC);


--
-- Name: _materialized_hypertable_6_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _materialized_hypertable_6_bucket_idx ON _timescaledb_internal._materialized_hypertable_6 USING btree (bucket DESC);


--
-- Name: _materialized_hypertable_6_device_id_bucket_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _materialized_hypertable_6_device_id_bucket_idx ON _timescaledb_internal._materialized_hypertable_6 USING btree (device_id, bucket DESC);


--
-- Name: energy_data_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX energy_data_timestamp_idx ON public.energy_data USING btree ("timestamp" DESC);


--
-- Name: environment_data_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX environment_data_timestamp_idx ON public.environment_data USING btree ("timestamp" DESC);


--
-- Name: idx_measurements_machine_metric_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_measurements_machine_metric_time ON public.measurements USING btree (machine_id, metric_name, "timestamp" DESC);


--
-- Name: idx_measurements_metric_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_measurements_metric_name ON public.measurements USING btree (metric_name);


--
-- Name: idx_measurements_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_measurements_timestamp ON public.measurements USING btree ("timestamp" DESC);


--
-- Name: ml_predictions_device_id_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ml_predictions_device_id_timestamp_idx ON public.ml_predictions USING btree (device_id, "timestamp" DESC);


--
-- Name: ml_predictions_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ml_predictions_timestamp_idx ON public.ml_predictions USING btree ("timestamp" DESC);


--
-- Name: ml_predictions_timestamp_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ml_predictions_timestamp_idx1 ON public.ml_predictions USING btree ("timestamp" DESC);


--
-- Name: printer_status_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX printer_status_timestamp_idx ON public.printer_status USING btree ("timestamp" DESC);


--
-- Name: _hyper_1_12_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_12_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_154_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_154_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_156_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_156_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_158_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_158_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_15_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_15_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_161_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_161_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_164_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_164_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_167_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_167_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_171_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_171_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_175_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_175_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_178_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_178_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_181_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_181_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_184_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_184_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_187_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_187_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_18_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_18_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_190_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_190_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_194_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_194_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_196_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_196_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_199_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_199_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_1_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_1_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_202_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_202_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_204_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_204_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_206_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_206_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_208_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_208_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_210_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_210_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_212_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_212_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_214_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_214_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_219_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_219_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_21_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_21_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_221_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_221_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_223_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_223_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_225_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_225_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_227_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_227_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_229_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_229_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_230_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_230_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_233_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_233_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_234_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_234_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_237_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_237_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_239_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_239_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_242_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_242_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_244_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_244_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_245_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_245_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_249_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_249_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_24_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_24_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_252_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_252_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_253_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_253_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_255_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_255_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_258_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_258_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_259_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_259_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_261_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_261_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_263_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_263_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_265_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_265_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_267_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_267_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_287_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_287_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_290_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_290_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_292_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_292_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_294_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_294_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_295_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_295_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_297_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_297_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_299_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_299_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_301_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_301_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_30_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_30_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_34_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_34_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_37_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_37_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_39_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_39_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_43_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_43_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_4_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_4_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_50_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_50_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_53_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_53_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_58_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_58_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_62_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_62_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_66_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_66_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _hyper_1_6_chunk ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON _timescaledb_internal._hyper_1_6_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: _materialized_hypertable_5 ts_insert_blocker; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._materialized_hypertable_5 FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.insert_blocker();


--
-- Name: _materialized_hypertable_6 ts_insert_blocker; Type: TRIGGER; Schema: _timescaledb_internal; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._materialized_hypertable_6 FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.insert_blocker();


--
-- Name: energy_data ts_cagg_invalidation_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_cagg_invalidation_trigger AFTER INSERT OR DELETE OR UPDATE ON public.energy_data FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.continuous_agg_invalidation_trigger('1');


--
-- Name: energy_data ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.energy_data FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.insert_blocker();


--
-- Name: environment_data ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.environment_data FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.insert_blocker();


--
-- Name: ml_predictions ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.ml_predictions FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.insert_blocker();


--
-- Name: printer_status ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.printer_status FOR EACH ROW EXECUTE FUNCTION _timescaledb_functions.insert_blocker();


--
-- Name: _hyper_2_100_chunk 100_141_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_100_chunk
    ADD CONSTRAINT "100_141_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_102_chunk 102_143_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_102_chunk
    ADD CONSTRAINT "102_143_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_103_chunk 103_145_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_103_chunk
    ADD CONSTRAINT "103_145_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_105_chunk 105_147_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_105_chunk
    ADD CONSTRAINT "105_147_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_107_chunk 107_149_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_107_chunk
    ADD CONSTRAINT "107_149_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_108_chunk 108_151_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_108_chunk
    ADD CONSTRAINT "108_151_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_110_chunk 110_153_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_110_chunk
    ADD CONSTRAINT "110_153_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_111_chunk 111_155_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_111_chunk
    ADD CONSTRAINT "111_155_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_113_chunk 113_157_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_113_chunk
    ADD CONSTRAINT "113_157_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_114_chunk 114_159_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_114_chunk
    ADD CONSTRAINT "114_159_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_116_chunk 116_161_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_116_chunk
    ADD CONSTRAINT "116_161_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_117_chunk 117_163_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_117_chunk
    ADD CONSTRAINT "117_163_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_119_chunk 119_165_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_119_chunk
    ADD CONSTRAINT "119_165_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_11_chunk 11_13_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_11_chunk
    ADD CONSTRAINT "11_13_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_120_chunk 120_167_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_120_chunk
    ADD CONSTRAINT "120_167_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_122_chunk 122_169_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_122_chunk
    ADD CONSTRAINT "122_169_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_124_chunk 124_171_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_124_chunk
    ADD CONSTRAINT "124_171_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_126_chunk 126_173_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_126_chunk
    ADD CONSTRAINT "126_173_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_128_chunk 128_175_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_128_chunk
    ADD CONSTRAINT "128_175_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_12_chunk 12_15_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_12_chunk
    ADD CONSTRAINT "12_15_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_130_chunk 130_177_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_130_chunk
    ADD CONSTRAINT "130_177_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_132_chunk 132_179_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_132_chunk
    ADD CONSTRAINT "132_179_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_134_chunk 134_181_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_134_chunk
    ADD CONSTRAINT "134_181_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_136_chunk 136_183_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_136_chunk
    ADD CONSTRAINT "136_183_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_137_chunk 137_185_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_137_chunk
    ADD CONSTRAINT "137_185_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_139_chunk 139_187_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_139_chunk
    ADD CONSTRAINT "139_187_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_141_chunk 141_189_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_141_chunk
    ADD CONSTRAINT "141_189_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_143_chunk 143_191_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_143_chunk
    ADD CONSTRAINT "143_191_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_144_chunk 144_193_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_144_chunk
    ADD CONSTRAINT "144_193_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_145_chunk 145_195_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_145_chunk
    ADD CONSTRAINT "145_195_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_147_chunk 147_197_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_147_chunk
    ADD CONSTRAINT "147_197_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_148_chunk 148_199_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_148_chunk
    ADD CONSTRAINT "148_199_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_14_chunk 14_17_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_14_chunk
    ADD CONSTRAINT "14_17_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_150_chunk 150_201_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_150_chunk
    ADD CONSTRAINT "150_201_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_152_chunk 152_203_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_152_chunk
    ADD CONSTRAINT "152_203_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_153_chunk 153_205_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_153_chunk
    ADD CONSTRAINT "153_205_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_154_chunk 154_207_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_154_chunk
    ADD CONSTRAINT "154_207_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_156_chunk 156_209_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_156_chunk
    ADD CONSTRAINT "156_209_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_157_chunk 157_211_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_157_chunk
    ADD CONSTRAINT "157_211_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_158_chunk 158_213_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_158_chunk
    ADD CONSTRAINT "158_213_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_15_chunk 15_19_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_15_chunk
    ADD CONSTRAINT "15_19_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_160_chunk 160_215_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_160_chunk
    ADD CONSTRAINT "160_215_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_161_chunk 161_217_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_161_chunk
    ADD CONSTRAINT "161_217_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_163_chunk 163_219_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_163_chunk
    ADD CONSTRAINT "163_219_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_164_chunk 164_221_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_164_chunk
    ADD CONSTRAINT "164_221_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_166_chunk 166_223_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_166_chunk
    ADD CONSTRAINT "166_223_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_167_chunk 167_225_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_167_chunk
    ADD CONSTRAINT "167_225_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_169_chunk 169_227_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_169_chunk
    ADD CONSTRAINT "169_227_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_170_chunk 170_229_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk
    ADD CONSTRAINT "170_229_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_171_chunk 171_231_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_171_chunk
    ADD CONSTRAINT "171_231_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_173_chunk 173_233_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_173_chunk
    ADD CONSTRAINT "173_233_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_174_chunk 174_235_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk
    ADD CONSTRAINT "174_235_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_175_chunk 175_237_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_175_chunk
    ADD CONSTRAINT "175_237_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_176_chunk 176_239_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_176_chunk
    ADD CONSTRAINT "176_239_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_177_chunk 177_241_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk
    ADD CONSTRAINT "177_241_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_178_chunk 178_243_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_178_chunk
    ADD CONSTRAINT "178_243_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_179_chunk 179_245_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_179_chunk
    ADD CONSTRAINT "179_245_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_17_chunk 17_21_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_17_chunk
    ADD CONSTRAINT "17_21_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_180_chunk 180_247_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk
    ADD CONSTRAINT "180_247_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_181_chunk 181_249_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_181_chunk
    ADD CONSTRAINT "181_249_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_182_chunk 182_251_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_182_chunk
    ADD CONSTRAINT "182_251_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_183_chunk 183_253_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk
    ADD CONSTRAINT "183_253_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_184_chunk 184_255_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_184_chunk
    ADD CONSTRAINT "184_255_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_185_chunk 185_257_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_185_chunk
    ADD CONSTRAINT "185_257_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_186_chunk 186_259_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk
    ADD CONSTRAINT "186_259_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_187_chunk 187_261_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_187_chunk
    ADD CONSTRAINT "187_261_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_188_chunk 188_263_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_188_chunk
    ADD CONSTRAINT "188_263_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_189_chunk 189_265_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk
    ADD CONSTRAINT "189_265_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_18_chunk 18_23_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_18_chunk
    ADD CONSTRAINT "18_23_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_190_chunk 190_267_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_190_chunk
    ADD CONSTRAINT "190_267_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_191_chunk 191_269_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_191_chunk
    ADD CONSTRAINT "191_269_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_192_chunk 192_271_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk
    ADD CONSTRAINT "192_271_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_194_chunk 194_273_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_194_chunk
    ADD CONSTRAINT "194_273_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_195_chunk 195_275_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_195_chunk
    ADD CONSTRAINT "195_275_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_196_chunk 196_277_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_196_chunk
    ADD CONSTRAINT "196_277_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_197_chunk 197_279_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_197_chunk
    ADD CONSTRAINT "197_279_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_198_chunk 198_281_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk
    ADD CONSTRAINT "198_281_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_199_chunk 199_283_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_199_chunk
    ADD CONSTRAINT "199_283_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_1_chunk 1_1_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1_chunk
    ADD CONSTRAINT "1_1_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_200_chunk 200_285_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_200_chunk
    ADD CONSTRAINT "200_285_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_201_chunk 201_287_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk
    ADD CONSTRAINT "201_287_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_202_chunk 202_289_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_202_chunk
    ADD CONSTRAINT "202_289_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_203_chunk 203_291_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_203_chunk
    ADD CONSTRAINT "203_291_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_204_chunk 204_293_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_204_chunk
    ADD CONSTRAINT "204_293_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_205_chunk 205_295_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_205_chunk
    ADD CONSTRAINT "205_295_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_206_chunk 206_297_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_206_chunk
    ADD CONSTRAINT "206_297_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_207_chunk 207_299_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_207_chunk
    ADD CONSTRAINT "207_299_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_208_chunk 208_301_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_208_chunk
    ADD CONSTRAINT "208_301_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_209_chunk 209_303_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_209_chunk
    ADD CONSTRAINT "209_303_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_20_chunk 20_25_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_20_chunk
    ADD CONSTRAINT "20_25_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_210_chunk 210_305_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_210_chunk
    ADD CONSTRAINT "210_305_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_211_chunk 211_307_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_211_chunk
    ADD CONSTRAINT "211_307_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_212_chunk 212_309_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_212_chunk
    ADD CONSTRAINT "212_309_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_213_chunk 213_311_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_213_chunk
    ADD CONSTRAINT "213_311_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_214_chunk 214_313_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_214_chunk
    ADD CONSTRAINT "214_313_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_215_chunk 215_315_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_215_chunk
    ADD CONSTRAINT "215_315_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_216_chunk 216_317_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_216_chunk
    ADD CONSTRAINT "216_317_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_217_chunk 217_319_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_217_chunk
    ADD CONSTRAINT "217_319_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_218_chunk 218_321_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_218_chunk
    ADD CONSTRAINT "218_321_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_219_chunk 219_323_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_219_chunk
    ADD CONSTRAINT "219_323_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_21_chunk 21_27_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_21_chunk
    ADD CONSTRAINT "21_27_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_220_chunk 220_325_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_220_chunk
    ADD CONSTRAINT "220_325_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_221_chunk 221_327_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_221_chunk
    ADD CONSTRAINT "221_327_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_222_chunk 222_329_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_222_chunk
    ADD CONSTRAINT "222_329_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_223_chunk 223_331_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_223_chunk
    ADD CONSTRAINT "223_331_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_224_chunk 224_333_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_224_chunk
    ADD CONSTRAINT "224_333_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_225_chunk 225_335_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_225_chunk
    ADD CONSTRAINT "225_335_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_226_chunk 226_337_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_226_chunk
    ADD CONSTRAINT "226_337_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_227_chunk 227_339_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_227_chunk
    ADD CONSTRAINT "227_339_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_228_chunk 228_341_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_228_chunk
    ADD CONSTRAINT "228_341_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_229_chunk 229_343_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_229_chunk
    ADD CONSTRAINT "229_343_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_230_chunk 230_345_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_230_chunk
    ADD CONSTRAINT "230_345_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_231_chunk 231_347_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_231_chunk
    ADD CONSTRAINT "231_347_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_232_chunk 232_349_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_232_chunk
    ADD CONSTRAINT "232_349_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_233_chunk 233_351_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_233_chunk
    ADD CONSTRAINT "233_351_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_234_chunk 234_353_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_234_chunk
    ADD CONSTRAINT "234_353_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_235_chunk 235_355_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_235_chunk
    ADD CONSTRAINT "235_355_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_236_chunk 236_357_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_236_chunk
    ADD CONSTRAINT "236_357_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_237_chunk 237_359_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_237_chunk
    ADD CONSTRAINT "237_359_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_238_chunk 238_361_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_238_chunk
    ADD CONSTRAINT "238_361_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_239_chunk 239_363_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_239_chunk
    ADD CONSTRAINT "239_363_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_23_chunk 23_29_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_23_chunk
    ADD CONSTRAINT "23_29_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_240_chunk 240_365_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_240_chunk
    ADD CONSTRAINT "240_365_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_241_chunk 241_367_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_241_chunk
    ADD CONSTRAINT "241_367_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_242_chunk 242_369_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_242_chunk
    ADD CONSTRAINT "242_369_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_243_chunk 243_371_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_243_chunk
    ADD CONSTRAINT "243_371_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_244_chunk 244_373_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_244_chunk
    ADD CONSTRAINT "244_373_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_245_chunk 245_375_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_245_chunk
    ADD CONSTRAINT "245_375_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_246_chunk 246_377_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_246_chunk
    ADD CONSTRAINT "246_377_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_247_chunk 247_379_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_247_chunk
    ADD CONSTRAINT "247_379_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_248_chunk 248_381_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_248_chunk
    ADD CONSTRAINT "248_381_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_249_chunk 249_383_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_249_chunk
    ADD CONSTRAINT "249_383_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_24_chunk 24_31_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_24_chunk
    ADD CONSTRAINT "24_31_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_250_chunk 250_385_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_250_chunk
    ADD CONSTRAINT "250_385_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_251_chunk 251_387_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_251_chunk
    ADD CONSTRAINT "251_387_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_252_chunk 252_389_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_252_chunk
    ADD CONSTRAINT "252_389_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_253_chunk 253_391_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_253_chunk
    ADD CONSTRAINT "253_391_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_254_chunk 254_393_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_254_chunk
    ADD CONSTRAINT "254_393_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_255_chunk 255_395_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_255_chunk
    ADD CONSTRAINT "255_395_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_256_chunk 256_397_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_256_chunk
    ADD CONSTRAINT "256_397_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_257_chunk 257_399_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_257_chunk
    ADD CONSTRAINT "257_399_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_258_chunk 258_401_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_258_chunk
    ADD CONSTRAINT "258_401_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_259_chunk 259_403_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_259_chunk
    ADD CONSTRAINT "259_403_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_260_chunk 260_405_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_260_chunk
    ADD CONSTRAINT "260_405_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_261_chunk 261_407_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_261_chunk
    ADD CONSTRAINT "261_407_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_262_chunk 262_409_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_262_chunk
    ADD CONSTRAINT "262_409_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_263_chunk 263_411_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_263_chunk
    ADD CONSTRAINT "263_411_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_264_chunk 264_413_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_264_chunk
    ADD CONSTRAINT "264_413_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_265_chunk 265_415_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_265_chunk
    ADD CONSTRAINT "265_415_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_266_chunk 266_417_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_266_chunk
    ADD CONSTRAINT "266_417_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_267_chunk 267_419_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_267_chunk
    ADD CONSTRAINT "267_419_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_268_chunk 268_421_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_268_chunk
    ADD CONSTRAINT "268_421_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_26_chunk 26_35_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_26_chunk
    ADD CONSTRAINT "26_35_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_287_chunk 287_423_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_287_chunk
    ADD CONSTRAINT "287_423_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_288_chunk 288_425_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_288_chunk
    ADD CONSTRAINT "288_425_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_28_chunk 28_37_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_28_chunk
    ADD CONSTRAINT "28_37_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_290_chunk 290_427_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_290_chunk
    ADD CONSTRAINT "290_427_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_291_chunk 291_429_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_291_chunk
    ADD CONSTRAINT "291_429_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_292_chunk 292_431_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_292_chunk
    ADD CONSTRAINT "292_431_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_294_chunk 294_433_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_294_chunk
    ADD CONSTRAINT "294_433_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_295_chunk 295_435_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_295_chunk
    ADD CONSTRAINT "295_435_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_296_chunk 296_437_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_296_chunk
    ADD CONSTRAINT "296_437_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_297_chunk 297_439_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_297_chunk
    ADD CONSTRAINT "297_439_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_298_chunk 298_441_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_298_chunk
    ADD CONSTRAINT "298_441_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_299_chunk 299_443_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_299_chunk
    ADD CONSTRAINT "299_443_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_29_chunk 29_39_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_29_chunk
    ADD CONSTRAINT "29_39_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_2_chunk 2_3_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_2_chunk
    ADD CONSTRAINT "2_3_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_300_chunk 300_445_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_300_chunk
    ADD CONSTRAINT "300_445_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_301_chunk 301_447_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_301_chunk
    ADD CONSTRAINT "301_447_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_302_chunk 302_449_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_302_chunk
    ADD CONSTRAINT "302_449_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_30_chunk 30_41_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_30_chunk
    ADD CONSTRAINT "30_41_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_32_chunk 32_43_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_32_chunk
    ADD CONSTRAINT "32_43_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_33_chunk 33_45_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_33_chunk
    ADD CONSTRAINT "33_45_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_34_chunk 34_47_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_34_chunk
    ADD CONSTRAINT "34_47_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_35_chunk 35_49_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_35_chunk
    ADD CONSTRAINT "35_49_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_36_chunk 36_51_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_36_chunk
    ADD CONSTRAINT "36_51_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_37_chunk 37_53_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_37_chunk
    ADD CONSTRAINT "37_53_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_39_chunk 39_55_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_39_chunk
    ADD CONSTRAINT "39_55_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_3_chunk 3_5_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_3_chunk
    ADD CONSTRAINT "3_5_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_41_chunk 41_57_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_41_chunk
    ADD CONSTRAINT "41_57_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_42_chunk 42_59_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_42_chunk
    ADD CONSTRAINT "42_59_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_43_chunk 43_61_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_43_chunk
    ADD CONSTRAINT "43_61_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_45_chunk 45_63_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_45_chunk
    ADD CONSTRAINT "45_63_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_46_chunk 46_65_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_46_chunk
    ADD CONSTRAINT "46_65_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_48_chunk 48_67_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_48_chunk
    ADD CONSTRAINT "48_67_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_49_chunk 49_69_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_49_chunk
    ADD CONSTRAINT "49_69_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_4_chunk 4_7_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_4_chunk
    ADD CONSTRAINT "4_7_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_50_chunk 50_71_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_50_chunk
    ADD CONSTRAINT "50_71_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_51_chunk 51_73_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_51_chunk
    ADD CONSTRAINT "51_73_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_52_chunk 52_75_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_52_chunk
    ADD CONSTRAINT "52_75_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_53_chunk 53_77_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_53_chunk
    ADD CONSTRAINT "53_77_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_56_chunk 56_79_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_56_chunk
    ADD CONSTRAINT "56_79_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_57_chunk 57_81_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_57_chunk
    ADD CONSTRAINT "57_81_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_58_chunk 58_83_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_58_chunk
    ADD CONSTRAINT "58_83_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_5_chunk 5_9_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_5_chunk
    ADD CONSTRAINT "5_9_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_60_chunk 60_85_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_60_chunk
    ADD CONSTRAINT "60_85_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_61_chunk 61_87_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_61_chunk
    ADD CONSTRAINT "61_87_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_62_chunk 62_89_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_62_chunk
    ADD CONSTRAINT "62_89_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_64_chunk 64_91_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_64_chunk
    ADD CONSTRAINT "64_91_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_65_chunk 65_93_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_65_chunk
    ADD CONSTRAINT "65_93_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_66_chunk 66_95_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_66_chunk
    ADD CONSTRAINT "66_95_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_68_chunk 68_97_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_68_chunk
    ADD CONSTRAINT "68_97_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_69_chunk 69_99_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_69_chunk
    ADD CONSTRAINT "69_99_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_1_6_chunk 6_11_energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_6_chunk
    ADD CONSTRAINT "6_11_energy_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_70_chunk 70_101_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_70_chunk
    ADD CONSTRAINT "70_101_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_71_chunk 71_103_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_71_chunk
    ADD CONSTRAINT "71_103_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_74_chunk 74_105_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_74_chunk
    ADD CONSTRAINT "74_105_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_75_chunk 75_107_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_75_chunk
    ADD CONSTRAINT "75_107_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_77_chunk 77_109_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_77_chunk
    ADD CONSTRAINT "77_109_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_78_chunk 78_111_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_78_chunk
    ADD CONSTRAINT "78_111_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_79_chunk 79_113_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_79_chunk
    ADD CONSTRAINT "79_113_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_81_chunk 81_115_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_81_chunk
    ADD CONSTRAINT "81_115_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_83_chunk 83_117_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_83_chunk
    ADD CONSTRAINT "83_117_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_84_chunk 84_119_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_84_chunk
    ADD CONSTRAINT "84_119_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_86_chunk 86_121_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_86_chunk
    ADD CONSTRAINT "86_121_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_87_chunk 87_123_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_87_chunk
    ADD CONSTRAINT "87_123_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_89_chunk 89_125_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_89_chunk
    ADD CONSTRAINT "89_125_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_90_chunk 90_127_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_90_chunk
    ADD CONSTRAINT "90_127_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_92_chunk 92_129_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_92_chunk
    ADD CONSTRAINT "92_129_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_93_chunk 93_131_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_93_chunk
    ADD CONSTRAINT "93_131_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_95_chunk 95_133_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_95_chunk
    ADD CONSTRAINT "95_133_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_96_chunk 96_135_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_96_chunk
    ADD CONSTRAINT "96_135_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_2_97_chunk 97_137_printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_97_chunk
    ADD CONSTRAINT "97_137_printer_status_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _hyper_3_99_chunk 99_139_environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_99_chunk
    ADD CONSTRAINT "99_139_environment_data_device_id_fkey" FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: energy_data energy_data_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.energy_data
    ADD CONSTRAINT energy_data_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: environment_data environment_data_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.environment_data
    ADD CONSTRAINT environment_data_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: print_jobs print_jobs_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.print_jobs
    ADD CONSTRAINT print_jobs_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id);


--
-- Name: printer_status printer_status_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.printer_status
    ADD CONSTRAINT printer_status_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(device_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


-- Add TimescaleDB Extension and create Hypertables
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- === Convert Verified Time-Series Tables to Hypertables ===
SELECT create_hypertable('energy_data', 'timestamp');
SELECT create_hypertable('environment_data', 'timestamp');
SELECT create_hypertable('ml_predictions', 'timestamp');
SELECT create_hypertable('printer_status', 'timestamp');

