--
-- PostgreSQL database dump
--

\restrict 0oYzE0cdFISZnb3acZxb6yUGfkzNxdeRZbMJJDRKWWK7FQqHmwRLZSVYddxtZMZ

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fy_2023_2024; Type: SCHEMA; Schema: -; Owner: orbx
--

CREATE SCHEMA fy_2023_2024;


ALTER SCHEMA fy_2023_2024 OWNER TO orbx;

--
-- Name: fy_2024_2025; Type: SCHEMA; Schema: -; Owner: orbx
--

CREATE SCHEMA fy_2024_2025;


ALTER SCHEMA fy_2024_2025 OWNER TO orbx;

--
-- Name: fy_2025_2026; Type: SCHEMA; Schema: -; Owner: orbx
--

CREATE SCHEMA fy_2025_2026;


ALTER SCHEMA fy_2025_2026 OWNER TO orbx;

--
-- Name: fy_2026_2027; Type: SCHEMA; Schema: -; Owner: orbx
--

CREATE SCHEMA fy_2026_2027;


ALTER SCHEMA fy_2026_2027 OWNER TO orbx;

--
-- Name: master; Type: SCHEMA; Schema: -; Owner: orbx
--

CREATE SCHEMA master;


ALTER SCHEMA master OWNER TO orbx;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: advance_payments; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.advance_payments (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    payment_type character varying(20) NOT NULL,
    ledger_type character varying(20) NOT NULL,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.advance_payments OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.advance_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.advance_payments_id_seq OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.advance_payments_id_seq OWNED BY fy_2023_2024.advance_payments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.audit_logs (
    id integer NOT NULL,
    user_id integer,
    username character varying(100),
    action character varying(50) NOT NULL,
    module character varying(50),
    record_id integer,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.audit_logs OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.audit_logs_id_seq OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.audit_logs_id_seq OWNED BY fy_2023_2024.audit_logs.id;


--
-- Name: biometric_entries; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.biometric_entries (
    id integer NOT NULL,
    ledger_id integer NOT NULL,
    entry_date date NOT NULL,
    punch_in time without time zone,
    punch_out time without time zone,
    hours_worked numeric(5,2),
    status character varying(20) DEFAULT 'Present'::character varying,
    device_log_id character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.biometric_entries OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.biometric_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.biometric_entries_id_seq OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.biometric_entries_id_seq OWNED BY fy_2023_2024.biometric_entries.id;


--
-- Name: eb_readings; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.eb_readings (
    id integer NOT NULL,
    reading_date date NOT NULL,
    meter_no character varying(50),
    previous_reading numeric(15,3) DEFAULT 0,
    current_reading numeric(15,3) DEFAULT 0,
    units_consumed numeric(15,3) DEFAULT 0,
    rate_per_unit numeric(10,4) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.eb_readings OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.eb_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.eb_readings_id_seq OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.eb_readings_id_seq OWNED BY fy_2023_2024.eb_readings.id;


--
-- Name: job_work_entries; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.job_work_entries (
    id integer NOT NULL,
    entry_no character varying(50) NOT NULL,
    entry_date date NOT NULL,
    ledger_id integer NOT NULL,
    product_id integer,
    process_id integer,
    rate_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    entry_type character varying(20) NOT NULL,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.job_work_entries OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.job_work_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.job_work_entries_id_seq OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.job_work_entries_id_seq OWNED BY fy_2023_2024.job_work_entries.id;


--
-- Name: labour_bills; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.labour_bills (
    id integer NOT NULL,
    bill_no character varying(50) NOT NULL,
    bill_date date NOT NULL,
    ledger_id integer NOT NULL,
    inward_id integer,
    product_id integer,
    process_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    gst_percent numeric(5,2) DEFAULT 0,
    gst_amount numeric(15,2) DEFAULT 0,
    cgst_percent numeric(5,2) DEFAULT 0,
    cgst_amount numeric(15,2) DEFAULT 0,
    sgst_percent numeric(5,2) DEFAULT 0,
    sgst_amount numeric(15,2) DEFAULT 0,
    round_off numeric(15,2) DEFAULT 0,
    net_amount numeric(15,2) DEFAULT 0,
    total_amount numeric(15,2) DEFAULT 0,
    narration text,
    is_paid boolean DEFAULT false,
    payment_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    items jsonb DEFAULT '[]'::jsonb,
    outward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255)
);


ALTER TABLE fy_2023_2024.labour_bills OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.labour_bills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.labour_bills_id_seq OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.labour_bills_id_seq OWNED BY fy_2023_2024.labour_bills.id;


--
-- Name: salary_vouchers; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.salary_vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    days_worked numeric(5,1) DEFAULT 0,
    basic_salary numeric(15,2) DEFAULT 0,
    allowances numeric(15,2) DEFAULT 0,
    deductions numeric(15,2) DEFAULT 0,
    net_salary numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.salary_vouchers OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.salary_vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.salary_vouchers_id_seq OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.salary_vouchers_id_seq OWNED BY fy_2023_2024.salary_vouchers.id;


--
-- Name: stock_adjustments; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.stock_adjustments (
    id integer NOT NULL,
    adjustment_no character varying(50) NOT NULL,
    adjustment_date date NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(15,3) NOT NULL,
    reason text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.stock_adjustments OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.stock_adjustments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.stock_adjustments_id_seq OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.stock_adjustments_id_seq OWNED BY fy_2023_2024.stock_adjustments.id;


--
-- Name: stock_inward; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.stock_inward (
    id integer NOT NULL,
    inward_no character varying(50) NOT NULL,
    inward_date date NOT NULL,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    narration text,
    serial_no character varying(100),
    ref_no character varying(100),
    ref_date date,
    expected_duration_days integer,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    items jsonb DEFAULT '[]'::jsonb,
    is_completed boolean DEFAULT false,
    completed_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.stock_inward OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.stock_inward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.stock_inward_id_seq OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.stock_inward_id_seq OWNED BY fy_2023_2024.stock_inward.id;


--
-- Name: stock_item_movements; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.stock_item_movements (
    id integer NOT NULL,
    movement_no character varying(50) NOT NULL,
    movement_date date NOT NULL,
    movement_type character varying(10) NOT NULL,
    stock_item_id integer NOT NULL,
    ledger_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.stock_item_movements OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.stock_item_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.stock_item_movements_id_seq OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.stock_item_movements_id_seq OWNED BY fy_2023_2024.stock_item_movements.id;


--
-- Name: stock_outward; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.stock_outward (
    id integer NOT NULL,
    outward_no character varying(50) NOT NULL,
    outward_date date NOT NULL,
    inward_id integer,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    uom_id integer,
    serial_no character varying(100),
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    inward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.stock_outward OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.stock_outward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.stock_outward_id_seq OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.stock_outward_id_seq OWNED BY fy_2023_2024.stock_outward.id;


--
-- Name: stock_transfer; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.stock_transfer (
    id integer NOT NULL,
    transfer_no character varying(50) NOT NULL,
    transfer_date date NOT NULL,
    from_stock_item_id integer NOT NULL,
    to_stock_item_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.stock_transfer OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.stock_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.stock_transfer_id_seq OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.stock_transfer_id_seq OWNED BY fy_2023_2024.stock_transfer.id;


--
-- Name: voucher_lines; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.voucher_lines (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    ledger_id integer NOT NULL,
    dr_amount numeric(15,2) DEFAULT 0,
    cr_amount numeric(15,2) DEFAULT 0,
    narration text
);


ALTER TABLE fy_2023_2024.voucher_lines OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.voucher_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.voucher_lines_id_seq OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.voucher_lines_id_seq OWNED BY fy_2023_2024.voucher_lines.id;


--
-- Name: vouchers; Type: TABLE; Schema: fy_2023_2024; Owner: orbx
--

CREATE TABLE fy_2023_2024.vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_type character varying(30) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    amount numeric(15,2) DEFAULT 0 NOT NULL,
    narration text,
    ref_no character varying(100),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2023_2024.vouchers OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: fy_2023_2024; Owner: orbx
--

CREATE SEQUENCE fy_2023_2024.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2023_2024.vouchers_id_seq OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2023_2024; Owner: orbx
--

ALTER SEQUENCE fy_2023_2024.vouchers_id_seq OWNED BY fy_2023_2024.vouchers.id;


--
-- Name: advance_payments; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.advance_payments (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    payment_type character varying(20) NOT NULL,
    ledger_type character varying(20) NOT NULL,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.advance_payments OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.advance_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.advance_payments_id_seq OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.advance_payments_id_seq OWNED BY fy_2024_2025.advance_payments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.audit_logs (
    id integer NOT NULL,
    user_id integer,
    username character varying(100),
    action character varying(50) NOT NULL,
    module character varying(50),
    record_id integer,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.audit_logs OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.audit_logs_id_seq OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.audit_logs_id_seq OWNED BY fy_2024_2025.audit_logs.id;


--
-- Name: biometric_entries; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.biometric_entries (
    id integer NOT NULL,
    ledger_id integer NOT NULL,
    entry_date date NOT NULL,
    punch_in time without time zone,
    punch_out time without time zone,
    hours_worked numeric(5,2),
    status character varying(20) DEFAULT 'Present'::character varying,
    device_log_id character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.biometric_entries OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.biometric_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.biometric_entries_id_seq OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.biometric_entries_id_seq OWNED BY fy_2024_2025.biometric_entries.id;


--
-- Name: eb_readings; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.eb_readings (
    id integer NOT NULL,
    reading_date date NOT NULL,
    meter_no character varying(50),
    previous_reading numeric(15,3) DEFAULT 0,
    current_reading numeric(15,3) DEFAULT 0,
    units_consumed numeric(15,3) DEFAULT 0,
    rate_per_unit numeric(10,4) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.eb_readings OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.eb_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.eb_readings_id_seq OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.eb_readings_id_seq OWNED BY fy_2024_2025.eb_readings.id;


--
-- Name: job_work_entries; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.job_work_entries (
    id integer NOT NULL,
    entry_no character varying(50) NOT NULL,
    entry_date date NOT NULL,
    ledger_id integer NOT NULL,
    product_id integer,
    process_id integer,
    rate_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    entry_type character varying(20) NOT NULL,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.job_work_entries OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.job_work_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.job_work_entries_id_seq OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.job_work_entries_id_seq OWNED BY fy_2024_2025.job_work_entries.id;


--
-- Name: labour_bills; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.labour_bills (
    id integer NOT NULL,
    bill_no character varying(50) NOT NULL,
    bill_date date NOT NULL,
    ledger_id integer NOT NULL,
    inward_id integer,
    product_id integer,
    process_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    gst_percent numeric(5,2) DEFAULT 0,
    gst_amount numeric(15,2) DEFAULT 0,
    cgst_percent numeric(5,2) DEFAULT 0,
    cgst_amount numeric(15,2) DEFAULT 0,
    sgst_percent numeric(5,2) DEFAULT 0,
    sgst_amount numeric(15,2) DEFAULT 0,
    round_off numeric(15,2) DEFAULT 0,
    net_amount numeric(15,2) DEFAULT 0,
    total_amount numeric(15,2) DEFAULT 0,
    narration text,
    is_paid boolean DEFAULT false,
    payment_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    items jsonb DEFAULT '[]'::jsonb,
    outward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255)
);


ALTER TABLE fy_2024_2025.labour_bills OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.labour_bills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.labour_bills_id_seq OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.labour_bills_id_seq OWNED BY fy_2024_2025.labour_bills.id;


--
-- Name: salary_vouchers; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.salary_vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    days_worked numeric(5,1) DEFAULT 0,
    basic_salary numeric(15,2) DEFAULT 0,
    allowances numeric(15,2) DEFAULT 0,
    deductions numeric(15,2) DEFAULT 0,
    net_salary numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.salary_vouchers OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.salary_vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.salary_vouchers_id_seq OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.salary_vouchers_id_seq OWNED BY fy_2024_2025.salary_vouchers.id;


--
-- Name: stock_adjustments; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.stock_adjustments (
    id integer NOT NULL,
    adjustment_no character varying(50) NOT NULL,
    adjustment_date date NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(15,3) NOT NULL,
    reason text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.stock_adjustments OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.stock_adjustments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.stock_adjustments_id_seq OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.stock_adjustments_id_seq OWNED BY fy_2024_2025.stock_adjustments.id;


--
-- Name: stock_inward; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.stock_inward (
    id integer NOT NULL,
    inward_no character varying(50) NOT NULL,
    inward_date date NOT NULL,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    narration text,
    serial_no character varying(100),
    ref_no character varying(100),
    ref_date date,
    expected_duration_days integer,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    items jsonb DEFAULT '[]'::jsonb,
    is_completed boolean DEFAULT false,
    completed_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.stock_inward OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.stock_inward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.stock_inward_id_seq OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.stock_inward_id_seq OWNED BY fy_2024_2025.stock_inward.id;


--
-- Name: stock_item_movements; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.stock_item_movements (
    id integer NOT NULL,
    movement_no character varying(50) NOT NULL,
    movement_date date NOT NULL,
    movement_type character varying(10) NOT NULL,
    stock_item_id integer NOT NULL,
    ledger_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.stock_item_movements OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.stock_item_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.stock_item_movements_id_seq OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.stock_item_movements_id_seq OWNED BY fy_2024_2025.stock_item_movements.id;


--
-- Name: stock_outward; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.stock_outward (
    id integer NOT NULL,
    outward_no character varying(50) NOT NULL,
    outward_date date NOT NULL,
    inward_id integer,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    uom_id integer,
    serial_no character varying(100),
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    inward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.stock_outward OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.stock_outward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.stock_outward_id_seq OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.stock_outward_id_seq OWNED BY fy_2024_2025.stock_outward.id;


--
-- Name: stock_transfer; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.stock_transfer (
    id integer NOT NULL,
    transfer_no character varying(50) NOT NULL,
    transfer_date date NOT NULL,
    from_stock_item_id integer NOT NULL,
    to_stock_item_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.stock_transfer OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.stock_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.stock_transfer_id_seq OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.stock_transfer_id_seq OWNED BY fy_2024_2025.stock_transfer.id;


--
-- Name: voucher_lines; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.voucher_lines (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    ledger_id integer NOT NULL,
    dr_amount numeric(15,2) DEFAULT 0,
    cr_amount numeric(15,2) DEFAULT 0,
    narration text
);


ALTER TABLE fy_2024_2025.voucher_lines OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.voucher_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.voucher_lines_id_seq OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.voucher_lines_id_seq OWNED BY fy_2024_2025.voucher_lines.id;


--
-- Name: vouchers; Type: TABLE; Schema: fy_2024_2025; Owner: orbx
--

CREATE TABLE fy_2024_2025.vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_type character varying(30) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    amount numeric(15,2) DEFAULT 0 NOT NULL,
    narration text,
    ref_no character varying(100),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2024_2025.vouchers OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: fy_2024_2025; Owner: orbx
--

CREATE SEQUENCE fy_2024_2025.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2024_2025.vouchers_id_seq OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2024_2025; Owner: orbx
--

ALTER SEQUENCE fy_2024_2025.vouchers_id_seq OWNED BY fy_2024_2025.vouchers.id;


--
-- Name: advance_payments; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.advance_payments (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    payment_type character varying(20) NOT NULL,
    ledger_type character varying(20) NOT NULL,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.advance_payments OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.advance_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.advance_payments_id_seq OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.advance_payments_id_seq OWNED BY fy_2025_2026.advance_payments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.audit_logs (
    id integer NOT NULL,
    user_id integer,
    username character varying(100),
    action character varying(50) NOT NULL,
    module character varying(50),
    record_id integer,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.audit_logs OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.audit_logs_id_seq OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.audit_logs_id_seq OWNED BY fy_2025_2026.audit_logs.id;


--
-- Name: biometric_entries; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.biometric_entries (
    id integer NOT NULL,
    ledger_id integer NOT NULL,
    entry_date date NOT NULL,
    punch_in time without time zone,
    punch_out time without time zone,
    hours_worked numeric(5,2),
    status character varying(20) DEFAULT 'Present'::character varying,
    device_log_id character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.biometric_entries OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.biometric_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.biometric_entries_id_seq OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.biometric_entries_id_seq OWNED BY fy_2025_2026.biometric_entries.id;


--
-- Name: eb_readings; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.eb_readings (
    id integer NOT NULL,
    reading_date date NOT NULL,
    meter_no character varying(50),
    previous_reading numeric(15,3) DEFAULT 0,
    current_reading numeric(15,3) DEFAULT 0,
    units_consumed numeric(15,3) DEFAULT 0,
    rate_per_unit numeric(10,4) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.eb_readings OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.eb_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.eb_readings_id_seq OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.eb_readings_id_seq OWNED BY fy_2025_2026.eb_readings.id;


--
-- Name: job_work_entries; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.job_work_entries (
    id integer NOT NULL,
    entry_no character varying(50) NOT NULL,
    entry_date date NOT NULL,
    ledger_id integer NOT NULL,
    product_id integer,
    process_id integer,
    rate_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    entry_type character varying(20) NOT NULL,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.job_work_entries OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.job_work_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.job_work_entries_id_seq OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.job_work_entries_id_seq OWNED BY fy_2025_2026.job_work_entries.id;


--
-- Name: labour_bills; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.labour_bills (
    id integer NOT NULL,
    bill_no character varying(50) NOT NULL,
    bill_date date NOT NULL,
    ledger_id integer NOT NULL,
    inward_id integer,
    product_id integer,
    process_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    gst_percent numeric(5,2) DEFAULT 0,
    gst_amount numeric(15,2) DEFAULT 0,
    cgst_percent numeric(5,2) DEFAULT 0,
    cgst_amount numeric(15,2) DEFAULT 0,
    sgst_percent numeric(5,2) DEFAULT 0,
    sgst_amount numeric(15,2) DEFAULT 0,
    round_off numeric(15,2) DEFAULT 0,
    net_amount numeric(15,2) DEFAULT 0,
    total_amount numeric(15,2) DEFAULT 0,
    narration text,
    is_paid boolean DEFAULT false,
    payment_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    items jsonb DEFAULT '[]'::jsonb,
    outward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255)
);


ALTER TABLE fy_2025_2026.labour_bills OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.labour_bills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.labour_bills_id_seq OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.labour_bills_id_seq OWNED BY fy_2025_2026.labour_bills.id;


--
-- Name: salary_vouchers; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.salary_vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    days_worked numeric(5,1) DEFAULT 0,
    basic_salary numeric(15,2) DEFAULT 0,
    allowances numeric(15,2) DEFAULT 0,
    deductions numeric(15,2) DEFAULT 0,
    net_salary numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.salary_vouchers OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.salary_vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.salary_vouchers_id_seq OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.salary_vouchers_id_seq OWNED BY fy_2025_2026.salary_vouchers.id;


--
-- Name: stock_adjustments; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.stock_adjustments (
    id integer NOT NULL,
    adjustment_no character varying(50) NOT NULL,
    adjustment_date date NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(15,3) NOT NULL,
    reason text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.stock_adjustments OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.stock_adjustments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.stock_adjustments_id_seq OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.stock_adjustments_id_seq OWNED BY fy_2025_2026.stock_adjustments.id;


--
-- Name: stock_inward; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.stock_inward (
    id integer NOT NULL,
    inward_no character varying(50) NOT NULL,
    inward_date date NOT NULL,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    narration text,
    serial_no character varying(100),
    ref_no character varying(100),
    ref_date date,
    expected_duration_days integer,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    items jsonb DEFAULT '[]'::jsonb,
    is_completed boolean DEFAULT false,
    completed_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.stock_inward OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.stock_inward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.stock_inward_id_seq OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.stock_inward_id_seq OWNED BY fy_2025_2026.stock_inward.id;


--
-- Name: stock_item_movements; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.stock_item_movements (
    id integer NOT NULL,
    movement_no character varying(50) NOT NULL,
    movement_date date NOT NULL,
    movement_type character varying(10) NOT NULL,
    stock_item_id integer NOT NULL,
    ledger_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.stock_item_movements OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.stock_item_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.stock_item_movements_id_seq OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.stock_item_movements_id_seq OWNED BY fy_2025_2026.stock_item_movements.id;


--
-- Name: stock_outward; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.stock_outward (
    id integer NOT NULL,
    outward_no character varying(50) NOT NULL,
    outward_date date NOT NULL,
    inward_id integer,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    uom_id integer,
    serial_no character varying(100),
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    inward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.stock_outward OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.stock_outward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.stock_outward_id_seq OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.stock_outward_id_seq OWNED BY fy_2025_2026.stock_outward.id;


--
-- Name: stock_transfer; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.stock_transfer (
    id integer NOT NULL,
    transfer_no character varying(50) NOT NULL,
    transfer_date date NOT NULL,
    from_stock_item_id integer NOT NULL,
    to_stock_item_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.stock_transfer OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.stock_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.stock_transfer_id_seq OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.stock_transfer_id_seq OWNED BY fy_2025_2026.stock_transfer.id;


--
-- Name: voucher_lines; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.voucher_lines (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    ledger_id integer NOT NULL,
    dr_amount numeric(15,2) DEFAULT 0,
    cr_amount numeric(15,2) DEFAULT 0,
    narration text
);


ALTER TABLE fy_2025_2026.voucher_lines OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.voucher_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.voucher_lines_id_seq OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.voucher_lines_id_seq OWNED BY fy_2025_2026.voucher_lines.id;


--
-- Name: vouchers; Type: TABLE; Schema: fy_2025_2026; Owner: orbx
--

CREATE TABLE fy_2025_2026.vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_type character varying(30) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    amount numeric(15,2) DEFAULT 0 NOT NULL,
    narration text,
    ref_no character varying(100),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2025_2026.vouchers OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: fy_2025_2026; Owner: orbx
--

CREATE SEQUENCE fy_2025_2026.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2025_2026.vouchers_id_seq OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2025_2026; Owner: orbx
--

ALTER SEQUENCE fy_2025_2026.vouchers_id_seq OWNED BY fy_2025_2026.vouchers.id;


--
-- Name: advance_payments; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.advance_payments (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    payment_type character varying(20) NOT NULL,
    ledger_type character varying(20) NOT NULL,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.advance_payments OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.advance_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.advance_payments_id_seq OWNER TO orbx;

--
-- Name: advance_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.advance_payments_id_seq OWNED BY fy_2026_2027.advance_payments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.audit_logs (
    id integer NOT NULL,
    user_id integer,
    username character varying(100),
    action character varying(50) NOT NULL,
    module character varying(50),
    record_id integer,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.audit_logs OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.audit_logs_id_seq OWNER TO orbx;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.audit_logs_id_seq OWNED BY fy_2026_2027.audit_logs.id;


--
-- Name: biometric_entries; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.biometric_entries (
    id integer NOT NULL,
    ledger_id integer NOT NULL,
    entry_date date NOT NULL,
    punch_in time without time zone,
    punch_out time without time zone,
    hours_worked numeric(5,2),
    status character varying(20) DEFAULT 'Present'::character varying,
    device_log_id character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.biometric_entries OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.biometric_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.biometric_entries_id_seq OWNER TO orbx;

--
-- Name: biometric_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.biometric_entries_id_seq OWNED BY fy_2026_2027.biometric_entries.id;


--
-- Name: eb_readings; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.eb_readings (
    id integer NOT NULL,
    reading_date date NOT NULL,
    meter_no character varying(50),
    previous_reading numeric(15,3) DEFAULT 0,
    current_reading numeric(15,3) DEFAULT 0,
    units_consumed numeric(15,3) DEFAULT 0,
    rate_per_unit numeric(10,4) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.eb_readings OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.eb_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.eb_readings_id_seq OWNER TO orbx;

--
-- Name: eb_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.eb_readings_id_seq OWNED BY fy_2026_2027.eb_readings.id;


--
-- Name: job_work_entries; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.job_work_entries (
    id integer NOT NULL,
    entry_no character varying(50) NOT NULL,
    entry_date date NOT NULL,
    ledger_id integer NOT NULL,
    product_id integer,
    process_id integer,
    rate_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    entry_type character varying(20) NOT NULL,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.job_work_entries OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.job_work_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.job_work_entries_id_seq OWNER TO orbx;

--
-- Name: job_work_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.job_work_entries_id_seq OWNED BY fy_2026_2027.job_work_entries.id;


--
-- Name: labour_bills; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.labour_bills (
    id integer NOT NULL,
    bill_no character varying(50) NOT NULL,
    bill_date date NOT NULL,
    ledger_id integer NOT NULL,
    inward_id integer,
    product_id integer,
    process_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    gst_percent numeric(5,2) DEFAULT 0,
    gst_amount numeric(15,2) DEFAULT 0,
    cgst_percent numeric(5,2) DEFAULT 0,
    cgst_amount numeric(15,2) DEFAULT 0,
    sgst_percent numeric(5,2) DEFAULT 0,
    sgst_amount numeric(15,2) DEFAULT 0,
    round_off numeric(15,2) DEFAULT 0,
    net_amount numeric(15,2) DEFAULT 0,
    total_amount numeric(15,2) DEFAULT 0,
    narration text,
    is_paid boolean DEFAULT false,
    payment_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    items jsonb DEFAULT '[]'::jsonb,
    outward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255)
);


ALTER TABLE fy_2026_2027.labour_bills OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.labour_bills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.labour_bills_id_seq OWNER TO orbx;

--
-- Name: labour_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.labour_bills_id_seq OWNED BY fy_2026_2027.labour_bills.id;


--
-- Name: salary_vouchers; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.salary_vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    days_worked numeric(5,1) DEFAULT 0,
    basic_salary numeric(15,2) DEFAULT 0,
    allowances numeric(15,2) DEFAULT 0,
    deductions numeric(15,2) DEFAULT 0,
    net_salary numeric(15,2) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.salary_vouchers OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.salary_vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.salary_vouchers_id_seq OWNER TO orbx;

--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.salary_vouchers_id_seq OWNED BY fy_2026_2027.salary_vouchers.id;


--
-- Name: stock_adjustments; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.stock_adjustments (
    id integer NOT NULL,
    adjustment_no character varying(50) NOT NULL,
    adjustment_date date NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(15,3) NOT NULL,
    reason text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.stock_adjustments OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.stock_adjustments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.stock_adjustments_id_seq OWNER TO orbx;

--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.stock_adjustments_id_seq OWNED BY fy_2026_2027.stock_adjustments.id;


--
-- Name: stock_inward; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.stock_inward (
    id integer NOT NULL,
    inward_no character varying(50) NOT NULL,
    inward_date date NOT NULL,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    narration text,
    serial_no character varying(100),
    ref_no character varying(100),
    ref_date date,
    expected_duration_days integer,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    items jsonb DEFAULT '[]'::jsonb,
    is_completed boolean DEFAULT false,
    completed_date date,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.stock_inward OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.stock_inward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.stock_inward_id_seq OWNER TO orbx;

--
-- Name: stock_inward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.stock_inward_id_seq OWNED BY fy_2026_2027.stock_inward.id;


--
-- Name: stock_item_movements; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.stock_item_movements (
    id integer NOT NULL,
    movement_no character varying(50) NOT NULL,
    movement_date date NOT NULL,
    movement_type character varying(10) NOT NULL,
    stock_item_id integer NOT NULL,
    ledger_id integer,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    uom_id integer,
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.stock_item_movements OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.stock_item_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.stock_item_movements_id_seq OWNER TO orbx;

--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.stock_item_movements_id_seq OWNED BY fy_2026_2027.stock_item_movements.id;


--
-- Name: stock_outward; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.stock_outward (
    id integer NOT NULL,
    outward_no character varying(50) NOT NULL,
    outward_date date NOT NULL,
    inward_id integer,
    product_id integer,
    process_id character varying(100),
    ledger_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    rate numeric(15,2) DEFAULT 0,
    amount numeric(15,2) DEFAULT 0,
    weight numeric(15,3) DEFAULT 0,
    total_weight numeric(15,3) DEFAULT 0,
    uom_id integer,
    serial_no character varying(100),
    ref_no character varying(100),
    narration text,
    items jsonb DEFAULT '[]'::jsonb,
    inward_ids jsonb DEFAULT '[]'::jsonb,
    dispatch_through character varying(255),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.stock_outward OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.stock_outward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.stock_outward_id_seq OWNER TO orbx;

--
-- Name: stock_outward_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.stock_outward_id_seq OWNED BY fy_2026_2027.stock_outward.id;


--
-- Name: stock_transfer; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.stock_transfer (
    id integer NOT NULL,
    transfer_no character varying(50) NOT NULL,
    transfer_date date NOT NULL,
    from_stock_item_id integer NOT NULL,
    to_stock_item_id integer NOT NULL,
    quantity numeric(15,3) DEFAULT 0,
    narration text,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.stock_transfer OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.stock_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.stock_transfer_id_seq OWNER TO orbx;

--
-- Name: stock_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.stock_transfer_id_seq OWNED BY fy_2026_2027.stock_transfer.id;


--
-- Name: voucher_lines; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.voucher_lines (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    ledger_id integer NOT NULL,
    dr_amount numeric(15,2) DEFAULT 0,
    cr_amount numeric(15,2) DEFAULT 0,
    narration text
);


ALTER TABLE fy_2026_2027.voucher_lines OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.voucher_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.voucher_lines_id_seq OWNER TO orbx;

--
-- Name: voucher_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.voucher_lines_id_seq OWNED BY fy_2026_2027.voucher_lines.id;


--
-- Name: vouchers; Type: TABLE; Schema: fy_2026_2027; Owner: orbx
--

CREATE TABLE fy_2026_2027.vouchers (
    id integer NOT NULL,
    voucher_no character varying(50) NOT NULL,
    voucher_type character varying(30) NOT NULL,
    voucher_date date NOT NULL,
    ledger_id integer NOT NULL,
    amount numeric(15,2) DEFAULT 0 NOT NULL,
    narration text,
    ref_no character varying(100),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE fy_2026_2027.vouchers OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: fy_2026_2027; Owner: orbx
--

CREATE SEQUENCE fy_2026_2027.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fy_2026_2027.vouchers_id_seq OWNER TO orbx;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: fy_2026_2027; Owner: orbx
--

ALTER SEQUENCE fy_2026_2027.vouchers_id_seq OWNED BY fy_2026_2027.vouchers.id;


--
-- Name: company; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.company (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    address text,
    city character varying(100),
    state character varying(100),
    pincode character varying(10),
    phone character varying(30),
    mobile character varying(30),
    email character varying(200),
    gstin character varying(20),
    pan character varying(20),
    tan character varying(20),
    financial_year_start_month integer NOT NULL,
    logo_path character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.company OWNER TO orbx;

--
-- Name: company_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.company_id_seq OWNER TO orbx;

--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.company_id_seq OWNED BY master.company.id;


--
-- Name: financial_years; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.financial_years (
    id integer NOT NULL,
    year_str character varying(20) NOT NULL,
    label character varying(50) NOT NULL,
    start_date character varying(10) NOT NULL,
    end_date character varying(10) NOT NULL,
    is_active boolean NOT NULL,
    is_locked boolean NOT NULL,
    schema_name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.financial_years OWNER TO orbx;

--
-- Name: financial_years_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.financial_years_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.financial_years_id_seq OWNER TO orbx;

--
-- Name: financial_years_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.financial_years_id_seq OWNED BY master.financial_years.id;


--
-- Name: ledger_groups; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.ledger_groups (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    parent_id integer,
    group_type character varying(20) NOT NULL,
    is_system boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.ledger_groups OWNER TO orbx;

--
-- Name: ledger_groups_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.ledger_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.ledger_groups_id_seq OWNER TO orbx;

--
-- Name: ledger_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.ledger_groups_id_seq OWNED BY master.ledger_groups.id;


--
-- Name: ledgers; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.ledgers (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    ledger_code character varying(50),
    group_id integer NOT NULL,
    ledger_type character varying(20) NOT NULL,
    opening_balance numeric(15,2) NOT NULL,
    balance_type character varying(2) NOT NULL,
    phone character varying(30),
    mobile character varying(30),
    address text,
    city character varying(100),
    pincode character varying(10),
    state character varying(100),
    gstin character varying(20),
    pan character varying(20),
    bank_name character varying(200),
    bank_account_no character varying(50),
    bank_ifsc character varying(20),
    designation character varying(100),
    department character varying(100),
    basic_salary numeric(15,2),
    join_date character varying(10),
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.ledgers OWNER TO orbx;

--
-- Name: ledgers_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.ledgers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.ledgers_id_seq OWNER TO orbx;

--
-- Name: ledgers_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.ledgers_id_seq OWNED BY master.ledgers.id;


--
-- Name: processes; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.processes (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    process_code character varying(50),
    product_id integer,
    sequence integer NOT NULL,
    company_rate numeric(15,4) NOT NULL,
    contractor_rate numeric(15,4) NOT NULL,
    gst_percent numeric(5,2) NOT NULL,
    description text,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.processes OWNER TO orbx;

--
-- Name: processes_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.processes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.processes_id_seq OWNER TO orbx;

--
-- Name: processes_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.processes_id_seq OWNED BY master.processes.id;


--
-- Name: products; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.products (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    product_code character varying(50),
    description text,
    uom_id integer,
    weight numeric(15,3),
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.products OWNER TO orbx;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.products_id_seq OWNER TO orbx;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.products_id_seq OWNED BY master.products.id;


--
-- Name: rates; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.rates (
    id integer NOT NULL,
    process_id integer NOT NULL,
    ledger_id integer,
    product_id integer,
    rate numeric(15,4) NOT NULL,
    uom_id integer,
    effective_from character varying(10),
    effective_to character varying(10),
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.rates OWNER TO orbx;

--
-- Name: rates_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.rates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.rates_id_seq OWNER TO orbx;

--
-- Name: rates_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.rates_id_seq OWNED BY master.rates.id;


--
-- Name: role_permissions; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.role_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    module character varying(50) NOT NULL,
    can_view boolean NOT NULL,
    can_create boolean NOT NULL,
    can_edit boolean NOT NULL,
    can_delete boolean NOT NULL,
    can_print boolean NOT NULL
);


ALTER TABLE master.role_permissions OWNER TO orbx;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.role_permissions_id_seq OWNER TO orbx;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.role_permissions_id_seq OWNED BY master.role_permissions.id;


--
-- Name: stock_items; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.stock_items (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    item_code character varying(50),
    uom_id integer,
    opening_stock numeric(15,3) NOT NULL,
    reorder_level numeric(15,3) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.stock_items OWNER TO orbx;

--
-- Name: stock_items_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.stock_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.stock_items_id_seq OWNER TO orbx;

--
-- Name: stock_items_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.stock_items_id_seq OWNED BY master.stock_items.id;


--
-- Name: units_of_measure; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.units_of_measure (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    symbol character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.units_of_measure OWNER TO orbx;

--
-- Name: units_of_measure_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.units_of_measure_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.units_of_measure_id_seq OWNER TO orbx;

--
-- Name: units_of_measure_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.units_of_measure_id_seq OWNED BY master.units_of_measure.id;


--
-- Name: users; Type: TABLE; Schema: master; Owner: orbx
--

CREATE TABLE master.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    full_name character varying(200),
    email character varying(200),
    role character varying(20) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE master.users OWNER TO orbx;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: master; Owner: orbx
--

CREATE SEQUENCE master.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE master.users_id_seq OWNER TO orbx;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: orbx
--

ALTER SEQUENCE master.users_id_seq OWNED BY master.users.id;


--
-- Name: advance_payments id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.advance_payments ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.advance_payments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.audit_logs ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.audit_logs_id_seq'::regclass);


--
-- Name: biometric_entries id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.biometric_entries ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.biometric_entries_id_seq'::regclass);


--
-- Name: eb_readings id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.eb_readings ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.eb_readings_id_seq'::regclass);


--
-- Name: job_work_entries id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.job_work_entries ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.job_work_entries_id_seq'::regclass);


--
-- Name: labour_bills id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.labour_bills ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.labour_bills_id_seq'::regclass);


--
-- Name: salary_vouchers id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.salary_vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.salary_vouchers_id_seq'::regclass);


--
-- Name: stock_adjustments id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_adjustments ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.stock_adjustments_id_seq'::regclass);


--
-- Name: stock_inward id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_inward ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.stock_inward_id_seq'::regclass);


--
-- Name: stock_item_movements id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_item_movements ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.stock_item_movements_id_seq'::regclass);


--
-- Name: stock_outward id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_outward ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.stock_outward_id_seq'::regclass);


--
-- Name: stock_transfer id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_transfer ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.stock_transfer_id_seq'::regclass);


--
-- Name: voucher_lines id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.voucher_lines ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.voucher_lines_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2023_2024.vouchers_id_seq'::regclass);


--
-- Name: advance_payments id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.advance_payments ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.advance_payments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.audit_logs ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.audit_logs_id_seq'::regclass);


--
-- Name: biometric_entries id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.biometric_entries ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.biometric_entries_id_seq'::regclass);


--
-- Name: eb_readings id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.eb_readings ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.eb_readings_id_seq'::regclass);


--
-- Name: job_work_entries id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.job_work_entries ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.job_work_entries_id_seq'::regclass);


--
-- Name: labour_bills id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.labour_bills ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.labour_bills_id_seq'::regclass);


--
-- Name: salary_vouchers id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.salary_vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.salary_vouchers_id_seq'::regclass);


--
-- Name: stock_adjustments id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_adjustments ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.stock_adjustments_id_seq'::regclass);


--
-- Name: stock_inward id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_inward ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.stock_inward_id_seq'::regclass);


--
-- Name: stock_item_movements id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_item_movements ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.stock_item_movements_id_seq'::regclass);


--
-- Name: stock_outward id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_outward ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.stock_outward_id_seq'::regclass);


--
-- Name: stock_transfer id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_transfer ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.stock_transfer_id_seq'::regclass);


--
-- Name: voucher_lines id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.voucher_lines ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.voucher_lines_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2024_2025.vouchers_id_seq'::regclass);


--
-- Name: advance_payments id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.advance_payments ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.advance_payments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.audit_logs ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.audit_logs_id_seq'::regclass);


--
-- Name: biometric_entries id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.biometric_entries ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.biometric_entries_id_seq'::regclass);


--
-- Name: eb_readings id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.eb_readings ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.eb_readings_id_seq'::regclass);


--
-- Name: job_work_entries id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.job_work_entries ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.job_work_entries_id_seq'::regclass);


--
-- Name: labour_bills id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.labour_bills ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.labour_bills_id_seq'::regclass);


--
-- Name: salary_vouchers id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.salary_vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.salary_vouchers_id_seq'::regclass);


--
-- Name: stock_adjustments id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_adjustments ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.stock_adjustments_id_seq'::regclass);


--
-- Name: stock_inward id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_inward ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.stock_inward_id_seq'::regclass);


--
-- Name: stock_item_movements id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_item_movements ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.stock_item_movements_id_seq'::regclass);


--
-- Name: stock_outward id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_outward ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.stock_outward_id_seq'::regclass);


--
-- Name: stock_transfer id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_transfer ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.stock_transfer_id_seq'::regclass);


--
-- Name: voucher_lines id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.voucher_lines ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.voucher_lines_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2025_2026.vouchers_id_seq'::regclass);


--
-- Name: advance_payments id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.advance_payments ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.advance_payments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.audit_logs ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.audit_logs_id_seq'::regclass);


--
-- Name: biometric_entries id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.biometric_entries ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.biometric_entries_id_seq'::regclass);


--
-- Name: eb_readings id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.eb_readings ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.eb_readings_id_seq'::regclass);


--
-- Name: job_work_entries id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.job_work_entries ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.job_work_entries_id_seq'::regclass);


--
-- Name: labour_bills id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.labour_bills ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.labour_bills_id_seq'::regclass);


--
-- Name: salary_vouchers id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.salary_vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.salary_vouchers_id_seq'::regclass);


--
-- Name: stock_adjustments id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_adjustments ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.stock_adjustments_id_seq'::regclass);


--
-- Name: stock_inward id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_inward ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.stock_inward_id_seq'::regclass);


--
-- Name: stock_item_movements id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_item_movements ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.stock_item_movements_id_seq'::regclass);


--
-- Name: stock_outward id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_outward ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.stock_outward_id_seq'::regclass);


--
-- Name: stock_transfer id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_transfer ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.stock_transfer_id_seq'::regclass);


--
-- Name: voucher_lines id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.voucher_lines ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.voucher_lines_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.vouchers ALTER COLUMN id SET DEFAULT nextval('fy_2026_2027.vouchers_id_seq'::regclass);


--
-- Name: company id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.company ALTER COLUMN id SET DEFAULT nextval('master.company_id_seq'::regclass);


--
-- Name: financial_years id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.financial_years ALTER COLUMN id SET DEFAULT nextval('master.financial_years_id_seq'::regclass);


--
-- Name: ledger_groups id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledger_groups ALTER COLUMN id SET DEFAULT nextval('master.ledger_groups_id_seq'::regclass);


--
-- Name: ledgers id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledgers ALTER COLUMN id SET DEFAULT nextval('master.ledgers_id_seq'::regclass);


--
-- Name: processes id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.processes ALTER COLUMN id SET DEFAULT nextval('master.processes_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.products ALTER COLUMN id SET DEFAULT nextval('master.products_id_seq'::regclass);


--
-- Name: rates id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.rates ALTER COLUMN id SET DEFAULT nextval('master.rates_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.role_permissions ALTER COLUMN id SET DEFAULT nextval('master.role_permissions_id_seq'::regclass);


--
-- Name: stock_items id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.stock_items ALTER COLUMN id SET DEFAULT nextval('master.stock_items_id_seq'::regclass);


--
-- Name: units_of_measure id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.units_of_measure ALTER COLUMN id SET DEFAULT nextval('master.units_of_measure_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.users ALTER COLUMN id SET DEFAULT nextval('master.users_id_seq'::regclass);


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
58	ADV_10_82	2023-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
59	ADV_11_97	2023-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
60	ADV_18_127	2023-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
61	ADV_1_62	2023-06-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
62	ADV_2_67	2023-06-21	2373	Payment	Contractor	0.00	20/06/2023 -1000 / 21/06/2023-2000	\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
63	ADV_3_68	2023-06-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
64	ADV_4_69	2023-06-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
65	ADV_5_70	2023-06-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
66	ADV_6_71	2023-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
67	ADV_7_72	2023-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
68	ADV_8_73	2023-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
69	ADV_9_74	2023-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
70	ADV_12_114	2023-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
71	ADV_13_115	2023-06-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
72	ADV_14_116	2023-06-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
73	ADV_15_117	2023-06-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
74	ADV_16_118	2023-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
75	ADV_17_126	2023-06-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
76	ADV_19_179	2023-07-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:00.899844	2026-08-03 15:19:00.899844
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.audit_logs (id, user_id, username, action, module, record_id, old_values, new_values, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: biometric_entries; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.biometric_entries (id, ledger_id, entry_date, punch_in, punch_out, hours_worked, status, device_log_id, created_at) FROM stdin;
\.


--
-- Data for Name: eb_readings; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.eb_readings (id, reading_date, meter_no, previous_reading, current_reading, units_consumed, rate_per_unit, amount, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: job_work_entries; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.job_work_entries (id, entry_no, entry_date, ledger_id, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, created_by, created_at, updated_at) FROM stdin;
4	JW_26_707_99_0	2023-06-24	2497	3808	19	\N	67.000	87.00	5829.00	Register		\N	2026-08-03 15:19:00.941342	2026-08-03 15:19:00.941342
\.


--
-- Data for Name: labour_bills; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.labour_bills (id, bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, is_paid, payment_date, created_by, created_at, updated_at, items, outward_ids, dispatch_through) FROM stdin;
778	LB_2_694_2_0	2023-06-21	2235	\N	3795	19	1440.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
779	LB_31_697_40_0	2023-06-15	2235	\N	3798	\N	100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80058-10	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
780	LB_32_697_41_0	2023-06-16	2235	\N	3798	19	982.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80136-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
781	LB_32_701_41_1	2023-06-16	2235	\N	3802	19	1508.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80136-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
782	LB_33_697_42_0	2023-06-16	2235	\N	3798	\N	51.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80101-104	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
783	LB_34_698_43_0	2023-06-17	2235	\N	3799	\N	200.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80142-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
784	LB_35_702_44_0	2023-06-17	2234	\N	3803	19	439.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	40075-30	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
785	LB_36_705_45_0	2023-06-17	2235	\N	3806	19	1170.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80125-76,80151-24,80092-20,80101-13,80076-17	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
786	LB_37_701_46_0	2023-06-17	2235	\N	3802	19	1450.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80060-10	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
787	LB_38_698_47_0	2023-06-19	2235	\N	3799	\N	400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80142-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
788	LB_39_698_48_0	2023-06-19	2235	\N	3799	\N	200.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80151-76	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
789	LB_40_697_49_0	2023-06-20	2234	\N	3798	19	1965.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	40077-22	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
790	LB_41_701_50_0	2023-06-20	2235	\N	3802	19	1015.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80157-50,80092-30,80060-10	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
791	LB_41_703_50_1	2023-06-20	2235	\N	3804	19	4222.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80157-50,80092-30,80060-10	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
792	LB_42_698_51_0	2023-06-21	2235	\N	3799	\N	600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80165-180	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
793	LB_43_697_52_0	2023-06-22	2235	\N	3798	19	982.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4,80165-220	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
794	LB_47_697_88_0	2023-06-24	2235	\N	3798	19	491.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80060-20	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
795	LB_47_697_88_1	2023-06-24	2235	\N	3798	19	1638.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80060-20	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
796	LB_48_696_89_0	2023-06-24	2235	\N	3797	19	428.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80058-9,80060-21	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
797	LB_48_696_89_1	2023-06-24	2235	\N	3797	19	375.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80058-9,80060-21	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
798	LB_49_699_90_0	2023-06-24	2235	\N	3800	19	110.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80047-50,80058-23,80092-27,80181-80	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
799	LB_49_699_90_1	2023-06-24	2235	\N	3800	19	314.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80047-50,80058-23,80092-27,80181-80	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
800	LB_50_697_91_0	2023-06-24	2235	\N	3798	19	2457.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80189-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
801	LB_51_704_92_0	2023-06-24	2235	\N	3805	19	270.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80092-3	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
802	LB_51_699_92_1	2023-06-24	2235	\N	3800	19	425.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80092-3	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
803	LB_51_696_92_2	2023-06-24	2235	\N	3797	19	1608.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80092-3	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
804	LB_52_701_93_0	2023-06-24	2234	\N	3802	19	290.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	40077-8,40133-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
805	LB_53_697_103_0	2023-06-26	2234	\N	3798	19	2948.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
806	LB_62_703_134_0	2023-07-03	2234	\N	3804	19	1646.580	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40231-400,M4-40234-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
807	LB_62_702_134_1	2023-07-03	2234	\N	3803	19	43.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40231-400,M4-40234-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
808	LB_63_696_135_0	2023-07-03	2235	\N	3797	19	1340.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80208-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
809	LB_66_695_138_0	2023-07-04	2235	\N	3796	19	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80058-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
810	LB_66_696_138_1	2023-07-04	2235	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80058-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
811	LB_66_696_138_2	2023-07-04	2235	\N	3797	19	804.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80058-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
812	LB_70_698_142_0	2023-07-05	2235	\N	3799	19	1680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80213-170,M4-80225-34,M4-80222-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
813	LB_70_706_142_1	2023-07-05	2235	\N	3807	19	1530.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80213-170,M4-80225-34,M4-80222-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
814	LB_44_699_53_0	2023-06-22	2235	\N	3800	19	1275.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
815	LB_45_698_80_0	2023-06-23	2235	\N	3799	\N	200.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80164-30,80172-100,80181-20,80172-20,80181-5,80076-103	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
816	LB_54_697_104_0	2023-06-26	2235	\N	3798	19	3603.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80181-95,80190-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
817	LB_55_696_106_0	2023-06-27	2234	\N	3797	\N	50.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211-50,M4-40219-150,M4-40216-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
818	LB_55_696_106_1	2023-06-27	2234	\N	3797	\N	70.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211-50,M4-40219-150,M4-40216-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
819	LB_55_695_106_2	2023-06-27	2234	\N	3796	\N	80.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211-50,M4-40219-150,M4-40216-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
820	LB_56_697_113_0	2023-06-28	2234	\N	3798	19	2457.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40223-300	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
821	LB_71_697_143_0	2023-07-05	2234	\N	3798	19	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40232-621,M4-40234-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
822	LB_77_695_161_0	2023-07-08	2235	\N	3796	19	4320.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
823	LB_77_704_161_1	2023-07-08	2235	\N	3805	19	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
824	LB_78_706_164_0	2023-07-10	2235	\N	3807	19	2550.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80076-103	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
825	LB_79_712_165_0	2023-07-10	2234	\N	3813	19	254.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
826	LB_81_700_170_0	2023-07-13	2235	\N	3801	19	2688.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80237-56,M4-80238-5,M4-80237-244 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
827	LB_83_704_174_0	2023-07-14	2234	\N	3805	19	756.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-17,M4-40275-50,M4-40281-20 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
828	LB_83_704_174_1	2023-07-14	2234	\N	3805	19	67.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-17,M4-40275-50,M4-40281-20 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
829	LB_83_699_174_2	2023-07-14	2234	\N	3800	19	2074.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-17,M4-40275-50,M4-40281-20 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
830	LB_84_695_187_0	2023-07-17	2235	\N	3796	19	2160.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80244-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
831	LB_84_719_187_1	2023-07-17	2235	\N	3820	19	665.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80244-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
832	LB_84_720_187_2	2023-07-17	2235	\N	3821	19	976.580	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80244-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
833	LB_87_699_190_0	2023-07-19	2235	\N	3800	19	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80247-100 NOS,M4-80247-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
834	LB_87_704_190_1	2023-07-19	2235	\N	3805	19	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80247-100 NOS,M4-80247-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
835	LB_88_718_191_0	2023-07-19	2234	\N	3819	19	448.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40291-700	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
836	LB_92_697_199_0	2023-07-21	2234	\N	3798	19	720.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40291-300 NOS,M4-40304-500 NOS,M4-40301-87 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
837	LB_94_695_201_0	2023-07-22	2234	\N	3796	19	72.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-230	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
838	LB_94_695_201_1	2023-07-22	2234	\N	3796	19	2016.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-230	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
839	LB_95_718_202_0	2023-07-22	2234	\N	3819	19	192.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
840	LB_95_721_202_1	2023-07-22	2234	\N	3822	19	145.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
841	LB_95_717_202_2	2023-07-22	2234	\N	3818	19	565.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
842	LB_96_700_208_0	2023-07-22	2234	\N	3801	19	1920.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40309-40, M4-40304-500 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
843	LB_96_721_208_1	2023-07-22	2234	\N	3822	19	145.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40309-40, M4-40304-500 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
844	LB_98_719_210_0	2023-07-24	2235	\N	3820	19	1149.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80249-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
845	LB_98_720_210_1	2023-07-24	2235	\N	3821	19	1331.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80249-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
846	LB_98_695_210_2	2023-07-24	2235	\N	3796	19	216.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80249-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
847	LB_99_700_214_0	2023-07-26	2234	\N	3801	19	480.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-10,M4-40281-20,M4-40311-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
848	LB_99_700_214_1	2023-07-26	2234	\N	3801	19	960.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-10,M4-40281-20,M4-40311-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
849	LB_99_716_214_2	2023-07-26	2234	\N	3817	19	1440.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-10,M4-40281-20,M4-40311-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
850	LB_100_716_217_0	2023-07-26	2235	\N	3817	19	480.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80253-100,M4-80255-150 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
851	LB_100_716_217_1	2023-07-26	2235	\N	3817	19	2400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80253-100,M4-80255-150 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
852	LB_101_716_218_0	2023-07-26	2234	\N	3817	19	480.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40311-10 ,M4-40317-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
853	LB_101_716_218_1	2023-07-26	2234	\N	3817	19	2400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40311-10 ,M4-40317-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
854	LB_101_700_218_2	2023-07-26	2234	\N	3801	19	1920.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40311-10 ,M4-40317-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
855	LB_104_719_226_0	2023-07-29	2235	\N	3820	19	2117.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80252-35 NOS, M4-80252-9 NOS,M4-80253-10 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
856	LB_104_720_226_1	2023-07-29	2235	\N	3821	19	443.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80252-35 NOS, M4-80252-9 NOS,M4-80253-10 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
857	LB_104_696_226_2	2023-07-29	2235	\N	3797	19	241.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80252-35 NOS, M4-80252-9 NOS,M4-80253-10 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
858	LB_105_695_227_0	2023-07-29	2235	\N	3796	19	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80269-100 NOS,80269-100 NOS,M4-80270-163 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
859	LB_105_696_227_1	2023-07-29	2235	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80269-100 NOS,80269-100 NOS,M4-80270-163 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
860	LB_105_704_227_2	2023-07-29	2235	\N	3805	19	2200.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80269-100 NOS,80269-100 NOS,M4-80270-163 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
861	LB_112_695_234_0	2023-08-02	2235	\N	3796	19	108.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80278	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
862	LB_112_719_234_1	2023-08-02	2235	\N	3820	19	2117.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80278	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
863	LB_113_720_235_0	2023-08-03	2234	\N	3821	19	44.390	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
864	LB_113_720_235_1	2023-08-03	2234	\N	3821	19	1731.210	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
865	LB_113_722_235_2	2023-08-03	2234	\N	3823	19	331.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
866	LB_115_696_237_0	2023-08-04	2235	\N	3797	19	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-802778-74,M4-80286-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
867	LB_116_719_238_0	2023-08-05	2235	\N	3820	19	1210.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80292	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
868	LB_118_696_240_0	2023-08-07	2235	\N	3797	19	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80298 130 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
869	LB_120_704_245_0	2023-08-08	2235	\N	3805	19	999.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80301-68 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
870	LB_120_696_245_1	2023-08-08	2235	\N	3797	19	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80301-68 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
871	LB_121_725_246_0	2023-08-08	2234	\N	3826	19	283.610	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
872	LB_121_725_246_1	2023-08-08	2234	\N	3826	19	391.050	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
873	LB_121_726_246_2	2023-08-08	2234	\N	3827	19	116.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
874	LB_121_726_246_3	2023-08-08	2234	\N	3827	19	350.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
875	LB_121_723_246_4	2023-08-08	2234	\N	3824	19	588.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
876	LB_125_696_274_0	2023-08-11	2235	\N	3797	19	3216.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80294-70 NOS, M4-80295-60 NOS, M480315-60 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
877	LB_126_697_275_0	2023-08-12	2234	\N	3798	19	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339-347, M4-40336-1000-NOS, M4-40336-109, M4-40358-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
878	LB_127_696_279_0	2023-08-12	2235	\N	3797	19	536.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
879	LB_127_696_279_1	2023-08-12	2235	\N	3797	19	3752.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
880	LB_127_704_279_2	2023-08-12	2235	\N	3805	19	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
881	LB_128_697_286_0	2023-08-12	2235	\N	3798	19	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80315-120 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
882	LB_128_697_286_1	2023-08-12	2235	\N	3798	19	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80315-120 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
883	LB_129_715_287_0	2023-08-14	2235	\N	3816	19	253.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
884	LB_129_714_287_1	2023-08-14	2235	\N	3815	19	650.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
885	LB_129_715_287_2	2023-08-14	2235	\N	3816	\N	100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
886	LB_129_715_287_3	2023-08-14	2235	\N	3816	\N	100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
887	LB_129_723_287_4	2023-08-14	2235	\N	3824	19	221.970	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
888	LB_129_723_287_5	2023-08-14	2235	\N	3824	19	1617.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
889	LB_130_704_288_0	2023-08-14	2235	\N	3805	19	1350.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80327-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
890	LB_132_695_294_0	2023-08-16	2235	\N	3796	19	1440.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80316-60 NOS, M4-80323-50 NOS, M4-80332-50,M4-80332-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
891	LB_132_695_294_1	2023-08-16	2235	\N	3796	19	1260.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80316-60 NOS, M4-80323-50 NOS, M4-80332-50,M4-80332-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
892	LB_134_697_296_0	2023-08-18	2234	\N	3798	19	2129.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
893	LB_134_697_296_1	2023-08-18	2234	\N	3798	19	1638.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
894	LB_134_697_296_2	2023-08-18	2234	\N	3798	19	2784.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
895	LB_134_728_296_3	2023-08-18	2234	\N	3829	19	621.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
896	LB_138_719_309_0	2023-08-21	2235	\N	3820	19	3630.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80347-130 NOS,M4-80350-100 NOS,M4-80349-170 NOS,M4-80349-69 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
897	LB_138_696_309_1	2023-08-21	2235	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80347-130 NOS,M4-80350-100 NOS,M4-80349-170 NOS,M4-80349-69 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
898	LB_139_698_310_0	2023-08-22	2235	\N	3799	19	2100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80347-30 NOS, M4-80350-35 NOS,M4-80350-30 NOS,M4-80357-15 NOS,M4-80358-20 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
899	LB_140_696_316_0	2023-08-23	2234	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40392-35,M4-40422-15 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
900	LB_140_699_316_1	2023-08-23	2234	\N	3800	19	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40392-35,M4-40422-15 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
901	LB_141_699_319_0	2023-08-23	2235	\N	3800	19	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-140 NOS,M4-80357-125 NOS,M4-80359-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
902	LB_141_696_319_1	2023-08-23	2235	\N	3797	19	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-140 NOS,M4-80357-125 NOS,M4-80359-50 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
903	LB_142_695_320_0	2023-08-23	2235	\N	3796	19	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-70 NOS,M4-80359-300 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
904	LB_142_704_320_1	2023-08-23	2235	\N	3805	19	1350.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-70 NOS,M4-80359-300 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
905	LB_142_697_320_2	2023-08-23	2235	\N	3798	19	3439.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-70 NOS,M4-80359-300 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
906	LB_143_732_321_0	2023-08-25	2235	\N	3833	19	489.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80358-60 NOS, M4-80355-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
907	LB_146_696_326_0	2023-08-26	2235	\N	3797	19	4020.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80355-100 NOS,M4-80362- 100 NOS,M4-80359-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
908	LB_146_704_326_1	2023-08-26	2235	\N	3805	19	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80355-100 NOS,M4-80362- 100 NOS,M4-80359-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
909	LB_146_720_326_2	2023-08-26	2235	\N	3821	19	887.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80355-100 NOS,M4-80362- 100 NOS,M4-80359-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
910	LB_147_699_327_0	2023-08-26	2235	\N	3800	19	127.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
911	LB_147_697_327_1	2023-08-26	2235	\N	3798	19	655.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
912	LB_147_699_327_2	2023-08-26	2235	\N	3800	19	722.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
913	LB_147_704_327_3	2023-08-26	2235	\N	3805	19	810.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
914	LB_147_696_327_4	2023-08-26	2235	\N	3797	19	1340.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
915	LB_147_697_327_5	2023-08-26	2235	\N	3798	19	2457.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
916	LB_147_704_327_6	2023-08-26	2235	\N	3805	19	1485.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
917	LB_148_699_328_0	2023-08-29	2235	\N	3800	19	977.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
918	LB_148_720_328_1	2023-08-29	2235	\N	3821	19	887.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
919	LB_148_722_328_2	2023-08-29	2235	\N	3823	19	946.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
920	LB_148_699_328_3	2023-08-29	2235	\N	3800	19	1436.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
921	LB_148_704_328_4	2023-08-29	2235	\N	3805	19	540.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
922	LB_150_697_330_0	2023-08-30	2234	\N	3798	19	1638.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40421-5	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
923	LB_151_722_331_0	2023-08-30	2235	\N	3823	19	2838.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80375-150 NOS,M4-80367-50 NOS,M4-80373-20 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
924	LB_151_699_331_1	2023-08-30	2235	\N	3800	19	263.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80375-150 NOS,M4-80367-50 NOS,M4-80373-20 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
925	LB_153_732_333_0	2023-09-01	2234	\N	3833	19	2448.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339-359,M4-40341,M4-40336-495,M4-40337-500	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
926	LB_155_719_351_0	2023-09-04	2235	\N	3820	17	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80381-100 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
927	LB_157_728_353_0	2023-09-05	2234	\N	3829	19	2034.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40479-25 Nos	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
928	LB_161_735_357_0	2023-09-07	2234	\N	3836	\N	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40497-25,M4-40558-150,M4-40558-300	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
929	LB_161_736_357_1	2023-09-07	2234	\N	3837	\N	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40497-25,M4-40558-150,M4-40558-300	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
930	LB_162_719_358_0	2023-09-07	2235	\N	3820	19	4840.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80382-100 NOS, M4-80387-51 NOS,M4-80385-170 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
931	LB_163_695_359_0	2023-09-08	2234	\N	3796	19	4680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40422-19,M4-40558-131,M4-40558-666,M4-40558-92,M4-40558-774	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
932	LB_163_699_359_1	2023-09-08	2234	\N	3800	19	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40422-19,M4-40558-131,M4-40558-666,M4-40558-92,M4-40558-774	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
933	LB_163_704_359_2	2023-09-08	2234	\N	3805	19	1012.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40422-19,M4-40558-131,M4-40558-666,M4-40558-92,M4-40558-774	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
934	LB_165_697_361_0	2023-09-09	2235	\N	3798	19	819.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80389-60	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
935	LB_165_697_361_1	2023-09-09	2235	\N	3798	19	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80389-60	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
936	LB_166_699_362_0	2023-09-11	2235	\N	3800	19	1088.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-226	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
937	LB_166_704_362_1	2023-09-11	2235	\N	3805	19	1012.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-226	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
938	LB_166_696_362_2	2023-09-11	2235	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-226	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
939	LB_167_720_363_0	2023-09-12	2235	\N	3821	19	3551.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80383-80	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
940	LB_168_698_364_0	2023-09-12	2235	\N	3799	19	2940.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-130,M4-80392-100,M4-80392-75	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
941	LB_173_704_371_0	2023-09-15	2235	\N	3805	19	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80401-300	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
942	LB_175_108_373_0	2023-09-15	2235	\N	3209	19	682.480	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80401-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
943	LB_175_737_373_1	2023-09-15	2235	\N	3838	19	3863.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80401-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
944	LB_179_697_377_0	2023-09-20	2234	\N	3798	19	4095.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40558-1182	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
945	LB_179_728_377_1	2023-09-20	2234	\N	3829	19	180.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40558-1182	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
946	LB_180_698_378_0	2023-09-20	2235	\N	3799	19	378.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
947	LB_180_698_378_1	2023-09-20	2235	\N	3799	19	2940.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
948	LB_182_719_380_0	2023-09-22	2235	\N	3820	17	80.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80403-70,M4-80419-120	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
949	LB_184_739_382_0	2023-09-24	2235	\N	3840	19	749.866	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
950	LB_184_740_382_1	2023-09-24	2235	\N	3841	19	1542.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
951	LB_184_742_382_2	2023-09-24	2235	\N	3843	19	318.492	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
952	LB_184_741_382_3	2023-09-24	2235	\N	3842	19	1544.790	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
953	LB_185_739_383_0	2023-09-25	2235	\N	3840	17	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80421-124	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
954	LB_187_743_385_0	2023-09-27	2234	\N	3844	17	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40655-135	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
955	LB_188_704_386_0	2023-09-28	2235	\N	3805	19	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80422-250	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
956	LB_188_699_386_1	2023-09-28	2235	\N	3800	19	680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80422-250	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
957	LB_189_729_387_0	2023-09-29	2235	\N	3830	19	1749.360	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80435-100 NOS, M4-80435-30 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
958	LB_190_696_388_0	2023-10-04	2234	\N	3797	19	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40655-115,M4-40672-118,M4-40672-20	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
959	LB_190_699_388_1	2023-10-04	2234	\N	3800	19	595.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40655-115,M4-40672-118,M4-40672-20	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
960	LB_192_745_390_0	2023-10-05	2235	\N	3846	17	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80443-400 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
961	LB_193_720_393_0	2023-10-07	2235	\N	3821	17	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80445-35,M4-80445-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
962	LB_195_746_395_0	2023-10-07	2234	\N	3847	19	1978.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40728-400	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
963	LB_197_696_397_0	2023-10-10	2271	\N	3797	19	3484.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
964	LB_198_699_398_0	2023-10-10	2235	\N	3800	19	595.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80452-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
965	LB_198_696_398_1	2023-10-10	2235	\N	3797	19	3216.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80452-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
966	LB_199_695_399_0	2023-10-10	2235	\N	3796	19	612.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
967	LB_199_720_399_1	2023-10-10	2235	\N	3821	19	1287.310	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
968	LB_199_722_399_2	2023-10-10	2235	\N	3823	19	1419.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
969	LB_199_695_399_3	2023-10-10	2235	\N	3796	19	2160.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
970	LB_204_696_404_0	2023-10-12	2234	\N	3797	19	3376.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40760-294	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
971	LB_205_696_405_0	2023-10-12	2235	\N	3797	19	3323.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80456-100,M4-80456-100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
972	LB_207_720_407_0	2023-10-13	2235	\N	3821	17	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80457-100,M4-80457-100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
973	LB_207_719_407_1	2023-10-13	2235	\N	3820	17	80.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80457-100,M4-80457-100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
974	LB_209_740_409_0	2023-10-16	2234	\N	3841	19	1598.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40769-50,M4-40776-1000,M4-40720-300	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
975	LB_210_741_410_0	2023-10-17	2235	\N	3842	19	2380.794	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80445-19,M4-80448-7,M4-80452-15,M4-80462-100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
976	LB_211_697_411_0	2023-10-18	2235	\N	3798	19	4095.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80448-10,M4-80462-100,M4-80463-15	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
977	LB_212_740_412_0	2023-10-18	2234	\N	3841	19	391.608	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40795-150	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
978	LB_213_740_413_0	2023-10-20	2235	\N	3841	19	7.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80448-33,M4-80463-15	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
979	LB_214_746_414_0	2023-10-20	2234	\N	3847	19	1463.855	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40779-300,M4-40795-72,M4-40820-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
980	LB_216_699_416_0	2023-10-25	2271	\N	3800	19	1147.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
981	LB_216_696_417_0	2023-10-25	2271	\N	3797	19	6700.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
982	LB_217_695_420_0	2023-10-25	2234	\N	3796	17	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40779-348,M4-40820-246,M4-40838-100,M4-40876-17	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
983	LB_217_722_420_1	2023-10-25	2234	\N	3823	17	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40779-348,M4-40820-246,M4-40838-100,M4-40876-17	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
984	LB_219_746_422_0	2023-10-27	2234	\N	3847	19	2027.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40720-100,M4-40876-83	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
985	LB_220_695_423_0	2023-10-28	2235	\N	3796	19	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80491-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
986	LB_220_696_423_1	2023-10-28	2235	\N	3797	19	804.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80491-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
987	LB_224_719_427_0	2023-10-30	2235	\N	3820	17	90.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80463-55	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
988	LB_228_695_431_0	2023-11-02	2234	\N	3796	17	15.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
989	LB_228_696_431_1	2023-11-02	2234	\N	3797	17	31.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
990	LB_228_720_431_2	2023-11-02	2234	\N	3821	17	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
991	LB_228_722_431_3	2023-11-02	2234	\N	3823	17	30.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
992	LB_228_719_431_4	2023-11-02	2234	\N	3820	17	30.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
993	LB_229_699_432_0	2023-11-03	2234	\N	3800	19	977.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40921-1050,M4-40921-766	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
994	LB_229_699_432_1	2023-11-03	2234	\N	3800	19	1003.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40921-1050,M4-40921-766	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
995	LB_229_717_432_2	2023-11-03	2234	\N	3818	19	130.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40921-1050,M4-40921-766	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
996	LB_231_746_436_0	2023-11-04	2235	\N	3847	19	1792.310	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80488-25,M4-80488-20,M4-80498-20,M4-80498-40	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
997	LB_259_742_437_0	2023-12-11	2271	\N	3843	19	528.854	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	2324U21JM00455,00467,00481,00477,00495,00522	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
998	LB_259_748_437_1	2023-12-11	2271	\N	3849	19	466.950	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	2324U21JM00455,00467,00481,00477,00495,00522	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
999	LB_233_741_438_0	2023-11-06	2234	\N	3842	19	617.916	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40932-100,M4-40933-100	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1000	LB_234_747_439_0	2023-11-08	2234	\N	3848	19	453.339	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40943-500,M4-40943-80,M4-40943-1000	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1001	LB_235_747_440_0	2023-11-09	2235	\N	3848	19	453.339	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80508-100,M4-80508-50	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1002	LB_236_747_441_0	2023-11-09	2234	\N	3848	19	568.896	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40943-678,M4-40958-500	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1003	LB_238_750_443_0	2023-11-15	2235	\N	3851	19	456.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80517-200	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1004	LB_240_747_445_0	2023-11-22	2234	\N	3848	19	453.339	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40967-200 NOS,M4-40966-260 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1005	LB_241_697_446_0	2023-11-22	2235	\N	3798	19	6552.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80528-100 Nos	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1006	LB_242_750_447_0	2023-11-23	2235	\N	3851	19	798.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80526-200NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1007	LB_248_696_453_0	2023-11-30	2235	\N	3797	17	9.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80544-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1008	LB_248_695_453_1	2023-11-30	2235	\N	3796	17	15.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80544-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1009	LB_248_704_453_2	2023-11-30	2235	\N	3805	17	52.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80544-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1010	LB_249_695_454_0	2023-11-30	2234	\N	3796	19	1260.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41077-240NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1011	LB_249_719_454_1	2023-11-30	2234	\N	3820	19	2420.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41077-240NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1012	LB_254_718_459_0	2023-12-06	2235	\N	3819	19	417.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80557-170	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1013	LB_254_718_459_1	2023-12-06	2235	\N	3819	19	222.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80557-170	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1014	LB_255_712_460_0	2023-12-07	2235	\N	3813	19	3280.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80548-90	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1015	LB_257_719_462_0	2023-12-09	2235	\N	3820	19	4235.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80565-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1016	LB_257_722_462_1	2023-12-09	2235	\N	3823	19	946.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80565-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1017	LB_258_741_463_0	2023-12-11	2235	\N	3842	17	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80565-100,M4-80566-112,M4-80567-38 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1018	LB_260_741_464_0	2023-12-12	2235	\N	3842	17	65.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80571-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1019	LB_261_741_465_0	2023-12-13	2235	\N	3842	17	158.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80572-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1020	LB_262_747_466_0	2023-12-14	2234	\N	3848	17	34.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41026-75,M4-41097-75,M4-41123-110	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1021	LB_263_747_467_0	2023-12-15	2235	\N	3848	17	64.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80574-150 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1022	LB_264_746_468_0	2023-12-16	2235	\N	3847	19	2501.935	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80577-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1023	LB_266_746_470_0	2023-12-19	2026	\N	3847	19	2027.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1024	LB_268_697_472_0	2023-12-20	2234	\N	3798	17	33.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41097 -300 NO, M4-41210-86 NO	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1025	LB_269_719_473_0	2023-12-20	2271	\N	3820	19	3025.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	2324U21JM00477,00495,00420,00406,00413,00439	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1026	LB_270_697_474_0	2023-12-20	2235	\N	3798	19	2293.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80583-156	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1027	LB_271_733_475_0	2023-12-22	2235	\N	3834	19	1741.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80586-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1028	LB_272_712_476_0	2023-12-23	2235	\N	3813	19	2460.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80586-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1029	LB_272_698_476_1	2023-12-23	2235	\N	3799	19	2822.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80586-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1030	LB_274_719_478_0	2023-12-25	2235	\N	3820	19	1512.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80587	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1031	LB_274_696_478_1	2023-12-25	2235	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80587	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1032	LB_276_718_480_0	2023-12-27	2235	\N	3819	19	583.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80592-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1033	LB_277_698_481_0	2023-12-27	2235	\N	3799	19	1234.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80593-200 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1034	LB_278_695_482_0	2023-12-28	2235	\N	3796	19	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80583-34 NOS,.M4-80593-200 NOS,M4-80594-100 NOS,M4-80598-36 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1035	LB_278_696_482_1	2023-12-28	2235	\N	3797	19	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80583-34 NOS,.M4-80593-200 NOS,M4-80594-100 NOS,M4-80598-36 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
1036	LB_281_698_485_0	2024-02-23	2234	\N	3799	19	2730.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41236-120 NOS,M4-41236-300 NOS	f	\N	\N	2026-08-03 15:19:00.378505	2026-08-03 15:19:00.378505	[]	[]	\N
\.


--
-- Data for Name: salary_vouchers; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.salary_vouchers (id, voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, allowances, deductions, net_salary, narration, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_adjustments; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.stock_adjustments (id, adjustment_no, adjustment_date, product_id, quantity, reason, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: stock_inward; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.stock_inward (id, inward_no, inward_date, product_id, process_id, ledger_id, quantity, rate, amount, uom_id, narration, serial_no, ref_no, ref_date, expected_duration_days, weight, total_weight, items, is_completed, completed_date, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_item_movements; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.stock_item_movements (id, movement_no, movement_date, movement_type, stock_item_id, ledger_id, quantity, rate, amount, uom_id, ref_no, narration, items, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_outward; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.stock_outward (id, outward_no, outward_date, inward_id, product_id, process_id, ledger_id, quantity, rate, amount, weight, total_weight, uom_id, serial_no, ref_no, narration, items, inward_ids, dispatch_through, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_transfer; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.stock_transfer (id, transfer_no, transfer_date, from_stock_item_id, to_stock_item_id, quantity, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: voucher_lines; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.voucher_lines (id, voucher_id, ledger_id, dr_amount, cr_amount, narration) FROM stdin;
79	45	2018	0.00	30000.00	AMOUNT CREDITED INVOICE NO
80	45	2235	30000.00	0.00	AMOUNT CREDITED INVOICE NO
81	46	2018	0.00	130000.00	AMOUNT CREDITED FOR INVOICE NO
82	46	2235	130000.00	0.00	AMOUNT CREDITED FOR INVOICE NO
83	47	2056	0.00	170.00	POOJA EXPENSES FOR FRIDAY
84	47	2000	170.00	0.00	POOJA EXPENSES FOR FRIDAY
85	48	2236	0.00	150.00	
86	48	2025	150.00	0.00	
87	49	2056	0.00	150.00	MOUNT POINT STONE 10 NOS
88	49	1954	150.00	0.00	MOUNT POINT STONE 10 NOS
89	50	2056	0.00	200.00	PURCHASE OF MILK  COFFEE POWDER SUGAR AND CUP
90	50	1966	200.00	0.00	PURCHASE OF MILK  COFFEE POWDER SUGAR AND CUP
91	40	2248	0.00	2301.00	
92	40	2248	2301.00	0.00	
93	41	2248	0.00	16638.00	
94	41	2248	16638.00	0.00	
95	42	2056	0.00	17437.00	LABOUR CHARGE FOR 8 LABOURS
96	42	2249	17437.00	0.00	LABOUR CHARGE FOR 8 LABOURS
97	43	2056	0.00	5862.00	LABOUR CHARGE
98	43	2250	5862.00	0.00	LABOUR CHARGE
99	44	2056	0.00	13188.00	WEEKLY SALARY
100	44	2249	13188.00	0.00	WEEKLY SALARY
101	51	2272	0.00	50400.00	
102	51	2273	50400.00	0.00	
103	52	2056	0.00	45000.00	FG
104	52	2272	45000.00	0.00	FG
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
45	PAY_1_64	Payment	2023-06-08	2018	30000.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
46	PAY_2_65	Payment	2023-06-16	2018	130000.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
47	PAY_3_75	Payment	2023-06-23	2056	170.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
48	PUR_1_76	Purchase	2023-06-23	2236	150.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
49	PAY_4_77	Payment	2023-06-23	2056	150.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
50	PAY_5_78	Payment	2023-06-23	2056	200.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
40	PUR_1_86	Purchase	2023-06-12	2248	2301.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
41	PUR_2_87	Purchase	2023-06-19	2248	16638.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
42	PAY_6_95	Payment	2023-06-24	2056	17437.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
43	PAY_7_96	Payment	2023-06-24	2056	5862.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
44	PAY_7_132	Payment	2023-07-01	2056	13188.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
51	PUR_3_369	Purchase	2023-09-15	2272	50400.00	Total Amount Include GST		\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
52	PAY_8_370	Payment	2023-09-15	2056	45000.00			\N	2026-08-03 15:18:58.663178	2026-08-03 15:18:58.663178
\.


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
7	ADV_1_29	2024-06-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:02.873863	2026-08-03 15:19:02.873863
8	ADV_2_30	2024-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:02.873863	2026-08-03 15:19:02.873863
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.audit_logs (id, user_id, username, action, module, record_id, old_values, new_values, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: biometric_entries; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.biometric_entries (id, ledger_id, entry_date, punch_in, punch_out, hours_worked, status, device_log_id, created_at) FROM stdin;
\.


--
-- Data for Name: eb_readings; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.eb_readings (id, reading_date, meter_no, previous_reading, current_reading, units_consumed, rate_per_unit, amount, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: job_work_entries; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.job_work_entries (id, entry_no, entry_date, ledger_id, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: labour_bills; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.labour_bills (id, bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, is_paid, payment_date, created_by, created_at, updated_at, items, outward_ids, dispatch_through) FROM stdin;
331	LB_2_756_75_0	2024-07-01	1937	\N	3857	18	1387.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
332	LB_2_756_75_1	2024-07-01	1937	\N	3857	19	1387.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
333	LB_4_770_83_0	2024-07-03	2492	\N	3871	18	890.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
334	LB_4_770_83_1	2024-07-03	2492	\N	3871	19	890.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
335	LB_4_771_83_2	2024-07-03	2492	\N	3872	18	699.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
336	LB_4_771_83_3	2024-07-03	2492	\N	3872	19	699.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
337	LB_5_756_84_0	2024-07-03	2492	\N	3857	18	796.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
338	LB_5_756_84_1	2024-07-03	2492	\N	3857	19	796.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
339	LB_5_756_91_0	2024-07-05	2492	\N	3857	18	925.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
340	LB_5_756_91_1	2024-07-05	2492	\N	3857	19	925.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
341	LB_7_770_93_0	2024-07-06	1937	\N	3871	18	1800.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
342	LB_11_503_137_0	2024-07-18	2492	\N	3604	18	1144.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
343	LB_12_756_138_0	2024-07-18	2492	\N	3857	18	205.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
344	LB_12_756_138_1	2024-07-18	2492	\N	3857	19	205.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
345	LB_12_756_138_2	2024-07-18	2492	\N	3857	18	1207.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
346	LB_12_756_138_3	2024-07-18	2492	\N	3857	19	1207.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
347	LB_13_767_146_0	2024-07-20	2492	\N	3868	18	3150.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
348	LB_13_767_146_1	2024-07-20	2492	\N	3868	19	3150.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
349	LB_14_756_156_0	2024-07-29	1937	\N	3857	18	31.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
350	LB_14_756_156_1	2024-07-29	1937	\N	3857	19	31.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
351	LB_14_756_156_2	2024-07-29	1937	\N	3857	18	26.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
352	LB_14_756_156_3	2024-07-29	1937	\N	3857	19	26.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
353	LB_14_756_156_4	2024-07-29	1937	\N	3857	18	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
354	LB_14_756_156_5	2024-07-29	1937	\N	3857	19	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
355	LB_15_756_157_0	2024-07-30	1937	\N	3857	18	53.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
356	LB_15_756_157_1	2024-07-30	1937	\N	3857	19	53.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
357	LB_17_757_159_0	2024-07-30	2492	\N	3858	18	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
358	LB_17_757_159_1	2024-07-30	2492	\N	3858	19	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
359	LB_18_756_160_0	2024-07-30	1937	\N	3857	18	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
360	LB_18_756_160_1	2024-07-30	1937	\N	3857	19	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
361	LB_18_756_160_2	2024-07-30	1937	\N	3857	18	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
362	LB_18_756_160_3	2024-07-30	1937	\N	3857	19	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
363	LB_18_756_160_4	2024-07-30	1937	\N	3857	18	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
364	LB_18_756_160_5	2024-07-30	1937	\N	3857	19	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
365	LB_19_756_161_0	2024-08-02	1937	\N	3857	18	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
366	LB_19_756_161_1	2024-08-02	1937	\N	3857	19	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
367	LB_20_758_162_0	2024-08-14	1937	\N	3859	18	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
368	LB_20_758_162_1	2024-08-14	1937	\N	3859	19	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
369	LB_21_796_163_0	2024-08-14	1937	\N	3897	19	50.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
370	LB_21_797_163_1	2024-08-14	1937	\N	3898	19	27.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
371	LB_22_797_164_0	2024-08-14	2492	\N	3898	17	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
372	LB_23_767_166_0	2024-08-21	2492	\N	3868	18	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
373	LB_23_767_166_1	2024-08-21	2492	\N	3868	19	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
374	LB_26_756_169_0	2024-08-24	2492	\N	3857	18	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
375	LB_26_756_169_1	2024-08-24	2492	\N	3857	19	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
376	LB_26_756_169_2	2024-08-24	2492	\N	3857	18	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
377	LB_26_756_169_3	2024-08-24	2492	\N	3857	19	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
378	LB_30_503_173_0	2024-08-28	1937	\N	3604	18	1366.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
379	LB_31_757_174_0	2024-08-29	2492	\N	3858	18	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
380	LB_31_757_174_1	2024-08-29	2492	\N	3858	19	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
381	LB_31_758_174_2	2024-08-29	2492	\N	3859	18	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
382	LB_31_758_174_3	2024-08-29	2492	\N	3859	19	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
383	LB_31_758_174_4	2024-08-29	2492	\N	3859	18	34.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
384	LB_31_758_174_5	2024-08-29	2492	\N	3859	19	34.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
385	LB_31_758_174_6	2024-08-29	2492	\N	3859	18	28.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
386	LB_31_758_174_7	2024-08-29	2492	\N	3859	19	28.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
387	LB_32_756_175_0	2024-08-29	2492	\N	3857	18	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
388	LB_32_756_175_1	2024-08-29	2492	\N	3857	19	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
389	LB_32_756_175_2	2024-08-29	2492	\N	3857	18	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
390	LB_32_756_175_3	2024-08-29	2492	\N	3857	19	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
391	LB_33_798_176_0	2024-08-30	1937	\N	3899	18	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
392	LB_33_798_176_1	2024-08-30	1937	\N	3899	19	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
393	LB_33_798_176_2	2024-08-30	1937	\N	3899	18	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
394	LB_33_798_176_3	2024-08-30	1937	\N	3899	19	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
395	LB_34_756_177_0	2024-08-31	1937	\N	3857	18	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
396	LB_34_756_177_1	2024-08-31	1937	\N	3857	19	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
397	LB_34_756_177_2	2024-08-31	1937	\N	3857	18	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
398	LB_34_756_177_3	2024-08-31	1937	\N	3857	19	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
399	LB_34_756_177_4	2024-08-31	1937	\N	3857	18	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
400	LB_34_756_177_5	2024-08-31	1937	\N	3857	19	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
401	LB_34_798_177_6	2024-08-31	1937	\N	3899	18	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
402	LB_34_798_177_7	2024-08-31	1937	\N	3899	19	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
403	LB_34_798_177_8	2024-08-31	1937	\N	3899	18	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
404	LB_34_798_177_9	2024-08-31	1937	\N	3899	19	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
405	LB_36_799_179_0	2024-09-03	1937	\N	3900	18	115.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
406	LB_36_799_179_1	2024-09-03	1937	\N	3900	19	115.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
407	LB_36_800_179_2	2024-09-03	1937	\N	3901	18	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
408	LB_36_800_179_3	2024-09-03	1937	\N	3901	19	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
409	LB_36_765_179_4	2024-09-03	1937	\N	3866	18	82.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
410	LB_36_765_179_5	2024-09-03	1937	\N	3866	19	82.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
411	LB_37_764_180_0	2024-09-04	1937	\N	3865	18	45.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
412	LB_37_764_180_1	2024-09-04	1937	\N	3865	19	45.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
413	LB_39_756_183_0	2024-09-12	2492	\N	3857	18	38.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
414	LB_39_756_183_1	2024-09-12	2492	\N	3857	19	38.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
415	LB_39_756_183_2	2024-09-12	2492	\N	3857	18	14.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
416	LB_39_756_183_3	2024-09-12	2492	\N	3857	19	14.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
417	LB_39_757_183_4	2024-09-12	2492	\N	3858	18	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
418	LB_39_757_183_5	2024-09-12	2492	\N	3858	19	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
419	LB_39_799_183_6	2024-09-12	2492	\N	3900	18	122.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
420	LB_39_799_183_7	2024-09-12	2492	\N	3900	19	122.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
421	LB_40_802_185_0	2024-09-17	2492	\N	3903	18	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
422	LB_40_801_185_1	2024-09-17	2492	\N	3902	18	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
423	LB_42_808_189_0	2024-09-19	1945	\N	3909	17	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
424	LB_42_809_189_1	2024-09-19	1945	\N	3910	17	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
425	LB_42_807_189_2	2024-09-19	1945	\N	3908	17	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
426	LB_42_805_189_3	2024-09-19	1945	\N	3906	17	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
427	LB_43_764_190_0	2024-09-19	2492	\N	3865	18	67.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
428	LB_43_764_190_1	2024-09-19	2492	\N	3865	18	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
429	LB_43_781_190_2	2024-09-19	2492	\N	3882	18	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
430	LB_45_635_192_0	2024-09-25	2492	\N	3671	18	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
431	LB_45_635_192_1	2024-09-25	2492	\N	3671	19	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
432	LB_45_635_192_2	2024-09-25	2492	\N	3671	20	2.175	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
433	LB_48_73_197_0	2024-10-22	2492	\N	3174	18	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
434	LB_48_645_197_1	2024-10-22	2492	\N	3681	18	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
435	LB_48_813_197_2	2024-10-22	2492	\N	3914	18	10.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
436	LB_48_59_197_3	2024-10-22	2492	\N	3161	18	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
437	LB_48_97_197_4	2024-10-22	2492	\N	3198	18	6.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
438	LB_48_300_197_5	2024-10-22	2492	\N	3401	18	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
439	LB_48_693_197_6	2024-10-22	2492	\N	3794	18	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
440	LB_49_90_198_0	2024-10-28	2492	\N	3191	17	15.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:02.731829	2026-08-03 15:19:02.731829	[]	[]	\N
\.


--
-- Data for Name: salary_vouchers; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.salary_vouchers (id, voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, allowances, deductions, net_salary, narration, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_adjustments; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.stock_adjustments (id, adjustment_no, adjustment_date, product_id, quantity, reason, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: stock_inward; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.stock_inward (id, inward_no, inward_date, product_id, process_id, ledger_id, quantity, rate, amount, uom_id, narration, serial_no, ref_no, ref_date, expected_duration_days, weight, total_weight, items, is_completed, completed_date, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_item_movements; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.stock_item_movements (id, movement_no, movement_date, movement_type, stock_item_id, ledger_id, quantity, rate, amount, uom_id, ref_no, narration, items, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_outward; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.stock_outward (id, outward_no, outward_date, inward_id, product_id, process_id, ledger_id, quantity, rate, amount, weight, total_weight, uom_id, serial_no, ref_no, narration, items, inward_ids, dispatch_through, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_transfer; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.stock_transfer (id, transfer_no, transfer_date, from_stock_item_id, to_stock_item_id, quantity, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: voucher_lines; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.voucher_lines (id, voucher_id, ledger_id, dr_amount, cr_amount, narration) FROM stdin;
1663	838	1989	0.00	16992.00	
1664	838	2289	16992.00	0.00	
1665	839	1913	0.00	23010.00	
1666	839	2289	23010.00	0.00	
1667	840	1980	0.00	1800.00	
1668	840	1996	1800.00	0.00	
1669	841	2018	0.00	16992.00	PURCHASE OF STEEL SHOTS
1670	841	1989	16992.00	0.00	PURCHASE OF STEEL SHOTS
1671	842	2018	0.00	11500.00	PURCHASE  OF WIRE CUT SHOTS
1672	842	1913	11500.00	0.00	PURCHASE  OF WIRE CUT SHOTS
1673	843	2018	0.00	1800.00	PURCHASE OF GLOUSE
1674	843	1980	1800.00	0.00	PURCHASE OF GLOUSE
1675	844	2018	0.00	6000.00	PURCASE OF PLYWOOD
1676	844	1954	6000.00	0.00	PURCASE OF PLYWOOD
1677	845	2018	0.00	1500.00	EXPENSES MADE FOR AUTO MURUGESAN
1678	845	1914	1500.00	0.00	EXPENSES MADE FOR AUTO MURUGESAN
1679	846	2018	0.00	3200.00	PURCHASE OF TUBE
1680	846	1915	3200.00	0.00	PURCHASE OF TUBE
1681	847	2018	0.00	1000.00	MIS ACC PURCHASED BY SHIVA
1682	847	1954	1000.00	0.00	MIS ACC PURCHASED BY SHIVA
1683	848	2018	0.00	3000.00	CASH PAID TO VEL CAMERA WIRING
1684	848	1916	3000.00	0.00	CASH PAID TO VEL CAMERA WIRING
1685	849	2018	0.00	3200.00	PURCHASE OF AIRTEL BROAD BAND
1686	849	1954	3200.00	0.00	PURCHASE OF AIRTEL BROAD BAND
1687	850	2056	0.00	1000.00	MURUGESH  GANDHIPURAM TO KNG PUDUR
1688	850	1914	1000.00	0.00	MURUGESH  GANDHIPURAM TO KNG PUDUR
1689	851	2018	0.00	3000.00	WORK DONE FOR NEW THUMB BLASTING MACH  PRAKESH
1690	851	1919	3000.00	0.00	WORK DONE FOR NEW THUMB BLASTING MACH  PRAKESH
1691	852	2056	0.00	150.00	Food Purchse For Hindhi Labour
1692	852	1966	150.00	0.00	Food Purchse For Hindhi Labour
1693	853	2018	0.00	505.00	Purchase Of Bolt Nuts And Crew
1694	853	2002	505.00	0.00	Purchase Of Bolt Nuts And Crew
1695	854	2018	0.00	50.00	Tea
1696	854	1966	50.00	0.00	Tea
1697	855	2018	0.00	130.00	Hose
1698	855	1915	130.00	0.00	Hose
1699	856	2018	0.00	450.00	Food
1700	856	1966	450.00	0.00	Food
1701	857	2018	0.00	150.00	Swith Purchase For Camera
1702	857	1919	150.00	0.00	Swith Purchase For Camera
1703	858	2018	0.00	1530.00	Card Board Sheet
1704	858	1954	1530.00	0.00	Card Board Sheet
1705	859	2018	0.00	800.00	Nillon Bush
1706	890	2018	0.00	50.00	TEA
1707	890	1966	50.00	0.00	TEA
1708	891	2018	0.00	1180.00	PURCHASE OF ACCOUNTS NOTE AND
1709	891	1982	1180.00	0.00	PURCHASE OF ACCOUNTS NOTE AND
1710	892	2018	0.00	250.00	LATHE WORK
1711	892	1932	250.00	0.00	LATHE WORK
1712	893	2018	0.00	250.00	CHAIN LOCK
1713	893	1932	250.00	0.00	CHAIN LOCK
1714	894	2018	0.00	300.00	SANTOR MACHINE SERVICE
1715	894	1932	300.00	0.00	SANTOR MACHINE SERVICE
1716	895	2018	0.00	140.00	WATER
1717	895	1967	140.00	0.00	WATER
1718	896	2018	0.00	300.00	BATHROOM CLEANING
1719	896	1936	300.00	0.00	BATHROOM CLEANING
1720	897	2018	0.00	150.00	TEA AND COFFEE AND BATTERY
1721	897	1966	150.00	0.00	TEA AND COFFEE AND BATTERY
1722	898	2018	0.00	100.00	BUS PIN
1723	898	1932	100.00	0.00	BUS PIN
1724	899	2018	0.00	500.00	FLEX BOARD FOR COMPANY
1725	899	1967	500.00	0.00	FLEX BOARD FOR COMPANY
1726	900	2018	0.00	2500.00	Power Factor Labour And Coil
1727	900	2002	2500.00	0.00	Power Factor Labour And Coil
1728	901	2018	0.00	700.00	Hose ,Ms Plate ,Lath Work
1729	901	2002	700.00	0.00	Hose ,Ms Plate ,Lath Work
1730	902	2018	0.00	400.00	
1731	902	1963	400.00	0.00	
1732	859	1954	800.00	0.00	Nillon Bush
1733	860	2018	0.00	770.00	Purchase Of Swith
1734	860	1919	770.00	0.00	Purchase Of Swith
1735	861	2018	0.00	100.00	Shiva
1736	861	1981	100.00	0.00	Shiva
1737	862	2018	0.00	40.00	Water
1738	862	1966	40.00	0.00	Water
1739	863	2018	0.00	600.00	Rent A Cutting Machine
1740	863	2002	600.00	0.00	Rent A Cutting Machine
1741	864	2018	0.00	5500.00	AMOUNT
1742	864	1916	5500.00	0.00	AMOUNT
1743	865	2018	0.00	5000.00	PRAKESH
1744	865	1919	5000.00	0.00	PRAKESH
1745	867	2018	0.00	10384.00	PURCHASE OF GRINDING STONE
1746	867	1930	10384.00	0.00	PURCHASE OF GRINDING STONE
1747	866	1930	0.00	10384.00	
1748	866	1931	10384.00	0.00	
1749	868	1930	0.00	2242.00	
1750	868	1931	2242.00	0.00	
1751	869	2018	0.00	2242.00	PURCHASE OF 9 INCH WHEEL
1752	869	1930	2242.00	0.00	PURCHASE OF 9 INCH WHEEL
1753	870	2018	0.00	500.00	PAID FOR MS BUSH
1754	870	1954	500.00	0.00	PAID FOR MS BUSH
1755	885	2018	0.00	500.00	PURCHASE OF VEGETABLE
1756	885	2249	500.00	0.00	PURCHASE OF VEGETABLE
1757	886	2018	0.00	3500.00	LABOUR CHARGES FOR PLYWOOD SHEET
1758	886	1933	3500.00	0.00	LABOUR CHARGES FOR PLYWOOD SHEET
1759	887	2018	0.00	210.00	BOLT AND NUT
1760	887	1954	210.00	0.00	BOLT AND NUT
1761	888	2018	0.00	750.00	AG7 WHEEL
1762	888	1954	750.00	0.00	AG7 WHEEL
1763	889	2018	0.00	50.00	WATER 20 LITER CAN
1764	889	1967	50.00	0.00	WATER 20 LITER CAN
1765	905	2018	0.00	1300.00	TRIPPER,HOSE WIRE FOR SUNG MACHINE
1766	905	2002	1300.00	0.00	TRIPPER,HOSE WIRE FOR SUNG MACHINE
1767	906	2018	0.00	200.00	TAG BFILE,BOX FILE
1768	907	2018	0.00	300.00	TOILET CLEANING
1769	907	1967	300.00	0.00	TOILET CLEANING
1770	908	2018	0.00	100.00	SARAVANAN LUNCH
1771	908	1966	100.00	0.00	SARAVANAN LUNCH
1772	909	2018	0.00	753.00	FLOWER,VESSEL
1773	909	2000	753.00	0.00	FLOWER,VESSEL
1774	910	1930	0.00	380.00	
1775	910	1954	380.00	0.00	
1776	911	2018	0.00	150.00	DRINKING WATER,MILK
1777	911	1966	150.00	0.00	DRINKING WATER,MILK
1778	912	2018	0.00	380.00	GPAY TO NAGARAJ
1779	912	1930	380.00	0.00	GPAY TO NAGARAJ
1780	913	2018	0.00	200.00	SUNG MACHINE WELDING
1781	913	1933	200.00	0.00	SUNG MACHINE WELDING
1782	914	2018	0.00	120.00	
1783	914	1947	120.00	0.00	
1784	915	2018	0.00	800.00	800 LTS
1785	915	1963	800.00	0.00	800 LTS
1786	916	2018	0.00	30.00	
1787	916	1947	30.00	0.00	
1788	917	2018	0.00	150.00	MOTAR PIPE
1789	917	1932	150.00	0.00	MOTAR PIPE
1790	918	2018	0.00	100.00	FOOD BABU
1791	918	1966	100.00	0.00	FOOD BABU
1792	919	2018	0.00	300.00	SWITCH BOX
1793	919	1919	300.00	0.00	SWITCH BOX
1794	920	2018	0.00	1100.00	GLASS CUP
1795	920	1967	1100.00	0.00	GLASS CUP
1796	921	2018	0.00	10000.00	NEW PURCHASE ADVANCE (BUFFING MOTAR)
1797	921	1976	10000.00	0.00	NEW PURCHASE ADVANCE (BUFFING MOTAR)
1798	922	2018	0.00	650.00	
1799	922	2000	650.00	0.00	
1800	923	2018	0.00	50.00	MILK
1801	923	1947	50.00	0.00	MILK
1802	924	2018	0.00	7434.00	2 GRINING WHEEL,10 AG9 WHEEL
1803	924	1930	7434.00	0.00	2 GRINING WHEEL,10 AG9 WHEEL
1804	925	2018	0.00	5001.00	ADVANCE
1805	925	1944	5001.00	0.00	ADVANCE
1806	926	2018	0.00	5000.00	GENSET RENT
1807	926	1932	5000.00	0.00	GENSET RENT
1808	927	2018	0.00	300.00	LUNCH
1809	927	1966	300.00	0.00	LUNCH
1810	928	1930	0.00	7434.00	
1811	928	1954	7434.00	0.00	
1812	929	2018	28594.00	0.00	CASH RECEIVED THROUGH BANK
1813	929	1937	0.00	28594.00	CASH RECEIVED THROUGH BANK
1814	930	2018	32926.00	0.00	PAYMENT RECEIVED Bill No 1-6
1815	930	1988	0.00	32926.00	PAYMENT RECEIVED Bill No 1-6
1816	903	2018	0.00	100.00	Tea
1817	903	1966	100.00	0.00	Tea
1818	904	2018	0.00	300.00	Carbon Brush
1819	904	2002	300.00	0.00	Carbon Brush
1820	871	2018	0.00	50.00	Tea
1821	871	1966	50.00	0.00	Tea
1822	872	2018	0.00	100.00	Tea
1823	872	1966	100.00	0.00	Tea
1824	873	2018	0.00	100.00	Files
1825	873	2012	100.00	0.00	Files
1826	874	2018	0.00	200.00	TEA
1827	874	1966	200.00	0.00	TEA
1828	875	2018	0.00	400.00	JALLI,CEMENT HALF BAG FOR SUNG MACHINE
1829	876	2018	0.00	500.00	DRILLING MACHINE RENT
1830	876	1932	500.00	0.00	DRILLING MACHINE RENT
1831	877	2018	0.00	1000.00	SUNG MACHINE HOLES LABOUR CHARGES
1832	877	1967	1000.00	0.00	SUNG MACHINE HOLES LABOUR CHARGES
1833	878	2018	0.00	3750.00	AG9 MACHINE
1834	878	1932	3750.00	0.00	AG9 MACHINE
1835	879	2056	0.00	100.00	SHIVA
1836	879	1981	100.00	0.00	SHIVA
1837	880	2056	0.00	500.00	29/6/2024 To 5/7/2024
1838	880	1947	500.00	0.00	29/6/2024 To 5/7/2024
1839	881	2056	0.00	280.00	Water
1840	881	1966	280.00	0.00	Water
1841	882	2018	0.00	1000.00	LABOUR CHARGES
1842	882	1933	1000.00	0.00	LABOUR CHARGES
1843	883	2018	0.00	800.00	CALCULATOR
1844	883	2012	800.00	0.00	CALCULATOR
1845	884	2018	0.00	400.00	
1846	884	2000	400.00	0.00	
1847	1081	2018	0.00	100.00	RAHUL LUNCH
1848	1081	1946	100.00	0.00	RAHUL LUNCH
1849	1082	2018	0.00	100.00	MARIMUTHU
1850	1082	1946	100.00	0.00	MARIMUTHU
1851	1083	2018	0.00	100.00	RAJ KUMAR
1852	1083	1946	100.00	0.00	RAJ KUMAR
1853	1084	2018	0.00	5000.00	AC FITTING
1854	1084	2220	5000.00	0.00	AC FITTING
1855	1085	2018	0.00	510.00	Grinding Stone Purchase
1856	1085	1931	510.00	0.00	Grinding Stone Purchase
1857	1086	2018	0.00	650.00	Cutter And Blue Paint
1858	1086	1932	650.00	0.00	Cutter And Blue Paint
1859	1087	2018	0.00	100.00	Tea
1860	1087	1947	100.00	0.00	Tea
1861	1088	2018	0.00	90.00	Rajkumar
1862	1088	1946	90.00	0.00	Rajkumar
1863	1089	2018	0.00	90.00	Janarthan
1864	1089	1946	90.00	0.00	Janarthan
1865	1090	2018	0.00	60.00	Rahul
1866	1090	1946	60.00	0.00	Rahul
1867	1091	2018	0.00	20.00	Ranjitha
1868	1091	1946	20.00	0.00	Ranjitha
1869	1092	2018	0.00	100.00	Water
1870	1092	2217	100.00	0.00	Water
1871	1093	2010	0.00	24898.00	
1872	1093	1954	24898.00	0.00	
1873	1094	2018	0.00	115.00	TEA
1874	1094	1947	115.00	0.00	TEA
1875	1095	2018	0.00	60.00	RAHUL
1876	1095	1946	60.00	0.00	RAHUL
1877	1096	2018	0.00	90.00	SELVAM
1878	1096	1946	90.00	0.00	SELVAM
1879	1097	2018	0.00	90.00	RAJ KUMAR
1880	1097	1946	90.00	0.00	RAJ KUMAR
1881	1098	2018	0.00	90.00	JANARTHAN
1882	1098	1946	90.00	0.00	JANARTHAN
1883	932	2018	0.00	1500.00	REWORK TABLE
1884	932	1933	1500.00	0.00	REWORK TABLE
1885	931	2018	0.00	2000.00	CORNER BED WORK
1886	931	1933	2000.00	0.00	CORNER BED WORK
1887	933	2018	0.00	500.00	MACHINE FOR RENT
1888	933	1932	500.00	0.00	MACHINE FOR RENT
1889	934	2018	0.00	275.00	CUTTING WHEEL,BOLT,WELDING ROD
1890	934	2002	275.00	0.00	CUTTING WHEEL,BOLT,WELDING ROD
1891	935	2018	0.00	1000.00	CORNER BED JALLI, CEMENT ,MANAL,JANATHACEM
1892	936	2018	0.00	100.00	SHIVA
1893	936	1981	100.00	0.00	SHIVA
1894	937	2018	0.00	700.00	RICE FROM RATION
1895	937	1966	700.00	0.00	RICE FROM RATION
1896	938	2018	0.00	700.00	LUNCH
1897	938	1966	700.00	0.00	LUNCH
1898	939	2018	0.00	1908.00	ANGLE FOR REWORK TABLE BOLT AND NUT AUTO RENT
1899	939	1932	1908.00	0.00	ANGLE FOR REWORK TABLE BOLT AND NUT AUTO RENT
1900	940	2018	30560.00	0.00	Payment Received
1901	940	1937	0.00	30560.00	Payment Received
1902	941	2018	30000.00	0.00	
1903	941	1988	0.00	30000.00	
1904	942	2018	35000.00	0.00	
1905	942	1937	0.00	35000.00	
1906	943	2018	17151.00	0.00	
1907	943	1937	0.00	17151.00	
1908	944	2018	40000.00	0.00	RTGST
1909	944	1988	0.00	40000.00	RTGST
1910	945	2018	0.00	1250.00	Ag9 Wheel Purchased
1911	945	1931	1250.00	0.00	Ag9 Wheel Purchased
1912	946	2018	0.00	1000.00	Lineman Nagaraj
1913	946	1967	1000.00	0.00	Lineman Nagaraj
1914	947	2018	42847.00	0.00	Payment Received
1915	947	1988	0.00	42847.00	Payment Received
1916	948	2018	75000.00	0.00	
1917	948	1988	0.00	75000.00	
1918	949	2010	0.00	24898.00	
1919	949	1954	24898.00	0.00	
1920	950	1952	0.00	20296.00	
1921	950	1954	20296.00	0.00	
1922	951	2117	0.00	12730.00	
1923	951	1954	12730.00	0.00	
1924	952	2117	0.00	23300.00	
1925	952	1954	23300.00	0.00	
1926	953	1913	0.00	32500.00	
1927	953	1954	32500.00	0.00	
1928	954	2018	0.00	2400.00	PURCHASE OF HELMET JACKET
1929	954	1967	2400.00	0.00	PURCHASE OF HELMET JACKET
1930	955	2018	0.00	2200.00	BALAJI TOOLS HAMMER PURCHASE
1931	955	1967	2200.00	0.00	BALAJI TOOLS HAMMER PURCHASE
1932	956	2018	0.00	100.00	CASH PAID TO SHIVA
1933	956	1981	100.00	0.00	CASH PAID TO SHIVA
1934	957	2018	0.00	100000.00	CASH PAID FOR CRANE ADVANCE
1935	957	1967	100000.00	0.00	CASH PAID FOR CRANE ADVANCE
1936	958	2018	0.00	150.00	AG4 MACHINE RENT
1937	958	1967	150.00	0.00	AG4 MACHINE RENT
1938	959	2018	0.00	300.00	CUTTING WHEEL 20 NOS
1939	959	1967	300.00	0.00	CUTTING WHEEL 20 NOS
1940	960	2018	0.00	225.00	PURCHASE OF MEALS 3 NOS
1941	960	1966	225.00	0.00	PURCHASE OF MEALS 3 NOS
1942	961	2018	0.00	3500.00	LORRY RENT FOR SHIFTING CRANE
1943	961	1949	3500.00	0.00	LORRY RENT FOR SHIFTING CRANE
1944	962	2018	0.00	2000.00	CRANR LOADING
1945	962	1967	2000.00	0.00	CRANR LOADING
1946	963	2018	0.00	5500.00	CRANE DISMANDLED LABOUR CHARGE
1947	963	1932	5500.00	0.00	CRANE DISMANDLED LABOUR CHARGE
1948	964	2018	0.00	200.00	TEA EXPENSES
1949	964	1947	200.00	0.00	TEA EXPENSES
1950	965	2018	0.00	2000.00	WELDING SALARY
1951	965	1933	2000.00	0.00	WELDING SALARY
1952	966	2018	0.00	1500.00	CRANE UNLOADING CHARGE
1953	966	1967	1500.00	0.00	CRANE UNLOADING CHARGE
1954	967	2018	0.00	100.00	PETROL
1955	967	1981	100.00	0.00	PETROL
1956	968	2018	0.00	24898.00	PURCHASE OF PAINT
1957	968	2010	24898.00	0.00	PURCHASE OF PAINT
1958	969	2018	0.00	12730.00	SHEET PURCHASE
1959	969	2117	12730.00	0.00	SHEET PURCHASE
1960	970	2018	0.00	500.00	AUTO
1961	970	1914	500.00	0.00	AUTO
1962	971	2018	0.00	400.00	WHEEL
1963	971	1967	400.00	0.00	WHEEL
1964	972	2018	0.00	150.00	RAVI LUNCH
1965	972	1933	150.00	0.00	RAVI LUNCH
1966	973	2018	0.00	150.00	SELVAM RAJ KUMAR LUNCH
1967	973	1946	150.00	0.00	SELVAM RAJ KUMAR LUNCH
1968	974	2018	0.00	60000.00	RENT FOR THE MONTH FEB 2025
1969	974	2122	60000.00	0.00	RENT FOR THE MONTH FEB 2025
1970	975	2018	0.00	4000.00	EB
1971	975	1948	4000.00	0.00	EB
1972	976	2018	0.00	500.00	LABOUR
1973	976	1933	500.00	0.00	LABOUR
1974	977	2018	0.00	700.00	BABU MECHENICS FOR CHANGE AIRHOUSE
1975	977	2123	700.00	0.00	BABU MECHENICS FOR CHANGE AIRHOUSE
1976	978	2018	0.00	400.00	WELDING ROD
1977	978	1967	400.00	0.00	WELDING ROD
1978	979	2018	0.00	150.00	2NO'S LUNCH FOR RAVI AND RAJAN
1979	979	1933	150.00	0.00	2NO'S LUNCH FOR RAVI AND RAJAN
1980	980	2018	0.00	100.00	2 CAN WATER 40 LITER
1981	980	2217	100.00	0.00	2 CAN WATER 40 LITER
1982	981	2018	0.00	800.00	SELVAN MONDAY SALARY
1983	981	2218	800.00	0.00	SELVAN MONDAY SALARY
1984	982	2018	0.00	100.00	AUTO RENT
1985	982	1914	100.00	0.00	AUTO RENT
1986	983	2018	0.00	750.00	RAJAN SALARY
1987	983	2219	750.00	0.00	RAJAN SALARY
1988	984	2018	0.00	3000.00	RAVI WELDING
1989	984	1933	3000.00	0.00	RAVI WELDING
1990	985	2018	0.00	150.00	TEA
1991	985	1947	150.00	0.00	TEA
1992	986	2018	0.00	10000.00	OFFICE FALSELING G PAY
1993	986	2220	10000.00	0.00	OFFICE FALSELING G PAY
1994	987	2018	0.00	4000.00	TUBE LIGHT FITTING
1995	987	2220	4000.00	0.00	TUBE LIGHT FITTING
1996	988	2018	0.00	100.00	TEA
1997	988	1947	100.00	0.00	TEA
1998	989	2018	0.00	2000.00	OFFICE FALSELING BALANCE PAYMENT
1999	989	2220	2000.00	0.00	OFFICE FALSELING BALANCE PAYMENT
2000	990	2018	0.00	250.00	LUNCH FOR RAVI (3, RAJAN)
2001	990	1946	250.00	0.00	LUNCH FOR RAVI (3, RAJAN)
2002	991	2018	0.00	100.00	PETROL SHIVA
2003	991	1981	100.00	0.00	PETROL SHIVA
2004	992	2018	0.00	700.00	RAJAN SALARY
2005	992	2219	700.00	0.00	RAJAN SALARY
2006	993	2018	0.00	100.00	TEA
2007	993	1947	100.00	0.00	TEA
2008	994	2018	0.00	100.00	RAJAN LUNCH
2009	994	1946	100.00	0.00	RAJAN LUNCH
2010	995	2018	0.00	100.00	CAN WATER
2011	995	2217	100.00	0.00	CAN WATER
2012	996	2018	0.00	300.00	Bolt,Snack,
2013	996	1967	300.00	0.00	Bolt,Snack,
2014	997	2018	0.00	200.00	Ravi Lunch
2015	997	1933	200.00	0.00	Ravi Lunch
2016	998	2018	0.00	2100.00	Crane
2017	998	1967	2100.00	0.00	Crane
2018	999	2018	0.00	2000.00	Ravi Salary
2019	999	1933	2000.00	0.00	Ravi Salary
2020	1000	2018	0.00	400.00	Oil,Pipe
2021	1000	1967	400.00	0.00	Oil,Pipe
2022	1001	2018	0.00	100.00	Tea
2023	1001	1947	100.00	0.00	Tea
2024	1002	2018	0.00	20300.00	T.V Bros
2025	1002	1952	20300.00	0.00	T.V Bros
2026	1003	2018	0.00	350.00	Welding Rod
2027	1003	1967	350.00	0.00	Welding Rod
2028	1004	2018	0.00	280.00	5 No's Lunch
2029	1004	1946	280.00	0.00	5 No's Lunch
2030	1005	2018	0.00	1200.00	Auto Rent For Turbonail Gp Paint
2031	1005	1914	1200.00	0.00	Auto Rent For Turbonail Gp Paint
2032	1006	2018	0.00	3200.00	Gear Wheel , Bolt
2033	1006	1967	3200.00	0.00	Gear Wheel , Bolt
2034	1007	2018	0.00	100.00	Tea
2035	1007	1947	100.00	0.00	Tea
2036	1008	2018	0.00	2000.00	Ravi Welding
2037	1008	1933	2000.00	0.00	Ravi Welding
2038	1009	2018	0.00	500.00	Panel Erection Labour
2039	1009	1966	500.00	0.00	Panel Erection Labour
2040	1010	2018	0.00	23300.00	3mm Sheet
2041	1010	1967	23300.00	0.00	3mm Sheet
2042	1011	2018	0.00	100.00	Petrol
2043	1011	1981	100.00	0.00	Petrol
2044	1012	2018	0.00	100.00	Tea
2045	1012	1947	100.00	0.00	Tea
2046	1013	2018	0.00	10000.00	Room Advance
2047	1013	2223	10000.00	0.00	Room Advance
2048	1014	2018	0.00	650.00	MCB Purchase
2049	1014	1919	650.00	0.00	MCB Purchase
2050	1015	2018	0.00	100.00	Tea
2051	1015	1947	100.00	0.00	Tea
2052	1016	2018	0.00	230.00	Lunch For 4 members
2053	1016	1966	230.00	0.00	Lunch For 4 members
2054	1017	2018	0.00	120.00	Ravi Lunch
2055	1017	1933	120.00	0.00	Ravi Lunch
2056	1018	2018	0.00	50.00	Can Water
2057	1042	2018	0.00	9600.00	Cement, Hollo Bricks
2058	1043	2018	0.00	700.00	Pooja Expenses
2059	1043	2220	700.00	0.00	Pooja Expenses
2060	1044	2018	0.00	200.00	Tea
2061	1044	1947	200.00	0.00	Tea
2062	1045	2018	0.00	100.00	Bolt
2063	1045	1967	100.00	0.00	Bolt
2064	1046	2018	0.00	11000.00	Panel Board Service Labour
2065	1046	1966	11000.00	0.00	Panel Board Service Labour
2066	1047	2018	0.00	200.00	Tea
2067	1047	1947	200.00	0.00	Tea
2068	1048	2226	0.00	7316.00	
2069	1048	1954	7316.00	0.00	
2070	1049	1952	0.00	20296.00	
2071	1049	1954	20296.00	0.00	
2072	1050	2018	0.00	2263.00	FOR OFFICE  PRINTING & STATIONARY
2073	1050	2012	2263.00	0.00	FOR OFFICE  PRINTING & STATIONARY
2074	1051	2018	0.00	250.00	LADDU (SWEETS)
2075	1051	2000	250.00	0.00	LADDU (SWEETS)
2076	1052	2018	0.00	30.00	KALKADU (SWEET)
2077	1052	2000	30.00	0.00	KALKADU (SWEET)
2078	1053	2018	0.00	1100.00	GLASS BALANCE PAID
2079	1053	2220	1100.00	0.00	GLASS BALANCE PAID
2080	1054	2018	0.00	3000.00	CRANE SERVICE LABOUR
2081	1054	1966	3000.00	0.00	CRANE SERVICE LABOUR
2082	1055	2018	0.00	200.00	CRANE LABOUR LUNCH
2083	1055	1946	200.00	0.00	CRANE LABOUR LUNCH
2084	1056	2018	0.00	100.00	ANAND DRIVER LUNCH
2085	1056	1946	100.00	0.00	ANAND DRIVER LUNCH
2086	1057	2018	0.00	100.00	MARIMUTHU LUNCH
2087	1057	1946	100.00	0.00	MARIMUTHU LUNCH
2088	1058	2018	0.00	80.00	RAGHUL
2089	1058	1946	80.00	0.00	RAGHUL
2090	1059	2018	0.00	400.00	TEA EXPENSES
2091	1059	1947	400.00	0.00	TEA EXPENSES
2092	1060	2018	0.00	100.00	SANJAY HINDI LUNCH
2093	1060	1946	100.00	0.00	SANJAY HINDI LUNCH
2094	1061	2018	0.00	100.00	TEA EXPENSES
2095	1061	1947	100.00	0.00	TEA EXPENSES
2096	1062	2018	0.00	10000.00	GRINDING WHEEL 4NO'S
2097	1062	2228	10000.00	0.00	GRINDING WHEEL 4NO'S
2098	1063	2018	0.00	396.00	AUTO RENT FOR AC
2099	1063	1914	396.00	0.00	AUTO RENT FOR AC
2100	1064	2018	0.00	350.00	6NO'S  CRANE U CLAMP
2101	1064	2237	350.00	0.00	6NO'S  CRANE U CLAMP
2102	1065	2018	0.00	200.00	2NO'S OF LUNCH FOR CRANE LABOUR
2103	1065	1946	200.00	0.00	2NO'S OF LUNCH FOR CRANE LABOUR
2104	1066	2018	0.00	100.00	LUNCH EXPENSES
2105	1066	2218	100.00	0.00	LUNCH EXPENSES
2106	1067	2018	0.00	100.00	MARIMUTHU LUNCH
2107	1067	1946	100.00	0.00	MARIMUTHU LUNCH
2108	1068	2018	0.00	100.00	GOPI LUNCH
2109	1068	1946	100.00	0.00	GOPI LUNCH
2110	1069	2018	0.00	100.00	SANJAY HINDI BHAI LUNCH
2111	1069	1946	100.00	0.00	SANJAY HINDI BHAI LUNCH
2112	1070	2018	0.00	60.00	RAHUL
2113	1070	1946	60.00	0.00	RAHUL
2114	1071	2018	0.00	75.00	YELLOW PAINT
2115	1071	1967	75.00	0.00	YELLOW PAINT
2116	1072	2018	0.00	75.00	WHITE PAINT
2117	1072	1967	75.00	0.00	WHITE PAINT
2118	1073	2018	0.00	210.00	BOLT
2119	1073	1967	210.00	0.00	BOLT
2120	1074	2018	0.00	80.00	DRINKING WATER
2121	1074	2217	80.00	0.00	DRINKING WATER
2122	1075	2018	0.00	120.00	TEA
2123	1075	1947	120.00	0.00	TEA
2124	1076	2018	0.00	500.00	BEARING 4NO'S
2125	1076	1968	500.00	0.00	BEARING 4NO'S
2126	1077	2227	0.00	6123.00	
2127	1077	1954	6123.00	0.00	
2128	1078	2018	0.00	543.00	PURCHASE OF SPANNER
2129	1078	1967	543.00	0.00	PURCHASE OF SPANNER
2130	1079	2018	0.00	200.00	TEA
2131	1079	1947	200.00	0.00	TEA
2132	1080	2018	0.00	2500.00	AIRTEL MODEM
2133	1080	2292	2500.00	0.00	AIRTEL MODEM
2134	1099	2018	0.00	200.00	MESTHIRI WORKER 2 PERSON
2135	1099	1946	200.00	0.00	MESTHIRI WORKER 2 PERSON
2136	1100	2018	0.00	291.00	FOR PAINT
2137	1018	2217	50.00	0.00	Can Water
2138	1019	2018	0.00	1000.00	Ravi Labour
2139	1019	1933	1000.00	0.00	Ravi Labour
2140	1020	2018	0.00	1000.00	Panel Eletrician Labour
2141	1020	1966	1000.00	0.00	Panel Eletrician Labour
2142	1021	2018	0.00	1000.00	Crane Erection Labour
2143	1021	1966	1000.00	0.00	Crane Erection Labour
2144	1022	2018	0.00	1700.00	Selvam Auto Rent Shots
2145	1022	1914	1700.00	0.00	Selvam Auto Rent Shots
2146	1023	2018	0.00	1000.00	Table Glass Advance
2147	1023	1967	1000.00	0.00	Table Glass Advance
2148	1024	2018	0.00	500.00	Welding Rod Cutting Wheel
2149	1024	1967	500.00	0.00	Welding Rod Cutting Wheel
2150	1025	2018	0.00	1250.00	Angle 2 Auto Rent
2151	1025	1914	1250.00	0.00	Angle 2 Auto Rent
2152	1026	2018	0.00	400.00	Lunch Ravi Welding Crane Driver
2153	1026	1946	400.00	0.00	Lunch Ravi Welding Crane Driver
2154	1027	2018	0.00	650.00	Lorry Lock
2155	1027	1967	650.00	0.00	Lorry Lock
2156	1028	2018	0.00	600.00	Paint
2157	1028	1967	600.00	0.00	Paint
2158	1029	2018	0.00	700.00	Wheel
2159	1029	1967	700.00	0.00	Wheel
2160	1030	2018	0.00	70.00	Ag 4 Wheel
2161	1030	1967	70.00	0.00	Ag 4 Wheel
2162	1031	2018	0.00	100.00	Tea
2163	1031	1947	100.00	0.00	Tea
2164	1032	2018	0.00	100.00	Petrol
2165	1032	1981	100.00	0.00	Petrol
2166	1033	2018	0.00	50.00	Auto Extra
2167	1033	1914	50.00	0.00	Auto Extra
2168	1034	2018	0.00	2000.00	Crane Service Labour
2169	1034	1966	2000.00	0.00	Crane Service Labour
2170	1035	2018	0.00	6500.00	Crane Service Labour
2171	1035	1966	6500.00	0.00	Crane Service Labour
2172	1036	2018	0.00	2000.00	Labour
2173	1036	1933	2000.00	0.00	Labour
2174	1037	2018	0.00	500.00	Petrol
2175	1037	1981	500.00	0.00	Petrol
2176	1038	2018	0.00	2000.00	Petrol
2177	1038	1981	2000.00	0.00	Petrol
2178	1039	2018	0.00	1500.00	Vechile Water Wash
2179	1039	2123	1500.00	0.00	Vechile Water Wash
2180	1040	2018	0.00	100.00	Tea
2181	1040	1947	100.00	0.00	Tea
2182	1041	2018	0.00	10000.00	Panel Board Service
2183	1041	1967	10000.00	0.00	Panel Board Service
2184	1100	1914	291.00	0.00	FOR PAINT
2185	1101	2018	0.00	205.00	BOROSIL CHIMNEY 350 CP
2186	1101	1932	205.00	0.00	BOROSIL CHIMNEY 350 CP
2187	1102	2018	0.00	871.00	GROCERY
2188	1102	1966	871.00	0.00	GROCERY
2189	1103	2018	0.00	4600.00	FOR MACHINERY (ROPE GRINDING)
2190	1103	1932	4600.00	0.00	FOR MACHINERY (ROPE GRINDING)
2191	1104	2018	0.00	1860.00	CHISEL CUTTER AG4 WHEEL
2192	1104	1932	1860.00	0.00	CHISEL CUTTER AG4 WHEEL
2193	1105	2018	0.00	285.00	TEA WATER CAN
2194	1105	1966	285.00	0.00	TEA WATER CAN
2195	1106	2018	0.00	2000.00	CHISEL HAMMER CHATTI
2196	1106	1932	2000.00	0.00	CHISEL HAMMER CHATTI
2197	1107	2018	0.00	900.00	CHISEL PURCHASED (CHANDRU)
2198	1107	1932	900.00	0.00	CHISEL PURCHASED (CHANDRU)
2199	1108	2018	0.00	390.00	TEA NIGHT TIFFEN
2200	1108	1966	390.00	0.00	TEA NIGHT TIFFEN
2201	1109	2018	0.00	1500.00	MAGNET PURCHASED BY GPAY
2202	1109	1932	1500.00	0.00	MAGNET PURCHASED BY GPAY
2203	1110	2018	0.00	1400.00	CYLINDER PURCHASED
2204	1110	1966	1400.00	0.00	CYLINDER PURCHASED
2205	1111	2018	0.00	800.00	COMPANY WEEKLY WAGES
2206	1111	2293	800.00	0.00	COMPANY WEEKLY WAGES
2207	1112	2018	0.00	2400.00	COMPANY WEEKLY WAGES
2208	1112	2294	2400.00	0.00	COMPANY WEEKLY WAGES
2209	1113	2018	0.00	5850.00	COMPANY WEEKLY WAGES
2210	1113	2295	5850.00	0.00	COMPANY WEEKLY WAGES
2211	1114	2018	0.00	200.00	TEA CAN WATER PETROL
2212	1114	1966	200.00	0.00	TEA CAN WATER PETROL
2213	1115	2018	0.00	300.00	BURNER
2214	1115	2220	300.00	0.00	BURNER
2215	1116	2018	0.00	100.00	TEA ,CAN WATER
2216	1116	1966	100.00	0.00	TEA ,CAN WATER
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
838	PUR_1_1	Purchase	2024-06-21	1989	16992.00	GPAY REF NO 417461101252		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
839	PUR_2_2	Purchase	2024-06-21	1913	23010.00	CASH PAID RS 11500 BALANCE HAVE T0 PAY RS.11500		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
840	PUR_3_3	Purchase	2024-06-21	1980	1800.00	GPAY		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
841	PAY_1_4	Payment	2024-06-21	2018	16992.00	GPAY		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
842	PAY_2_5	Payment	2024-06-21	2018	11500.00	BALANCE AMOUNT 11500		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
843	PAY_3_6	Payment	2024-06-21	2018	1800.00	GPAY		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
844	PAY_4_7	Payment	2024-06-25	2018	6000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
845	PAY_5_8	Payment	2024-06-21	2018	1500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
846	PAY_6_9	Payment	2024-06-21	2018	3200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
847	PAY_7_10	Payment	2024-06-25	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
848	PAY_8_11	Payment	2024-06-25	2018	3000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
849	PAY_9_12	Payment	2024-06-21	2018	3200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
850	PAY_10_15	Payment	2024-06-22	2056	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
851	PAY_11_16	Payment	2024-06-23	2018	3000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
852	PAY_12_17	Payment	2024-06-23	2056	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
853	PAY_13_18	Payment	2024-06-23	2018	505.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
854	PAY_14_19	Payment	2024-06-24	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
855	PAY_15_20	Payment	2024-06-24	2018	130.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
856	PAY_16_21	Payment	2024-06-24	2018	450.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
857	PAY_17_22	Payment	2024-06-24	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
858	PAY_18_23	Payment	2024-06-24	2018	1530.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
890	PAY_34_49	Payment	2024-06-25	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
891	PAY_35_50	Payment	2024-06-26	2018	1180.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
892	PAY_36_51	Payment	2024-06-26	2018	250.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
893	PAY_37_52	Payment	2024-06-26	2018	250.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
894	PAY_38_53	Payment	2024-06-26	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
895	PAY_39_56	Payment	2024-06-26	2018	140.00	4 CAN		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
896	PAY_40_57	Payment	2024-06-26	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
897	PAY_41_58	Payment	2024-06-26	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
898	PAY_42_59	Payment	2024-06-26	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
899	PAY_43_61	Payment	2024-06-26	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
900	PAY_44_65	Payment	2024-06-27	2018	2500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
901	PAY_45_66	Payment	2024-06-27	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
902	PAY_46_71	Payment	2024-06-28	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
859	PAY_19_24	Payment	2024-06-24	2018	800.00	2 Nos For Grinding Bed		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
860	PAY_20_25	Payment	2024-06-24	2018	770.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
861	PAY_21_26	Payment	2024-06-24	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
862	PAY_22_27	Payment	2024-06-24	2018	40.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
863	PAY_23_28	Payment	2024-06-24	2018	600.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
864	PAY_24_32	Payment	2024-06-25	2018	5500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
865	PAY_25_33	Payment	2024-06-25	2018	5000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
867	PAY_26_35	Payment	2024-06-24	2018	10384.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
866	PUR_4_34	Purchase	2024-06-25	1930	10384.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
868	PUR_5_36	Purchase	2024-06-25	1930	2242.00	9 INCH WHEEL		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
869	PAY_27_37	Payment	2024-06-25	2018	2242.00	9 INCH WHEEL		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
870	PAY_28_38	Payment	2024-06-25	2018	500.00	MS BUSH FOR GRINDING BED		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
885	PAY_29_39	Payment	2024-06-25	2018	500.00	FOR SARVAN		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
886	PAY_30_44	Payment	2024-06-25	2018	3500.00	BALANCE 500		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
887	PAY_31_45	Payment	2024-06-25	2018	210.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
888	PAY_32_46	Payment	2024-06-25	2018	750.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
889	PAY_33_48	Payment	2024-06-25	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
905	PAY_63_104	Payment	2024-07-08	2018	1300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
906	PAY_64_105	Payment	2024-07-08	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
907	PAY_65_106	Payment	2024-07-08	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
908	PAY_66_107	Payment	2024-07-08	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
909	PAY_67_109	Payment	2024-07-08	2018	753.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
910	PUR_6_110	Purchase	2024-07-08	1930	380.00	GPAY TO NAGARAJ UPI-419006399785		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
911	PAY_68_111	Payment	2024-07-08	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
912	PAY_69_112	Payment	2024-07-08	2018	380.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
913	PAY_70_114	Payment	2024-07-10	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
914	PAY_71_115	Payment	2024-07-10	2018	120.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
915	PAY_72_116	Payment	2024-07-10	2018	800.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
916	PAY_73_117	Payment	2024-07-10	2018	30.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
917	PAY_74_118	Payment	2024-07-10	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
918	PAY_75_119	Payment	2024-07-11	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
919	PAY_76_120	Payment	2024-07-11	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
920	PAY_77_121	Payment	2024-07-11	2018	1100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
921	PAY_78_122	Payment	2024-07-11	2018	10000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
922	PAY_79_125	Payment	2024-07-12	2018	650.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
923	PAY_80_126	Payment	2024-07-12	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
924	PAY_81_127	Payment	2024-07-12	2018	7434.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
925	PAY_82_129	Payment	2024-07-12	2018	5001.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
926	PAY_83_130	Payment	2024-07-12	2018	5000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
927	PAY_84_131	Payment	2024-07-12	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
928	PUR_7_133	Purchase	2024-07-12	1930	7434.00	BILL NO 160		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
929	REC_1_139	Receipt	2024-07-20	2018	28594.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
930	REC_2_140	Receipt	2024-07-20	2018	32926.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
903	PAY_47_72	Payment	2024-06-28	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
904	PAY_48_73	Payment	2024-06-29	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
871	PAY_49_74	Payment	2024-06-29	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
872	PAY_50_81	Payment	2024-07-02	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
873	PAY_51_82	Payment	2024-07-02	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
874	PAY_52_85	Payment	2024-07-04	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
875	PAY_53_86	Payment	2024-07-04	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
876	PAY_54_87	Payment	2024-07-04	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
877	PAY_55_88	Payment	2024-07-04	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
878	PAY_56_89	Payment	2024-07-04	2018	3750.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
879	PAY_57_90	Payment	2024-07-04	2056	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
880	PAY_58_97	Payment	2024-07-06	2056	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
881	PAY_59_98	Payment	2024-07-06	2056	280.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
882	PAY_60_101	Payment	2024-07-08	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
883	PAY_61_102	Payment	2024-07-08	2018	800.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
884	PAY_62_103	Payment	2024-07-08	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1081	PAY_220_379	Payment	2025-03-26	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1082	PAY_221_380	Payment	2025-03-26	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1083	PAY_222_381	Payment	2025-03-26	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1084	PAY_223_382	Payment	2025-03-26	2018	5000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1085	PAY_224_385	Payment	2025-03-26	2018	510.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1086	PAY_225_386	Payment	2025-03-27	2018	650.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1087	PAY_226_387	Payment	2025-03-27	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1088	PAY_227_388	Payment	2025-03-27	2018	90.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1089	PAY_228_389	Payment	2025-03-27	2018	90.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1090	PAY_229_390	Payment	2025-03-27	2018	60.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1091	PAY_230_391	Payment	2025-03-27	2018	20.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1092	PAY_231_392	Payment	2025-03-27	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1093	PUR_15_393	Purchase	2025-03-28	2010	24898.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1094	PAY_232_398	Payment	2025-03-28	2018	115.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1095	PAY_233_399	Payment	2025-03-28	2018	60.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1096	PAY_234_400	Payment	2025-03-28	2018	90.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1097	PAY_235_401	Payment	2025-03-28	2018	90.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1098	PAY_236_402	Payment	2025-03-28	2018	90.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
932	PAY_86_148	Payment	2024-07-25	2018	1500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
931	PAY_85_147	Payment	2024-07-18	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
933	PAY_87_149	Payment	2024-07-18	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
934	PAY_88_150	Payment	2024-07-18	2018	275.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
935	PAY_89_151	Payment	2024-07-18	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
936	PAY_90_152	Payment	2024-07-18	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
937	PAY_91_153	Payment	2024-07-18	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
938	PAY_92_154	Payment	2024-07-19	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
939	PAY_93_155	Payment	2024-07-25	2018	1908.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
940	REC_3_165	Receipt	2024-08-19	2018	30560.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
941	REC_4_187	Receipt	2024-09-14	2018	30000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
942	REC_5_188	Receipt	2024-09-18	2018	35000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
943	REC_6_193	Receipt	2024-10-01	2018	17151.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
944	REC_7_200	Receipt	2024-09-26	2018	40000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
945	PAY_94_210	Payment	2024-11-05	2018	1250.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
946	PAY_95_211	Payment	2024-11-05	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
947	REC_8_220	Receipt	2024-11-19	2018	42847.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
948	REC_9_230	Receipt	2024-12-21	2018	75000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
949	PUR_8_232	Purchase	2025-03-13	2010	24898.00	PURCHASE OF 200 LITRES OF GP PAINT		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
950	PUR_9_233	Purchase	2025-03-18	1952	20296.00	PURCHASE OF TURBON OIL 200 LITERS		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
951	PUR_10_234	Purchase	2025-03-10	2117	12730.00	PURCHASED MS ANGLE FOR CRANE BEAM		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
952	PUR_11_235	Purchase	2025-03-19	2117	23300.00	PURCHASE OF SHEET FOR EICHER (5 SHEETS)		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
953	PUR_12_236	Purchase	2025-03-11	1913	32500.00	PURCHASE OF SHOTS 500 KGS		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
954	PAY_96_237	Payment	2025-03-06	2018	2400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
955	PAY_97_238	Payment	2025-03-06	2018	2200.00	PURCHASE OF HAMMER		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
956	PAY_98_239	Payment	2025-03-06	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
957	PAY_99_240	Payment	2025-03-07	2018	100000.00	ADVANCE PATYMENT FOR CRANE		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
958	PAY_100_242	Payment	2025-03-08	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
959	PAY_101_243	Payment	2025-03-08	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
960	PAY_102_244	Payment	2025-03-08	2018	225.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
961	PAY_103_245	Payment	2025-03-08	2018	3500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
962	PAY_104_246	Payment	2025-03-08	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
963	PAY_105_247	Payment	2025-03-08	2018	5500.00	LABOUR 4000, BHAI 1500		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
964	PAY_106_248	Payment	2025-03-08	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
965	PAY_107_249	Payment	2025-03-08	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
966	PAY_108_250	Payment	2025-03-08	2018	1500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
967	PAY_109_253	Payment	2025-03-08	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
968	PAY_110_254	Payment	2025-03-08	2018	24898.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
969	PAY_111_255	Payment	2025-03-10	2018	12730.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
970	PAY_112_256	Payment	2025-03-10	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
971	PAY_113_257	Payment	2025-03-10	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
972	PAY_114_258	Payment	2025-03-10	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
973	PAY_115_259	Payment	2025-03-10	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
974	PAY_116_260	Payment	2025-03-10	2018	60000.00	RENT PAID		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
975	PAY_117_261	Payment	2025-03-10	2018	4000.00	EB FEB 2025		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
976	PAY_118_262	Payment	2025-03-11	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
977	PAY_119_263	Payment	2025-03-11	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
978	PAY_120_264	Payment	2025-03-11	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
979	PAY_121_265	Payment	2025-03-11	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
980	PAY_122_266	Payment	2025-03-11	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
981	PAY_123_267	Payment	2025-03-11	2018	800.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
982	PAY_124_268	Payment	2025-03-11	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
983	PAY_125_269	Payment	2025-03-11	2018	750.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
984	PAY_126_270	Payment	2025-03-11	2018	3000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
985	PAY_127_271	Payment	2025-03-11	2018	150.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
986	PAY_128_272	Payment	2025-03-12	2018	10000.00	OFFICE FALSEING G PAY		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
987	PAY_129_273	Payment	2025-03-12	2018	4000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
988	PAY_130_274	Payment	2025-03-12	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
989	PAY_131_275	Payment	2025-03-12	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
990	PAY_132_276	Payment	2025-03-12	2018	250.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
991	PAY_133_277	Payment	2025-03-12	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
992	PAY_134_278	Payment	2025-03-12	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
993	PAY_135_280	Payment	2025-03-12	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
994	PAY_136_281	Payment	2025-03-13	2018	100.00	.		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
995	PAY_137_282	Payment	2025-03-13	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
996	PAY_138_285	Payment	2025-03-17	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
997	PAY_139_286	Payment	2025-03-17	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
998	PAY_140_287	Payment	2025-03-17	2018	2100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
999	PAY_141_288	Payment	2025-03-17	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1000	PAY_142_289	Payment	2025-03-18	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1001	PAY_143_290	Payment	2025-03-18	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1002	PAY_144_291	Payment	2025-03-18	2018	20300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1003	PAY_145_292	Payment	2025-03-18	2018	350.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1004	PAY_146_293	Payment	2025-03-18	2018	280.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1005	PAY_147_294	Payment	2025-03-18	2018	1200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1006	PAY_148_295	Payment	2025-03-18	2018	3200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1007	PAY_149_296	Payment	2025-03-18	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1008	PAY_150_297	Payment	2025-03-18	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1009	PAY_151_298	Payment	2025-03-18	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1010	PAY_152_299	Payment	2025-03-19	2018	23300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1011	PAY_153_300	Payment	2025-03-19	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1012	PAY_154_301	Payment	2025-03-19	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1013	PAY_155_302	Payment	2025-03-19	2018	10000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1014	PAY_156_303	Payment	2025-03-19	2018	650.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1015	PAY_157_304	Payment	2025-03-19	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1016	PAY_158_305	Payment	2025-03-19	2018	230.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1017	PAY_159_306	Payment	2025-03-19	2018	120.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1042	PAY_184_332	Payment	2025-03-22	2018	9600.00	Paid To Vardharaj		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1043	PAY_185_333	Payment	2025-03-22	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1044	PAY_186_334	Payment	2025-03-22	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1045	PAY_187_335	Payment	2025-03-22	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1046	PAY_188_337	Payment	2025-03-22	2018	11000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1047	PAY_189_338	Payment	2025-03-22	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1048	PUR_13_342	Purchase	2025-03-24	2226	7316.00	GST AMOUNT 1116		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1049	PUR_14_343	Purchase	2025-03-24	1952	20296.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1050	PAY_190_344	Payment	2025-03-24	2018	2263.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1051	PAY_191_345	Payment	2025-03-24	2018	250.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1052	PAY_192_346	Payment	2025-03-24	2018	30.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1053	PAY_193_347	Payment	2025-03-24	2018	1100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1054	PAY_194_348	Payment	2025-03-24	2018	3000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1055	PAY_195_349	Payment	2025-03-24	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1056	PAY_196_350	Payment	2025-03-24	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1057	PAY_197_351	Payment	2025-03-24	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1058	PAY_198_352	Payment	2025-03-24	2018	80.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1059	PAY_199_353	Payment	2025-03-24	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1060	PAY_200_354	Payment	2025-03-24	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1061	PAY_201_355	Payment	2025-03-25	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1062	PAY_202_356	Payment	2025-03-25	2018	10000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1063	PAY_203_357	Payment	2025-03-25	2018	396.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1064	PAY_204_358	Payment	2025-03-25	2018	350.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1065	PAY_205_359	Payment	2025-03-25	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1066	PAY_206_360	Payment	2025-03-25	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1067	PAY_207_361	Payment	2025-03-25	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1068	PAY_208_362	Payment	2025-03-25	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1069	PAY_209_363	Payment	2025-03-25	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1070	PAY_210_364	Payment	2025-03-25	2018	60.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1071	PAY_211_365	Payment	2025-03-25	2018	75.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1072	PAY_212_366	Payment	2025-03-25	2018	75.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1073	PAY_213_367	Payment	2025-03-25	2018	210.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1074	PAY_214_368	Payment	2025-03-25	2018	80.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1075	PAY_215_369	Payment	2025-03-25	2018	120.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1076	PAY_216_370	Payment	2025-03-25	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1077	PUR_14_372	Purchase	2025-03-24	2227	6123.00	PURCHASE OF ALLEN KEY,SPANNER,SOCKET		\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1078	PAY_217_375	Payment	2025-03-24	2018	543.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1079	PAY_218_377	Payment	2025-03-26	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1080	PAY_219_378	Payment	2025-03-26	2018	2500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1099	PAY_237_403	Payment	2025-03-28	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1018	PAY_160_307	Payment	2025-03-19	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1019	PAY_161_308	Payment	2025-03-19	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1020	PAY_162_309	Payment	2025-03-19	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1021	PAY_163_310	Payment	2025-03-19	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1022	PAY_164_311	Payment	2025-03-20	2018	1700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1023	PAY_165_312	Payment	2025-03-20	2018	1000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1024	PAY_166_313	Payment	2025-03-20	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1025	PAY_167_314	Payment	2025-03-20	2018	1250.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1026	PAY_168_315	Payment	2025-03-20	2018	400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1027	PAY_169_316	Payment	2025-03-20	2018	650.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1028	PAY_170_317	Payment	2025-03-20	2018	600.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1029	PAY_171_318	Payment	2025-03-20	2018	700.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1030	PAY_172_319	Payment	2025-03-20	2018	70.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1031	PAY_173_320	Payment	2025-03-20	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1032	PAY_174_321	Payment	2025-03-20	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1033	PAY_175_322	Payment	2025-03-20	2018	50.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1034	PAY_176_323	Payment	2025-03-20	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1035	PAY_177_324	Payment	2025-03-21	2018	6500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1036	PAY_178_325	Payment	2025-03-21	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1037	PAY_179_326	Payment	2025-03-21	2018	500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1038	PAY_180_327	Payment	2025-03-21	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1039	PAY_181_328	Payment	2025-03-21	2018	1500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1040	PAY_182_329	Payment	2025-03-21	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1041	PAY_183_330	Payment	2025-03-21	2018	10000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1100	PAY_238_404	Payment	2025-03-28	2018	291.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1101	PAY_239_405	Payment	2025-03-28	2018	205.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1102	PAY_240_406	Payment	2025-03-28	2018	871.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1103	PAY_241_407	Payment	2025-03-28	2018	4600.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1104	PAY_242_408	Payment	2025-03-28	2018	1860.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1105	PAY_243_409	Payment	2025-03-28	2018	285.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1106	PAY_244_410	Payment	2025-03-28	2018	2000.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1107	PAY_245_411	Payment	2025-03-28	2018	900.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1108	PAY_246_413	Payment	2025-03-28	2018	390.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1109	PAY_247_414	Payment	2025-03-28	2018	1500.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1110	PAY_248_415	Payment	2025-03-28	2018	1400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1111	PAY_249_425	Payment	2025-03-29	2018	800.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1112	PAY_250_426	Payment	2025-03-29	2018	2400.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1113	PAY_251_428	Payment	2025-03-29	2018	5850.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1114	PAY_252_436	Payment	2025-03-29	2018	200.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1115	PAY_253_437	Payment	2025-03-29	2018	300.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
1116	PAY_254_440	Payment	2025-03-29	2018	100.00			\N	2026-08-03 15:19:01.165727	2026-08-03 15:19:01.165727
\.


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
1489	ADV_7_36	2025-04-05	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1490	ADV_18_57	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1491	ADV_22_62	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1492	ADV_23_64	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1493	ADV_28_70	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1494	ADV_29_71	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1495	ADV_30_72	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1496	ADV_31_73	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1497	ADV_104_358	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1498	ADV_1_359	2025-04-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1499	ADV_2_360	2025-05-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1500	ADV_3_361	2025-04-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1501	ADV_4_362	2025-04-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1502	ADV_5_363	2025-04-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1503	ADV_6_364	2025-04-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1504	ADV_7_384	2025-04-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1505	ADV_21_385	2025-04-05	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1506	ADV_8_386	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1507	ADV_9_387	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1508	ADV_22_388	2025-04-07	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1509	ADV_10_389	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1510	ADV_11_390	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1511	ADV_12_391	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1512	ADV_13_392	2025-04-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1513	ADV_14_393	2025-04-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1514	ADV_36_107	2025-04-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1515	ADV_37_109	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1516	ADV_38_110	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1517	ADV_39_111	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1518	ADV_40_113	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1519	ADV_41_114	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1520	ADV_42_125	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1521	ADV_43_126	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1522	ADV_44_127	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1523	ADV_45_128	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1524	ADV_46_131	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1525	ADV_47_137	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1526	ADV_48_138	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1527	ADV_49_139	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1528	ADV_50_140	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1529	ADV_51_144	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1530	ADV_12_151	2025-04-15	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1531	ADV_13_152	2025-04-15	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1532	ADV_14_153	2025-04-15	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1533	ADV_52_154	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1534	ADV_53_155	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1535	ADV_54_156	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1536	ADV_55_157	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1537	ADV_56_158	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1538	ADV_57_159	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1539	ADV_58_160	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1540	ADV_59_161	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1541	ADV_60_162	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1542	ADV_15_171	2025-04-14	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1543	ADV_61_172	2025-04-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1544	ADV_62_173	2025-04-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1545	ADV_63_174	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1546	ADV_64_175	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1547	ADV_65_176	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1548	ADV_66_177	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1549	ADV_67_178	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1550	ADV_16_179	2025-04-15	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1551	ADV_68_180	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1552	ADV_69_185	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1553	ADV_70_186	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1554	ADV_71_187	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1555	ADV_72_188	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1556	ADV_73_196	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1557	ADV_74_197	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1558	ADV_75_198	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1559	ADV_76_199	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1560	ADV_77_200	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1561	ADV_78_201	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1562	ADV_79_202	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1563	ADV_80_203	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1564	ADV_81_204	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1565	ADV_82_205	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1566	ADV_83_206	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1567	ADV_84_208	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1568	ADV_85_209	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1569	ADV_86_210	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1570	ADV_87_211	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1571	ADV_88_212	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1572	ADV_89_213	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1573	ADV_90_214	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1574	ADV_91_215	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1575	ADV_92_216	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1576	ADV_17_217	2025-04-18	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1577	ADV_18_218	2025-04-18	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1578	ADV_93_232	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1579	ADV_19_235	2025-04-18	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1580	ADV_20_236	2025-04-18	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1581	ADV_94_237	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1582	ADV_95_239	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1583	ADV_96_240	2025-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1584	ADV_97_268	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1585	ADV_98_269	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1586	ADV_99_272	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1587	ADV_100_273	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1588	ADV_101_274	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1589	ADV_102_275	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1590	ADV_103_276	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1591	ADV_15_394	2025-04-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1592	ADV_16_395	2025-04-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1593	ADV_17_396	2025-04-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1594	ADV_23_397	2025-04-08	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1595	ADV_18_398	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1596	ADV_19_399	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1597	ADV_20_400	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1598	ADV_21_401	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1599	ADV_22_402	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1600	ADV_23_403	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1601	ADV_24_404	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1602	ADV_25_405	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1603	ADV_26_406	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1604	ADV_27_407	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1605	ADV_24_408	2025-04-10	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1606	ADV_28_409	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1607	ADV_29_410	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1608	ADV_30_411	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1609	ADV_31_412	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1610	ADV_32_413	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1611	ADV_33_414	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1612	ADV_34_415	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1613	ADV_35_416	2025-04-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1614	ADV_36_417	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1615	ADV_37_418	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1616	ADV_38_419	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1617	ADV_39_420	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1618	ADV_40_421	2025-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1619	ADV_25_422	2025-04-11	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1620	ADV_41_423	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1621	ADV_42_424	2025-04-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1622	ADV_43_439	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1623	ADV_26_440	2025-04-12	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1624	ADV_44_441	2025-04-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1625	ADV_45_442	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1626	ADV_46_443	2025-04-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1627	ADV_47_444	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1628	ADV_48_445	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1629	ADV_49_446	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1630	ADV_50_447	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1631	ADV_51_448	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1632	ADV_52_449	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1633	ADV_53_450	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1634	ADV_27_451	2025-04-15	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1635	ADV_54_452	2025-04-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1636	ADV_55_453	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1637	ADV_56_454	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1638	ADV_57_455	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1639	ADV_58_456	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1640	ADV_59_457	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1641	ADV_60_458	2025-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1642	ADV_61_459	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1643	ADV_62_460	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1644	ADV_63_461	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1645	ADV_64_462	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1646	ADV_65_463	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1647	ADV_66_466	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1648	ADV_67_467	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1649	ADV_68_468	2025-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1650	ADV_69_469	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1651	ADV_70_470	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1652	ADV_71_471	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1653	ADV_72_472	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1654	ADV_73_473	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1655	ADV_74_474	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1656	ADV_75_475	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1657	ADV_76_476	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1658	ADV_77_477	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1659	ADV_78_478	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1660	ADV_79_479	2025-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1661	ADV_80_480	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1662	ADV_81_481	2025-04-18	2373	Payment	Contractor	0.80		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1663	ADV_82_482	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1664	ADV_83_483	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1665	ADV_28_484	2025-04-18	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1666	ADV_84_486	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1667	ADV_85_487	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1668	ADV_86_488	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1669	ADV_87_489	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1670	ADV_88_490	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1671	ADV_89_491	2025-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1672	ADV_90_492	2025-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1673	ADV_91_498	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1674	ADV_92_501	2025-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1675	ADV_29_503	2025-04-19	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1676	ADV_93_506	2025-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1677	ADV_94_513	2025-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1678	ADV_30_514	2025-04-21	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1679	ADV_95_515	2025-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1680	ADV_96_516	2025-04-21	2373	Payment	Contractor	0.00	PIUIUYYT	\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1681	ADV_97_517	2025-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1682	ADV_98_518	2025-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1683	ADV_99_519	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1684	ADV_100_520	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1685	ADV_101_521	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1686	ADV_102_522	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1687	ADV_103_523	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1688	ADV_104_524	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1689	ADV_105_525	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1690	ADV_106_526	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1691	ADV_107_527	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1692	ADV_108_528	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1693	ADV_109_529	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1694	ADV_110_530	2025-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1695	ADV_111_531	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1696	ADV_112_532	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1697	ADV_113_533	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1698	ADV_114_534	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1699	ADV_115_535	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1700	ADV_117_537	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1701	ADV_118_538	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1702	ADV_119_539	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1703	ADV_120_540	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1704	ADV_121_541	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1705	ADV_122_542	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1706	ADV_123_543	2025-04-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1707	ADV_124_544	2025-04-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1708	ADV_125_545	2025-04-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1709	ADV_126_546	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1710	ADV_127_547	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1711	ADV_128_548	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1712	ADV_129_549	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1713	ADV_31_550	2025-04-25	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1714	ADV_130_551	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1715	ADV_131_552	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1716	ADV_132_553	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1717	ADV_133_554	2025-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1718	ADV_134_555	2025-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1719	ADV_135_559	2025-04-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1720	ADV_136_560	2025-04-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1721	ADV_137_562	2025-04-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1722	ADV_32_575	2025-04-26	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1723	ADV_138_576	2025-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1724	ADV_138_583	2025-04-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1725	ADV_139_584	2025-04-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1726	ADV_140_585	2025-04-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1727	ADV_141_586	2025-04-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1728	ADV_142_587	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1729	ADV_143_588	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1730	ADV_144_590	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1731	ADV_145_591	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1732	ADV_146_592	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1733	ADV_147_593	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1734	ADV_148_594	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1735	ADV_149_595	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1736	ADV_33_596	2025-04-28	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1737	ADV_150_604	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1738	ADV_34_605	2025-04-28	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1739	ADV_151_606	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1740	ADV_152_607	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1741	ADV_153_608	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1742	ADV_154_609	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1743	ADV_155_610	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1744	ADV_156_611	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1745	ADV_157_612	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1746	ADV_158_613	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1747	ADV_159_614	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1748	ADV_35_615	2025-04-29	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1749	ADV_160_616	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1750	ADV_161_617	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1751	ADV_162_618	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1752	ADV_163_619	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1753	ADV_164_620	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1754	ADV_165_621	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1755	ADV_166_622	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1756	ADV_167_623	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1757	ADV_168_624	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1758	ADV_169_625	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1759	ADV_170_626	2025-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1760	ADV_171_627	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1761	ADV_172_628	2025-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1762	ADV_36_629	2025-04-29	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1763	ADV_173_630	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1764	ADV_37_631	2025-04-30	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1765	ADV_174_632	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1766	ADV_175_633	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1767	ADV_176_634	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1768	ADV_177_635	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1769	ADV_178_636	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1770	ADV_179_637	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1771	ADV_180_638	2025-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1772	ADV_181_639	2025-05-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1773	ADV_182_640	2025-05-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1774	ADV_183_641	2025-05-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1775	ADV_184_642	2025-05-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1776	ADV_185_643	2025-05-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1777	ADV_186_644	2025-05-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1778	ADV_38_645	2025-05-01	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1779	ADV_187_646	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1780	ADV_188_647	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1781	ADV_189_648	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1782	ADV_190_649	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1783	ADV_191_650	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1784	ADV_192_651	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1785	ADV_193_652	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1786	ADV_194_653	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1787	ADV_195_654	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1788	ADV_196_655	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1789	ADV_197_656	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1790	ADV_39_657	2025-05-02	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1791	ADV_40_658	2025-05-02	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1792	ADV_41_659	2025-05-03	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1793	ADV_198_660	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1794	ADV_199_661	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1795	ADV_200_662	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1796	ADV_201_663	2025-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1797	ADV_202_665	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1798	ADV_203_666	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1799	ADV_204_667	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1800	ADV_205_668	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1801	ADV_206_669	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1802	ADV_207_670	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1803	ADV_208_671	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1804	ADV_209_672	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1805	ADV_210_673	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1806	ADV_42_674	2025-05-03	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1807	ADV_43_675	2025-05-03	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1808	ADV_211_676	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1809	ADV_212_677	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1810	ADV_213_678	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1811	ADV_44_692	2025-05-03	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1812	ADV_214_694	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1813	ADV_215_695	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1814	ADV_216_696	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1815	ADV_217_697	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1816	ADV_218_698	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1817	ADV_219_699	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1818	ADV_220_700	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1819	ADV_221_701	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1820	ADV_222_702	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1821	ADV_223_703	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1822	ADV_224_704	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1823	ADV_225_705	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1824	ADV_226_706	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1825	ADV_227_707	2025-05-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1826	ADV_228_708	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1827	ADV_45_709	2025-05-05	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1828	ADV_229_710	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1829	ADV_230_711	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1830	ADV_231_712	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1831	ADV_232_713	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1832	ADV_233_714	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1833	ADV_234_715	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1834	ADV_235_716	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1835	ADV_236_717	2025-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1836	ADV_237_718	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1837	ADV_238_719	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1838	ADV_239_720	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1839	ADV_240_721	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1840	ADV_241_722	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1841	ADV_242_723	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1842	ADV_243_724	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1843	ADV_244_725	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1844	ADV_245_726	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1845	ADV_246_727	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1846	ADV_247_728	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1847	ADV_248_729	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1848	ADV_249_730	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1849	ADV_250_731	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1850	ADV_251_732	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1851	ADV_252_733	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1852	ADV_253_734	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1853	ADV_254_735	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1854	ADV_255_736	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1855	ADV_256_737	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1856	ADV_257_738	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1857	ADV_258_739	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1858	ADV_259_740	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1859	ADV_260_741	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1860	ADV_261_742	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1861	ADV_262_743	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1862	ADV_263_744	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1863	ADV_264_745	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1864	ADV_265_746	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1865	ADV_266_747	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1866	ADV_267_772	2025-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1867	ADV_268_773	2025-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1868	ADV_269_780	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1869	ADV_270_781	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1870	ADV_271_782	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1871	ADV_272_783	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1872	ADV_273_784	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1873	ADV_274_785	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1874	ADV_275_786	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1875	ADV_276_787	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1876	ADV_277_788	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1877	ADV_278_789	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1878	ADV_279_790	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1879	ADV_280_791	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1880	ADV_281_792	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1881	ADV_282_793	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1882	ADV_283_794	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1883	ADV_284_795	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1884	ADV_285_796	2025-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1885	ADV_286_803	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1886	ADV_287_804	2025-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1887	ADV_288_805	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1888	ADV_289_806	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1889	ADV_290_807	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1890	ADV_46_808	2025-05-09	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1891	ADV_291_809	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1892	ADV_292_810	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1893	ADV_293_811	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1894	ADV_294_812	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1895	ADV_295_813	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1896	ADV_296_814	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1897	ADV_297_815	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1898	ADV_298_825	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1899	ADV_299_826	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1900	ADV_300_827	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1901	ADV_301_828	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1902	ADV_302_829	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1903	ADV_303_830	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1904	ADV_304_831	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1905	ADV_305_832	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1906	ADV_306_833	2025-05-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1907	ADV_1_843	2025-05-10	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1908	ADV_307_866	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1909	ADV_308_867	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1910	ADV_309_868	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1911	ADV_310_869	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1912	ADV_311_870	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1913	ADV_312_871	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1914	ADV_313_872	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1915	ADV_314_873	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1916	ADV_315_874	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1917	ADV_316_875	2025-05-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1918	ADV_47_876	2025-05-10	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1919	ADV_48_877	2025-05-10	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1920	ADV_49_878	2025-05-12	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1921	ADV_317_882	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1922	ADV_318_884	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1923	ADV_319_885	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1924	ADV_320_886	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1925	ADV_321_887	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1926	ADV_322_889	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1927	ADV_323_890	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1928	ADV_324_891	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1929	ADV_325_894	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1930	ADV_326_895	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1931	ADV_327_896	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1932	ADV_328_897	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1933	ADV_329_898	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1934	ADV_330_899	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1935	ADV_331_900	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1936	ADV_332_903	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1937	ADV_333_904	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1938	ADV_334_905	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1939	ADV_335_906	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1940	ADV_336_907	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1941	ADV_337_908	2025-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1942	ADV_338_912	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1943	ADV_339_913	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1944	ADV_340_914	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1945	ADV_341_915	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1946	ADV_342_916	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1947	ADV_343_917	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1948	ADV_344_918	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1949	ADV_345_919	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1950	ADV_346_920	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1951	ADV_347_921	2025-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1952	ADV_348_927	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1953	ADV_349_928	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1954	ADV_350_929	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1955	ADV_351_930	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1956	ADV_352_931	2025-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1957	ADV_50_937	2025-05-15	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1958	ADV_353_940	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1959	ADV_354_948	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1960	ADV_355_949	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1961	ADV_356_950	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1962	ADV_357_951	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1963	ADV_358_952	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1964	ADV_359_953	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1965	ADV_360_954	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1966	ADV_361_955	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1967	ADV_362_956	2025-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1968	ADV_363_960	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1969	ADV_364_961	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1970	ADV_365_963	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1971	ADV_366_964	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1972	ADV_367_965	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1973	ADV_368_966	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1974	ADV_369_967	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1975	ADV_370_968	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1976	ADV_51_969	2025-05-16	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1977	ADV_371_970	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1978	ADV_372_971	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1979	ADV_373_972	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1980	ADV_374_974	2025-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1981	ADV_2_976	2025-05-17	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1982	ADV_52_979	2025-05-17	2506	Payment	Staff	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1983	ADV_375_980	2025-05-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
1984	ADV_376_981	2025-05-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:08.96659	2026-08-03 15:19:08.96659
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.audit_logs (id, user_id, username, action, module, record_id, old_values, new_values, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: biometric_entries; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.biometric_entries (id, ledger_id, entry_date, punch_in, punch_out, hours_worked, status, device_log_id, created_at) FROM stdin;
\.


--
-- Data for Name: eb_readings; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.eb_readings (id, reading_date, meter_no, previous_reading, current_reading, units_consumed, rate_per_unit, amount, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: job_work_entries; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.job_work_entries (id, entry_no, entry_date, ledger_id, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: labour_bills; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.labour_bills (id, bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, is_paid, payment_date, created_by, created_at, updated_at, items, outward_ids, dispatch_through) FROM stdin;
2221	LB_1_863_41_0	2025-04-07	1894	\N	3964	18	4777.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2222	LB_3_115_247_0	2025-04-21	1986	\N	3216	18	212.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2223	LB_3_115_247_1	2025-04-21	1986	\N	3216	19	212.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2224	LB_3_115_247_2	2025-04-21	1986	\N	3216	20	212.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2225	LB_3_138_247_3	2025-04-21	1986	\N	3239	18	844.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2226	LB_3_138_247_4	2025-04-21	1986	\N	3239	19	844.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2227	LB_3_138_247_5	2025-04-21	1986	\N	3239	20	844.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2228	LB_3_307_247_6	2025-04-21	1986	\N	3408	18	651.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2229	LB_3_307_247_7	2025-04-21	1986	\N	3408	19	651.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2230	LB_3_307_247_8	2025-04-21	1986	\N	3408	20	651.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2231	LB_3_417_247_9	2025-04-21	1986	\N	3518	18	32.364	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2232	LB_3_417_247_10	2025-04-21	1986	\N	3518	19	32.364	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2233	LB_3_417_247_11	2025-04-21	1986	\N	3518	20	32.364	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2234	LB_3_583_247_12	2025-04-21	1986	\N	3749	18	502.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2235	LB_3_583_247_13	2025-04-21	1986	\N	3749	19	502.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2236	LB_3_583_247_14	2025-04-21	1986	\N	3749	20	502.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2237	LB_3_42_247_15	2025-04-21	1986	\N	3144	18	471.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2238	LB_3_42_247_16	2025-04-21	1986	\N	3144	19	471.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2239	LB_3_42_247_17	2025-04-21	1986	\N	3144	20	471.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2240	LB_3_164_247_18	2025-04-21	1986	\N	3265	18	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2241	LB_3_164_247_19	2025-04-21	1986	\N	3265	19	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2242	LB_3_164_247_20	2025-04-21	1986	\N	3265	20	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2243	LB_3_384_247_21	2025-04-21	1986	\N	3485	18	355.160	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2244	LB_3_384_247_22	2025-04-21	1986	\N	3485	19	355.160	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2245	LB_3_384_247_23	2025-04-21	1986	\N	3485	20	355.160	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2246	LB_3_143_247_24	2025-04-21	1986	\N	3244	18	257.982	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2247	LB_3_143_247_25	2025-04-21	1986	\N	3244	19	257.982	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2248	LB_3_143_247_26	2025-04-21	1986	\N	3244	20	257.982	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2249	LB_3_42_248_0	2025-04-21	1986	\N	3144	19	117.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2250	LB_3_42_248_1	2025-04-21	1986	\N	3144	20	117.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2251	LB_3_307_248_2	2025-04-21	1986	\N	3408	18	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2252	LB_3_307_248_3	2025-04-21	1986	\N	3408	19	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2253	LB_3_307_248_4	2025-04-21	1986	\N	3408	20	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2254	LB_3_42_248_5	2025-04-21	1986	\N	3144	18	117.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2255	LB_3_90_249_0	2025-04-21	1986	\N	3191	17	11.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2256	LB_4_138_259_0	2025-04-24	1894	\N	3239	18	91.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2257	LB_4_138_259_1	2025-04-24	1894	\N	3239	19	91.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2258	LB_4_138_259_2	2025-04-24	1894	\N	3239	20	91.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2259	LB_4_642_259_3	2025-04-24	1894	\N	3678	18	736.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2260	LB_4_642_259_4	2025-04-24	1894	\N	3678	19	736.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2261	LB_4_642_259_5	2025-04-24	1894	\N	3678	20	736.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2262	LB_4_868_259_6	2025-04-24	1894	\N	3969	18	277.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2263	LB_4_868_259_7	2025-04-24	1894	\N	3969	19	277.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2264	LB_4_868_259_8	2025-04-24	1894	\N	3969	20	277.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2265	LB_4_30_259_9	2025-04-24	1894	\N	3132	18	686.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2266	LB_4_30_259_10	2025-04-24	1894	\N	3132	19	686.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2267	LB_4_30_259_11	2025-04-24	1894	\N	3132	20	686.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2268	LB_4_42_259_12	2025-04-24	1894	\N	3144	18	6.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2269	LB_4_42_259_13	2025-04-24	1894	\N	3144	19	6.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2270	LB_4_42_259_14	2025-04-24	1894	\N	3144	20	6.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2271	LB_4_138_259_15	2025-04-24	1894	\N	3239	18	825.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2272	LB_4_138_259_16	2025-04-24	1894	\N	3239	19	825.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2273	LB_4_138_259_17	2025-04-24	1894	\N	3239	20	825.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2274	LB_4_138_259_18	2025-04-24	1894	\N	3239	18	17.190	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2275	LB_4_216_259_19	2025-04-24	1894	\N	3317	18	3.584	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2276	LB_4_409_259_20	2025-04-24	1894	\N	3510	18	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2277	LB_4_409_259_21	2025-04-24	1894	\N	3510	19	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2278	LB_4_409_259_22	2025-04-24	1894	\N	3510	20	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2279	LB_4_486_259_23	2025-04-24	1894	\N	3587	18	1466.265	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2280	LB_4_486_259_24	2025-04-24	1894	\N	3587	19	1466.265	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2281	LB_4_486_259_25	2025-04-24	1894	\N	3587	20	1466.265	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2282	LB_4_236_259_26	2025-04-24	1894	\N	3337	18	157.088	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2283	LB_4_236_259_27	2025-04-24	1894	\N	3337	19	157.088	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2284	LB_4_126_259_28	2025-04-24	1894	\N	3227	18	194.510	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2285	LB_4_126_259_29	2025-04-24	1894	\N	3227	19	194.510	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2286	LB_4_898_259_30	2025-04-24	1894	\N	3998	18	519.860	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2287	LB_4_898_259_31	2025-04-24	1894	\N	3998	19	519.860	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2288	LB_4_813_259_32	2025-04-24	1894	\N	3914	18	388.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2289	LB_4_813_259_33	2025-04-24	1894	\N	3914	19	388.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2290	LB_4_813_259_34	2025-04-24	1894	\N	3914	20	388.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2291	LB_4_897_259_35	2025-04-24	1894	\N	3997	18	369.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2292	LB_4_897_259_36	2025-04-24	1894	\N	3997	19	369.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2293	LB_4_897_259_37	2025-04-24	1894	\N	3997	20	369.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2294	LB_4_40_259_38	2025-04-24	1894	\N	3142	18	1128.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2295	LB_4_40_259_39	2025-04-24	1894	\N	3142	19	1128.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2296	LB_4_40_259_40	2025-04-24	1894	\N	3142	20	1128.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2297	LB_4_42_259_41	2025-04-24	1894	\N	3144	18	96.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2298	LB_4_42_259_42	2025-04-24	1894	\N	3144	19	96.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2299	LB_4_42_259_43	2025-04-24	1894	\N	3144	20	96.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2300	LB_4_164_259_44	2025-04-24	1894	\N	3265	18	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2301	LB_4_164_259_45	2025-04-24	1894	\N	3265	19	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2302	LB_4_164_259_46	2025-04-24	1894	\N	3265	20	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2303	LB_4_164_259_47	2025-04-24	1894	\N	3265	18	4.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2304	LB_4_409_259_48	2025-04-24	1894	\N	3510	18	234.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2305	LB_4_409_259_49	2025-04-24	1894	\N	3510	19	234.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2306	LB_4_409_259_50	2025-04-24	1894	\N	3510	20	234.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2307	LB_4_19_259_51	2025-04-24	1894	\N	3121	18	295.880	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2308	LB_4_19_259_52	2025-04-24	1894	\N	3121	19	295.880	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2309	LB_4_19_259_53	2025-04-24	1894	\N	3121	20	295.880	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2310	LB_4_307_260_0	2025-04-24	1894	\N	3408	18	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2311	LB_4_307_260_1	2025-04-24	1894	\N	3408	19	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2312	LB_4_307_260_2	2025-04-24	1894	\N	3408	20	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2313	LB_4_868_260_3	2025-04-24	1894	\N	3969	18	19.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2314	LB_4_868_260_4	2025-04-24	1894	\N	3969	19	19.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2315	LB_4_868_260_5	2025-04-24	1894	\N	3969	20	19.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2316	LB_4_42_260_6	2025-04-24	1894	\N	3144	18	39.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2317	LB_4_42_260_7	2025-04-24	1894	\N	3144	19	39.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2318	LB_4_42_260_8	2025-04-24	1894	\N	3144	20	39.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2319	LB_4_164_260_9	2025-04-24	1894	\N	3265	18	14.880	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2320	LB_4_164_260_10	2025-04-24	1894	\N	3265	19	14.880	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2321	LB_4_164_260_11	2025-04-24	1894	\N	3265	20	14.880	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2322	LB_4_486_260_12	2025-04-24	1894	\N	3587	18	6.135	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2323	LB_4_486_260_13	2025-04-24	1894	\N	3587	19	6.135	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2324	LB_4_486_260_14	2025-04-24	1894	\N	3587	20	6.135	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2325	LB_4_216_260_15	2025-04-24	1894	\N	3317	18	19.712	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2326	LB_4_216_260_16	2025-04-24	1894	\N	3317	19	19.712	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2327	LB_4_216_260_17	2025-04-24	1894	\N	3317	20	19.712	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2328	LB_4_138_260_18	2025-04-24	1894	\N	3239	18	55.390	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2329	LB_4_138_260_19	2025-04-24	1894	\N	3239	19	55.390	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2330	LB_4_138_260_20	2025-04-24	1894	\N	3239	20	55.390	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2331	LB_4_32_261_0	2025-04-24	1894	\N	3134	17	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2332	LB_4_40_261_1	2025-04-24	1894	\N	3142	17	109.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2333	LB_4_90_262_0	2025-04-24	1894	\N	3191	17	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2334	LB_4_90_262_1	2025-04-24	1894	\N	3191	17	14.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2335	LB_4_90_262_2	2025-04-24	1894	\N	3191	17	8.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2336	LB_5_32_285_0	2025-04-30	1894	\N	3134	18	1.710	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2337	LB_5_32_285_1	2025-04-30	1894	\N	3134	18	511.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2338	LB_5_32_285_2	2025-04-30	1894	\N	3134	19	511.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2339	LB_5_32_285_3	2025-04-30	1894	\N	3134	20	511.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2340	LB_5_40_285_4	2025-04-30	1894	\N	3142	18	1377.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2341	LB_5_40_285_5	2025-04-30	1894	\N	3142	19	1377.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2342	LB_5_40_285_6	2025-04-30	1894	\N	3142	20	1377.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2343	LB_5_143_285_7	2025-04-30	1894	\N	3244	18	8.835	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2344	LB_5_143_285_8	2025-04-30	1894	\N	3244	18	521.265	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2345	LB_5_143_285_9	2025-04-30	1894	\N	3244	19	521.265	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2346	LB_5_143_285_10	2025-04-30	1894	\N	3244	20	521.265	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2347	LB_5_204_285_11	2025-04-30	1894	\N	3305	18	948.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2348	LB_5_204_285_12	2025-04-30	1894	\N	3305	19	948.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2349	LB_5_204_285_13	2025-04-30	1894	\N	3305	20	948.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2350	LB_5_307_285_14	2025-04-30	1894	\N	3408	18	411.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2351	LB_5_307_285_15	2025-04-30	1894	\N	3408	19	411.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2352	LB_5_307_285_16	2025-04-30	1894	\N	3408	20	411.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2353	LB_5_900_285_17	2025-04-30	1894	\N	4000	18	481.920	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2354	LB_5_900_285_18	2025-04-30	1894	\N	4000	19	481.920	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2355	LB_5_900_285_19	2025-04-30	1894	\N	4000	20	481.920	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2356	LB_5_138_285_20	2025-04-30	1894	\N	3239	18	903.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2357	LB_5_138_285_21	2025-04-30	1894	\N	3239	19	903.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2358	LB_5_138_285_22	2025-04-30	1894	\N	3239	20	903.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2359	LB_5_573_285_23	2025-04-30	1894	\N	3739	18	205.530	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2360	LB_5_573_285_24	2025-04-30	1894	\N	3739	19	205.530	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2361	LB_5_573_285_25	2025-04-30	1894	\N	3739	20	205.530	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2362	LB_5_901_285_26	2025-04-30	1894	\N	4001	18	220.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2363	LB_5_901_285_27	2025-04-30	1894	\N	4001	19	220.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2364	LB_5_901_285_28	2025-04-30	1894	\N	4001	20	220.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2365	LB_5_5_285_29	2025-04-30	1894	\N	3107	18	1833.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2366	LB_5_5_285_30	2025-04-30	1894	\N	3107	19	1833.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2367	LB_5_5_285_31	2025-04-30	1894	\N	3107	20	1833.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2368	LB_5_5_285_32	2025-04-30	1894	\N	3107	18	46.350	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2369	LB_5_5_285_33	2025-04-30	1894	\N	3107	19	46.350	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2370	LB_5_5_285_34	2025-04-30	1894	\N	3107	20	46.350	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2371	LB_5_138_286_0	2025-04-30	1894	\N	3239	18	45.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2372	LB_5_138_286_1	2025-04-30	1894	\N	3239	19	45.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2373	LB_5_138_286_2	2025-04-30	1894	\N	3239	20	45.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2374	LB_5_90_287_0	2025-04-30	1894	\N	3191	17	11.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2375	LB_5_90_287_1	2025-04-30	1894	\N	3191	17	6.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2376	LB_5_90_291_0	2025-04-30	1894	\N	3191	17	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2377	LB_5_90_291_1	2025-04-30	1894	\N	3191	17	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2378	LB_5_90_291_2	2025-04-30	1894	\N	3191	17	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2379	LB_5_243_293_0	2025-04-30	1894	\N	3344	18	17.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2380	LB_5_243_293_1	2025-04-30	1894	\N	3344	19	17.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2381	LB_5_596_293_2	2025-04-30	1894	\N	3632	18	80.240	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2382	LB_5_596_293_3	2025-04-30	1894	\N	3632	19	80.240	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2383	LB_5_596_293_4	2025-04-30	1894	\N	3632	20	80.240	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2384	LB_6_17_598_0	2025-05-06	1894	\N	3119	18	1313.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2385	LB_6_17_598_1	2025-05-06	1894	\N	3119	19	1313.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2386	LB_6_17_598_2	2025-05-06	1894	\N	3119	20	1313.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2387	LB_6_40_598_3	2025-05-06	1894	\N	3142	18	2025.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2388	LB_6_40_598_4	2025-05-06	1894	\N	3142	19	2025.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2389	LB_6_40_598_5	2025-05-06	1894	\N	3142	20	2025.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2390	LB_6_40_598_6	2025-05-06	1894	\N	3142	18	27.550	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2391	LB_6_40_598_7	2025-05-06	1894	\N	3142	19	27.550	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2392	LB_6_40_598_8	2025-05-06	1894	\N	3142	20	27.550	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2393	LB_6_460_598_9	2025-05-06	1894	\N	3561	18	1.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2394	LB_6_460_598_10	2025-05-06	1894	\N	3561	19	1.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2395	LB_6_590_598_11	2025-05-06	1894	\N	3756	18	3.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2396	LB_6_590_598_12	2025-05-06	1894	\N	3756	18	6.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2397	LB_6_590_598_13	2025-05-06	1894	\N	3756	19	6.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2398	LB_6_590_598_14	2025-05-06	1894	\N	3756	20	6.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2399	LB_6_208_598_15	2025-05-06	1894	\N	3309	18	116.050	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2400	LB_6_208_598_16	2025-05-06	1894	\N	3309	19	116.050	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2401	LB_6_914_598_17	2025-05-06	1894	\N	4014	18	0.236	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2402	LB_6_914_598_18	2025-05-06	1894	\N	4014	19	0.236	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2403	LB_6_914_598_19	2025-05-06	1894	\N	4014	20	0.236	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2404	LB_6_90_599_0	2025-05-06	1894	\N	3191	17	8.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2405	LB_6_90_599_1	2025-05-06	1894	\N	3191	17	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2406	LB_10_975_996_0	2025-05-28	1894	\N	4076	18	557.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2407	LB_10_975_996_1	2025-05-28	1894	\N	4076	19	557.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2408	LB_10_975_996_2	2025-05-28	1894	\N	4076	20	557.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2409	LB_10_268_996_3	2025-05-28	1894	\N	3369	18	4.008	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2410	LB_10_268_996_4	2025-05-28	1894	\N	3369	18	997.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2411	LB_10_268_996_5	2025-05-28	1894	\N	3369	19	997.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2412	LB_10_268_996_6	2025-05-28	1894	\N	3369	20	997.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2413	LB_10_640_996_7	2025-05-28	1894	\N	3676	18	31.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2414	LB_10_640_996_8	2025-05-28	1894	\N	3676	19	31.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2415	LB_10_640_996_9	2025-05-28	1894	\N	3676	20	31.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2416	LB_10_946_996_10	2025-05-28	1894	\N	4047	18	4.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2417	LB_10_946_996_11	2025-05-28	1894	\N	4047	18	101.250	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2418	LB_10_946_996_12	2025-05-28	1894	\N	4047	19	101.250	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2419	LB_10_946_996_13	2025-05-28	1894	\N	4047	20	101.250	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2420	LB_10_974_996_14	2025-05-28	1894	\N	4075	18	8.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2421	LB_10_974_996_15	2025-05-28	1894	\N	4075	18	2432.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2422	LB_10_974_996_16	2025-05-28	1894	\N	4075	19	2432.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2423	LB_10_974_996_17	2025-05-28	1894	\N	4075	20	2432.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2424	LB_10_88_996_18	2025-05-28	1894	\N	3189	18	138.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2425	LB_10_88_996_19	2025-05-28	1894	\N	3189	18	3323.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2426	LB_10_88_996_20	2025-05-28	1894	\N	3189	19	3323.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2427	LB_10_88_996_21	2025-05-28	1894	\N	3189	20	3323.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2428	LB_10_898_996_22	2025-05-28	1894	\N	3998	18	417.010	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2429	LB_10_898_996_23	2025-05-28	1894	\N	3998	19	417.010	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2430	LB_10_905_996_24	2025-05-28	1894	\N	4005	18	420.140	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2431	LB_10_905_996_25	2025-05-28	1894	\N	4005	19	420.140	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2432	LB_10_905_996_26	2025-05-28	1894	\N	4005	20	420.140	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2433	LB_10_15_996_27	2025-05-28	1894	\N	3117	18	2767.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2434	LB_10_15_996_28	2025-05-28	1894	\N	3117	19	2767.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2435	LB_10_15_996_29	2025-05-28	1894	\N	3117	20	2767.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2436	LB_10_962_996_30	2025-05-28	1894	\N	4063	18	4.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2437	LB_10_962_996_31	2025-05-28	1894	\N	4063	18	460.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2438	LB_10_962_996_32	2025-05-28	1894	\N	4063	19	460.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2439	LB_10_962_996_33	2025-05-28	1894	\N	4063	20	460.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2440	LB_10_299_996_34	2025-05-28	1894	\N	3400	18	403.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2441	LB_10_299_996_35	2025-05-28	1894	\N	3400	19	403.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2442	LB_10_299_996_36	2025-05-28	1894	\N	3400	20	403.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2443	LB_10_90_997_0	2025-05-28	1894	\N	3191	17	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2444	LB_10_90_997_1	2025-05-28	1894	\N	3191	17	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2445	LB_10_90_997_2	2025-05-28	1894	\N	3191	17	3.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2446	LB_11_869_1004_0	2025-06-04	1894	\N	3970	18	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2447	LB_11_299_1005_0	2025-06-04	1894	\N	3400	18	1275.376	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2448	LB_11_299_1005_1	2025-06-04	1894	\N	3400	19	1275.376	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2449	LB_11_299_1005_2	2025-06-04	1894	\N	3400	20	1275.376	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2450	LB_11_299_1005_3	2025-06-04	1894	\N	3400	18	387.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2451	LB_11_299_1005_4	2025-06-04	1894	\N	3400	19	387.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2452	LB_11_299_1005_5	2025-06-04	1894	\N	3400	20	387.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2453	LB_11_454_1005_6	2025-06-04	1894	\N	3555	18	546.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2454	LB_11_454_1005_7	2025-06-04	1894	\N	3555	19	546.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2455	LB_11_454_1005_8	2025-06-04	1894	\N	3555	20	546.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2456	LB_11_874_1005_9	2025-06-04	1894	\N	3975	18	493.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2457	LB_11_874_1005_10	2025-06-04	1894	\N	3975	19	493.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2458	LB_11_874_1005_11	2025-06-04	1894	\N	3975	20	493.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2459	LB_11_90_1006_0	2025-06-04	1894	\N	3191	17	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2460	LB_14_170_1011_0	2025-06-23	1937	\N	3271	18	11.642	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2461	LB_14_170_1011_1	2025-06-23	1937	\N	3271	18	780.014	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2462	LB_14_170_1011_2	2025-06-23	1937	\N	3271	19	780.014	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2463	LB_14_170_1011_3	2025-06-23	1937	\N	3271	20	780.014	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2464	LB_14_125_1011_4	2025-06-23	1937	\N	3226	18	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2465	LB_14_125_1011_5	2025-06-23	1937	\N	3226	18	362.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2466	LB_14_125_1011_6	2025-06-23	1937	\N	3226	19	362.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2467	LB_14_125_1011_7	2025-06-23	1937	\N	3226	20	362.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2468	LB_14_963_1011_8	2025-06-23	1937	\N	4064	18	2201.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2469	LB_14_963_1011_9	2025-06-23	1937	\N	4064	19	2201.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2470	LB_14_963_1011_10	2025-06-23	1937	\N	4064	20	2201.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2471	LB_14_143_1011_11	2025-06-23	1937	\N	3244	18	19.437	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2472	LB_14_143_1011_12	2025-06-23	1937	\N	3244	18	1524.921	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2473	LB_14_143_1011_13	2025-06-23	1937	\N	3244	19	1524.921	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2474	LB_14_143_1011_14	2025-06-23	1937	\N	3244	20	1524.921	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2475	LB_14_454_1011_15	2025-06-23	1937	\N	3555	18	1639.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2476	LB_14_454_1011_16	2025-06-23	1937	\N	3555	19	1639.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2477	LB_14_454_1011_17	2025-06-23	1937	\N	3555	20	1639.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2478	LB_14_539_1011_18	2025-06-23	1937	\N	3705	18	1400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2479	LB_14_539_1011_19	2025-06-23	1937	\N	3705	19	1400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2480	LB_14_539_1011_20	2025-06-23	1937	\N	3705	20	1400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2481	LB_14_958_1011_21	2025-06-23	1937	\N	4059	18	167.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2482	LB_14_958_1011_22	2025-06-23	1937	\N	4059	19	167.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2483	LB_14_958_1011_23	2025-06-23	1937	\N	4059	20	167.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2484	LB_14_869_1011_24	2025-06-23	1937	\N	3970	18	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2485	LB_14_869_1011_25	2025-06-23	1937	\N	3970	19	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2486	LB_14_869_1011_26	2025-06-23	1937	\N	3970	20	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2487	LB_14_971_1011_27	2025-06-23	1937	\N	4072	18	1842.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2488	LB_14_971_1011_28	2025-06-23	1937	\N	4072	19	1842.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2489	LB_14_971_1011_29	2025-06-23	1937	\N	4072	20	1842.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2490	LB_14_874_1011_30	2025-06-23	1937	\N	3975	18	977.130	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2491	LB_14_874_1011_31	2025-06-23	1937	\N	3975	19	977.130	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2492	LB_14_874_1011_32	2025-06-23	1937	\N	3975	20	977.130	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2493	LB_14_874_1011_33	2025-06-23	1937	\N	3975	18	9.870	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2494	LB_15_90_1012_0	2025-06-24	1894	\N	3191	17	22.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2495	LB_15_90_1012_1	2025-06-24	1894	\N	3191	17	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2496	LB_15_170_1014_0	2025-06-24	1894	\N	3271	18	372.544	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2497	LB_15_170_1014_1	2025-06-24	1894	\N	3271	19	372.544	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2498	LB_15_170_1014_2	2025-06-24	1894	\N	3271	20	372.544	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2499	LB_15_226_1014_3	2025-06-24	1894	\N	3327	18	288.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2500	LB_15_226_1014_4	2025-06-24	1894	\N	3327	19	288.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2501	LB_15_152_1014_5	2025-06-24	1894	\N	3253	18	4.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2502	LB_15_152_1014_6	2025-06-24	1894	\N	3253	18	337.960	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2503	LB_15_152_1014_7	2025-06-24	1894	\N	3253	19	337.960	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2504	LB_15_899_1014_8	2025-06-24	1894	\N	3999	18	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2505	LB_15_899_1014_9	2025-06-24	1894	\N	3999	18	1081.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2506	LB_15_899_1014_10	2025-06-24	1894	\N	3999	19	1081.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2507	LB_15_899_1014_11	2025-06-24	1894	\N	3999	20	1081.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2508	LB_15_914_1014_12	2025-06-24	1894	\N	4014	18	109.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2509	LB_15_914_1014_13	2025-06-24	1894	\N	4014	19	109.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2510	LB_15_914_1014_14	2025-06-24	1894	\N	4014	20	109.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2511	LB_15_122_1014_15	2025-06-24	1894	\N	3223	18	185.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2512	LB_15_122_1014_16	2025-06-24	1894	\N	3223	19	185.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2513	LB_15_122_1014_17	2025-06-24	1894	\N	3223	20	185.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2514	LB_15_882_1014_18	2025-06-24	1894	\N	3983	18	20.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2515	LB_15_882_1014_19	2025-06-24	1894	\N	3983	18	3090.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2516	LB_15_882_1014_20	2025-06-24	1894	\N	3983	19	3090.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2517	LB_15_882_1014_21	2025-06-24	1894	\N	3983	20	3090.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2518	LB_15_919_1014_22	2025-06-24	1894	\N	4020	18	833.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2519	LB_15_919_1014_23	2025-06-24	1894	\N	4020	19	833.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2520	LB_15_919_1014_24	2025-06-24	1894	\N	4020	20	833.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2521	LB_16_869_1015_0	2025-07-02	1894	\N	3970	18	13.536	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2522	LB_16_90_1016_0	2025-07-02	1894	\N	3191	17	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2523	LB_16_90_1016_1	2025-07-02	1894	\N	3191	17	9.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2524	LB_21_869_1024_0	2025-07-30	1894	\N	3970	17	56.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2525	LB_21_978_1024_1	2025-07-30	1894	\N	4079	17	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2526	LB_21_90_1024_2	2025-07-30	1894	\N	3191	17	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2527	LB_23_81_1026_0	2025-08-06	1894	\N	3182	18	1.620	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2528	LB_23_81_1026_1	2025-08-06	1894	\N	3182	18	152.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2529	LB_23_81_1026_2	2025-08-06	1894	\N	3182	19	152.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2530	LB_23_81_1026_3	2025-08-06	1894	\N	3182	20	152.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2531	LB_23_961_1026_4	2025-08-06	1894	\N	4062	18	2315.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2532	LB_23_961_1026_5	2025-08-06	1894	\N	4062	19	2315.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2533	LB_23_961_1026_6	2025-08-06	1894	\N	4062	20	2315.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2534	LB_23_974_1026_7	2025-08-06	1894	\N	4075	18	2327.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2535	LB_23_974_1026_8	2025-08-06	1894	\N	4075	19	2327.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2536	LB_23_974_1026_9	2025-08-06	1894	\N	4075	20	2327.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2537	LB_23_130_1026_10	2025-08-06	1894	\N	3231	18	876.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2538	LB_23_130_1026_11	2025-08-06	1894	\N	3231	19	876.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2539	LB_23_130_1026_12	2025-08-06	1894	\N	3231	20	876.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2540	LB_23_585_1026_13	2025-08-06	1894	\N	3751	18	7.060	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2541	LB_23_585_1026_14	2025-08-06	1894	\N	3751	18	635.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2542	LB_23_585_1026_15	2025-08-06	1894	\N	3751	19	635.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2543	LB_23_585_1026_16	2025-08-06	1894	\N	3751	20	635.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2544	LB_23_958_1026_17	2025-08-06	1894	\N	4059	18	327.210	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2545	LB_23_958_1026_18	2025-08-06	1894	\N	4059	19	327.210	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2546	LB_23_958_1026_19	2025-08-06	1894	\N	4059	20	327.210	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2547	LB_23_906_1026_20	2025-08-06	1894	\N	4006	18	732.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2548	LB_23_906_1026_21	2025-08-06	1894	\N	4006	19	732.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2549	LB_23_906_1026_22	2025-08-06	1894	\N	4006	20	732.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2550	LB_23_944_1026_23	2025-08-06	1894	\N	4045	18	1017.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2551	LB_23_944_1026_24	2025-08-06	1894	\N	4045	19	1017.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2552	LB_23_944_1026_25	2025-08-06	1894	\N	4045	20	1017.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2553	LB_23_958_1026_26	2025-08-06	1894	\N	4059	18	25.170	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2554	LB_23_958_1026_27	2025-08-06	1894	\N	4059	18	1652.830	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2555	LB_23_958_1026_28	2025-08-06	1894	\N	4059	19	1652.830	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2556	LB_23_958_1026_29	2025-08-06	1894	\N	4059	20	1652.830	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2557	LB_23_19_1026_30	2025-08-06	1894	\N	3121	18	411.320	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2558	LB_23_19_1026_31	2025-08-06	1894	\N	3121	19	411.320	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2559	LB_23_19_1026_32	2025-08-06	1894	\N	3121	20	411.320	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2560	LB_24_90_1027_0	2025-08-13	1894	\N	3191	17	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2561	LB_24_90_1027_1	2025-08-13	1894	\N	3191	17	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2562	LB_24_90_1027_2	2025-08-13	1894	\N	3191	17	11.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2563	LB_24_90_1027_3	2025-08-13	1894	\N	3191	17	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2564	LB_26_978_1029_0	2025-08-27	1894	\N	4079	18	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2565	LB_27_972_1032_0	2025-09-03	1894	\N	4073	18	180.660	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2566	LB_27_972_1032_1	2025-09-03	1894	\N	4073	19	180.660	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2567	LB_27_972_1032_2	2025-09-03	1894	\N	4073	20	180.660	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2568	LB_27_22_1032_3	2025-09-03	1894	\N	3124	18	1420.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2569	LB_27_22_1032_4	2025-09-03	1894	\N	3124	19	1420.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2570	LB_27_22_1032_5	2025-09-03	1894	\N	3124	20	1420.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2571	LB_27_22_1032_6	2025-09-03	1894	\N	3124	18	9.345	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2572	LB_27_862_1032_7	2025-09-03	1894	\N	3963	18	277.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2573	LB_27_862_1032_8	2025-09-03	1894	\N	3963	19	277.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2574	LB_27_862_1032_9	2025-09-03	1894	\N	3963	20	277.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2575	LB_27_453_1032_10	2025-09-03	1894	\N	3554	18	200.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2576	LB_27_453_1032_11	2025-09-03	1894	\N	3554	19	200.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2577	LB_27_453_1032_12	2025-09-03	1894	\N	3554	20	200.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2578	LB_27_977_1032_13	2025-09-03	1894	\N	4078	18	213.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2579	LB_27_977_1032_14	2025-09-03	1894	\N	4078	19	213.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2580	LB_27_977_1032_15	2025-09-03	1894	\N	4078	20	213.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2581	LB_27_274_1032_16	2025-09-03	1894	\N	3375	18	504.850	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2582	LB_27_274_1032_17	2025-09-03	1894	\N	3375	19	504.850	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2583	LB_27_274_1032_18	2025-09-03	1894	\N	3375	20	504.850	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2584	LB_27_862_1032_19	2025-09-03	1894	\N	3963	18	739.772	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2585	LB_27_862_1032_20	2025-09-03	1894	\N	3963	19	739.772	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2586	LB_27_862_1032_21	2025-09-03	1894	\N	3963	20	739.772	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2587	LB_27_899_1032_22	2025-09-03	1894	\N	3999	18	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2588	LB_27_899_1032_23	2025-09-03	1894	\N	3999	19	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2589	LB_27_899_1032_24	2025-09-03	1894	\N	3999	20	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2590	LB_27_111_1032_25	2025-09-03	1894	\N	3212	18	0.978	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2591	LB_27_111_1032_26	2025-09-03	1894	\N	3212	19	0.978	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2592	LB_27_111_1032_27	2025-09-03	1894	\N	3212	20	0.978	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2593	LB_27_585_1032_28	2025-09-03	1894	\N	3751	18	14.120	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2594	LB_27_585_1032_29	2025-09-03	1894	\N	3751	19	14.120	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2595	LB_27_585_1032_30	2025-09-03	1894	\N	3751	20	14.120	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2596	LB_27_899_1032_31	2025-09-03	1894	\N	3999	18	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2597	LB_27_899_1032_32	2025-09-03	1894	\N	3999	19	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2598	LB_27_899_1032_33	2025-09-03	1894	\N	3999	20	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2599	LB_27_914_1032_34	2025-09-03	1894	\N	4014	18	23.836	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2600	LB_27_914_1032_35	2025-09-03	1894	\N	4014	19	23.836	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2601	LB_27_914_1032_36	2025-09-03	1894	\N	4014	20	23.836	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2602	LB_27_125_1032_37	2025-09-03	1894	\N	3226	18	16.224	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2603	LB_27_125_1032_38	2025-09-03	1894	\N	3226	19	16.224	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2604	LB_27_125_1032_39	2025-09-03	1894	\N	3226	20	16.224	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2605	LB_27_946_1032_40	2025-09-03	1894	\N	4047	18	1.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2606	LB_27_946_1032_41	2025-09-03	1894	\N	4047	19	1.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2607	LB_27_946_1032_42	2025-09-03	1894	\N	4047	20	1.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2608	LB_27_143_1032_43	2025-09-03	1894	\N	3244	18	1.767	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2609	LB_27_143_1032_44	2025-09-03	1894	\N	3244	19	1.767	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2610	LB_27_143_1032_45	2025-09-03	1894	\N	3244	20	1.767	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2611	LB_27_129_1032_46	2025-09-03	1894	\N	3230	18	0.510	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2612	LB_27_129_1032_47	2025-09-03	1894	\N	3230	19	0.510	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2613	LB_27_129_1032_48	2025-09-03	1894	\N	3230	20	0.510	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2614	LB_27_90_1033_0	2025-09-03	1894	\N	3191	17	8.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2615	LB_27_90_1033_1	2025-09-03	1894	\N	3191	17	3.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2616	LB_30_22_1039_0	2025-09-10	2182	\N	3124	18	373.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2617	LB_30_22_1039_1	2025-09-10	2182	\N	3124	19	373.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2618	LB_30_22_1039_2	2025-09-10	2182	\N	3124	20	373.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2619	LB_30_642_1039_3	2025-09-10	2182	\N	3678	18	7.365	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2620	LB_30_642_1039_4	2025-09-10	2182	\N	3678	18	1200.495	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2621	LB_30_642_1039_5	2025-09-10	2182	\N	3678	19	1200.495	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2622	LB_30_642_1039_6	2025-09-10	2182	\N	3678	20	1200.495	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2623	LB_30_947_1039_7	2025-09-10	2182	\N	4048	18	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2624	LB_30_947_1039_8	2025-09-10	2182	\N	4048	19	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2625	LB_30_947_1039_9	2025-09-10	2182	\N	4048	20	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2626	LB_30_109_1039_10	2025-09-10	2182	\N	3210	18	1967.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2627	LB_30_109_1039_11	2025-09-10	2182	\N	3210	19	1967.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2628	LB_30_109_1039_12	2025-09-10	2182	\N	3210	20	1967.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2629	LB_30_40_1039_13	2025-09-10	2182	\N	3142	18	609.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2630	LB_30_40_1039_14	2025-09-10	2182	\N	3142	19	609.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2631	LB_30_40_1039_15	2025-09-10	2182	\N	3142	20	609.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2632	LB_29_90_1040_0	2025-09-09	1894	\N	3191	17	10.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2633	LB_29_90_1040_1	2025-09-09	1894	\N	3191	17	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2634	LB_31_90_1041_0	2025-09-17	1894	\N	3191	17	10.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2635	LB_31_90_1041_1	2025-09-17	1894	\N	3191	17	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2636	LB_31_109_1042_0	2025-09-17	1894	\N	3210	18	68.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2637	LB_31_109_1042_1	2025-09-17	1894	\N	3210	18	426.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2638	LB_31_109_1042_2	2025-09-17	1894	\N	3210	19	426.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2639	LB_31_109_1042_3	2025-09-17	1894	\N	3210	20	426.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2640	LB_31_40_1042_4	2025-09-17	1894	\N	3142	18	20.300	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2641	LB_31_40_1042_5	2025-09-17	1894	\N	3142	18	1945.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2642	LB_31_40_1042_6	2025-09-17	1894	\N	3142	19	1945.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2643	LB_31_40_1042_7	2025-09-17	1894	\N	3142	20	1945.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2644	LB_31_299_1042_8	2025-09-17	1894	\N	3400	18	169.334	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2645	LB_31_299_1042_9	2025-09-17	1894	\N	3400	19	169.334	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2646	LB_31_299_1042_10	2025-09-17	1894	\N	3400	20	169.334	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2647	LB_32_1_1044_0	2025-09-24	1894	\N	3103	17	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2648	LB_32_90_1045_0	2025-09-24	1894	\N	3191	17	6.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2649	LB_32_90_1045_1	2025-09-24	1894	\N	3191	17	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2650	LB_32_978_1045_2	2025-09-24	1894	\N	4079	17	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2651	LB_35_103_1055_0	2025-10-08	1894	\N	3204	18	975.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2652	LB_35_103_1055_1	2025-10-08	1894	\N	3204	19	975.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2653	LB_35_103_1055_2	2025-10-08	1894	\N	3204	20	975.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2654	LB_35_115_1055_3	2025-10-08	1894	\N	3216	18	163.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2655	LB_35_115_1055_4	2025-10-08	1894	\N	3216	19	163.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2656	LB_35_115_1055_5	2025-10-08	1894	\N	3216	20	163.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2657	LB_35_204_1055_6	2025-10-08	1894	\N	3305	18	21.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2658	LB_35_204_1055_7	2025-10-08	1894	\N	3305	18	2613.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2659	LB_35_204_1055_8	2025-10-08	1894	\N	3305	19	2613.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2660	LB_35_204_1055_9	2025-10-08	1894	\N	3305	20	2613.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2661	LB_35_879_1055_10	2025-10-08	1894	\N	3980	18	7.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2662	LB_35_879_1055_11	2025-10-08	1894	\N	3980	18	319.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2663	LB_35_879_1055_12	2025-10-08	1894	\N	3980	19	319.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2664	LB_35_15_1055_13	2025-10-08	1894	\N	3117	18	2651.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2665	LB_35_15_1055_14	2025-10-08	1894	\N	3117	19	2651.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2666	LB_35_15_1055_15	2025-10-08	1894	\N	3117	20	2651.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2667	LB_35_22_1055_16	2025-10-08	1894	\N	3124	18	9.345	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2668	LB_35_22_1055_17	2025-10-08	1894	\N	3124	18	943.845	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2669	LB_35_22_1055_18	2025-10-08	1894	\N	3124	19	943.845	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2670	LB_35_22_1055_19	2025-10-08	1894	\N	3124	20	943.845	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2671	LB_35_979_1055_20	2025-10-08	1894	\N	4080	18	706.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2672	LB_35_979_1055_21	2025-10-08	1894	\N	4080	19	706.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2673	LB_35_979_1055_22	2025-10-08	1894	\N	4080	20	706.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2674	LB_35_980_1055_23	2025-10-08	1894	\N	4081	18	762.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2675	LB_35_980_1055_24	2025-10-08	1894	\N	4081	19	762.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2676	LB_35_980_1055_25	2025-10-08	1894	\N	4081	20	762.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2677	LB_35_981_1055_26	2025-10-08	1894	\N	4082	18	430.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2678	LB_35_981_1055_27	2025-10-08	1894	\N	4082	19	430.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2679	LB_35_981_1055_28	2025-10-08	1894	\N	4082	20	430.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2680	LB_35_22_1055_29	2025-10-08	1894	\N	3124	18	934.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2681	LB_35_22_1055_30	2025-10-08	1894	\N	3124	19	934.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2682	LB_36_90_1056_0	2025-10-15	1894	\N	3191	17	17.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2683	LB_36_90_1056_1	2025-10-15	1894	\N	3191	17	9.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2684	LB_37_859_1060_0	2025-10-22	1894	\N	3960	18	14.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2685	LB_37_859_1060_1	2025-10-22	1894	\N	3960	18	1423.620	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2686	LB_37_859_1060_2	2025-10-22	1894	\N	3960	19	1423.620	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2687	LB_37_859_1060_3	2025-10-22	1894	\N	3960	20	1423.620	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2688	LB_37_394_1060_4	2025-10-22	1894	\N	3495	18	960.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2689	LB_37_394_1060_5	2025-10-22	1894	\N	3495	19	960.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2690	LB_37_394_1060_6	2025-10-22	1894	\N	3495	20	960.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2691	LB_37_164_1060_7	2025-10-22	1894	\N	3265	18	27.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2692	LB_37_164_1060_8	2025-10-22	1894	\N	3265	19	27.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2693	LB_37_164_1060_9	2025-10-22	1894	\N	3265	20	27.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2694	LB_37_230_1060_10	2025-10-22	1894	\N	3331	18	321.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2695	LB_37_230_1060_11	2025-10-22	1894	\N	3331	19	321.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2696	LB_37_230_1060_12	2025-10-22	1894	\N	3331	20	321.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2697	LB_37_367_1060_13	2025-10-22	1894	\N	3468	18	32.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2698	LB_37_367_1060_14	2025-10-22	1894	\N	3468	19	32.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2699	LB_37_626_1060_15	2025-10-22	1894	\N	3662	18	148.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2700	LB_37_626_1060_16	2025-10-22	1894	\N	3662	19	148.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2701	LB_37_626_1060_17	2025-10-22	1894	\N	3662	20	148.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2702	LB_37_963_1060_18	2025-10-22	1894	\N	4064	18	1584.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2703	LB_37_963_1060_19	2025-10-22	1894	\N	4064	19	1584.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2704	LB_37_963_1060_20	2025-10-22	1894	\N	4064	20	1584.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2705	LB_37_229_1060_21	2025-10-22	1894	\N	3330	18	29.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2706	LB_37_229_1060_22	2025-10-22	1894	\N	3330	19	29.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2707	LB_37_229_1060_23	2025-10-22	1894	\N	3330	20	29.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2708	LB_37_90_1061_0	2025-10-22	1894	\N	3191	17	3.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2709	LB_37_90_1061_1	2025-10-22	1894	\N	3191	17	9.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2710	LB_37_18_1062_0	2025-10-22	1894	\N	3120	18	785.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2711	LB_37_18_1062_1	2025-10-22	1894	\N	3120	19	785.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2712	LB_37_18_1062_2	2025-10-22	1894	\N	3120	20	785.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2713	LB_39_279_1067_0	2025-11-05	1894	\N	3380	18	108.252	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2714	LB_39_279_1067_1	2025-11-05	1894	\N	3380	19	108.252	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2715	LB_39_950_1067_2	2025-11-05	1894	\N	4051	18	12.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2716	LB_39_950_1067_3	2025-11-05	1894	\N	4051	18	1769.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2717	LB_39_950_1067_4	2025-11-05	1894	\N	4051	19	1769.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2718	LB_39_950_1067_5	2025-11-05	1894	\N	4051	20	1769.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2719	LB_39_104_1067_6	2025-11-05	1894	\N	3205	18	601.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2720	LB_39_104_1067_7	2025-11-05	1894	\N	3205	19	601.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2721	LB_39_104_1067_8	2025-11-05	1894	\N	3205	20	601.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2722	LB_39_64_1067_9	2025-11-05	1894	\N	3166	18	779.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2723	LB_39_64_1067_10	2025-11-05	1894	\N	3166	19	779.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2724	LB_39_64_1067_11	2025-11-05	1894	\N	3166	20	779.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2725	LB_39_164_1067_12	2025-11-05	1894	\N	3265	18	964.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2726	LB_39_164_1067_13	2025-11-05	1894	\N	3265	19	964.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2727	LB_39_164_1067_14	2025-11-05	1894	\N	3265	20	964.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2728	LB_39_954_1067_15	2025-11-05	1894	\N	4055	18	340.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2729	LB_39_954_1067_16	2025-11-05	1894	\N	4055	19	340.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2730	LB_39_954_1067_17	2025-11-05	1894	\N	4055	20	340.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2731	LB_39_983_1067_18	2025-11-05	1894	\N	4084	18	141.764	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2732	LB_39_983_1067_19	2025-11-05	1894	\N	4084	19	141.764	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2733	LB_39_983_1067_20	2025-11-05	1894	\N	4084	20	141.764	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2734	LB_39_984_1067_21	2025-11-05	1894	\N	4085	18	138.558	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2735	LB_39_984_1067_22	2025-11-05	1894	\N	4085	19	138.558	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2736	LB_39_984_1067_23	2025-11-05	1894	\N	4085	20	138.558	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2737	LB_39_983_1067_24	2025-11-05	1894	\N	4084	18	253.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2738	LB_39_983_1067_25	2025-11-05	1894	\N	4084	19	253.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2739	LB_39_983_1067_26	2025-11-05	1894	\N	4084	20	253.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2740	LB_39_516_1067_27	2025-11-05	1894	\N	3617	18	27.090	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2741	LB_40_90_1068_0	2025-11-05	2179	\N	3191	17	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2742	LB_40_90_1068_1	2025-11-05	2179	\N	3191	17	12.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2743	LB_41_28_1072_0	2025-11-19	1894	\N	3130	18	55.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2744	LB_41_28_1072_1	2025-11-19	1894	\N	3130	18	2202.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2745	LB_41_28_1072_2	2025-11-19	1894	\N	3130	19	2202.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2746	LB_41_28_1072_3	2025-11-19	1894	\N	3130	20	2202.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2747	LB_41_268_1072_4	2025-11-19	1894	\N	3369	18	1170.336	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2748	LB_41_268_1072_5	2025-11-19	1894	\N	3369	19	1170.336	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2749	LB_41_268_1072_6	2025-11-19	1894	\N	3369	20	1170.336	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2750	LB_41_566_1072_7	2025-11-19	1894	\N	3732	18	9.390	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2751	LB_41_566_1072_8	2025-11-19	1894	\N	3732	18	929.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2752	LB_41_566_1072_9	2025-11-19	1894	\N	3732	19	929.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2753	LB_41_566_1072_10	2025-11-19	1894	\N	3732	20	929.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2754	LB_41_982_1072_11	2025-11-19	1894	\N	4083	18	7.251	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2755	LB_41_982_1072_12	2025-11-19	1894	\N	4083	18	188.526	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2756	LB_41_982_1072_13	2025-11-19	1894	\N	4083	19	188.526	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2757	LB_41_982_1072_14	2025-11-19	1894	\N	4083	20	188.526	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2758	LB_41_982_1072_15	2025-11-19	1894	\N	4083	18	152.271	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2759	LB_41_982_1072_16	2025-11-19	1894	\N	4083	19	152.271	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2760	LB_41_982_1072_17	2025-11-19	1894	\N	4083	20	152.271	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2761	LB_41_114_1072_18	2025-11-19	1894	\N	3215	18	515.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2762	LB_41_114_1072_19	2025-11-19	1894	\N	3215	19	515.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2763	LB_41_114_1072_20	2025-11-19	1894	\N	3215	20	515.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2764	LB_41_178_1072_21	2025-11-19	1894	\N	3279	18	964.410	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2765	LB_41_178_1072_22	2025-11-19	1894	\N	3279	19	964.410	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2766	LB_41_178_1072_23	2025-11-19	1894	\N	3279	20	964.410	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2767	LB_41_452_1072_24	2025-11-19	1894	\N	3553	18	58.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2768	LB_41_452_1072_25	2025-11-19	1894	\N	3553	18	139.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2769	LB_41_452_1072_26	2025-11-19	1894	\N	3553	19	139.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2770	LB_41_452_1072_27	2025-11-19	1894	\N	3553	20	139.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2771	LB_41_311_1072_28	2025-11-19	1894	\N	3412	18	3.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2772	LB_41_311_1072_29	2025-11-19	1894	\N	3412	18	164.640	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2773	LB_41_311_1072_30	2025-11-19	1894	\N	3412	19	164.640	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2774	LB_41_516_1072_31	2025-11-19	1894	\N	3617	18	785.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2775	LB_41_516_1072_32	2025-11-19	1894	\N	3617	19	785.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2776	LB_41_516_1072_33	2025-11-19	1894	\N	3617	20	785.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2777	LB_41_229_1072_34	2025-11-19	1894	\N	3330	18	224.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2778	LB_41_229_1072_35	2025-11-19	1894	\N	3330	19	224.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2779	LB_41_229_1072_36	2025-11-19	1894	\N	3330	20	224.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2780	LB_41_268_1072_37	2025-11-19	1894	\N	3369	18	32.064	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2781	LB_41_268_1072_38	2025-11-19	1894	\N	3369	19	32.064	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2782	LB_41_268_1072_39	2025-11-19	1894	\N	3369	20	32.064	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2783	LB_41_202_1072_40	2025-11-19	1894	\N	3303	18	313.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2784	LB_41_202_1072_41	2025-11-19	1894	\N	3303	19	313.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2785	LB_41_204_1072_42	2025-11-19	1894	\N	3305	18	39.330	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2786	LB_41_208_1072_43	2025-11-19	1894	\N	3309	18	2.110	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2787	LB_41_208_1072_44	2025-11-19	1894	\N	3309	18	303.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2788	LB_41_208_1072_45	2025-11-19	1894	\N	3309	19	303.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2789	LB_41_297_1072_46	2025-11-19	1894	\N	3398	18	32.890	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2790	LB_41_297_1072_47	2025-11-19	1894	\N	3398	19	32.890	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2791	LB_41_646_1072_48	2025-11-19	1894	\N	3682	18	261.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2792	LB_41_646_1072_49	2025-11-19	1894	\N	3682	19	261.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2793	LB_41_646_1072_50	2025-11-19	1894	\N	3682	20	261.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2794	LB_41_454_1072_51	2025-11-19	1894	\N	3555	18	49.176	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2795	LB_41_454_1072_52	2025-11-19	1894	\N	3555	18	1447.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2796	LB_41_454_1072_53	2025-11-19	1894	\N	3555	19	1447.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2797	LB_41_454_1072_54	2025-11-19	1894	\N	3555	20	1447.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2798	LB_41_204_1072_55	2025-11-19	1894	\N	3305	18	620.540	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2799	LB_41_204_1072_56	2025-11-19	1894	\N	3305	19	620.540	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2800	LB_41_204_1072_57	2025-11-19	1894	\N	3305	20	620.540	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2801	LB_41_90_1073_0	2025-11-19	1894	\N	3191	17	4.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2802	LB_41_90_1073_1	2025-11-19	1894	\N	3191	17	14.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2803	LB_41_90_1073_2	2025-11-19	1894	\N	3191	17	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2804	LB_42_1_1075_0	2025-11-26	1894	\N	3103	17	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2805	LB_42_985_1076_0	2025-11-26	1894	\N	4086	18	1284.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2806	LB_42_985_1076_1	2025-11-26	1894	\N	4086	19	1284.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2807	LB_42_985_1076_2	2025-11-26	1894	\N	4086	20	1284.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2808	LB_42_983_1076_3	2025-11-26	1894	\N	4084	18	1012.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2809	LB_42_983_1076_4	2025-11-26	1894	\N	4084	19	1012.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2810	LB_42_983_1076_5	2025-11-26	1894	\N	4084	20	1012.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2811	LB_42_984_1076_6	2025-11-26	1894	\N	4085	18	9.897	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2812	LB_42_984_1076_7	2025-11-26	1894	\N	4085	18	1088.670	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2813	LB_42_984_1076_8	2025-11-26	1894	\N	4085	19	1088.670	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2814	LB_42_984_1076_9	2025-11-26	1894	\N	4085	20	1088.670	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2815	LB_42_40_1076_10	2025-11-26	1894	\N	3142	18	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2816	LB_42_40_1076_11	2025-11-26	1894	\N	3142	19	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2817	LB_42_40_1076_12	2025-11-26	1894	\N	3142	20	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2818	LB_42_279_1076_13	2025-11-26	1894	\N	3380	18	0.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2819	LB_42_279_1076_14	2025-11-26	1894	\N	3380	19	0.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2820	LB_42_229_1076_15	2025-11-26	1894	\N	3330	18	0.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2821	LB_42_229_1076_16	2025-11-26	1894	\N	3330	19	0.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2822	LB_42_229_1076_17	2025-11-26	1894	\N	3330	20	0.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2823	LB_42_90_1077_0	2025-11-26	1894	\N	3191	17	6.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2824	LB_42_90_1077_1	2025-11-26	1894	\N	3191	17	2.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2825	LB_43_914_1086_0	2025-12-03	1894	\N	4014	18	0.470	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2826	LB_43_914_1086_1	2025-12-03	1894	\N	4014	19	0.470	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2827	LB_43_914_1086_2	2025-12-03	1894	\N	4014	20	0.470	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2828	LB_43_862_1087_0	2025-12-03	1894	\N	3963	18	1.462	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2829	LB_43_862_1087_1	2025-12-03	1894	\N	3963	18	1314.338	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2830	LB_43_862_1087_2	2025-12-03	1894	\N	3963	19	1314.338	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2831	LB_43_862_1087_3	2025-12-03	1894	\N	3963	20	1314.338	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2832	LB_43_245_1087_4	2025-12-03	1894	\N	3346	18	297.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2833	LB_43_245_1087_5	2025-12-03	1894	\N	3346	19	297.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2834	LB_43_245_1087_6	2025-12-03	1894	\N	3346	20	297.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2835	LB_43_986_1087_7	2025-12-03	1894	\N	4087	18	1075.104	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2836	LB_43_986_1087_8	2025-12-03	1894	\N	4087	19	1075.104	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2837	LB_43_986_1087_9	2025-12-03	1894	\N	4087	20	1075.104	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2838	LB_43_963_1087_10	2025-12-03	1894	\N	4064	18	1932.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2839	LB_43_963_1087_11	2025-12-03	1894	\N	4064	19	1932.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2840	LB_43_963_1087_12	2025-12-03	1894	\N	4064	20	1932.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2841	LB_43_287_1087_13	2025-12-03	1894	\N	3388	18	180.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2842	LB_43_287_1087_14	2025-12-03	1894	\N	3388	19	180.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2843	LB_43_287_1087_15	2025-12-03	1894	\N	3388	20	180.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2844	LB_43_963_1087_16	2025-12-03	1894	\N	4064	18	47.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2845	LB_44_90_1088_0	2025-12-10	1894	\N	3191	17	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2846	LB_44_90_1088_1	2025-12-10	1894	\N	3191	17	3.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2847	LB_44_90_1091_0	2025-12-10	1894	\N	3191	17	2.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2848	LB_44_988_1091_1	2025-12-10	1894	\N	4089	17	36.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2849	LB_45_486_1094_0	2025-12-10	1894	\N	3587	20	1840.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2850	LB_45_88_1094_1	2025-12-10	1894	\N	3189	18	1456.560	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2851	LB_45_88_1094_2	2025-12-10	1894	\N	3189	19	1456.560	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2852	LB_45_88_1094_3	2025-12-10	1894	\N	3189	20	1456.560	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2853	LB_45_987_1094_4	2025-12-10	1894	\N	4088	18	223.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2854	LB_45_987_1094_5	2025-12-10	1894	\N	4088	19	223.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2855	LB_45_987_1094_6	2025-12-10	1894	\N	4088	20	223.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2856	LB_45_974_1094_7	2025-12-10	1894	\N	4075	18	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2857	LB_45_974_1094_8	2025-12-10	1894	\N	4075	19	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2858	LB_45_974_1094_9	2025-12-10	1894	\N	4075	20	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2859	LB_45_989_1094_10	2025-12-10	1894	\N	4090	18	142.335	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2860	LB_45_989_1094_11	2025-12-10	1894	\N	4090	19	142.335	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2861	LB_45_989_1094_12	2025-12-10	1894	\N	4090	20	142.335	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2862	LB_45_990_1094_13	2025-12-10	1894	\N	4091	18	125.568	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2863	LB_45_990_1094_14	2025-12-10	1894	\N	4091	19	125.568	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2864	LB_45_990_1094_15	2025-12-10	1894	\N	4091	20	125.568	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2865	LB_45_486_1094_16	2025-12-10	1894	\N	3587	18	1840.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2866	LB_45_486_1094_17	2025-12-10	1894	\N	3587	19	1840.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2867	LB_45_90_1095_0	2025-12-11	1894	\N	3191	17	8.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2868	LB_45_90_1095_1	2025-12-11	1894	\N	3191	17	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2869	LB_47_869_1099_0	2025-12-24	1894	\N	3970	17	42.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2870	LB_47_978_1099_1	2025-12-24	1894	\N	4079	17	20.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2871	LB_47_974_1100_0	2025-12-24	1894	\N	4075	18	8.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2872	LB_47_974_1100_1	2025-12-24	1894	\N	4075	18	1203.920	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2873	LB_47_974_1100_2	2025-12-24	1894	\N	4075	19	1203.920	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2874	LB_47_974_1100_3	2025-12-24	1894	\N	4075	20	1203.920	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2875	LB_47_869_1100_4	2025-12-24	1894	\N	3970	18	12.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2876	LB_47_90_1101_0	2025-12-24	1894	\N	3191	17	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2877	LB_47_90_1101_1	2025-12-24	1894	\N	3191	17	3.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2878	LB_49_88_1105_0	2026-01-07	1894	\N	3189	18	52.020	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2879	LB_49_88_1105_1	2026-01-07	1894	\N	3189	18	1959.420	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2880	LB_49_88_1105_2	2026-01-07	1894	\N	3189	19	1959.420	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2881	LB_49_88_1105_3	2026-01-07	1894	\N	3189	20	1959.420	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2882	LB_49_452_1105_4	2026-01-07	1894	\N	3553	18	58.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2883	LB_49_452_1105_5	2026-01-07	1894	\N	3553	18	1105.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2884	LB_49_452_1105_6	2026-01-07	1894	\N	3553	19	1105.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2885	LB_49_452_1105_7	2026-01-07	1894	\N	3553	20	1105.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2886	LB_49_394_1105_8	2026-01-07	1894	\N	3495	18	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2887	LB_49_394_1105_9	2026-01-07	1894	\N	3495	18	950.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2888	LB_49_394_1105_10	2026-01-07	1894	\N	3495	19	950.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2889	LB_49_394_1105_11	2026-01-07	1894	\N	3495	20	950.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2890	LB_49_990_1105_12	2026-01-07	1894	\N	4091	18	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2891	LB_49_990_1105_13	2026-01-07	1894	\N	4091	19	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2892	LB_49_990_1105_14	2026-01-07	1894	\N	4091	20	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2893	LB_49_909_1105_15	2026-01-07	1894	\N	4009	18	26.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2894	LB_49_909_1105_16	2026-01-07	1894	\N	4009	18	1578.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2895	LB_49_909_1105_17	2026-01-07	1894	\N	4009	19	1578.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2896	LB_49_909_1105_18	2026-01-07	1894	\N	4009	20	1578.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2897	LB_49_990_1105_19	2026-01-07	1894	\N	4091	18	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2898	LB_49_990_1105_20	2026-01-07	1894	\N	4091	18	1083.024	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2899	LB_49_990_1105_21	2026-01-07	1894	\N	4091	19	1083.024	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2900	LB_49_990_1105_22	2026-01-07	1894	\N	4091	20	1083.024	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2901	LB_50_90_1106_0	2026-01-07	1894	\N	3191	17	14.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2902	LB_50_90_1106_1	2026-01-07	1894	\N	3191	17	5.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2903	LB_53_90_1112_0	2026-01-28	1894	\N	3191	17	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2904	LB_53_90_1112_1	2026-01-28	1894	\N	3191	17	12.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2905	LB_53_90_1112_2	2026-01-28	1894	\N	3191	17	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2906	LB_54_138_1113_0	2026-02-04	1894	\N	3239	18	3.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2907	LB_54_138_1113_1	2026-02-04	1894	\N	3239	18	836.580	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2908	LB_54_138_1113_2	2026-02-04	1894	\N	3239	19	836.580	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2909	LB_54_138_1113_3	2026-02-04	1894	\N	3239	20	836.580	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2910	LB_54_146_1113_4	2026-02-04	1894	\N	3247	18	5.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2911	LB_54_146_1113_5	2026-02-04	1894	\N	3247	18	801.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2912	LB_54_146_1113_6	2026-02-04	1894	\N	3247	19	801.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2913	LB_54_172_1113_7	2026-02-04	1894	\N	3273	18	689.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2914	LB_54_172_1113_8	2026-02-04	1894	\N	3273	19	689.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2915	LB_54_172_1113_9	2026-02-04	1894	\N	3273	20	689.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2916	LB_54_184_1113_10	2026-02-04	1894	\N	3285	18	118.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2917	LB_54_184_1113_11	2026-02-04	1894	\N	3285	19	118.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2918	LB_54_184_1113_12	2026-02-04	1894	\N	3285	20	118.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2919	LB_54_194_1113_13	2026-02-04	1894	\N	3295	18	200.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2920	LB_54_194_1113_14	2026-02-04	1894	\N	3295	19	200.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2921	LB_54_948_1113_15	2026-02-04	1894	\N	4049	18	1701.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2922	LB_54_948_1113_16	2026-02-04	1894	\N	4049	19	1701.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2923	LB_54_948_1113_17	2026-02-04	1894	\N	4049	20	1701.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2924	LB_54_217_1113_18	2026-02-04	1894	\N	3318	18	271.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2925	LB_54_217_1113_19	2026-02-04	1894	\N	3318	19	271.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2926	LB_54_217_1113_20	2026-02-04	1894	\N	3318	20	271.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2927	LB_54_991_1113_21	2026-02-04	1894	\N	4092	18	44.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2928	LB_54_991_1113_22	2026-02-04	1894	\N	4092	19	44.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2929	LB_54_991_1113_23	2026-02-04	1894	\N	4092	20	44.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2930	LB_54_5_1113_24	2026-02-04	1894	\N	3107	18	978.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2931	LB_54_5_1113_25	2026-02-04	1894	\N	3107	19	978.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2932	LB_54_5_1113_26	2026-02-04	1894	\N	3107	20	978.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2933	LB_54_188_1113_27	2026-02-04	1894	\N	3289	18	11.685	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2934	LB_54_220_1113_28	2026-02-04	1894	\N	3321	18	22.590	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2935	LB_54_188_1113_29	2026-02-04	1894	\N	3289	18	408.975	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2936	LB_54_188_1113_30	2026-02-04	1894	\N	3289	19	408.975	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2937	LB_54_220_1113_31	2026-02-04	1894	\N	3321	18	687.740	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2938	LB_54_220_1113_32	2026-02-04	1894	\N	3321	19	687.740	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2939	LB_54_299_1113_33	2026-02-04	1894	\N	3400	18	11.814	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2940	LB_54_299_1113_34	2026-02-04	1894	\N	3400	18	1535.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2941	LB_54_299_1113_35	2026-02-04	1894	\N	3400	19	1535.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2942	LB_54_299_1113_36	2026-02-04	1894	\N	3400	20	1535.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2943	LB_54_948_1113_37	2026-02-04	1894	\N	4049	18	3.384	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2944	LB_54_948_1113_38	2026-02-04	1894	\N	4049	19	3.384	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2945	LB_54_948_1113_39	2026-02-04	1894	\N	4049	20	3.384	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2946	LB_54_213_1113_40	2026-02-04	1894	\N	3314	18	189.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2947	LB_54_213_1113_41	2026-02-04	1894	\N	3314	19	189.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2948	LB_54_213_1113_42	2026-02-04	1894	\N	3314	20	189.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2949	LB_54_990_1113_43	2026-02-04	1894	\N	4091	18	1098.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2950	LB_54_990_1113_44	2026-02-04	1894	\N	4091	19	1098.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2951	LB_54_990_1113_45	2026-02-04	1894	\N	4091	20	1098.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2952	LB_55_217_1114_0	2026-02-11	1894	\N	3318	18	36.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2953	LB_55_217_1114_1	2026-02-11	1894	\N	3318	19	36.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2954	LB_55_217_1114_2	2026-02-11	1894	\N	3318	20	36.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2955	LB_55_990_1114_3	2026-02-11	1894	\N	4091	18	408.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2956	LB_55_990_1114_4	2026-02-11	1894	\N	4091	19	408.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2957	LB_55_990_1114_5	2026-02-11	1894	\N	4091	20	408.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2958	LB_57_869_1117_0	2026-03-31	1894	\N	3970	18	15.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2959	LB_57_869_1117_1	2026-03-31	1894	\N	3970	19	15.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
2960	LB_57_869_1117_2	2026-03-31	1894	\N	3970	20	15.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:08.220246	2026-08-03 15:19:08.220246	[]	[]	\N
\.


--
-- Data for Name: salary_vouchers; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.salary_vouchers (id, voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, allowances, deductions, net_salary, narration, created_by, created_at, updated_at) FROM stdin;
16	SAL_1_146	2025-04-12	2506	4	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:08.950231	2026-08-03 15:19:08.950231
17	SAL_2_238	2025-04-18	2506	4	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:08.950231	2026-08-03 15:19:08.950231
18	SAL_3_485	2025-05-05	2506	5	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:08.950231	2026-08-03 15:19:08.950231
19	SAL_4_938	2025-05-15	2506	5	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:08.950231	2026-08-03 15:19:08.950231
20	SAL_5_939	2025-05-15	2506	5	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:08.950231	2026-08-03 15:19:08.950231
\.


--
-- Data for Name: stock_adjustments; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.stock_adjustments (id, adjustment_no, adjustment_date, product_id, quantity, reason, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: stock_inward; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.stock_inward (id, inward_no, inward_date, product_id, process_id, ledger_id, quantity, rate, amount, uom_id, narration, serial_no, ref_no, ref_date, expected_duration_days, weight, total_weight, items, is_completed, completed_date, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_item_movements; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.stock_item_movements (id, movement_no, movement_date, movement_type, stock_item_id, ledger_id, quantity, rate, amount, uom_id, ref_no, narration, items, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_outward; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.stock_outward (id, outward_no, outward_date, inward_id, product_id, process_id, ledger_id, quantity, rate, amount, weight, total_weight, uom_id, serial_no, ref_no, narration, items, inward_ids, dispatch_through, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_transfer; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.stock_transfer (id, transfer_no, transfer_date, from_stock_item_id, to_stock_item_id, quantity, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: voucher_lines; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.voucher_lines (id, voucher_id, ledger_id, dr_amount, cr_amount, narration) FROM stdin;
1279	648	2056	0.00	260.00	WATER CAN, MILK
1280	648	1966	260.00	0.00	WATER CAN, MILK
1281	640	2056	0.00	600.00	Eicher Oil
1282	640	2123	600.00	0.00	Eicher Oil
1283	641	2056	0.00	200.00	Tea
1284	641	1947	200.00	0.00	Tea
1285	642	2056	0.00	100.00	DINNER EXPENSE FOR WATCHMAN (SUNDAY DOUBLE DUTY)
1286	651	2056	0.00	1925.00	LABOUR CHARGE DT FROM 29.03 TO 04.04
1287	651	2295	1925.00	0.00	LABOUR CHARGE DT FROM 29.03 TO 04.04
1288	652	2056	0.00	2275.00	LABOUR CHARGE FROM 29.03 TO  04.04
1289	652	2311	2275.00	0.00	LABOUR CHARGE FROM 29.03 TO  04.04
1290	653	2056	0.00	1560.00	LABOUR CHARGE  FROM 29.03 TO 04.04
1291	653	2312	1560.00	0.00	LABOUR CHARGE  FROM 29.03 TO 04.04
1292	654	2056	0.00	17496.00	CONTRACT LABOUR CHARGE  01.04 TO 4.4
1293	654	2327	17496.00	0.00	CONTRACT LABOUR CHARGE  01.04 TO 4.4
1294	655	2056	0.00	356.00	CONTRACTOR CHARGE FOR 29.03
1295	655	2218	356.00	0.00	CONTRACTOR CHARGE FOR 29.03
1296	656	2056	0.00	350.00	PAID FOR AUTO RENT TO TEXMO
1297	656	2218	350.00	0.00	PAID FOR AUTO RENT TO TEXMO
1298	657	2018	0.00	100.00	STAFF AUTO CHARGE
1299	657	1914	100.00	0.00	STAFF AUTO CHARGE
1300	659	2018	0.00	15000.00	AC PURCHASE 2TONE
1301	659	1954	15000.00	0.00	AC PURCHASE 2TONE
1302	658	2056	0.00	250.00	HINDI LOBOUR AUTO CHARGE
1303	658	1914	250.00	0.00	HINDI LOBOUR AUTO CHARGE
1304	660	2056	0.00	90.00	JUICE & MILK EXPENSES
1305	660	1966	90.00	0.00	JUICE & MILK EXPENSES
1306	669	1980	0.00	2700.00	
1307	669	1996	2700.00	0.00	
1308	670	2056	0.00	2700.00	PURCHASE OF 90 SET GLOUSE
1309	670	1980	2700.00	0.00	PURCHASE OF 90 SET GLOUSE
1310	668	2056	0.00	400.00	NIGHT SHIFT TIFFEN
1311	668	1966	400.00	0.00	NIGHT SHIFT TIFFEN
1312	667	2056	0.00	200.00	SHIVA KUMAR
1313	667	1981	200.00	0.00	SHIVA KUMAR
1314	671	2056	0.00	250.00	PAID FOR HINDHI LABOURS
1315	671	1914	250.00	0.00	PAID FOR HINDHI LABOURS
1316	672	2056	0.00	900.00	CASH PAID FOR LUNCH
1317	672	1966	900.00	0.00	CASH PAID FOR LUNCH
1318	673	2350	0.00	14000.00	
1319	673	1954	14000.00	0.00	
1320	674	2056	0.00	14400.00	PURCHASE OF 2 TONE A/C
1321	674	2350	14400.00	0.00	PURCHASE OF 2 TONE A/C
1322	675	2056	0.00	90.00	PURCHASE OF TEA AND JUICE
1323	675	1966	90.00	0.00	PURCHASE OF TEA AND JUICE
1324	676	2056	0.00	200.00	CASH PAID TP MARIMUTHU VECHILE
1325	676	1981	200.00	0.00	CASH PAID TP MARIMUTHU VECHILE
1326	677	2056	0.00	200.00	PAID FOR WATER CAN AND TEA
1327	677	1966	200.00	0.00	PAID FOR WATER CAN AND TEA
1328	678	2056	0.00	400.00	PAID FOR LUNCH IN TEXMO  LOADING LABOURS
1329	678	1966	400.00	0.00	PAID FOR LUNCH IN TEXMO  LOADING LABOURS
1330	679	2056	0.00	200.00	MARIMUTHU
1331	679	1981	200.00	0.00	MARIMUTHU
1332	680	2056	0.00	100.00	TAPE ROLL, TRIMMING
1333	680	1932	100.00	0.00	TAPE ROLL, TRIMMING
1334	690	2351	0.00	30000.00	
1335	690	1954	30000.00	0.00	
1336	691	2056	0.00	30000.00	PURCAHSE OF GRINDING BED
1337	691	2351	30000.00	0.00	PURCAHSE OF GRINDING BED
1338	688	2056	0.00	600.00	PURCHASE OF (G.BED)
1339	688	1914	600.00	0.00	PURCHASE OF (G.BED)
1340	687	2056	0.00	400.00	CAN WATER SANTHOSH 10 CAN
1341	687	1966	400.00	0.00	CAN WATER SANTHOSH 10 CAN
1342	642	1966	100.00	0.00	DINNER EXPENSE FOR WATCHMAN (SUNDAY DOUBLE DUTY)
1343	643	2056	0.00	400.00	LUNCH FOR TEXMO LOADING LABOURS
1344	643	1946	400.00	0.00	LUNCH FOR TEXMO LOADING LABOURS
1345	644	2056	0.00	250.00	NIGHT DINNER
1346	644	1966	250.00	0.00	NIGHT DINNER
1347	645	2056	0.00	200.00	MARIMUTHU
1348	645	1981	200.00	0.00	MARIMUTHU
1349	646	2056	0.00	100.00	TAPE ROLL, TRIMMING PIN
1350	646	1932	100.00	0.00	TAPE ROLL, TRIMMING PIN
1351	647	2056	0.00	600.00	EICHER OIL
1352	681	2056	0.00	250.00	DINNER (NIGHT SHIFT WORKERS)
1353	681	1966	250.00	0.00	DINNER (NIGHT SHIFT WORKERS)
1354	682	2056	0.00	600.00	VECHILES MAINTANCE
1355	682	2123	600.00	0.00	VECHILES MAINTANCE
1356	683	2056	0.00	200.00	CAN WATER
1357	683	1966	200.00	0.00	CAN WATER
1358	684	2056	0.00	100.00	PETROL
1359	684	1981	100.00	0.00	PETROL
1360	685	2056	0.00	100.00	SUGAR
1361	685	1966	100.00	0.00	SUGAR
1362	686	2056	0.00	350.00	POOJA EXPENSES
1363	686	2000	350.00	0.00	POOJA EXPENSES
1364	689	2056	0.00	390.00	PURCHASE OF LAKSHMI PAINT
1365	689	1954	390.00	0.00	PURCHASE OF LAKSHMI PAINT
1366	647	2123	600.00	0.00	EICHER OIL
1367	649	2056	0.00	100.00	PAINT
1368	649	1967	100.00	0.00	PAINT
1369	650	2056	0.00	100.00	Print Out
1370	650	2012	100.00	0.00	Print Out
1371	692	2352	0.00	1309.00	
1372	692	1954	1309.00	0.00	
1373	693	2056	0.00	1309.00	PURCHASE ACCOUNT
1374	693	2352	1309.00	0.00	PURCHASE ACCOUNT
1375	694	2056	0.00	500.00	CASH PAID TO SURESH CHIPPING
1376	694	1967	500.00	0.00	CASH PAID TO SURESH CHIPPING
1377	695	2056	0.00	80.00	MILK
1378	695	1966	80.00	0.00	MILK
1379	696	2056	0.00	400.00	SANTHOSH WATER CAN
1380	696	1966	400.00	0.00	SANTHOSH WATER CAN
1381	697	2056	0.00	100.00	2 DAYS MILK
1382	697	1966	100.00	0.00	2 DAYS MILK
1383	698	2056	0.00	400.00	NIGHT SHIFT LABOUR DINNER
1384	698	1966	400.00	0.00	NIGHT SHIFT LABOUR DINNER
1385	699	2056	0.00	100.00	MARIMUTHU LUNCH
1386	699	1966	100.00	0.00	MARIMUTHU LUNCH
1387	700	2056	0.00	300.00	SUGAR , TEA CUP ,MATCH BOX, WATER GLASS,
1388	700	1966	300.00	0.00	SUGAR , TEA CUP ,MATCH BOX, WATER GLASS,
1389	701	2056	0.00	200.00	STICKY NOTE , NOTE
1390	701	2012	200.00	0.00	STICKY NOTE , NOTE
1391	702	2056	0.00	50.00	PURCHASE OF MILK
1392	702	1966	50.00	0.00	PURCHASE OF MILK
1393	703	2056	0.00	425.00	PURCHASE OF BATTERY, WHEEL,CORBON BRUSH
1394	703	1967	425.00	0.00	PURCHASE OF BATTERY, WHEEL,CORBON BRUSH
1395	704	2056	0.00	298.00	BOC FILE, CASH VOUCHER,STIC FILE,VOUCER BOOK
1396	704	2012	298.00	0.00	BOC FILE, CASH VOUCHER,STIC FILE,VOUCER BOOK
1397	705	2056	0.00	140.00	PURCHASES OF MILK, CUP,JUICE
1398	705	1966	140.00	0.00	PURCHASES OF MILK, CUP,JUICE
1399	661	1981	200.00	0.00	PETROL
1400	706	2056	0.00	100.00	PAINT
1401	706	1967	100.00	0.00	PAINT
1402	707	1952	0.00	10078.00	
1403	707	1954	10078.00	0.00	
1404	708	2010	0.00	24898.00	
1405	708	1954	24898.00	0.00	
1406	709	2056	0.00	10078.00	PURCHASES OF 100 LTR OIL
1407	709	1952	10078.00	0.00	PURCHASES OF 100 LTR OIL
1408	710	2056	0.00	24898.00	PURCHASES OF 100 LTR PAINT
1409	710	2010	24898.00	0.00	PURCHASES OF 100 LTR PAINT
1410	711	2056	0.00	3953.00	WEEKLY SALARY
1411	711	2327	3953.00	0.00	WEEKLY SALARY
1412	712	2056	0.00	1846.00	WEEKLY SALARY
1413	712	2312	1846.00	0.00	WEEKLY SALARY
1414	713	2056	0.00	1500.00	SATHIM,USHAN,SAMIR SALARY
1415	713	2327	1500.00	0.00	SATHIM,USHAN,SAMIR SALARY
1416	714	2056	0.00	600.00	COMPRESSOR OIL PURCHASED
1417	714	1954	600.00	0.00	COMPRESSOR OIL PURCHASED
1418	715	2056	0.00	100.00	KOLA PODI, CHANI POWDER PURCHASE
1419	715	2220	100.00	0.00	KOLA PODI, CHANI POWDER PURCHASE
1420	716	2056	0.00	100.00	MILK PURCHASE(16-04-25 & 17-04-25)
1421	716	1966	100.00	0.00	MILK PURCHASE(16-04-25 & 17-04-25)
1422	717	2056	0.00	950.00	TURPEN OIL & PAINT TEMPO RENT
1423	717	1914	950.00	0.00	TURPEN OIL & PAINT TEMPO RENT
1424	718	2056	0.00	100.00	PURCHASE OF MILK & TEACUP
1425	718	1966	100.00	0.00	PURCHASE OF MILK & TEACUP
1426	719	2056	0.00	1000.00	PAID FOR DISEAL
1427	719	2053	1000.00	0.00	PAID FOR DISEAL
1428	720	2056	0.00	1320.00	CHANGE OF OIL AND SENCOR
1429	720	2123	1320.00	0.00	CHANGE OF OIL AND SENCOR
1430	721	2056	0.00	500.00	PURCHASE OF STIKY NOTE SUGAR
1431	721	1954	500.00	0.00	PURCHASE OF STIKY NOTE SUGAR
1432	722	2056	0.00	204.00	PURCHASE OF FLOWER
1433	722	2000	204.00	0.00	PURCHASE OF FLOWER
1434	723	2056	0.00	100.00	PURCHASE OF SUGAR
1435	723	1966	100.00	0.00	PURCHASE OF SUGAR
1436	724	2056	0.00	200.00	WATER
1437	724	1966	200.00	0.00	WATER
1438	725	2056	0.00	100.00	FLOWER
1439	725	2000	100.00	0.00	FLOWER
1440	726	2056	0.00	400.00	PURCHASE OF ELLEN KEY
1441	726	1954	400.00	0.00	PURCHASE OF ELLEN KEY
1442	727	2056	0.00	950.00	TUBELIGHTS
1443	727	1954	950.00	0.00	TUBELIGHTS
1444	728	2056	0.00	1000.00	TATA
1445	728	2053	1000.00	0.00	TATA
1446	729	2056	0.00	30000.00	PURCHASE OF GRINDING BED
1447	729	2351	30000.00	0.00	PURCHASE OF GRINDING BED
1448	730	2056	0.00	3000.00	BED STAND
1449	730	1954	3000.00	0.00	BED STAND
1450	731	2056	0.00	600.00	PURCHASE OF GRINDING BED AUTO CHARGE
1451	731	1914	600.00	0.00	PURCHASE OF GRINDING BED AUTO CHARGE
1452	732	2056	0.00	300.00	AUTO CHARGE
1453	732	1914	300.00	0.00	AUTO CHARGE
1454	733	2056	0.00	400.00	AUTO CHARGE FOR AC PURCHASE
1455	733	1914	400.00	0.00	AUTO CHARGE FOR AC PURCHASE
1456	734	2056	0.00	250.00	AUTO RENT
1457	734	1914	250.00	0.00	AUTO RENT
1458	735	2056	0.00	15000.00	PURCHASE OF A/C
1459	735	1954	15000.00	0.00	PURCHASE OF A/C
1460	736	2056	0.00	90.00	TEA
1461	736	1966	90.00	0.00	TEA
1462	737	2056	0.00	100.00	CASH
1463	737	1914	100.00	0.00	CASH
1464	738	2056	0.00	100.00	CASH
1465	738	1981	100.00	0.00	CASH
1466	739	2056	0.00	400.00	LUNCH
1467	739	1966	400.00	0.00	LUNCH
1468	740	2056	0.00	2700.00	PURCHASE OF GLOUSE
1469	740	1980	2700.00	0.00	PURCHASE OF GLOUSE
1470	741	2056	0.00	1309.00	PURCHASE OF GLOUSE AND GLASS
1471	741	2352	1309.00	0.00	PURCHASE OF GLOUSE AND GLASS
1472	742	2358	0.00	400.00	
1473	742	1954	400.00	0.00	
1474	743	2056	0.00	400.00	PURCHASE OF 200  LITTERS
1475	743	2358	400.00	0.00	PURCHASE OF 200  LITTERS
1476	744	2056	0.00	500.00	PURCHASE OF  SUGAR TEA CUP
1477	744	1966	500.00	0.00	PURCHASE OF  SUGAR TEA CUP
1478	745	2056	0.00	50.00	MILK
1479	745	1966	50.00	0.00	MILK
1480	746	2352	0.00	485.00	
1481	746	1954	485.00	0.00	
1482	747	2056	0.00	485.00	PURCHASE OF 4" GRINDING WHEEL
1483	747	2352	485.00	0.00	PURCHASE OF 4" GRINDING WHEEL
1484	748	2056	0.00	268.00	PURCASHE OF BOX FILE AND VOUCHER
1485	748	1982	268.00	0.00	PURCASHE OF BOX FILE AND VOUCHER
1486	749	2056	0.00	268.00	PURCHASE OF PAPER
1487	749	1982	268.00	0.00	PURCHASE OF PAPER
1488	750	2056	0.00	100.00	TEA
1489	750	1966	100.00	0.00	TEA
1490	751	2056	0.00	40.00	TEA
1491	751	1966	40.00	0.00	TEA
1492	752	2056	0.00	600.00	PURCHASE OF COMPRESOR OIL
1493	752	1932	600.00	0.00	PURCHASE OF COMPRESOR OIL
1494	753	2056	0.00	200.00	TEA
1495	753	1966	200.00	0.00	TEA
1496	755	2056	0.00	10000.00	SAMYNATHAN
1497	755	1949	10000.00	0.00	SAMYNATHAN
1498	754	2056	0.00	50000.00	SAMYNATHAN
1499	754	1949	50000.00	0.00	SAMYNATHAN
1500	756	2056	0.00	1500.00	KANAKARAJ COMPRESSOR MAINTANCE
1501	756	1932	1500.00	0.00	KANAKARAJ COMPRESSOR MAINTANCE
1502	757	2056	0.00	750.00	RANGA RAJ COMPRESSOR MAINTANCE
1503	757	1932	750.00	0.00	RANGA RAJ COMPRESSOR MAINTANCE
1504	758	2359	0.00	4800.00	
1505	758	1954	4800.00	0.00	
1506	759	2056	0.00	4800.00	PURCHASE OF BLADE-2 CONTROL-1,IMPELLER-2
1507	759	2359	4800.00	0.00	PURCHASE OF BLADE-2 CONTROL-1,IMPELLER-2
1508	760	2056	0.00	1000.00	COMPRESSOR  FROM MAKESH COMPANY
1509	760	1914	1000.00	0.00	COMPRESSOR  FROM MAKESH COMPANY
1510	761	2056	0.00	1000.00	TATa
1511	761	2053	1000.00	0.00	TATa
1512	762	2056	0.00	1320.00	CHANGE OF SENCOR
1513	762	2123	1320.00	0.00	CHANGE OF SENCOR
1514	763	2360	0.00	15000.00	
1515	763	1954	15000.00	0.00	
1516	764	2056	0.00	15000.00	PURCHASE OF NEW HOISTER
1517	764	2360	15000.00	0.00	PURCHASE OF NEW HOISTER
1518	765	2358	0.00	400.00	
1519	765	1954	400.00	0.00	
1520	766	2352	0.00	500.00	
1521	766	1954	500.00	0.00	
1522	767	2056	0.00	400.00	PURCHASE OF 10 CAN
1523	767	2358	400.00	0.00	PURCHASE OF 10 CAN
1524	768	2056	0.00	500.00	GRINDING WHEEL
1525	768	2352	500.00	0.00	GRINDING WHEEL
1526	769	2056	0.00	200.00	FLOWER
1527	769	2000	200.00	0.00	FLOWER
1528	770	1952	0.00	9558.00	
1529	770	1954	9558.00	0.00	
1530	771	2056	0.00	9558.00	PURCHASE OF TURBON OIL 100 LITTER
1531	771	1952	9558.00	0.00	PURCHASE OF TURBON OIL 100 LITTER
1532	772	2056	0.00	10078.00	PURCHASE OF TURBON OIL
1533	772	1952	10078.00	0.00	PURCHASE OF TURBON OIL
1534	773	2056	0.00	24898.00	PURCHASE OF VASANTHI RED
1535	773	2010	24898.00	0.00	PURCHASE OF VASANTHI RED
1536	774	1954	0.00	12300.00	
1537	774	1954	12300.00	0.00	
1538	775	2056	0.00	12300.00	FAN
1539	775	1954	12300.00	0.00	FAN
1540	776	2361	0.00	12300.00	
1541	776	1954	12300.00	0.00	
1542	777	2056	0.00	12300.00	PURCHASE OF INDUSTRIAL FAN
1543	777	2361	12300.00	0.00	PURCHASE OF INDUSTRIAL FAN
1544	778	2056	0.00	250.00	PURCHASE OF BOLT NUT
1545	778	1932	250.00	0.00	PURCHASE OF BOLT NUT
1546	779	2056	0.00	150.00	TEA
1547	779	1966	150.00	0.00	TEA
1548	780	2056	0.00	250.00	PURCHASE OF TEA
1549	780	1966	250.00	0.00	PURCHASE OF TEA
1550	661	2056	0.00	200.00	PETROL
1551	666	2056	0.00	350.00	AUTO CHARGE
1552	666	1914	350.00	0.00	AUTO CHARGE
1553	781	2056	52672.00	0.00	BILL NO 1
1554	781	1894	0.00	52672.00	BILL NO 1
1555	782	2056	159753.00	0.00	BILL NO 2
1556	782	1894	0.00	159753.00	BILL NO 2
1557	784	2056	0.00	40.00	TEA
1558	784	1966	40.00	0.00	TEA
1559	785	2056	0.00	360.00	TEA
1560	785	1966	360.00	0.00	TEA
1561	787	2056	0.00	6120.00	PURCHASE OF TURBON OIL 60LITTERS
1562	787	1952	6120.00	0.00	PURCHASE OF TURBON OIL 60LITTERS
1563	788	2056	0.00	400.00	TEA
1564	788	1966	400.00	0.00	TEA
1565	789	2056	0.00	200.00	TEA
1566	789	1966	200.00	0.00	TEA
1567	790	2056	0.00	3500.00	COMPRESSOR
1568	790	1932	3500.00	0.00	COMPRESSOR
1569	791	2056	0.00	200.00	TEA
1570	791	1966	200.00	0.00	TEA
1571	792	2056	0.00	200.00	Plumbing Item
1572	792	1932	200.00	0.00	Plumbing Item
1573	793	2056	0.00	200.00	TEA
1574	793	1966	200.00	0.00	TEA
1575	794	2010	0.00	14940.00	
1576	794	1954	14940.00	0.00	
1577	795	1952	0.00	1935.00	
1578	795	1954	1935.00	0.00	
1579	796	2056	0.00	14940.00	PURCHASE OF 60 LITTERS
1580	796	2010	14940.00	0.00	PURCHASE OF 60 LITTERS
1581	797	2056	0.00	1935.00	PPURCHASE OF TURBON OIL
1582	797	1952	1935.00	0.00	PPURCHASE OF TURBON OIL
1583	798	2056	0.00	950.00	HINDI GRINDING FANESH
1584	798	1914	950.00	0.00	HINDI GRINDING FANESH
1585	799	2056	0.00	750.00	PURCHASE OF GP PAINR
1586	799	1914	750.00	0.00	PURCHASE OF GP PAINR
1587	800	1952	0.00	6132.00	
1588	800	1954	6132.00	0.00	
1589	801	2056	0.00	6132.00	60 LITTERS TURBON OIL
1590	801	1952	6132.00	0.00	60 LITTERS TURBON OIL
1591	802	2056	0.00	200.00	FLOWER
1592	802	2000	200.00	0.00	FLOWER
1593	803	2056	0.00	200.00	TEA
1594	803	1966	200.00	0.00	TEA
1595	804	2056	0.00	1000.00	TN38DL1948
1596	804	2053	1000.00	0.00	TN38DL1948
1597	805	2056	0.00	10000.00	COMPRESSOR
1598	805	1932	10000.00	0.00	COMPRESSOR
1599	806	2056	0.00	80.00	WELDDING OF BED PLATE
1600	806	1932	80.00	0.00	WELDDING OF BED PLATE
1601	807	2010	0.00	24898.00	
1602	807	1954	24898.00	0.00	
1603	808	2358	0.00	2000.00	
1604	808	1954	2000.00	0.00	
1605	809	1952	0.00	5952.00	
1606	809	1954	5952.00	0.00	
1607	810	2056	0.00	24898.00	PURCHASE OF 100 LTS OF GP PAING
1608	810	2010	24898.00	0.00	PURCHASE OF 100 LTS OF GP PAING
1609	811	2056	0.00	5952.00	PURCHASE OF 60 LITTERS TURBO OIL
1610	811	1952	5952.00	0.00	PURCHASE OF 60 LITTERS TURBO OIL
1611	812	2056	0.00	150.00	TEA
1612	812	1966	150.00	0.00	TEA
1613	813	2056	0.00	1160.00	Purchase Of Swith And Cut Wheel
1614	813	1932	1160.00	0.00	Purchase Of Swith And Cut Wheel
1615	814	2056	0.00	200.00	Flower
1616	814	2000	200.00	0.00	Flower
1617	815	2056	0.00	510.00	Purchase
1618	815	2000	510.00	0.00	Purchase
1619	816	2056	0.00	250000.00	Deposite Payment
1620	816	1894	250000.00	0.00	Deposite Payment
1621	817	2056	0.00	10000.00	COMPRESSOR AIRWA
1622	817	1932	10000.00	0.00	COMPRESSOR AIRWA
1623	818	2166	0.00	120.00	
1624	818	1954	120.00	0.00	
1625	819	2056	0.00	120.00	CASH
1626	819	2166	120.00	0.00	CASH
1627	820	2056	0.00	200.00	CASH
1628	820	1966	200.00	0.00	CASH
1629	821	2056	0.00	300.00	TEA AND BISCU
1630	821	1966	300.00	0.00	TEA AND BISCU
1631	822	2056	0.00	200.00	LEMON
1632	822	2000	200.00	0.00	LEMON
1633	823	2056	0.00	200.00	TEA
1634	823	1966	200.00	0.00	TEA
1635	824	2056	0.00	150.00	TEA
1636	824	1966	150.00	0.00	TEA
1637	825	2056	0.00	1010.00	TURBONOIL 10 LITTER
1638	825	1954	1010.00	0.00	TURBONOIL 10 LITTER
1639	826	2056	0.00	90.00	TEA
1640	826	1966	90.00	0.00	TEA
1641	827	2056	0.00	50.00	TEA
1642	827	1966	50.00	0.00	TEA
1643	828	2056	0.00	100.00	TEA
1644	828	1966	100.00	0.00	TEA
1645	829	2056	0.00	420.00	LUNCH
1646	829	1966	420.00	0.00	LUNCH
1647	830	2056	0.00	60.00	TEA
1648	830	1966	60.00	0.00	TEA
1649	831	2056	0.00	100.00	Tea
1650	831	1966	100.00	0.00	Tea
1651	832	2026	0.00	25000.00	
1652	832	1954	25000.00	0.00	
1653	833	2056	0.00	25000.00	COMPRESSOR 7.5 HP
1654	833	2026	25000.00	0.00	COMPRESSOR 7.5 HP
1655	834	2056	0.00	3000.00	COMPRESSOR TRANSFER  DINDUGAL
1656	834	1914	3000.00	0.00	COMPRESSOR TRANSFER  DINDUGAL
1657	835	2056	0.00	1500.00	CASH PAID
1658	835	2358	1500.00	0.00	CASH PAID
1659	837	2056	0.00	24898.00	PURCHASE OF 100 LTS
1660	837	2010	24898.00	0.00	PURCHASE OF 100 LTS
1661	836	2010	0.00	24898.00	
1662	836	1954	24898.00	0.00	
1663	838	1952	0.00	6120.00	
1664	838	1954	6120.00	0.00	
1665	786	1952	0.00	6120.00	
1666	786	1954	6120.00	0.00	
1667	839	2056	0.00	14000.00	
1668	839	2350	14000.00	0.00	
1669	662	2056	0.00	200.00	TEA
1670	662	1966	200.00	0.00	TEA
1671	663	2056	0.00	200.00	MARIMUTHU
1672	663	1981	200.00	0.00	MARIMUTHU
1673	664	2056	0.00	160.00	TEA
1674	664	1966	160.00	0.00	TEA
1675	665	2056	0.00	300.00	TEA
1676	665	1966	300.00	0.00	TEA
1677	783	2056	0.00	300.00	TEA
1678	783	1966	300.00	0.00	TEA
1679	840	2358	0.00	400.00	
1680	840	1954	400.00	0.00	
1681	841	1952	0.00	5703.00	
1682	841	1954	5703.00	0.00	
1683	842	2010	0.00	14988.00	
1684	842	1954	14988.00	0.00	
1685	843	2056	0.00	5703.00	PURCASE OF 60 LITTERS
1686	843	1952	5703.00	0.00	PURCASE OF 60 LITTERS
1687	844	2056	0.00	14988.00	PURCHASE OF  60 LITTERS
1688	844	2010	14988.00	0.00	PURCHASE OF  60 LITTERS
1689	845	2056	0.00	1310.00	COMPRESSOR SPARE PURCASE GPAY
1690	845	1932	1310.00	0.00	COMPRESSOR SPARE PURCASE GPAY
1691	846	2056	0.00	300.00	TEA
1692	846	1966	300.00	0.00	TEA
1693	847	2056	0.00	2000.00	RANGARAJ
1694	847	1915	2000.00	0.00	RANGARAJ
1695	848	2352	0.00	1065.00	
1696	848	1954	1065.00	0.00	
1697	849	2056	0.00	1065.00	CAS
1698	849	2352	1065.00	0.00	CAS
1699	850	2056	0.00	265.00	TEA SUGAR AND CUP
1700	850	1966	265.00	0.00	TEA SUGAR AND CUP
1701	851	2056	0.00	50.00	PURCHASE OF WATER
1702	851	1966	50.00	0.00	PURCHASE OF WATER
1703	852	2056	0.00	460.00	CASH
1704	852	2000	460.00	0.00	CASH
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
648	PAY_9_17	Payment	2025-04-03	2056	260.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
640	PAY_1_1	Payment	2025-04-01	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
641	PAY_2_2	Payment	2025-04-01	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
651	PAY_12_27	Payment	2025-04-05	2056	1925.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
652	PAY_13_28	Payment	2025-04-05	2056	2275.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
653	PAY_14_29	Payment	2025-04-05	2056	1560.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
654	PAY_15_30	Payment	2025-04-05	2056	17496.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
655	PAY_16_34	Payment	2025-04-05	2056	356.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
656	PAY_17_35	Payment	2025-04-05	2056	350.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
657	PAY_18_47	Payment	2025-04-09	2018	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
659	PAY_20_49	Payment	2025-04-09	2018	15000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
658	PAY_19_48	Payment	2025-04-09	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
660	PAY_21_61	Payment	2025-04-09	2056	90.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
669	PUR_1_76	Purchase	2025-04-11	1980	2700.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
670	PAY_24_77	Payment	2025-04-10	2056	2700.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
668	PAY_23_75	Payment	2025-04-10	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
667	PAY_22_74	Payment	2025-04-10	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
671	PAY_25_78	Payment	2025-04-09	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
672	PAY_26_79	Payment	2025-04-09	2056	900.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
673	PUR_2_80	Purchase	2025-04-09	2350	14000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
674	PAY_27_81	Payment	2025-04-09	2056	14400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
675	PAY_28_82	Payment	2025-04-09	2056	90.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
676	PAY_29_83	Payment	2025-04-01	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
677	PAY_30_84	Payment	2025-04-01	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
678	PAY_31_85	Payment	2025-04-01	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
679	PAY_32_86	Payment	2025-04-02	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
680	PAY_33_87	Payment	2025-04-02	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
690	PUR_3_103	Purchase	2025-04-07	2351	30000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
691	PAY_43_104	Payment	2025-04-07	2056	30000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
688	PAY_41_101	Payment	2025-04-07	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
687	PAY_40_100	Payment	2025-04-07	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
642	PAY_3_3	Payment	2025-04-01	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
643	PAY_4_4	Payment	2025-04-01	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
644	PAY_5_5	Payment	2025-04-02	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
645	PAY_6_6	Payment	2025-04-02	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
646	PAY_7_10	Payment	2025-04-02	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
681	PAY_34_88	Payment	2025-04-11	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
682	PAY_35_89	Payment	2025-04-11	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
683	PAY_36_91	Payment	2025-04-04	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
684	PAY_37_92	Payment	2025-04-04	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
685	PAY_38_93	Payment	2025-04-04	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
686	PAY_39_94	Payment	2025-04-04	2056	350.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
689	PAY_42_102	Payment	2025-04-07	2056	390.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
647	PAY_8_11	Payment	2025-04-02	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
649	PAY_10_18	Payment	2025-04-03	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
650	PAY_11_23	Payment	2025-04-03	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
692	PUR_4_105	Purchase	2025-04-11	2352	1309.00	SGST 99.81 CGST 99.81		\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
693	PAY_44_106	Payment	2025-04-11	2056	1309.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
694	PAY_45_108	Payment	2025-04-11	2056	500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
695	PAY_46_112	Payment	2025-04-11	2056	80.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
696	PAY_47_134	Payment	2025-04-12	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
697	PAY_48_135	Payment	2025-04-12	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
698	PAY_49_136	Payment	2025-04-12	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
699	PAY_50_141	Payment	2025-04-12	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
700	PAY_51_142	Payment	2025-04-12	2056	300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
701	PAY_52_143	Payment	2025-04-12	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
702	PAY_53_147	Payment	2025-04-15	2056	50.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
703	PAY_54_148	Payment	2025-04-15	2056	425.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
704	PAY_55_149	Payment	2025-04-15	2056	298.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
705	PAY_56_150	Payment	2025-04-15	2056	140.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
706	PAY_57_163	Payment	2025-04-15	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
707	PUR_5_164	Purchase	2025-04-16	1952	10078.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
708	PUR_6_165	Purchase	2025-04-16	2010	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
709	PAY_58_166	Payment	2025-04-16	2056	10078.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
710	PAY_59_167	Payment	2025-04-16	2056	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
711	PAY_60_168	Payment	2025-04-12	2056	3953.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
712	PAY_61_169	Payment	2025-04-12	2056	1846.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
713	PAY_62_170	Payment	2025-04-12	2056	1500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
714	PAY_63_181	Payment	2025-04-16	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
715	PAY_64_182	Payment	2025-04-16	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
716	PAY_65_183	Payment	2025-04-16	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
717	PAY_66_184	Payment	2025-04-16	2056	950.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
718	PAY_67_207	Payment	2025-04-16	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
719	PAY_68_242	Payment	2025-04-19	2056	1000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
720	PAY_69_243	Payment	2025-04-19	2056	1320.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
721	PAY_70_271	Payment	2025-04-12	2056	500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
722	PAY_1_294	Payment	2025-04-01	2056	204.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
723	PAY_2_295	Payment	2025-04-01	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
724	PAY_3_296	Payment	2025-04-01	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
725	PAY_4_297	Payment	2025-04-02	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
726	PAY_5_298	Payment	2025-04-05	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
727	PAY_6_299	Payment	2025-04-05	2056	950.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
728	PAY_7_300	Payment	2025-04-05	2056	1000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
729	PAY_8_301	Payment	2025-04-06	2056	30000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
730	PAY_9_302	Payment	2025-04-07	2056	3000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
731	PAY_10_303	Payment	2025-04-07	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
732	PAY_11_304	Payment	2025-04-08	2056	300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
733	PAY_12_305	Payment	2025-04-08	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
734	PAY_13_306	Payment	2025-04-09	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
735	PAY_14_307	Payment	2025-04-09	2056	15000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
736	PAY_15_308	Payment	2025-04-09	2056	90.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
737	PAY_16_309	Payment	2025-04-10	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
738	PAY_17_310	Payment	2025-04-10	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
739	PAY_18_311	Payment	2025-04-10	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
740	PAY_19_312	Payment	2025-04-10	2056	2700.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
741	PAY_20_313	Payment	2025-04-11	2056	1309.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
742	PUR_7_314	Purchase	2025-04-12	2358	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
743	PAY_21_315	Payment	2025-04-12	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
744	PAY_22_316	Payment	2025-04-12	2056	500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
745	PAY_23_317	Payment	2025-04-15	2056	50.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
746	PUR_8_318	Purchase	2025-04-12	2352	485.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
747	PAY_24_319	Payment	2025-04-15	2056	485.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
748	PAY_25_320	Payment	2025-04-15	2056	268.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
749	PAY_26_321	Payment	2025-04-15	2056	268.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
750	PAY_27_322	Payment	2025-04-15	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
751	PAY_28_323	Payment	2025-04-15	2056	40.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
752	PAY_29_324	Payment	2025-04-16	2056	600.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
753	PAY_30_325	Payment	2025-04-16	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
755	PAY_32_327	Payment	2025-04-16	2056	10000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
754	PAY_31_326	Payment	2025-04-16	2056	50000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
756	PAY_33_328	Payment	2025-04-18	2056	1500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
757	PAY_34_329	Payment	2025-04-18	2056	750.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
758	PUR_9_330	Purchase	2025-04-18	2359	4800.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
759	PAY_35_331	Payment	2025-04-18	2056	4800.00	BLADE-400 RS, CONTROL CAGE-600, IMPELLER- 500		\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
760	PAY_36_332	Payment	2025-04-18	2056	1000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
761	PAY_37_333	Payment	2025-04-19	2056	1000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
762	PAY_38_334	Payment	2025-04-19	2056	1320.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
763	PUR_10_335	Purchase	2025-04-19	2360	15000.00	PURCHASE OF NEW HOISTER		\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
764	PAY_39_336	Payment	2025-04-21	2056	15000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
765	PUR_11_337	Purchase	2025-04-22	2358	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
766	PUR_12_338	Purchase	2025-04-22	2352	500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
767	PAY_40_339	Payment	2025-04-22	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
768	PAY_41_340	Payment	2025-04-22	2056	500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
769	PAY_42_341	Payment	2025-04-23	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
770	PUR_13_342	Purchase	2025-04-23	1952	9558.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
771	PAY_43_343	Payment	2025-04-23	2056	9558.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
772	PAY_44_344	Payment	2025-04-16	2056	10078.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
773	PAY_45_345	Payment	2025-04-16	2056	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
774	PUR_14_346	Purchase	2025-04-23	1954	12300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
775	PAY_46_347	Payment	2025-04-23	2056	12300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
776	PUR_14_348	Purchase	2025-04-23	2361	12300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
777	PAY_46_349	Payment	2025-04-23	2056	12300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
778	PAY_47_350	Payment	2025-04-25	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
779	PAY_48_351	Payment	2025-04-25	2056	150.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
780	PAY_49_352	Payment	2025-04-25	2056	250.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
661	PAY_50_353	Payment	2025-04-25	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
666	PAY_55_382	Payment	2025-04-05	2056	350.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
781	REC_1_602	Receipt	2025-04-16	2056	52672.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
782	REC_2_603	Receipt	2025-04-23	2056	159753.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
784	PAY_56_749	Payment	2025-04-29	2056	40.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
785	PAY_57_750	Payment	2025-04-30	2056	360.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
787	PAY_58_752	Payment	2025-05-02	2056	6120.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
788	PAY_59_753	Payment	2025-05-02	2056	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
789	PAY_60_754	Payment	2025-05-02	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
790	PAY_61_755	Payment	2025-05-02	2056	3500.00	RANGARAJ		\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
791	PAY_62_756	Payment	2025-05-03	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
792	PAY_63_757	Payment	2025-05-03	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
793	PAY_64_758	Payment	2025-05-05	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
794	PUR_16_759	Purchase	2025-05-05	2010	14940.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
795	PUR_17_760	Purchase	2025-05-05	1952	1935.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
796	PAY_65_761	Payment	2025-05-05	2056	14940.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
797	PAY_66_762	Payment	2025-05-05	2056	1935.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
798	PAY_67_763	Payment	2025-05-05	2056	950.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
799	PAY_68_764	Payment	2025-05-05	2056	750.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
800	PUR_18_765	Purchase	2025-05-07	1952	6132.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
801	PAY_69_766	Payment	2025-05-06	2056	6132.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
802	PAY_70_767	Payment	2025-05-07	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
803	PAY_71_768	Payment	2025-05-07	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
804	PAY_72_769	Payment	2025-05-07	2056	1000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
805	PAY_73_770	Payment	2025-05-07	2056	10000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
806	PAY_74_771	Payment	2025-05-07	2056	80.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
807	PUR_19_774	Purchase	2025-05-08	2010	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
808	PUR_20_775	Purchase	2025-05-08	2358	2000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
809	PUR_21_776	Purchase	2025-05-08	1952	5952.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
810	PAY_75_777	Payment	2025-05-08	2056	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
811	PAY_76_778	Payment	2025-05-08	2056	5952.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
812	PAY_77_779	Payment	2025-05-08	2056	150.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
813	PAY_78_797	Payment	2025-05-09	2056	1160.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
814	PAY_79_798	Payment	2025-05-09	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
815	PAY_80_799	Payment	2025-05-09	2056	510.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
816	PAY_81_800	Payment	2025-05-09	2056	250000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
817	PAY_82_801	Payment	2025-05-09	2056	10000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
818	PUR_22_816	Purchase	2025-05-09	2166	120.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
819	PAY_83_817	Payment	2025-05-09	2056	120.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
820	PAY_84_818	Payment	2025-05-09	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
821	PAY_85_823	Payment	2025-05-09	2056	300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
822	PAY_86_824	Payment	2025-05-09	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
823	PAY_87_865	Payment	2025-05-10	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
824	PAY_88_879	Payment	2025-05-09	2056	150.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
825	PAY_89_880	Payment	2025-05-10	2056	1010.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
826	PAY_90_883	Payment	2025-05-14	2056	90.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
827	PAY_91_888	Payment	2025-05-12	2056	50.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
828	PAY_92_892	Payment	2025-05-13	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
829	PAY_93_893	Payment	2025-05-13	2056	420.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
830	PAY_93_901	Payment	2025-05-13	2056	60.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
831	PAY_94_902	Payment	2025-05-13	2056	100.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
832	PUR_23_909	Purchase	2025-05-13	2026	25000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
833	PAY_95_910	Payment	2025-05-13	2056	25000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
834	PAY_96_911	Payment	2025-05-13	2056	3000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
835	PAY_97_922	Payment	2025-05-08	2056	1500.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
837	PAY_98_924	Payment	2025-04-24	2056	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
836	PUR_24_923	Purchase	2025-04-24	2010	24898.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
838	PUR_25_925	Purchase	2025-05-02	1952	6120.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
786	PUR_15_751	Purchase	2025-04-30	1952	6120.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
839	PAY_99_926	Payment	2025-05-01	2056	14000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
662	PAY_51_354	Payment	2025-04-27	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
663	PAY_52_355	Payment	2025-04-27	2056	200.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
664	PAY_53_356	Payment	2025-04-28	2056	160.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
665	PAY_54_357	Payment	2025-04-28	2056	300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
783	PAY_55_748	Payment	2025-04-29	2056	300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
840	PUR_26_935	Purchase	2025-05-12	2358	400.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
841	PUR_27_941	Purchase	2025-05-15	1952	5703.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
842	PUR_28_942	Purchase	2025-05-15	2010	14988.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
843	PAY_100_943	Payment	2025-05-15	2056	5703.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
844	PAY_101_944	Payment	2025-05-15	2056	14988.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
845	PAY_102_945	Payment	2025-05-15	2056	1310.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
846	PAY_103_946	Payment	2025-05-15	2056	300.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
847	PAY_104_947	Payment	2025-05-15	2056	2000.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
848	PUR_29_957	Purchase	2025-05-15	2352	1065.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
849	PAY_105_958	Payment	2025-05-15	2056	1065.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
850	PAY_106_959	Payment	2025-05-16	2056	265.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
851	PAY_107_962	Payment	2025-05-16	2056	50.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
852	PAY_108_973	Payment	2025-05-16	2056	460.00			\N	2026-08-03 15:19:03.071997	2026-08-03 15:19:03.071997
\.


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
1027	ADV_1_2	2026-04-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1028	ADV_15_35	2026-04-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1029	ADV_15_39	2026-04-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1030	ADV_16_40	2026-04-02	2373	Payment	Contractor	0.00	1000 Rs For Train And 1500 For Food	\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1031	ADV_17_42	2026-04-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1032	ADV_17_43	2026-04-02	2373	Payment	Contractor	0.00	GPAY TO MARKET TO JITHENDAR NUMBER	\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1033	ADV_18_44	2026-04-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1034	ADV_19_45	2026-04-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1035	ADV_20_51	2026-04-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1036	ADV_21_52	2026-04-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1037	ADV_22_68	2026-04-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1038	ADV_23_69	2026-04-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1039	ADV_194_744	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1040	ADV_195_754	2026-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1041	ADV_196_755	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1042	ADV_198_757	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1043	ADV_199_758	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1044	ADV_200_759	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1045	ADV_201_760	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1046	ADV_202_761	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1047	ADV_203_762	2026-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1048	ADV_204_763	2026-05-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1049	ADV_205_776	2026-05-07	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1050	ADV_368_1430	2026-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1051	ADV_369_1431	2026-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1052	ADV_370_1432	2026-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1053	ADV_371_1433	2026-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1054	ADV_372_1434	2026-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1055	ADV_373_1435	2026-06-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1056	ADV_374_1436	2026-06-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1057	ADV_375_1437	2026-06-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1058	ADV_376_1438	2026-06-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1059	ADV_377_1439	2026-06-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1060	ADV_378_1440	2026-06-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1061	ADV_379_1441	2026-06-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1062	ADV_380_1442	2026-06-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1063	ADV_381_1443	2026-06-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1064	ADV_382_1444	2026-06-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1065	ADV_383_1445	2026-06-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1066	ADV_384_1446	2026-06-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1067	ADV_385_1447	2026-06-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1068	ADV_386_1448	2026-06-04	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1069	ADV_387_1449	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1070	ADV_388_1450	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1071	ADV_389_1451	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1072	ADV_390_1452	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1073	ADV_391_1453	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1074	ADV_392_1454	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1075	ADV_393_1455	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1076	ADV_394_1456	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1077	ADV_395_1457	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1078	ADV_396_1458	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1079	ADV_397_1459	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1080	ADV_398_1460	2026-06-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1081	ADV_25_78	2026-04-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1082	ADV_27_86	2026-04-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1083	ADV_28_87	2026-04-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1084	ADV_29_90	2026-04-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1085	ADV_50_162	2026-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1086	ADV_51_163	2026-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1087	ADV_52_165	2026-04-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1088	ADV_53_167	2026-04-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1089	ADV_54_168	2026-04-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1090	ADV_56_171	2026-04-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1091	ADV_59_174	2026-04-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1092	ADV_60_175	2026-04-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1093	ADV_61_179	2026-04-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1094	ADV_70_221	2026-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1095	ADV_74_231	2026-04-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1096	ADV_82_239	2026-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1097	ADV_83_240	2026-04-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1098	ADV_94_254	2026-04-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1099	ADV_96_263	2026-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1100	ADV_98_270	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1101	ADV_99_271	2026-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1102	ADV_104_313	2026-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1103	ADV_107_317	2026-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1104	ADV_110_321	2026-04-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1105	ADV_111_322	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1106	ADV_115_326	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1107	ADV_116_327	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1108	ADV_117_328	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1109	ADV_118_329	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1110	ADV_120_331	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1111	ADV_121_332	2026-04-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1112	ADV_122_333	2026-04-19	2373	Payment	Contractor	0.00	PAID TO VINOTH SALARY ADVANCE	\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1113	ADV_123_334	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1114	ADV_124_335	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1115	ADV_125_336	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1116	ADV_126_337	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1117	ADV_127_338	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1118	ADV_128_339	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1119	ADV_129_340	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1120	ADV_130_341	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1121	ADV_131_342	2026-04-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1122	ADV_1_357	2026-04-22	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1123	ADV_1_390	2026-04-24	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1124	ADV_1_412	2026-04-24	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1125	ADV_2_413	2026-04-24	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1126	ADV_3_414	2026-04-24	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1127	ADV_4_415	2026-04-24	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1128	ADV_134_416	2026-04-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1129	ADV_135_417	2026-04-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1130	ADV_7_441	2026-04-25	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1131	ADV_139_454	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1132	ADV_8_458	2026-04-25	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1133	ADV_9_465	2026-04-04	2373	Receipt	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1134	ADV_140_470	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1135	ADV_141_495	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1136	ADV_142_496	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1137	ADV_143_497	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1138	ADV_144_498	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1139	ADV_145_499	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1140	ADV_146_500	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1141	ADV_147_504	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1142	ADV_148_505	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1143	ADV_150_527	2026-04-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1144	ADV_151_555	2026-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1145	ADV_152_584	2026-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1146	ADV_153_585	2026-04-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1147	ADV_159_591	2026-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1148	ADV_167_601	2026-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1149	ADV_176_638	2026-04-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1150	ADV_180_663	2026-04-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1151	ADV_182_697	2026-05-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1152	ADV_193_708	2026-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1153	ADV_206_802	2026-05-05	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1154	ADV_207_803	2026-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1155	ADV_208_804	2026-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1156	ADV_209_805	2026-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1157	ADV_210_806	2026-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1158	ADV_211_807	2026-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1159	ADV_212_808	2026-05-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1160	ADV_214_858	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1161	ADV_215_859	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1162	ADV_216_860	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1163	ADV_217_861	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1164	ADV_218_862	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1165	ADV_219_863	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1166	ADV_220_864	2026-05-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1167	ADV_221_865	2026-05-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1168	ADV_222_866	2026-05-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1169	ADV_223_917	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1170	ADV_224_918	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1171	ADV_225_919	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1172	ADV_226_920	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1173	ADV_227_921	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1174	ADV_228_922	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1175	ADV_229_923	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1176	ADV_230_924	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1177	ADV_231_925	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1178	ADV_232_942	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1179	ADV_233_943	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1180	ADV_234_944	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1181	ADV_235_945	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1182	ADV_236_946	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1183	ADV_237_947	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1184	ADV_238_948	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1185	ADV_239_949	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1186	ADV_240_950	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1187	ADV_242_987	2026-05-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1188	ADV_243_1040	2026-05-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1189	ADV_244_1041	2026-05-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1190	ADV_246_1054	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1191	ADV_247_1055	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1192	ADV_248_1056	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1193	ADV_249_1057	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1194	ADV_250_1058	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1195	ADV_251_1059	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1196	ADV_252_1060	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1197	ADV_253_1061	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1198	ADV_254_1062	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1199	ADV_255_1063	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1200	ADV_256_1064	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1201	ADV_257_1065	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1202	ADV_258_1066	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1203	ADV_259_1067	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1204	ADV_260_1068	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1205	ADV_261_1069	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1206	ADV_262_1070	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1207	ADV_263_1071	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1208	ADV_264_1072	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1209	ADV_265_1073	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1210	ADV_266_1074	2026-05-13	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1211	ADV_267_1075	2026-05-14	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1212	ADV_268_1076	2026-05-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1213	ADV_269_1077	2026-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1214	ADV_270_1078	2026-05-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1215	ADV_271_1079	2026-05-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1216	ADV_272_1080	2026-05-20	2373	Payment	Contractor	0.00	KAVITHAA  DROP  100	\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1217	ADV_273_1081	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1218	ADV_274_1083	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1219	ADV_275_1084	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1220	ADV_276_1088	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1221	ADV_277_1089	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1222	ADV_278_1090	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1223	ADV_279_1091	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1224	ADV_280_1092	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1225	ADV_281_1093	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1226	ADV_282_1094	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1227	ADV_283_1095	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1228	ADV_284_1096	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1229	ADV_285_1097	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1230	ADV_286_1134	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1231	ADV_287_1135	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1232	ADV_288_1136	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1233	ADV_289_1137	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1234	ADV_290_1138	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1235	ADV_291_1139	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1236	ADV_292_1140	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1237	ADV_293_1141	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1238	ADV_294_1142	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1239	ADV_295_1143	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1240	ADV_296_1144	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1241	ADV_297_1145	2026-05-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1242	ADV_298_1146	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1243	ADV_299_1163	2026-05-22	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1244	ADV_300_1171	2026-05-21	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1245	ADV_301_1209	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1246	ADV_302_1210	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1247	ADV_303_1211	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1248	ADV_304_1212	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1249	ADV_305_1213	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1250	ADV_306_1214	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1251	ADV_307_1215	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1252	ADV_308_1216	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1253	ADV_309_1217	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1254	ADV_310_1218	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1255	ADV_311_1219	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1256	ADV_312_1220	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1257	ADV_313_1221	2026-05-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1258	ADV_314_1222	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1259	ADV_315_1223	2026-05-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1260	ADV_316_1224	2026-05-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1261	ADV_317_1225	2026-05-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1262	ADV_318_1226	2026-05-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1263	ADV_319_1227	2026-05-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1264	ADV_320_1228	2026-05-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1265	ADV_321_1229	2026-05-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1266	ADV_322_1230	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1267	ADV_323_1231	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1268	ADV_324_1232	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1269	ADV_325_1233	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1270	ADV_326_1234	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1271	ADV_327_1235	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1272	ADV_328_1236	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1273	ADV_329_1237	2026-05-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1274	ADV_330_1238	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1275	ADV_331_1262	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1276	ADV_332_1263	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1277	ADV_333_1264	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1278	ADV_335_1266	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1279	ADV_336_1267	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1280	ADV_337_1268	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1281	ADV_338_1269	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1282	ADV_339_1270	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1283	ADV_340_1273	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1284	ADV_341_1274	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1285	ADV_342_1275	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1286	ADV_343_1276	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1287	ADV_344_1277	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1288	ADV_345_1278	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1289	ADV_346_1279	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1290	ADV_347_1280	2026-05-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1291	ADV_348_1294	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1292	ADV_349_1295	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1293	ADV_350_1296	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1294	ADV_351_1297	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1295	ADV_352_1298	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1296	ADV_353_1299	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1297	ADV_354_1300	2026-05-28	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1298	ADV_355_1306	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1299	ADV_356_1307	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1300	ADV_357_1308	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1301	ADV_358_1309	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1302	ADV_359_1310	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1303	ADV_360_1324	2026-05-27	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1304	ADV_361_1327	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1305	ADV_362_1331	2026-05-29	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1306	ADV_366_1405	2026-05-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1307	ADV_367_1406	2026-05-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1308	ADV_399_1473	2026-06-30	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1309	ADV_400_1477	2026-06-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1310	ADV_401_1482	2026-06-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1311	ADV_402_1580	2026-06-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1312	ADV_403_1581	2026-06-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1313	ADV_404_1582	2026-06-06	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1314	ADV_405_1583	2026-06-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1315	ADV_406_1584	2026-06-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1316	ADV_407_1585	2026-06-08	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1317	ADV_408_1586	2026-06-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1318	ADV_409_1587	2026-06-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1319	ADV_410_1588	2026-06-09	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1320	ADV_411_1589	2026-06-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1321	ADV_412_1590	2026-06-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1322	ADV_413_1591	2026-06-10	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1323	ADV_414_1592	2026-06-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1324	ADV_415_1593	2026-06-11	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1325	ADV_416_1594	2026-06-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1326	ADV_417_1595	2026-06-12	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1327	ADV_418_1709	2026-06-15	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1328	ADV_419_1710	2026-06-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1329	ADV_420_1711	2026-06-16	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1330	ADV_421_1712	2026-06-17	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1331	ADV_422_1713	2026-06-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1332	ADV_423_1714	2026-06-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1333	ADV_424_1715	2026-06-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1334	ADV_425_1716	2026-06-18	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1335	ADV_426_1733	2026-06-20	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1336	ADV_427_1779	2026-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1337	ADV_428_1780	2026-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1338	ADV_429_1781	2026-06-19	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1339	ADV_430_1841	2026-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1340	ADV_431_1842	2026-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1341	ADV_432_1843	2026-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1342	ADV_433_1844	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1343	ADV_434_1845	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1344	ADV_435_1846	2026-06-23	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1345	ADV_436_1847	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1346	ADV_437_1848	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1347	ADV_438_1849	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1348	ADV_439_1850	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1349	ADV_440_1851	2026-06-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1350	ADV_441_1852	2026-06-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1351	ADV_442_1853	2026-06-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1352	ADV_443_1854	2026-06-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1353	ADV_444_1855	2026-06-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1354	ADV_445_1856	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1355	ADV_446_1857	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1356	ADV_447_1858	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1357	ADV_448_1859	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1358	ADV_449_1873	2026-06-24	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1359	ADV_450_1874	2026-06-25	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1360	ADV_452_2004	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1361	ADV_453_2005	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1362	ADV_454_2006	2026-06-26	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1363	ADV_455_2007	2026-07-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1364	ADV_456_2008	2026-07-01	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1365	ADV_457_2009	2026-07-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1366	ADV_458_2010	2026-07-02	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1367	ADV_459_2011	2026-07-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
1368	ADV_460_2012	2026-07-03	2373	Payment	Contractor	0.00		\N	2026-08-03 15:19:13.553896	2026-08-03 15:19:13.553896
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.audit_logs (id, user_id, username, action, module, record_id, old_values, new_values, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: biometric_entries; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.biometric_entries (id, ledger_id, entry_date, punch_in, punch_out, hours_worked, status, device_log_id, created_at) FROM stdin;
\.


--
-- Data for Name: eb_readings; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.eb_readings (id, reading_date, meter_no, previous_reading, current_reading, units_consumed, rate_per_unit, amount, narration, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: job_work_entries; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.job_work_entries (id, entry_no, entry_date, ledger_id, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: labour_bills; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.labour_bills (id, bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, is_paid, payment_date, created_by, created_at, updated_at, items, outward_ids, dispatch_through) FROM stdin;
400	LB_2_40_120_0	2026-04-08	1894	\N	3142	18	1001.950	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
401	LB_2_40_120_1	2026-04-08	1894	\N	3142	19	1001.950	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
402	LB_2_40_120_2	2026-04-08	1894	\N	3142	20	1001.950	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
403	LB_2_169_120_3	2026-04-08	1894	\N	3270	18	4.902	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
404	LB_2_169_120_4	2026-04-08	1894	\N	3270	18	950.988	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
405	LB_2_169_120_5	2026-04-08	1894	\N	3270	19	950.988	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
406	LB_2_169_120_6	2026-04-08	1894	\N	3270	20	950.988	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
407	LB_2_573_120_7	2026-04-08	1894	\N	3739	18	216.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
408	LB_2_573_120_8	2026-04-08	1894	\N	3739	19	216.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
409	LB_2_573_120_9	2026-04-08	1894	\N	3739	20	216.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
410	LB_2_952_120_10	2026-04-08	1894	\N	4053	18	535.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
411	LB_2_952_120_11	2026-04-08	1894	\N	4053	19	535.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
412	LB_2_952_120_12	2026-04-08	1894	\N	4053	20	535.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
413	LB_2_5_120_13	2026-04-08	1894	\N	3107	18	5.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
414	LB_2_5_120_14	2026-04-08	1894	\N	3107	18	3084.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
415	LB_2_5_120_15	2026-04-08	1894	\N	3107	19	3084.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
416	LB_2_5_120_16	2026-04-08	1894	\N	3107	20	3084.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
417	LB_2_6_120_17	2026-04-08	1894	\N	3108	18	16.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
418	LB_2_6_120_18	2026-04-08	1894	\N	3108	18	405.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
419	LB_2_6_120_19	2026-04-08	1894	\N	3108	19	405.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
420	LB_2_6_120_20	2026-04-08	1894	\N	3108	20	405.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
421	LB_2_13_120_21	2026-04-08	1894	\N	3115	18	73.612	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
422	LB_2_13_120_22	2026-04-08	1894	\N	3115	19	73.612	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
423	LB_2_13_120_23	2026-04-08	1894	\N	3115	20	73.612	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
424	LB_2_40_120_24	2026-04-08	1894	\N	3142	18	11.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
425	LB_2_191_120_25	2026-04-08	1894	\N	3292	18	9.250	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
426	LB_2_191_120_26	2026-04-08	1894	\N	3292	18	229.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
427	LB_2_191_120_27	2026-04-08	1894	\N	3292	19	229.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
428	LB_2_195_120_28	2026-04-08	1894	\N	3296	18	325.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
429	LB_2_195_120_29	2026-04-08	1894	\N	3296	19	325.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
430	LB_2_212_120_30	2026-04-08	1894	\N	3313	18	26.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
431	LB_2_212_120_31	2026-04-08	1894	\N	3313	18	414.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
432	LB_2_212_120_32	2026-04-08	1894	\N	3313	19	414.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
433	LB_2_212_120_33	2026-04-08	1894	\N	3313	20	414.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
434	LB_2_307_120_34	2026-04-08	1894	\N	3408	18	512.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
435	LB_2_307_120_35	2026-04-08	1894	\N	3408	19	512.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
436	LB_2_307_120_36	2026-04-08	1894	\N	3408	20	512.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
437	LB_2_454_120_37	2026-04-08	1894	\N	3555	18	1070.944	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
438	LB_2_454_120_38	2026-04-08	1894	\N	3555	19	1070.944	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
439	LB_2_454_120_39	2026-04-08	1894	\N	3555	20	1070.944	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
440	LB_2_583_120_40	2026-04-08	1894	\N	3749	18	159.300	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
441	LB_2_583_120_41	2026-04-08	1894	\N	3749	19	159.300	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
442	LB_2_583_120_42	2026-04-08	1894	\N	3749	20	159.300	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
443	LB_2_1010_120_43	2026-04-08	1894	\N	4111	18	108.188	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
444	LB_2_1010_120_44	2026-04-08	1894	\N	4111	18	438.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
445	LB_2_1010_120_45	2026-04-08	1894	\N	4111	19	438.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
446	LB_2_1010_120_46	2026-04-08	1894	\N	4111	20	438.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
447	LB_2_1_122_0	2026-04-08	1894	\N	3103	17	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
448	LB_4_90_201_0	2026-04-15	1894	\N	3191	17	17.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
449	LB_4_90_201_1	2026-04-15	1894	\N	3191	17	9.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
450	LB_5_329_359_0	2026-04-22	1894	\N	3430	18	13.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
451	LB_5_329_359_1	2026-04-22	1894	\N	3430	19	13.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
452	LB_5_329_359_2	2026-04-22	1894	\N	3430	20	13.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
453	LB_5_680_359_3	2026-04-22	1894	\N	3781	18	10.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
454	LB_5_680_359_4	2026-04-22	1894	\N	3781	19	10.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
455	LB_5_680_359_5	2026-04-22	1894	\N	3781	20	10.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
456	LB_5_961_359_6	2026-04-22	1894	\N	4062	18	9.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
457	LB_5_961_359_7	2026-04-22	1894	\N	4062	19	9.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
458	LB_5_961_359_8	2026-04-22	1894	\N	4062	20	9.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
459	LB_5_212_359_9	2026-04-22	1894	\N	3313	18	1.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
460	LB_5_212_359_10	2026-04-22	1894	\N	3313	19	1.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
461	LB_5_212_359_11	2026-04-22	1894	\N	3313	20	1.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
462	LB_5_32_359_12	2026-04-22	1894	\N	3134	18	23.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
463	LB_5_32_359_13	2026-04-22	1894	\N	3134	19	23.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
464	LB_5_32_359_14	2026-04-22	1894	\N	3134	20	23.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
465	LB_5_40_359_15	2026-04-22	1894	\N	3142	18	2.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
466	LB_5_40_359_16	2026-04-22	1894	\N	3142	19	2.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
467	LB_5_40_359_17	2026-04-22	1894	\N	3142	20	2.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
468	LB_5_8_359_18	2026-04-22	1894	\N	3110	18	30.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
469	LB_5_8_359_19	2026-04-22	1894	\N	3110	19	30.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
470	LB_5_8_359_20	2026-04-22	1894	\N	3110	20	30.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
471	LB_5_879_359_21	2026-04-22	1894	\N	3980	18	3.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
472	LB_5_879_359_22	2026-04-22	1894	\N	3980	19	3.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
473	LB_5_191_359_23	2026-04-22	1894	\N	3292	18	1.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
474	LB_5_191_359_24	2026-04-22	1894	\N	3292	19	1.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
475	LB_5_323_359_25	2026-04-22	1894	\N	3424	18	6.292	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
476	LB_5_323_359_26	2026-04-22	1894	\N	3424	19	6.292	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
477	LB_5_323_359_27	2026-04-22	1894	\N	3424	20	6.292	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
478	LB_5_40_359_28	2026-04-22	1894	\N	3142	18	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
479	LB_5_40_359_29	2026-04-22	1894	\N	3142	19	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
480	LB_5_40_359_30	2026-04-22	1894	\N	3142	20	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
481	LB_5_307_359_31	2026-04-22	1894	\N	3408	19	11.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
482	LB_5_862_359_32	2026-04-22	1894	\N	3963	18	4.389	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
483	LB_5_862_359_33	2026-04-22	1894	\N	3963	19	4.389	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
484	LB_5_862_359_34	2026-04-22	1894	\N	3963	20	4.389	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
485	LB_5_102_359_35	2026-04-22	1894	\N	3203	18	65.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
486	LB_5_102_359_36	2026-04-22	1894	\N	3203	19	65.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
487	LB_5_102_359_37	2026-04-22	1894	\N	3203	20	65.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
488	LB_5_160_359_38	2026-04-22	1894	\N	3261	18	5.216	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
489	LB_5_160_359_39	2026-04-22	1894	\N	3261	19	5.216	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
490	LB_5_160_359_40	2026-04-22	1894	\N	3261	20	5.216	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
491	LB_5_146_359_41	2026-04-22	1894	\N	3247	18	2.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
492	LB_5_146_359_42	2026-04-22	1894	\N	3247	19	2.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
493	LB_5_146_359_43	2026-04-22	1894	\N	3247	20	2.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
494	LB_5_152_359_44	2026-04-22	1894	\N	3253	18	4.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
495	LB_5_152_359_45	2026-04-22	1894	\N	3253	19	4.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
496	LB_5_152_359_46	2026-04-22	1894	\N	3253	20	4.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
497	LB_5_32_359_47	2026-04-22	1894	\N	3134	18	1.710	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
498	LB_5_32_359_48	2026-04-22	1894	\N	3134	19	1.710	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
499	LB_5_32_359_49	2026-04-22	1894	\N	3134	20	1.710	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
500	LB_5_480_359_50	2026-04-22	1894	\N	3581	18	19.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
501	LB_5_480_359_51	2026-04-22	1894	\N	3581	19	19.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
502	LB_5_480_359_52	2026-04-22	1894	\N	3581	20	19.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
503	LB_5_85_359_53	2026-04-22	1894	\N	3186	18	9.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
504	LB_5_85_359_54	2026-04-22	1894	\N	3186	19	9.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
505	LB_5_85_359_55	2026-04-22	1894	\N	3186	20	9.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
506	LB_5_596_359_56	2026-04-22	1894	\N	3632	18	10.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
507	LB_5_596_359_57	2026-04-22	1894	\N	3632	19	10.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
508	LB_5_596_359_58	2026-04-22	1894	\N	3632	20	10.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
509	LB_5_22_359_59	2026-04-22	1894	\N	3124	18	56.070	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
510	LB_5_22_359_60	2026-04-22	1894	\N	3124	19	56.070	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
511	LB_5_22_359_61	2026-04-22	1894	\N	3124	20	56.070	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
512	LB_6_642_559_0	2026-04-29	1894	\N	3678	18	243.045	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
513	LB_6_642_559_1	2026-04-29	1894	\N	3678	19	243.045	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
514	LB_6_642_559_2	2026-04-29	1894	\N	3678	20	243.045	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
515	LB_6_5_559_3	2026-04-29	1894	\N	3107	18	5.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
516	LB_6_5_559_4	2026-04-29	1894	\N	3107	18	2003.350	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
517	LB_6_5_559_5	2026-04-29	1894	\N	3107	19	2003.350	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
518	LB_6_5_559_6	2026-04-29	1894	\N	3107	20	2003.350	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
519	LB_6_19_559_7	2026-04-29	1894	\N	3121	18	5.876	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
520	LB_6_19_559_8	2026-04-29	1894	\N	3121	18	581.724	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
521	LB_6_19_559_9	2026-04-29	1894	\N	3121	19	581.724	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
522	LB_6_19_559_10	2026-04-29	1894	\N	3121	20	581.724	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
523	LB_6_164_559_11	2026-04-29	1894	\N	3265	18	4.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
524	LB_6_164_559_12	2026-04-29	1894	\N	3265	18	982.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
525	LB_6_164_559_13	2026-04-29	1894	\N	3265	19	982.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
526	LB_6_164_559_14	2026-04-29	1894	\N	3265	20	982.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
527	LB_6_213_559_15	2026-04-29	1894	\N	3314	18	666.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
528	LB_6_213_559_16	2026-04-29	1894	\N	3314	19	666.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
529	LB_6_213_559_17	2026-04-29	1894	\N	3314	20	666.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
530	LB_6_242_559_18	2026-04-29	1894	\N	3343	18	498.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
531	LB_6_242_559_19	2026-04-29	1894	\N	3343	19	498.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
532	LB_6_242_559_20	2026-04-29	1894	\N	3343	20	498.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 15:19:13.414929	2026-08-03 15:19:13.414929	[]	[]	\N
\.


--
-- Data for Name: salary_vouchers; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.salary_vouchers (id, voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, allowances, deductions, net_salary, narration, created_by, created_at, updated_at) FROM stdin;
7	SAL_8_775	2026-05-07	2506	5	2026	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:13.543817	2026-08-03 15:19:13.543817
8	SAL_11_984	2026-05-18	2506	5	2026	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 15:19:13.543817	2026-08-03 15:19:13.543817
\.


--
-- Data for Name: stock_adjustments; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.stock_adjustments (id, adjustment_no, adjustment_date, product_id, quantity, reason, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: stock_inward; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.stock_inward (id, inward_no, inward_date, product_id, process_id, ledger_id, quantity, rate, amount, uom_id, narration, serial_no, ref_no, ref_date, expected_duration_days, weight, total_weight, items, is_completed, completed_date, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_item_movements; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.stock_item_movements (id, movement_no, movement_date, movement_type, stock_item_id, ledger_id, quantity, rate, amount, uom_id, ref_no, narration, items, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_outward; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.stock_outward (id, outward_no, outward_date, inward_id, product_id, process_id, ledger_id, quantity, rate, amount, weight, total_weight, uom_id, serial_no, ref_no, narration, items, inward_ids, dispatch_through, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stock_transfer; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.stock_transfer (id, transfer_no, transfer_date, from_stock_item_id, to_stock_item_id, quantity, narration, created_by, created_at) FROM stdin;
7	ST_20_22	2026-05-22	3275	3275	360.000		\N	2026-08-03 15:19:14.276016
8	ST_31_33	2026-06-04	3745	3745	111.000		\N	2026-08-03 15:19:14.276016
\.


--
-- Data for Name: voucher_lines; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.voucher_lines (id, voucher_id, ledger_id, dr_amount, cr_amount, narration) FROM stdin;
1909	955	2018	0.00	109000.00	PAID AMOUNT FOR JAN
1910	955	2027	109000.00	0.00	PAID AMOUNT FOR JAN
1911	956	2056	0.00	350.00	PURCHASE OF GP PANT
1912	956	1914	350.00	0.00	PURCHASE OF GP PANT
1913	957	2028	0.00	700.00	PURCASE OF WIRE AND SWITCH
1914	957	1967	700.00	0.00	PURCASE OF WIRE AND SWITCH
1915	958	2056	0.00	360.00	FAN FROM LODGE AUTO CHARGE
1916	958	1914	360.00	0.00	FAN FROM LODGE AUTO CHARGE
1917	959	2028	0.00	450.00	PURCHASE OF PEN AND ACOUNT NOTES
1918	959	1982	450.00	0.00	PURCHASE OF PEN AND ACOUNT NOTES
1919	960	2018	0.00	75.00	PURCHASE OF TESTER
1920	960	1967	75.00	0.00	PURCHASE OF TESTER
1921	963	2018	0.00	300.00	LATHE WORK
1922	963	1967	300.00	0.00	LATHE WORK
1923	964	2018	0.00	140.00	PURCHASE OF BED PLATES SHREE KUMARAN STEELS
1924	964	1967	140.00	0.00	PURCHASE OF BED PLATES SHREE KUMARAN STEELS
1925	965	2018	0.00	700.00	BOLT AND NUT
1926	965	1954	700.00	0.00	BOLT AND NUT
1927	966	2018	0.00	3050.00	PURCHASE OF DUST COLLECTOR BAG
1928	966	2112	3050.00	0.00	PURCHASE OF DUST COLLECTOR BAG
1929	967	2018	0.00	180.00	RAPIDO
1930	967	2113	180.00	0.00	RAPIDO
1931	961	2018	0.00	105.00	RAPIDO TO IBHARIM
1932	961	2113	105.00	0.00	RAPIDO TO IBHARIM
1933	962	2028	0.00	180.00	RAPIDO KANNAN GRINDING
1934	962	2113	180.00	0.00	RAPIDO KANNAN GRINDING
1935	968	2018	0.00	200.00	KANNAN
1936	968	2113	200.00	0.00	KANNAN
1937	969	1996	0.00	1450.00	
1938	969	1996	1450.00	0.00	
1939	970	2056	0.00	450.00	Purchase Of Printer Caterage
1940	970	1954	450.00	0.00	Purchase Of Printer Caterage
1941	971	2056	0.00	830.00	Paper Bundle
1942	971	1954	830.00	0.00	Paper Bundle
1943	972	2056	0.00	100.00	From Gandhipuram
1944	972	2113	100.00	0.00	From Gandhipuram
1945	973	2056	0.00	1420.00	Purcase Of Gloves
1946	973	1996	1420.00	0.00	Purcase Of Gloves
1947	974	2018	0.00	1000.00	Diseal
1948	974	2096	1000.00	0.00	Diseal
1949	975	2056	0.00	1000.00	Tata
1950	975	2053	1000.00	0.00	Tata
1951	976	2056	0.00	220.00	Food
1952	976	1966	220.00	0.00	Food
1953	986	2018	0.00	5000.00	Paid For Crainloading And Unloading
1954	986	2124	5000.00	0.00	Paid For Crainloading And Unloading
1955	987	2056	0.00	200.00	Tea
1956	987	1966	200.00	0.00	Tea
1957	988	2056	0.00	1000.00	Diseal
1958	988	2096	1000.00	0.00	Diseal
1959	989	2056	0.00	2500.00	Syscli
1960	989	1954	2500.00	0.00	Syscli
1961	990	2056	0.00	110.00	Gandhipuram
1962	990	2113	110.00	0.00	Gandhipuram
1963	991	2056	0.00	2242.00	Welding Rod
1964	991	1954	2242.00	0.00	Welding Rod
1965	992	2056	0.00	300.00	Bolt And Nut For Power Factor
1966	992	1954	300.00	0.00	Bolt And Nut For Power Factor
1967	993	2056	0.00	300.00	Bolt And Nut For Shotblasting
1968	993	1954	300.00	0.00	Bolt And Nut For Shotblasting
1969	994	2056	0.00	200.00	TEA
1970	994	1966	200.00	0.00	TEA
1971	995	2056	0.00	2500.00	AC FROM AVANCASHI
1972	995	1914	2500.00	0.00	AC FROM AVANCASHI
1973	996	2018	0.00	800.00	SAND JALLADAI
1974	996	1954	800.00	0.00	SAND JALLADAI
1975	997	2018	0.00	1900.00	ALUMINIUM SCREW AND RUBBER BEADING
1976	997	1954	1900.00	0.00	ALUMINIUM SCREW AND RUBBER BEADING
1977	998	2018	0.00	250.00	PURCHASE OF AG4 WHEEL
1978	998	1954	250.00	0.00	PURCHASE OF AG4 WHEEL
1979	999	2010	0.00	29618.00	
1980	999	1954	29618.00	0.00	
1981	1000	2018	0.00	29618.00	PURCHASE OF 100 LTS PAINT
1982	1000	2010	29618.00	0.00	PURCHASE OF 100 LTS PAINT
1983	1001	2018	0.00	200.00	FOR MOTOR FROM COMPANY TO AVERAMPALAYAM
1984	1001	2113	200.00	0.00	FOR MOTOR FROM COMPANY TO AVERAMPALAYAM
1985	1002	1980	0.00	38704.00	
1986	1002	1954	38704.00	0.00	
1987	1003	1980	0.00	500.00	
1988	1003	1954	500.00	0.00	
1989	1004	2018	0.00	870.00	PURCHASE OF CAKE FOR SURESH BIRTHDAY
1990	1004	1966	870.00	0.00	PURCHASE OF CAKE FOR SURESH BIRTHDAY
1991	1005	1913	0.00	10000.00	
1992	1005	2289	10000.00	0.00	
1993	1006	2018	0.00	10000.00	PURCHASE OF SHOTS 150 KGS
1994	1006	1913	10000.00	0.00	PURCHASE OF SHOTS 150 KGS
1995	1007	2018	0.00	550.00	PURCHASE OF BUSH FOR SHOTBLASTING
1996	1007	1954	550.00	0.00	PURCHASE OF BUSH FOR SHOTBLASTING
1997	1008	2056	0.00	100.00	ARUMUGAM
1998	1008	2113	100.00	0.00	ARUMUGAM
1999	1009	2018	0.00	140.00	PURCHASE OF GROOME 2 NOS
2000	1009	1954	140.00	0.00	PURCHASE OF GROOME 2 NOS
2001	1010	2028	0.00	10000.00	Paid For Grinding Stone
2002	1010	1980	10000.00	0.00	Paid For Grinding Stone
2003	1011	2028	0.00	600.00	Purchase Of 14 Inch Cutting Wheel
2004	1011	1954	600.00	0.00	Purchase Of 14 Inch Cutting Wheel
2005	1012	2018	0.00	350.00	Krishna Grinding Auto Charge
2006	1012	1914	350.00	0.00	Krishna Grinding Auto Charge
2007	1013	2018	0.00	200.00	Hindi Labour From Room To Company
2008	1013	1914	200.00	0.00	Hindi Labour From Room To Company
2009	1014	2018	0.00	5000.00	Payed For Crain
2010	1014	2124	5000.00	0.00	Payed For Crain
2011	1015	2018	0.00	2000.00	TATA
2012	1015	2053	2000.00	0.00	TATA
2013	1016	2018	0.00	100.00	PAID FOR ARUMUGAM
2014	1016	1914	100.00	0.00	PAID FOR ARUMUGAM
2015	1017	2056	0.00	200.00	HINDIN LABOURS FROM ROOM
2016	1017	1914	200.00	0.00	HINDIN LABOURS FROM ROOM
2017	1018	2018	0.00	400.00	PURCHASE OF 4 INCH WHEEL
2018	1018	1954	400.00	0.00	PURCHASE OF 4 INCH WHEEL
2019	1019	2018	0.00	1000.00	FORKLIFT
2020	1019	2053	1000.00	0.00	FORKLIFT
2021	1020	2018	0.00	120.00	PURCHASE OF FLANGE BEARING
2022	1020	2113	120.00	0.00	PURCHASE OF FLANGE BEARING
2023	1021	2018	0.00	2000.00	TATA
2024	1021	2053	2000.00	0.00	TATA
2025	1022	2018	0.00	200.00	HINDI LABOUR
2026	1022	1914	200.00	0.00	HINDI LABOUR
2027	1023	2018	0.00	1500.00	PURCHASE OF ALUMINIUM L ANGLE
2028	1023	1954	1500.00	0.00	PURCHASE OF ALUMINIUM L ANGLE
2029	1024	2018	0.00	1300.00	FLANGE BEARING
2030	1024	1954	1300.00	0.00	FLANGE BEARING
2031	1061	2010	0.00	29618.00	
2032	1061	1954	29618.00	0.00	
2033	1062	1913	0.00	11505.00	
2034	1062	1954	11505.00	0.00	
2035	1063	2358	0.00	1600.00	
2036	1063	1954	1600.00	0.00	
2037	1064	2018	0.00	28497.00	PAID FOR TURBON OIL
2038	1064	2264	28497.00	0.00	PAID FOR TURBON OIL
2039	1065	2018	0.00	20000.00	PAID FOR GRINDING STONE
2040	1065	1980	20000.00	0.00	PAID FOR GRINDING STONE
2041	1066	2018	0.00	29618.00	PURCHSE OF 100 LTS GP  PAINT
2042	1066	2010	29618.00	0.00	PURCHSE OF 100 LTS GP  PAINT
2043	1067	2018	0.00	1600.00	PURCHASE  OF DRINKING WATER
2044	1067	2358	1600.00	0.00	PURCHASE  OF DRINKING WATER
2045	1068	2018	0.00	10000.00	MOTOR REPAIR
2046	1068	1976	10000.00	0.00	MOTOR REPAIR
2047	1069	2018	0.00	10000.00	PAID FOR CRAIN
2048	1069	2124	10000.00	0.00	PAID FOR CRAIN
2049	1074	2018	0.00	3700.00	Ac Repair And Gas Filing
2050	1074	1967	3700.00	0.00	Ac Repair And Gas Filing
2051	1075	2018	0.00	5700.00	Purchase Of Water Tank
2052	1075	1954	5700.00	0.00	Purchase Of Water Tank
2053	1076	2018	0.00	100.00	Marimuthu Lunch
2054	1076	1966	100.00	0.00	Marimuthu Lunch
2055	1077	2056	0.00	200.00	Texmo
2056	1077	2113	200.00	0.00	Texmo
2057	977	2056	0.00	200.00	TEXMO
2058	977	2113	200.00	0.00	TEXMO
2059	978	2056	0.00	200.00	TEA
2060	978	1966	200.00	0.00	TEA
2061	979	2056	0.00	100.00	ZIP COVER AND LEMON
2062	979	1954	100.00	0.00	ZIP COVER AND LEMON
2063	980	2018	0.00	4000.00	ASHOK SAMY
2064	980	2000	4000.00	0.00	ASHOK SAMY
2065	981	2018	0.00	44000.00	LOAN AMOUNT PAID
2066	981	1944	44000.00	0.00	LOAN AMOUNT PAID
2067	982	2018	0.00	200.00	TEXMO
2068	982	2113	200.00	0.00	TEXMO
2069	983	2018	0.00	1862.00	WEEKLY TEA PAYMENT
2070	983	2261	1862.00	0.00	WEEKLY TEA PAYMENT
2071	984	2018	0.00	15000.00	WEEKLY PAPYMENT
2072	984	2124	15000.00	0.00	WEEKLY PAPYMENT
2073	985	2018	252002.00	0.00	BILL NO - 6
2074	985	1894	0.00	252002.00	BILL NO - 6
2075	1237	2056	0.00	20000.00	PAID FOR GRINDING STONE
2076	1237	1980	20000.00	0.00	PAID FOR GRINDING STONE
2077	1238	1980	0.00	16992.00	
2078	1238	1954	16992.00	0.00	
2079	1239	2264	0.00	28497.00	
2080	1239	1954	28497.00	0.00	
2081	1240	2010	0.00	16992.00	
2082	1240	1954	16992.00	0.00	
2083	1241	2018	0.00	28497.00	PAID FOR THE PURCHASE OF 210 LITTERS
2084	1241	2264	28497.00	0.00	PAID FOR THE PURCHASE OF 210 LITTERS
2085	1243	2018	0.00	41300.00	RENT PAID
2086	1243	2296	41300.00	0.00	RENT PAID
2087	1244	2296	0.00	76300.00	
2088	1244	1954	76300.00	0.00	
2089	1245	2018	0.00	41600.00	RENT PAID FOR THE MONTH OF JUNE
2090	1245	2296	41600.00	0.00	RENT PAID FOR THE MONTH OF JUNE
2091	1246	2018	0.00	2303.00	LABOUR WELFARE
2092	1246	2261	2303.00	0.00	LABOUR WELFARE
2093	1247	2018	0.00	10000.00	PAID FOR THE CRAIN
2094	1247	2124	10000.00	0.00	PAID FOR THE CRAIN
2095	1242	2018	0.00	16992.00	CASH PAID FOR 60 LITTERS
2096	1242	2010	16992.00	0.00	CASH PAID FOR 60 LITTERS
2097	1025	2056	0.00	2500.00	DRINKS
2098	1025	1966	2500.00	0.00	DRINKS
2099	1026	2018	0.00	1500.00	Paid For Water
2100	1026	2358	1500.00	0.00	Paid For Water
2101	1027	2018	0.00	288.00	Texmo For Strainer Bracket
2102	1027	1914	288.00	0.00	Texmo For Strainer Bracket
2103	1028	2018	0.00	3000.00	Paid For Labour Welfare
2104	1028	2261	3000.00	0.00	Paid For Labour Welfare
2105	1029	2018	0.00	170.00	Texmo Labours
2106	1029	1914	170.00	0.00	Texmo Labours
2107	1030	2018	0.00	820.00	Purchase Of Wire And Switch Boxs For Office
2108	1030	1954	820.00	0.00	Purchase Of Wire And Switch Boxs For Office
2109	1031	2018	0.00	300.00	Paid For Rapido For Modi And Ibharim
2110	1031	1914	300.00	0.00	Paid For Rapido For Modi And Ibharim
2111	1032	2018	0.00	5100.00	Purchase Of Floor Mat For Office
2112	1032	1954	5100.00	0.00	Purchase Of Floor Mat For Office
2113	1033	2264	0.00	56994.00	
2114	1033	1954	56994.00	0.00	
2115	1034	2018	0.00	28497.00	PAID FOR TURBON OIL
2116	1034	2264	28497.00	0.00	PAID FOR TURBON OIL
2117	1035	2018	0.00	20000.00	PAID FOR GRINDING WHEEL
2118	1035	1980	20000.00	0.00	PAID FOR GRINDING WHEEL
2119	1036	2018	0.00	500.00	CASH PAID
2120	1036	1980	500.00	0.00	CASH PAID
2121	1037	1980	0.00	1900.00	
2122	1037	1954	1900.00	0.00	
2123	1038	1980	0.00	10856.00	
2124	1038	1954	10856.00	0.00	
2125	1039	2358	0.00	7200.00	
2126	1039	1954	7200.00	0.00	
2127	1040	2018	0.00	1648.00	BALANCE AMOUNT PAID
2128	1040	2261	1648.00	0.00	BALANCE AMOUNT PAID
2129	1041	2018	0.00	2000.00	PAID FOR DRINKING WATER
2130	1041	2358	2000.00	0.00	PAID FOR DRINKING WATER
2131	1043	1913	0.00	9750.00	
2132	1043	1954	9750.00	0.00	
2133	1044	2182	0.00	4956.00	
2134	1044	1954	4956.00	0.00	
2135	1045	2018	0.00	4956.00	Gpay Paid For Narrow Plate
2136	1045	2182	4956.00	0.00	Gpay Paid For Narrow Plate
2137	1042	1913	0.00	23010.00	
2138	1042	1954	23010.00	0.00	
2139	1046	2010	0.00	28618.00	
2140	1046	1954	28618.00	0.00	
2141	1047	2010	0.00	29618.00	
2142	1047	1954	29618.00	0.00	
2143	1048	2018	0.00	29618.00	Purchase Of Gp Paint 100 Lts
2144	1048	2010	29618.00	0.00	Purchase Of Gp Paint 100 Lts
2145	1049	2018	0.00	29618.00	Purchase Of Gp Paint 100 Lts
2272	1125	1954	17770.00	0.00	
2146	1049	2010	29618.00	0.00	Purchase Of Gp Paint 100 Lts
2147	1050	2018	0.00	5000.00	Paid For Crain
2148	1050	2124	5000.00	0.00	Paid For Crain
2149	1051	2018	0.00	23010.00	Paid In  Cheque
2150	1051	1913	23010.00	0.00	Paid In  Cheque
2151	1052	2018	57600.00	0.00	Paid Bill No 01
2152	1052	1894	0.00	57600.00	Paid Bill No 01
2153	1053	2018	223480.00	0.00	Paid For Bil  No 2 And 3
2154	1053	1894	0.00	223480.00	Paid For Bil  No 2 And 3
2155	1054	2018	0.00	300.00	Modi And Ibrahim
2156	1054	2113	300.00	0.00	Modi And Ibrahim
2157	1055	2018	0.00	300.00	Evening Tea
2158	1055	1966	300.00	0.00	Evening Tea
2159	1056	2018	0.00	2000.00	Tata
2160	1056	2053	2000.00	0.00	Tata
2161	1070	2018	0.00	1500.00	ACTING  DRIVER
2162	1070	2276	1500.00	0.00	ACTING  DRIVER
2163	1057	2056	0.00	200.00	Texmo
2164	1057	2113	200.00	0.00	Texmo
2165	1058	2056	0.00	500.00	Acting Driver Tips
2166	1058	2276	500.00	0.00	Acting Driver Tips
2167	1059	2018	0.00	1200.00	SALARY FOR A DAY
2168	1059	2276	1200.00	0.00	SALARY FOR A DAY
2169	1060	2056	0.00	200.00	TEXMO
2170	1060	2113	200.00	0.00	TEXMO
2171	1071	2018	0.00	115666.00	PAID FEB MONTH
2172	1071	2027	115666.00	0.00	PAID FEB MONTH
2173	1072	2018	0.00	1776.00	PAID
2174	1072	2261	1776.00	0.00	PAID
2175	1073	2018	0.00	11505.00	PAID PURCHASE OF SHOTS 150 KGS
2176	1073	1913	11505.00	0.00	PAID PURCHASE OF SHOTS 150 KGS
2177	1079	1913	0.00	11505.00	
2178	1079	1954	11505.00	0.00	
2179	1080	2056	0.00	100.00	MARIMUTHU LUNCH
2180	1080	1966	100.00	0.00	MARIMUTHU LUNCH
2181	1081	2056	0.00	60.00	LUNCH MARIMUTHU
2182	1081	1966	60.00	0.00	LUNCH MARIMUTHU
2183	1082	2056	0.00	350.00	WELDING ROD
2184	1082	1919	350.00	0.00	WELDING ROD
2185	1078	2018	234452.00	0.00	Received
2186	1078	1894	0.00	234452.00	Received
2187	1083	2264	0.00	28497.00	
2188	1083	1954	28497.00	0.00	
2189	1084	2018	0.00	200.00	TEXMO
2190	1084	2113	200.00	0.00	TEXMO
2191	1085	2018	0.00	350.00	PURCHASE OF WELDING ROD
2192	1085	1954	350.00	0.00	PURCHASE OF WELDING ROD
2193	1086	2018	0.00	200.00	WHITE PAINT AND BLUE PAINT
2194	1086	1954	200.00	0.00	WHITE PAINT AND BLUE PAINT
2195	1087	2018	0.00	200.00	TEXMO
2196	1087	2113	200.00	0.00	TEXMO
2197	1088	2018	0.00	60.00	MARIMUTHU  LUNCH
2198	1088	1966	60.00	0.00	MARIMUTHU  LUNCH
2199	1089	2018	0.00	300.00	PURCHASE OF LOCK AND SANAL
2200	1089	1954	300.00	0.00	PURCHASE OF LOCK AND SANAL
2201	1090	2018	0.00	150.00	TEA
2202	1090	1966	150.00	0.00	TEA
2203	1091	2018	0.00	200.00	BROOM
2204	1091	1954	200.00	0.00	BROOM
2205	1092	1948	0.00	28409.00	
2206	1092	1954	28409.00	0.00	
2207	1094	2018	0.00	23677.00	Paid For Eb Deposite
2208	1094	2296	23677.00	0.00	Paid For Eb Deposite
2209	1095	2018	0.00	28409.00	Cheque Paid To E.B With Deposite Amount
2210	1095	1948	28409.00	0.00	Cheque Paid To E.B With Deposite Amount
2211	1093	2296	0.00	93948.00	
2212	1093	1954	93948.00	0.00	
2213	1102	2297	0.00	600.00	
2214	1102	1954	600.00	0.00	
2215	1103	2018	0.00	600.00	1000 LTS WATER
2216	1103	2297	600.00	0.00	1000 LTS WATER
2217	1104	1913	0.00	11505.00	
2218	1104	1954	11505.00	0.00	
2219	1105	2018	0.00	880.00	VALUE FOR COMPRESSOR
2220	1105	1954	880.00	0.00	VALUE FOR COMPRESSOR
2221	1106	2018	0.00	4800.00	HOSE FOR COMPRESSOR
2222	1106	1954	4800.00	0.00	HOSE FOR COMPRESSOR
2223	1107	2018	0.00	200.00	TEXMO
2224	1107	2113	200.00	0.00	TEXMO
2225	1108	2018	0.00	330.00	SHOTS
2226	1108	1914	330.00	0.00	SHOTS
2227	1109	2018	0.00	2000.00	TATA
2228	1109	2053	2000.00	0.00	TATA
2229	1110	2018	0.00	390.00	TEA
2230	1110	1966	390.00	0.00	TEA
2231	1096	2018	0.00	28497.00	Turboil
2232	1096	2264	28497.00	0.00	Turboil
2233	1097	2018	0.00	11505.00	Purchase Of Shots 150 Kgs
2234	1097	1913	11505.00	0.00	Purchase Of Shots 150 Kgs
2235	1098	2018	0.00	20000.00	Payment Paid
2236	1098	1980	20000.00	0.00	Payment Paid
2237	1099	2010	0.00	29618.00	
2238	1099	1954	29618.00	0.00	
2239	1100	2018	0.00	29618.00	Payment Made For 100 Lts Paint
2240	1100	2010	29618.00	0.00	Payment Made For 100 Lts Paint
2241	1101	2018	265931.00	0.00	Invoice No 01-06  Dated 22/04/26
2242	1101	1894	0.00	265931.00	Invoice No 01-06  Dated 22/04/26
2243	1111	2056	0.00	1500.00	SALARY
2244	1111	2276	1500.00	0.00	SALARY
2245	1112	2056	0.00	200.00	TEA
2246	1112	1966	200.00	0.00	TEA
2247	1114	2018	0.00	20000.00	PURCHASE OF GRINDING STONE
2248	1114	1980	20000.00	0.00	PURCHASE OF GRINDING STONE
2249	1115	2018	0.00	2000.00	WATER
2250	1115	2358	2000.00	0.00	WATER
2251	1113	1980	0.00	100034.00	
2252	1113	1954	100034.00	0.00	
2253	1116	2028	0.00	41300.00	RENT PAID FOR THE MONTH OF APRIL
2254	1116	2296	41300.00	0.00	RENT PAID FOR THE MONTH OF APRIL
2255	1117	2264	0.00	28497.00	
2256	1117	1954	28497.00	0.00	
2257	1118	2264	0.00	28497.00	
2258	1118	1954	28497.00	0.00	
2259	1119	2056	0.00	200.00	CASH
2260	1119	2113	200.00	0.00	CASH
2261	1120	2056	0.00	250.00	CASH
2262	1120	2000	250.00	0.00	CASH
2263	1121	2056	0.00	200.00	CAS
2264	1121	2113	200.00	0.00	CAS
2265	1122	2056	0.00	150.00	MOP
2266	1122	1967	150.00	0.00	MOP
2267	1123	2056	0.00	20000.00	RENT BALANCE PAID
2268	1123	2296	20000.00	0.00	RENT BALANCE PAID
2269	1124	2028	0.00	8971.00	RENT BALANCE TRANSFER
2270	1124	2296	8971.00	0.00	RENT BALANCE TRANSFER
2271	1125	2010	0.00	17770.00	
2273	1126	2010	0.00	16992.00	
2274	1126	1954	16992.00	0.00	
2275	1127	2018	0.00	17770.00	PURCHASE OF PAINT 60 LTS
2276	1127	2010	17770.00	0.00	PURCHASE OF PAINT 60 LTS
2277	1128	2018	0.00	16992.00	PURCCHASE OF PAINT 60 LITERS
2278	1128	2010	16992.00	0.00	PURCCHASE OF PAINT 60 LITERS
2279	1129	2056	0.00	100.00	MARIMUTHU
2280	1129	1966	100.00	0.00	MARIMUTHU
2281	1130	2018	0.00	200.00	TEXMO
2282	1130	2113	200.00	0.00	TEXMO
2283	1131	2056	0.00	100.00	TEXMO
2284	1131	2113	100.00	0.00	TEXMO
2285	1132	2056	0.00	300.00	PURCHASE OF GP PAINT 60 LTS
2286	1132	1914	300.00	0.00	PURCHASE OF GP PAINT 60 LTS
2287	1133	2018	0.00	20000.00	Paid For Grinding Stone Purchasse
2288	1133	1980	20000.00	0.00	Paid For Grinding Stone Purchasse
2289	1134	2018	0.00	11505.00	Purchase Of Shots 150  Kgs
2290	1134	1913	11505.00	0.00	Purchase Of Shots 150  Kgs
2291	1136	2018	0.00	1800.00	Paid For Labour Welfare Tea Dt.Till 10.05.2026
2292	1136	2261	1800.00	0.00	Paid For Labour Welfare Tea Dt.Till 10.05.2026
2293	1137	2018	0.00	600.00	Paid For Drinking Water 1000 Lts
2294	1137	2297	600.00	0.00	Paid For Drinking Water 1000 Lts
2295	1138	2018	0.00	600.00	Paid For Drinking Water 1000 Lts
2296	1138	2297	600.00	0.00	Paid For Drinking Water 1000 Lts
2297	1135	2018	0.00	28497.00	Purchase Of Turbonoil 210 Litters
2298	1135	2264	28497.00	0.00	Purchase Of Turbonoil 210 Litters
2299	1139	2018	0.00	11328.00	PURCAHSE OF 40 LTS PAINT INV NO 1265300482
2300	1139	2010	11328.00	0.00	PURCAHSE OF 40 LTS PAINT INV NO 1265300482
2301	1140	2010	0.00	11328.00	
2302	1140	1954	11328.00	0.00	
2303	1141	2018	218313.00	0.00	BILL NO
2304	1141	1894	0.00	218313.00	BILL NO
2305	1142	1980	0.00	3930.00	
2306	1142	1954	3930.00	0.00	
2307	1143	1913	0.00	11505.00	
2308	1143	1954	11505.00	0.00	
2309	1144	2018	0.00	28497.00	Paid For Turbon Oil
2310	1144	2264	28497.00	0.00	Paid For Turbon Oil
2311	1145	2018	0.00	20000.00	PAID FOR GRINDING STONE
2312	1145	1980	20000.00	0.00	PAID FOR GRINDING STONE
2313	1146	2018	0.00	11505.00	PAID FOR SHOTS 150 KGS
2314	1146	1913	11505.00	0.00	PAID FOR SHOTS 150 KGS
2315	1147	2010	0.00	33984.00	
2316	1147	1954	33984.00	0.00	
2317	1148	2018	0.00	33984.00	PURCHASE OF GP PAINT 120 LITS
2318	1148	2010	33984.00	0.00	PURCHASE OF GP PAINT 120 LITS
2319	1149	2018	0.00	1860.00	PURCASE OF TEA
2320	1149	2261	1860.00	0.00	PURCASE OF TEA
2321	1150	2018	0.00	20000.00	CRAIN PAYMENT
2322	1150	2124	20000.00	0.00	CRAIN PAYMENT
2323	1151	2182	0.00	4200.00	
2324	1151	1954	4200.00	0.00	
2325	1152	2182	0.00	4500.00	
2326	1152	1954	4500.00	0.00	
2327	1153	2018	0.00	4200.00	PAID FOR LONG NARROW PLATE
2328	1153	2182	4200.00	0.00	PAID FOR LONG NARROW PLATE
2329	1154	2056	0.00	1400.00	FROM DT 12-21
2330	1154	2113	1400.00	0.00	FROM DT 12-21
2331	1155	2056	0.00	200.00	TEXMO
2332	1155	2113	200.00	0.00	TEXMO
2333	1156	2056	0.00	600.00	FRIDAY EXPENSES
2334	1156	2000	600.00	0.00	FRIDAY EXPENSES
2335	1157	2264	0.00	56994.00	
2336	1157	1954	56994.00	0.00	
2337	1158	2010	0.00	33984.00	
2338	1158	1954	33984.00	0.00	
2339	1159	2056	0.00	33984.00	PURCHASE OF GP PAINT 120 LIT
2340	1159	2010	33984.00	0.00	PURCHASE OF GP PAINT 120 LIT
2341	1160	2018	0.00	28497.00	PURCHASE OF 210 LITTERS TURBON OIL
2342	1160	2264	28497.00	0.00	PURCHASE OF 210 LITTERS TURBON OIL
2343	1161	2018	0.00	10000.00	PURCHASE OF GRINDING STONE
2344	1161	1980	10000.00	0.00	PURCHASE OF GRINDING STONE
2345	1162	2182	0.00	6000.00	
2346	1162	1954	6000.00	0.00	
2347	1163	2056	0.00	6000.00	PURCHASE OF 100 KGS SHOTS
2348	1163	2182	6000.00	0.00	PURCHASE OF 100 KGS SHOTS
2349	1164	2056	0.00	2100.00	LABOUR WELFARE
2350	1164	2261	2100.00	0.00	LABOUR WELFARE
2351	1165	2018	0.00	20000.00	PAID FOR CRAIN
2352	1165	2124	20000.00	0.00	PAID FOR CRAIN
2353	1166	2018	264360.00	0.00	BILL NO 10 AND 11
2354	1169	2056	0.00	300.00	TEXMO
2355	1169	2113	300.00	0.00	TEXMO
2356	1170	2056	0.00	600.00	CUTTING WHEEL AND BOLT NUT
2357	1170	1967	600.00	0.00	CUTTING WHEEL AND BOLT NUT
2358	1171	2056	0.00	180.00	WAY BRIDGE
2359	1171	1967	180.00	0.00	WAY BRIDGE
2360	1172	2018	0.00	137060.00	PAID FOR APRIL MONTH
2361	1172	2027	137060.00	0.00	PAID FOR APRIL MONTH
2362	1173	2056	0.00	3800.00	JCB SAND
2363	1173	1967	3800.00	0.00	JCB SAND
2364	1174	2056	0.00	150.00	LUNCH FOR SHOTBLASTING WORKER
2365	1174	1966	150.00	0.00	LUNCH FOR SHOTBLASTING WORKER
2366	1175	2182	0.00	16500.00	
2367	1175	1954	16500.00	0.00	
2368	1166	1894	0.00	264360.00	BILL NO 10 AND 11
2369	1167	2306	0.00	24500.00	
2370	1167	1954	24500.00	0.00	
2371	1168	2056	0.00	24500.00	PURCHASE OF INNER DISK AND MS PLATE
2372	1168	2306	24500.00	0.00	PURCHASE OF INNER DISK AND MS PLATE
2373	1176	2010	0.00	16992.00	
2374	1176	1954	16992.00	0.00	
2375	1177	2056	0.00	16992.00	PURCHASE OF PAINT 60 LITTER
2376	1177	2010	16992.00	0.00	PURCHASE OF PAINT 60 LITTER
2377	1178	1980	0.00	68558.00	
2378	1178	1954	68558.00	0.00	
2379	1179	2018	0.00	20000.00	PAID FOR PURCASE OF GRINDING WHEEEL
2380	1179	1980	20000.00	0.00	PAID FOR PURCASE OF GRINDING WHEEEL
2381	1180	2010	0.00	16992.00	
2382	1180	1954	16992.00	0.00	
2383	1181	2018	0.00	16992.00	PURCHASE OF PAINT 60 LITTERS
2384	1181	2010	16992.00	0.00	PURCHASE OF PAINT 60 LITTERS
2385	1182	2018	0.00	28497.00	PURCHASE OF  TURBON OIL
2386	1182	2264	28497.00	0.00	PURCHASE OF  TURBON OIL
2387	1184	2018	0.00	35000.00	PAID RENT FOR THE MONTH OF MAY
2388	1184	2296	35000.00	0.00	PAID RENT FOR THE MONTH OF MAY
2389	1185	2018	0.00	8250.00	PAID FOR SHOTS 150 KGS
2390	1185	2182	8250.00	0.00	PAID FOR SHOTS 150 KGS
2391	1186	2056	0.00	1175.00	PURCHASE OF TEA LABOUR WELFARE
2392	1186	2261	1175.00	0.00	PURCHASE OF TEA LABOUR WELFARE
2393	1183	2296	0.00	76300.00	
2394	1183	1954	76300.00	0.00	
2395	1187	2018	255389.00	0.00	BILL NO 01-12
2396	1187	1894	0.00	255389.00	BILL NO 01-12
2397	1188	2010	0.00	22656.00	
2398	1188	1954	22656.00	0.00	
2399	1189	2264	0.00	56994.00	
2400	1189	1954	56994.00	0.00	
2401	1190	2018	0.00	28497.00	PAID FOR 210 LITTERS OF TURBONOIL
2402	1190	2264	28497.00	0.00	PAID FOR 210 LITTERS OF TURBONOIL
2403	1191	2018	0.00	20000.00	PAID FOR GRINDING STONE
2404	1191	1980	20000.00	0.00	PAID FOR GRINDING STONE
2405	1192	2018	0.00	10000.00	PAID FOR CRAIN
2406	1192	2124	10000.00	0.00	PAID FOR CRAIN
2407	1193	2018	0.00	1701.00	PAID FOR LABOUR WELFARE
2408	1193	2261	1701.00	0.00	PAID FOR LABOUR WELFARE
2409	1194	2056	0.00	200.00	TEXMO
2410	1194	2113	200.00	0.00	TEXMO
2411	1195	2056	0.00	200.00	LABOUR WELFARE
2412	1195	2297	200.00	0.00	LABOUR WELFARE
2413	1196	2056	0.00	200.00	TA
2414	1196	1947	200.00	0.00	TA
2415	1197	2056	0.00	300.00	GREASE
2416	1197	1967	300.00	0.00	GREASE
2417	1198	2056	0.00	200.00	PURCHASE OF BREAING FROM GANDHIPURAM
2418	1198	2113	200.00	0.00	PURCHASE OF BREAING FROM GANDHIPURAM
2419	1199	2056	0.00	200.00	TEXMO
2420	1199	2113	200.00	0.00	TEXMO
2421	1200	2056	0.00	400.00	PURCHASE OF GP PAINT
2422	1200	2113	400.00	0.00	PURCHASE OF GP PAINT
2423	1201	2056	0.00	200.00	TEA
2424	1201	1947	200.00	0.00	TEA
2425	1202	2056	0.00	200.00	TEXMO
2426	1202	2113	200.00	0.00	TEXMO
2427	1203	2056	0.00	150.00	TEA
2428	1203	1947	150.00	0.00	TEA
2429	1204	2056	0.00	300.00	TEXMO
2430	1204	2113	300.00	0.00	TEXMO
2431	1205	2056	0.00	200.00	TEA
2432	1205	1947	200.00	0.00	TEA
2433	1206	2056	0.00	200.00	TEXMO
2434	1206	2113	200.00	0.00	TEXMO
2435	1207	2056	0.00	700.00	SAKU
2436	1207	1967	700.00	0.00	SAKU
2437	1208	2056	0.00	200.00	TEA
2438	1208	1947	200.00	0.00	TEA
2439	1209	2018	0.00	13982.00	PAID FOR THE GRINDING STONE
2440	1209	1980	13982.00	0.00	PAID FOR THE GRINDING STONE
2441	1210	2018	0.00	28497.00	PAID FOR THE TURBON OIL
2442	1210	2264	28497.00	0.00	PAID FOR THE TURBON OIL
2443	1211	2018	0.00	10000.00	PAID FOR THE CRAIN
2444	1211	2124	10000.00	0.00	PAID FOR THE CRAIN
2445	1212	2018	0.00	1901.00	PAID FOR LABOUR WELFARE
2446	1212	2261	1901.00	0.00	PAID FOR LABOUR WELFARE
2447	1213	2010	0.00	28320.00	
2448	1213	1954	28320.00	0.00	
2449	1214	2018	0.00	28320.00	PURCHASE OF GP PAINT 100 LITTERS
2450	1214	2010	28320.00	0.00	PURCHASE OF GP PAINT 100 LITTERS
2451	1215	2018	0.00	22656.00	PURCHASE OF GP PAINT
2452	1215	2010	22656.00	0.00	PURCHASE OF GP PAINT
2453	1216	2010	0.00	28320.00	
2454	1216	1954	28320.00	0.00	
2455	1217	2018	0.00	28320.00	PURCHASE OF GP PAINT 100 LITTERS
2456	1217	2010	28320.00	0.00	PURCHASE OF GP PAINT 100 LITTERS
2457	1218	2182	0.00	8250.00	
2458	1218	1954	8250.00	0.00	
2459	1219	1980	0.00	28108.00	
2460	1219	1954	28108.00	0.00	
2461	1220	2056	0.00	200.00	CASH
2462	1220	1966	200.00	0.00	CASH
2463	1221	2056	0.00	200.00	TEXMO
2464	1221	2113	200.00	0.00	TEXMO
2465	1222	2056	0.00	200.00	TEA
2466	1222	1966	200.00	0.00	TEA
2467	1223	2056	0.00	1000.00	PANNEL BOARD SERVICE
2468	1223	1932	1000.00	0.00	PANNEL BOARD SERVICE
2469	1224	2056	0.00	200.00	TEXMO
2470	1224	2113	200.00	0.00	TEXMO
2471	1225	2056	0.00	100.00	AKBAR
2472	1225	2113	100.00	0.00	AKBAR
2473	1226	2056	0.00	250.00	TEA
2474	1226	1966	250.00	0.00	TEA
2475	1227	2056	0.00	200.00	TEXMO
2476	1227	2113	200.00	0.00	TEXMO
2477	1228	2056	0.00	100.00	KANNAN AND AKBAR
2478	1228	2113	100.00	0.00	KANNAN AND AKBAR
2479	1233	2113	200.00	0.00	TEXMO
2480	1234	2056	0.00	200.00	AKBAR
2481	1234	2113	200.00	0.00	AKBAR
2482	1235	2056	0.00	200.00	LABOUR WELFARE
2483	1235	1947	200.00	0.00	LABOUR WELFARE
2484	1236	2056	0.00	200.00	LABOUR WELFARE
2485	1236	1947	200.00	0.00	LABOUR WELFARE
2486	1229	2018	0.00	20000.00	PAYMENT MAID FOR GRINDING STONE
2487	1229	1980	20000.00	0.00	PAYMENT MAID FOR GRINDING STONE
2488	1230	2018	0.00	8250.00	PAID FOR SHOTS 150 KGS
2489	1230	2182	8250.00	0.00	PAID FOR SHOTS 150 KGS
2490	1231	2056	0.00	200.00	TEXMO
2491	1231	2113	200.00	0.00	TEXMO
2492	1232	2056	0.00	200.00	AKBAR
2493	1232	2113	200.00	0.00	AKBAR
2494	1233	2056	0.00	200.00	TEXMO
2495	1248	2056	0.00	200.00	TEXMO
2496	1248	2113	200.00	0.00	TEXMO
2497	1249	2056	0.00	200.00	AKBAR
2498	1249	2113	200.00	0.00	AKBAR
2499	1250	2056	0.00	200.00	LABOUR WELFARE
2500	1250	1947	200.00	0.00	LABOUR WELFARE
2501	1251	2056	0.00	200.00	LABOUR WELFARE
2502	1251	1947	200.00	0.00	LABOUR WELFARE
2503	1252	2056	0.00	200.00	SHOTBLAST BOLT
2504	1252	2002	200.00	0.00	SHOTBLAST BOLT
2505	1253	2056	0.00	200.00	TEXMO
2506	1253	2113	200.00	0.00	TEXMO
2507	1254	2056	0.00	430.00	CEMENT
2508	1254	1967	430.00	0.00	CEMENT
2509	1255	2056	0.00	200.00	LABUR WELFARE
2510	1255	1947	200.00	0.00	LABUR WELFARE
2511	1256	2056	0.00	200.00	TEXMO
2512	1256	2113	200.00	0.00	TEXMO
2513	1257	2056	0.00	200.00	BLUE  AND WHITE PAINT
2514	1257	1967	200.00	0.00	BLUE  AND WHITE PAINT
2515	1258	2056	0.00	100.00	GLASS
2516	1258	1996	100.00	0.00	GLASS
2517	1259	2056	0.00	400.00	TEXMO AND AKBAR
2518	1259	2113	400.00	0.00	TEXMO AND AKBAR
2519	1260	2056	0.00	200.00	LABOUR WELFARE
2520	1260	1947	200.00	0.00	LABOUR WELFARE
2521	1261	2056	0.00	2000.00	TATA
2522	1261	2053	2000.00	0.00	TATA
2523	1262	2056	0.00	200.00	SHIVA KUMAR
2524	1262	1981	200.00	0.00	SHIVA KUMAR
2525	1263	2056	0.00	1000.00	PURCHASE OF SHOE
2526	1263	1966	1000.00	0.00	PURCHASE OF SHOE
2527	1264	2056	0.00	400.00	TEXMO AND AKBAR
2528	1264	2113	400.00	0.00	TEXMO AND AKBAR
2529	1265	2056	0.00	200.00	LABOUR WELFARE
2530	1265	1947	200.00	0.00	LABOUR WELFARE
2531	1266	2056	0.00	200.00	TEXMO AND AKBAR
2532	1266	2113	200.00	0.00	TEXMO AND AKBAR
2533	1267	2056	0.00	200.00	LABOUR WELFARE
2534	1267	1947	200.00	0.00	LABOUR WELFARE
2535	1268	2056	0.00	500.00	MEDICAL EXPENSES
2536	1268	1967	500.00	0.00	MEDICAL EXPENSES
2537	1269	2018	231651.00	0.00	PAYMENT RECEIVED  BILL NO 01-14
2538	1269	1894	0.00	231651.00	PAYMENT RECEIVED  BILL NO 01-14
2539	1270	2018	380434.00	0.00	PAYMENT RECEIVED BILL NO 01-17
2540	1270	1894	0.00	380434.00	PAYMENT RECEIVED BILL NO 01-17
2541	1271	2018	224928.00	0.00	PAYMENT RECEIVED BILL NO 01-15
2542	1271	1894	0.00	224928.00	PAYMENT RECEIVED BILL NO 01-15
2543	1272	2264	0.00	22302.00	
2544	1272	1954	22302.00	0.00	
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
955	PAY_1_3	Payment	2026-04-01	2018	109000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
956	PAY_2_4	Payment	2026-04-01	2056	350.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
957	PAY_3_5	Payment	2026-04-01	2028	700.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
958	PAY_4_6	Payment	2026-04-01	2056	360.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
959	PAY_5_18	Payment	2026-04-02	2028	450.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
960	PAY_6_21	Payment	2026-04-01	2018	75.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
963	PAY_9_28	Payment	2026-04-02	2018	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
964	PAY_10_29	Payment	2026-04-02	2018	140.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
965	PAY_11_31	Payment	2026-04-02	2018	700.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
966	PAY_12_34	Payment	2026-04-02	2018	3050.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
967	PAY_13_38	Payment	2026-04-02	2018	180.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
961	PAY_7_26	Payment	2026-04-01	2018	105.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
962	PAY_8_27	Payment	2026-04-01	2028	180.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
968	PAY_14_41	Payment	2026-04-02	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
969	PUR_1_46	Purchase	2026-04-03	1996	1450.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
970	PAY_15_47	Payment	2026-04-03	2056	450.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
971	PAY_16_48	Payment	2026-04-03	2056	830.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
972	PAY_17_49	Payment	2026-04-03	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
973	PAY_18_50	Payment	2026-04-03	2056	1420.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
974	PAY_19_54	Payment	2026-04-03	2018	1000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
975	PAY_20_65	Payment	2026-04-03	2056	1000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
976	PAY_21_70	Payment	2026-04-04	2056	220.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
986	PAY_22_76	Payment	2026-04-04	2018	5000.00	Total Amount Rs 17500 -5000  Balance 12500		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
987	PAY_23_77	Payment	2026-04-04	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
988	PAY_24_80	Payment	2026-04-06	2056	1000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
989	PAY_25_81	Payment	2026-04-06	2056	2500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
990	PAY_26_82	Payment	2026-04-06	2056	110.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
991	PAY_27_83	Payment	2026-04-06	2056	2242.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
992	PAY_28_84	Payment	2026-04-06	2056	300.00	For		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
993	PAY_29_85	Payment	2026-04-06	2056	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
994	PAY_30_91	Payment	2026-04-06	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
995	PAY_31_92	Payment	2026-04-07	2056	2500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
996	PAY_32_93	Payment	2026-04-07	2018	800.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
997	PAY_33_94	Payment	2026-04-07	2018	1900.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
998	PAY_34_95	Payment	2026-04-07	2018	250.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
999	PUR_2_100	Purchase	2026-04-07	2010	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1000	PAY_35_101	Payment	2026-04-07	2018	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1001	PAY_36_102	Payment	2026-04-07	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1002	PUR_3_103	Purchase	2026-04-07	1980	38704.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1003	PUR_4_104	Purchase	2026-04-07	1980	500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1004	PAY_37_105	Payment	2026-04-07	2018	870.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1005	PUR_5_115	Purchase	2026-04-08	1913	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1006	PAY_38_116	Payment	2026-04-08	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1007	PAY_39_117	Payment	2026-04-08	2018	550.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1008	PAY_40_118	Payment	2026-04-08	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1009	PAY_41_119	Payment	2026-04-08	2018	140.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1010	PAY_42_124	Payment	2026-04-09	2028	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1011	PAY_43_125	Payment	2026-04-09	2028	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1012	PAY_44_126	Payment	2026-04-09	2018	350.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1013	PAY_45_127	Payment	2026-04-09	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1014	PAY_46_128	Payment	2026-04-09	2018	5000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1015	PAY_47_132	Payment	2026-04-09	2018	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1016	PAY_48_133	Payment	2026-04-09	2018	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1017	PAY_49_134	Payment	2026-04-10	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1018	PAY_50_135	Payment	2026-04-11	2018	400.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1019	PAY_51_136	Payment	2026-04-10	2018	1000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1020	PAY_52_137	Payment	2026-04-10	2018	120.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1021	PAY_53_138	Payment	2026-04-10	2018	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1022	PAY_54_139	Payment	2026-04-11	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1023	PAY_55_140	Payment	2026-04-11	2018	1500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1024	PAY_56_141	Payment	2026-04-11	2018	1300.00	INDUSTRIAL BEARING		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1061	PUR_15_360	Purchase	2026-04-22	2010	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1062	PUR_16_361	Purchase	2026-04-22	1913	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1063	PUR_17_362	Purchase	2026-04-22	2358	1600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1064	PAY_81_363	Payment	2026-04-22	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1065	PAY_82_364	Payment	2026-04-22	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1066	PAY_83_365	Payment	2026-04-22	2018	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1067	PAY_84_366	Payment	2026-04-22	2018	1600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1068	PAY_85_367	Payment	2026-04-22	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1069	PAY_86_368	Payment	2026-04-22	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1074	PAY_91_420	Payment	2026-04-24	2018	3700.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1075	PAY_92_421	Payment	2026-04-24	2018	5700.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1076	PAY_93_422	Payment	2026-04-24	2018	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1077	PAY_94_423	Payment	2026-04-24	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
977	PAY_124_765	Payment	2026-05-06	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
978	PAY_125_766	Payment	2026-05-06	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
979	PAY_126_767	Payment	2026-05-06	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
980	PAY_127_768	Payment	2026-05-07	2018	4000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
981	PAY_128_769	Payment	2026-05-07	2018	44000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
982	PAY_129_770	Payment	2026-05-07	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
983	PAY_130_771	Payment	2026-05-07	2018	1862.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
984	PAY_131_772	Payment	2026-05-07	2018	15000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
985	REC_5_773	Receipt	2026-05-06	2018	252002.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1237	PAY_224_1962	Payment	2026-07-01	2056	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1238	PUR_51_1963	Purchase	2026-07-02	1980	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1239	PUR_52_1964	Purchase	2026-06-25	2264	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1240	PUR_53_1965	Purchase	2026-06-30	2010	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1241	PAY_225_1966	Payment	2026-07-01	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1243	PAY_227_1968	Payment	2026-06-10	2018	41300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1244	PUR_54_1969	Purchase	2026-07-01	2296	76300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1245	PAY_228_1970	Payment	2026-07-02	2018	41600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1246	PAY_229_1971	Payment	2026-07-02	2018	2303.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1247	PAY_230_1972	Payment	2026-07-02	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1242	PAY_226_1967	Payment	2026-06-30	2018	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1025	PAY_57_166	Payment	2026-04-12	2056	2500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1026	PAY_58_180	Payment	2026-04-13	2018	1500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1027	PAY_59_181	Payment	2026-04-13	2018	288.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1028	PAY_60_182	Payment	2026-04-13	2018	3000.00	Balance Rs 1648		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1029	PAY_61_183	Payment	2026-04-13	2018	170.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1030	PAY_62_184	Payment	2026-04-13	2018	820.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1031	PAY_63_185	Payment	2026-04-15	2018	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1032	PAY_64_186	Payment	2026-04-15	2018	5100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1033	PUR_6_192	Purchase	2026-04-11	2264	56994.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1034	PAY_65_193	Payment	2026-04-15	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1035	PAY_66_194	Payment	2026-04-15	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1036	PAY_67_195	Payment	2026-04-15	2018	500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1037	PUR_7_196	Purchase	2026-04-11	1980	1900.00	BILL NO 601		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1038	PUR_8_197	Purchase	2026-04-15	1980	10856.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1039	PUR_9_198	Purchase	2026-04-15	2358	7200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1040	PAY_68_199	Payment	2026-04-15	2018	1648.00	NILL BALANCE PAID TILL 11.04.2026		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1041	PAY_69_200	Payment	2026-04-15	2018	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1043	PUR_11_203	Purchase	2026-04-11	1913	9750.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1044	PUR_12_204	Purchase	2026-04-01	2182	4956.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1045	PAY_70_205	Payment	2026-04-15	2018	4956.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1042	PUR_10_202	Purchase	2026-04-01	1913	23010.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1046	PUR_13_207	Purchase	2026-04-07	2010	28618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1047	PUR_14_208	Purchase	2026-04-15	2010	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1048	PAY_71_209	Payment	2026-04-07	2018	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1049	PAY_71_210	Payment	2026-04-15	2018	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1050	PAY_72_211	Payment	2026-04-15	2018	5000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1051	PAY_73_212	Payment	2026-04-15	2018	23010.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1052	REC_1_214	Receipt	2026-04-08	2018	57600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1053	REC_2_215	Receipt	2026-04-15	2018	223480.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1054	PAY_74_243	Payment	2026-04-16	2018	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1055	PAY_75_244	Payment	2026-04-16	2018	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1056	PAY_76_245	Payment	2026-04-17	2018	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1070	PAY_87_369	Payment	2026-04-22	2018	1500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1057	PAY_77_273	Payment	2026-04-19	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1058	PAY_78_274	Payment	2026-04-19	2056	500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1059	PAY_79_275	Payment	2026-04-21	2018	1200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1060	PAY_80_343	Payment	2026-04-21	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1071	PAY_88_370	Payment	2026-04-22	2018	115666.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1072	PAY_89_371	Payment	2026-04-22	2018	1776.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1073	PAY_90_375	Payment	2026-04-22	2018	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1079	PUR_18_489	Purchase	2026-04-27	1913	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1080	PAY_95_501	Payment	2026-04-25	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1081	PAY_96_502	Payment	2026-04-27	2056	60.00	60		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1082	PAY_97_503	Payment	2026-04-27	2056	350.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1078	REC_3_472	Receipt	2026-04-25	2018	234452.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1083	PUR_19_518	Purchase	2026-04-28	2264	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1084	PAY_98_519	Payment	2026-04-27	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1085	PAY_99_520	Payment	2026-04-27	2018	350.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1086	PAY_100_521	Payment	2026-04-27	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1087	PAY_101_522	Payment	2026-04-28	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1088	PAY_102_523	Payment	2026-04-28	2018	60.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1089	PAY_103_524	Payment	2026-04-28	2018	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1090	PAY_104_525	Payment	2026-04-28	2018	150.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1091	PAY_105_526	Payment	2026-04-28	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1092	PUR_20_528	Purchase	2026-04-28	1948	28409.00	IN THIS BILL DEPOSITE PAID RS 23677		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1094	PAY_106_530	Payment	2026-04-28	2018	23677.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1095	PAY_107_531	Payment	2026-04-28	2018	28409.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1093	PUR_21_529	Purchase	2026-04-28	2296	93948.00	FOR THE MONTH OF APRIL INVOICE NUMBER 05  DATED 29/04/2026		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1102	PUR_23_577	Purchase	2026-04-30	2297	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1103	PAY_112_578	Payment	2026-04-30	2018	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1104	PUR_24_579	Purchase	2026-04-30	1913	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1105	PAY_113_580	Payment	2026-04-30	2018	880.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1106	PAY_114_581	Payment	2026-04-30	2018	4800.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1107	PAY_115_582	Payment	2026-04-30	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1108	PAY_116_583	Payment	2026-04-30	2018	330.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1109	PAY_117_606	Payment	2026-04-30	2018	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1110	PAY_118_607	Payment	2026-04-30	2018	390.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1096	PAY_108_549	Payment	2026-04-29	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1097	PAY_109_550	Payment	2026-04-29	2018	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1098	PAY_110_551	Payment	2026-04-29	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1099	PUR_22_552	Purchase	2026-04-29	2010	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1100	PAY_111_553	Payment	2026-04-29	2018	29618.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1101	REC_4_554	Receipt	2026-04-29	2018	265931.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1111	PAY_119_709	Payment	2026-05-05	2056	1500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1112	PAY_120_710	Payment	2026-05-05	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1114	PAY_121_736	Payment	2026-05-06	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1115	PAY_122_737	Payment	2026-05-06	2018	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1113	PUR_25_735	Purchase	2026-05-06	1980	100034.00	INVOICE NO 3841.   DC NO 606,609,624		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1116	PAY_123_739	Payment	2026-05-06	2028	41300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1117	PUR_26_740	Purchase	2026-05-06	2264	28497.00	BILL NO 26-27/INV85		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1118	PUR_27_741	Purchase	2026-05-06	2264	28497.00	26/27/INV84		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1119	PAY_132_809	Payment	2026-05-08	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1120	PAY_133_810	Payment	2026-05-09	2056	250.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1121	PAY_134_811	Payment	2026-05-09	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1122	PAY_135_812	Payment	2026-05-09	2056	150.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1123	PAY_136_841	Payment	2026-05-11	2056	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1124	PAY_137_842	Payment	2026-05-11	2028	8971.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1125	PUR_28_853	Purchase	2026-05-08	2010	17770.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1126	PUR_29_854	Purchase	2026-05-12	2010	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1127	PAY_138_855	Payment	2026-05-08	2018	17770.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1128	PAY_139_856	Payment	2026-05-12	2018	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1129	PAY_140_867	Payment	2026-05-12	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1130	PAY_141_868	Payment	2026-05-11	2018	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1131	PAY_142_869	Payment	2026-05-12	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1132	PAY_143_870	Payment	2026-05-12	2056	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1133	PAY_144_894	Payment	2026-05-13	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1134	PAY_145_895	Payment	2026-05-13	2018	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1136	PAY_147_897	Payment	2026-05-13	2018	1800.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1137	PAY_148_898	Payment	2026-04-30	2018	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1138	PAY_149_899	Payment	2026-05-13	2018	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1135	PAY_146_896	Payment	2026-05-13	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1139	PAY_150_985	Payment	2026-05-12	2018	11328.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1140	PUR_30_986	Purchase	2026-05-12	2010	11328.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1141	REC_6_993	Receipt	2026-05-13	2018	218313.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1142	PUR_31_1017	Purchase	2026-05-20	1980	3930.00	DC NO-662		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1143	PUR_32_1018	Purchase	2026-05-14	1913	11505.00	INVOICE NO-SA/26-27/30		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1144	PAY_151_1030	Payment	2026-05-20	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1145	PAY_152_1031	Payment	2026-05-20	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1146	PAY_153_1032	Payment	2026-05-20	2018	11505.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1147	PUR_33_1033	Purchase	2026-05-20	2010	33984.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1148	PAY_154_1034	Payment	2026-05-20	2018	33984.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1149	PAY_155_1035	Payment	2026-05-20	2018	1860.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1150	PAY_156_1036	Payment	2026-05-20	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1151	PUR_34_1037	Purchase	2026-05-20	2182	4200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1152	PUR_35_1038	Purchase	2026-05-20	2182	4500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1153	PAY_157_1039	Payment	2026-05-20	2018	4200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1154	PAY_158_1082	Payment	2026-05-21	2056	1400.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1155	PAY_159_1098	Payment	2026-05-22	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1156	PAY_160_1121	Payment	2026-05-22	2056	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1157	PUR_36_1122	Purchase	2026-05-22	2264	56994.00	INVOICE NO 26-27/INV-127		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1158	PUR_37_1208	Purchase	2026-05-27	2010	33984.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1159	PAY_161_1239	Payment	2026-05-27	2056	33984.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1160	PAY_162_1240	Payment	2026-05-27	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1161	PAY_163_1241	Payment	2026-05-27	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1162	PUR_38_1242	Purchase	2026-05-21	2182	6000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1163	PAY_164_1243	Payment	2026-05-27	2056	6000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1164	PAY_165_1244	Payment	2026-05-27	2056	2100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1165	PAY_166_1245	Payment	2026-05-27	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1169	PAY_168_1301	Payment	2026-05-29	2056	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1170	PAY_169_1302	Payment	2026-05-29	2056	600.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1171	PAY_170_1303	Payment	2026-05-29	2056	180.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1172	PAY_171_1304	Payment	2026-05-29	2018	137060.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1173	PAY_172_1305	Payment	2026-05-29	2056	3800.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1174	PAY_173_1311	Payment	2026-05-29	2056	150.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1175	PUR_40_1312	Purchase	2026-05-28	2182	16500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1166	REC_7_1259	Receipt	2026-05-27	2018	264360.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1167	PUR_39_1271	Purchase	2026-05-28	2306	24500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1168	PAY_167_1272	Payment	2026-05-28	2056	24500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1176	PUR_41_1341	Purchase	2026-05-30	2010	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1177	PAY_174_1342	Payment	2026-05-30	2056	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1178	PUR_42_1393	Purchase	2026-06-03	1980	68558.00	BILL NO 3869		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1179	PAY_175_1394	Payment	2026-06-03	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1180	PUR_43_1395	Purchase	2026-06-30	2010	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1181	PAY_176_1396	Payment	2026-06-05	2018	16992.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1182	PAY_177_1397	Payment	2026-06-03	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1184	PAY_178_1399	Payment	2026-06-03	2018	35000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1185	PAY_179_1400	Payment	2026-06-03	2018	8250.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1186	PAY_180_1401	Payment	2026-06-05	2056	1175.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1183	PUR_44_1398	Purchase	2026-06-01	2296	76300.00	Invoice No.08 Dated 29/05/2026		\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1187	REC_8_1484	Receipt	2026-06-03	2018	255389.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1188	PUR_45_1532	Purchase	2026-06-09	2010	22656.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1189	PUR_46_1533	Purchase	2026-06-06	2264	56994.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1190	PAY_181_1563	Payment	2026-06-10	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1191	PAY_182_1564	Payment	2026-06-10	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1192	PAY_183_1565	Payment	2026-06-10	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1193	PAY_184_1566	Payment	2026-06-10	2018	1701.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1194	PAY_185_1596	Payment	2026-06-08	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1195	PAY_186_1597	Payment	2026-06-13	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1196	PAY_187_1598	Payment	2026-06-13	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1197	PAY_188_1599	Payment	2026-06-13	2056	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1198	PAY_189_1600	Payment	2026-06-08	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1199	PAY_190_1601	Payment	2026-06-09	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1200	PAY_191_1602	Payment	2026-06-09	2056	400.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1201	PAY_192_1603	Payment	2026-06-09	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1202	PAY_193_1604	Payment	2026-06-10	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1203	PAY_194_1605	Payment	2026-06-10	2056	150.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1204	PAY_195_1606	Payment	2026-06-11	2056	300.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1205	PAY_196_1607	Payment	2026-06-10	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1206	PAY_197_1608	Payment	2026-06-12	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1207	PAY_198_1609	Payment	2026-06-12	2056	700.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1208	PAY_199_1610	Payment	2026-06-12	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1209	PAY_200_1663	Payment	2026-06-17	2018	13982.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1210	PAY_201_1664	Payment	2026-06-17	2018	28497.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1211	PAY_202_1665	Payment	2026-06-17	2018	10000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1212	PAY_203_1666	Payment	2026-06-17	2018	1901.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1213	PUR_47_1676	Purchase	2026-06-12	2010	28320.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1214	PAY_204_1677	Payment	2026-06-12	2018	28320.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1215	PAY_205_1678	Payment	2026-06-09	2018	22656.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1216	PUR_48_1696	Purchase	2026-06-19	2010	28320.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1217	PAY_206_1697	Payment	2026-06-19	2018	28320.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1218	PUR_49_1764	Purchase	2026-06-18	2182	8250.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1219	PUR_50_1765	Purchase	2026-06-16	1980	28108.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1220	PAY_207_1782	Payment	2026-06-20	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1221	PAY_208_1783	Payment	2026-06-20	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1222	PAY_209_1784	Payment	2026-06-22	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1223	PAY_210_1785	Payment	2026-06-20	2056	1000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1224	PAY_211_1786	Payment	2026-06-23	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1225	PAY_212_1787	Payment	2026-06-23	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1226	PAY_213_1788	Payment	2026-06-23	2056	250.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1227	PAY_214_1789	Payment	2026-06-24	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1228	PAY_215_1790	Payment	2026-06-23	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1234	PAY_221_1863	Payment	2026-06-26	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1235	PAY_222_1864	Payment	2026-06-26	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1236	PAY_223_1865	Payment	2026-06-25	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1229	PAY_216_1808	Payment	2026-06-24	2018	20000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1230	PAY_217_1809	Payment	2026-06-24	2018	8250.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1231	PAY_218_1860	Payment	2026-06-25	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1232	PAY_219_1861	Payment	2026-06-25	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1233	PAY_220_1862	Payment	2026-06-26	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1248	PAY_231_2013	Payment	2026-06-27	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1249	PAY_232_2014	Payment	2026-06-27	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1250	PAY_233_2015	Payment	2026-06-27	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1251	PAY_234_2016	Payment	2026-07-29	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1252	PAY_235_2017	Payment	2026-06-29	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1253	PAY_236_2018	Payment	2026-06-29	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1254	PAY_237_2019	Payment	2026-06-29	2056	430.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1255	PAY_238_2020	Payment	2026-06-30	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1256	PAY_239_2021	Payment	2026-06-30	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1257	PAY_240_2022	Payment	2026-06-30	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1258	PAY_241_2023	Payment	2026-06-30	2056	100.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1259	PAY_242_2024	Payment	2026-07-01	2056	400.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1260	PAY_243_2025	Payment	2026-07-01	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1261	PAY_244_2026	Payment	2026-07-01	2056	2000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1262	PAY_245_2027	Payment	2026-07-01	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1263	PAY_246_2028	Payment	2026-07-01	2056	1000.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1264	PAY_247_2029	Payment	2026-07-02	2056	400.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1265	PAY_248_2030	Payment	2026-07-02	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1266	PAY_249_2031	Payment	2026-07-03	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1267	PAY_250_2032	Payment	2026-07-03	2056	200.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1268	PAY_251_2033	Payment	2026-07-03	2056	500.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1269	REC_9_2052	Receipt	2026-06-10	2018	231651.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1270	REC_10_2053	Receipt	2026-06-24	2018	380434.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1271	REC_11_2054	Receipt	2026-06-17	2018	224928.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
1272	PUR_55_2055	Purchase	2026-07-04	2264	22302.00			\N	2026-08-03 15:19:10.416023	2026-08-03 15:19:10.416023
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.company (id, name, address, city, state, pincode, phone, mobile, email, gstin, pan, tan, financial_year_start_month, logo_path, created_at, updated_at) FROM stdin;
1	SRI METAL	S.F NO 497/2 BHARATHI STREET CHINNAVEDAMPATTY	COIMBATORE	Tamilnadu	641049			srimetal6email@gmail.com	\N	\N	\N	4	\N	2026-08-03 15:18:56.947731+00	2026-08-03 15:18:56.947731+00
\.


--
-- Data for Name: financial_years; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.financial_years (id, year_str, label, start_date, end_date, is_active, is_locked, schema_name, created_at) FROM stdin;
1	2023_2024	2023-2024	2023-04-01	2024-03-31	f	t	fy_2023_2024	2026-08-03 12:45:17.397342+00
2	2024_2025	2024-2025	2024-04-01	2025-03-31	f	t	fy_2024_2025	2026-08-03 12:45:17.397342+00
3	2025_2026	2025-2026	2025-04-01	2026-03-31	f	f	fy_2025_2026	2026-08-03 12:45:17.397342+00
4	2026_2027	2026-2027	2026-04-01	2027-03-31	t	f	fy_2026_2027	2026-08-03 12:45:17.397342+00
\.


--
-- Data for Name: ledger_groups; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.ledger_groups (id, name, parent_id, group_type, is_system, created_at) FROM stdin;
100	Duties & Taxes	106	Liability	f	2026-08-03 15:18:57.054534+00
101	Fixed Assets	101	Liability	f	2026-08-03 15:18:57.054534+00
102	Current Assets	102	Liability	f	2026-08-03 15:18:57.054534+00
103	Cash & Bank	103	Liability	f	2026-08-03 15:18:57.054534+00
104	Capital Accounts	104	Liability	f	2026-08-03 15:18:57.054534+00
105	Loans (Liabilities)	105	Liability	f	2026-08-03 15:18:57.054534+00
106	Current Liabilities	106	Liability	f	2026-08-03 15:18:57.054534+00
107	Incomes	107	Liability	f	2026-08-03 15:18:57.054534+00
108	Expenses	108	Liability	f	2026-08-03 15:18:57.054534+00
109	Deposits (Assets)	102	Liability	f	2026-08-03 15:18:57.054534+00
110	Loans & Advances (Assets)	102	Liability	f	2026-08-03 15:18:57.054534+00
111	Misc. expenses (Assets)	102	Liability	f	2026-08-03 15:18:57.054534+00
112	Sundry Debtors	102	Liability	f	2026-08-03 15:18:57.054534+00
113	Suppliers	102	Liability	f	2026-08-03 15:18:57.054534+00
114	Investments	102	Liability	f	2026-08-03 15:18:57.054534+00
115	Salary Advance (Assets)	102	Liability	f	2026-08-03 15:18:57.054534+00
116	Contractor Advance (Assets)	102	Liability	f	2026-08-03 15:18:57.054534+00
117	Bank Accounts	103	Liability	f	2026-08-03 15:18:57.054534+00
118	Cash In Hand	103	Liability	f	2026-08-03 15:18:57.054534+00
119	Reserves & Surplus	104	Liability	f	2026-08-03 15:18:57.054534+00
120	Secured Loans	105	Liability	f	2026-08-03 15:18:57.054534+00
121	Unsecured Loans	105	Liability	f	2026-08-03 15:18:57.054534+00
122	Bank O.D A/c	105	Liability	f	2026-08-03 15:18:57.054534+00
123	Provisions	106	Liability	f	2026-08-03 15:18:57.054534+00
124	Sundry Creditors	106	Liability	f	2026-08-03 15:18:57.054534+00
125	Sales Account	107	Liability	f	2026-08-03 15:18:57.054534+00
126	Labour Bill Account	107	Liability	f	2026-08-03 15:18:57.054534+00
127	Loading And UnLoading Charges (Income)	107	Liability	f	2026-08-03 15:18:57.054534+00
128	Purchase Account	108	Liability	f	2026-08-03 15:18:57.054534+00
129	Salary Expenses	108	Liability	f	2026-08-03 15:18:57.054534+00
130	Contractor Expenses	108	Liability	f	2026-08-03 15:18:57.054534+00
131	Fuel Expenses	108	Liability	f	2026-08-03 15:18:57.054534+00
132	Mobile Charges	108	Liability	f	2026-08-03 15:18:57.054534+00
\.


--
-- Data for Name: ledgers; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.ledgers (id, name, ledger_code, group_id, ledger_type, opening_balance, balance_type, phone, mobile, address, city, pincode, state, gstin, pan, bank_name, bank_account_no, bank_ifsc, designation, department, basic_salary, join_date, is_active, created_at, updated_at) FROM stdin;
1894	TEXMO INDUSTRIES  PUMP DIVISION	15	113	Account	0.00	Dr			THUDIYALUR POST	\N	\N	\N	33432020074	33AABFT1899B1ZC	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1895	TEXMO INDUSTRIES MOTOR DIVISION	19	113	Account	0.00	Dr			GNANAMBIKAI MILL POST MTP ROAD	\N	\N	\N	33432020074		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1896	V.KAVITHA - (Staff Advance)	20	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1897	V.KAVITHA - (Staff Salary)	21	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1898	SHIVA KUMAR - (Staff Advance)	22	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1899	SHIVA KUMAR - (Staff Salary)	23	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1900	MARI MUTHU RAMAKRISHNAN - (Contractor Advance)	24	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1901	MARI MUTHU RAMAKRISHNAN - (Job Work Payment)	25	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1902	GAJARAJ - (Staff Advance)	30	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1903	GAJARAJ - (Staff Salary)	31	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1904	PINTHU KUMAR - (Contractor Advance)	36	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1905	PINTHU KUMAR - (Job Work Payment)	37	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1906	LVB A/C 0192611000000430	48	117	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1907	LVB  C/A 0350360000000374	49	117	Account	0.00	Dr			KK PUDUR	\N	\N	\N			\N	0350360000000374	\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1908	LVB S/A. 0192301000056540	50	117	Account	0.00	Dr			GOUNDAMPALAYAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1909	IOB L/A. 013103401400008	51	117	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1910	IGST	239	100	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1911	CGST	240	100	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1912	SGST	241	100	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1913	SAS SHOTS	325	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1914	AUTO OR TEMPO RENT	326	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1915	COMPRESSOR EXPENSES	327	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1916	CAMERA EXPENSES	328	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1917	BABU RAJESH - (Staff Advance)	329	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1918	BABU RAJESH - (Staff Salary)	330	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1919	ELECTRICAL WORK	331	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1920	KRISHANA    GRINDING - (Contractor Advance)	332	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1921	KRISHANA    GRINDING - (Job Work Payment)	333	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1922	MADHAN GRINDING - (Contractor Advance)	334	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1923	CHANDRU (CHIPPING) - (Contractor Advance)	407	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1924	CHANDRU (CHIPPING) - (Job Work Payment)	408	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1925	Sanjai Helper - (Contractor Advance)	545	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1926	IOB C/A. 0192301000056540	52	117	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1927	MOHAN RAJ SRINIVASAN	53	104	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1928	MOHAN RAJ.S	54	124	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1929	MADHAN GRINDING - (Job Work Payment)	335	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1930	SUPER CUT	336	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1931	GRINDING STONE	337	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1932	MAINTANCE EXPENSES	338	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1933	RAVI WELDING	339	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1934	ARUMUGAM GRINDING - (Contractor Advance)	340	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1935	ARUMUGAM GRINDING - (Job Work Payment)	341	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1936	HOUSE KEEPING	342	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1937	FINECAST INDUSTRIES	343	113	Account	0.00	Dr			18/11 THADAGAM ROAD KNG PUDUR	\N	\N	\N	33AAAFF9592J1Z4	33AAAFF9592J1Z4	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1938	Deepak Helper - (Contractor Advance)	344	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1939	Deepak Helper - (Job Work Payment)	345	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1940	Babu Driver - (Staff Advance)	346	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1941	Babu Driver - (Staff Salary)	347	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1942	KOUSAL - (Contractor Advance)	348	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1943	KOUSAL - (Job Work Payment)	349	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1944	TATA VECHILE	350	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1945	JS AUTO CAST FOUNDRY INDIA PRIVATE LIMITED	351	113	Account	0.00	Dr			PLOT NO KK5,KK7 SIPCOT INDUSTRIES GROWTH CENTRE PERUNDURAI	\N	\N	\N	33AABCJ4470D1ZZ	33AABCJ4470D1ZZ	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1946	LUNCH EXPENSES	73	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1947	TEA	74	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1948	E.B	75	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1949	RENT	76	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1950	BANK CHARGES	77	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1951	TDS	78	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1952	T.V BROS	79	124	Account	0.00	Dr	04222398074	04222398074	500, R G STREET	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1953	UNIVERSAL PAINTS	80	124	Account	0.00	Dr	9843045547	9843045547	5/229, KNG PUDUR ROAD, THADAGAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1954	PURCHASE ACCOUNT	81	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1955	SOFTWARE PURCHASE	82	102	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1956	SALARY	83	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1957	TN 07 F 7090	84	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1958	TEXMO INDUSTRIES (SBL)	85	113	Account	0.00	Dr			THUDIYALUR ROAD	\N	\N	\N	33432020074		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1959	EDDY CURRENT	86	113	Account	0.00	Dr			5/233,KNG PUDUR SOMAYAMPALAYAM	\N	\N	\N	33266200237		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1960	EM EM	89	113	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1961	THAMBI DURAI - (Staff Advance)	90	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1962	THAMBI DURAI - (Staff Salary)	91	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1963	TANK WATER	92	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1964	GRACE CAST ALLOYS	352	113	Account	0.00	Dr			5/371-3F3 KNG PUDUR COIMBATORE	\N	\N	\N		33HWLPD7795B1ZA	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1965	Sri Krishna Equipment	353	113	Account	0.00	Dr			305, Lakshmi Nagar Vadavalli Road Edayarpalayam	\N	\N	\N	33DNJPS4380C1ZY	33DNJPS4380C1ZY	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1966	LABOUR WELFARE	93	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1967	MISCELLANEOUS EXP	94	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1968	BEARING	95	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1969	LVB INTREST	96	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1970	APPLE METAL	97	113	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1971	SAI MULTY PUMPS	98	113	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1972	KHAJA - (Contractor Advance)	99	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1973	KHAJA - (Job Work Payment)	100	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1974	ALAMU LODGE A/C	101	124	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1975	HOSPITAL EXPENSES	102	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1976	MOTOR MAINTANCE	103	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1977	KARPAGAM METAL	104	113	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1978	TN 66 M 5757	105	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1979	SALARY EXPENSES	106	125	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1980	V.S.AGENCIES	107	124	Account	0.00	Dr			142/238,SHIDDIVINAGAR STREET, COIMBATORE	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1981	PETROL EXPENSES	108	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1982	STATIONERS	109	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1983	PARAMESWARI FOOD PRODUCTS	110	124	Account	0.00	Dr	9843090905	9843090905	55A, BHARATHI ROAD TELUNGUPALAYAM PUDUR COIMBATORE	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1984	RUKMANI CAST ALLOYS	111	113	Account	0.00	Dr	04222404649	04222404649	568, KUPPANAICKAN ROAD, 3RD CROSS SOMAYAMPALAYAM	\N	\N	\N	33616203391		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1985	KARTHICK GRINDING - (Contractor Advance)	354	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1986	SANTHI CASTING	430	113	Account	0.00	Dr			SF NO 415&416 DOOR NO 2/229 NARASIMMANAICKENPALAYAM POST,KURUDAMPALAYAM VILLAG	\N	\N	\N		33ADPFS8454C1ZU	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1987	TELEPHONE BILL	114	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1988	JAGATHSHREE CASTINGS	115	113	Account	0.00	Dr			404/1B2 VADAVALLI KANUVAI ROAD,SOMAYAMPALAYAM	\N	\N	\N	33376202553	33BZZPR7759G1ZC	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1989	VIGNESHWARE AGENCIES	116	124	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1990	WASTE SAND	117	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1991	ANNAI ENGINEERING	118	113	Account	0.00	Dr			11/10 KAUNDAMPALAYAM EDAYARPALATYAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1992	PINDU KUMAR - (Contractor Advance)	119	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1993	PINDU KUMAR - (Job Work Payment)	120	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1994	GUN METAL	121	113	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1995	KSR COTTAGE INDUSTRIES	122	113	Account	0.00	Dr			1/99 VELAMMAL COLONY NGGO COLONY POST	\N	\N	\N	33112026264		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1996	GLOUSE	123	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1997	SRI METALS - (Contractor Advance)	124	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1998	SRI METALS - (Job Work Payment)	125	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
1999	KAVITHA	126	124	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2000	POOJA EXPENSES	127	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2001	BUILDING EXPENSES (NEW)	128	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2002	MACHINE ERECTION	129	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2003	LOADING & UNLOADING	130	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2004	KARTHICK GRINDING - (Job Work Payment)	355	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2005	Ankit Kumar - (Contractor Advance)	356	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2006	Ankit Kumar - (Job Work Payment)	357	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2007	Eicher Rent	141	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2008	RAMESH GRINDING - (Contractor Advance)	142	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2009	RAMESH GRINDING - (Job Work Payment)	143	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2010	GRAND POLYCOATS COMPANY PVT LTD	144	124	Account	0.00	Dr	04224200801	04224200801	79, VENKATASAMY ROAD WEST R.S. PURAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2011	GOODLUCK PAINTS & CHEMICALS	145	124	Account	0.00	Dr	04222552115	04222552115	15/11 C PONNUSAMY STREET,METTUPALAYAM ROAD R.S PURAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2012	PRINTING & STATIONARY	148	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2013	GEEKAY ENGG (Steel Shots )	149	124	Account	0.00	Dr	9750917896	9750917896	542/2 COSMOFAN FOUNDRY, ARASUR	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2014	ANAND GRINDING - (Contractor Advance)	257	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2015	ANAND GRINDING - (Job Work Payment)	258	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2016	SARVAN GRINDIND - (Contractor Advance)	259	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2017	SARVAN GRINDIND - (Job Work Payment)	260	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2018	HDFC SRI METAL	261	117	Account	0.00	Dr				\N	\N	\N			\N	50200080117707	\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2019	MIDAS GLOUSE	262	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2020	LODING GLOUSE	263	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2021	AUGISTIAN - (Contractor Advance)	264	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2022	AUGISTIAN - (Job Work Payment)	265	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2023	MARI MUTHU GRINDING - (Contractor Advance)	266	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2024	MARI MUTHU GRINDING - (Job Work Payment)	267	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2025	MOUNT POINT STONE	268	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2026	JOTHI ENTERPRISES	323	113	Account	0.00	Dr			1-12 P25E, A.T.S NAGAR EXTENSION GANDHIGRAM	\N	\N	\N		33AERPN9276QIZB	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2027	GST SRI METAL	577	100	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2028	YES BANK	578	117	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2029	SELVAM (MELTER) - (Contractor Advance)	579	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2030	SELVAM (MELTER) - (Job Work Payment)	580	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2031	RAJIV (MELTER) - (Contractor Advance)	581	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2032	RAJIV (MELTER) - (Job Work Payment)	582	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2033	SANKAR (SELVAM MELTER) - (Contractor Advance)	583	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2034	SANKAR (SELVAM MELTER) - (Job Work Payment)	584	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2035	ANKIT KUMAR (BRIENDAR) - (Contractor Advance)	458	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2036	ANKIT KUMAR (BRIENDAR) - (Job Work Payment)	459	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2037	MANIKANDAN (GRINDING) - (Contractor Advance)	460	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2038	MANIKANDAN (GRINDING) - (Job Work Payment)	461	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2039	RAGUL (BRINDER) - (Contractor Advance)	462	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2040	RAGUL (BRINDER) - (Job Work Payment)	463	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2041	ANAND (GRINDING) - (Contractor Advance)	464	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2042	ANAND (GRINDING) - (Job Work Payment)	465	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2043	SURAJ (HINDI) - (Contractor Advance)	466	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2044	SURAJ (HINDI) - (Job Work Payment)	467	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2045	MD INTHA(HINDI) - (Contractor Advance)	468	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2046	MD INTHA(HINDI) - (Job Work Payment)	469	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2047	SIVAGURUNATHAN - (Contractor Advance)	470	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2048	SIVAGURUNATHAN - (Job Work Payment)	471	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2049	SHAKIL (HINDI) - (Contractor Advance)	472	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2050	SHAKIL (HINDI) - (Job Work Payment)	473	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2051	GURU (CRANE) - (Contractor Advance)	476	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2052	GURU (CRANE) - (Job Work Payment)	477	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2053	DISEAL	478	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2054	GANESH (MARI MUTHU) HELPER - (Contractor Advance)	585	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2055	GANESH (MARI MUTHU) HELPER - (Job Work Payment)	586	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2056	Cash	1	118	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2057	Profit & Loss A/c	2	119	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2058	Transport Charges	3	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2059	Round Off	4	107	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2060	PRAKASH CASTING	156	113	Account	0.00	Dr			2/323,A2,GCT NAGAR,KASTHURINAPALAYAM, VADAVALLI	\N	\N	\N	33696206839		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2061	SAKTHIVEL - (Contractor Advance)	157	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2062	SAKTHIVEL - (Job Work Payment)	158	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2063	KUMAR - (Contractor Advance)	159	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2064	KUMAR - (Job Work Payment)	160	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2065	AREMPEE COMPRESSORS PVT.LTD	161	113	Account	0.00	Dr			KANUVAI	\N	\N	\N	33936203409		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2066	P.MAHAKRISHNAN - (Contractor Advance)	162	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2067	P.MAHAKRISHNAN - (Job Work Payment)	163	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2068	Manish Kumar - (Contractor Advance)	358	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2069	Manish Kumar - (Job Work Payment)	359	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2070	Dinanath Kumar - (Contractor Advance)	360	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2071	MODI HELPER - (Contractor Advance)	587	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2072	MADHESWARAN - (Contractor Advance)	500	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2073	MADHESWARAN - (Job Work Payment)	501	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2074	SATHISH - (Contractor Advance)	502	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2075	SATHISH - (Job Work Payment)	503	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2076	MOHAMAAD - (Contractor Advance)	504	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2077	MOHAMAAD - (Job Work Payment)	505	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2078	THESER HINDHI HELPER - (Contractor Advance)	506	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2079	THESER HINDHI HELPER - (Job Work Payment)	507	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2080	MOHAMAAD NAZUREL - (Contractor Advance)	508	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2081	MOHAMAAD NAZUREL - (Job Work Payment)	509	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2082	PRAWEZ ALAM - (Contractor Advance)	510	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2083	PRAWEZ ALAM - (Job Work Payment)	511	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2084	MAKESH HELPER - (Contractor Advance)	512	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2085	MAKESH HELPER - (Job Work Payment)	513	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2086	ANITHA HELPER - (Contractor Advance)	514	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2087	ANITHA HELPER - (Job Work Payment)	515	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2088	DHANANJAY - (Contractor Advance)	516	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2089	DHANANJAY - (Job Work Payment)	517	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2090	ISRAFUL - (Contractor Advance)	518	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2091	ISRAFUL - (Job Work Payment)	519	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2092	GOBI NATH - (Contractor Advance)	520	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2093	T.SATHISH KUMAR - (Staff Advance)	187	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2094	T.SATHISH KUMAR - (Staff Salary)	188	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2095	Generator	189	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2096	Forklift	190	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2097	NATRAJ AND CO	191	124	Account	0.00	Dr	2230825,4377480	2230825,4377480	450 DR.NANJAPPA ROAD	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2098	THE COSMAFAN MARKETING SOCIETY	192	124	Account	0.00	Dr	2561819	2561819	42-D,SNR COLLEGE ROAD, PEELAMEDU	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2099	AZA WATER	195	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2100	Dinanath Kumar - (Job Work Payment)	361	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2101	Ramesh Contract - (Contractor Advance)	362	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2102	Ramesh Contract - (Job Work Payment)	363	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2103	Kasi Muthu - (Contractor Advance)	364	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2104	Kasi Muthu - (Job Work Payment)	365	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2105	MODI HELPER - (Job Work Payment)	588	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2106	SKD SATHISH - (Contractor Advance)	589	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2107	SKD SATHISH - (Job Work Payment)	590	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2108	SURESH DRIVER - (Contractor Advance)	591	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2109	SURESH DRIVER - (Job Work Payment)	592	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2110	JITHENDAR GRINDING - (Contractor Advance)	593	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2111	JITHENDAR GRINDING - (Job Work Payment)	594	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2112	DUST COLLECTOR	595	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2113	RAPIDO	596	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2114	Naveena Agency	208	124	Account	0.00	Dr	9952482393	9952482393	8/16,Kk Lane No 2, Hirudaya Building,	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2115	HINDUSTAN FOUNDRY	215	113	Account	0.00	Dr	04222560383	04222560383	48.NAVAINDIA ROAD, S.S COMPLEX	\N	\N	\N	33852028961		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2116	VASANTH AGENCIES	378	113	Account	0.00	Dr			2/2,  STANES GARDEN, THUDIYALUR	\N	\N	\N		33AHGPG8472K1Z3	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2117	NATIONAL HARDWARES	379	124	Account	0.00	Dr	9894653889	9894653889	61/1 BHARATHIYAR ROAD MANIYAKARANPALAYAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2118	SELVAM (GRINDING) - (Contractor Advance)	380	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2119	SELVAM (GRINDING) - (Job Work Payment)	381	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2120	ANKIT (LABOUR) - (Contractor Advance)	382	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2121	ANKIT (LABOUR) - (Job Work Payment)	383	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2122	SWAMINATHAN	384	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2123	VECHILES MAINTANCE	385	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2124	Crain	597	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2125	Indra Kumar(Grinding) - (Contractor Advance)	598	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2126	Indra Kumar(Grinding) - (Job Work Payment)	599	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2127	KANNAN GRINDING - (Contractor Advance)	600	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2128	KANNAN GRINDING - (Job Work Payment)	601	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2129	ARUMUGAM GRINDING NEW - (Contractor Advance)	602	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2130	ARUMUGAM GRINDING NEW - (Job Work Payment)	603	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2131	MANDU - (Contractor Advance)	604	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2132	GOBI NATH - (Job Work Payment)	521	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2133	SARDAR - (Contractor Advance)	522	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2134	SARDAR - (Job Work Payment)	523	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2135	MD CHAND - (Contractor Advance)	524	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2136	MD CHAND - (Job Work Payment)	525	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2137	ANYAR RAIN - (Contractor Advance)	526	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2138	ANYAR RAIN - (Job Work Payment)	527	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2139	SADAM LABOUR - (Contractor Advance)	528	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2140	SADAM LABOUR - (Job Work Payment)	529	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2141	MADHAN LABOUR - (Contractor Advance)	530	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2142	MADHAN LABOUR - (Job Work Payment)	531	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2143	JABAR LABOUR - (Contractor Advance)	532	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2144	JABAR LABOUR - (Job Work Payment)	533	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2145	RAVI GRINDING - (Contractor Advance)	534	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2146	RAVI GRINDING - (Job Work Payment)	535	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2147	Ranjith - (Contractor Advance)	536	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2148	Ranjith - (Job Work Payment)	537	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2149	RAJA ACCOUNTANT - (Staff Advance)	538	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2150	RAJA ACCOUNTANT - (Staff Salary)	539	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2151	Diiser Helper - (Contractor Advance)	540	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2152	Diiser Helper - (Job Work Payment)	541	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2153	MUNISH - (Contractor Advance)	542	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2154	MUNISH - (Job Work Payment)	543	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2155	Sanjai Helper - (Job Work Payment)	546	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2156	GANESH (GRINDING) - (Contractor Advance)	547	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2157	GANESH (GRINDING) - (Job Work Payment)	548	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2158	PAPALU GRINDING - (Contractor Advance)	549	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2159	PAPALU GRINDING - (Job Work Payment)	550	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2160	ASIF GRINDING - (Contractor Advance)	551	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2161	ASIF GRINDING - (Job Work Payment)	552	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2162	RAMU GRINDING - (Contractor Advance)	553	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2163	RAMU GRINDING - (Job Work Payment)	554	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2164	VINOTH  CHIPPING - (Contractor Advance)	555	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2165	VINOTH  CHIPPING - (Job Work Payment)	556	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2166	PAINT	557	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2167	PRADEEP SINGH - (Contractor Advance)	558	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2168	PRADEEP SINGH - (Job Work Payment)	559	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2169	DIPTI - (Contractor Advance)	560	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2170	DIPTI - (Job Work Payment)	561	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2171	SARAVANAN (RAJA) - (Contractor Advance)	562	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2172	SARAVANAN (RAJA) - (Job Work Payment)	563	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2173	KRISHANAN (CHIPPING) - (Contractor Advance)	564	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2174	KRISHANAN (CHIPPING) - (Job Work Payment)	565	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2175	RAMESH CHIPPING - (Contractor Advance)	566	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2176	RAMESH CHIPPING - (Job Work Payment)	567	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2177	TEXMO INDUSTRIES (PUMP DIVISION)	568	113	Account	0.00	Dr			THUDIYALUR POST METTUPALAYAM ROAD	\N	\N	\N		33AABFT1899B1ZC	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2178	SELVALAKSHMI INDUSTRIES	569	113	Account	0.00	Dr			S.F NO26/1APPG NURSING COLLEGE BACKSIDE VKV KUMARAGURU NAGAR,KEERANATHAM ROAD,SARAVANAMPAT	\N	\N	\N		33AUBPK7362A1Z3	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2179	CHENNAI CAST ALLOYS	570	113	Account	0.00	Dr	9965405351	9965405351	498/1b2,1a2 BHARATHI STREET PUTTU THOTTAM,CHINNAVEDAMPATTI	\N	\N	\N		33AAVFC4616K1Z5	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2180	ASIAN FERRO CAST	571	113	Account	0.00	Dr			74,ATHIPALAYAM ROAD CHINNAVEDAMPATTI	\N	\N	\N		33ABMFA713B1ZX	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2181	SHRI MAHA VISHNU HI HEAT TREATER	572	113	Account	0.00	Dr			9/219 MASAGOUNDEN PALAYAM CHETTIPALAYAM POST KOVIL PALAYAM	\N	\N	\N		33DMKPS0705R1ZJ	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2182	MM TRADERS	573	113	Account	0.00	Dr			9/88-3,VIVEKANANDA NAGAR KURUMBAPALAYAM	\N	\N	\N		33AWWPD2196C1ZJ	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2183	SEENU INDUSTRIES	574	113	Account	0.00	Dr			24-A KK NAGAR,VG RAO NAGAR EB COLONY NEAR,GANAPATHY,	\N	\N	\N		33AWNPJ0817B1ZO	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2184	CONSTRUCATION EQUPIMENTS OWNERS ASSOCIATION	575	113	Account	0.00	Dr			SAMARPANIKA AUDITORIUM ATHIKODE	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2185	STAR ELETRICAL WOKS	576	113	Account	0.00	Dr			Sc/266 THANGAMMAL NAGAR LAKSHMIPURAM,GANAPATHY	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2186	MANDU - (Job Work Payment)	605	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2187	PALANISAMY (MELTER) - (Contractor Advance)	606	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2188	PALANISAMY (MELTER) - (Job Work Payment)	607	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2189	PRAMASIVAM (MELTER) - (Contractor Advance)	608	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2190	SURAN MODI HELPER - (Contractor Advance)	652	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2191	SURAN MODI HELPER - (Job Work Payment)	653	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2192	SUKHAN MODI HELPER - (Contractor Advance)	654	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2193	SUKHAN MODI HELPER - (Job Work Payment)	655	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2194	SUBHAM MODI HELPER - (Contractor Advance)	656	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2195	SUBHAM MODI HELPER - (Job Work Payment)	657	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2196	TAPAN MODI HELPER - (Contractor Advance)	658	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2197	TAPAN MODI HELPER - (Job Work Payment)	659	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2198	KAUTUKA MODI HELPER - (Contractor Advance)	660	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2199	KAUTUKA MODI HELPER - (Job Work Payment)	661	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2200	Kumar Modi Helper - (Contractor Advance)	662	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2201	Kumar Modi Helper - (Job Work Payment)	663	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2202	SANDRAM GRINDING - (Contractor Advance)	664	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2203	SANDRAM GRINDING - (Job Work Payment)	665	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2204	AKBAR GRINDING - (Contractor Advance)	666	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2205	AKBAR GRINDING - (Job Work Payment)	667	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2206	SURAJ  PAL GRINDING - (Contractor Advance)	668	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2207	SURAJ  PAL GRINDING - (Job Work Payment)	669	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2208	SRI KRISHNA FAFABRICATION	170	113	Account	0.00	Dr			334/1F SOMIYAMPALAYAM THADAGAM	\N	\N	\N	33436203005		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2209	KALYANASUNDRAM C - (Contractor Advance)	171	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2210	KALYANASUNDRAM C - (Job Work Payment)	172	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2211	ANBU SELVAM (GRINDING ) - (Contractor Advance)	175	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2212	ANBU SELVAM (GRINDING ) - (Job Work Payment)	176	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2213	SHRI EASWARA ENGINEERING COMPANY	179	113	Account	0.00	Dr			633,BETTATHAPURAM KARAMADAI POST	\N	\N	\N	33302030282		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2214	SOLAR FOUNDRY	180	113	Account	0.00	Dr			51,ARAVINDA NAGAR THADAGAM	\N	\N	\N	33596200201		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2215	M.Palaniswamy - (Staff Advance)	183	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2216	M.Palaniswamy - (Staff Salary)	184	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2217	CAN WATER	386	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2218	SELVAM	387	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2219	RAJAN  SALARY	388	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2220	OFFICE	389	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2221	Rajan  Grinding - (Contractor Advance)	390	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2222	Rajan  Grinding - (Job Work Payment)	391	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2223	Keerthi Room Rent	392	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2224	Mathi Driver - (Staff Advance)	393	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2225	Mathi Driver - (Staff Salary)	394	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2226	TEE Y LIFTING SOLUTIONS	395	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2227	ORIENT	396	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2228	GRINDING WHEEL	397	101	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2229	SRI SAKTHIVELAN INDUSTRIES	230	113	Account	0.00	Dr			SOMIYAMPALAYAM KNG PUDUR	\N	\N	\N	33496267671		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2230	ASHOK CONTRACT - (Contractor Advance)	231	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2231	ASHOK CONTRACT - (Job Work Payment)	232	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2232	SRI DHARSHINI MALLEABLE	233	113	Account	0.00	Dr	9843296216	9843296216	624/1A,THADAGAM ROAD AGARWALSCHOOL ROAD, SOMAYAMPALAYAM POST	\N	\N	\N	33636204156		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2233	ENBEST PUMPS INDIA PVT LTD	236	113	Account	0.00	Dr			NO,362/3,SOMAYAMPALAYAM COIMBATORE	\N	\N	\N	33286201380		\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2234	INTEGRA AUTOMATION PVT LTD UNIt IV	242	113	Account	0.00	Dr			S.F.NO238,KURUNALLIPALAYAM VILLAGE NEAR, KOTHAVAD VADACHITTUR VIA,	\N	\N	\N		33AAAC17412H1ZX	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2235	INTEGRA AUTOMATION PVT LTD METTUBAVI UNIT	243	113	Account	0.00	Dr			SF NO. 7, METULAKSHMINAYAKAMPALAYAM ROAD, METTUBAVI VILLAGE,KINATHUKAAVU TALUK,	\N	\N	\N		33AAACI7412H1ZX	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2236	SRI METAL	244	113	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2237	U CLAMP	398	101	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2238	GOPINATH - (Staff Advance)	399	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2239	GOPINATH - (Staff Salary)	400	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2240	RAVI CHANDRAN (GRINDING STONE)	401	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2241	RAJ KUMAR - (Contractor Advance)	402	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2242	RAJ KUMAR - (Job Work Payment)	403	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2243	PRAMASIVAM (MELTER) - (Job Work Payment)	609	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2244	RAJESH (MODI) - (Contractor Advance)	610	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2245	RAJESH (MODI) - (Job Work Payment)	611	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2246	MURUGESH (GRINDING) - (Contractor Advance)	612	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2247	SRI METAL PURCHASE	269	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2248	SM TRADERS	270	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2249	SARVAN  HINDI LABOUR	271	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2250	PINDHU KUMAR	272	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2251	SARVAN LABOUR	275	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2252	SARVAN HINDI  LABOUR - (Contractor Advance)	276	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2253	SARVAN HINDI  LABOUR - (Job Work Payment)	277	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2254	ANAND GRINDING1 - (Staff Advance)	281	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2255	ANAND GRINDING1 - (Staff Salary)	282	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2256	SARVAN GRINDING 1 - (Staff Advance)	283	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2257	SARVAN GRINDING 1 - (Staff Salary)	284	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2258	MURUGESH (GRINDING) - (Job Work Payment)	613	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2259	Dhanpathdass - (Contractor Advance)	614	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2260	Dhanpathdass - (Job Work Payment)	615	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2261	Anbu (Tea)	616	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2262	Sathish Skd - (Staff Advance)	617	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2263	Sathish Skd - (Staff Salary)	618	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2264	VM MINERALS	619	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2265	PRADEEP HELPER) MODI - (Contractor Advance)	620	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2266	PRADEEP HELPER) MODI - (Job Work Payment)	621	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2267	Rajiv (Father) - (Contractor Advance)	622	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2268	Rajiv (Father) - (Job Work Payment)	623	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2269	INDOTHERMTECHNOLOGIES	299	113	Account	0.00	Dr			2/55, MASAGOUNPUDUR,ELLAPALAYAM PO KATTAMPATTY	\N	\N	\N		33AAFF11997K1Z1	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2270	MAHALAKSHMI INDUSTRIES	302	113	Account	0.00	Dr			THIRUVASAKAM STREET VINAYAGAPURAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2271	33	305	113	Account	0.00	Dr	04222642484	04222642484	254/1,258/1,CHINNAKUYALI,KALLAPALAYAM(PO) ONDIPUDUR(VIA)	\N	\N	\N	33AADFA80281Z9	33AADFA8028P1Z9	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2272	BALU SCRAP	306	124	Account	0.00	Dr			UYIUYUIY UIYIUYI	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2273	CI BOARINGS	307	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2274	PASANTH KUMAR (PAINTER) - (Contractor Advance)	624	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2275	PASANTH KUMAR (PAINTER) - (Job Work Payment)	625	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2276	Acting Driver	626	111	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2277	SRIDHU MODI HELPER - (Contractor Advance)	627	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2278	SRIDHU MODI HELPER - (Job Work Payment)	628	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2279	BALA MODI HELPER - (Contractor Advance)	629	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2280	BALA MODI HELPER - (Job Work Payment)	630	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2281	MAKESH KISHNA HELPER - (Contractor Advance)	631	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2282	MAKESH KISHNA HELPER - (Job Work Payment)	632	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2283	INDRA DEV RAJIV HELPER - (Contractor Advance)	633	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2284	INDRA DEV RAJIV HELPER - (Job Work Payment)	634	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2285	DIAMOND EQUIPMENTS & ENGINEERS	635	113	Account	0.00	Dr	908790660	908790660	D.NO-17/2 BHARATHI NAGAR 4TH STREETKRISHNARAYAPURAM	\N	\N	\N		33BLPPM0067E1Z8	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2286	KRISHNA CCA - (Contractor Advance)	636	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2287	KRISHNA CCA - (Job Work Payment)	637	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2288	TANDEM ENTERPRISES	322	113	Account	0.00	Dr			SF 245/1 , ORAIKKALAPALAYAM ROAD KUNNATHUR, SS KULAM	\N	\N	\N		33AADFT0017H1ZQ	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2289	SHOTS	324	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2290	ANAND DRIVER - (Staff Advance)	404	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2291	ANAND DRIVER - (Staff Salary)	405	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2292	COMPUTER AND ACCESSORIES	406	101	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2293	RAJ KUMAR (COMPANY)	410	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2294	SELVAM (COMPANY)	411	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2295	ANKIT (COMPANY)	412	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2296	RAJESH RENT	638	108	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2297	DRINKING WATER	639	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2298	KAVITHA 1 - (Staff Advance)	640	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2299	KAVITHA 1 - (Staff Salary)	641	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2300	GUNA SELVAM - (Contractor Advance)	642	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2301	GUNA SELVAM - (Job Work Payment)	643	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2302	HARI HELPER - (Contractor Advance)	644	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2303	HARI HELPER - (Job Work Payment)	645	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2304	MAKESH DRIVER - (Contractor Advance)	646	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2305	MAKESH DRIVER - (Job Work Payment)	647	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2306	YAZHINI ENTERPRISES	648	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2307	GREEN ENERGY TRANSPORT	649	113	Account	0.00	Dr			PLOT NO 6,ROJA NAGAR FIRST STRET SILAPADAI	\N	\N	\N		33GMXPM5480D1ZK	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2308	JITHENDAR CCA - (Contractor Advance)	650	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2309	JITHENDAR CCA - (Job Work Payment)	651	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2310	SANJEEV (COMPANY)	413	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2311	JANARTHAN	414	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2312	LAKSHMI (COMPANY)	415	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2313	SANJEEV - (Contractor Advance)	416	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2314	SANJEEV - (Job Work Payment)	417	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2315	JANARTHAN (COMPANY) - (Contractor Advance)	418	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2316	JANARTHAN (COMPANY) - (Job Work Payment)	419	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2317	LAKSHMI - (Contractor Advance)	420	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2318	LAKSHMI - (Job Work Payment)	421	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2319	RAHUL - (Staff Advance)	422	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2320	RAHUL - (Staff Salary)	423	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2321	RANJITHA - (Staff Advance)	424	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2322	RANJITHA - (Staff Salary)	425	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2323	MARIMUTHU (WATCH MAN) - (Contractor Advance)	426	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2324	MARIMUTHU (WATCH MAN) - (Job Work Payment)	427	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2325	MARIMUTHU - (Staff Advance)	428	115	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2326	MARIMUTHU - (Staff Salary)	429	129	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2327	M.D. CHAND	431	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2328	VENKATESH GRINDING - (Contractor Advance)	432	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2329	VENKATESH GRINDING - (Job Work Payment)	433	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2330	EASWAR (BRINDAR) - (Contractor Advance)	434	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2331	EASWAR (BRINDAR) - (Job Work Payment)	435	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2332	KABU - (Contractor Advance)	436	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2333	KABU - (Job Work Payment)	437	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2334	RAJESH - (Contractor Advance)	438	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2335	RAJESH - (Job Work Payment)	439	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2336	AJITH KUMAR - (Contractor Advance)	440	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2337	AJITH KUMAR - (Job Work Payment)	441	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2338	SELVAM LABOUR - (Contractor Advance)	442	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2339	SELVAM LABOUR - (Job Work Payment)	443	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2340	DEEPAK LABOUR - (Contractor Advance)	444	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2341	DEEPAK LABOUR - (Job Work Payment)	445	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2342	IBHARIM - (Contractor Advance)	446	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2343	IBHARIM - (Job Work Payment)	447	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2344	VENKATESH LABOUR - (Contractor Advance)	448	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2345	VENKATESH LABOUR - (Job Work Payment)	449	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2346	PRABU LABOUR - (Contractor Advance)	450	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2347	PRABU LABOUR - (Job Work Payment)	451	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2348	SELVAM (SHIVA) - (Contractor Advance)	453	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2349	SELVAM (SHIVA) - (Job Work Payment)	454	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2350	AJEES A/C MECHANIC	455	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2351	SELVAM AQUA SUB	456	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2352	BABU AGENCIES	457	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2353	SRI SAKTHI VADIVELAN INDUSTRIES	479	113	Account	0.00	Dr			399/1B SOMAYAMPALAYAM THADAGAM ROAD	\N	\N	\N		33AEXPA2369F1ZH	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2354	AIRWA	480	113	Account	0.00	Dr			367,V.K ROAD, THANNERPANDAL PEELAMEDU	\N	\N	\N		33DADPS8282N1ZZ	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2355	MAHABULLA HINDI LABOUR	482	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2356	MAHABULLA HINDHI LABOUR - (Contractor Advance)	483	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2357	MAHABULLA HINDHI LABOUR - (Job Work Payment)	484	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2358	SANTHOSH (WATER)	485	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2359	DHARSAHINI MANABALES	486	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2360	HOISTER	487	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2361	FAN	488	128	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2362	SANJAI SAMY HINDHI CONTRACTOR	489	127	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2363	ARUN - (Contractor Advance)	490	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2364	ARUN - (Job Work Payment)	491	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2365	JAYARAM - (Contractor Advance)	492	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2366	JAYARAM - (Job Work Payment)	493	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2367	MUNISHWARAN - (Contractor Advance)	494	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2368	MUNISHWARAN - (Job Work Payment)	495	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2369	MURALI - (Contractor Advance)	496	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2370	MURALI - (Job Work Payment)	497	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2371	ROHIT - (Contractor Advance)	498	116	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2372	ROHIT - (Job Work Payment)	499	130	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.115437+00	2026-08-03 15:18:57.115437+00
2373	MARI MUTHU RAMAKRISHNAN	CON_1	116	Contractor	0.00	Dr			8/181, DEVARAJ NAGAR, KEERANATHAM PUDHU PALAYAM	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2374	PINTHU KUMAR	CON_4	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2375	KHAJA	CON_20	116	Contractor	0.00	Dr	9655744542	9655744542	64 E ,KARAMBU KADAI, CHERAN NAGAR	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2376	PINDU KUMAR	CON_22	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2377	SRI METALS	CON_23	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2378	KRISHANA    GRINDING	CON_68	116	Contractor	0.00	Dr	6387378764	6387378764		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2379	MADHAN GRINDING	CON_69	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2380	ARUMUGAM GRINDING	CON_70	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2381	Deepak Helper	CON_71	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2382	KOUSAL	CON_72	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2383	KARTHICK GRINDING	CON_73	116	Contractor	0.00	Dr	9787130680	9787130680	18, RAMASWAMY GOUNDER STREET RATHINAPURI	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2384	Ankit Kumar	CON_74	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2385	Manish Kumar	CON_75	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2386	Dinanath Kumar	CON_76	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2387	Ramesh Contract	CON_77	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2388	Kasi Muthu	CON_78	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2389	SELVAM (GRINDING)	CON_79	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2390	ANKIT (LABOUR)	CON_80	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2391	Rajan  Grinding	CON_81	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2392	RAJ KUMAR	CON_82	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2393	CHANDRU (CHIPPING)	CON_83	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2394	SANJEEV	CON_84	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2395	JANARTHAN (COMPANY)	CON_85	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2396	LAKSHMI	CON_86	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2397	MARIMUTHU (WATCH MAN)	CON_87	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2398	KANNAN GRINDING	CON_155	116	Contractor	0.00	Dr	7339505806	7339505806		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2399	ARUMUGAM GRINDING NEW	CON_156	116	Contractor	0.00	Dr	9363132301	9363132301		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2400	MANDU	CON_157	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2401	PALANISAMY (MELTER)	CON_158	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2402	PRAMASIVAM (MELTER)	CON_159	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2403	RAJESH (MODI)	CON_160	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2404	MURUGESH (GRINDING)	CON_161	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2405	Dhanpathdass	CON_162	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2406	PRADEEP HELPER) MODI	CON_163	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2407	Rajiv (Father)	CON_164	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2408	PASANTH KUMAR (PAINTER)	CON_165	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2409	SRIDHU MODI HELPER	CON_166	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2410	BALA MODI HELPER	CON_167	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2411	MAKESH KISHNA HELPER	CON_168	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2412	INDRA DEV RAJIV HELPER	CON_169	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2413	KRISHNA CCA	CON_170	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2414	GUNA SELVAM	CON_171	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2415	HARI HELPER	CON_172	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2416	MAKESH DRIVER	CON_173	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2417	JITHENDAR CCA	CON_174	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2418	SURAN MODI HELPER	CON_175	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2419	SUKHAN MODI HELPER	CON_176	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2420	SUBHAM MODI HELPER	CON_177	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2421	TAPAN MODI HELPER	CON_178	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2422	KAUTUKA MODI HELPER	CON_179	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2423	RAMESH GRINDING	CON_29	116	Contractor	0.00	Dr	7305787077	7305787077		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2424	SAKTHIVEL	CON_34	116	Contractor	0.00	Dr	9943108008	9943108008	3/6A ALMARA STREET PERUR	\N	\N	\N	\N	\N	\N	99431	\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2425	KUMAR	CON_35	116	Contractor	0.00	Dr	8012641226	8012641226	5/291,KUPPANAICKEN PALAYAM SOMAYAMPALAYAM	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2426	P.MAHAKRISHNAN	CON_36	116	Contractor	0.00	Dr	9842008293	9842008293	BOMMIAMMAN KOVIL STREET POMMANAMPALAYAM	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2427	KALYANASUNDRAM C	CON_40	116	Contractor	0.00	Dr	96773557744	96773557744	82-6-777,,MANADAKAPADI STREET AYIIKUDY	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2428	ANBU SELVAM (GRINDING )	CON_42	116	Contractor	0.00	Dr	8973884677	8973884677		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2429	VENKATESH GRINDING	CON_88	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2430	EASWAR (BRINDAR)	CON_89	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2431	KABU	CON_90	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2432	RAJESH	CON_91	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2433	AJITH KUMAR	CON_92	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2434	SELVAM LABOUR	CON_93	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2435	DEEPAK LABOUR	CON_94	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2436	IBHARIM	CON_95	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2437	VENKATESH LABOUR	CON_96	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2438	PRABU LABOUR	CON_97	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2439	SELVAM (SHIVA)	CON_98	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2440	ANKIT KUMAR (BRIENDAR)	CON_99	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2441	MANIKANDAN (GRINDING)	CON_100	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2442	RAGUL (BRINDER)	CON_101	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2443	ANAND (GRINDING)	CON_102	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2444	SURAJ (HINDI)	CON_103	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2445	MD INTHA(HINDI)	CON_104	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2446	SIVAGURUNATHAN	CON_105	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2447	SHAKIL (HINDI)	CON_106	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2448	MADHAN LABOUR	CON_129	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2449	JABAR LABOUR	CON_130	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2450	RAVI GRINDING	CON_131	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2451	Ranjith	CON_132	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2452	Diiser Helper	CON_133	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2453	MUNISH	CON_134	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2454	Sanjai Helper	CON_135	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2455	GANESH (GRINDING)	CON_136	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2456	PAPALU GRINDING	CON_137	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2457	ASIF GRINDING	CON_138	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2458	RAMU GRINDING	CON_139	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2459	VINOTH  CHIPPING	CON_140	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2460	PRADEEP SINGH	CON_141	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2461	DIPTI	CON_142	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2462	SARAVANAN (RAJA)	CON_143	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2463	KRISHANAN (CHIPPING)	CON_144	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2464	RAMESH CHIPPING	CON_145	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2465	SELVAM (MELTER)	CON_146	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2466	RAJIV (MELTER)	CON_147	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2467	SANKAR (SELVAM MELTER)	CON_148	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2468	GANESH (MARI MUTHU) HELPER	CON_149	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2469	MODI HELPER	CON_150	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2470	SKD SATHISH	CON_151	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2471	SURESH DRIVER	CON_152	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2472	JITHENDAR GRINDING	CON_153	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2473	Indra Kumar(Grinding)	CON_154	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2474	Kumar Modi Helper	CON_180	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2475	SANDRAM GRINDING	CON_181	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2476	AKBAR GRINDING	CON_182	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2477	SURAJ  PAL GRINDING	CON_183	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2478	ASHOK CONTRACT	CON_60	116	Contractor	0.00	Dr	9994640518	9994640518	15,VADUKUTHOTTAM,	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2479	ANAND GRINDING	CON_63	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2480	SARVAN GRINDIND	CON_64	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2481	AUGISTIAN	CON_65	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2482	MARI MUTHU GRINDING	CON_66	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2483	SARVAN HINDI  LABOUR	CON_67	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2484	GURU (CRANE)	CON_107	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2485	MAHABULLA HINDHI LABOUR	CON_108	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2486	ARUN	CON_109	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2487	JAYARAM	CON_110	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2488	MUNISHWARAN	CON_111	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2489	MURALI	CON_112	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2490	ROHIT	CON_113	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2491	MADHESWARAN	CON_114	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2492	SATHISH	CON_115	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2493	MOHAMAAD	CON_116	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2494	THESER HINDHI HELPER	CON_117	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2495	MOHAMAAD NAZUREL	CON_118	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2496	PRAWEZ ALAM	CON_119	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2497	MAKESH HELPER	CON_120	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2498	ANITHA HELPER	CON_121	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2499	DHANANJAY	CON_122	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2500	ISRAFUL	CON_123	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2501	GOBI NATH	CON_124	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2502	SARDAR	CON_125	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2503	MD CHAND	CON_126	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2504	ANYAR RAIN	CON_127	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2505	SADAM LABOUR	CON_128	116	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.568619+00	2026-08-03 15:18:57.568619+00
2506	V.KAVITHA	STF_1	100	Staff	0.00	Dr	9976073013	9976073013	4T1, PERMAL LAYOUR KATTOR	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2507	SHIVA KUMAR	STF_2	100	Staff	0.00	Dr			SOWRIMUTHU CHETTIYAR RED FIELD	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2508	GAJARAJ	STF_3	100	Staff	0.00	Dr	8903649728	8903649728	7/9, PERMAL KOVIL , NAICKNUR, 4 VEERAPANDI,PRESS COLONY PO	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2509	THAMBI DURAI	STF_6	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2510	M.Palaniswamy	STF_7	100	Staff	0.00	Dr	7200399068,8220408405	7200399068,8220408405	5/14,Vinayagarkovil Street, Sengalipalayam,Nggo Colony Post	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2511	T.SATHISH KUMAR	STF_8	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2512	ANAND GRINDING1	STF_9	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2513	SARVAN GRINDING 1	STF_10	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2514	BABU RAJESH	STF_11	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2515	Babu Driver	STF_12	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2516	Mathi Driver	STF_13	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2517	GOPINATH	STF_14	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2518	ANAND DRIVER	STF_15	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2519	RAHUL	STF_16	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2520	RANJITHA	STF_17	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2521	MARIMUTHU	STF_18	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2522	RAJA ACCOUNTANT	STF_19	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2523	Sathish Skd	STF_20	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
2524	KAVITHA 1	STF_21	100	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 15:18:57.692981+00	2026-08-03 15:18:57.692981+00
\.


--
-- Data for Name: processes; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.processes (id, name, process_code, product_id, sequence, company_rate, contractor_rate, gst_percent, description, is_active, created_at) FROM stdin;
14	Chipping	12	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
15	SBL/FET//GPP	14	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
16	TRANSPORT	544	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
17	Return	5	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
18	SBL	6	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
19	FET	7	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
20	GPP	9	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
21	PRM	10	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
22	SBL/GPP	216	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
23	SBL/FET	371	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
24	SCRAP	452	\N	0	0.0000	0.0000	0.00		t	2026-08-03 15:18:58.448489+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.products (id, name, product_code, description, uom_id, weight, is_active, created_at, updated_at) FROM stdin;
3103	Scrap-Waste Materials	1	\N	\N	0.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3104	CGC051-CASING	2	\N	\N	8.330	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3105	CGC052-CASING	3	\N	\N	9.164	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3106	CGH100-CASING	4	\N	\N	10.170	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3107	GBS015-MOTOR BASE	5	\N	\N	5.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3108	GBS019-MOTOR BASE	6	\N	\N	0.950	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3109	RCG011-REAR COVER	7	\N	\N	3.040	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3110	YOH044-YOKE	8	\N	\N	6.160	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3111	CDF022-COVER DOME	9	\N	\N	5.073	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3112	CDF027-COVER DOME	10	\N	\N	8.850	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3113	GBS003-MOTOR BASE	11	\N	\N	0.870	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3114	GBS021-MOTOR BASE	12	\N	\N	1.924	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3115	RCG005-REAR COVER	13	\N	\N	3.346	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3116	GOS007-TOP HOUSING	14	\N	\N	6.070	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3117	BDF005-TSM MOTOR BODY	15	\N	\N	10.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3118	DBS061-BOTTOM HOUSING	16	\N	\N	2.340	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3119	CGH090-CASING	17	\N	\N	9.910	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3120	SKA008-STRAINER BRACKET	18	\N	\N	1.340	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3121	CDA005-CASING	19	\N	\N	5.876	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3122	RCF001-REAR COVER	20	\N	\N	1.431	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3123	RCH005-REAR COVER	21	\N	\N	4.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3124	CGH085-CASING	22	\N	\N	9.345	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3125	DHA001-DIFFFUSER HOUSING	23	\N	\N	1.366	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3126	DHC005-DIFFUSER HOUSING	24	\N	\N	1.795	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3127	RCI004-REAR COVER	25	\N	\N	7.110	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3128	BOI001-BODY	26	\N	\N	37.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3129	FTA008-FRONT COVER	27	\N	\N	11.370	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3130	BDF007-TSM MOTOR BODY	28	\N	\N	11.610	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3131	GOS023-TOP HOUSING	29	\N	\N	5.314	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3132	FSK001-FAN SHIELD	30	\N	\N	3.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3133	DHA001-DIFFUSER HOUSING	31	\N	\N	1.376	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3134	DHC005-DIFFFUSER HOUSING	32	\N	\N	1.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3135	BDA008-TSM MOTOR BODY	33	\N	\N	16.310	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3136	DBS072-TOP HOUSING	34	\N	\N	1.180	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3137	ECA008-END COVER	35	\N	\N	5.196	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3138	FSL001-FAN SHIELD	36	\N	\N	4.552	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3139	GBS020-TRUST INSERT	37	\N	\N	0.840	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3140	ECA007-END COVER	38	\N	\N	5.434	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3141	FNA017-FAN	39	\N	\N	3.238	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3142	DHC008-DIFFUSER HOUSING	40	\N	\N	1.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3143	IMI017-IMPELLER	41	\N	\N	2.325	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3144	SKA009-STRAINER BRACKET	42	\N	\N	1.240	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3145	YOS008-YOKE	43	\N	\N	10.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3146	GGS001-BOTTOM HOUSING	44	\N	\N	4.830	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3147	FTC009-FRONT COVER	45	\N	\N	8.207	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3148	FTC011-FRONT COVER	46	\N	\N	5.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3149	RCE001-REAR COVER	47	\N	\N	1.430	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3150	RCK001-REAR COVER	48	\N	\N	4.930	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3151	RCL001-REAR COVER	49	\N	\N	8.544	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3152	BDA010-TSM MOTOR BODY	50	\N	\N	12.580	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3153	DHA003-DIFFUSER HOUSING	51	\N	\N	3.306	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3154	YOS003-YOKE	52	\N	\N	7.902	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3155	BDC019-MOTOR BODY	53	\N	\N	8.290	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3156	BDF006-MOTOR BODY	54	\N	\N	9.973	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3157	CGH084-OH40Q CASING	55	\N	\N	9.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3158	CGH087 -1H65Q CASING	56	\N	\N	9.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3159	CGH088- 2H50Q CASING	57	\N	\N	10.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3160	GH091-2H65AQ CASING	58	\N	\N	10.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3161	CGH093-2H75Q CASING	59	\N	\N	15.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3162	CGH091-2H65AQ CASING	60	\N	\N	10.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3163	CGH098-1H75Q S185 CASING	61	\N	\N	14.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3164	CGH086-1H50Q CASING	62	\N	\N	8.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3165	FCG001-FRONT COVER	63	\N	\N	2.869	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3166	CGH101-4H50Q CASING	64	\N	\N	15.580	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3167	FSG001-FAN SHIELD	65	\N	\N	2.020	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3168	RAK009-REAR COVER	66	\N	\N	5.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3169	YOH006-YOKE	67	\N	\N	3.560	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3170	YOS002-YOKE	68	\N	\N	7.490	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3171	BDB001-TSM MOTOR BODY	69	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3172	BDF003-TSM MOTOR BODY	70	\N	\N	12.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3173	DBS064-TOP HOUSING	72	\N	\N	1.810	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3174	RAK007-REAR COVER	73	\N	\N	6.416	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3175	FTM007-FRONT COVER	74	\N	\N	10.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3176	FTM008-FRONT COVER	75	\N	\N	9.457	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3177	CGC015-7025 CASING	76	\N	\N	3.724	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3178	FTM010- FRONT COVER	77	\N	\N	8.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3179	CGC054-50Q CASING	78	\N	\N	5.256	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3180	HIS015-INLET BRACKET	79	\N	\N	9.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3181	HIS106-INLET BRACKET	80	\N	\N	4.410	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3182	IBA001-CASING	81	\N	\N	1.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3183	CDK004-COVER DOME	82	\N	\N	5.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3184	CGH105-3H40SQ CASING	83	\N	\N	12.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3185	GPS002-CABLE BOX	84	\N	\N	6.890	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3186	HIS001-INLRT BRACKET	85	\N	\N	4.730	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3187	DHA002-DIFFUSER HOUSING	86	\N	\N	1.656	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3188	FCF006-FRONT COVER	87	\N	\N	1.736	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3189	GGS006-BOTTOM HOUSING	88	\N	\N	5.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3190	BDF006-TSM M OTOR BODY	89	\N	\N	11.610	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3191	MS PALLET	90	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3192	SHOTBLSTING	91	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3193	CGC053- SM 40Q CASING	92	\N	\N	4.728	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3194	FTC008-FRONT COVER	93	\N	\N	5.845	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3195	HCA001-DELIVERY CHAMBER	94	\N	\N	5.257	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3196	DBS071-TOP HOUSING	95	\N	\N	1.574	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3197	RCE003-REAR COVER	96	\N	\N	1.531	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3198	DHA005-DIFFUSER HOUSING	97	\N	\N	1.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3199	IMI008-IMPELLER	98	\N	\N	3.676	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3200	IMS009-IMPELLER	99	\N	\N	3.836	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3201	RUNNER	100	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3202	CGC044-CASING	101	\N	\N	5.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3203	HPS045-PUMP HOUSING	102	\N	\N	2.182	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3204	RAC006-REAR COVER	103	\N	\N	4.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3205	CGH099-CASING	104	\N	\N	6.010	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3206	BDB004-TSM MOTOR BODY	105	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3207	BDD002-VSM MOTOR BODY	106	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3208	BDE003-VSM MOTOR BODY	107	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3209	CASING  ASM 30J	108	\N	\N	8.531	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3210	BDA011-TSM MOTOR BODY	109	\N	\N	14.122	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3211	CGCF016-CASING	110	\N	\N	8.440	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3212	FNA019-FAN	111	\N	\N	0.978	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3213	CGC016-CASING	112	\N	\N	8.440	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3214	IMI049-IMPELLER	113	\N	\N	3.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3215	CDK001-COVER DOME	114	\N	\N	5.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3216	DHC016-DIFFUSER HOUSING	115	\N	\N	4.090	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3217	FCI002-FRONT COVER	116	\N	\N	5.360	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3218	BDC017-MOTOR BODY	117	\N	\N	7.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3219	CGC017-CASING	118	\N	\N	5.020	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3220	FCG003-FRONT COVER	119	\N	\N	2.268	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3221	HCS006-DELLIVERY CASING	120	\N	\N	2.292	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3222	ECC002-MOTOR BASE	121	\N	\N	5.730	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3223	FTC007-FRONT COVER	122	\N	\N	4.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3224	RAB001-REAR COVER	123	\N	\N	10.458	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3225	IMH086-IMPELLER	124	\N	\N	4.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3226	TCH001-TERMINAL BOX COVER	125	\N	\N	0.507	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3227	IMH060 -H14/H18 IMPELLER	126	\N	\N	3.776	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3228	IMI017-H30 IMPELLER	127	\N	\N	2.405	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3229	IMI027-IMPELLER	128	\N	\N	3.520	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3230	TXH001-TEMINAL BOX	129	\N	\N	0.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3231	FTB001-FRONT COVER	130	\N	\N	16.975	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3232	FTC004-FRONT COVER	131	\N	\N	4.481	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3233	CGH089-CASING	132	\N	\N	11.030	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3234	TCG001-TERMINAL BOX COVER	133	\N	\N	0.411	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3235	CGH103-5H65Q CASING	134	\N	\N	18.320	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3236	GBS023- MOTORBASE	135	\N	\N	5.980	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3237	RAA003-REAR COVER	136	\N	\N	8.515	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3238	RCK002-REAR COVER	137	\N	\N	5.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3239	FSF005-FAN SHIELD	138	\N	\N	1.910	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3240	FTC016-FRONT COVER	139	\N	\N	4.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3241	YOH038-YOKE	140	\N	\N	5.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3242	HIS034-INLET BRACKET	141	\N	\N	3.550	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3243	HIS026-INLET BRACKET	142	\N	\N	1.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3244	IBA002 - CASING	143	\N	\N	1.767	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3245	BDE001-VSM MOTOR BODY	144	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3246	IMI034-IMPELLER	145	\N	\N	4.350	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3247	IMI043-IMPELLER	146	\N	\N	2.550	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3248	IMK005-IMPELLER	147	\N	\N	1.226	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3249	FCF003-FRONT COVER	148	\N	\N	2.142	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3250	FCH003-FRONT COVER	149	\N	\N	3.322	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3251	IMH071-IMPELLER	150	\N	\N	4.420	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3252	IMI005-IMPELLER	151	\N	\N	4.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3253	IMI050-IMPELLER	152	\N	\N	2.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3254	BDD001-VSM MOTOR BODY	153	\N	\N	15.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3255	BDE005-MOTOR BODY	154	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3256	BFI001- CASING	155	\N	\N	3.622	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3257	HCA009-DELIVERY CHAMBER	156	\N	\N	1.430	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3258	IMJ069-IMPELLER	157	\N	\N	0.863	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3259	HIS102-INLET BRACKET	158	\N	\N	1.244	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3260	IMH068-IMPELLER	159	\N	\N	2.817	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3261	IMH090-IMPELLER	160	\N	\N	2.608	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3262	FLS039-FLANGE SQUARE	161	\N	\N	0.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3263	IMH003-IMPELLER	162	\N	\N	2.907	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3264	HCS178-DELIVERY CASING	163	\N	\N	1.936	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3265	RCF005-REAR COVER	164	\N	\N	2.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3266	RCG001-REAR COVER	165	\N	\N	2.151	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3267	RCG008-REAR COVER	166	\N	\N	2.092	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3268	IMH097- IMPELLER	167	\N	\N	3.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3269	RAC002-REAR COVER	168	\N	\N	3.220	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3270	HIS111-INLET BRACKET	169	\N	\N	4.902	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3271	CGH092-2H65SQ CASING	170	\N	\N	11.642	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3272	IMI045-IMPELLER	171	\N	\N	2.884	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3273	HIS002-INLET BRACKET	172	\N	\N	3.448	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3274	BDD003-VSM BODY	173	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3275	GBS012-MOTOR BASE	174	\N	\N	0.615	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3276	IMS004-S13 IMPELLER	175	\N	\N	6.475	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3277	FTA010-FRONT COVER	176	\N	\N	13.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3278	BOK003-BODY	177	\N	\N	31.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3279	FTA007-FRONT COVER	178	\N	\N	10.370	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3280	FTM009-FRONT COVER	179	\N	\N	11.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3281	IMH030-IMPELLER	180	\N	\N	3.037	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3282	IMC008-IMPELLER	181	\N	\N	1.256	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3283	IMJ070-IMPELLER	182	\N	\N	0.803	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3284	FTC015-FRONT COVER	183	\N	\N	5.550	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3285	HES128-BOWL	184	\N	\N	4.950	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3286	IMC016-IMPELLER	185	\N	\N	1.794	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3287	IMC042-IMPELLER	186	\N	\N	1.350	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3288	IMI16-IMPELLER	187	\N	\N	2.337	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3289	IMI016-IMPELLER	188	\N	\N	2.337	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3290	DHC004-DIFFUSER HOUSING	189	\N	\N	6.006	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3291	IMH014-IMPELLER	190	\N	\N	2.407	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3292	IMH022-IMPELLER	191	\N	\N	1.850	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3293	IMI032-IMPELLER	192	\N	\N	2.540	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3294	IMO019-IMPELLER	193	\N	\N	4.270	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3295	IMS033-IMPELLER	194	\N	\N	5.208	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3296	IMH055-IMPELLER	195	\N	\N	3.160	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3297	IMS005-IMPELLER	196	\N	\N	5.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3298	IMH069-IMPELLER	197	\N	\N	2.990	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3299	BOS003-BODY	198	\N	\N	10.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3300	FTM006-FRONT COVER	199	\N	\N	10.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3301	BDA009-MOTOR BODY	200	\N	\N	11.870	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3302	FSH001-FAN SHIELD	201	\N	\N	4.046	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3303	IMS002-IMPELLER	202	\N	\N	6.273	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3304	DBS055-BOTTOM HOUSING	203	\N	\N	2.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3305	HES123-BOWL	204	\N	\N	4.370	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3306	HES133-BOWL	205	\N	\N	4.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3307	BDH001-VSM BODY	206	\N	\N	10.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3308	IMC052-IMPELLER	207	\N	\N	1.750	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3309	IMH091-IMPELLER	208	\N	\N	2.110	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3310	BDC016-MOTOR BODY	209	\N	\N	7.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3311	IMI009-IMPELLER	210	\N	\N	3.068	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3312	BDH002-VSM MOTORBODY	211	\N	\N	8.560	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3313	HIS010-INLET BRACKET	212	\N	\N	1.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3314	YOS022-YOKE	213	\N	\N	6.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3315	FLC009-FLANGE	214	\N	\N	2.039	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3316	BDC007-CAP	215	\N	\N	0.440	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3317	FSF001-FAN SHIELD	216	\N	\N	1.731	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3318	HPS039-PUMP HOUSING	217	\N	\N	2.848	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3319	IMI018-IMPELLER	218	\N	\N	2.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3320	IMI021-IMPELLER	219	\N	\N	1.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3321	IMI022-IMPELLER	220	\N	\N	2.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3322	CGS022-CASING	221	\N	\N	13.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3323	IMI090-IMPELLER	222	\N	\N	2.608	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3324	IMI052-IMPELLER	223	\N	\N	3.459	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3325	IMS014-IMPELLER	224	\N	\N	4.422	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3326	YOH001-YOKE	225	\N	\N	2.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3327	IMI048-IMPELLER	226	\N	\N	2.930	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3328	IMH051-IMPELER	227	\N	\N	4.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3329	BCB011-CAP	228	\N	\N	0.342	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3330	HNS017-NVR SEAT RETAINER	229	\N	\N	0.499	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3331	YOH012-YOKE	230	\N	\N	6.432	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3332	IMI031-IMPELLER	231	\N	\N	2.946	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3333	YOC002-YOKE	232	\N	\N	2.713	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3334	IMH004-IMPELLER	233	\N	\N	3.108	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3335	IMH076 - IMPELLER	234	\N	\N	3.065	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3336	IMH095- IMPELLER	235	\N	\N	3.211	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3337	IMI003-IMPELLER	236	\N	\N	4.909	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3338	IMS031-IMPELLER	237	\N	\N	5.750	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3339	CDB003-COVER DOME	238	\N	\N	9.960	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3340	GGAS001-CAP	239	\N	\N	0.411	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3341	GAS001-CAP	240	\N	\N	0.411	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3342	IMS015-IMPELLER	241	\N	\N	4.325	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3343	ECA006-END COVER	242	\N	\N	4.989	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3344	IMH015-IMPELLER	243	\N	\N	3.560	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3345	YOS010-YOKE	244	\N	\N	10.298	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3346	YOS011-YOKE	245	\N	\N	9.912	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3347	IMH017-IMPELLER	246	\N	\N	4.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3348	IMI028-IMPELLER	247	\N	\N	4.950	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3349	IMS003-IMPELLER	248	\N	\N	5.528	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3350	YOH016-YOKE	249	\N	\N	7.676	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3351	IMH026-IMPELLER	250	\N	\N	2.930	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3352	YOS021--YOKE	251	\N	\N	6.658	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3353	RCG009-REAR COVER	252	\N	\N	2.040	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3354	FCF008-FRONT COVER	253	\N	\N	1.858	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3355	RCF012-REAR COVER	254	\N	\N	1.985	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3356	RCG014-REAR COVER	255	\N	\N	5.804	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3357	ECA002-END COVER	256	\N	\N	6.508	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3358	ECB001-END COVER	257	\N	\N	4.996	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3359	IMH073-IMPELLER	258	\N	\N	4.750	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3360	YOH009-YOKE	259	\N	\N	5.760	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3361	IMH035-IMPELLER	260	\N	\N	2.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3362	RAA002-REAR COVER	261	\N	\N	8.959	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3363	GBS058-BOTTOM HOUSING	262	\N	\N	2.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3364	DBS058-BOTTOM HOUSING	263	\N	\N	2.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3365	IMH062-IMPELLER	264	\N	\N	3.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3366	IMK002-IMPELLER	265	\N	\N	1.413	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3367	IMH054-IMPELLER	266	\N	\N	3.857	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3368	YOS009-YOKE	267	\N	\N	9.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3369	FCF005-CASIING COVER	268	\N	\N	2.004	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3370	FTM011-FRONT COVER	269	\N	\N	8.160	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3371	IMC006-IMPELLER	270	\N	\N	1.787	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3372	IMC025-IMPELLER	271	\N	\N	1.386	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3373	IMK003-IMPELLER	272	\N	\N	1.193	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3374	HIS038-INLET BRACKET	273	\N	\N	0.851	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3375	DBS040-BOTTOM HOUSING	274	\N	\N	1.128	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3376	FCH002-FRONT COVER	275	\N	\N	3.308	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3377	CDK003-COVER DOME	276	\N	\N	6.060	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3378	IMC007-IMPELLER	277	\N	\N	1.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3379	FLS027-FLANGE	278	\N	\N	1.307	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3380	IMI035-IMPELLER	279	\N	\N	0.873	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3381	HCA002-REAR COVER	280	\N	\N	7.020	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3382	IMI044-IMPELLER	281	\N	\N	10.514	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3383	GAS011-REAR CAP	282	\N	\N	0.205	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3384	HCS158-SHELL DELIVERYCASING	283	\N	\N	2.514	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3385	RCK004 - REAR COVER	284	\N	\N	5.630	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3386	BON008-BODY	285	\N	\N	6.280	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3387	CDA010-COVER DOME	286	\N	\N	9.070	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3388	BDC015-MOTOR BODY	287	\N	\N	5.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3389	BOG008-BODY	288	\N	\N	15.870	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3390	CDB002-COVER DOME	289	\N	\N	11.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3391	IMH058-IMPELLER	290	\N	\N	2.210	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3392	IMH100-IMPELLER	291	\N	\N	2.560	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3393	IMC002-IMPELLER	292	\N	\N	1.610	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3394	IMH059-IMPELLER	293	\N	\N	1.520	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3395	CGC055-CASING	294	\N	\N	5.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3396	GAS005-CAP	295	\N	\N	0.436	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3397	FNA034-FAN	296	\N	\N	4.898	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3398	IMI020-IMPELLER	297	\N	\N	2.530	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3399	HIS087-INLET BRACKET	298	\N	\N	1.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3400	IAA002-CHAMBER	299	\N	\N	3.938	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3401	IMI007- IMPELLER	300	\N	\N	3.180	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3402	IMH096- IMPELLER	301	\N	\N	2.434	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3403	YOH019-YOKE	302	\N	\N	10.346	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3404	GBS007-THRUST INSERT	303	\N	\N	0.674	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3405	HCA008-DELIVERY CHAMBER	304	\N	\N	1.504	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3406	IMC056-IMPELLER	305	\N	\N	2.268	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3407	IML002-IMPELLER	306	\N	\N	1.068	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3408	GPS006-CABLE BOX	307	\N	\N	2.960	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3409	IMH033-IMPELLER	308	\N	\N	3.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3410	IMH070-IMPELLER	309	\N	\N	5.134	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3411	DHC001-DIFFUSER	310	\N	\N	1.880	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3412	IMI026-IMPELLER	311	\N	\N	3.360	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3413	IMI025-IMPELLER	312	\N	\N	3.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3414	IMI056-IMPELLER	313	\N	\N	3.463	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3415	IMO021-IMPELLER	314	\N	\N	2.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3416	CGH095-3H65 Q CASING	315	\N	\N	13.330	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3417	IMH019-IMPELLER	316	\N	\N	3.890	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3418	HIS103-INLETBRACKET	317	\N	\N	1.084	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3419	IMH0080-IMPELLER	318	\N	\N	5.288	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3420	IMH080-IMPELLER	319	\N	\N	5.288	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3421	IPB00I- INTERMIDATE PLATE	320	\N	\N	6.342	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3422	IPB003-INTERMIDATE PLATE	321	\N	\N	9.178	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3423	IPB001- INTERMIDATE PLATE	322	\N	\N	6.342	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3424	SKA010- STRAINER BRACKET	323	\N	\N	1.573	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3425	CGS020-1S100 Q CASING	324	\N	\N	21.414	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3426	CGH014--2H65A CASING	325	\N	\N	12.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3427	FLO004-FLANGE OVAL	326	\N	\N	0.330	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3428	GBS011-THRUST BASE	327	\N	\N	0.382	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3429	BDF002-MOTOR BODY	328	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3430	CGH051-2H65S CASING	329	\N	\N	13.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3431	IMI010-IMPELLER	330	\N	\N	5.440	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3432	HNS018-NNRV SEAT RETAINER	331	\N	\N	0.286	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3433	HNS020-NRV SEAT RETAINER	332	\N	\N	0.429	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3434	BOF016-BODY	333	\N	\N	6.921	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3435	BCC004-CAP	334	\N	\N	0.326	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3436	CGS004-1S125 CASING	335	\N	\N	33.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3437	IMI006-IMPELLER	336	\N	\N	2.426	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3438	IMT003-IMPELLER	337	\N	\N	1.810	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3439	IMS027-IMPELLER	338	\N	\N	8.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3440	IMS017-IMPELLER	339	\N	\N	5.340	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3441	IMH012-IMPELLER	340	\N	\N	4.020	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3442	CDF018-COVER DOME	341	\N	\N	5.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3443	GAS004-CAP	342	\N	\N	0.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3444	IMS007-IMPELLER	343	\N	\N	6.047	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3445	RCK003-REAR COVER	344	\N	\N	5.072	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3446	YOH040-YOKE	345	\N	\N	4.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3447	CGS007-1S50A CASING	346	\N	\N	14.073	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3448	CDB001-COVER DOME	347	\N	\N	8.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3449	HCS021-DELIVERY CASING	348	\N	\N	2.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3450	YOS001-YOKE	349	\N	\N	6.339	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3451	FLS028-FLANGE	350	\N	\N	1.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3452	HCS177--DELIVERY CASING	351	\N	\N	0.762	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3453	IML004-IMPELLER	352	\N	\N	1.820	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3454	HHCS0080-DELIVERY CASING	353	\N	\N	2.672	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3455	HPS001-PUMP HOUSING	354	\N	\N	2.694	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3456	HCS080-DELIVERY CASING	355	\N	\N	2.734	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3457	IMH009-IMPELLER	356	\N	\N	3.415	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3458	IMI054-IMPELLER	357	\N	\N	2.192	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3459	IMK004-IMPELLER	358	\N	\N	1.308	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3460	CGS002-0S75 CASING	359	\N	\N	23.170	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3461	CGH011-2H50 CASING	360	\N	\N	11.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3462	CGH036-1H75 CASING	361	\N	\N	16.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3463	HES001-BOWL	362	\N	\N	4.080	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3464	IMS032 IMPELLER	363	\N	\N	6.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3465	CGS001-0S65 CASING	364	\N	\N	16.091	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3466	BOF006-BODY	365	\N	\N	9.187	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3467	YOS006-YOKE	366	\N	\N	13.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3468	IMS011-IMPELLER	367	\N	\N	6.504	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3469	IMI041-IMPELLER	368	\N	\N	6.966	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3470	IMC058-IMPELLER	369	\N	\N	1.059	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3471	RCF004-REAR COVER	370	\N	\N	2.833	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3472	RCH002-REAR COVER	371	\N	\N	5.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3473	IMO024-IMPELLER	372	\N	\N	3.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3474	IAA012 DELIVERY CHAMBER	373	\N	\N	3.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3475	RCG013-REAR COVER	374	\N	\N	3.692	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3476	IMI033-IMPELLER	375	\N	\N	2.090	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3477	IMI051-IMPELLER	376	\N	\N	1.272	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3478	CGC015 - 7025 CASING	377	\N	\N	3.724	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3479	IMC014-IMPELLER	378	\N	\N	1.812	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3480	HES007-BOWL	379	\N	\N	4.796	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3481	BCD004-CAP	380	\N	\N	0.440	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3482	IMC018-IMPELLER	381	\N	\N	1.097	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3483	TXG007-TERMINAL BOX	382	\N	\N	0.370	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3484	IMS021-IMPELLER	383	\N	\N	3.490	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3485	CDC003-COVER DOME	384	\N	\N	15.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3486	CJA004-CASING	385	\N	\N	16.060	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3487	RCJ005-REAR COVER	386	\N	\N	12.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3488	BCC014-CAP	387	\N	\N	0.418	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3489	CGH039 4H40-CASING	388	\N	\N	18.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3490	IMH040-IMPELLER	389	\N	\N	3.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3491	IMI038-IMPELLER	390	\N	\N	1.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3492	RCD001-REAR COVER	391	\N	\N	1.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3493	RCD002-REAR COVER	392	\N	\N	1.080	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3494	IMI046-IMPELLER	393	\N	\N	0.832	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3495	CDB004-COVER DOME	394	\N	\N	9.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3496	IMI030-IMPELLER	395	\N	\N	3.488	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3497	IMH061-IMPELLER	396	\N	\N	4.817	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3498	BCE004-CAP	397	\N	\N	0.536	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3499	HPV005-PUMP HOUSING	398	\N	\N	2.980	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3500	7.5 FLANGE	399	\N	\N	22.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3501	5.5 FLANGE	400	\N	\N	57.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3502	5.5 DTG FLANGE	401	\N	\N	11.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3503	IMK009-IMPELLER	402	\N	\N	1.530	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3504	IMC019-IMELLER	403	\N	\N	1.298	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3505	RAK006-REARCOVER	404	\N	\N	6.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3506	IMO040-IMPELLER	405	\N	\N	3.903	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3507	CDC001-COVER DOME	406	\N	\N	11.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3508	FCI001-FRONT COVER	407	\N	\N	4.609	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3509	FSJ002-FAN SHIELD	408	\N	\N	10.160	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3510	DBS039-TOP HOUSING	409	\N	\N	0.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3511	DHA006-DIFFUSER HOUSING	410	\N	\N	4.268	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3512	IMH009 - IMPELLER	411	\N	\N	3.415	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3513	IMO017-IMPELLER	412	\N	\N	3.580	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3514	BCE001-CAP	413	\N	\N	0.527	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3515	FSL032-FLANGE SQUARE	414	\N	\N	1.829	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3516	IPB002-INTERMMADIATE PLATE	415	\N	\N	5.592	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3517	IMH016-IMPELLER	416	\N	\N	3.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3518	BCI003-CAP	417	\N	\N	1.116	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3519	FTE006-SUCTION CHAMBER	418	\N	\N	3.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3520	IML003-IMPELLER	419	\N	\N	1.726	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3521	FLC028-FLANGE SQUARE	420	\N	\N	1.771	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3522	BOC014 - BODY	421	\N	\N	3.930	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3523	IMI042-IMPELLER	422	\N	\N	0.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3524	IMK008-IMPELLER	423	\N	\N	1.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3525	IMI057-IMPELLER	424	\N	\N	3.590	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3526	IMS012-IMPELLER	425	\N	\N	6.454	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3527	CDK007 - COVER DOME	426	\N	\N	5.377	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3528	FLS017- FLANGE SQUARE	427	\N	\N	1.270	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3529	FLC006-FLANGE CIRCULAR	428	\N	\N	1.820	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3530	GBS025-THRUST INSERT	429	\N	\N	0.840	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3531	ECC001-MOTOR BODY	430	\N	\N	5.978	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3532	ECD001-MOTOR BASE	431	\N	\N	10.522	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3533	FSL040-FLANGE SQUARE	432	\N	\N	0.796	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3534	FLS040 - FLANGE SQUARE	433	\N	\N	0.796	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3535	BOG001-BODY	434	\N	\N	15.870	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3536	RAE001-BOTTOM BUSH	435	\N	\N	5.363	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3537	IMH002 -IMPELLER	436	\N	\N	2.850	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3538	IMH057-IMPELLER	437	\N	\N	2.564	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3539	IMH028- IMPELLER	438	\N	\N	4.760	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3540	CGC-023 MOTOR BASE	439	\N	\N	5.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3541	CGC-023 CASING	440	\N	\N	5.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3542	CDA004-COVER DOME	441	\N	\N	7.459	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3543	IMC001-IMPELLER	442	\N	\N	1.968	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3544	CDF023 - COVER DOME	443	\N	\N	6.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3545	FLS032-FLANGE SQUARE	444	\N	\N	1.829	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3546	FLS031-FLANGE SQUARE	445	\N	\N	1.790	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3547	BCA002-CAP	446	\N	\N	0.204	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3548	HIS116-INLET SEALING RING	447	\N	\N	0.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3549	HNS019-SEAT RETAINER	448	\N	\N	0.564	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3550	YOH027 - YOKE	449	\N	\N	3.290	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3551	BOK007-BODY	450	\N	\N	23.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3552	BCD007-CAP	451	\N	\N	0.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3553	FTA009-FRONT COVER	452	\N	\N	11.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3554	YOS004-YOKE	453	\N	\N	10.030	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3555	ECA010 - END COVER	454	\N	\N	5.464	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3556	CDK005-COVER DOME	455	\N	\N	5.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3557	IMC026-IMPELLER	456	\N	\N	1.110	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3558	CGC034~1125-CASING	457	\N	\N	5.706	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3559	YOH018-YOKE	458	\N	\N	10.210	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3560	IMI058-IMPELLER	459	\N	\N	1.350	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3561	IMH042-IMPELLER	460	\N	\N	1.430	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3562	IMC068-IMPELLER	461	\N	\N	1.716	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3563	IMC029-IMPELLER	462	\N	\N	1.096	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3564	CGC023-CASING	463	\N	\N	5.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3565	IMH099-IMPELLER	464	\N	\N	2.981	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3566	IMH078- IMPELLER	465	\N	\N	5.270	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3567	IMH078-IMPPELLER	466	\N	\N	5.270	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3568	IMH078 IMPELLER	467	\N	\N	5.270	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3569	IMH021-IMPELLER	468	\N	\N	1.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3570	RAC003-REAR COVER	469	\N	\N	3.232	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3571	FLC008-FRONT COVER	470	\N	\N	2.071	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3572	HCS191-DELIVERY CASING	471	\N	\N	6.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3573	HIS084-INLET BRACKET	472	\N	\N	7.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3574	BON003-BODY	473	\N	\N	5.865	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3575	CGC009 - 1S75 CASING	474	\N	\N	20.989	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3576	CGS009-1S75 CASING	475	\N	\N	20.989	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3577	BDF001-TSM BODY	476	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3578	YOS01-YOKE	477	\N	\N	17.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3579	YOS014 - YOKE	478	\N	\N	17.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3580	BCF002-CAP	479	\N	\N	0.836	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3581	GPS014-CABLE BOX	480	\N	\N	3.230	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3582	CGC013 - 2S50 CASING	481	\N	\N	18.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3583	MCC004-FRONT COVER	482	\N	\N	5.156	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3584	IMI012-IMPELLER	483	\N	\N	4.570	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3585	YOH039-YOKE	484	\N	\N	8.940	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3586	GBS008-MOTOR BASE	485	\N	\N	4.631	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3587	HCS001-DELIVERY CASING	486	\N	\N	6.135	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3588	HCS038-INTEGRAL DELIVERY	487	\N	\N	4.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3589	HIS089-INLET BRACKET	488	\N	\N	4.980	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3590	FCF004 - CASING  COVER	489	\N	\N	1.765	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3591	HES026-BOWL	490	\N	\N	7.198	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3592	GBS024-MOTOR BASE	491	\N	\N	2.020	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3593	FCJ004-FRONT COVER	492	\N	\N	9.502	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3594	IMS024 - IMPELLER	493	\N	\N	8.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3595	IMI045 - IMPELLER	494	\N	\N	2.790	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3596	IMS010 - IMPELLER	495	\N	\N	6.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3597	CDF007-COVER DOME	496	\N	\N	8.260	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3598	HCS202 - DELIVERY CASING	497	\N	\N	2.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3599	FLS041-FLANGE SQUARE	498	\N	\N	1.125	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3600	IAA001- SD CHAMBER	499	\N	\N	3.617	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3601	CGC041 - CASING	500	\N	\N	10.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3602	FTE003- SUCTION CHAMBER	501	\N	\N	12.201	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3603	CGH106- OH50 CASING	502	\N	\N	5.501	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3604	SHOTBLASTING HOUSING SOFT	503	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3605	GGS009-BOTTOM HOUSING	504	\N	\N	5.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3606	HIS123-INLET BRACKET	505	\N	\N	0.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3607	EAR005-STATOR END RING	506	\N	\N	1.402	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3608	CGC020 - 1S100CASING	507	\N	\N	21.414	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3609	BCI004-CAP	508	\N	\N	1.050	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3610	HIS117 - INLET BRACKET	509	\N	\N	1.734	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3611	ECC007- MOTORBASE	510	\N	\N	1.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3612	DHA039-DIFFUSER HOUSING	511	\N	\N	1.420	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3613	DHA040-DIFFUSER HOUSING	512	\N	\N	1.520	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3614	DHA041-DIFFUSER HOUSING	513	\N	\N	1.720	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3615	CGH088 2H50Q CASING	514	\N	\N	10.804	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3616	CGH098-1H75Q CASING	515	\N	\N	14.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3617	CGS021-2S100 Q CASING	516	\N	\N	27.090	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3618	FLC034-FLANGE CIRCULAR	517	\N	\N	6.707	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3619	FCG002-FRONT COVER	518	\N	\N	2.392	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3620	GUN-METAL	519	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3621	HIS032-INLET BRACKET	520	\N	\N	1.425	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3622	IMC073 - IMPELLER	521	\N	\N	1.056	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3623	CDC004 - COVER DOME	522	\N	\N	14.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3624	BCB001-THRUST BASE	523	\N	\N	0.285	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3625	IMC015-IMPELLER	524	\N	\N	1.438	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3626	BCB001-CAP	525	\N	\N	0.285	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3627	YOH014-YOKE	526	\N	\N	8.318	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3628	ECA011-END COVER	527	\N	\N	5.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3629	HCS206 - DELIVERYCASING	528	\N	\N	5.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3630	RAH001-BOTTOM BUSH HOUSING	594	\N	\N	8.518	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3631	BOL001-BODY	595	\N	\N	42.490	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3632	IMJ218-IMPELLER	596	\N	\N	0.680	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3633	MIM048-WEAR PLATE	597	\N	\N	0.750	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3634	FLS0205- FLANGE SQUARE	598	\N	\N	1.075	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3635	FLS025-FLANGE SQUUARE	599	\N	\N	1.075	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3636	BOK005-BODY	600	\N	\N	21.220	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3637	BCB013-CAP	601	\N	\N	0.316	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3638	HCS234-DELIVERY CASING	602	\N	\N	5.540	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3639	YOS017-YOKE	603	\N	\N	12.246	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3640	HES078-BOWL	604	\N	\N	10.060	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3641	YOH041-YOKE	605	\N	\N	5.630	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3642	CGH053-3H35 CASING	606	\N	\N	21.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3643	CGH104-4H75 CASING	607	\N	\N	20.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3644	CGS008-1S65 CASING	608	\N	\N	16.210	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3645	HES233-DELIVERY CASING	609	\N	\N	4.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3646	HCS233-DELIVERY CASING	610	\N	\N	4.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3647	CGH017-3H40S CASING	611	\N	\N	14.490	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3648	HCS232-DELIVERY CASING	612	\N	\N	5.320	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3649	BDE011-BODY	613	\N	\N	23.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3650	CGS005-1S150 CASING	614	\N	\N	43.210	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3651	HES030- BOWL	615	\N	\N	5.180	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3652	DHC014-DIFFUSER HOUSING	616	\N	\N	10.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3653	GPS003-CABLE BOX	617	\N	\N	3.263	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3654	IMC047-IMPELLER	618	\N	\N	1.239	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3655	IMS042-IMPELLER	619	\N	\N	4.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3656	HES038-BOWL	620	\N	\N	4.732	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3657	BDB005-TSM BOBY	621	\N	\N	31.180	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3658	FLO013-FLANGE OVAL	622	\N	\N	0.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3659	IMK013-IMPELLER	623	\N	\N	1.193	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3660	BCB021-CAP	624	\N	\N	0.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3661	HIS121-INLET SEALING RING	625	\N	\N	0.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3662	HIS024-INLET BRACKET	626	\N	\N	3.707	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3663	CIVIL WORK	627	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3664	HIS126-INLET BRACKET	628	\N	\N	4.990	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3665	IMJ213-IMPELLER	629	\N	\N	0.940	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3666	IMK007-IMPELLER	630	\N	\N	1.840	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3667	HCS235-DELIVERY CASING	631	\N	\N	5.254	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3668	FLO009-FLANGE OVAL	632	\N	\N	0.512	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3669	HCS029-DELIVERY CASING	633	\N	\N	6.478	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3670	IMC028-IMPELLER	634	\N	\N	1.310	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3671	DBS009-BOTTOM HOUSING	635	\N	\N	2.175	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3672	EXPENSES FOR DISA (SPARES & LABOUR)	636	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3673	HNV004-NRV SEAT	637	\N	\N	0.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3674	CDC002-COVER DOME	638	\N	\N	16.210	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3675	HNM005-DISC FACE	639	\N	\N	0.184	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3676	MIM034-WEAR PLATE	640	\N	\N	4.980	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3677	CCGC022-S30Q CASING	641	\N	\N	13.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3678	CDG001-COVER DOME	642	\N	\N	2.455	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3679	FLS034-FLANGE SQUARE	643	\N	\N	2.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3680	IPA003-INTERMEDIATE PLATE	644	\N	\N	9.180	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3681	HNF017-NRV SEATHOLDER	645	\N	\N	0.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3682	HIS122-INLETBRACKET	646	\N	\N	1.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3683	IMS008-IMPELLER	647	\N	\N	7.318	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3684	MIM042-WEAR PLATE	648	\N	\N	1.094	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3685	CDA009-COVER DOME	649	\N	\N	9.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3686	IMJ219-IMPELLER	650	\N	\N	0.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3687	ATTANCE	651	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3688	FLS038-FLANGE	652	\N	\N	3.955	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3689	GLD006-GLAND	653	\N	\N	0.430	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3690	GLD007-GLAND	654	\N	\N	0.520	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3691	BCB009-CAP	655	\N	\N	0.278	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3692	HES077-BOWL	656	\N	\N	9.130	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3693	IMS020-IMPELLER	657	\N	\N	3.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3694	HNM013-NRV DISC FACE	658	\N	\N	0.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3695	CDF022-COVERDOME	529	\N	\N	5.073	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3696	CGH018  -3H50 CASING	530	\N	\N	12.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3697	HCS105 - DELIVERY CASING	531	\N	\N	1.240	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3698	HCS138-DELIVERY CASING	532	\N	\N	1.060	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3699	BOK001-BODY	533	\N	\N	33.440	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3700	HIS092-INLET BRACKET	534	\N	\N	0.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3701	FTC019-FRONT COVER	535	\N	\N	5.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3702	HCS120 - INTEGRAL DELIVERY CASING	536	\N	\N	5.240	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3703	HCS205- DELIVERY CASING	537	\N	\N	6.270	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3704	CGC059 - CASING	538	\N	\N	4.690	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3705	HCS122-DELIVERY CASING	539	\N	\N	2.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3706	YOH046-YOKE	540	\N	\N	6.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3707	IMC064-IMPELLER	541	\N	\N	0.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3708	IMC010-IMPELLER	542	\N	\N	1.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3709	YOH047-YOKE	543	\N	\N	6.420	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3710	IMI059-IMPELLER	544	\N	\N	1.410	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3711	FLS005-FLANGE SQUARE	545	\N	\N	1.014	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3712	HIIS124-INLET BRACKET	546	\N	\N	1.850	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3713	HIS124 - INLET BRACKET	547	\N	\N	1.850	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3714	HCA006-DELIIVEVERY CHAMBER	548	\N	\N	5.760	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3715	DFA037-DIFFUSER	549	\N	\N	1.290	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3716	HES141-BOWL	550	\N	\N	4.560	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3717	IMI047-IMPELLER	551	\N	\N	1.023	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3718	HCS116-DELIVERY CASING	552	\N	\N	4.950	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3719	BCF009-CAP	553	\N	\N	0.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3720	FLS033-FLANGE	554	\N	\N	2.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3721	FLC044-FLANGE SQUARE	555	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3722	IMJ212-IMPELLER	556	\N	\N	0.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3723	FLS004-FLANGE SQUARE	557	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3724	FLS052-FLANGE CIRCULAR	558	\N	\N	1.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3725	FLI004-FLANGE PROFILE	559	\N	\N	1.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3726	YOH037-YOKE	560	\N	\N	9.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3727	FLC052-FLANGE CIRCULAR	561	\N	\N	1.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3728	IMJ217-IMPELLER	562	\N	\N	0.741	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3729	IMJ211-IMPELLER	563	\N	\N	0.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3730	IMT004-IMPELLER	564	\N	\N	2.006	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3731	HES106-BOWL	565	\N	\N	6.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3732	HES129-BOWL	566	\N	\N	4.590	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3733	FTC018-FRONT COVER	567	\N	\N	6.750	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3734	HCS238-DELIVERY CASING	568	\N	\N	11.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3735	BOS008-BODY	569	\N	\N	8.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3736	HCS193-DELIVERY CASING	570	\N	\N	2.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3737	FTE002-SUCTION CHAMBER	571	\N	\N	12.196	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3738	IML005-IMPELLER	572	\N	\N	2.735	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3739	GAS014-DIAPHRAM CAP	573	\N	\N	0.360	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3740	FLC032-FLANGE CIRCULAR	574	\N	\N	3.588	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3741	IMT006-IMPELLER	575	\N	\N	2.290	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3742	FTE001-SUCTION CHAMBER	576	\N	\N	12.057	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3743	IMI011-IMPELLER	577	\N	\N	66.310	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3744	CDF024-COVER DOME	578	\N	\N	3.940	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3745	CGC062-CASING	579	\N	\N	5.782	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3746	CGC045-CASING	580	\N	\N	6.793	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3747	BCG011-CAP	581	\N	\N	1.012	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3748	IMJ215-IMPELLER	582	\N	\N	0.570	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3749	IMJ216-IMPELLER	583	\N	\N	0.590	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3750	IMO018-IMPELLER	584	\N	\N	3.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3751	HIS045-INLETBRACKET	585	\N	\N	7.060	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3752	HCS100-DELIVERY CASING	586	\N	\N	5.350	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3753	HCS185-DELIVERY CASING	587	\N	\N	6.040	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3754	FLS037-FLANGE SQUARE	588	\N	\N	2.803	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3755	FTM012-FRONT COVER	589	\N	\N	8.720	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3756	IMJ223-IMPELLER	590	\N	\N	0.760	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3757	HIS095-INLET BRACKET	591	\N	\N	8.310	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3758	MIM027-WEAR PLATE	592	\N	\N	3.183	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3759	BOE007-BODY	593	\N	\N	10.980	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3760	DBS034-BOTTOM HOUSING	659	\N	\N	2.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3761	FLC038-FLANGE SQUARE	660	\N	\N	1.910	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3762	PYF001-FLAT PULLEY	661	\N	\N	4.517	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3763	BDD009-MOTOR BODY	662	\N	\N	16.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3764	HES044-BOWL	663	\N	\N	8.556	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3765	FTE004-SUCTION CHAMBER	664	\N	\N	10.718	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3766	IMH052-IMPELLER	665	\N	\N	2.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3767	HCS002-DELIVERY CASING	666	\N	\N	6.340	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3768	HIS128-INLETBRACKET	667	\N	\N	1.630	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3769	DBS021-TOPHOUSING	668	\N	\N	1.666	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3770	BDD008-BODY	669	\N	\N	15.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3771	YOS016-YOKE	670	\N	\N	11.968	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3772	BOT002-BODY	671	\N	\N	9.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3773	HCS240 - DELIVERY CASING	672	\N	\N	2.734	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3774	HES046-BOWL	673	\N	\N	8.507	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3775	FLI002-FLANGE	674	\N	\N	1.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3776	IMH006-IMPELLER	675	\N	\N	2.910	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3777	MIM047-REAR COVER	676	\N	\N	3.183	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3778	HIS019-INLET BRACKET	677	\N	\N	12.050	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3779	IMC057-IMPELLER	678	\N	\N	1.316	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3780	IMJ227-IMPELLER	679	\N	\N	0.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3781	RAK010-REAR COVER	680	\N	\N	5.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3782	IMH032-IMPELLER	681	\N	\N	2.754	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3783	CGC064-CASING	682	\N	\N	9.070	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3784	BOF001-1544 OUTER CASING	683	\N	\N	4.951	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3785	HCS228  - DELIVERY CASING	684	\N	\N	5.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3786	CGC065-4025 CASING	685	\N	\N	3.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3787	CGH037-2H75 CASING	686	\N	\N	18.298	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3788	IMH024-IMPELLER	687	\N	\N	2.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3789	0.5 HP ADAPTER	688	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3790	1 HP SHALLO ADAPTOR	689	\N	\N	4.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3791	2 STAGE	690	\N	\N	4.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3792	1 HP AV CASING	691	\N	\N	4.438	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3793	A TYPE ADOPTER	692	\N	\N	4.565	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3794	FTM013 S M FRONT COVER	693	\N	\N	7.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3795	LMW0002 INTERMEDIATE FRAME	694	\N	\N	48.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3796	GEAR BOX HOUSING (FRONT HALF)	695	\N	\N	36.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3797	GEAR BOX HOUSING (REAR HALF)	696	\N	\N	26.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3798	PP TATA 380 (VALVO PRESSURE PLATE)	697	\N	\N	16.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3799	OUTER HOUSING MACHINED	698	\N	\N	4.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3800	MANIFOLD ASSY	699	\N	\N	8.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3801	INTERMEDIATE FRAME_G039072	700	\N	\N	48.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3802	BRAKE CALIPER (DELLNER)	701	\N	\N	29.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3803	SUMP LUB OIL(ADDISON SUMP103)	702	\N	\N	43.980	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3804	SUMP LUB OIL (ADDISON SUMP 3005)	703	\N	\N	42.220	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3805	IND-PACKER -ASSY	704	\N	\N	13.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3806	PLANET CARRIER	705	\N	\N	39.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3807	CENTER HOUSING	706	\N	\N	10.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3808	ATTANANCE ( PINHU)	707	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3809	ATANANCE ( LABOUR)	708	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3810	RAJ BHIHARI	709	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3811	SANTHOSH HINDI	710	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3812	MISHOTAN HINDI	711	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3813	OUTER HOUSING  IU4A0057	712	\N	\N	8.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3814	OUTER HOUSING NPDT0015	713	\N	\N	3.600	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3815	KNUCKLE STEERING 0041	714	\N	\N	6.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3816	KNUCKLE STEERING 0046	715	\N	\N	6.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3817	FRAME 0072	716	\N	\N	48.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3818	DIFF CASE	717	\N	\N	6.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3819	IND CAP FUNCTI ONAL	718	\N	\N	0.640	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3820	GEAR BOX INTERMEDIATE	719	\N	\N	60.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3821	GEAR BOX FRONT 5830	720	\N	\N	44.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3822	IND PLUG-1 1/4 NPT	721	\N	\N	0.290	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3823	GEAR BOX REAR 5830	722	\N	\N	47.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3824	BODY INJECTOR MACH	723	\N	\N	1.470	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3825	IND PLUG 2	724	\N	\N	0.290	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3826	COVER CAPACTOR	725	\N	\N	0.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3827	IND PLUG 2 BOX RED	726	\N	\N	0.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3828	LMW FRAME 002	727	\N	\N	48.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3829	DISC BRAKE 0082597	728	\N	\N	9.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3830	IND BODY INJECTOR	729	\N	\N	1.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3831	FURNACE 500 KG CRUISABLE	730	\N	\N	300.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3832	PANNEL BOARD 350 KW	731	\N	\N	400.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3833	IU4A0078 AXLE CASING	732	\N	\N	97.940	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3834	NPDT0225 AXLE CASING	733	\N	\N	174.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3835	STANCHION WITH CYLINDER	734	\N	\N	750.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3836	ABC PANNEL	735	\N	\N	300.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3837	MV PANNEL	736	\N	\N	750.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3838	FRONTCOVER ASM30J	737	\N	\N	9.540	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3839	C.I SCRAP	738	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3840	COVER CASING DMS3	739	\N	\N	2.483	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3841	S&D CHAMBER DMS2	740	\N	\N	3.996	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3842	ASM 30J FRONT COVER	741	\N	\N	9.087	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3843	COOLING COVER 100	742	\N	\N	1.966	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3844	EMPTYOIL CAN	743	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3845	GP SEAL CAST DP VAS LT	744	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3846	JERLAC THINNER 104	745	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3847	BOWL STAGE MS65A (CASTING)	746	\N	\N	4.055	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3848	ASM1J FRONT COVER	747	\N	\N	8.889	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3849	DMS3 VOLUTE CASING	748	\N	\N	1.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3850	BOTTOM BEARING HOUSING CASTING SM610	749	\N	\N	5.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3851	ASM14J REAR COVER	750	\N	\N	5.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3852	DOME CHAMBER DMS2	751	\N	\N	4.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3853	DOME CHAMBER DMS3	752	\N	\N	5.720	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3854	500 KVA TRANSFORMER	753	\N	\N	2500.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3855	ELGI COMPRESSOR -E30	754	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3856	IR COMPRESSOR UP5-22	755	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3857	SG1-06 FRAME	756	\N	\N	25.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3858	SG1-06B FRAME	757	\N	\N	25.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3859	YN54D0168P1-01 BRACKET CASTING	758	\N	\N	16.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3860	1-572-001-100 ROTOR CASTING	759	\N	\N	13.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3861	2A50111910SG BRACKET	760	\N	\N	9.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3862	150-00202-01 CLAW ROTOR CASTING QDP80	761	\N	\N	2.540	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3863	047-Traction Sheave (320 Pcd X08x5g)(2648)	762	\N	\N	20.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3864	CRX MOTAR BODY	763	\N	\N	23.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3865	YN30P01029 P1 BRACKET	764	\N	\N	14.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3866	YN02P01397 BRACKET	765	\N	\N	6.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3867	045-TRACTION SHEAVE 4ES-00-0045	766	\N	\N	19.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3868	08006011710355-OUTER HOUSING CASTED	767	\N	\N	6.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3869	END SHIELD	768	\N	\N	11.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3870	MOUNT HUB	769	\N	\N	18.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3871	BREAKDRUM	770	\N	\N	5.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3872	4121 GEAR	771	\N	\N	2.330	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3873	PTO CASING	772	\N	\N	8.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3874	015 POPPET	773	\N	\N	1.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3875	1.564 ROTAR	774	\N	\N	0.860	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3876	007 BONUT	775	\N	\N	2.200	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3877	Segment	776	\N	\N	6.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3878	Cam Gear	777	\N	\N	2.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3879	Hub	778	\N	\N	2.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3880	Geneva Top	779	\N	\N	8.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3881	Geneva Bottom	780	\N	\N	8.410	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3882	08 Frame	781	\N	\N	30.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3883	BOX CASTING	782	\N	\N	14.545	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3884	BRACKET	783	\N	\N	5.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3885	501 Hub	784	\N	\N	1.040	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3886	2" BOTTOM	785	\N	\N	2.452	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3887	2*11/2 RED	786	\N	\N	2.167	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3888	1 1/4 TOP	787	\N	\N	1.403	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3889	1 1/4*1 RED	788	\N	\N	0.789	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3890	1 1/2 * 1 1/4 RED BUSH	789	\N	\N	0.810	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3891	1 1/4  BOTTOM	790	\N	\N	1.417	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3892	1 1/4*1 1/2 EXP BUSH	791	\N	\N	1.123	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3893	1 1/4 SUPER HEVY BOTTOM	792	\N	\N	1.687	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3894	1 1/2 TOP SUPER HEAVY	793	\N	\N	2.111	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3895	7" PLATE (R)	794	\N	\N	1.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3896	7" PLATE (S)	795	\N	\N	1.475	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3897	TEL S105 TURBINE HOUSINFB RAW PART	796	\N	\N	8.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3898	HYU S01 MANIFOLD EXHAUST	797	\N	\N	4.490	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3899	LP54D01002P1-01-CST BRACKET SK 14O CASTING	798	\N	\N	10.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3900	PRESSURE RELIEVE CASING 1147239453SG	799	\N	\N	5.340	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3901	END COVERV CASING 25 SERIES	800	\N	\N	15.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3902	SHOTBLAST BLOWER MACHINE	801	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3903	SHOTBLASTING MACHINE	802	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3904	COMPURSURE 10 HP	803	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3905	CONVER BELT	804	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3906	SUNG MOTOR	805	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3907	PANNAL BOARD	806	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3908	Grinding Machine	807	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3909	Bed	808	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3910	Coat	809	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3911	DELIVERY CASING	810	\N	\N	2.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3912	NRV SEAT HOLDER	811	\N	\N	0.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3913	S.D CHAMBER	812	\N	\N	3.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3914	IAA004 S. D CHAMBER	813	\N	\N	3.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3915	CHAIN SLING 1 TON CAPACITY 1.5 METER 4 LEG	814	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3916	ALLEN KEY 1.5MM TO 10MM	815	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3917	ALLEN KEY 12MM	816	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3918	ALLEN KEY 14MM	817	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3919	ALLEN KEY 17MM	818	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3920	ALLEN KEY 19MM	819	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3921	ALLEN KEY 22MM	820	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3922	DROP FORGED	821	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3923	6 TO 32 MM , VANDIUM STEEL	822	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3924	Socket Sq. Drive  Hex 30mm	823	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3925	Sq. Drive ,Hex 32mm,	824	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3926	Sq.Drive , 26mm,	825	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3927	Sq. Drive, Hex 24mm,	826	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3928	Sq. Drive Hex 20mm,	827	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3929	Sq. Drive , Hex 22mm,	828	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3930	Taparia T-Handle	829	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3931	Bullwark Tool Box	830	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3932	ALLEN KEY SHORT FLAT 9	831	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3933	ALLEN KEY SHORT FLAT 12MM	832	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3934	ALLEN KEY SHORT FLAT 14MM	833	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3935	ALLEN KEY SHORT FLAT 17MM	834	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3936	ALLEN KEY SHORT FLAT 19MM	835	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3937	ALLEN KEY SHORT FLAT 22MM	836	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3938	RING SPANNER 12Pcs	837	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3939	DOUBLE OPEN END SPANNER 12Pcs	838	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3940	Sq. Drive Hex 30mm	839	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3941	Sq. Drive 32mm	840	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3942	Sq Drive 26mm	841	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3943	Sq. Drive Hex 24mm	842	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3944	Sq. Drive Hex 20mm	843	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3945	Sq. Drive Hex 22mm	844	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3946	Sq, Drive 12" Length	845	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3947	Collapsible 17*9*6.5"	846	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3948	F 180 12 303 Cover Dome	847	\N	\N	22.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3949	Ms Cover Dome	848	\N	\N	3.940	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3950	2H65S CASING	849	\N	\N	13.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3951	7032 S 4H CASING	850	\N	\N	11.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3952	RC DIFFUSER HOUSING INTEGRAL	851	\N	\N	1.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3953	2DH DIAPHRAGM CAP	852	\N	\N	0.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3954	525H S D CHAMBER	853	\N	\N	3.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3955	TSP 1/2 CASING	854	\N	\N	1.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3956	TSP 3 CASING	855	\N	\N	1.767	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3957	CDE010 COVER DOME	856	\N	\N	22.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3958	CJA009 -CASING	857	\N	\N	11.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3959	CDA006 COVER DOME	858	\N	\N	6.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3960	DHC018 DIFFUSER HOUSING	859	\N	\N	7.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3961	IMS058 IMPELLER	860	\N	\N	5.026	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3962	DHC024 DIFFUSER HOUSING	861	\N	\N	1.550	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3963	HIS150 INLET BRACKET	862	\N	\N	1.463	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3964	MCI DRUM	863	\N	\N	7.350	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3965	KAPPA FLYWHEEL 23211-08200	864	\N	\N	8.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3966	CDF029 COVER DOME	865	\N	\N	4.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3967	A/C 2 TONE	866	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3968	GRINDING BED	867	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3969	HES134 BOWL	868	\N	\N	4.960	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3970	FMZ077 RING PATTERN	869	\N	\N	0.288	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3971	REAR CAP 1505C	870	\N	\N	4.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3972	DHA042 DIFFUSER HOUSING	871	\N	\N	1.280	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3973	CGC046 CASING	872	\N	\N	2.760	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3974	RAE002 BOTTOM BUSH HOUSING	873	\N	\N	6.480	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3975	RAH003 BOTTOM BUSH HOUSING	874	\N	\N	9.870	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3976	RAC005 REARCOVER	875	\N	\N	2.410	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3977	CGH077-7025 CASING	876	\N	\N	3.826	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3978	IAA011 CHAMBER	877	\N	\N	5.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3979	10 PISTON COMPRESSOR RENTAL PURPOSE	878	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3980	IMC078 IMPELLER	879	\N	\N	1.950	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3981	BFO002 OUTER CASING	880	\N	\N	5.250	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3982	HIO001INLET BRACKET	881	\N	\N	7.460	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3983	HCA012 DELIVERY CHAMBER	882	\N	\N	10.360	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3984	WATER	883	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3985	SANTOR WHEEL 4"	884	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3986	ECD004-MOTOR BASE	886	\N	\N	6.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3987	BDD006 - MOTOR BODY	887	\N	\N	13.340	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3988	IMI060-IMPELLER	888	\N	\N	0.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3989	BOD003-BODY	889	\N	\N	8.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3990	IMK015-IMPELLER	890	\N	\N	1.880	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3991	IMC021-IMPELLER	891	\N	\N	2.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3992	ECC010-MOTOR BASE	892	\N	\N	1.950	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3993	FTE007-SUCTION CHAMBER	893	\N	\N	3.500	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3994	BOD009	894	\N	\N	7.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3995	BOF021 BODY	895	\N	\N	9.187	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3996	CGC066 CASING	896	\N	\N	4.210	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3997	HCA016 DELIVERY CHAMBER	897	\N	\N	1.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3998	IMI062 IMPELLER	898	\N	\N	1.870	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
3999	FCD004 CASING COVER	899	\N	\N	1.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4000	HES144 BOWL	900	\N	\N	10.040	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4001	HES126 BOWL	901	\N	\N	4.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4002	HES039 PUMP HOUSING	902	\N	\N	3.080	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4003	IMK014 IMPELLER	903	\N	\N	1.930	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4004	RCE004 REAR COVER	904	\N	\N	1.418	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4005	CGC022 4025 CASING	905	\N	\N	3.001	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4006	FTC013 FRONT COVER	906	\N	\N	3.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4007	DBS079 BOTTOM HOUSING	907	\N	\N	2.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4008	IMI063 IMPELLER	908	\N	\N	3.760	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4009	DBO001 TOP BUSH HOUSING	909	\N	\N	8.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4010	FLS045 FLANGE	910	\N	\N	1.650	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4011	FLS046 FLANGE	911	\N	\N	1.780	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4012	CORE SHUTER	912	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4013	CGC035 CASING	913	\N	\N	11.330	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4014	MIM033 DRAIN COVER	914	\N	\N	0.236	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4015	IMK011 IMPELLER	915	\N	\N	1.810	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4016	GPS016 CABLE BOX	916	\N	\N	2.510	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4017	CUT WIRE SHOTS	917	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4018	400*50*127 C163 ZRC	1028	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4019	BCG012 CAP	918	\N	\N	1.018	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4020	BDE012 BODY	919	\N	\N	17.740	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4021	MIM038 WEAR PLATE	920	\N	\N	0.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4022	DHA044MDIFFUSER HOUSING	921	\N	\N	1.120	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4023	HCA014 DELIVERY CHAMBER	922	\N	\N	4.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4024	BLADE	923	\N	\N	1.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4025	BLADE-14MM(HC)	924	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4026	BLADE MOUNTING BOLT@NUT	925	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4027	IMPELLER	926	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4028	CONTROLGUAGE	927	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4029	NARROW PLATE	928	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4030	CURVED PLATE	929	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4031	200*400 GUIDE PLATE	930	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4032	700*400 WALL PLATE	931	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4033	300 KGS BLADE	932	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4034	BLADEMOUNT&NUT	933	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4035	300 KGS IMPELLER	934	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4036	300 KGS CONTROL GUAGE	935	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4037	300 KGS NARROW PLATE	936	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4038	300 KGS CURVED PLATE	937	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4039	150*300 GUIDE PLATE	938	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4040	300 KGS BEARING END	939	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4041	300 KGS FEEDING END	940	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4042	HNM010 NRV DISC FACE	941	\N	\N	0.036	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4043	BDD004 BODY	942	\N	\N	10.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4044	CDF013 COVER DOME	943	\N	\N	5.548	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4045	ECC008	944	\N	\N	5.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4046	COMPRESSOR 7.5 HP	945	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4047	FNA036-FAN	946	\N	\N	0.750	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4048	DBS089-TOP HUSING	947	\N	\N	2.020	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4049	HCS252 DELIVERY CASING	948	\N	\N	3.384	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4050	DBO005 TOPBUSH	949	\N	\N	10.960	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4051	DBS088 BOTTOM HOUSING	950	\N	\N	3.030	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4052	CGH054  4H65 CASING	951	\N	\N	19.420	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4053	CGC067 CASING	952	\N	\N	5.580	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4054	CGC048 50H CASING	953	\N	\N	6.940	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4055	HIO002 INLET BRACKET	954	\N	\N	6.680	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4056	HPS067 INTERMEDIATE HOUSING	955	\N	\N	1.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4057	JCB LSRS\t\t	956	\N	\N	6.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4058	JCB CENTER CUTTER\t\t	957	\N	\N	6.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4059	BDF009 TSM BODY	958	\N	\N	8.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4060	FTM015 FRONT COVER	959	\N	\N	7.700	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4061	CGH056-H38	960	\N	\N	17.300	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4062	RAK011 REAR COVER	961	\N	\N	4.630	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4063	HCS253 DELIVERY CASING	962	\N	\N	2.280	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4064	CGH115-1H40 CASING	963	\N	\N	7.920	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4065	CDF002-COVER DOME	964	\N	\N	6.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4066	ROPE GRINDING	965	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4067	FTC020 FRONT COVER	966	\N	\N	5.180	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4068	FTC014 REAR COVER	967	\N	\N	2.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4069	RCF014 REAR COVER	968	\N	\N	2.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4070	GP PAINT FOR REWORK PURPOSE	969	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4071	SKA011 STRAINER BRACKET	970	\N	\N	1.710	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4072	ECD004-MOTAR BASE	971	\N	\N	6.140	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4073	CGH117-IH65 CASING	972	\N	\N	9.033	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4074	GBS002 MOTAR BASE	973	\N	\N	10.576	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4075	FTM014 FRONT COVER	974	\N	\N	8.080	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4076	CDI015 COVER DOME	975	\N	\N	3.400	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4077	NFD CASTING	976	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4078	YOS005 YOKE	977	\N	\N	10.660	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4079	FMZ078 MATCH RING	978	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4080	FTM016 FRONT COVER	979	\N	\N	7.064	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4081	FTM017 FRONT COVER	980	\N	\N	7.626	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4082	FTM018 FRONTCOVER	981	\N	\N	8.610	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4083	CDA008 COVER DOME	982	\N	\N	7.251	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4084	CGH121 2H50 CASING	983	\N	\N	10.126	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4085	CGH122 2H40QN CASING	984	\N	\N	9.897	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4086	CGH123 2H65A CASING	985	\N	\N	10.708	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4087	RAK012 REAR COVER	986	\N	\N	6.135	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4088	BOD012 BODY	987	\N	\N	6.390	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4089	RING PATTERN	988	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4090	YOS018 YOKE	989	\N	\N	15.810	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4091	BDF010 BODY	990	\N	\N	7.848	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4092	CDI011 COVER DOME	991	\N	\N	2.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4093	2000 A COVER	992	\N	\N	10.657	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4094	1-567-410 ROTAR	993	\N	\N	2.419	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4095	IMPELLER -	994	\N	\N	2.420	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4096	GOS014 TOP HOUSING	995	\N	\N	13.450	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4097	IAB008 DELIVERY CHAMBER	996	\N	\N	2.900	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4098	HIS166 INLET BRACKET	997	\N	\N	1.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4099	SKA012 STRAINER BRACKET	998	\N	\N	1.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4100	BDE014 BODY	999	\N	\N	21.240	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4101	RGS001 SUCTION CHAMBER	1000	\N	\N	1.220	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4102	BDF011 BODY	1001	\N	\N	10.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4103	BOK009-BODY	1002	\N	\N	20.620	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4104	CGH120-0H40QN CASING	1003	\N	\N	8.976	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4105	HNM003 NRV DISC	1004	\N	\N	0.100	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4106	FCD008 FRONT COVER	1005	\N	\N	1.680	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4107	CDA013 COVER DOME	1006	\N	\N	14.865	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4108	BOH002- BODY	1007	\N	\N	22.525	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4109	BON005 BODY	1008	\N	\N	7.670	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4110	CGH116-1H50 QN CASING	1009	\N	\N	7.208	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4111	HIS167 INLET BRACKET	1010	\N	\N	1.462	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4112	BOH003-MOTOR BODY	1011	\N	\N	6.359	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4113	CDI013 COVER DOME	1012	\N	\N	3.800	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4114	SS 304	1013	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4115	GBS022 MOTARBASE	1014	\N	\N	6.080	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4116	GAS002 CAP	1015	\N	\N	0.730	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4117	HIS168 INLETBRACKET	1016	\N	\N	1.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4118	HCA015 -DELIVER CASING	1017	\N	\N	1.380	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4119	HCS178 DELIVERY CASING	1018	\N	\N	1.935	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4120	HCS153-IMPELLER	1019	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4121	BOWL	1020	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4122	GGS012 BOTTOM HOUSING	1021	\N	\N	11.410	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4123	FCE006 REAR COVER	1022	\N	\N	1.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4124	CDB008 COVER DOME	1023	\N	\N	8.360	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4125	HCS247 DELIVERY CASING	1024	\N	\N	1.060	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4126	FTC017 FRONT COVER	1025	\N	\N	5.190	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4127	GBS028 - THRUST INSERT	1026	\N	\N	1.070	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4128	MOTAR	1027	\N	\N	20.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4129	400*50*127 C163 ZRC SPEED WHEEL	1029	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4130	FORK LIFT MAINTANCE	1030	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4131	EB	1031	\N	\N	1.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4132	BFI002	1032	\N	\N	3.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4133	CDF017 COVER DOME	1033	\N	\N	5.902	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4134	IAA009 SUCTION CHAMBER	1034	\N	\N	3.150	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4135	DHC019 DIFFUSER HOUSING	1035	\N	\N	2.770	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
4136	BOH008 BODY	1036	\N	\N	24.000	t	2026-08-03 15:18:57.719099+00	2026-08-03 15:18:57.719099+00
\.


--
-- Data for Name: rates; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.rates (id, process_id, ledger_id, product_id, rate, uom_id, effective_from, effective_to, is_active, created_at) FROM stdin;
5	19	\N	\N	3.4000	\N	\N	\N	t	2026-08-03 15:18:58.462678+00
6	19	\N	\N	1.5000	\N	\N	\N	t	2026-08-03 15:18:58.462678+00
7	19	\N	\N	1.5000	\N	\N	\N	t	2026-08-03 15:18:58.462678+00
8	16	\N	\N	0.8000	\N	\N	\N	t	2026-08-03 15:18:58.462678+00
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.role_permissions (id, user_id, module, can_view, can_create, can_edit, can_delete, can_print) FROM stdin;
\.


--
-- Data for Name: stock_items; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.stock_items (id, name, item_code, uom_id, opening_stock, reorder_level, is_active, created_at, updated_at) FROM stdin;
295	STEEL SHOTS	1	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
296	SHOTS	2	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
297	GRINDING STONE 400*50*127	3	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
298	GRINDING STONE 350*50*50.8	4	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
299	ROD PAINT	5	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
300	GPP PAINT	6	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
301	GRN PAINT	7	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
302	TURBON OIL	8	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
303	TINNER	9	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
304	GLOUSE	10	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
305	GLASS	11	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
306	GRINDING STONE CORNER WHEEL 230*7*22.23	12	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
307	BEARING	13	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
308	PAPER	14	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
309	TEA	15	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
310	COTTON GLOUSE	16	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
311	GRINDING WHEEL 100*6*15.88 AG4	17	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
312	GP SEAL CAST VASANTHI RED OXIDE	18	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
313	GLOUSE INNER	19	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
314	GLOUSE LEATHER	20	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
315	CONTROL GUAGE	21	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
316	NARROW PLATE	22	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
317	CURVE PLATE	23	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
318	IMPELLER	24	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
319	IMPELLER COLLER	25	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
320	BLADE	26	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
321	SPANNER RING	27	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
322	SPANNER DOUBLE HAND	28	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
323	WIRE CUTTER	29	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
324	ALLEN KEY (1.5mm To 10mm)	30	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
325	CUTTING PLAYER	31	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
326	CIRCLIP PLAYER	32	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
327	HAMMER	33	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
328	ADJUSTABLE SPANNER	34	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
329	MAGNET	35	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
330	CHUTTY	36	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
331	MOUNTED POINT STONE	37	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
332	CUTTER CB1022	38	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
333	CUTTER CTP 1224	39	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
334	GRINDING STONE  BT 400/50/127MM	40	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
335	GRINDING STONE B+	41	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
336	GRINDING STONE SIC 1675	42	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
337	GRINDING STONE DIAMOND CUT	43	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
338	CI BORINGS	44	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
339	JOIST (150*75) (20")	45	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
340	JOIST (150*75) (4.5")	46	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
341	M S ANGLE (50*5 R)	47	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
342	HR SHEETS	48	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
343	CHAIN	49	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
344	CGST 9%	50	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
345	SGST 9%	51	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
346	Allen Key (12 MM)	52	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
347	ALLEN KEY (14 MM)	53	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
348	ALLEN KEY (17 MM)	54	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
349	ALLEN KEY (19 MM)	55	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
350	ALLEN KEY (22 MM)	56	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
351	RING SPANNER (6 TO 32 MM)	57	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
352	DOUBLE OPEN END SPANNER (6 TO 32 MM)	58	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
353	SOCKET 1/2" HEX 30 MM	59	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
354	SOCKET 1/2" HEX 32 MM	60	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
355	SOCKET 1/2" HEX 26 MM	61	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
356	SOCKET 1/2" HEX 24 MM	62	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
357	SOCKET 1/2" HEX 20 MM	63	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
358	SOCKET 1/2" HEX 22 MM	64	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
359	T HANDLE (12" LENGTH)	65	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
360	TOOL BOX COLLAPSIBLE 17*9*6.5"	66	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
361	A/C 2 TONE	67	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
362	GRINDING BED	68	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
363	BOLT AND NUT	69	11	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
364	WATER	70	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
365	SANTOR WHEEL 4"	71	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
366	BOX FILE	72	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
367	SHOTBLASTING BLADE	73	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
368	SHOTBLASTING IMPELLER	74	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
369	SHOTBLASTING CONTROL CAGE	75	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
370	HOSITER	76	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
371	FAN	77	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
372	WHITE PAINT	78	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
373	BLUE PAING	79	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
374	COMPRESSOR	80	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
375	ADI 230*7*22.23 MM	81	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
376	J24 300*7*25.4	82	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
377	DC WHEEL	83	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
378	RPW 400*50*127	84	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
379	NAGA 400*50*127	85	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
380	400*50*127 C163 ZRC	86	10	1.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
381	400*50*127 C163 ZRC SPEED WHEEL	87	10	1.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
382	TURPENTINE OIL	88	12	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
383	ATTANCE	89	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
384	EB	90	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
385	RENT	91	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
386	AG 4 WHEEL	92	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
387	230*5*22.23 C 30	93	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
388	9 DC WHEEL C30	94	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
389	15 MM DIAMOND MOUNT POINTED	95	10	1.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
390	15 MM SPINDLE	96	10	1.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
391	DISK INNER	97	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
392	MS PLATE FOR INNER DISK	98	10	0.000	0.000	t	2026-08-03 15:18:56.963343+00	2026-08-03 15:18:56.963343+00
\.


--
-- Data for Name: units_of_measure; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.units_of_measure (id, name, symbol, created_at) FROM stdin;
10	Numbers	nos	2026-08-03 15:18:56.954577+00
11	Kilogram	kgs	2026-08-03 15:18:56.954577+00
12	Liter	ltr	2026-08-03 15:18:56.954577+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.users (id, username, hashed_password, full_name, email, role, is_active, created_at, updated_at) FROM stdin;
1	admin	$2b$12$P.dFgBwh39KPX15P90N/cOOqtNjWOJ5YaulrsUihxbD8ZzKYvJQte	System Administrator	\N	Admin	t	2026-08-03 12:45:17.397342+00	2026-08-03 12:45:17.397342+00
\.


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.advance_payments_id_seq', 76, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.audit_logs_id_seq', 1, false);


--
-- Name: biometric_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.biometric_entries_id_seq', 1, false);


--
-- Name: eb_readings_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.eb_readings_id_seq', 1, false);


--
-- Name: job_work_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.job_work_entries_id_seq', 4, true);


--
-- Name: labour_bills_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.labour_bills_id_seq', 1036, true);


--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.salary_vouchers_id_seq', 1, false);


--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_adjustments_id_seq', 1, false);


--
-- Name: stock_inward_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_inward_id_seq', 1920, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_outward_id_seq', 2548, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_transfer_id_seq', 1, false);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.voucher_lines_id_seq', 104, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.vouchers_id_seq', 52, true);


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.advance_payments_id_seq', 8, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.audit_logs_id_seq', 1, false);


--
-- Name: biometric_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.biometric_entries_id_seq', 1, false);


--
-- Name: eb_readings_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.eb_readings_id_seq', 1, false);


--
-- Name: job_work_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.job_work_entries_id_seq', 1, false);


--
-- Name: labour_bills_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.labour_bills_id_seq', 440, true);


--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.salary_vouchers_id_seq', 1, false);


--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_adjustments_id_seq', 1, false);


--
-- Name: stock_inward_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_inward_id_seq', 704, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_outward_id_seq', 744, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_transfer_id_seq', 1, false);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.voucher_lines_id_seq', 2216, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.vouchers_id_seq', 1116, true);


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.advance_payments_id_seq', 1984, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.audit_logs_id_seq', 1, false);


--
-- Name: biometric_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.biometric_entries_id_seq', 1, false);


--
-- Name: eb_readings_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.eb_readings_id_seq', 1, false);


--
-- Name: job_work_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.job_work_entries_id_seq', 1, false);


--
-- Name: labour_bills_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.labour_bills_id_seq', 2960, true);


--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.salary_vouchers_id_seq', 20, true);


--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_adjustments_id_seq', 1, false);


--
-- Name: stock_inward_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_inward_id_seq', 14360, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_outward_id_seq', 444, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_transfer_id_seq', 1, false);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.voucher_lines_id_seq', 1704, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.vouchers_id_seq', 852, true);


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.advance_payments_id_seq', 1368, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.audit_logs_id_seq', 1, false);


--
-- Name: biometric_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.biometric_entries_id_seq', 1, false);


--
-- Name: eb_readings_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.eb_readings_id_seq', 1, false);


--
-- Name: job_work_entries_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.job_work_entries_id_seq', 1, false);


--
-- Name: labour_bills_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.labour_bills_id_seq', 532, true);


--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.salary_vouchers_id_seq', 8, true);


--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_adjustments_id_seq', 1, false);


--
-- Name: stock_inward_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_inward_id_seq', 5408, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_outward_id_seq', 4, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_transfer_id_seq', 8, true);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.voucher_lines_id_seq', 2544, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.vouchers_id_seq', 1272, true);


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.company_id_seq', 1, false);


--
-- Name: financial_years_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.financial_years_id_seq', 4, true);


--
-- Name: ledger_groups_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.ledger_groups_id_seq', 132, true);


--
-- Name: ledgers_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.ledgers_id_seq', 2524, true);


--
-- Name: processes_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.processes_id_seq', 24, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.products_id_seq', 4136, true);


--
-- Name: rates_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.rates_id_seq', 8, true);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.role_permissions_id_seq', 1, false);


--
-- Name: stock_items_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.stock_items_id_seq', 392, true);


--
-- Name: units_of_measure_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.units_of_measure_id_seq', 12, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.users_id_seq', 1, true);


--
-- Name: advance_payments advance_payments_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.advance_payments
    ADD CONSTRAINT advance_payments_pkey PRIMARY KEY (id);


--
-- Name: advance_payments advance_payments_voucher_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.advance_payments
    ADD CONSTRAINT advance_payments_voucher_no_key UNIQUE (voucher_no);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: biometric_entries biometric_entries_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.biometric_entries
    ADD CONSTRAINT biometric_entries_pkey PRIMARY KEY (id);


--
-- Name: eb_readings eb_readings_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.eb_readings
    ADD CONSTRAINT eb_readings_pkey PRIMARY KEY (id);


--
-- Name: job_work_entries job_work_entries_entry_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.job_work_entries
    ADD CONSTRAINT job_work_entries_entry_no_key UNIQUE (entry_no);


--
-- Name: job_work_entries job_work_entries_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.job_work_entries
    ADD CONSTRAINT job_work_entries_pkey PRIMARY KEY (id);


--
-- Name: labour_bills labour_bills_bill_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.labour_bills
    ADD CONSTRAINT labour_bills_bill_no_key UNIQUE (bill_no);


--
-- Name: labour_bills labour_bills_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.labour_bills
    ADD CONSTRAINT labour_bills_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.salary_vouchers
    ADD CONSTRAINT salary_vouchers_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.salary_vouchers
    ADD CONSTRAINT salary_vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: stock_adjustments stock_adjustments_adjustment_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_adjustments
    ADD CONSTRAINT stock_adjustments_adjustment_no_key UNIQUE (adjustment_no);


--
-- Name: stock_adjustments stock_adjustments_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_adjustments
    ADD CONSTRAINT stock_adjustments_pkey PRIMARY KEY (id);


--
-- Name: stock_inward stock_inward_inward_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_inward
    ADD CONSTRAINT stock_inward_inward_no_key UNIQUE (inward_no);


--
-- Name: stock_inward stock_inward_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_inward
    ADD CONSTRAINT stock_inward_pkey PRIMARY KEY (id);


--
-- Name: stock_item_movements stock_item_movements_movement_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_item_movements
    ADD CONSTRAINT stock_item_movements_movement_no_key UNIQUE (movement_no);


--
-- Name: stock_item_movements stock_item_movements_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_item_movements
    ADD CONSTRAINT stock_item_movements_pkey PRIMARY KEY (id);


--
-- Name: stock_outward stock_outward_outward_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_outward
    ADD CONSTRAINT stock_outward_outward_no_key UNIQUE (outward_no);


--
-- Name: stock_outward stock_outward_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_outward
    ADD CONSTRAINT stock_outward_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_transfer
    ADD CONSTRAINT stock_transfer_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_transfer_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_transfer
    ADD CONSTRAINT stock_transfer_transfer_no_key UNIQUE (transfer_no);


--
-- Name: voucher_lines voucher_lines_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.voucher_lines
    ADD CONSTRAINT voucher_lines_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.vouchers
    ADD CONSTRAINT vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: advance_payments advance_payments_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.advance_payments
    ADD CONSTRAINT advance_payments_pkey PRIMARY KEY (id);


--
-- Name: advance_payments advance_payments_voucher_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.advance_payments
    ADD CONSTRAINT advance_payments_voucher_no_key UNIQUE (voucher_no);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: biometric_entries biometric_entries_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.biometric_entries
    ADD CONSTRAINT biometric_entries_pkey PRIMARY KEY (id);


--
-- Name: eb_readings eb_readings_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.eb_readings
    ADD CONSTRAINT eb_readings_pkey PRIMARY KEY (id);


--
-- Name: job_work_entries job_work_entries_entry_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.job_work_entries
    ADD CONSTRAINT job_work_entries_entry_no_key UNIQUE (entry_no);


--
-- Name: job_work_entries job_work_entries_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.job_work_entries
    ADD CONSTRAINT job_work_entries_pkey PRIMARY KEY (id);


--
-- Name: labour_bills labour_bills_bill_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.labour_bills
    ADD CONSTRAINT labour_bills_bill_no_key UNIQUE (bill_no);


--
-- Name: labour_bills labour_bills_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.labour_bills
    ADD CONSTRAINT labour_bills_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.salary_vouchers
    ADD CONSTRAINT salary_vouchers_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.salary_vouchers
    ADD CONSTRAINT salary_vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: stock_adjustments stock_adjustments_adjustment_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_adjustments
    ADD CONSTRAINT stock_adjustments_adjustment_no_key UNIQUE (adjustment_no);


--
-- Name: stock_adjustments stock_adjustments_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_adjustments
    ADD CONSTRAINT stock_adjustments_pkey PRIMARY KEY (id);


--
-- Name: stock_inward stock_inward_inward_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_inward
    ADD CONSTRAINT stock_inward_inward_no_key UNIQUE (inward_no);


--
-- Name: stock_inward stock_inward_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_inward
    ADD CONSTRAINT stock_inward_pkey PRIMARY KEY (id);


--
-- Name: stock_item_movements stock_item_movements_movement_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_item_movements
    ADD CONSTRAINT stock_item_movements_movement_no_key UNIQUE (movement_no);


--
-- Name: stock_item_movements stock_item_movements_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_item_movements
    ADD CONSTRAINT stock_item_movements_pkey PRIMARY KEY (id);


--
-- Name: stock_outward stock_outward_outward_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_outward
    ADD CONSTRAINT stock_outward_outward_no_key UNIQUE (outward_no);


--
-- Name: stock_outward stock_outward_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_outward
    ADD CONSTRAINT stock_outward_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_transfer
    ADD CONSTRAINT stock_transfer_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_transfer_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_transfer
    ADD CONSTRAINT stock_transfer_transfer_no_key UNIQUE (transfer_no);


--
-- Name: voucher_lines voucher_lines_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.voucher_lines
    ADD CONSTRAINT voucher_lines_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.vouchers
    ADD CONSTRAINT vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: advance_payments advance_payments_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.advance_payments
    ADD CONSTRAINT advance_payments_pkey PRIMARY KEY (id);


--
-- Name: advance_payments advance_payments_voucher_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.advance_payments
    ADD CONSTRAINT advance_payments_voucher_no_key UNIQUE (voucher_no);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: biometric_entries biometric_entries_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.biometric_entries
    ADD CONSTRAINT biometric_entries_pkey PRIMARY KEY (id);


--
-- Name: eb_readings eb_readings_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.eb_readings
    ADD CONSTRAINT eb_readings_pkey PRIMARY KEY (id);


--
-- Name: job_work_entries job_work_entries_entry_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.job_work_entries
    ADD CONSTRAINT job_work_entries_entry_no_key UNIQUE (entry_no);


--
-- Name: job_work_entries job_work_entries_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.job_work_entries
    ADD CONSTRAINT job_work_entries_pkey PRIMARY KEY (id);


--
-- Name: labour_bills labour_bills_bill_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.labour_bills
    ADD CONSTRAINT labour_bills_bill_no_key UNIQUE (bill_no);


--
-- Name: labour_bills labour_bills_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.labour_bills
    ADD CONSTRAINT labour_bills_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.salary_vouchers
    ADD CONSTRAINT salary_vouchers_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.salary_vouchers
    ADD CONSTRAINT salary_vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: stock_adjustments stock_adjustments_adjustment_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_adjustments
    ADD CONSTRAINT stock_adjustments_adjustment_no_key UNIQUE (adjustment_no);


--
-- Name: stock_adjustments stock_adjustments_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_adjustments
    ADD CONSTRAINT stock_adjustments_pkey PRIMARY KEY (id);


--
-- Name: stock_inward stock_inward_inward_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_inward
    ADD CONSTRAINT stock_inward_inward_no_key UNIQUE (inward_no);


--
-- Name: stock_inward stock_inward_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_inward
    ADD CONSTRAINT stock_inward_pkey PRIMARY KEY (id);


--
-- Name: stock_item_movements stock_item_movements_movement_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_item_movements
    ADD CONSTRAINT stock_item_movements_movement_no_key UNIQUE (movement_no);


--
-- Name: stock_item_movements stock_item_movements_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_item_movements
    ADD CONSTRAINT stock_item_movements_pkey PRIMARY KEY (id);


--
-- Name: stock_outward stock_outward_outward_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_outward
    ADD CONSTRAINT stock_outward_outward_no_key UNIQUE (outward_no);


--
-- Name: stock_outward stock_outward_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_outward
    ADD CONSTRAINT stock_outward_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_transfer
    ADD CONSTRAINT stock_transfer_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_transfer_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_transfer
    ADD CONSTRAINT stock_transfer_transfer_no_key UNIQUE (transfer_no);


--
-- Name: voucher_lines voucher_lines_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.voucher_lines
    ADD CONSTRAINT voucher_lines_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.vouchers
    ADD CONSTRAINT vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: advance_payments advance_payments_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.advance_payments
    ADD CONSTRAINT advance_payments_pkey PRIMARY KEY (id);


--
-- Name: advance_payments advance_payments_voucher_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.advance_payments
    ADD CONSTRAINT advance_payments_voucher_no_key UNIQUE (voucher_no);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: biometric_entries biometric_entries_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.biometric_entries
    ADD CONSTRAINT biometric_entries_pkey PRIMARY KEY (id);


--
-- Name: eb_readings eb_readings_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.eb_readings
    ADD CONSTRAINT eb_readings_pkey PRIMARY KEY (id);


--
-- Name: job_work_entries job_work_entries_entry_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.job_work_entries
    ADD CONSTRAINT job_work_entries_entry_no_key UNIQUE (entry_no);


--
-- Name: job_work_entries job_work_entries_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.job_work_entries
    ADD CONSTRAINT job_work_entries_pkey PRIMARY KEY (id);


--
-- Name: labour_bills labour_bills_bill_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.labour_bills
    ADD CONSTRAINT labour_bills_bill_no_key UNIQUE (bill_no);


--
-- Name: labour_bills labour_bills_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.labour_bills
    ADD CONSTRAINT labour_bills_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.salary_vouchers
    ADD CONSTRAINT salary_vouchers_pkey PRIMARY KEY (id);


--
-- Name: salary_vouchers salary_vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.salary_vouchers
    ADD CONSTRAINT salary_vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: stock_adjustments stock_adjustments_adjustment_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_adjustments
    ADD CONSTRAINT stock_adjustments_adjustment_no_key UNIQUE (adjustment_no);


--
-- Name: stock_adjustments stock_adjustments_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_adjustments
    ADD CONSTRAINT stock_adjustments_pkey PRIMARY KEY (id);


--
-- Name: stock_inward stock_inward_inward_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_inward
    ADD CONSTRAINT stock_inward_inward_no_key UNIQUE (inward_no);


--
-- Name: stock_inward stock_inward_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_inward
    ADD CONSTRAINT stock_inward_pkey PRIMARY KEY (id);


--
-- Name: stock_item_movements stock_item_movements_movement_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_item_movements
    ADD CONSTRAINT stock_item_movements_movement_no_key UNIQUE (movement_no);


--
-- Name: stock_item_movements stock_item_movements_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_item_movements
    ADD CONSTRAINT stock_item_movements_pkey PRIMARY KEY (id);


--
-- Name: stock_outward stock_outward_outward_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_outward
    ADD CONSTRAINT stock_outward_outward_no_key UNIQUE (outward_no);


--
-- Name: stock_outward stock_outward_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_outward
    ADD CONSTRAINT stock_outward_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_transfer
    ADD CONSTRAINT stock_transfer_pkey PRIMARY KEY (id);


--
-- Name: stock_transfer stock_transfer_transfer_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_transfer
    ADD CONSTRAINT stock_transfer_transfer_no_key UNIQUE (transfer_no);


--
-- Name: voucher_lines voucher_lines_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.voucher_lines
    ADD CONSTRAINT voucher_lines_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_voucher_no_key; Type: CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.vouchers
    ADD CONSTRAINT vouchers_voucher_no_key UNIQUE (voucher_no);


--
-- Name: company pk_company; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.company
    ADD CONSTRAINT pk_company PRIMARY KEY (id);


--
-- Name: financial_years pk_financial_years; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.financial_years
    ADD CONSTRAINT pk_financial_years PRIMARY KEY (id);


--
-- Name: ledger_groups pk_ledger_groups; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledger_groups
    ADD CONSTRAINT pk_ledger_groups PRIMARY KEY (id);


--
-- Name: ledgers pk_ledgers; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledgers
    ADD CONSTRAINT pk_ledgers PRIMARY KEY (id);


--
-- Name: processes pk_processes; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.processes
    ADD CONSTRAINT pk_processes PRIMARY KEY (id);


--
-- Name: products pk_products; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.products
    ADD CONSTRAINT pk_products PRIMARY KEY (id);


--
-- Name: rates pk_rates; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.rates
    ADD CONSTRAINT pk_rates PRIMARY KEY (id);


--
-- Name: role_permissions pk_role_permissions; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.role_permissions
    ADD CONSTRAINT pk_role_permissions PRIMARY KEY (id);


--
-- Name: stock_items pk_stock_items; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.stock_items
    ADD CONSTRAINT pk_stock_items PRIMARY KEY (id);


--
-- Name: units_of_measure pk_units_of_measure; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.units_of_measure
    ADD CONSTRAINT pk_units_of_measure PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: financial_years uq_financial_years_year_str; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.financial_years
    ADD CONSTRAINT uq_financial_years_year_str UNIQUE (year_str);


--
-- Name: ledger_groups uq_ledger_groups_name; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledger_groups
    ADD CONSTRAINT uq_ledger_groups_name UNIQUE (name);


--
-- Name: ledgers uq_ledgers_ledger_code; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledgers
    ADD CONSTRAINT uq_ledgers_ledger_code UNIQUE (ledger_code);


--
-- Name: products uq_products_product_code; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.products
    ADD CONSTRAINT uq_products_product_code UNIQUE (product_code);


--
-- Name: stock_items uq_stock_items_item_code; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.stock_items
    ADD CONSTRAINT uq_stock_items_item_code UNIQUE (item_code);


--
-- Name: stock_items uq_stock_items_name; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.stock_items
    ADD CONSTRAINT uq_stock_items_name UNIQUE (name);


--
-- Name: units_of_measure uq_units_of_measure_name; Type: CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.units_of_measure
    ADD CONSTRAINT uq_units_of_measure_name UNIQUE (name);


--
-- Name: idx_fy_2023_2024_audit_date; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_audit_date ON fy_2023_2024.audit_logs USING btree (created_at);


--
-- Name: idx_fy_2023_2024_biometric_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_biometric_ledger ON fy_2023_2024.biometric_entries USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_inward_date; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_inward_date ON fy_2023_2024.stock_inward USING btree (inward_date);


--
-- Name: idx_fy_2023_2024_inward_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_inward_ledger ON fy_2023_2024.stock_inward USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_job_work_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_job_work_ledger ON fy_2023_2024.job_work_entries USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_labour_date; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_labour_date ON fy_2023_2024.labour_bills USING btree (bill_date);


--
-- Name: idx_fy_2023_2024_labour_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_labour_ledger ON fy_2023_2024.labour_bills USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_outward_date; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_outward_date ON fy_2023_2024.stock_outward USING btree (outward_date);


--
-- Name: idx_fy_2023_2024_outward_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_outward_ledger ON fy_2023_2024.stock_outward USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_voucher_lines_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_voucher_lines_ledger ON fy_2023_2024.voucher_lines USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_voucher_lines_voucher; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_voucher_lines_voucher ON fy_2023_2024.voucher_lines USING btree (voucher_id);


--
-- Name: idx_fy_2023_2024_vouchers_date; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_vouchers_date ON fy_2023_2024.vouchers USING btree (voucher_date);


--
-- Name: idx_fy_2023_2024_vouchers_ledger; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_vouchers_ledger ON fy_2023_2024.vouchers USING btree (ledger_id);


--
-- Name: idx_fy_2023_2024_vouchers_type; Type: INDEX; Schema: fy_2023_2024; Owner: orbx
--

CREATE INDEX idx_fy_2023_2024_vouchers_type ON fy_2023_2024.vouchers USING btree (voucher_type);


--
-- Name: idx_fy_2024_2025_audit_date; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_audit_date ON fy_2024_2025.audit_logs USING btree (created_at);


--
-- Name: idx_fy_2024_2025_biometric_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_biometric_ledger ON fy_2024_2025.biometric_entries USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_inward_date; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_inward_date ON fy_2024_2025.stock_inward USING btree (inward_date);


--
-- Name: idx_fy_2024_2025_inward_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_inward_ledger ON fy_2024_2025.stock_inward USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_job_work_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_job_work_ledger ON fy_2024_2025.job_work_entries USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_labour_date; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_labour_date ON fy_2024_2025.labour_bills USING btree (bill_date);


--
-- Name: idx_fy_2024_2025_labour_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_labour_ledger ON fy_2024_2025.labour_bills USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_outward_date; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_outward_date ON fy_2024_2025.stock_outward USING btree (outward_date);


--
-- Name: idx_fy_2024_2025_outward_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_outward_ledger ON fy_2024_2025.stock_outward USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_voucher_lines_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_voucher_lines_ledger ON fy_2024_2025.voucher_lines USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_voucher_lines_voucher; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_voucher_lines_voucher ON fy_2024_2025.voucher_lines USING btree (voucher_id);


--
-- Name: idx_fy_2024_2025_vouchers_date; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_vouchers_date ON fy_2024_2025.vouchers USING btree (voucher_date);


--
-- Name: idx_fy_2024_2025_vouchers_ledger; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_vouchers_ledger ON fy_2024_2025.vouchers USING btree (ledger_id);


--
-- Name: idx_fy_2024_2025_vouchers_type; Type: INDEX; Schema: fy_2024_2025; Owner: orbx
--

CREATE INDEX idx_fy_2024_2025_vouchers_type ON fy_2024_2025.vouchers USING btree (voucher_type);


--
-- Name: idx_fy_2025_2026_audit_date; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_audit_date ON fy_2025_2026.audit_logs USING btree (created_at);


--
-- Name: idx_fy_2025_2026_biometric_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_biometric_ledger ON fy_2025_2026.biometric_entries USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_inward_date; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_inward_date ON fy_2025_2026.stock_inward USING btree (inward_date);


--
-- Name: idx_fy_2025_2026_inward_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_inward_ledger ON fy_2025_2026.stock_inward USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_job_work_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_job_work_ledger ON fy_2025_2026.job_work_entries USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_labour_date; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_labour_date ON fy_2025_2026.labour_bills USING btree (bill_date);


--
-- Name: idx_fy_2025_2026_labour_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_labour_ledger ON fy_2025_2026.labour_bills USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_outward_date; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_outward_date ON fy_2025_2026.stock_outward USING btree (outward_date);


--
-- Name: idx_fy_2025_2026_outward_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_outward_ledger ON fy_2025_2026.stock_outward USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_voucher_lines_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_voucher_lines_ledger ON fy_2025_2026.voucher_lines USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_voucher_lines_voucher; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_voucher_lines_voucher ON fy_2025_2026.voucher_lines USING btree (voucher_id);


--
-- Name: idx_fy_2025_2026_vouchers_date; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_vouchers_date ON fy_2025_2026.vouchers USING btree (voucher_date);


--
-- Name: idx_fy_2025_2026_vouchers_ledger; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_vouchers_ledger ON fy_2025_2026.vouchers USING btree (ledger_id);


--
-- Name: idx_fy_2025_2026_vouchers_type; Type: INDEX; Schema: fy_2025_2026; Owner: orbx
--

CREATE INDEX idx_fy_2025_2026_vouchers_type ON fy_2025_2026.vouchers USING btree (voucher_type);


--
-- Name: idx_fy_2026_2027_audit_date; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_audit_date ON fy_2026_2027.audit_logs USING btree (created_at);


--
-- Name: idx_fy_2026_2027_biometric_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_biometric_ledger ON fy_2026_2027.biometric_entries USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_inward_date; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_inward_date ON fy_2026_2027.stock_inward USING btree (inward_date);


--
-- Name: idx_fy_2026_2027_inward_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_inward_ledger ON fy_2026_2027.stock_inward USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_job_work_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_job_work_ledger ON fy_2026_2027.job_work_entries USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_labour_date; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_labour_date ON fy_2026_2027.labour_bills USING btree (bill_date);


--
-- Name: idx_fy_2026_2027_labour_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_labour_ledger ON fy_2026_2027.labour_bills USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_outward_date; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_outward_date ON fy_2026_2027.stock_outward USING btree (outward_date);


--
-- Name: idx_fy_2026_2027_outward_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_outward_ledger ON fy_2026_2027.stock_outward USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_voucher_lines_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_voucher_lines_ledger ON fy_2026_2027.voucher_lines USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_voucher_lines_voucher; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_voucher_lines_voucher ON fy_2026_2027.voucher_lines USING btree (voucher_id);


--
-- Name: idx_fy_2026_2027_vouchers_date; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_vouchers_date ON fy_2026_2027.vouchers USING btree (voucher_date);


--
-- Name: idx_fy_2026_2027_vouchers_ledger; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_vouchers_ledger ON fy_2026_2027.vouchers USING btree (ledger_id);


--
-- Name: idx_fy_2026_2027_vouchers_type; Type: INDEX; Schema: fy_2026_2027; Owner: orbx
--

CREATE INDEX idx_fy_2026_2027_vouchers_type ON fy_2026_2027.vouchers USING btree (voucher_type);


--
-- Name: ix_master_ledger_groups_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_ledger_groups_id ON master.ledger_groups USING btree (id);


--
-- Name: ix_master_ledgers_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_ledgers_id ON master.ledgers USING btree (id);


--
-- Name: ix_master_ledgers_name; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_ledgers_name ON master.ledgers USING btree (name);


--
-- Name: ix_master_processes_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_processes_id ON master.processes USING btree (id);


--
-- Name: ix_master_products_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_products_id ON master.products USING btree (id);


--
-- Name: ix_master_rates_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_rates_id ON master.rates USING btree (id);


--
-- Name: ix_master_role_permissions_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_role_permissions_id ON master.role_permissions USING btree (id);


--
-- Name: ix_master_stock_items_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_stock_items_id ON master.stock_items USING btree (id);


--
-- Name: ix_master_units_of_measure_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_units_of_measure_id ON master.units_of_measure USING btree (id);


--
-- Name: ix_master_users_id; Type: INDEX; Schema: master; Owner: orbx
--

CREATE INDEX ix_master_users_id ON master.users USING btree (id);


--
-- Name: ix_master_users_username; Type: INDEX; Schema: master; Owner: orbx
--

CREATE UNIQUE INDEX ix_master_users_username ON master.users USING btree (username);


--
-- Name: stock_outward stock_outward_inward_id_fkey; Type: FK CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.stock_outward
    ADD CONSTRAINT stock_outward_inward_id_fkey FOREIGN KEY (inward_id) REFERENCES fy_2023_2024.stock_inward(id);


--
-- Name: voucher_lines voucher_lines_voucher_id_fkey; Type: FK CONSTRAINT; Schema: fy_2023_2024; Owner: orbx
--

ALTER TABLE ONLY fy_2023_2024.voucher_lines
    ADD CONSTRAINT voucher_lines_voucher_id_fkey FOREIGN KEY (voucher_id) REFERENCES fy_2023_2024.vouchers(id) ON DELETE CASCADE;


--
-- Name: stock_outward stock_outward_inward_id_fkey; Type: FK CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.stock_outward
    ADD CONSTRAINT stock_outward_inward_id_fkey FOREIGN KEY (inward_id) REFERENCES fy_2024_2025.stock_inward(id);


--
-- Name: voucher_lines voucher_lines_voucher_id_fkey; Type: FK CONSTRAINT; Schema: fy_2024_2025; Owner: orbx
--

ALTER TABLE ONLY fy_2024_2025.voucher_lines
    ADD CONSTRAINT voucher_lines_voucher_id_fkey FOREIGN KEY (voucher_id) REFERENCES fy_2024_2025.vouchers(id) ON DELETE CASCADE;


--
-- Name: stock_outward stock_outward_inward_id_fkey; Type: FK CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.stock_outward
    ADD CONSTRAINT stock_outward_inward_id_fkey FOREIGN KEY (inward_id) REFERENCES fy_2025_2026.stock_inward(id);


--
-- Name: voucher_lines voucher_lines_voucher_id_fkey; Type: FK CONSTRAINT; Schema: fy_2025_2026; Owner: orbx
--

ALTER TABLE ONLY fy_2025_2026.voucher_lines
    ADD CONSTRAINT voucher_lines_voucher_id_fkey FOREIGN KEY (voucher_id) REFERENCES fy_2025_2026.vouchers(id) ON DELETE CASCADE;


--
-- Name: stock_outward stock_outward_inward_id_fkey; Type: FK CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.stock_outward
    ADD CONSTRAINT stock_outward_inward_id_fkey FOREIGN KEY (inward_id) REFERENCES fy_2026_2027.stock_inward(id);


--
-- Name: voucher_lines voucher_lines_voucher_id_fkey; Type: FK CONSTRAINT; Schema: fy_2026_2027; Owner: orbx
--

ALTER TABLE ONLY fy_2026_2027.voucher_lines
    ADD CONSTRAINT voucher_lines_voucher_id_fkey FOREIGN KEY (voucher_id) REFERENCES fy_2026_2027.vouchers(id) ON DELETE CASCADE;


--
-- Name: ledger_groups fk_ledger_groups_parent_id_ledger_groups; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledger_groups
    ADD CONSTRAINT fk_ledger_groups_parent_id_ledger_groups FOREIGN KEY (parent_id) REFERENCES master.ledger_groups(id);


--
-- Name: ledgers fk_ledgers_group_id_ledger_groups; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.ledgers
    ADD CONSTRAINT fk_ledgers_group_id_ledger_groups FOREIGN KEY (group_id) REFERENCES master.ledger_groups(id);


--
-- Name: processes fk_processes_product_id_products; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.processes
    ADD CONSTRAINT fk_processes_product_id_products FOREIGN KEY (product_id) REFERENCES master.products(id);


--
-- Name: products fk_products_uom_id_units_of_measure; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.products
    ADD CONSTRAINT fk_products_uom_id_units_of_measure FOREIGN KEY (uom_id) REFERENCES master.units_of_measure(id);


--
-- Name: rates fk_rates_ledger_id_ledgers; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.rates
    ADD CONSTRAINT fk_rates_ledger_id_ledgers FOREIGN KEY (ledger_id) REFERENCES master.ledgers(id);


--
-- Name: rates fk_rates_process_id_processes; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.rates
    ADD CONSTRAINT fk_rates_process_id_processes FOREIGN KEY (process_id) REFERENCES master.processes(id);


--
-- Name: rates fk_rates_product_id_products; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.rates
    ADD CONSTRAINT fk_rates_product_id_products FOREIGN KEY (product_id) REFERENCES master.products(id);


--
-- Name: rates fk_rates_uom_id_units_of_measure; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.rates
    ADD CONSTRAINT fk_rates_uom_id_units_of_measure FOREIGN KEY (uom_id) REFERENCES master.units_of_measure(id);


--
-- Name: role_permissions fk_role_permissions_user_id_users; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.role_permissions
    ADD CONSTRAINT fk_role_permissions_user_id_users FOREIGN KEY (user_id) REFERENCES master.users(id) ON DELETE CASCADE;


--
-- Name: stock_items fk_stock_items_uom_id_units_of_measure; Type: FK CONSTRAINT; Schema: master; Owner: orbx
--

ALTER TABLE ONLY master.stock_items
    ADD CONSTRAINT fk_stock_items_uom_id_units_of_measure FOREIGN KEY (uom_id) REFERENCES master.units_of_measure(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 0oYzE0cdFISZnb3acZxb6yUGfkzNxdeRZbMJJDRKWWK7FQqHmwRLZSVYddxtZMZ

