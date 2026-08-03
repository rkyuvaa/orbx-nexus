--
-- PostgreSQL database dump
--

\restrict 2Ie990lwVOelci6ymv4nLygUOn0GcVgHLWbQ56xiSaIGhAMR4kEBHxUTJUaETpj

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
39	ADV_10_82	2023-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
40	ADV_11_97	2023-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
41	ADV_18_127	2023-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
42	ADV_1_62	2023-06-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
43	ADV_2_67	2023-06-21	1742	Payment	Contractor	0.00	20/06/2023 -1000 / 21/06/2023-2000	\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
44	ADV_3_68	2023-06-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
45	ADV_4_69	2023-06-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
46	ADV_5_70	2023-06-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
47	ADV_6_71	2023-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
48	ADV_7_72	2023-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
49	ADV_8_73	2023-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
50	ADV_9_74	2023-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
51	ADV_12_114	2023-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
52	ADV_13_115	2023-06-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
53	ADV_14_116	2023-06-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
54	ADV_15_117	2023-06-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
55	ADV_16_118	2023-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
56	ADV_17_126	2023-06-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
57	ADV_19_179	2023-07-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:10.6242	2026-08-03 14:42:10.6242
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
3	JW_26_707_99_0	2023-06-24	1866	2774	8	\N	67.000	87.00	5829.00	Register		\N	2026-08-03 14:42:10.664599	2026-08-03 14:42:10.664599
\.


--
-- Data for Name: labour_bills; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.labour_bills (id, bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, is_paid, payment_date, created_by, created_at, updated_at, items, outward_ids, dispatch_through) FROM stdin;
519	LB_2_694_2_0	2023-06-21	1604	\N	2761	8	1440.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
520	LB_31_697_40_0	2023-06-15	1604	\N	2764	\N	100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80058-10	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
521	LB_32_697_41_0	2023-06-16	1604	\N	2764	8	982.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80136-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
522	LB_32_701_41_1	2023-06-16	1604	\N	2768	8	1508.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80136-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
523	LB_33_697_42_0	2023-06-16	1604	\N	2764	\N	51.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80101-104	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
524	LB_34_698_43_0	2023-06-17	1604	\N	2765	\N	200.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80142-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
525	LB_35_702_44_0	2023-06-17	1603	\N	2769	8	439.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	40075-30	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
526	LB_36_705_45_0	2023-06-17	1604	\N	2772	8	1170.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80125-76,80151-24,80092-20,80101-13,80076-17	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
527	LB_37_701_46_0	2023-06-17	1604	\N	2768	8	1450.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80060-10	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
528	LB_38_698_47_0	2023-06-19	1604	\N	2765	\N	400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80142-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
529	LB_39_698_48_0	2023-06-19	1604	\N	2765	\N	200.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80151-76	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
530	LB_40_697_49_0	2023-06-20	1603	\N	2764	8	1965.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	40077-22	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
531	LB_41_701_50_0	2023-06-20	1604	\N	2768	8	1015.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80157-50,80092-30,80060-10	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
532	LB_41_703_50_1	2023-06-20	1604	\N	2770	8	4222.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80157-50,80092-30,80060-10	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
533	LB_42_698_51_0	2023-06-21	1604	\N	2765	\N	600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80165-180	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
534	LB_43_697_52_0	2023-06-22	1604	\N	2764	8	982.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4,80165-220	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
535	LB_47_697_88_0	2023-06-24	1604	\N	2764	8	491.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80060-20	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
536	LB_47_697_88_1	2023-06-24	1604	\N	2764	8	1638.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80060-20	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
537	LB_48_696_89_0	2023-06-24	1604	\N	2763	8	428.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80058-9,80060-21	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
538	LB_48_696_89_1	2023-06-24	1604	\N	2763	8	375.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80058-9,80060-21	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
539	LB_49_699_90_0	2023-06-24	1604	\N	2766	8	110.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80047-50,80058-23,80092-27,80181-80	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
540	LB_49_699_90_1	2023-06-24	1604	\N	2766	8	314.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80047-50,80058-23,80092-27,80181-80	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
541	LB_50_697_91_0	2023-06-24	1604	\N	2764	8	2457.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80189-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
542	LB_51_704_92_0	2023-06-24	1604	\N	2771	8	270.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80092-3	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
543	LB_51_699_92_1	2023-06-24	1604	\N	2766	8	425.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80092-3	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
544	LB_51_696_92_2	2023-06-24	1604	\N	2763	8	1608.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80092-3	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
545	LB_52_701_93_0	2023-06-24	1603	\N	2768	8	290.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	40077-8,40133-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
546	LB_53_697_103_0	2023-06-26	1603	\N	2764	8	2948.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
547	LB_62_703_134_0	2023-07-03	1603	\N	2770	8	1646.580	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40231-400,M4-40234-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
548	LB_62_702_134_1	2023-07-03	1603	\N	2769	8	43.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40231-400,M4-40234-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
549	LB_63_696_135_0	2023-07-03	1604	\N	2763	8	1340.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80208-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
550	LB_66_695_138_0	2023-07-04	1604	\N	2762	8	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80058-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
551	LB_66_696_138_1	2023-07-04	1604	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80058-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
552	LB_66_696_138_2	2023-07-04	1604	\N	2763	8	804.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80058-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
553	LB_70_698_142_0	2023-07-05	1604	\N	2765	8	1680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80213-170,M4-80225-34,M4-80222-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
554	LB_70_706_142_1	2023-07-05	1604	\N	2773	8	1530.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80213-170,M4-80225-34,M4-80222-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
555	LB_44_699_53_0	2023-06-22	1604	\N	2766	8	1275.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
556	LB_45_698_80_0	2023-06-23	1604	\N	2765	\N	200.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80164-30,80172-100,80181-20,80172-20,80181-5,80076-103	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
557	LB_54_697_104_0	2023-06-26	1604	\N	2764	8	3603.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	80181-95,80190-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
558	LB_55_696_106_0	2023-06-27	1603	\N	2763	\N	50.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211-50,M4-40219-150,M4-40216-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
559	LB_55_696_106_1	2023-06-27	1603	\N	2763	\N	70.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211-50,M4-40219-150,M4-40216-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
560	LB_55_695_106_2	2023-06-27	1603	\N	2762	\N	80.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40211-50,M4-40219-150,M4-40216-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
561	LB_56_697_113_0	2023-06-28	1603	\N	2764	8	2457.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40223-300	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
562	LB_71_697_143_0	2023-07-05	1603	\N	2764	8	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40232-621,M4-40234-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
563	LB_77_695_161_0	2023-07-08	1604	\N	2762	8	4320.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
564	LB_77_704_161_1	2023-07-08	1604	\N	2771	8	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
565	LB_78_706_164_0	2023-07-10	1604	\N	2773	8	2550.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80076-103	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
566	LB_79_712_165_0	2023-07-10	1603	\N	2779	8	254.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
567	LB_81_700_170_0	2023-07-13	1604	\N	2767	8	2688.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80237-56,M4-80238-5,M4-80237-244 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
568	LB_83_704_174_0	2023-07-14	1603	\N	2771	8	756.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-17,M4-40275-50,M4-40281-20 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
569	LB_83_704_174_1	2023-07-14	1603	\N	2771	8	67.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-17,M4-40275-50,M4-40281-20 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
570	LB_83_699_174_2	2023-07-14	1603	\N	2766	8	2074.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40260-17,M4-40275-50,M4-40281-20 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
571	LB_84_695_187_0	2023-07-17	1604	\N	2762	8	2160.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80244-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
572	LB_84_719_187_1	2023-07-17	1604	\N	2786	8	665.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80244-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
573	LB_84_720_187_2	2023-07-17	1604	\N	2787	8	976.580	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80244-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
574	LB_87_699_190_0	2023-07-19	1604	\N	2766	8	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80247-100 NOS,M4-80247-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
575	LB_87_704_190_1	2023-07-19	1604	\N	2771	8	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80247-100 NOS,M4-80247-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
576	LB_88_718_191_0	2023-07-19	1603	\N	2785	8	448.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40291-700	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
577	LB_92_697_199_0	2023-07-21	1603	\N	2764	8	720.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40291-300 NOS,M4-40304-500 NOS,M4-40301-87 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
578	LB_94_695_201_0	2023-07-22	1603	\N	2762	8	72.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-230	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
579	LB_94_695_201_1	2023-07-22	1603	\N	2762	8	2016.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-230	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
580	LB_95_718_202_0	2023-07-22	1603	\N	2785	8	192.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
581	LB_95_721_202_1	2023-07-22	1603	\N	2788	8	145.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
582	LB_95_717_202_2	2023-07-22	1603	\N	2784	8	565.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
583	LB_96_700_208_0	2023-07-22	1603	\N	2767	8	1920.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40309-40, M4-40304-500 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
584	LB_96_721_208_1	2023-07-22	1603	\N	2788	8	145.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40309-40, M4-40304-500 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
585	LB_98_719_210_0	2023-07-24	1604	\N	2786	8	1149.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80249-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
586	LB_98_720_210_1	2023-07-24	1604	\N	2787	8	1331.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80249-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
587	LB_98_695_210_2	2023-07-24	1604	\N	2762	8	216.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80249-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
588	LB_99_700_214_0	2023-07-26	1603	\N	2767	8	480.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-10,M4-40281-20,M4-40311-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
589	LB_99_700_214_1	2023-07-26	1603	\N	2767	8	960.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-10,M4-40281-20,M4-40311-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
590	LB_99_716_214_2	2023-07-26	1603	\N	2783	8	1440.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40303-10,M4-40281-20,M4-40311-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
591	LB_100_716_217_0	2023-07-26	1604	\N	2783	8	480.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80253-100,M4-80255-150 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
592	LB_100_716_217_1	2023-07-26	1604	\N	2783	8	2400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80253-100,M4-80255-150 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
593	LB_101_716_218_0	2023-07-26	1603	\N	2783	8	480.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40311-10 ,M4-40317-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
594	LB_101_716_218_1	2023-07-26	1603	\N	2783	8	2400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40311-10 ,M4-40317-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
595	LB_101_700_218_2	2023-07-26	1603	\N	2767	8	1920.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40311-10 ,M4-40317-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
596	LB_104_719_226_0	2023-07-29	1604	\N	2786	8	2117.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80252-35 NOS, M4-80252-9 NOS,M4-80253-10 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
597	LB_104_720_226_1	2023-07-29	1604	\N	2787	8	443.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80252-35 NOS, M4-80252-9 NOS,M4-80253-10 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
598	LB_104_696_226_2	2023-07-29	1604	\N	2763	8	241.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80252-35 NOS, M4-80252-9 NOS,M4-80253-10 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
599	LB_105_695_227_0	2023-07-29	1604	\N	2762	8	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80269-100 NOS,80269-100 NOS,M4-80270-163 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
600	LB_105_696_227_1	2023-07-29	1604	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80269-100 NOS,80269-100 NOS,M4-80270-163 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
601	LB_105_704_227_2	2023-07-29	1604	\N	2771	8	2200.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80269-100 NOS,80269-100 NOS,M4-80270-163 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
602	LB_112_695_234_0	2023-08-02	1604	\N	2762	8	108.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80278	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
603	LB_112_719_234_1	2023-08-02	1604	\N	2786	8	2117.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80278	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
604	LB_113_720_235_0	2023-08-03	1603	\N	2787	8	44.390	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
605	LB_113_720_235_1	2023-08-03	1603	\N	2787	8	1731.210	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
606	LB_113_722_235_2	2023-08-03	1603	\N	2789	8	331.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
607	LB_115_696_237_0	2023-08-04	1604	\N	2763	8	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-802778-74,M4-80286-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
608	LB_116_719_238_0	2023-08-05	1604	\N	2786	8	1210.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80292	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
609	LB_118_696_240_0	2023-08-07	1604	\N	2763	8	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80298 130 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
610	LB_120_704_245_0	2023-08-08	1604	\N	2771	8	999.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80301-68 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
611	LB_120_696_245_1	2023-08-08	1604	\N	2763	8	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80301-68 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
612	LB_121_725_246_0	2023-08-08	1603	\N	2792	8	283.610	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
613	LB_121_725_246_1	2023-08-08	1603	\N	2792	8	391.050	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
614	LB_121_726_246_2	2023-08-08	1603	\N	2793	8	116.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
615	LB_121_726_246_3	2023-08-08	1603	\N	2793	8	350.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
616	LB_121_723_246_4	2023-08-08	1603	\N	2790	8	588.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339  316,M4-40336-884	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
617	LB_125_696_274_0	2023-08-11	1604	\N	2763	8	3216.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80294-70 NOS, M4-80295-60 NOS, M480315-60 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
618	LB_126_697_275_0	2023-08-12	1603	\N	2764	8	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339-347, M4-40336-1000-NOS, M4-40336-109, M4-40358-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
619	LB_127_696_279_0	2023-08-12	1604	\N	2763	8	536.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
620	LB_127_696_279_1	2023-08-12	1604	\N	2763	8	3752.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
621	LB_127_704_279_2	2023-08-12	1604	\N	2771	8	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
622	LB_128_697_286_0	2023-08-12	1604	\N	2764	8	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80315-120 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
623	LB_128_697_286_1	2023-08-12	1604	\N	2764	8	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80315-120 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
624	LB_129_715_287_0	2023-08-14	1604	\N	2782	8	253.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
625	LB_129_714_287_1	2023-08-14	1604	\N	2781	8	650.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
626	LB_129_715_287_2	2023-08-14	1604	\N	2782	\N	100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
627	LB_129_715_287_3	2023-08-14	1604	\N	2782	\N	100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
628	LB_129_723_287_4	2023-08-14	1604	\N	2790	8	221.970	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
629	LB_129_723_287_5	2023-08-14	1604	\N	2790	8	1617.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80317-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
630	LB_130_704_288_0	2023-08-14	1604	\N	2771	8	1350.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80327-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
631	LB_132_695_294_0	2023-08-16	1604	\N	2762	8	1440.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80316-60 NOS, M4-80323-50 NOS, M4-80332-50,M4-80332-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
632	LB_132_695_294_1	2023-08-16	1604	\N	2762	8	1260.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80316-60 NOS, M4-80323-50 NOS, M4-80332-50,M4-80332-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
633	LB_134_697_296_0	2023-08-18	1603	\N	2764	8	2129.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
634	LB_134_697_296_1	2023-08-18	1603	\N	2764	8	1638.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
635	LB_134_697_296_2	2023-08-18	1603	\N	2764	8	2784.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
636	LB_134_728_296_3	2023-08-18	1603	\N	2795	8	621.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40268-39,M4-40329-100,M4-40329-100,M4-M4-339-151,M4-40336-1100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
637	LB_138_719_309_0	2023-08-21	1604	\N	2786	8	3630.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80347-130 NOS,M4-80350-100 NOS,M4-80349-170 NOS,M4-80349-69 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
638	LB_138_696_309_1	2023-08-21	1604	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80347-130 NOS,M4-80350-100 NOS,M4-80349-170 NOS,M4-80349-69 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
639	LB_139_698_310_0	2023-08-22	1604	\N	2765	8	2100.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80347-30 NOS, M4-80350-35 NOS,M4-80350-30 NOS,M4-80357-15 NOS,M4-80358-20 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
640	LB_140_696_316_0	2023-08-23	1603	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40392-35,M4-40422-15 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
641	LB_140_699_316_1	2023-08-23	1603	\N	2766	8	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40392-35,M4-40422-15 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
642	LB_141_699_319_0	2023-08-23	1604	\N	2766	8	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-140 NOS,M4-80357-125 NOS,M4-80359-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
643	LB_141_696_319_1	2023-08-23	1604	\N	2763	8	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-140 NOS,M4-80357-125 NOS,M4-80359-50 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
644	LB_142_695_320_0	2023-08-23	1604	\N	2762	8	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-70 NOS,M4-80359-300 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
645	LB_142_704_320_1	2023-08-23	1604	\N	2771	8	1350.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-70 NOS,M4-80359-300 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
646	LB_142_697_320_2	2023-08-23	1604	\N	2764	8	3439.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80349-70 NOS,M4-80359-300 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
647	LB_143_732_321_0	2023-08-25	1604	\N	2799	8	489.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80358-60 NOS, M4-80355-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
648	LB_146_696_326_0	2023-08-26	1604	\N	2763	8	4020.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80355-100 NOS,M4-80362- 100 NOS,M4-80359-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
649	LB_146_704_326_1	2023-08-26	1604	\N	2771	8	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80355-100 NOS,M4-80362- 100 NOS,M4-80359-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
650	LB_146_720_326_2	2023-08-26	1604	\N	2787	8	887.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80355-100 NOS,M4-80362- 100 NOS,M4-80359-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
651	LB_147_699_327_0	2023-08-26	1604	\N	2766	8	127.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
652	LB_147_697_327_1	2023-08-26	1604	\N	2764	8	655.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
653	LB_147_699_327_2	2023-08-26	1604	\N	2766	8	722.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
654	LB_147_704_327_3	2023-08-26	1604	\N	2771	8	810.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
655	LB_147_696_327_4	2023-08-26	1604	\N	2763	8	1340.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
656	LB_147_697_327_5	2023-08-26	1604	\N	2764	8	2457.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
657	LB_147_704_327_6	2023-08-26	1604	\N	2771	8	1485.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80362-100 NOS, M4-80356-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
658	LB_148_699_328_0	2023-08-29	1604	\N	2766	8	977.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
659	LB_148_720_328_1	2023-08-29	1604	\N	2787	8	887.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
660	LB_148_722_328_2	2023-08-29	1604	\N	2789	8	946.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
661	LB_148_699_328_3	2023-08-29	1604	\N	2766	8	1436.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
662	LB_148_704_328_4	2023-08-29	1604	\N	2771	8	540.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80365-100 NOS , M4-80366-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
663	LB_150_697_330_0	2023-08-30	1603	\N	2764	8	1638.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40421-5	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
664	LB_151_722_331_0	2023-08-30	1604	\N	2789	8	2838.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80375-150 NOS,M4-80367-50 NOS,M4-80373-20 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
665	LB_151_699_331_1	2023-08-30	1604	\N	2766	8	263.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80375-150 NOS,M4-80367-50 NOS,M4-80373-20 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
666	LB_153_732_333_0	2023-09-01	1603	\N	2799	8	2448.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40339-359,M4-40341,M4-40336-495,M4-40337-500	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
667	LB_155_719_351_0	2023-09-04	1604	\N	2786	6	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80381-100 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
668	LB_157_728_353_0	2023-09-05	1603	\N	2795	8	2034.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40479-25 Nos	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
669	LB_161_735_357_0	2023-09-07	1603	\N	2802	\N	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40497-25,M4-40558-150,M4-40558-300	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
670	LB_161_736_357_1	2023-09-07	1603	\N	2803	\N	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40497-25,M4-40558-150,M4-40558-300	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
671	LB_162_719_358_0	2023-09-07	1604	\N	2786	8	4840.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80382-100 NOS, M4-80387-51 NOS,M4-80385-170 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
672	LB_163_695_359_0	2023-09-08	1603	\N	2762	8	4680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40422-19,M4-40558-131,M4-40558-666,M4-40558-92,M4-40558-774	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
673	LB_163_699_359_1	2023-09-08	1603	\N	2766	8	850.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40422-19,M4-40558-131,M4-40558-666,M4-40558-92,M4-40558-774	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
674	LB_163_704_359_2	2023-09-08	1603	\N	2771	8	1012.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40422-19,M4-40558-131,M4-40558-666,M4-40558-92,M4-40558-774	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
675	LB_165_697_361_0	2023-09-09	1604	\N	2764	8	819.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80389-60	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
676	LB_165_697_361_1	2023-09-09	1604	\N	2764	8	3276.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80389-60	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
677	LB_166_699_362_0	2023-09-11	1604	\N	2766	8	1088.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-226	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
678	LB_166_704_362_1	2023-09-11	1604	\N	2771	8	1012.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-226	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
679	LB_166_696_362_2	2023-09-11	1604	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-226	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
680	LB_167_720_363_0	2023-09-12	1604	\N	2787	8	3551.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80383-80	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
681	LB_168_698_364_0	2023-09-12	1604	\N	2765	8	2940.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80390-130,M4-80392-100,M4-80392-75	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
682	LB_173_704_371_0	2023-09-15	1604	\N	2771	8	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80401-300	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
683	LB_175_108_373_0	2023-09-15	1604	\N	2175	8	682.480	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80401-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
684	LB_175_737_373_1	2023-09-15	1604	\N	2804	8	3863.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80401-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
685	LB_179_697_377_0	2023-09-20	1603	\N	2764	8	4095.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40558-1182	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
686	LB_179_728_377_1	2023-09-20	1603	\N	2795	8	180.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40558-1182	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
687	LB_180_698_378_0	2023-09-20	1604	\N	2765	8	378.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
688	LB_180_698_378_1	2023-09-20	1604	\N	2765	8	2940.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
689	LB_182_719_380_0	2023-09-22	1604	\N	2786	6	80.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80403-70,M4-80419-120	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
690	LB_184_739_382_0	2023-09-24	1604	\N	2806	8	749.866	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
691	LB_184_740_382_1	2023-09-24	1604	\N	2807	8	1542.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
692	LB_184_742_382_2	2023-09-24	1604	\N	2809	8	318.492	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
693	LB_184_741_382_3	2023-09-24	1604	\N	2808	8	1544.790	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
694	LB_185_739_383_0	2023-09-25	1604	\N	2806	6	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80421-124	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
695	LB_187_743_385_0	2023-09-27	1603	\N	2810	6	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40655-135	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
696	LB_188_704_386_0	2023-09-28	1604	\N	2771	8	675.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80422-250	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
697	LB_188_699_386_1	2023-09-28	1604	\N	2766	8	680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80422-250	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
698	LB_189_729_387_0	2023-09-29	1604	\N	2796	8	1749.360	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80435-100 NOS, M4-80435-30 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
699	LB_190_696_388_0	2023-10-04	1603	\N	2763	8	5360.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40655-115,M4-40672-118,M4-40672-20	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
700	LB_190_699_388_1	2023-10-04	1603	\N	2766	8	595.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40655-115,M4-40672-118,M4-40672-20	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
701	LB_192_745_390_0	2023-10-05	1604	\N	2812	6	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80443-400 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
702	LB_193_720_393_0	2023-10-07	1604	\N	2787	6	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80445-35,M4-80445-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
703	LB_195_746_395_0	2023-10-07	1603	\N	2813	8	1978.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40728-400	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
704	LB_197_696_397_0	2023-10-10	1640	\N	2763	8	3484.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
705	LB_198_699_398_0	2023-10-10	1604	\N	2766	8	595.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80452-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
706	LB_198_696_398_1	2023-10-10	1604	\N	2763	8	3216.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80452-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
707	LB_199_695_399_0	2023-10-10	1604	\N	2762	8	612.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
708	LB_199_720_399_1	2023-10-10	1604	\N	2787	8	1287.310	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
709	LB_199_722_399_2	2023-10-10	1604	\N	2789	8	1419.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
710	LB_199_695_399_3	2023-10-10	1604	\N	2762	8	2160.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80454-140	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
711	LB_204_696_404_0	2023-10-12	1603	\N	2763	8	3376.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40760-294	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
712	LB_205_696_405_0	2023-10-12	1604	\N	2763	8	3323.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80456-100,M4-80456-100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
713	LB_207_720_407_0	2023-10-13	1604	\N	2787	6	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80457-100,M4-80457-100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
714	LB_207_719_407_1	2023-10-13	1604	\N	2786	6	80.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80457-100,M4-80457-100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
715	LB_209_740_409_0	2023-10-16	1603	\N	2807	8	1598.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40769-50,M4-40776-1000,M4-40720-300	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
716	LB_210_741_410_0	2023-10-17	1604	\N	2808	8	2380.794	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80445-19,M4-80448-7,M4-80452-15,M4-80462-100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
717	LB_211_697_411_0	2023-10-18	1604	\N	2764	8	4095.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80448-10,M4-80462-100,M4-80463-15	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
718	LB_212_740_412_0	2023-10-18	1603	\N	2807	8	391.608	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40795-150	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
719	LB_213_740_413_0	2023-10-20	1604	\N	2807	8	7.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80448-33,M4-80463-15	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
720	LB_214_746_414_0	2023-10-20	1603	\N	2813	8	1463.855	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40779-300,M4-40795-72,M4-40820-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
721	LB_216_699_416_0	2023-10-25	1640	\N	2766	8	1147.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
722	LB_216_696_417_0	2023-10-25	1640	\N	2763	8	6700.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
723	LB_217_695_420_0	2023-10-25	1603	\N	2762	6	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40779-348,M4-40820-246,M4-40838-100,M4-40876-17	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
724	LB_217_722_420_1	2023-10-25	1603	\N	2789	6	60.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40779-348,M4-40820-246,M4-40838-100,M4-40876-17	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
725	LB_219_746_422_0	2023-10-27	1603	\N	2813	8	2027.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40720-100,M4-40876-83	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
726	LB_220_695_423_0	2023-10-28	1604	\N	2762	8	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80491-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
727	LB_220_696_423_1	2023-10-28	1604	\N	2763	8	804.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80491-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
728	LB_224_719_427_0	2023-10-30	1604	\N	2786	6	90.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80463-55	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
729	LB_228_695_431_0	2023-11-02	1603	\N	2762	6	15.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
730	LB_228_696_431_1	2023-11-02	1603	\N	2763	6	31.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
731	LB_228_720_431_2	2023-11-02	1603	\N	2787	6	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
732	LB_228_722_431_3	2023-11-02	1603	\N	2789	6	30.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
733	LB_228_719_431_4	2023-11-02	1603	\N	2786	6	30.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40915-594	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
734	LB_229_699_432_0	2023-11-03	1603	\N	2766	8	977.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40921-1050,M4-40921-766	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
735	LB_229_699_432_1	2023-11-03	1603	\N	2766	8	1003.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40921-1050,M4-40921-766	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
736	LB_229_717_432_2	2023-11-03	1603	\N	2784	8	130.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40921-1050,M4-40921-766	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
737	LB_231_746_436_0	2023-11-04	1604	\N	2813	8	1792.310	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80488-25,M4-80488-20,M4-80498-20,M4-80498-40	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
738	LB_259_742_437_0	2023-12-11	1640	\N	2809	8	528.854	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	2324U21JM00455,00467,00481,00477,00495,00522	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
739	LB_259_748_437_1	2023-12-11	1640	\N	2815	8	466.950	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	2324U21JM00455,00467,00481,00477,00495,00522	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
740	LB_233_741_438_0	2023-11-06	1603	\N	2808	8	617.916	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40932-100,M4-40933-100	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
741	LB_234_747_439_0	2023-11-08	1603	\N	2814	8	453.339	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40943-500,M4-40943-80,M4-40943-1000	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
742	LB_235_747_440_0	2023-11-09	1604	\N	2814	8	453.339	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80508-100,M4-80508-50	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
743	LB_236_747_441_0	2023-11-09	1603	\N	2814	8	568.896	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40943-678,M4-40958-500	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
744	LB_238_750_443_0	2023-11-15	1604	\N	2817	8	456.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80517-200	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
745	LB_240_747_445_0	2023-11-22	1603	\N	2814	8	453.339	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-40967-200 NOS,M4-40966-260 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
746	LB_241_697_446_0	2023-11-22	1604	\N	2764	8	6552.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80528-100 Nos	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
747	LB_242_750_447_0	2023-11-23	1604	\N	2817	8	798.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80526-200NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
748	LB_248_696_453_0	2023-11-30	1604	\N	2763	6	9.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80544-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
749	LB_248_695_453_1	2023-11-30	1604	\N	2762	6	15.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80544-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
750	LB_248_704_453_2	2023-11-30	1604	\N	2771	6	52.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80544-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
751	LB_249_695_454_0	2023-11-30	1603	\N	2762	8	1260.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41077-240NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
752	LB_249_719_454_1	2023-11-30	1603	\N	2786	8	2420.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41077-240NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
753	LB_254_718_459_0	2023-12-06	1604	\N	2785	8	417.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80557-170	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
754	LB_254_718_459_1	2023-12-06	1604	\N	2785	8	222.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80557-170	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
755	LB_255_712_460_0	2023-12-07	1604	\N	2779	8	3280.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80548-90	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
756	LB_257_719_462_0	2023-12-09	1604	\N	2786	8	4235.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80565-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
757	LB_257_722_462_1	2023-12-09	1604	\N	2789	8	946.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80565-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
758	LB_258_741_463_0	2023-12-11	1604	\N	2808	6	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80565-100,M4-80566-112,M4-80567-38 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
759	LB_260_741_464_0	2023-12-12	1604	\N	2808	6	65.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80571-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
760	LB_261_741_465_0	2023-12-13	1604	\N	2808	6	158.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80572-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
761	LB_262_747_466_0	2023-12-14	1603	\N	2814	6	34.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41026-75,M4-41097-75,M4-41123-110	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
762	LB_263_747_467_0	2023-12-15	1604	\N	2814	6	64.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80574-150 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
763	LB_264_746_468_0	2023-12-16	1604	\N	2813	8	2501.935	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80577-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
764	LB_266_746_470_0	2023-12-19	1395	\N	2813	8	2027.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
765	LB_268_697_472_0	2023-12-20	1603	\N	2764	6	33.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41097 -300 NO, M4-41210-86 NO	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
766	LB_269_719_473_0	2023-12-20	1640	\N	2786	8	3025.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	2324U21JM00477,00495,00420,00406,00413,00439	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
767	LB_270_697_474_0	2023-12-20	1604	\N	2764	8	2293.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80583-156	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
768	LB_271_733_475_0	2023-12-22	1604	\N	2800	8	1741.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80586-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
769	LB_272_712_476_0	2023-12-23	1604	\N	2779	8	2460.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80586-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
770	LB_272_698_476_1	2023-12-23	1604	\N	2765	8	2822.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80586-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
771	LB_274_719_478_0	2023-12-25	1604	\N	2786	8	1512.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80587	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
772	LB_274_696_478_1	2023-12-25	1604	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80587	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
773	LB_276_718_480_0	2023-12-27	1604	\N	2785	8	583.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80592-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
774	LB_277_698_481_0	2023-12-27	1604	\N	2765	8	1234.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80593-200 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
775	LB_278_695_482_0	2023-12-28	1604	\N	2762	8	3600.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80583-34 NOS,.M4-80593-200 NOS,M4-80594-100 NOS,M4-80598-36 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
776	LB_278_696_482_1	2023-12-28	1604	\N	2763	8	2680.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-80583-34 NOS,.M4-80593-200 NOS,M4-80594-100 NOS,M4-80598-36 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
777	LB_281_698_485_0	2024-02-23	1603	\N	2765	8	2730.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	M4-41236-120 NOS,M4-41236-300 NOS	f	\N	\N	2026-08-03 14:42:10.098963	2026-08-03 14:42:10.098963	[]	[]	\N
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
53	32	1387	0.00	30000.00	AMOUNT CREDITED INVOICE NO
54	32	1604	30000.00	0.00	AMOUNT CREDITED INVOICE NO
55	33	1387	0.00	130000.00	AMOUNT CREDITED FOR INVOICE NO
56	33	1604	130000.00	0.00	AMOUNT CREDITED FOR INVOICE NO
57	34	1425	0.00	170.00	POOJA EXPENSES FOR FRIDAY
58	34	1369	170.00	0.00	POOJA EXPENSES FOR FRIDAY
59	35	1605	0.00	150.00	
60	35	1394	150.00	0.00	
61	36	1425	0.00	150.00	MOUNT POINT STONE 10 NOS
62	36	1323	150.00	0.00	MOUNT POINT STONE 10 NOS
63	37	1425	0.00	200.00	PURCHASE OF MILK  COFFEE POWDER SUGAR AND CUP
64	37	1335	200.00	0.00	PURCHASE OF MILK  COFFEE POWDER SUGAR AND CUP
65	27	1617	0.00	2301.00	
66	27	1617	2301.00	0.00	
67	28	1617	0.00	16638.00	
68	28	1617	16638.00	0.00	
69	29	1425	0.00	17437.00	LABOUR CHARGE FOR 8 LABOURS
70	29	1618	17437.00	0.00	LABOUR CHARGE FOR 8 LABOURS
71	30	1425	0.00	5862.00	LABOUR CHARGE
72	30	1619	5862.00	0.00	LABOUR CHARGE
73	31	1425	0.00	13188.00	WEEKLY SALARY
74	31	1618	13188.00	0.00	WEEKLY SALARY
75	38	1641	0.00	50400.00	
76	38	1642	50400.00	0.00	
77	39	1425	0.00	45000.00	FG
78	39	1641	45000.00	0.00	FG
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2023_2024; Owner: orbx
--

COPY fy_2023_2024.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
32	PAY_1_64	Payment	2023-06-08	1387	30000.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
33	PAY_2_65	Payment	2023-06-16	1387	130000.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
34	PAY_3_75	Payment	2023-06-23	1425	170.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
35	PUR_1_76	Purchase	2023-06-23	1605	150.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
36	PAY_4_77	Payment	2023-06-23	1425	150.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
37	PAY_5_78	Payment	2023-06-23	1425	200.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
27	PUR_1_86	Purchase	2023-06-12	1617	2301.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
28	PUR_2_87	Purchase	2023-06-19	1617	16638.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
29	PAY_6_95	Payment	2023-06-24	1425	17437.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
30	PAY_7_96	Payment	2023-06-24	1425	5862.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
31	PAY_7_132	Payment	2023-07-01	1425	13188.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
38	PUR_3_369	Purchase	2023-09-15	1641	50400.00	Total Amount Include GST		\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
39	PAY_8_370	Payment	2023-09-15	1425	45000.00			\N	2026-08-03 14:42:08.602018	2026-08-03 14:42:08.602018
\.


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
5	ADV_1_29	2024-06-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:12.612396	2026-08-03 14:42:12.612396
6	ADV_2_30	2024-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:12.612396	2026-08-03 14:42:12.612396
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
221	LB_2_756_75_0	2024-07-01	1306	\N	2823	7	1387.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
222	LB_2_756_75_1	2024-07-01	1306	\N	2823	8	1387.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
223	LB_4_770_83_0	2024-07-03	1861	\N	2837	7	890.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
224	LB_4_770_83_1	2024-07-03	1861	\N	2837	8	890.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
225	LB_4_771_83_2	2024-07-03	1861	\N	2838	7	699.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
226	LB_4_771_83_3	2024-07-03	1861	\N	2838	8	699.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
227	LB_5_756_84_0	2024-07-03	1861	\N	2823	7	796.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
228	LB_5_756_84_1	2024-07-03	1861	\N	2823	8	796.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
229	LB_5_756_91_0	2024-07-05	1861	\N	2823	7	925.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
230	LB_5_756_91_1	2024-07-05	1861	\N	2823	8	925.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
231	LB_7_770_93_0	2024-07-06	1306	\N	2837	7	1800.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
232	LB_11_503_137_0	2024-07-18	1861	\N	2570	7	1144.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
233	LB_12_756_138_0	2024-07-18	1861	\N	2823	7	205.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
234	LB_12_756_138_1	2024-07-18	1861	\N	2823	8	205.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
235	LB_12_756_138_2	2024-07-18	1861	\N	2823	7	1207.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
236	LB_12_756_138_3	2024-07-18	1861	\N	2823	8	1207.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
237	LB_13_767_146_0	2024-07-20	1861	\N	2834	7	3150.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
238	LB_13_767_146_1	2024-07-20	1861	\N	2834	8	3150.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
239	LB_14_756_156_0	2024-07-29	1306	\N	2823	7	31.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
240	LB_14_756_156_1	2024-07-29	1306	\N	2823	8	31.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
241	LB_14_756_156_2	2024-07-29	1306	\N	2823	7	26.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
242	LB_14_756_156_3	2024-07-29	1306	\N	2823	8	26.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
243	LB_14_756_156_4	2024-07-29	1306	\N	2823	7	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
244	LB_14_756_156_5	2024-07-29	1306	\N	2823	8	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
245	LB_15_756_157_0	2024-07-30	1306	\N	2823	7	53.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
246	LB_15_756_157_1	2024-07-30	1306	\N	2823	8	53.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
247	LB_17_757_159_0	2024-07-30	1861	\N	2824	7	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
248	LB_17_757_159_1	2024-07-30	1861	\N	2824	8	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
249	LB_18_756_160_0	2024-07-30	1306	\N	2823	7	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
250	LB_18_756_160_1	2024-07-30	1306	\N	2823	8	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
251	LB_18_756_160_2	2024-07-30	1306	\N	2823	7	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
252	LB_18_756_160_3	2024-07-30	1306	\N	2823	8	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
253	LB_18_756_160_4	2024-07-30	1306	\N	2823	7	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
254	LB_18_756_160_5	2024-07-30	1306	\N	2823	8	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	HOTBLAST	f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
255	LB_19_756_161_0	2024-08-02	1306	\N	2823	7	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
256	LB_19_756_161_1	2024-08-02	1306	\N	2823	8	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
257	LB_20_758_162_0	2024-08-14	1306	\N	2825	7	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
258	LB_20_758_162_1	2024-08-14	1306	\N	2825	8	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
259	LB_21_796_163_0	2024-08-14	1306	\N	2863	8	50.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
260	LB_21_797_163_1	2024-08-14	1306	\N	2864	8	27.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
261	LB_22_797_164_0	2024-08-14	1861	\N	2864	6	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
262	LB_23_767_166_0	2024-08-21	1861	\N	2834	7	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
263	LB_23_767_166_1	2024-08-21	1861	\N	2834	8	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
264	LB_26_756_169_0	2024-08-24	1861	\N	2823	7	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
265	LB_26_756_169_1	2024-08-24	1861	\N	2823	8	40.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
266	LB_26_756_169_2	2024-08-24	1861	\N	2823	7	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
267	LB_26_756_169_3	2024-08-24	1861	\N	2823	8	57.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
268	LB_30_503_173_0	2024-08-28	1306	\N	2570	7	1366.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
269	LB_31_757_174_0	2024-08-29	1861	\N	2824	7	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
270	LB_31_757_174_1	2024-08-29	1861	\N	2824	8	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
271	LB_31_758_174_2	2024-08-29	1861	\N	2825	7	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
272	LB_31_758_174_3	2024-08-29	1861	\N	2825	8	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
273	LB_31_758_174_4	2024-08-29	1861	\N	2825	7	34.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
274	LB_31_758_174_5	2024-08-29	1861	\N	2825	8	34.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
275	LB_31_758_174_6	2024-08-29	1861	\N	2825	7	28.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
276	LB_31_758_174_7	2024-08-29	1861	\N	2825	8	28.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
277	LB_32_756_175_0	2024-08-29	1861	\N	2823	7	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
278	LB_32_756_175_1	2024-08-29	1861	\N	2823	8	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
279	LB_32_756_175_2	2024-08-29	1861	\N	2823	7	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
280	LB_32_756_175_3	2024-08-29	1861	\N	2823	8	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
281	LB_33_798_176_0	2024-08-30	1306	\N	2865	7	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
282	LB_33_798_176_1	2024-08-30	1306	\N	2865	8	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
283	LB_33_798_176_2	2024-08-30	1306	\N	2865	7	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
284	LB_33_798_176_3	2024-08-30	1306	\N	2865	8	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
285	LB_34_756_177_0	2024-08-31	1306	\N	2823	7	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
286	LB_34_756_177_1	2024-08-31	1306	\N	2823	8	16.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
287	LB_34_756_177_2	2024-08-31	1306	\N	2823	7	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
288	LB_34_756_177_3	2024-08-31	1306	\N	2823	8	41.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
289	LB_34_756_177_4	2024-08-31	1306	\N	2823	7	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
290	LB_34_756_177_5	2024-08-31	1306	\N	2823	8	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
291	LB_34_798_177_6	2024-08-31	1306	\N	2865	7	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
292	LB_34_798_177_7	2024-08-31	1306	\N	2865	8	12.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
293	LB_34_798_177_8	2024-08-31	1306	\N	2865	7	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
294	LB_34_798_177_9	2024-08-31	1306	\N	2865	8	74.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
295	LB_36_799_179_0	2024-09-03	1306	\N	2866	7	115.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
296	LB_36_799_179_1	2024-09-03	1306	\N	2866	8	115.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
297	LB_36_800_179_2	2024-09-03	1306	\N	2867	7	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
298	LB_36_800_179_3	2024-09-03	1306	\N	2867	8	23.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
299	LB_36_765_179_4	2024-09-03	1306	\N	2832	7	82.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
300	LB_36_765_179_5	2024-09-03	1306	\N	2832	8	82.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
301	LB_37_764_180_0	2024-09-04	1306	\N	2831	7	45.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
302	LB_37_764_180_1	2024-09-04	1306	\N	2831	8	45.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
303	LB_39_756_183_0	2024-09-12	1861	\N	2823	7	38.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
304	LB_39_756_183_1	2024-09-12	1861	\N	2823	8	38.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
305	LB_39_756_183_2	2024-09-12	1861	\N	2823	7	14.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
306	LB_39_756_183_3	2024-09-12	1861	\N	2823	8	14.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
307	LB_39_757_183_4	2024-09-12	1861	\N	2824	7	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
308	LB_39_757_183_5	2024-09-12	1861	\N	2824	8	43.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
309	LB_39_799_183_6	2024-09-12	1861	\N	2866	7	122.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
310	LB_39_799_183_7	2024-09-12	1861	\N	2866	8	122.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
311	LB_40_802_185_0	2024-09-17	1861	\N	2869	7	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
312	LB_40_801_185_1	2024-09-17	1861	\N	2868	7	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
313	LB_42_808_189_0	2024-09-19	1314	\N	2875	6	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
314	LB_42_809_189_1	2024-09-19	1314	\N	2876	6	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
315	LB_42_807_189_2	2024-09-19	1314	\N	2874	6	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
316	LB_42_805_189_3	2024-09-19	1314	\N	2872	6	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
317	LB_43_764_190_0	2024-09-19	1861	\N	2831	7	67.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
318	LB_43_764_190_1	2024-09-19	1861	\N	2831	7	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
319	LB_43_781_190_2	2024-09-19	1861	\N	2848	7	42.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
320	LB_45_635_192_0	2024-09-25	1861	\N	2637	7	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
321	LB_45_635_192_1	2024-09-25	1861	\N	2637	8	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
322	LB_45_635_192_2	2024-09-25	1861	\N	2637	9	2.175	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
323	LB_48_73_197_0	2024-10-22	1861	\N	2140	7	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
324	LB_48_645_197_1	2024-10-22	1861	\N	2647	7	48.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
325	LB_48_813_197_2	2024-10-22	1861	\N	2880	7	10.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
326	LB_48_59_197_3	2024-10-22	1861	\N	2127	7	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
327	LB_48_97_197_4	2024-10-22	1861	\N	2164	7	6.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
328	LB_48_300_197_5	2024-10-22	1861	\N	2367	7	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
329	LB_48_693_197_6	2024-10-22	1861	\N	2760	7	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
330	LB_49_90_198_0	2024-10-28	1861	\N	2157	6	15.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:12.463949	2026-08-03 14:42:12.463949	[]	[]	\N
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
1109	559	1358	0.00	16992.00	
1110	559	1658	16992.00	0.00	
1111	560	1282	0.00	23010.00	
1112	560	1658	23010.00	0.00	
1113	561	1349	0.00	1800.00	
1114	561	1365	1800.00	0.00	
1115	562	1387	0.00	16992.00	PURCHASE OF STEEL SHOTS
1116	562	1358	16992.00	0.00	PURCHASE OF STEEL SHOTS
1117	563	1387	0.00	11500.00	PURCHASE  OF WIRE CUT SHOTS
1118	563	1282	11500.00	0.00	PURCHASE  OF WIRE CUT SHOTS
1119	564	1387	0.00	1800.00	PURCHASE OF GLOUSE
1120	564	1349	1800.00	0.00	PURCHASE OF GLOUSE
1121	565	1387	0.00	6000.00	PURCASE OF PLYWOOD
1122	565	1323	6000.00	0.00	PURCASE OF PLYWOOD
1123	566	1387	0.00	1500.00	EXPENSES MADE FOR AUTO MURUGESAN
1124	566	1283	1500.00	0.00	EXPENSES MADE FOR AUTO MURUGESAN
1125	567	1387	0.00	3200.00	PURCHASE OF TUBE
1126	567	1284	3200.00	0.00	PURCHASE OF TUBE
1127	568	1387	0.00	1000.00	MIS ACC PURCHASED BY SHIVA
1128	568	1323	1000.00	0.00	MIS ACC PURCHASED BY SHIVA
1129	569	1387	0.00	3000.00	CASH PAID TO VEL CAMERA WIRING
1130	569	1285	3000.00	0.00	CASH PAID TO VEL CAMERA WIRING
1131	570	1387	0.00	3200.00	PURCHASE OF AIRTEL BROAD BAND
1132	570	1323	3200.00	0.00	PURCHASE OF AIRTEL BROAD BAND
1133	571	1425	0.00	1000.00	MURUGESH  GANDHIPURAM TO KNG PUDUR
1134	571	1283	1000.00	0.00	MURUGESH  GANDHIPURAM TO KNG PUDUR
1135	572	1387	0.00	3000.00	WORK DONE FOR NEW THUMB BLASTING MACH  PRAKESH
1136	572	1288	3000.00	0.00	WORK DONE FOR NEW THUMB BLASTING MACH  PRAKESH
1137	573	1425	0.00	150.00	Food Purchse For Hindhi Labour
1138	573	1335	150.00	0.00	Food Purchse For Hindhi Labour
1139	574	1387	0.00	505.00	Purchase Of Bolt Nuts And Crew
1140	574	1371	505.00	0.00	Purchase Of Bolt Nuts And Crew
1141	575	1387	0.00	50.00	Tea
1142	575	1335	50.00	0.00	Tea
1143	576	1387	0.00	130.00	Hose
1144	576	1284	130.00	0.00	Hose
1145	577	1387	0.00	450.00	Food
1146	577	1335	450.00	0.00	Food
1147	578	1387	0.00	150.00	Swith Purchase For Camera
1148	578	1288	150.00	0.00	Swith Purchase For Camera
1149	579	1387	0.00	1530.00	Card Board Sheet
1150	579	1323	1530.00	0.00	Card Board Sheet
1151	580	1387	0.00	800.00	Nillon Bush
1152	611	1387	0.00	50.00	TEA
1153	611	1335	50.00	0.00	TEA
1154	612	1387	0.00	1180.00	PURCHASE OF ACCOUNTS NOTE AND
1155	612	1351	1180.00	0.00	PURCHASE OF ACCOUNTS NOTE AND
1156	613	1387	0.00	250.00	LATHE WORK
1157	613	1301	250.00	0.00	LATHE WORK
1158	614	1387	0.00	250.00	CHAIN LOCK
1159	614	1301	250.00	0.00	CHAIN LOCK
1160	615	1387	0.00	300.00	SANTOR MACHINE SERVICE
1161	615	1301	300.00	0.00	SANTOR MACHINE SERVICE
1162	616	1387	0.00	140.00	WATER
1163	616	1336	140.00	0.00	WATER
1164	617	1387	0.00	300.00	BATHROOM CLEANING
1165	617	1305	300.00	0.00	BATHROOM CLEANING
1166	618	1387	0.00	150.00	TEA AND COFFEE AND BATTERY
1167	618	1335	150.00	0.00	TEA AND COFFEE AND BATTERY
1168	619	1387	0.00	100.00	BUS PIN
1169	619	1301	100.00	0.00	BUS PIN
1170	620	1387	0.00	500.00	FLEX BOARD FOR COMPANY
1171	620	1336	500.00	0.00	FLEX BOARD FOR COMPANY
1172	621	1387	0.00	2500.00	Power Factor Labour And Coil
1173	621	1371	2500.00	0.00	Power Factor Labour And Coil
1174	622	1387	0.00	700.00	Hose ,Ms Plate ,Lath Work
1175	622	1371	700.00	0.00	Hose ,Ms Plate ,Lath Work
1176	623	1387	0.00	400.00	
1177	623	1332	400.00	0.00	
1178	580	1323	800.00	0.00	Nillon Bush
1179	581	1387	0.00	770.00	Purchase Of Swith
1180	581	1288	770.00	0.00	Purchase Of Swith
1181	582	1387	0.00	100.00	Shiva
1182	582	1350	100.00	0.00	Shiva
1183	583	1387	0.00	40.00	Water
1184	583	1335	40.00	0.00	Water
1185	584	1387	0.00	600.00	Rent A Cutting Machine
1186	584	1371	600.00	0.00	Rent A Cutting Machine
1187	585	1387	0.00	5500.00	AMOUNT
1188	585	1285	5500.00	0.00	AMOUNT
1189	586	1387	0.00	5000.00	PRAKESH
1190	586	1288	5000.00	0.00	PRAKESH
1191	588	1387	0.00	10384.00	PURCHASE OF GRINDING STONE
1192	588	1299	10384.00	0.00	PURCHASE OF GRINDING STONE
1193	587	1299	0.00	10384.00	
1194	587	1300	10384.00	0.00	
1195	589	1299	0.00	2242.00	
1196	589	1300	2242.00	0.00	
1197	590	1387	0.00	2242.00	PURCHASE OF 9 INCH WHEEL
1198	590	1299	2242.00	0.00	PURCHASE OF 9 INCH WHEEL
1199	591	1387	0.00	500.00	PAID FOR MS BUSH
1200	591	1323	500.00	0.00	PAID FOR MS BUSH
1201	606	1387	0.00	500.00	PURCHASE OF VEGETABLE
1202	606	1618	500.00	0.00	PURCHASE OF VEGETABLE
1203	607	1387	0.00	3500.00	LABOUR CHARGES FOR PLYWOOD SHEET
1204	607	1302	3500.00	0.00	LABOUR CHARGES FOR PLYWOOD SHEET
1205	608	1387	0.00	210.00	BOLT AND NUT
1206	608	1323	210.00	0.00	BOLT AND NUT
1207	609	1387	0.00	750.00	AG7 WHEEL
1208	609	1323	750.00	0.00	AG7 WHEEL
1209	610	1387	0.00	50.00	WATER 20 LITER CAN
1210	610	1336	50.00	0.00	WATER 20 LITER CAN
1211	626	1387	0.00	1300.00	TRIPPER,HOSE WIRE FOR SUNG MACHINE
1212	626	1371	1300.00	0.00	TRIPPER,HOSE WIRE FOR SUNG MACHINE
1213	627	1387	0.00	200.00	TAG BFILE,BOX FILE
1214	628	1387	0.00	300.00	TOILET CLEANING
1215	628	1336	300.00	0.00	TOILET CLEANING
1216	629	1387	0.00	100.00	SARAVANAN LUNCH
1217	629	1335	100.00	0.00	SARAVANAN LUNCH
1218	630	1387	0.00	753.00	FLOWER,VESSEL
1219	630	1369	753.00	0.00	FLOWER,VESSEL
1220	631	1299	0.00	380.00	
1221	631	1323	380.00	0.00	
1222	632	1387	0.00	150.00	DRINKING WATER,MILK
1223	632	1335	150.00	0.00	DRINKING WATER,MILK
1224	633	1387	0.00	380.00	GPAY TO NAGARAJ
1225	633	1299	380.00	0.00	GPAY TO NAGARAJ
1226	634	1387	0.00	200.00	SUNG MACHINE WELDING
1227	634	1302	200.00	0.00	SUNG MACHINE WELDING
1228	635	1387	0.00	120.00	
1229	635	1316	120.00	0.00	
1230	636	1387	0.00	800.00	800 LTS
1231	636	1332	800.00	0.00	800 LTS
1232	637	1387	0.00	30.00	
1233	637	1316	30.00	0.00	
1234	638	1387	0.00	150.00	MOTAR PIPE
1235	638	1301	150.00	0.00	MOTAR PIPE
1236	639	1387	0.00	100.00	FOOD BABU
1237	639	1335	100.00	0.00	FOOD BABU
1238	640	1387	0.00	300.00	SWITCH BOX
1239	640	1288	300.00	0.00	SWITCH BOX
1240	641	1387	0.00	1100.00	GLASS CUP
1241	641	1336	1100.00	0.00	GLASS CUP
1242	642	1387	0.00	10000.00	NEW PURCHASE ADVANCE (BUFFING MOTAR)
1243	642	1345	10000.00	0.00	NEW PURCHASE ADVANCE (BUFFING MOTAR)
1244	643	1387	0.00	650.00	
1245	643	1369	650.00	0.00	
1246	644	1387	0.00	50.00	MILK
1247	644	1316	50.00	0.00	MILK
1248	645	1387	0.00	7434.00	2 GRINING WHEEL,10 AG9 WHEEL
1249	645	1299	7434.00	0.00	2 GRINING WHEEL,10 AG9 WHEEL
1250	646	1387	0.00	5001.00	ADVANCE
1251	646	1313	5001.00	0.00	ADVANCE
1252	647	1387	0.00	5000.00	GENSET RENT
1253	647	1301	5000.00	0.00	GENSET RENT
1254	648	1387	0.00	300.00	LUNCH
1255	648	1335	300.00	0.00	LUNCH
1256	649	1299	0.00	7434.00	
1257	649	1323	7434.00	0.00	
1258	650	1387	28594.00	0.00	CASH RECEIVED THROUGH BANK
1259	650	1306	0.00	28594.00	CASH RECEIVED THROUGH BANK
1260	651	1387	32926.00	0.00	PAYMENT RECEIVED Bill No 1-6
1261	651	1357	0.00	32926.00	PAYMENT RECEIVED Bill No 1-6
1262	624	1387	0.00	100.00	Tea
1263	624	1335	100.00	0.00	Tea
1264	625	1387	0.00	300.00	Carbon Brush
1265	625	1371	300.00	0.00	Carbon Brush
1266	592	1387	0.00	50.00	Tea
1267	592	1335	50.00	0.00	Tea
1268	593	1387	0.00	100.00	Tea
1269	593	1335	100.00	0.00	Tea
1270	594	1387	0.00	100.00	Files
1271	594	1381	100.00	0.00	Files
1272	595	1387	0.00	200.00	TEA
1273	595	1335	200.00	0.00	TEA
1274	596	1387	0.00	400.00	JALLI,CEMENT HALF BAG FOR SUNG MACHINE
1275	597	1387	0.00	500.00	DRILLING MACHINE RENT
1276	597	1301	500.00	0.00	DRILLING MACHINE RENT
1277	598	1387	0.00	1000.00	SUNG MACHINE HOLES LABOUR CHARGES
1278	598	1336	1000.00	0.00	SUNG MACHINE HOLES LABOUR CHARGES
1279	599	1387	0.00	3750.00	AG9 MACHINE
1280	599	1301	3750.00	0.00	AG9 MACHINE
1281	600	1425	0.00	100.00	SHIVA
1282	600	1350	100.00	0.00	SHIVA
1283	601	1425	0.00	500.00	29/6/2024 To 5/7/2024
1284	601	1316	500.00	0.00	29/6/2024 To 5/7/2024
1285	602	1425	0.00	280.00	Water
1286	602	1335	280.00	0.00	Water
1287	603	1387	0.00	1000.00	LABOUR CHARGES
1288	603	1302	1000.00	0.00	LABOUR CHARGES
1289	604	1387	0.00	800.00	CALCULATOR
1290	604	1381	800.00	0.00	CALCULATOR
1291	605	1387	0.00	400.00	
1292	605	1369	400.00	0.00	
1293	802	1387	0.00	100.00	RAHUL LUNCH
1294	802	1315	100.00	0.00	RAHUL LUNCH
1295	803	1387	0.00	100.00	MARIMUTHU
1296	803	1315	100.00	0.00	MARIMUTHU
1297	804	1387	0.00	100.00	RAJ KUMAR
1298	804	1315	100.00	0.00	RAJ KUMAR
1299	805	1387	0.00	5000.00	AC FITTING
1300	805	1589	5000.00	0.00	AC FITTING
1301	806	1387	0.00	510.00	Grinding Stone Purchase
1302	806	1300	510.00	0.00	Grinding Stone Purchase
1303	807	1387	0.00	650.00	Cutter And Blue Paint
1304	807	1301	650.00	0.00	Cutter And Blue Paint
1305	808	1387	0.00	100.00	Tea
1306	808	1316	100.00	0.00	Tea
1307	809	1387	0.00	90.00	Rajkumar
1308	809	1315	90.00	0.00	Rajkumar
1309	810	1387	0.00	90.00	Janarthan
1310	810	1315	90.00	0.00	Janarthan
1311	811	1387	0.00	60.00	Rahul
1312	811	1315	60.00	0.00	Rahul
1313	812	1387	0.00	20.00	Ranjitha
1314	812	1315	20.00	0.00	Ranjitha
1315	813	1387	0.00	100.00	Water
1316	813	1586	100.00	0.00	Water
1317	814	1379	0.00	24898.00	
1318	814	1323	24898.00	0.00	
1319	815	1387	0.00	115.00	TEA
1320	815	1316	115.00	0.00	TEA
1321	816	1387	0.00	60.00	RAHUL
1322	816	1315	60.00	0.00	RAHUL
1323	817	1387	0.00	90.00	SELVAM
1324	817	1315	90.00	0.00	SELVAM
1325	818	1387	0.00	90.00	RAJ KUMAR
1326	818	1315	90.00	0.00	RAJ KUMAR
1327	819	1387	0.00	90.00	JANARTHAN
1328	819	1315	90.00	0.00	JANARTHAN
1329	653	1387	0.00	1500.00	REWORK TABLE
1330	653	1302	1500.00	0.00	REWORK TABLE
1331	652	1387	0.00	2000.00	CORNER BED WORK
1332	652	1302	2000.00	0.00	CORNER BED WORK
1333	654	1387	0.00	500.00	MACHINE FOR RENT
1334	654	1301	500.00	0.00	MACHINE FOR RENT
1335	655	1387	0.00	275.00	CUTTING WHEEL,BOLT,WELDING ROD
1336	655	1371	275.00	0.00	CUTTING WHEEL,BOLT,WELDING ROD
1337	656	1387	0.00	1000.00	CORNER BED JALLI, CEMENT ,MANAL,JANATHACEM
1338	657	1387	0.00	100.00	SHIVA
1339	657	1350	100.00	0.00	SHIVA
1340	658	1387	0.00	700.00	RICE FROM RATION
1341	658	1335	700.00	0.00	RICE FROM RATION
1342	659	1387	0.00	700.00	LUNCH
1343	659	1335	700.00	0.00	LUNCH
1344	660	1387	0.00	1908.00	ANGLE FOR REWORK TABLE BOLT AND NUT AUTO RENT
1345	660	1301	1908.00	0.00	ANGLE FOR REWORK TABLE BOLT AND NUT AUTO RENT
1346	661	1387	30560.00	0.00	Payment Received
1347	661	1306	0.00	30560.00	Payment Received
1348	662	1387	30000.00	0.00	
1349	662	1357	0.00	30000.00	
1350	663	1387	35000.00	0.00	
1351	663	1306	0.00	35000.00	
1352	664	1387	17151.00	0.00	
1353	664	1306	0.00	17151.00	
1354	665	1387	40000.00	0.00	RTGST
1355	665	1357	0.00	40000.00	RTGST
1356	666	1387	0.00	1250.00	Ag9 Wheel Purchased
1357	666	1300	1250.00	0.00	Ag9 Wheel Purchased
1358	667	1387	0.00	1000.00	Lineman Nagaraj
1359	667	1336	1000.00	0.00	Lineman Nagaraj
1360	668	1387	42847.00	0.00	Payment Received
1361	668	1357	0.00	42847.00	Payment Received
1362	669	1387	75000.00	0.00	
1363	669	1357	0.00	75000.00	
1364	670	1379	0.00	24898.00	
1365	670	1323	24898.00	0.00	
1366	671	1321	0.00	20296.00	
1367	671	1323	20296.00	0.00	
1368	672	1486	0.00	12730.00	
1369	672	1323	12730.00	0.00	
1370	673	1486	0.00	23300.00	
1371	673	1323	23300.00	0.00	
1372	674	1282	0.00	32500.00	
1373	674	1323	32500.00	0.00	
1374	675	1387	0.00	2400.00	PURCHASE OF HELMET JACKET
1375	675	1336	2400.00	0.00	PURCHASE OF HELMET JACKET
1376	676	1387	0.00	2200.00	BALAJI TOOLS HAMMER PURCHASE
1377	676	1336	2200.00	0.00	BALAJI TOOLS HAMMER PURCHASE
1378	677	1387	0.00	100.00	CASH PAID TO SHIVA
1379	677	1350	100.00	0.00	CASH PAID TO SHIVA
1380	678	1387	0.00	100000.00	CASH PAID FOR CRANE ADVANCE
1381	678	1336	100000.00	0.00	CASH PAID FOR CRANE ADVANCE
1382	679	1387	0.00	150.00	AG4 MACHINE RENT
1383	679	1336	150.00	0.00	AG4 MACHINE RENT
1384	680	1387	0.00	300.00	CUTTING WHEEL 20 NOS
1385	680	1336	300.00	0.00	CUTTING WHEEL 20 NOS
1386	681	1387	0.00	225.00	PURCHASE OF MEALS 3 NOS
1387	681	1335	225.00	0.00	PURCHASE OF MEALS 3 NOS
1388	682	1387	0.00	3500.00	LORRY RENT FOR SHIFTING CRANE
1389	682	1318	3500.00	0.00	LORRY RENT FOR SHIFTING CRANE
1390	683	1387	0.00	2000.00	CRANR LOADING
1391	683	1336	2000.00	0.00	CRANR LOADING
1392	684	1387	0.00	5500.00	CRANE DISMANDLED LABOUR CHARGE
1393	684	1301	5500.00	0.00	CRANE DISMANDLED LABOUR CHARGE
1394	685	1387	0.00	200.00	TEA EXPENSES
1395	685	1316	200.00	0.00	TEA EXPENSES
1396	686	1387	0.00	2000.00	WELDING SALARY
1397	686	1302	2000.00	0.00	WELDING SALARY
1398	687	1387	0.00	1500.00	CRANE UNLOADING CHARGE
1399	687	1336	1500.00	0.00	CRANE UNLOADING CHARGE
1400	688	1387	0.00	100.00	PETROL
1401	688	1350	100.00	0.00	PETROL
1402	689	1387	0.00	24898.00	PURCHASE OF PAINT
1403	689	1379	24898.00	0.00	PURCHASE OF PAINT
1404	690	1387	0.00	12730.00	SHEET PURCHASE
1405	690	1486	12730.00	0.00	SHEET PURCHASE
1406	691	1387	0.00	500.00	AUTO
1407	691	1283	500.00	0.00	AUTO
1408	692	1387	0.00	400.00	WHEEL
1409	692	1336	400.00	0.00	WHEEL
1410	693	1387	0.00	150.00	RAVI LUNCH
1411	693	1302	150.00	0.00	RAVI LUNCH
1412	694	1387	0.00	150.00	SELVAM RAJ KUMAR LUNCH
1413	694	1315	150.00	0.00	SELVAM RAJ KUMAR LUNCH
1414	695	1387	0.00	60000.00	RENT FOR THE MONTH FEB 2025
1415	695	1491	60000.00	0.00	RENT FOR THE MONTH FEB 2025
1416	696	1387	0.00	4000.00	EB
1417	696	1317	4000.00	0.00	EB
1418	697	1387	0.00	500.00	LABOUR
1419	697	1302	500.00	0.00	LABOUR
1420	698	1387	0.00	700.00	BABU MECHENICS FOR CHANGE AIRHOUSE
1421	698	1492	700.00	0.00	BABU MECHENICS FOR CHANGE AIRHOUSE
1422	699	1387	0.00	400.00	WELDING ROD
1423	699	1336	400.00	0.00	WELDING ROD
1424	700	1387	0.00	150.00	2NO'S LUNCH FOR RAVI AND RAJAN
1425	700	1302	150.00	0.00	2NO'S LUNCH FOR RAVI AND RAJAN
1426	701	1387	0.00	100.00	2 CAN WATER 40 LITER
1427	701	1586	100.00	0.00	2 CAN WATER 40 LITER
1428	702	1387	0.00	800.00	SELVAN MONDAY SALARY
1429	702	1587	800.00	0.00	SELVAN MONDAY SALARY
1430	703	1387	0.00	100.00	AUTO RENT
1431	703	1283	100.00	0.00	AUTO RENT
1432	704	1387	0.00	750.00	RAJAN SALARY
1433	704	1588	750.00	0.00	RAJAN SALARY
1434	705	1387	0.00	3000.00	RAVI WELDING
1435	705	1302	3000.00	0.00	RAVI WELDING
1436	706	1387	0.00	150.00	TEA
1437	706	1316	150.00	0.00	TEA
1438	707	1387	0.00	10000.00	OFFICE FALSELING G PAY
1439	707	1589	10000.00	0.00	OFFICE FALSELING G PAY
1440	708	1387	0.00	4000.00	TUBE LIGHT FITTING
1441	708	1589	4000.00	0.00	TUBE LIGHT FITTING
1442	709	1387	0.00	100.00	TEA
1443	709	1316	100.00	0.00	TEA
1444	710	1387	0.00	2000.00	OFFICE FALSELING BALANCE PAYMENT
1445	710	1589	2000.00	0.00	OFFICE FALSELING BALANCE PAYMENT
1446	711	1387	0.00	250.00	LUNCH FOR RAVI (3, RAJAN)
1447	711	1315	250.00	0.00	LUNCH FOR RAVI (3, RAJAN)
1448	712	1387	0.00	100.00	PETROL SHIVA
1449	712	1350	100.00	0.00	PETROL SHIVA
1450	713	1387	0.00	700.00	RAJAN SALARY
1451	713	1588	700.00	0.00	RAJAN SALARY
1452	714	1387	0.00	100.00	TEA
1453	714	1316	100.00	0.00	TEA
1454	715	1387	0.00	100.00	RAJAN LUNCH
1455	715	1315	100.00	0.00	RAJAN LUNCH
1456	716	1387	0.00	100.00	CAN WATER
1457	716	1586	100.00	0.00	CAN WATER
1458	717	1387	0.00	300.00	Bolt,Snack,
1459	717	1336	300.00	0.00	Bolt,Snack,
1460	718	1387	0.00	200.00	Ravi Lunch
1461	718	1302	200.00	0.00	Ravi Lunch
1462	719	1387	0.00	2100.00	Crane
1463	719	1336	2100.00	0.00	Crane
1464	720	1387	0.00	2000.00	Ravi Salary
1465	720	1302	2000.00	0.00	Ravi Salary
1466	721	1387	0.00	400.00	Oil,Pipe
1467	721	1336	400.00	0.00	Oil,Pipe
1468	722	1387	0.00	100.00	Tea
1469	722	1316	100.00	0.00	Tea
1470	723	1387	0.00	20300.00	T.V Bros
1471	723	1321	20300.00	0.00	T.V Bros
1472	724	1387	0.00	350.00	Welding Rod
1473	724	1336	350.00	0.00	Welding Rod
1474	725	1387	0.00	280.00	5 No's Lunch
1475	725	1315	280.00	0.00	5 No's Lunch
1476	726	1387	0.00	1200.00	Auto Rent For Turbonail Gp Paint
1477	726	1283	1200.00	0.00	Auto Rent For Turbonail Gp Paint
1478	727	1387	0.00	3200.00	Gear Wheel , Bolt
1479	727	1336	3200.00	0.00	Gear Wheel , Bolt
1480	728	1387	0.00	100.00	Tea
1481	728	1316	100.00	0.00	Tea
1482	729	1387	0.00	2000.00	Ravi Welding
1483	729	1302	2000.00	0.00	Ravi Welding
1484	730	1387	0.00	500.00	Panel Erection Labour
1485	730	1335	500.00	0.00	Panel Erection Labour
1486	731	1387	0.00	23300.00	3mm Sheet
1487	731	1336	23300.00	0.00	3mm Sheet
1488	732	1387	0.00	100.00	Petrol
1489	732	1350	100.00	0.00	Petrol
1490	733	1387	0.00	100.00	Tea
1491	733	1316	100.00	0.00	Tea
1492	734	1387	0.00	10000.00	Room Advance
1493	734	1592	10000.00	0.00	Room Advance
1494	735	1387	0.00	650.00	MCB Purchase
1495	735	1288	650.00	0.00	MCB Purchase
1496	736	1387	0.00	100.00	Tea
1497	736	1316	100.00	0.00	Tea
1498	737	1387	0.00	230.00	Lunch For 4 members
1499	737	1335	230.00	0.00	Lunch For 4 members
1500	738	1387	0.00	120.00	Ravi Lunch
1501	738	1302	120.00	0.00	Ravi Lunch
1502	739	1387	0.00	50.00	Can Water
1503	763	1387	0.00	9600.00	Cement, Hollo Bricks
1504	764	1387	0.00	700.00	Pooja Expenses
1505	764	1589	700.00	0.00	Pooja Expenses
1506	765	1387	0.00	200.00	Tea
1507	765	1316	200.00	0.00	Tea
1508	766	1387	0.00	100.00	Bolt
1509	766	1336	100.00	0.00	Bolt
1510	767	1387	0.00	11000.00	Panel Board Service Labour
1511	767	1335	11000.00	0.00	Panel Board Service Labour
1512	768	1387	0.00	200.00	Tea
1513	768	1316	200.00	0.00	Tea
1514	769	1595	0.00	7316.00	
1515	769	1323	7316.00	0.00	
1516	770	1321	0.00	20296.00	
1517	770	1323	20296.00	0.00	
1518	771	1387	0.00	2263.00	FOR OFFICE  PRINTING & STATIONARY
1519	771	1381	2263.00	0.00	FOR OFFICE  PRINTING & STATIONARY
1520	772	1387	0.00	250.00	LADDU (SWEETS)
1521	772	1369	250.00	0.00	LADDU (SWEETS)
1522	773	1387	0.00	30.00	KALKADU (SWEET)
1523	773	1369	30.00	0.00	KALKADU (SWEET)
1524	774	1387	0.00	1100.00	GLASS BALANCE PAID
1525	774	1589	1100.00	0.00	GLASS BALANCE PAID
1526	775	1387	0.00	3000.00	CRANE SERVICE LABOUR
1527	775	1335	3000.00	0.00	CRANE SERVICE LABOUR
1528	776	1387	0.00	200.00	CRANE LABOUR LUNCH
1529	776	1315	200.00	0.00	CRANE LABOUR LUNCH
1530	777	1387	0.00	100.00	ANAND DRIVER LUNCH
1531	777	1315	100.00	0.00	ANAND DRIVER LUNCH
1532	778	1387	0.00	100.00	MARIMUTHU LUNCH
1533	778	1315	100.00	0.00	MARIMUTHU LUNCH
1534	779	1387	0.00	80.00	RAGHUL
1535	779	1315	80.00	0.00	RAGHUL
1536	780	1387	0.00	400.00	TEA EXPENSES
1537	780	1316	400.00	0.00	TEA EXPENSES
1538	781	1387	0.00	100.00	SANJAY HINDI LUNCH
1539	781	1315	100.00	0.00	SANJAY HINDI LUNCH
1540	782	1387	0.00	100.00	TEA EXPENSES
1541	782	1316	100.00	0.00	TEA EXPENSES
1542	783	1387	0.00	10000.00	GRINDING WHEEL 4NO'S
1543	783	1597	10000.00	0.00	GRINDING WHEEL 4NO'S
1544	784	1387	0.00	396.00	AUTO RENT FOR AC
1545	784	1283	396.00	0.00	AUTO RENT FOR AC
1546	785	1387	0.00	350.00	6NO'S  CRANE U CLAMP
1547	785	1606	350.00	0.00	6NO'S  CRANE U CLAMP
1548	786	1387	0.00	200.00	2NO'S OF LUNCH FOR CRANE LABOUR
1549	786	1315	200.00	0.00	2NO'S OF LUNCH FOR CRANE LABOUR
1550	787	1387	0.00	100.00	LUNCH EXPENSES
1551	787	1587	100.00	0.00	LUNCH EXPENSES
1552	788	1387	0.00	100.00	MARIMUTHU LUNCH
1553	788	1315	100.00	0.00	MARIMUTHU LUNCH
1554	789	1387	0.00	100.00	GOPI LUNCH
1555	789	1315	100.00	0.00	GOPI LUNCH
1556	790	1387	0.00	100.00	SANJAY HINDI BHAI LUNCH
1557	790	1315	100.00	0.00	SANJAY HINDI BHAI LUNCH
1558	791	1387	0.00	60.00	RAHUL
1559	791	1315	60.00	0.00	RAHUL
1560	792	1387	0.00	75.00	YELLOW PAINT
1561	792	1336	75.00	0.00	YELLOW PAINT
1562	793	1387	0.00	75.00	WHITE PAINT
1563	793	1336	75.00	0.00	WHITE PAINT
1564	794	1387	0.00	210.00	BOLT
1565	794	1336	210.00	0.00	BOLT
1566	795	1387	0.00	80.00	DRINKING WATER
1567	795	1586	80.00	0.00	DRINKING WATER
1568	796	1387	0.00	120.00	TEA
1569	796	1316	120.00	0.00	TEA
1570	797	1387	0.00	500.00	BEARING 4NO'S
1571	797	1337	500.00	0.00	BEARING 4NO'S
1572	798	1596	0.00	6123.00	
1573	798	1323	6123.00	0.00	
1574	799	1387	0.00	543.00	PURCHASE OF SPANNER
1575	799	1336	543.00	0.00	PURCHASE OF SPANNER
1576	800	1387	0.00	200.00	TEA
1577	800	1316	200.00	0.00	TEA
1578	801	1387	0.00	2500.00	AIRTEL MODEM
1579	801	1661	2500.00	0.00	AIRTEL MODEM
1580	820	1387	0.00	200.00	MESTHIRI WORKER 2 PERSON
1581	820	1315	200.00	0.00	MESTHIRI WORKER 2 PERSON
1582	821	1387	0.00	291.00	FOR PAINT
1583	739	1586	50.00	0.00	Can Water
1584	740	1387	0.00	1000.00	Ravi Labour
1585	740	1302	1000.00	0.00	Ravi Labour
1586	741	1387	0.00	1000.00	Panel Eletrician Labour
1587	741	1335	1000.00	0.00	Panel Eletrician Labour
1588	742	1387	0.00	1000.00	Crane Erection Labour
1589	742	1335	1000.00	0.00	Crane Erection Labour
1590	743	1387	0.00	1700.00	Selvam Auto Rent Shots
1591	743	1283	1700.00	0.00	Selvam Auto Rent Shots
1592	744	1387	0.00	1000.00	Table Glass Advance
1593	744	1336	1000.00	0.00	Table Glass Advance
1594	745	1387	0.00	500.00	Welding Rod Cutting Wheel
1595	745	1336	500.00	0.00	Welding Rod Cutting Wheel
1596	746	1387	0.00	1250.00	Angle 2 Auto Rent
1597	746	1283	1250.00	0.00	Angle 2 Auto Rent
1598	747	1387	0.00	400.00	Lunch Ravi Welding Crane Driver
1599	747	1315	400.00	0.00	Lunch Ravi Welding Crane Driver
1600	748	1387	0.00	650.00	Lorry Lock
1601	748	1336	650.00	0.00	Lorry Lock
1602	749	1387	0.00	600.00	Paint
1603	749	1336	600.00	0.00	Paint
1604	750	1387	0.00	700.00	Wheel
1605	750	1336	700.00	0.00	Wheel
1606	751	1387	0.00	70.00	Ag 4 Wheel
1607	751	1336	70.00	0.00	Ag 4 Wheel
1608	752	1387	0.00	100.00	Tea
1609	752	1316	100.00	0.00	Tea
1610	753	1387	0.00	100.00	Petrol
1611	753	1350	100.00	0.00	Petrol
1612	754	1387	0.00	50.00	Auto Extra
1613	754	1283	50.00	0.00	Auto Extra
1614	755	1387	0.00	2000.00	Crane Service Labour
1615	755	1335	2000.00	0.00	Crane Service Labour
1616	756	1387	0.00	6500.00	Crane Service Labour
1617	756	1335	6500.00	0.00	Crane Service Labour
1618	757	1387	0.00	2000.00	Labour
1619	757	1302	2000.00	0.00	Labour
1620	758	1387	0.00	500.00	Petrol
1621	758	1350	500.00	0.00	Petrol
1622	759	1387	0.00	2000.00	Petrol
1623	759	1350	2000.00	0.00	Petrol
1624	760	1387	0.00	1500.00	Vechile Water Wash
1625	760	1492	1500.00	0.00	Vechile Water Wash
1626	761	1387	0.00	100.00	Tea
1627	761	1316	100.00	0.00	Tea
1628	762	1387	0.00	10000.00	Panel Board Service
1629	762	1336	10000.00	0.00	Panel Board Service
1630	821	1283	291.00	0.00	FOR PAINT
1631	822	1387	0.00	205.00	BOROSIL CHIMNEY 350 CP
1632	822	1301	205.00	0.00	BOROSIL CHIMNEY 350 CP
1633	823	1387	0.00	871.00	GROCERY
1634	823	1335	871.00	0.00	GROCERY
1635	824	1387	0.00	4600.00	FOR MACHINERY (ROPE GRINDING)
1636	824	1301	4600.00	0.00	FOR MACHINERY (ROPE GRINDING)
1637	825	1387	0.00	1860.00	CHISEL CUTTER AG4 WHEEL
1638	825	1301	1860.00	0.00	CHISEL CUTTER AG4 WHEEL
1639	826	1387	0.00	285.00	TEA WATER CAN
1640	826	1335	285.00	0.00	TEA WATER CAN
1641	827	1387	0.00	2000.00	CHISEL HAMMER CHATTI
1642	827	1301	2000.00	0.00	CHISEL HAMMER CHATTI
1643	828	1387	0.00	900.00	CHISEL PURCHASED (CHANDRU)
1644	828	1301	900.00	0.00	CHISEL PURCHASED (CHANDRU)
1645	829	1387	0.00	390.00	TEA NIGHT TIFFEN
1646	829	1335	390.00	0.00	TEA NIGHT TIFFEN
1647	830	1387	0.00	1500.00	MAGNET PURCHASED BY GPAY
1648	830	1301	1500.00	0.00	MAGNET PURCHASED BY GPAY
1649	831	1387	0.00	1400.00	CYLINDER PURCHASED
1650	831	1335	1400.00	0.00	CYLINDER PURCHASED
1651	832	1387	0.00	800.00	COMPANY WEEKLY WAGES
1652	832	1662	800.00	0.00	COMPANY WEEKLY WAGES
1653	833	1387	0.00	2400.00	COMPANY WEEKLY WAGES
1654	833	1663	2400.00	0.00	COMPANY WEEKLY WAGES
1655	834	1387	0.00	5850.00	COMPANY WEEKLY WAGES
1656	834	1664	5850.00	0.00	COMPANY WEEKLY WAGES
1657	835	1387	0.00	200.00	TEA CAN WATER PETROL
1658	835	1335	200.00	0.00	TEA CAN WATER PETROL
1659	836	1387	0.00	300.00	BURNER
1660	836	1589	300.00	0.00	BURNER
1661	837	1387	0.00	100.00	TEA ,CAN WATER
1662	837	1335	100.00	0.00	TEA ,CAN WATER
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2024_2025; Owner: orbx
--

COPY fy_2024_2025.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
559	PUR_1_1	Purchase	2024-06-21	1358	16992.00	GPAY REF NO 417461101252		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
560	PUR_2_2	Purchase	2024-06-21	1282	23010.00	CASH PAID RS 11500 BALANCE HAVE T0 PAY RS.11500		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
561	PUR_3_3	Purchase	2024-06-21	1349	1800.00	GPAY		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
562	PAY_1_4	Payment	2024-06-21	1387	16992.00	GPAY		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
563	PAY_2_5	Payment	2024-06-21	1387	11500.00	BALANCE AMOUNT 11500		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
564	PAY_3_6	Payment	2024-06-21	1387	1800.00	GPAY		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
565	PAY_4_7	Payment	2024-06-25	1387	6000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
566	PAY_5_8	Payment	2024-06-21	1387	1500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
567	PAY_6_9	Payment	2024-06-21	1387	3200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
568	PAY_7_10	Payment	2024-06-25	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
569	PAY_8_11	Payment	2024-06-25	1387	3000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
570	PAY_9_12	Payment	2024-06-21	1387	3200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
571	PAY_10_15	Payment	2024-06-22	1425	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
572	PAY_11_16	Payment	2024-06-23	1387	3000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
573	PAY_12_17	Payment	2024-06-23	1425	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
574	PAY_13_18	Payment	2024-06-23	1387	505.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
575	PAY_14_19	Payment	2024-06-24	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
576	PAY_15_20	Payment	2024-06-24	1387	130.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
577	PAY_16_21	Payment	2024-06-24	1387	450.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
578	PAY_17_22	Payment	2024-06-24	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
579	PAY_18_23	Payment	2024-06-24	1387	1530.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
611	PAY_34_49	Payment	2024-06-25	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
612	PAY_35_50	Payment	2024-06-26	1387	1180.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
613	PAY_36_51	Payment	2024-06-26	1387	250.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
614	PAY_37_52	Payment	2024-06-26	1387	250.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
615	PAY_38_53	Payment	2024-06-26	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
616	PAY_39_56	Payment	2024-06-26	1387	140.00	4 CAN		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
617	PAY_40_57	Payment	2024-06-26	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
618	PAY_41_58	Payment	2024-06-26	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
619	PAY_42_59	Payment	2024-06-26	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
620	PAY_43_61	Payment	2024-06-26	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
621	PAY_44_65	Payment	2024-06-27	1387	2500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
622	PAY_45_66	Payment	2024-06-27	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
623	PAY_46_71	Payment	2024-06-28	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
580	PAY_19_24	Payment	2024-06-24	1387	800.00	2 Nos For Grinding Bed		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
581	PAY_20_25	Payment	2024-06-24	1387	770.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
582	PAY_21_26	Payment	2024-06-24	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
583	PAY_22_27	Payment	2024-06-24	1387	40.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
584	PAY_23_28	Payment	2024-06-24	1387	600.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
585	PAY_24_32	Payment	2024-06-25	1387	5500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
586	PAY_25_33	Payment	2024-06-25	1387	5000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
588	PAY_26_35	Payment	2024-06-24	1387	10384.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
587	PUR_4_34	Purchase	2024-06-25	1299	10384.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
589	PUR_5_36	Purchase	2024-06-25	1299	2242.00	9 INCH WHEEL		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
590	PAY_27_37	Payment	2024-06-25	1387	2242.00	9 INCH WHEEL		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
591	PAY_28_38	Payment	2024-06-25	1387	500.00	MS BUSH FOR GRINDING BED		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
606	PAY_29_39	Payment	2024-06-25	1387	500.00	FOR SARVAN		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
607	PAY_30_44	Payment	2024-06-25	1387	3500.00	BALANCE 500		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
608	PAY_31_45	Payment	2024-06-25	1387	210.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
609	PAY_32_46	Payment	2024-06-25	1387	750.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
610	PAY_33_48	Payment	2024-06-25	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
626	PAY_63_104	Payment	2024-07-08	1387	1300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
627	PAY_64_105	Payment	2024-07-08	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
628	PAY_65_106	Payment	2024-07-08	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
629	PAY_66_107	Payment	2024-07-08	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
630	PAY_67_109	Payment	2024-07-08	1387	753.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
631	PUR_6_110	Purchase	2024-07-08	1299	380.00	GPAY TO NAGARAJ UPI-419006399785		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
632	PAY_68_111	Payment	2024-07-08	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
633	PAY_69_112	Payment	2024-07-08	1387	380.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
634	PAY_70_114	Payment	2024-07-10	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
635	PAY_71_115	Payment	2024-07-10	1387	120.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
636	PAY_72_116	Payment	2024-07-10	1387	800.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
637	PAY_73_117	Payment	2024-07-10	1387	30.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
638	PAY_74_118	Payment	2024-07-10	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
639	PAY_75_119	Payment	2024-07-11	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
640	PAY_76_120	Payment	2024-07-11	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
641	PAY_77_121	Payment	2024-07-11	1387	1100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
642	PAY_78_122	Payment	2024-07-11	1387	10000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
643	PAY_79_125	Payment	2024-07-12	1387	650.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
644	PAY_80_126	Payment	2024-07-12	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
645	PAY_81_127	Payment	2024-07-12	1387	7434.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
646	PAY_82_129	Payment	2024-07-12	1387	5001.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
647	PAY_83_130	Payment	2024-07-12	1387	5000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
648	PAY_84_131	Payment	2024-07-12	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
649	PUR_7_133	Purchase	2024-07-12	1299	7434.00	BILL NO 160		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
650	REC_1_139	Receipt	2024-07-20	1387	28594.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
651	REC_2_140	Receipt	2024-07-20	1387	32926.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
624	PAY_47_72	Payment	2024-06-28	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
625	PAY_48_73	Payment	2024-06-29	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
592	PAY_49_74	Payment	2024-06-29	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
593	PAY_50_81	Payment	2024-07-02	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
594	PAY_51_82	Payment	2024-07-02	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
595	PAY_52_85	Payment	2024-07-04	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
596	PAY_53_86	Payment	2024-07-04	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
597	PAY_54_87	Payment	2024-07-04	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
598	PAY_55_88	Payment	2024-07-04	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
599	PAY_56_89	Payment	2024-07-04	1387	3750.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
600	PAY_57_90	Payment	2024-07-04	1425	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
601	PAY_58_97	Payment	2024-07-06	1425	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
602	PAY_59_98	Payment	2024-07-06	1425	280.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
603	PAY_60_101	Payment	2024-07-08	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
604	PAY_61_102	Payment	2024-07-08	1387	800.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
605	PAY_62_103	Payment	2024-07-08	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
802	PAY_220_379	Payment	2025-03-26	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
803	PAY_221_380	Payment	2025-03-26	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
804	PAY_222_381	Payment	2025-03-26	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
805	PAY_223_382	Payment	2025-03-26	1387	5000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
806	PAY_224_385	Payment	2025-03-26	1387	510.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
807	PAY_225_386	Payment	2025-03-27	1387	650.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
808	PAY_226_387	Payment	2025-03-27	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
809	PAY_227_388	Payment	2025-03-27	1387	90.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
810	PAY_228_389	Payment	2025-03-27	1387	90.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
811	PAY_229_390	Payment	2025-03-27	1387	60.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
812	PAY_230_391	Payment	2025-03-27	1387	20.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
813	PAY_231_392	Payment	2025-03-27	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
814	PUR_15_393	Purchase	2025-03-28	1379	24898.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
815	PAY_232_398	Payment	2025-03-28	1387	115.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
816	PAY_233_399	Payment	2025-03-28	1387	60.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
817	PAY_234_400	Payment	2025-03-28	1387	90.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
818	PAY_235_401	Payment	2025-03-28	1387	90.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
819	PAY_236_402	Payment	2025-03-28	1387	90.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
653	PAY_86_148	Payment	2024-07-25	1387	1500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
652	PAY_85_147	Payment	2024-07-18	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
654	PAY_87_149	Payment	2024-07-18	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
655	PAY_88_150	Payment	2024-07-18	1387	275.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
656	PAY_89_151	Payment	2024-07-18	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
657	PAY_90_152	Payment	2024-07-18	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
658	PAY_91_153	Payment	2024-07-18	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
659	PAY_92_154	Payment	2024-07-19	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
660	PAY_93_155	Payment	2024-07-25	1387	1908.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
661	REC_3_165	Receipt	2024-08-19	1387	30560.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
662	REC_4_187	Receipt	2024-09-14	1387	30000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
663	REC_5_188	Receipt	2024-09-18	1387	35000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
664	REC_6_193	Receipt	2024-10-01	1387	17151.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
665	REC_7_200	Receipt	2024-09-26	1387	40000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
666	PAY_94_210	Payment	2024-11-05	1387	1250.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
667	PAY_95_211	Payment	2024-11-05	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
668	REC_8_220	Receipt	2024-11-19	1387	42847.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
669	REC_9_230	Receipt	2024-12-21	1387	75000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
670	PUR_8_232	Purchase	2025-03-13	1379	24898.00	PURCHASE OF 200 LITRES OF GP PAINT		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
671	PUR_9_233	Purchase	2025-03-18	1321	20296.00	PURCHASE OF TURBON OIL 200 LITERS		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
672	PUR_10_234	Purchase	2025-03-10	1486	12730.00	PURCHASED MS ANGLE FOR CRANE BEAM		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
673	PUR_11_235	Purchase	2025-03-19	1486	23300.00	PURCHASE OF SHEET FOR EICHER (5 SHEETS)		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
674	PUR_12_236	Purchase	2025-03-11	1282	32500.00	PURCHASE OF SHOTS 500 KGS		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
675	PAY_96_237	Payment	2025-03-06	1387	2400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
676	PAY_97_238	Payment	2025-03-06	1387	2200.00	PURCHASE OF HAMMER		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
677	PAY_98_239	Payment	2025-03-06	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
678	PAY_99_240	Payment	2025-03-07	1387	100000.00	ADVANCE PATYMENT FOR CRANE		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
679	PAY_100_242	Payment	2025-03-08	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
680	PAY_101_243	Payment	2025-03-08	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
681	PAY_102_244	Payment	2025-03-08	1387	225.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
682	PAY_103_245	Payment	2025-03-08	1387	3500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
683	PAY_104_246	Payment	2025-03-08	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
684	PAY_105_247	Payment	2025-03-08	1387	5500.00	LABOUR 4000, BHAI 1500		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
685	PAY_106_248	Payment	2025-03-08	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
686	PAY_107_249	Payment	2025-03-08	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
687	PAY_108_250	Payment	2025-03-08	1387	1500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
688	PAY_109_253	Payment	2025-03-08	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
689	PAY_110_254	Payment	2025-03-08	1387	24898.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
690	PAY_111_255	Payment	2025-03-10	1387	12730.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
691	PAY_112_256	Payment	2025-03-10	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
692	PAY_113_257	Payment	2025-03-10	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
693	PAY_114_258	Payment	2025-03-10	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
694	PAY_115_259	Payment	2025-03-10	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
695	PAY_116_260	Payment	2025-03-10	1387	60000.00	RENT PAID		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
696	PAY_117_261	Payment	2025-03-10	1387	4000.00	EB FEB 2025		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
697	PAY_118_262	Payment	2025-03-11	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
698	PAY_119_263	Payment	2025-03-11	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
699	PAY_120_264	Payment	2025-03-11	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
700	PAY_121_265	Payment	2025-03-11	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
701	PAY_122_266	Payment	2025-03-11	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
702	PAY_123_267	Payment	2025-03-11	1387	800.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
703	PAY_124_268	Payment	2025-03-11	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
704	PAY_125_269	Payment	2025-03-11	1387	750.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
705	PAY_126_270	Payment	2025-03-11	1387	3000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
706	PAY_127_271	Payment	2025-03-11	1387	150.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
707	PAY_128_272	Payment	2025-03-12	1387	10000.00	OFFICE FALSEING G PAY		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
708	PAY_129_273	Payment	2025-03-12	1387	4000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
709	PAY_130_274	Payment	2025-03-12	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
710	PAY_131_275	Payment	2025-03-12	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
711	PAY_132_276	Payment	2025-03-12	1387	250.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
712	PAY_133_277	Payment	2025-03-12	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
713	PAY_134_278	Payment	2025-03-12	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
714	PAY_135_280	Payment	2025-03-12	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
715	PAY_136_281	Payment	2025-03-13	1387	100.00	.		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
716	PAY_137_282	Payment	2025-03-13	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
717	PAY_138_285	Payment	2025-03-17	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
718	PAY_139_286	Payment	2025-03-17	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
719	PAY_140_287	Payment	2025-03-17	1387	2100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
720	PAY_141_288	Payment	2025-03-17	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
721	PAY_142_289	Payment	2025-03-18	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
722	PAY_143_290	Payment	2025-03-18	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
723	PAY_144_291	Payment	2025-03-18	1387	20300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
724	PAY_145_292	Payment	2025-03-18	1387	350.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
725	PAY_146_293	Payment	2025-03-18	1387	280.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
726	PAY_147_294	Payment	2025-03-18	1387	1200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
727	PAY_148_295	Payment	2025-03-18	1387	3200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
728	PAY_149_296	Payment	2025-03-18	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
729	PAY_150_297	Payment	2025-03-18	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
730	PAY_151_298	Payment	2025-03-18	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
731	PAY_152_299	Payment	2025-03-19	1387	23300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
732	PAY_153_300	Payment	2025-03-19	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
733	PAY_154_301	Payment	2025-03-19	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
734	PAY_155_302	Payment	2025-03-19	1387	10000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
735	PAY_156_303	Payment	2025-03-19	1387	650.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
736	PAY_157_304	Payment	2025-03-19	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
737	PAY_158_305	Payment	2025-03-19	1387	230.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
738	PAY_159_306	Payment	2025-03-19	1387	120.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
763	PAY_184_332	Payment	2025-03-22	1387	9600.00	Paid To Vardharaj		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
764	PAY_185_333	Payment	2025-03-22	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
765	PAY_186_334	Payment	2025-03-22	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
766	PAY_187_335	Payment	2025-03-22	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
767	PAY_188_337	Payment	2025-03-22	1387	11000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
768	PAY_189_338	Payment	2025-03-22	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
769	PUR_13_342	Purchase	2025-03-24	1595	7316.00	GST AMOUNT 1116		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
770	PUR_14_343	Purchase	2025-03-24	1321	20296.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
771	PAY_190_344	Payment	2025-03-24	1387	2263.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
772	PAY_191_345	Payment	2025-03-24	1387	250.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
773	PAY_192_346	Payment	2025-03-24	1387	30.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
774	PAY_193_347	Payment	2025-03-24	1387	1100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
775	PAY_194_348	Payment	2025-03-24	1387	3000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
776	PAY_195_349	Payment	2025-03-24	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
777	PAY_196_350	Payment	2025-03-24	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
778	PAY_197_351	Payment	2025-03-24	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
779	PAY_198_352	Payment	2025-03-24	1387	80.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
780	PAY_199_353	Payment	2025-03-24	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
781	PAY_200_354	Payment	2025-03-24	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
782	PAY_201_355	Payment	2025-03-25	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
783	PAY_202_356	Payment	2025-03-25	1387	10000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
784	PAY_203_357	Payment	2025-03-25	1387	396.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
785	PAY_204_358	Payment	2025-03-25	1387	350.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
786	PAY_205_359	Payment	2025-03-25	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
787	PAY_206_360	Payment	2025-03-25	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
788	PAY_207_361	Payment	2025-03-25	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
789	PAY_208_362	Payment	2025-03-25	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
790	PAY_209_363	Payment	2025-03-25	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
791	PAY_210_364	Payment	2025-03-25	1387	60.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
792	PAY_211_365	Payment	2025-03-25	1387	75.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
793	PAY_212_366	Payment	2025-03-25	1387	75.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
794	PAY_213_367	Payment	2025-03-25	1387	210.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
795	PAY_214_368	Payment	2025-03-25	1387	80.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
796	PAY_215_369	Payment	2025-03-25	1387	120.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
797	PAY_216_370	Payment	2025-03-25	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
798	PUR_14_372	Purchase	2025-03-24	1596	6123.00	PURCHASE OF ALLEN KEY,SPANNER,SOCKET		\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
799	PAY_217_375	Payment	2025-03-24	1387	543.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
800	PAY_218_377	Payment	2025-03-26	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
801	PAY_219_378	Payment	2025-03-26	1387	2500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
820	PAY_237_403	Payment	2025-03-28	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
739	PAY_160_307	Payment	2025-03-19	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
740	PAY_161_308	Payment	2025-03-19	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
741	PAY_162_309	Payment	2025-03-19	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
742	PAY_163_310	Payment	2025-03-19	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
743	PAY_164_311	Payment	2025-03-20	1387	1700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
744	PAY_165_312	Payment	2025-03-20	1387	1000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
745	PAY_166_313	Payment	2025-03-20	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
746	PAY_167_314	Payment	2025-03-20	1387	1250.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
747	PAY_168_315	Payment	2025-03-20	1387	400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
748	PAY_169_316	Payment	2025-03-20	1387	650.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
749	PAY_170_317	Payment	2025-03-20	1387	600.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
750	PAY_171_318	Payment	2025-03-20	1387	700.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
751	PAY_172_319	Payment	2025-03-20	1387	70.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
752	PAY_173_320	Payment	2025-03-20	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
753	PAY_174_321	Payment	2025-03-20	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
754	PAY_175_322	Payment	2025-03-20	1387	50.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
755	PAY_176_323	Payment	2025-03-20	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
756	PAY_177_324	Payment	2025-03-21	1387	6500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
757	PAY_178_325	Payment	2025-03-21	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
758	PAY_179_326	Payment	2025-03-21	1387	500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
759	PAY_180_327	Payment	2025-03-21	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
760	PAY_181_328	Payment	2025-03-21	1387	1500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
761	PAY_182_329	Payment	2025-03-21	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
762	PAY_183_330	Payment	2025-03-21	1387	10000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
821	PAY_238_404	Payment	2025-03-28	1387	291.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
822	PAY_239_405	Payment	2025-03-28	1387	205.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
823	PAY_240_406	Payment	2025-03-28	1387	871.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
824	PAY_241_407	Payment	2025-03-28	1387	4600.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
825	PAY_242_408	Payment	2025-03-28	1387	1860.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
826	PAY_243_409	Payment	2025-03-28	1387	285.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
827	PAY_244_410	Payment	2025-03-28	1387	2000.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
828	PAY_245_411	Payment	2025-03-28	1387	900.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
829	PAY_246_413	Payment	2025-03-28	1387	390.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
830	PAY_247_414	Payment	2025-03-28	1387	1500.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
831	PAY_248_415	Payment	2025-03-28	1387	1400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
832	PAY_249_425	Payment	2025-03-29	1387	800.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
833	PAY_250_426	Payment	2025-03-29	1387	2400.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
834	PAY_251_428	Payment	2025-03-29	1387	5850.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
835	PAY_252_436	Payment	2025-03-29	1387	200.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
836	PAY_253_437	Payment	2025-03-29	1387	300.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
837	PAY_254_440	Payment	2025-03-29	1387	100.00			\N	2026-08-03 14:42:10.902049	2026-08-03 14:42:10.902049
\.


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
993	ADV_7_36	2025-04-05	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
994	ADV_18_57	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
995	ADV_22_62	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
996	ADV_23_64	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
997	ADV_28_70	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
998	ADV_29_71	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
999	ADV_30_72	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1000	ADV_31_73	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1001	ADV_104_358	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1002	ADV_1_359	2025-04-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1003	ADV_2_360	2025-05-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1004	ADV_3_361	2025-04-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1005	ADV_4_362	2025-04-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1006	ADV_5_363	2025-04-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1007	ADV_6_364	2025-04-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1008	ADV_7_384	2025-04-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1009	ADV_21_385	2025-04-05	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1010	ADV_8_386	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1011	ADV_9_387	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1012	ADV_22_388	2025-04-07	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1013	ADV_10_389	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1014	ADV_11_390	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1015	ADV_12_391	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1016	ADV_13_392	2025-04-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1017	ADV_14_393	2025-04-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1018	ADV_36_107	2025-04-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1019	ADV_37_109	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1020	ADV_38_110	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1021	ADV_39_111	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1022	ADV_40_113	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1023	ADV_41_114	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1024	ADV_42_125	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1025	ADV_43_126	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1026	ADV_44_127	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1027	ADV_45_128	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1028	ADV_46_131	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1029	ADV_47_137	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1030	ADV_48_138	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1031	ADV_49_139	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1032	ADV_50_140	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1033	ADV_51_144	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1034	ADV_12_151	2025-04-15	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1035	ADV_13_152	2025-04-15	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1036	ADV_14_153	2025-04-15	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1037	ADV_52_154	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1038	ADV_53_155	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1039	ADV_54_156	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1040	ADV_55_157	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1041	ADV_56_158	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1042	ADV_57_159	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1043	ADV_58_160	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1044	ADV_59_161	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1045	ADV_60_162	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1046	ADV_15_171	2025-04-14	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1047	ADV_61_172	2025-04-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1048	ADV_62_173	2025-04-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1049	ADV_63_174	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1050	ADV_64_175	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1051	ADV_65_176	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1052	ADV_66_177	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1053	ADV_67_178	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1054	ADV_16_179	2025-04-15	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1055	ADV_68_180	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1056	ADV_69_185	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1057	ADV_70_186	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1058	ADV_71_187	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1059	ADV_72_188	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1060	ADV_73_196	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1061	ADV_74_197	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1062	ADV_75_198	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1063	ADV_76_199	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1064	ADV_77_200	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1065	ADV_78_201	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1066	ADV_79_202	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1067	ADV_80_203	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1068	ADV_81_204	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1069	ADV_82_205	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1070	ADV_83_206	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1071	ADV_84_208	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1072	ADV_85_209	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1073	ADV_86_210	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1074	ADV_87_211	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1075	ADV_88_212	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1076	ADV_89_213	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1077	ADV_90_214	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1078	ADV_91_215	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1079	ADV_92_216	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1080	ADV_17_217	2025-04-18	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1081	ADV_18_218	2025-04-18	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1082	ADV_93_232	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1083	ADV_19_235	2025-04-18	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1084	ADV_20_236	2025-04-18	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1085	ADV_94_237	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1086	ADV_95_239	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1087	ADV_96_240	2025-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1088	ADV_97_268	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1089	ADV_98_269	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1090	ADV_99_272	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1091	ADV_100_273	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1092	ADV_101_274	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1093	ADV_102_275	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1094	ADV_103_276	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1095	ADV_15_394	2025-04-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1096	ADV_16_395	2025-04-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1097	ADV_17_396	2025-04-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1098	ADV_23_397	2025-04-08	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1099	ADV_18_398	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1100	ADV_19_399	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1101	ADV_20_400	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1102	ADV_21_401	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1103	ADV_22_402	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1104	ADV_23_403	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1105	ADV_24_404	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1106	ADV_25_405	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1107	ADV_26_406	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1108	ADV_27_407	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1109	ADV_24_408	2025-04-10	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1110	ADV_28_409	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1111	ADV_29_410	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1112	ADV_30_411	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1113	ADV_31_412	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1114	ADV_32_413	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1115	ADV_33_414	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1116	ADV_34_415	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1117	ADV_35_416	2025-04-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1118	ADV_36_417	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1119	ADV_37_418	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1120	ADV_38_419	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1121	ADV_39_420	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1122	ADV_40_421	2025-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1123	ADV_25_422	2025-04-11	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1124	ADV_41_423	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1125	ADV_42_424	2025-04-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1126	ADV_43_439	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1127	ADV_26_440	2025-04-12	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1128	ADV_44_441	2025-04-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1129	ADV_45_442	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1130	ADV_46_443	2025-04-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1131	ADV_47_444	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1132	ADV_48_445	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1133	ADV_49_446	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1134	ADV_50_447	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1135	ADV_51_448	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1136	ADV_52_449	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1137	ADV_53_450	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1138	ADV_27_451	2025-04-15	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1139	ADV_54_452	2025-04-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1140	ADV_55_453	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1141	ADV_56_454	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1142	ADV_57_455	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1143	ADV_58_456	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1144	ADV_59_457	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1145	ADV_60_458	2025-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1146	ADV_61_459	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1147	ADV_62_460	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1148	ADV_63_461	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1149	ADV_64_462	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1150	ADV_65_463	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1151	ADV_66_466	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1152	ADV_67_467	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1153	ADV_68_468	2025-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1154	ADV_69_469	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1155	ADV_70_470	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1156	ADV_71_471	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1157	ADV_72_472	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1158	ADV_73_473	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1159	ADV_74_474	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1160	ADV_75_475	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1161	ADV_76_476	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1162	ADV_77_477	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1163	ADV_78_478	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1164	ADV_79_479	2025-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1165	ADV_80_480	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1166	ADV_81_481	2025-04-18	1742	Payment	Contractor	0.80		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1167	ADV_82_482	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1168	ADV_83_483	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1169	ADV_28_484	2025-04-18	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1170	ADV_84_486	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1171	ADV_85_487	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1172	ADV_86_488	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1173	ADV_87_489	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1174	ADV_88_490	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1175	ADV_89_491	2025-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1176	ADV_90_492	2025-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1177	ADV_91_498	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1178	ADV_92_501	2025-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1179	ADV_29_503	2025-04-19	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1180	ADV_93_506	2025-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1181	ADV_94_513	2025-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1182	ADV_30_514	2025-04-21	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1183	ADV_95_515	2025-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1184	ADV_96_516	2025-04-21	1742	Payment	Contractor	0.00	PIUIUYYT	\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1185	ADV_97_517	2025-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1186	ADV_98_518	2025-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1187	ADV_99_519	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1188	ADV_100_520	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1189	ADV_101_521	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1190	ADV_102_522	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1191	ADV_103_523	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1192	ADV_104_524	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1193	ADV_105_525	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1194	ADV_106_526	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1195	ADV_107_527	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1196	ADV_108_528	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1197	ADV_109_529	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1198	ADV_110_530	2025-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1199	ADV_111_531	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1200	ADV_112_532	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1201	ADV_113_533	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1202	ADV_114_534	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1203	ADV_115_535	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1204	ADV_117_537	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1205	ADV_118_538	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1206	ADV_119_539	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1207	ADV_120_540	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1208	ADV_121_541	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1209	ADV_122_542	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1210	ADV_123_543	2025-04-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1211	ADV_124_544	2025-04-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1212	ADV_125_545	2025-04-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1213	ADV_126_546	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1214	ADV_127_547	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1215	ADV_128_548	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1216	ADV_129_549	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1217	ADV_31_550	2025-04-25	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1218	ADV_130_551	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1219	ADV_131_552	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1220	ADV_132_553	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1221	ADV_133_554	2025-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1222	ADV_134_555	2025-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1223	ADV_135_559	2025-04-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1224	ADV_136_560	2025-04-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1225	ADV_137_562	2025-04-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1226	ADV_32_575	2025-04-26	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1227	ADV_138_576	2025-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1228	ADV_138_583	2025-04-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1229	ADV_139_584	2025-04-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1230	ADV_140_585	2025-04-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1231	ADV_141_586	2025-04-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1232	ADV_142_587	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1233	ADV_143_588	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1234	ADV_144_590	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1235	ADV_145_591	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1236	ADV_146_592	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1237	ADV_147_593	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1238	ADV_148_594	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1239	ADV_149_595	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1240	ADV_33_596	2025-04-28	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1241	ADV_150_604	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1242	ADV_34_605	2025-04-28	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1243	ADV_151_606	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1244	ADV_152_607	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1245	ADV_153_608	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1246	ADV_154_609	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1247	ADV_155_610	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1248	ADV_156_611	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1249	ADV_157_612	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1250	ADV_158_613	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1251	ADV_159_614	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1252	ADV_35_615	2025-04-29	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1253	ADV_160_616	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1254	ADV_161_617	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1255	ADV_162_618	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1256	ADV_163_619	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1257	ADV_164_620	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1258	ADV_165_621	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1259	ADV_166_622	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1260	ADV_167_623	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1261	ADV_168_624	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1262	ADV_169_625	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1263	ADV_170_626	2025-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1264	ADV_171_627	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1265	ADV_172_628	2025-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1266	ADV_36_629	2025-04-29	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1267	ADV_173_630	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1268	ADV_37_631	2025-04-30	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1269	ADV_174_632	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1270	ADV_175_633	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1271	ADV_176_634	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1272	ADV_177_635	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1273	ADV_178_636	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1274	ADV_179_637	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1275	ADV_180_638	2025-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1276	ADV_181_639	2025-05-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1277	ADV_182_640	2025-05-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1278	ADV_183_641	2025-05-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1279	ADV_184_642	2025-05-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1280	ADV_185_643	2025-05-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1281	ADV_186_644	2025-05-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1282	ADV_38_645	2025-05-01	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1283	ADV_187_646	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1284	ADV_188_647	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1285	ADV_189_648	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1286	ADV_190_649	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1287	ADV_191_650	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1288	ADV_192_651	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1289	ADV_193_652	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1290	ADV_194_653	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1291	ADV_195_654	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1292	ADV_196_655	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1293	ADV_197_656	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1294	ADV_39_657	2025-05-02	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1295	ADV_40_658	2025-05-02	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1296	ADV_41_659	2025-05-03	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1297	ADV_198_660	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1298	ADV_199_661	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1299	ADV_200_662	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1300	ADV_201_663	2025-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1301	ADV_202_665	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1302	ADV_203_666	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1303	ADV_204_667	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1304	ADV_205_668	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1305	ADV_206_669	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1306	ADV_207_670	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1307	ADV_208_671	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1308	ADV_209_672	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1309	ADV_210_673	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1310	ADV_42_674	2025-05-03	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1311	ADV_43_675	2025-05-03	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1312	ADV_211_676	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1313	ADV_212_677	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1314	ADV_213_678	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1315	ADV_44_692	2025-05-03	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1316	ADV_214_694	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1317	ADV_215_695	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1318	ADV_216_696	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1319	ADV_217_697	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1320	ADV_218_698	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1321	ADV_219_699	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1322	ADV_220_700	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1323	ADV_221_701	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1324	ADV_222_702	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1325	ADV_223_703	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1326	ADV_224_704	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1327	ADV_225_705	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1328	ADV_226_706	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1329	ADV_227_707	2025-05-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1330	ADV_228_708	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1331	ADV_45_709	2025-05-05	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1332	ADV_229_710	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1333	ADV_230_711	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1334	ADV_231_712	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1335	ADV_232_713	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1336	ADV_233_714	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1337	ADV_234_715	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1338	ADV_235_716	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1339	ADV_236_717	2025-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1340	ADV_237_718	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1341	ADV_238_719	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1342	ADV_239_720	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1343	ADV_240_721	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1344	ADV_241_722	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1345	ADV_242_723	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1346	ADV_243_724	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1347	ADV_244_725	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1348	ADV_245_726	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1349	ADV_246_727	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1350	ADV_247_728	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1351	ADV_248_729	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1352	ADV_249_730	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1353	ADV_250_731	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1354	ADV_251_732	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1355	ADV_252_733	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1356	ADV_253_734	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1357	ADV_254_735	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1358	ADV_255_736	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1359	ADV_256_737	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1360	ADV_257_738	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1361	ADV_258_739	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1362	ADV_259_740	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1363	ADV_260_741	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1364	ADV_261_742	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1365	ADV_262_743	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1366	ADV_263_744	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1367	ADV_264_745	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1368	ADV_265_746	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1369	ADV_266_747	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1370	ADV_267_772	2025-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1371	ADV_268_773	2025-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1372	ADV_269_780	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1373	ADV_270_781	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1374	ADV_271_782	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1375	ADV_272_783	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1376	ADV_273_784	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1377	ADV_274_785	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1378	ADV_275_786	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1379	ADV_276_787	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1380	ADV_277_788	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1381	ADV_278_789	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1382	ADV_279_790	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1383	ADV_280_791	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1384	ADV_281_792	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1385	ADV_282_793	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1386	ADV_283_794	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1387	ADV_284_795	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1388	ADV_285_796	2025-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1389	ADV_286_803	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1390	ADV_287_804	2025-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1391	ADV_288_805	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1392	ADV_289_806	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1393	ADV_290_807	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1394	ADV_46_808	2025-05-09	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1395	ADV_291_809	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1396	ADV_292_810	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1397	ADV_293_811	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1398	ADV_294_812	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1399	ADV_295_813	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1400	ADV_296_814	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1401	ADV_297_815	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1402	ADV_298_825	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1403	ADV_299_826	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1404	ADV_300_827	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1405	ADV_301_828	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1406	ADV_302_829	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1407	ADV_303_830	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1408	ADV_304_831	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1409	ADV_305_832	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1410	ADV_306_833	2025-05-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1411	ADV_1_843	2025-05-10	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1412	ADV_307_866	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1413	ADV_308_867	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1414	ADV_309_868	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1415	ADV_310_869	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1416	ADV_311_870	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1417	ADV_312_871	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1418	ADV_313_872	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1419	ADV_314_873	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1420	ADV_315_874	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1421	ADV_316_875	2025-05-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1422	ADV_47_876	2025-05-10	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1423	ADV_48_877	2025-05-10	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1424	ADV_49_878	2025-05-12	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1425	ADV_317_882	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1426	ADV_318_884	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1427	ADV_319_885	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1428	ADV_320_886	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1429	ADV_321_887	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1430	ADV_322_889	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1431	ADV_323_890	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1432	ADV_324_891	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1433	ADV_325_894	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1434	ADV_326_895	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1435	ADV_327_896	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1436	ADV_328_897	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1437	ADV_329_898	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1438	ADV_330_899	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1439	ADV_331_900	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1440	ADV_332_903	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1441	ADV_333_904	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1442	ADV_334_905	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1443	ADV_335_906	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1444	ADV_336_907	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1445	ADV_337_908	2025-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1446	ADV_338_912	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1447	ADV_339_913	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1448	ADV_340_914	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1449	ADV_341_915	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1450	ADV_342_916	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1451	ADV_343_917	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1452	ADV_344_918	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1453	ADV_345_919	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1454	ADV_346_920	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1455	ADV_347_921	2025-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1456	ADV_348_927	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1457	ADV_349_928	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1458	ADV_350_929	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1459	ADV_351_930	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1460	ADV_352_931	2025-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1461	ADV_50_937	2025-05-15	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1462	ADV_353_940	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1463	ADV_354_948	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1464	ADV_355_949	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1465	ADV_356_950	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1466	ADV_357_951	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1467	ADV_358_952	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1468	ADV_359_953	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1469	ADV_360_954	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1470	ADV_361_955	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1471	ADV_362_956	2025-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1472	ADV_363_960	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1473	ADV_364_961	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1474	ADV_365_963	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1475	ADV_366_964	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1476	ADV_367_965	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1477	ADV_368_966	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1478	ADV_369_967	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1479	ADV_370_968	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1480	ADV_51_969	2025-05-16	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1481	ADV_371_970	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1482	ADV_372_971	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1483	ADV_373_972	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1484	ADV_374_974	2025-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1485	ADV_2_976	2025-05-17	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1486	ADV_52_979	2025-05-17	1875	Payment	Staff	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1487	ADV_375_980	2025-05-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
1488	ADV_376_981	2025-05-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:18.91291	2026-08-03 14:42:18.91291
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
1481	LB_1_863_41_0	2025-04-07	1263	\N	2930	7	4777.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1482	LB_3_115_247_0	2025-04-21	1355	\N	2182	7	212.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1483	LB_3_115_247_1	2025-04-21	1355	\N	2182	8	212.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1484	LB_3_115_247_2	2025-04-21	1355	\N	2182	9	212.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1485	LB_3_138_247_3	2025-04-21	1355	\N	2205	7	844.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1486	LB_3_138_247_4	2025-04-21	1355	\N	2205	8	844.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1487	LB_3_138_247_5	2025-04-21	1355	\N	2205	9	844.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1488	LB_3_307_247_6	2025-04-21	1355	\N	2374	7	651.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1489	LB_3_307_247_7	2025-04-21	1355	\N	2374	8	651.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1490	LB_3_307_247_8	2025-04-21	1355	\N	2374	9	651.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1491	LB_3_417_247_9	2025-04-21	1355	\N	2484	7	32.364	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1492	LB_3_417_247_10	2025-04-21	1355	\N	2484	8	32.364	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1493	LB_3_417_247_11	2025-04-21	1355	\N	2484	9	32.364	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1494	LB_3_583_247_12	2025-04-21	1355	\N	2715	7	502.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1495	LB_3_583_247_13	2025-04-21	1355	\N	2715	8	502.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1496	LB_3_583_247_14	2025-04-21	1355	\N	2715	9	502.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1497	LB_3_42_247_15	2025-04-21	1355	\N	2110	7	471.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1498	LB_3_42_247_16	2025-04-21	1355	\N	2110	8	471.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1499	LB_3_42_247_17	2025-04-21	1355	\N	2110	9	471.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1500	LB_3_164_247_18	2025-04-21	1355	\N	2231	7	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1501	LB_3_164_247_19	2025-04-21	1355	\N	2231	8	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1502	LB_3_164_247_20	2025-04-21	1355	\N	2231	9	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1503	LB_3_384_247_21	2025-04-21	1355	\N	2451	7	355.160	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1504	LB_3_384_247_22	2025-04-21	1355	\N	2451	8	355.160	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1505	LB_3_384_247_23	2025-04-21	1355	\N	2451	9	355.160	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1506	LB_3_143_247_24	2025-04-21	1355	\N	2210	7	257.982	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1507	LB_3_143_247_25	2025-04-21	1355	\N	2210	8	257.982	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1508	LB_3_143_247_26	2025-04-21	1355	\N	2210	9	257.982	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1509	LB_3_42_248_0	2025-04-21	1355	\N	2110	8	117.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1510	LB_3_42_248_1	2025-04-21	1355	\N	2110	9	117.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1511	LB_3_307_248_2	2025-04-21	1355	\N	2374	7	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1512	LB_3_307_248_3	2025-04-21	1355	\N	2374	8	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1513	LB_3_307_248_4	2025-04-21	1355	\N	2374	9	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1514	LB_3_42_248_5	2025-04-21	1355	\N	2110	7	117.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1515	LB_3_90_249_0	2025-04-21	1355	\N	2157	6	11.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1516	LB_4_138_259_0	2025-04-24	1263	\N	2205	7	91.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1517	LB_4_138_259_1	2025-04-24	1263	\N	2205	8	91.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1518	LB_4_138_259_2	2025-04-24	1263	\N	2205	9	91.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1519	LB_4_642_259_3	2025-04-24	1263	\N	2644	7	736.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1520	LB_4_642_259_4	2025-04-24	1263	\N	2644	8	736.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1521	LB_4_642_259_5	2025-04-24	1263	\N	2644	9	736.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1522	LB_4_868_259_6	2025-04-24	1263	\N	2935	7	277.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1523	LB_4_868_259_7	2025-04-24	1263	\N	2935	8	277.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1524	LB_4_868_259_8	2025-04-24	1263	\N	2935	9	277.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1525	LB_4_30_259_9	2025-04-24	1263	\N	2098	7	686.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1526	LB_4_30_259_10	2025-04-24	1263	\N	2098	8	686.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1527	LB_4_30_259_11	2025-04-24	1263	\N	2098	9	686.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1528	LB_4_42_259_12	2025-04-24	1263	\N	2110	7	6.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1529	LB_4_42_259_13	2025-04-24	1263	\N	2110	8	6.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1530	LB_4_42_259_14	2025-04-24	1263	\N	2110	9	6.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1531	LB_4_138_259_15	2025-04-24	1263	\N	2205	7	825.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1532	LB_4_138_259_16	2025-04-24	1263	\N	2205	8	825.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1533	LB_4_138_259_17	2025-04-24	1263	\N	2205	9	825.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1534	LB_4_138_259_18	2025-04-24	1263	\N	2205	7	17.190	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1535	LB_4_216_259_19	2025-04-24	1263	\N	2283	7	3.584	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1536	LB_4_409_259_20	2025-04-24	1263	\N	2476	7	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1537	LB_4_409_259_21	2025-04-24	1263	\N	2476	8	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1538	LB_4_409_259_22	2025-04-24	1263	\N	2476	9	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1539	LB_4_486_259_23	2025-04-24	1263	\N	2553	7	1466.265	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1540	LB_4_486_259_24	2025-04-24	1263	\N	2553	8	1466.265	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1541	LB_4_486_259_25	2025-04-24	1263	\N	2553	9	1466.265	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1542	LB_4_236_259_26	2025-04-24	1263	\N	2303	7	157.088	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1543	LB_4_236_259_27	2025-04-24	1263	\N	2303	8	157.088	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1544	LB_4_126_259_28	2025-04-24	1263	\N	2193	7	194.510	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1545	LB_4_126_259_29	2025-04-24	1263	\N	2193	8	194.510	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1546	LB_4_898_259_30	2025-04-24	1263	\N	2964	7	519.860	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1547	LB_4_898_259_31	2025-04-24	1263	\N	2964	8	519.860	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1548	LB_4_813_259_32	2025-04-24	1263	\N	2880	7	388.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1549	LB_4_813_259_33	2025-04-24	1263	\N	2880	8	388.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1550	LB_4_813_259_34	2025-04-24	1263	\N	2880	9	388.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1551	LB_4_897_259_35	2025-04-24	1263	\N	2963	7	369.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1552	LB_4_897_259_36	2025-04-24	1263	\N	2963	8	369.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1553	LB_4_897_259_37	2025-04-24	1263	\N	2963	9	369.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1554	LB_4_40_259_38	2025-04-24	1263	\N	2108	7	1128.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1555	LB_4_40_259_39	2025-04-24	1263	\N	2108	8	1128.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1556	LB_4_40_259_40	2025-04-24	1263	\N	2108	9	1128.100	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1557	LB_4_42_259_41	2025-04-24	1263	\N	2110	7	96.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1558	LB_4_42_259_42	2025-04-24	1263	\N	2110	8	96.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1559	LB_4_42_259_43	2025-04-24	1263	\N	2110	9	96.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1560	LB_4_164_259_44	2025-04-24	1263	\N	2231	7	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1561	LB_4_164_259_45	2025-04-24	1263	\N	2231	8	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1562	LB_4_164_259_46	2025-04-24	1263	\N	2231	9	399.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1563	LB_4_164_259_47	2025-04-24	1263	\N	2231	7	4.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1564	LB_4_409_259_48	2025-04-24	1263	\N	2476	7	234.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1565	LB_4_409_259_49	2025-04-24	1263	\N	2476	8	234.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1566	LB_4_409_259_50	2025-04-24	1263	\N	2476	9	234.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1567	LB_4_19_259_51	2025-04-24	1263	\N	2087	7	295.880	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1568	LB_4_19_259_52	2025-04-24	1263	\N	2087	8	295.880	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1569	LB_4_19_259_53	2025-04-24	1263	\N	2087	9	295.880	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1570	LB_4_307_260_0	2025-04-24	1263	\N	2374	7	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1571	LB_4_307_260_1	2025-04-24	1263	\N	2374	8	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1572	LB_4_307_260_2	2025-04-24	1263	\N	2374	9	11.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1573	LB_4_868_260_3	2025-04-24	1263	\N	2935	7	19.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1574	LB_4_868_260_4	2025-04-24	1263	\N	2935	8	19.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1575	LB_4_868_260_5	2025-04-24	1263	\N	2935	9	19.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1576	LB_4_42_260_6	2025-04-24	1263	\N	2110	7	39.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1577	LB_4_42_260_7	2025-04-24	1263	\N	2110	8	39.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1578	LB_4_42_260_8	2025-04-24	1263	\N	2110	9	39.680	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1579	LB_4_164_260_9	2025-04-24	1263	\N	2231	7	14.880	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1580	LB_4_164_260_10	2025-04-24	1263	\N	2231	8	14.880	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1581	LB_4_164_260_11	2025-04-24	1263	\N	2231	9	14.880	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1582	LB_4_486_260_12	2025-04-24	1263	\N	2553	7	6.135	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1583	LB_4_486_260_13	2025-04-24	1263	\N	2553	8	6.135	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1584	LB_4_486_260_14	2025-04-24	1263	\N	2553	9	6.135	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1585	LB_4_216_260_15	2025-04-24	1263	\N	2283	7	19.712	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1586	LB_4_216_260_16	2025-04-24	1263	\N	2283	8	19.712	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1587	LB_4_216_260_17	2025-04-24	1263	\N	2283	9	19.712	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1588	LB_4_138_260_18	2025-04-24	1263	\N	2205	7	55.390	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1589	LB_4_138_260_19	2025-04-24	1263	\N	2205	8	55.390	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1590	LB_4_138_260_20	2025-04-24	1263	\N	2205	9	55.390	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1591	LB_4_32_261_0	2025-04-24	1263	\N	2100	6	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1592	LB_4_40_261_1	2025-04-24	1263	\N	2108	6	109.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1593	LB_4_90_262_0	2025-04-24	1263	\N	2157	6	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1594	LB_4_90_262_1	2025-04-24	1263	\N	2157	6	14.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1595	LB_4_90_262_2	2025-04-24	1263	\N	2157	6	8.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1596	LB_5_32_285_0	2025-04-30	1263	\N	2100	7	1.710	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1597	LB_5_32_285_1	2025-04-30	1263	\N	2100	7	511.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1598	LB_5_32_285_2	2025-04-30	1263	\N	2100	8	511.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1599	LB_5_32_285_3	2025-04-30	1263	\N	2100	9	511.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1600	LB_5_40_285_4	2025-04-30	1263	\N	2108	7	1377.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1601	LB_5_40_285_5	2025-04-30	1263	\N	2108	8	1377.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1602	LB_5_40_285_6	2025-04-30	1263	\N	2108	9	1377.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1603	LB_5_143_285_7	2025-04-30	1263	\N	2210	7	8.835	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1604	LB_5_143_285_8	2025-04-30	1263	\N	2210	7	521.265	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1605	LB_5_143_285_9	2025-04-30	1263	\N	2210	8	521.265	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1606	LB_5_143_285_10	2025-04-30	1263	\N	2210	9	521.265	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1607	LB_5_204_285_11	2025-04-30	1263	\N	2271	7	948.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1608	LB_5_204_285_12	2025-04-30	1263	\N	2271	8	948.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1609	LB_5_204_285_13	2025-04-30	1263	\N	2271	9	948.290	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1610	LB_5_307_285_14	2025-04-30	1263	\N	2374	7	411.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1611	LB_5_307_285_15	2025-04-30	1263	\N	2374	8	411.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1612	LB_5_307_285_16	2025-04-30	1263	\N	2374	9	411.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1613	LB_5_900_285_17	2025-04-30	1263	\N	2966	7	481.920	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1614	LB_5_900_285_18	2025-04-30	1263	\N	2966	8	481.920	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1615	LB_5_900_285_19	2025-04-30	1263	\N	2966	9	481.920	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1616	LB_5_138_285_20	2025-04-30	1263	\N	2205	7	903.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1617	LB_5_138_285_21	2025-04-30	1263	\N	2205	8	903.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1618	LB_5_138_285_22	2025-04-30	1263	\N	2205	9	903.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1619	LB_5_573_285_23	2025-04-30	1263	\N	2705	7	205.530	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1620	LB_5_573_285_24	2025-04-30	1263	\N	2705	8	205.530	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1621	LB_5_573_285_25	2025-04-30	1263	\N	2705	9	205.530	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1622	LB_5_901_285_26	2025-04-30	1263	\N	2967	7	220.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1623	LB_5_901_285_27	2025-04-30	1263	\N	2967	8	220.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1624	LB_5_901_285_28	2025-04-30	1263	\N	2967	9	220.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1625	LB_5_5_285_29	2025-04-30	1263	\N	2073	7	1833.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1626	LB_5_5_285_30	2025-04-30	1263	\N	2073	8	1833.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1627	LB_5_5_285_31	2025-04-30	1263	\N	2073	9	1833.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1628	LB_5_5_285_32	2025-04-30	1263	\N	2073	7	46.350	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1629	LB_5_5_285_33	2025-04-30	1263	\N	2073	8	46.350	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1630	LB_5_5_285_34	2025-04-30	1263	\N	2073	9	46.350	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1631	LB_5_138_286_0	2025-04-30	1263	\N	2205	7	45.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1632	LB_5_138_286_1	2025-04-30	1263	\N	2205	8	45.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1633	LB_5_138_286_2	2025-04-30	1263	\N	2205	9	45.840	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1634	LB_5_90_287_0	2025-04-30	1263	\N	2157	6	11.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1635	LB_5_90_287_1	2025-04-30	1263	\N	2157	6	6.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1636	LB_5_90_291_0	2025-04-30	1263	\N	2157	6	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1637	LB_5_90_291_1	2025-04-30	1263	\N	2157	6	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1638	LB_5_90_291_2	2025-04-30	1263	\N	2157	6	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1639	LB_5_243_293_0	2025-04-30	1263	\N	2310	7	17.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1640	LB_5_243_293_1	2025-04-30	1263	\N	2310	8	17.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1641	LB_5_596_293_2	2025-04-30	1263	\N	2598	7	80.240	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1642	LB_5_596_293_3	2025-04-30	1263	\N	2598	8	80.240	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1643	LB_5_596_293_4	2025-04-30	1263	\N	2598	9	80.240	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1644	LB_6_17_598_0	2025-05-06	1263	\N	2085	7	1313.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1645	LB_6_17_598_1	2025-05-06	1263	\N	2085	8	1313.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1646	LB_6_17_598_2	2025-05-06	1263	\N	2085	9	1313.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1647	LB_6_40_598_3	2025-05-06	1263	\N	2108	7	2025.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1648	LB_6_40_598_4	2025-05-06	1263	\N	2108	8	2025.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1649	LB_6_40_598_5	2025-05-06	1263	\N	2108	9	2025.650	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1650	LB_6_40_598_6	2025-05-06	1263	\N	2108	7	27.550	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1651	LB_6_40_598_7	2025-05-06	1263	\N	2108	8	27.550	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1652	LB_6_40_598_8	2025-05-06	1263	\N	2108	9	27.550	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1653	LB_6_460_598_9	2025-05-06	1263	\N	2527	7	1.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1654	LB_6_460_598_10	2025-05-06	1263	\N	2527	8	1.430	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1655	LB_6_590_598_11	2025-05-06	1263	\N	2722	7	3.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1656	LB_6_590_598_12	2025-05-06	1263	\N	2722	7	6.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1657	LB_6_590_598_13	2025-05-06	1263	\N	2722	8	6.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1658	LB_6_590_598_14	2025-05-06	1263	\N	2722	9	6.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1659	LB_6_208_598_15	2025-05-06	1263	\N	2275	7	116.050	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1660	LB_6_208_598_16	2025-05-06	1263	\N	2275	8	116.050	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1661	LB_6_914_598_17	2025-05-06	1263	\N	2980	7	0.236	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1662	LB_6_914_598_18	2025-05-06	1263	\N	2980	8	0.236	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1663	LB_6_914_598_19	2025-05-06	1263	\N	2980	9	0.236	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1664	LB_6_90_599_0	2025-05-06	1263	\N	2157	6	8.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1665	LB_6_90_599_1	2025-05-06	1263	\N	2157	6	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1666	LB_10_975_996_0	2025-05-28	1263	\N	3042	7	557.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1667	LB_10_975_996_1	2025-05-28	1263	\N	3042	8	557.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1668	LB_10_975_996_2	2025-05-28	1263	\N	3042	9	557.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1669	LB_10_268_996_3	2025-05-28	1263	\N	2335	7	4.008	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1670	LB_10_268_996_4	2025-05-28	1263	\N	2335	7	997.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1671	LB_10_268_996_5	2025-05-28	1263	\N	2335	8	997.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1672	LB_10_268_996_6	2025-05-28	1263	\N	2335	9	997.992	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1673	LB_10_640_996_7	2025-05-28	1263	\N	2642	7	31.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1674	LB_10_640_996_8	2025-05-28	1263	\N	2642	8	31.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1675	LB_10_640_996_9	2025-05-28	1263	\N	2642	9	31.980	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1676	LB_10_946_996_10	2025-05-28	1263	\N	3013	7	4.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1677	LB_10_946_996_11	2025-05-28	1263	\N	3013	7	101.250	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1678	LB_10_946_996_12	2025-05-28	1263	\N	3013	8	101.250	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1679	LB_10_946_996_13	2025-05-28	1263	\N	3013	9	101.250	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1680	LB_10_974_996_14	2025-05-28	1263	\N	3041	7	8.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1681	LB_10_974_996_15	2025-05-28	1263	\N	3041	7	2432.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1682	LB_10_974_996_16	2025-05-28	1263	\N	3041	8	2432.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1683	LB_10_974_996_17	2025-05-28	1263	\N	3041	9	2432.080	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1684	LB_10_88_996_18	2025-05-28	1263	\N	2155	7	138.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1685	LB_10_88_996_19	2025-05-28	1263	\N	2155	7	3323.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1686	LB_10_88_996_20	2025-05-28	1263	\N	2155	8	3323.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1687	LB_10_88_996_21	2025-05-28	1263	\N	2155	9	3323.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1688	LB_10_898_996_22	2025-05-28	1263	\N	2964	7	417.010	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1689	LB_10_898_996_23	2025-05-28	1263	\N	2964	8	417.010	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1690	LB_10_905_996_24	2025-05-28	1263	\N	2971	7	420.140	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1691	LB_10_905_996_25	2025-05-28	1263	\N	2971	8	420.140	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1692	LB_10_905_996_26	2025-05-28	1263	\N	2971	9	420.140	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1693	LB_10_15_996_27	2025-05-28	1263	\N	2083	7	2767.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1694	LB_10_15_996_28	2025-05-28	1263	\N	2083	8	2767.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1695	LB_10_15_996_29	2025-05-28	1263	\N	2083	9	2767.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1696	LB_10_962_996_30	2025-05-28	1263	\N	3029	7	4.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1697	LB_10_962_996_31	2025-05-28	1263	\N	3029	7	460.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1698	LB_10_962_996_32	2025-05-28	1263	\N	3029	8	460.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1699	LB_10_962_996_33	2025-05-28	1263	\N	3029	9	460.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1700	LB_10_299_996_34	2025-05-28	1263	\N	2366	7	403.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1701	LB_10_299_996_35	2025-05-28	1263	\N	2366	8	403.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1702	LB_10_299_996_36	2025-05-28	1263	\N	2366	9	403.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1703	LB_10_90_997_0	2025-05-28	1263	\N	2157	6	5.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1704	LB_10_90_997_1	2025-05-28	1263	\N	2157	6	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1705	LB_10_90_997_2	2025-05-28	1263	\N	2157	6	3.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1706	LB_11_869_1004_0	2025-06-04	1263	\N	2936	7	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1707	LB_11_299_1005_0	2025-06-04	1263	\N	2366	7	1275.376	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1708	LB_11_299_1005_1	2025-06-04	1263	\N	2366	8	1275.376	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1709	LB_11_299_1005_2	2025-06-04	1263	\N	2366	9	1275.376	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1710	LB_11_299_1005_3	2025-06-04	1263	\N	2366	7	387.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1711	LB_11_299_1005_4	2025-06-04	1263	\N	2366	8	387.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1712	LB_11_299_1005_5	2025-06-04	1263	\N	2366	9	387.456	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1713	LB_11_454_1005_6	2025-06-04	1263	\N	2521	7	546.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1714	LB_11_454_1005_7	2025-06-04	1263	\N	2521	8	546.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1715	LB_11_454_1005_8	2025-06-04	1263	\N	2521	9	546.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1716	LB_11_874_1005_9	2025-06-04	1263	\N	2941	7	493.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1717	LB_11_874_1005_10	2025-06-04	1263	\N	2941	8	493.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1718	LB_11_874_1005_11	2025-06-04	1263	\N	2941	9	493.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1719	LB_11_90_1006_0	2025-06-04	1263	\N	2157	6	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1720	LB_14_170_1011_0	2025-06-23	1306	\N	2237	7	11.642	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1721	LB_14_170_1011_1	2025-06-23	1306	\N	2237	7	780.014	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1722	LB_14_170_1011_2	2025-06-23	1306	\N	2237	8	780.014	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1723	LB_14_170_1011_3	2025-06-23	1306	\N	2237	9	780.014	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1724	LB_14_125_1011_4	2025-06-23	1306	\N	2192	7	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1725	LB_14_125_1011_5	2025-06-23	1306	\N	2192	7	362.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1726	LB_14_125_1011_6	2025-06-23	1306	\N	2192	8	362.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1727	LB_14_125_1011_7	2025-06-23	1306	\N	2192	9	362.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1728	LB_14_963_1011_8	2025-06-23	1306	\N	3030	7	2201.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1729	LB_14_963_1011_9	2025-06-23	1306	\N	3030	8	2201.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1730	LB_14_963_1011_10	2025-06-23	1306	\N	3030	9	2201.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1731	LB_14_143_1011_11	2025-06-23	1306	\N	2210	7	19.437	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1732	LB_14_143_1011_12	2025-06-23	1306	\N	2210	7	1524.921	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1733	LB_14_143_1011_13	2025-06-23	1306	\N	2210	8	1524.921	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1734	LB_14_143_1011_14	2025-06-23	1306	\N	2210	9	1524.921	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1735	LB_14_454_1011_15	2025-06-23	1306	\N	2521	7	1639.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1736	LB_14_454_1011_16	2025-06-23	1306	\N	2521	8	1639.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1737	LB_14_454_1011_17	2025-06-23	1306	\N	2521	9	1639.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1738	LB_14_539_1011_18	2025-06-23	1306	\N	2671	7	1400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1739	LB_14_539_1011_19	2025-06-23	1306	\N	2671	8	1400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1740	LB_14_539_1011_20	2025-06-23	1306	\N	2671	9	1400.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1741	LB_14_958_1011_21	2025-06-23	1306	\N	3025	7	167.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1742	LB_14_958_1011_22	2025-06-23	1306	\N	3025	8	167.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1743	LB_14_958_1011_23	2025-06-23	1306	\N	3025	9	167.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1744	LB_14_869_1011_24	2025-06-23	1306	\N	2936	7	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1745	LB_14_869_1011_25	2025-06-23	1306	\N	2936	8	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1746	LB_14_869_1011_26	2025-06-23	1306	\N	2936	9	11.520	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1747	LB_14_971_1011_27	2025-06-23	1306	\N	3038	7	1842.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1748	LB_14_971_1011_28	2025-06-23	1306	\N	3038	8	1842.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1749	LB_14_971_1011_29	2025-06-23	1306	\N	3038	9	1842.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1750	LB_14_874_1011_30	2025-06-23	1306	\N	2941	7	977.130	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1751	LB_14_874_1011_31	2025-06-23	1306	\N	2941	8	977.130	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1752	LB_14_874_1011_32	2025-06-23	1306	\N	2941	9	977.130	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1753	LB_14_874_1011_33	2025-06-23	1306	\N	2941	7	9.870	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1754	LB_15_90_1012_0	2025-06-24	1263	\N	2157	6	22.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1755	LB_15_90_1012_1	2025-06-24	1263	\N	2157	6	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1756	LB_15_170_1014_0	2025-06-24	1263	\N	2237	7	372.544	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1757	LB_15_170_1014_1	2025-06-24	1263	\N	2237	8	372.544	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1758	LB_15_170_1014_2	2025-06-24	1263	\N	2237	9	372.544	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1759	LB_15_226_1014_3	2025-06-24	1263	\N	2293	7	288.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1760	LB_15_226_1014_4	2025-06-24	1263	\N	2293	8	288.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1761	LB_15_152_1014_5	2025-06-24	1263	\N	2219	7	4.760	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1762	LB_15_152_1014_6	2025-06-24	1263	\N	2219	7	337.960	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1763	LB_15_152_1014_7	2025-06-24	1263	\N	2219	8	337.960	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1764	LB_15_899_1014_8	2025-06-24	1263	\N	2965	7	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1765	LB_15_899_1014_9	2025-06-24	1263	\N	2965	7	1081.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1766	LB_15_899_1014_10	2025-06-24	1263	\N	2965	8	1081.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1767	LB_15_899_1014_11	2025-06-24	1263	\N	2965	9	1081.700	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1768	LB_15_914_1014_12	2025-06-24	1263	\N	2980	7	109.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1769	LB_15_914_1014_13	2025-06-24	1263	\N	2980	8	109.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1770	LB_15_914_1014_14	2025-06-24	1263	\N	2980	9	109.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1771	LB_15_122_1014_15	2025-06-24	1263	\N	2189	7	185.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1772	LB_15_122_1014_16	2025-06-24	1263	\N	2189	8	185.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1773	LB_15_122_1014_17	2025-06-24	1263	\N	2189	9	185.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1774	LB_15_882_1014_18	2025-06-24	1263	\N	2949	7	20.740	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1775	LB_15_882_1014_19	2025-06-24	1263	\N	2949	7	3090.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1776	LB_15_882_1014_20	2025-06-24	1263	\N	2949	8	3090.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1777	LB_15_882_1014_21	2025-06-24	1263	\N	2949	9	3090.260	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1778	LB_15_919_1014_22	2025-06-24	1263	\N	2986	7	833.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1779	LB_15_919_1014_23	2025-06-24	1263	\N	2986	8	833.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1780	LB_15_919_1014_24	2025-06-24	1263	\N	2986	9	833.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1781	LB_16_869_1015_0	2025-07-02	1263	\N	2936	7	13.536	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1782	LB_16_90_1016_0	2025-07-02	1263	\N	2157	6	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1783	LB_16_90_1016_1	2025-07-02	1263	\N	2157	6	9.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1784	LB_21_869_1024_0	2025-07-30	1263	\N	2936	6	56.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1785	LB_21_978_1024_1	2025-07-30	1263	\N	3045	6	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1786	LB_21_90_1024_2	2025-07-30	1263	\N	2157	6	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1787	LB_23_81_1026_0	2025-08-06	1263	\N	2148	7	1.620	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1788	LB_23_81_1026_1	2025-08-06	1263	\N	2148	7	152.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1789	LB_23_81_1026_2	2025-08-06	1263	\N	2148	8	152.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1790	LB_23_81_1026_3	2025-08-06	1263	\N	2148	9	152.280	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1791	LB_23_961_1026_4	2025-08-06	1263	\N	3028	7	2315.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1792	LB_23_961_1026_5	2025-08-06	1263	\N	3028	8	2315.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1793	LB_23_961_1026_6	2025-08-06	1263	\N	3028	9	2315.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1794	LB_23_974_1026_7	2025-08-06	1263	\N	3041	7	2327.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1795	LB_23_974_1026_8	2025-08-06	1263	\N	3041	8	2327.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1796	LB_23_974_1026_9	2025-08-06	1263	\N	3041	9	2327.040	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1797	LB_23_130_1026_10	2025-08-06	1263	\N	2197	7	876.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1798	LB_23_130_1026_11	2025-08-06	1263	\N	2197	8	876.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1799	LB_23_130_1026_12	2025-08-06	1263	\N	2197	9	876.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1800	LB_23_585_1026_13	2025-08-06	1263	\N	2717	7	7.060	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1801	LB_23_585_1026_14	2025-08-06	1263	\N	2717	7	635.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1802	LB_23_585_1026_15	2025-08-06	1263	\N	2717	8	635.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1803	LB_23_585_1026_16	2025-08-06	1263	\N	2717	9	635.400	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1804	LB_23_958_1026_17	2025-08-06	1263	\N	3025	7	327.210	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1805	LB_23_958_1026_18	2025-08-06	1263	\N	3025	8	327.210	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1806	LB_23_958_1026_19	2025-08-06	1263	\N	3025	9	327.210	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1807	LB_23_906_1026_20	2025-08-06	1263	\N	2972	7	732.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1808	LB_23_906_1026_21	2025-08-06	1263	\N	2972	8	732.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1809	LB_23_906_1026_22	2025-08-06	1263	\N	2972	9	732.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1810	LB_23_944_1026_23	2025-08-06	1263	\N	3011	7	1017.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1811	LB_23_944_1026_24	2025-08-06	1263	\N	3011	8	1017.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1812	LB_23_944_1026_25	2025-08-06	1263	\N	3011	9	1017.720	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1813	LB_23_958_1026_26	2025-08-06	1263	\N	3025	7	25.170	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1814	LB_23_958_1026_27	2025-08-06	1263	\N	3025	7	1652.830	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1815	LB_23_958_1026_28	2025-08-06	1263	\N	3025	8	1652.830	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1816	LB_23_958_1026_29	2025-08-06	1263	\N	3025	9	1652.830	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1817	LB_23_19_1026_30	2025-08-06	1263	\N	2087	7	411.320	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1818	LB_23_19_1026_31	2025-08-06	1263	\N	2087	8	411.320	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1819	LB_23_19_1026_32	2025-08-06	1263	\N	2087	9	411.320	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1820	LB_24_90_1027_0	2025-08-13	1263	\N	2157	6	7.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1821	LB_24_90_1027_1	2025-08-13	1263	\N	2157	6	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1822	LB_24_90_1027_2	2025-08-13	1263	\N	2157	6	11.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1823	LB_24_90_1027_3	2025-08-13	1263	\N	2157	6	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1824	LB_26_978_1029_0	2025-08-27	1263	\N	3045	7	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1825	LB_27_972_1032_0	2025-09-03	1263	\N	3039	7	180.660	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1826	LB_27_972_1032_1	2025-09-03	1263	\N	3039	8	180.660	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1827	LB_27_972_1032_2	2025-09-03	1263	\N	3039	9	180.660	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1828	LB_27_22_1032_3	2025-09-03	1263	\N	2090	7	1420.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1829	LB_27_22_1032_4	2025-09-03	1263	\N	2090	8	1420.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1830	LB_27_22_1032_5	2025-09-03	1263	\N	2090	9	1420.440	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1831	LB_27_22_1032_6	2025-09-03	1263	\N	2090	7	9.345	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1832	LB_27_862_1032_7	2025-09-03	1263	\N	2929	7	277.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1833	LB_27_862_1032_8	2025-09-03	1263	\N	2929	8	277.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1834	LB_27_862_1032_9	2025-09-03	1263	\N	2929	9	277.780	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1835	LB_27_453_1032_10	2025-09-03	1263	\N	2520	7	200.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1836	LB_27_453_1032_11	2025-09-03	1263	\N	2520	8	200.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1837	LB_27_453_1032_12	2025-09-03	1263	\N	2520	9	200.600	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1838	LB_27_977_1032_13	2025-09-03	1263	\N	3044	7	213.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1839	LB_27_977_1032_14	2025-09-03	1263	\N	3044	8	213.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1840	LB_27_977_1032_15	2025-09-03	1263	\N	3044	9	213.200	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1841	LB_27_274_1032_16	2025-09-03	1263	\N	2341	7	504.850	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1842	LB_27_274_1032_17	2025-09-03	1263	\N	2341	8	504.850	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1843	LB_27_274_1032_18	2025-09-03	1263	\N	2341	9	504.850	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1844	LB_27_862_1032_19	2025-09-03	1263	\N	2929	7	739.772	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1845	LB_27_862_1032_20	2025-09-03	1263	\N	2929	8	739.772	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1846	LB_27_862_1032_21	2025-09-03	1263	\N	2929	9	739.772	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1847	LB_27_899_1032_22	2025-09-03	1263	\N	2965	7	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1848	LB_27_899_1032_23	2025-09-03	1263	\N	2965	8	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1849	LB_27_899_1032_24	2025-09-03	1263	\N	2965	9	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1850	LB_27_111_1032_25	2025-09-03	1263	\N	2178	7	0.978	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1851	LB_27_111_1032_26	2025-09-03	1263	\N	2178	8	0.978	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1852	LB_27_111_1032_27	2025-09-03	1263	\N	2178	9	0.978	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1853	LB_27_585_1032_28	2025-09-03	1263	\N	2717	7	14.120	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1854	LB_27_585_1032_29	2025-09-03	1263	\N	2717	8	14.120	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1855	LB_27_585_1032_30	2025-09-03	1263	\N	2717	9	14.120	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1856	LB_27_899_1032_31	2025-09-03	1263	\N	2965	7	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1857	LB_27_899_1032_32	2025-09-03	1263	\N	2965	8	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1858	LB_27_899_1032_33	2025-09-03	1263	\N	2965	9	1.450	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1859	LB_27_914_1032_34	2025-09-03	1263	\N	2980	7	23.836	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1860	LB_27_914_1032_35	2025-09-03	1263	\N	2980	8	23.836	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1861	LB_27_914_1032_36	2025-09-03	1263	\N	2980	9	23.836	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1862	LB_27_125_1032_37	2025-09-03	1263	\N	2192	7	16.224	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1863	LB_27_125_1032_38	2025-09-03	1263	\N	2192	8	16.224	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1864	LB_27_125_1032_39	2025-09-03	1263	\N	2192	9	16.224	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1865	LB_27_946_1032_40	2025-09-03	1263	\N	3013	7	1.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1866	LB_27_946_1032_41	2025-09-03	1263	\N	3013	8	1.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1867	LB_27_946_1032_42	2025-09-03	1263	\N	3013	9	1.500	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1868	LB_27_143_1032_43	2025-09-03	1263	\N	2210	7	1.767	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1869	LB_27_143_1032_44	2025-09-03	1263	\N	2210	8	1.767	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1870	LB_27_143_1032_45	2025-09-03	1263	\N	2210	9	1.767	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1871	LB_27_129_1032_46	2025-09-03	1263	\N	2196	7	0.510	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1872	LB_27_129_1032_47	2025-09-03	1263	\N	2196	8	0.510	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1873	LB_27_129_1032_48	2025-09-03	1263	\N	2196	9	0.510	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1874	LB_27_90_1033_0	2025-09-03	1263	\N	2157	6	8.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1875	LB_27_90_1033_1	2025-09-03	1263	\N	2157	6	3.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1876	LB_30_22_1039_0	2025-09-10	1551	\N	2090	7	373.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1877	LB_30_22_1039_1	2025-09-10	1551	\N	2090	8	373.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1878	LB_30_22_1039_2	2025-09-10	1551	\N	2090	9	373.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1879	LB_30_642_1039_3	2025-09-10	1551	\N	2644	7	7.365	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1880	LB_30_642_1039_4	2025-09-10	1551	\N	2644	7	1200.495	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1881	LB_30_642_1039_5	2025-09-10	1551	\N	2644	8	1200.495	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1882	LB_30_642_1039_6	2025-09-10	1551	\N	2644	9	1200.495	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1883	LB_30_947_1039_7	2025-09-10	1551	\N	3014	7	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1884	LB_30_947_1039_8	2025-09-10	1551	\N	3014	8	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1885	LB_30_947_1039_9	2025-09-10	1551	\N	3014	9	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1886	LB_30_109_1039_10	2025-09-10	1551	\N	2176	7	1967.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1887	LB_30_109_1039_11	2025-09-10	1551	\N	2176	8	1967.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1888	LB_30_109_1039_12	2025-09-10	1551	\N	2176	9	1967.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1889	LB_30_40_1039_13	2025-09-10	1551	\N	2108	7	609.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1890	LB_30_40_1039_14	2025-09-10	1551	\N	2108	8	609.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1891	LB_30_40_1039_15	2025-09-10	1551	\N	2108	9	609.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1892	LB_29_90_1040_0	2025-09-09	1263	\N	2157	6	10.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1893	LB_29_90_1040_1	2025-09-09	1263	\N	2157	6	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1894	LB_31_90_1041_0	2025-09-17	1263	\N	2157	6	10.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1895	LB_31_90_1041_1	2025-09-17	1263	\N	2157	6	4.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1896	LB_31_109_1042_0	2025-09-17	1263	\N	2176	7	68.800	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1897	LB_31_109_1042_1	2025-09-17	1263	\N	2176	7	426.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1898	LB_31_109_1042_2	2025-09-17	1263	\N	2176	8	426.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1899	LB_31_109_1042_3	2025-09-17	1263	\N	2176	9	426.560	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1900	LB_31_40_1042_4	2025-09-17	1263	\N	2108	7	20.300	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1901	LB_31_40_1042_5	2025-09-17	1263	\N	2108	7	1945.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1902	LB_31_40_1042_6	2025-09-17	1263	\N	2108	8	1945.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1903	LB_31_40_1042_7	2025-09-17	1263	\N	2108	9	1945.900	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1904	LB_31_299_1042_8	2025-09-17	1263	\N	2366	7	169.334	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1905	LB_31_299_1042_9	2025-09-17	1263	\N	2366	8	169.334	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1906	LB_31_299_1042_10	2025-09-17	1263	\N	2366	9	169.334	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1907	LB_32_1_1044_0	2025-09-24	1263	\N	2069	6	1.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1908	LB_32_90_1045_0	2025-09-24	1263	\N	2157	6	6.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1909	LB_32_90_1045_1	2025-09-24	1263	\N	2157	6	2.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1910	LB_32_978_1045_2	2025-09-24	1263	\N	3045	6	20.000	0.00	0.00	12.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1911	LB_35_103_1055_0	2025-10-08	1263	\N	2170	7	975.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1912	LB_35_103_1055_1	2025-10-08	1263	\N	2170	8	975.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1913	LB_35_103_1055_2	2025-10-08	1263	\N	2170	9	975.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1914	LB_35_115_1055_3	2025-10-08	1263	\N	2182	7	163.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1915	LB_35_115_1055_4	2025-10-08	1263	\N	2182	8	163.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1916	LB_35_115_1055_5	2025-10-08	1263	\N	2182	9	163.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1917	LB_35_204_1055_6	2025-10-08	1263	\N	2271	7	21.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1918	LB_35_204_1055_7	2025-10-08	1263	\N	2271	7	2613.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1919	LB_35_204_1055_8	2025-10-08	1263	\N	2271	8	2613.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1920	LB_35_204_1055_9	2025-10-08	1263	\N	2271	9	2613.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1921	LB_35_879_1055_10	2025-10-08	1263	\N	2946	7	7.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1922	LB_35_879_1055_11	2025-10-08	1263	\N	2946	7	319.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1923	LB_35_879_1055_12	2025-10-08	1263	\N	2946	8	319.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1924	LB_35_15_1055_13	2025-10-08	1263	\N	2083	7	2651.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1925	LB_35_15_1055_14	2025-10-08	1263	\N	2083	8	2651.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1926	LB_35_15_1055_15	2025-10-08	1263	\N	2083	9	2651.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1927	LB_35_22_1055_16	2025-10-08	1263	\N	2090	7	9.345	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1928	LB_35_22_1055_17	2025-10-08	1263	\N	2090	7	943.845	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1929	LB_35_22_1055_18	2025-10-08	1263	\N	2090	8	943.845	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1930	LB_35_22_1055_19	2025-10-08	1263	\N	2090	9	943.845	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1931	LB_35_979_1055_20	2025-10-08	1263	\N	3046	7	706.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1932	LB_35_979_1055_21	2025-10-08	1263	\N	3046	8	706.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1933	LB_35_979_1055_22	2025-10-08	1263	\N	3046	9	706.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1934	LB_35_980_1055_23	2025-10-08	1263	\N	3047	7	762.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1935	LB_35_980_1055_24	2025-10-08	1263	\N	3047	8	762.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1936	LB_35_980_1055_25	2025-10-08	1263	\N	3047	9	762.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1937	LB_35_981_1055_26	2025-10-08	1263	\N	3048	7	430.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1938	LB_35_981_1055_27	2025-10-08	1263	\N	3048	8	430.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1939	LB_35_981_1055_28	2025-10-08	1263	\N	3048	9	430.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1940	LB_35_22_1055_29	2025-10-08	1263	\N	2090	7	934.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1941	LB_35_22_1055_30	2025-10-08	1263	\N	2090	8	934.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1942	LB_36_90_1056_0	2025-10-15	1263	\N	2157	6	17.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1943	LB_36_90_1056_1	2025-10-15	1263	\N	2157	6	9.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1944	LB_37_859_1060_0	2025-10-22	1263	\N	2926	7	14.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1945	LB_37_859_1060_1	2025-10-22	1263	\N	2926	7	1423.620	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1946	LB_37_859_1060_2	2025-10-22	1263	\N	2926	8	1423.620	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1947	LB_37_859_1060_3	2025-10-22	1263	\N	2926	9	1423.620	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1948	LB_37_394_1060_4	2025-10-22	1263	\N	2461	7	960.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1949	LB_37_394_1060_5	2025-10-22	1263	\N	2461	8	960.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1950	LB_37_394_1060_6	2025-10-22	1263	\N	2461	9	960.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1951	LB_37_164_1060_7	2025-10-22	1263	\N	2231	7	27.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1952	LB_37_164_1060_8	2025-10-22	1263	\N	2231	8	27.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1953	LB_37_164_1060_9	2025-10-22	1263	\N	2231	9	27.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1954	LB_37_230_1060_10	2025-10-22	1263	\N	2297	7	321.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1955	LB_37_230_1060_11	2025-10-22	1263	\N	2297	8	321.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1956	LB_37_230_1060_12	2025-10-22	1263	\N	2297	9	321.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1957	LB_37_367_1060_13	2025-10-22	1263	\N	2434	7	32.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1958	LB_37_367_1060_14	2025-10-22	1263	\N	2434	8	32.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1959	LB_37_626_1060_15	2025-10-22	1263	\N	2628	7	148.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1960	LB_37_626_1060_16	2025-10-22	1263	\N	2628	8	148.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1961	LB_37_626_1060_17	2025-10-22	1263	\N	2628	9	148.280	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1962	LB_37_963_1060_18	2025-10-22	1263	\N	3030	7	1584.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1963	LB_37_963_1060_19	2025-10-22	1263	\N	3030	8	1584.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1964	LB_37_963_1060_20	2025-10-22	1263	\N	3030	9	1584.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1965	LB_37_229_1060_21	2025-10-22	1263	\N	2296	7	29.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1966	LB_37_229_1060_22	2025-10-22	1263	\N	2296	8	29.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1967	LB_37_229_1060_23	2025-10-22	1263	\N	2296	9	29.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1968	LB_37_90_1061_0	2025-10-22	1263	\N	2157	6	3.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1969	LB_37_90_1061_1	2025-10-22	1263	\N	2157	6	9.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1970	LB_37_18_1062_0	2025-10-22	1263	\N	2086	7	785.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1971	LB_37_18_1062_1	2025-10-22	1263	\N	2086	8	785.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1972	LB_37_18_1062_2	2025-10-22	1263	\N	2086	9	785.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1973	LB_39_279_1067_0	2025-11-05	1263	\N	2346	7	108.252	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1974	LB_39_279_1067_1	2025-11-05	1263	\N	2346	8	108.252	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1975	LB_39_950_1067_2	2025-11-05	1263	\N	3017	7	12.120	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1976	LB_39_950_1067_3	2025-11-05	1263	\N	3017	7	1769.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1977	LB_39_950_1067_4	2025-11-05	1263	\N	3017	8	1769.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1978	LB_39_950_1067_5	2025-11-05	1263	\N	3017	9	1769.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1979	LB_39_104_1067_6	2025-11-05	1263	\N	2171	7	601.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1980	LB_39_104_1067_7	2025-11-05	1263	\N	2171	8	601.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1981	LB_39_104_1067_8	2025-11-05	1263	\N	2171	9	601.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1982	LB_39_64_1067_9	2025-11-05	1263	\N	2132	7	779.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1983	LB_39_64_1067_10	2025-11-05	1263	\N	2132	8	779.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1984	LB_39_64_1067_11	2025-11-05	1263	\N	2132	9	779.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1985	LB_39_164_1067_12	2025-11-05	1263	\N	2231	7	964.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1986	LB_39_164_1067_13	2025-11-05	1263	\N	2231	8	964.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1987	LB_39_164_1067_14	2025-11-05	1263	\N	2231	9	964.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1988	LB_39_954_1067_15	2025-11-05	1263	\N	3021	7	340.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1989	LB_39_954_1067_16	2025-11-05	1263	\N	3021	8	340.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1990	LB_39_954_1067_17	2025-11-05	1263	\N	3021	9	340.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1991	LB_39_983_1067_18	2025-11-05	1263	\N	3050	7	141.764	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1992	LB_39_983_1067_19	2025-11-05	1263	\N	3050	8	141.764	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1993	LB_39_983_1067_20	2025-11-05	1263	\N	3050	9	141.764	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1994	LB_39_984_1067_21	2025-11-05	1263	\N	3051	7	138.558	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1995	LB_39_984_1067_22	2025-11-05	1263	\N	3051	8	138.558	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1996	LB_39_984_1067_23	2025-11-05	1263	\N	3051	9	138.558	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1997	LB_39_983_1067_24	2025-11-05	1263	\N	3050	7	253.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1998	LB_39_983_1067_25	2025-11-05	1263	\N	3050	8	253.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
1999	LB_39_983_1067_26	2025-11-05	1263	\N	3050	9	253.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2000	LB_39_516_1067_27	2025-11-05	1263	\N	2583	7	27.090	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2001	LB_40_90_1068_0	2025-11-05	1548	\N	2157	6	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2002	LB_40_90_1068_1	2025-11-05	1548	\N	2157	6	12.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2003	LB_41_28_1072_0	2025-11-19	1263	\N	2096	7	55.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2004	LB_41_28_1072_1	2025-11-19	1263	\N	2096	7	2202.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2005	LB_41_28_1072_2	2025-11-19	1263	\N	2096	8	2202.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2006	LB_41_28_1072_3	2025-11-19	1263	\N	2096	9	2202.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2007	LB_41_268_1072_4	2025-11-19	1263	\N	2335	7	1170.336	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2008	LB_41_268_1072_5	2025-11-19	1263	\N	2335	8	1170.336	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2009	LB_41_268_1072_6	2025-11-19	1263	\N	2335	9	1170.336	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2010	LB_41_566_1072_7	2025-11-19	1263	\N	2698	7	9.390	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2011	LB_41_566_1072_8	2025-11-19	1263	\N	2698	7	929.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2012	LB_41_566_1072_9	2025-11-19	1263	\N	2698	8	929.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2013	LB_41_566_1072_10	2025-11-19	1263	\N	2698	9	929.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2014	LB_41_982_1072_11	2025-11-19	1263	\N	3049	7	7.251	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2015	LB_41_982_1072_12	2025-11-19	1263	\N	3049	7	188.526	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2016	LB_41_982_1072_13	2025-11-19	1263	\N	3049	8	188.526	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2017	LB_41_982_1072_14	2025-11-19	1263	\N	3049	9	188.526	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2018	LB_41_982_1072_15	2025-11-19	1263	\N	3049	7	152.271	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2019	LB_41_982_1072_16	2025-11-19	1263	\N	3049	8	152.271	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2020	LB_41_982_1072_17	2025-11-19	1263	\N	3049	9	152.271	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2021	LB_41_114_1072_18	2025-11-19	1263	\N	2181	7	515.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2022	LB_41_114_1072_19	2025-11-19	1263	\N	2181	8	515.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2023	LB_41_114_1072_20	2025-11-19	1263	\N	2181	9	515.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2024	LB_41_178_1072_21	2025-11-19	1263	\N	2245	7	964.410	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2025	LB_41_178_1072_22	2025-11-19	1263	\N	2245	8	964.410	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2026	LB_41_178_1072_23	2025-11-19	1263	\N	2245	9	964.410	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2027	LB_41_452_1072_24	2025-11-19	1263	\N	2519	7	58.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2028	LB_41_452_1072_25	2025-11-19	1263	\N	2519	7	139.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2029	LB_41_452_1072_26	2025-11-19	1263	\N	2519	8	139.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2030	LB_41_452_1072_27	2025-11-19	1263	\N	2519	9	139.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2031	LB_41_311_1072_28	2025-11-19	1263	\N	2378	7	3.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2032	LB_41_311_1072_29	2025-11-19	1263	\N	2378	7	164.640	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2033	LB_41_311_1072_30	2025-11-19	1263	\N	2378	8	164.640	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2034	LB_41_516_1072_31	2025-11-19	1263	\N	2583	7	785.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2035	LB_41_516_1072_32	2025-11-19	1263	\N	2583	8	785.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2036	LB_41_516_1072_33	2025-11-19	1263	\N	2583	9	785.610	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2037	LB_41_229_1072_34	2025-11-19	1263	\N	2296	7	224.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2038	LB_41_229_1072_35	2025-11-19	1263	\N	2296	8	224.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2039	LB_41_229_1072_36	2025-11-19	1263	\N	2296	9	224.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2040	LB_41_268_1072_37	2025-11-19	1263	\N	2335	7	32.064	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2041	LB_41_268_1072_38	2025-11-19	1263	\N	2335	8	32.064	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2042	LB_41_268_1072_39	2025-11-19	1263	\N	2335	9	32.064	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2043	LB_41_202_1072_40	2025-11-19	1263	\N	2269	7	313.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2044	LB_41_202_1072_41	2025-11-19	1263	\N	2269	8	313.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2045	LB_41_204_1072_42	2025-11-19	1263	\N	2271	7	39.330	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2046	LB_41_208_1072_43	2025-11-19	1263	\N	2275	7	2.110	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2047	LB_41_208_1072_44	2025-11-19	1263	\N	2275	7	303.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2048	LB_41_208_1072_45	2025-11-19	1263	\N	2275	8	303.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2049	LB_41_297_1072_46	2025-11-19	1263	\N	2364	7	32.890	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2050	LB_41_297_1072_47	2025-11-19	1263	\N	2364	8	32.890	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2051	LB_41_646_1072_48	2025-11-19	1263	\N	2648	7	261.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2052	LB_41_646_1072_49	2025-11-19	1263	\N	2648	8	261.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2053	LB_41_646_1072_50	2025-11-19	1263	\N	2648	9	261.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2054	LB_41_454_1072_51	2025-11-19	1263	\N	2521	7	49.176	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2055	LB_41_454_1072_52	2025-11-19	1263	\N	2521	7	1447.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2056	LB_41_454_1072_53	2025-11-19	1263	\N	2521	8	1447.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2057	LB_41_454_1072_54	2025-11-19	1263	\N	2521	9	1447.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2058	LB_41_204_1072_55	2025-11-19	1263	\N	2271	7	620.540	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2059	LB_41_204_1072_56	2025-11-19	1263	\N	2271	8	620.540	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2060	LB_41_204_1072_57	2025-11-19	1263	\N	2271	9	620.540	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2061	LB_41_90_1073_0	2025-11-19	1263	\N	2157	6	4.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2062	LB_41_90_1073_1	2025-11-19	1263	\N	2157	6	14.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2063	LB_41_90_1073_2	2025-11-19	1263	\N	2157	6	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2064	LB_42_1_1075_0	2025-11-26	1263	\N	2069	6	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2065	LB_42_985_1076_0	2025-11-26	1263	\N	3052	7	1284.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2066	LB_42_985_1076_1	2025-11-26	1263	\N	3052	8	1284.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2067	LB_42_985_1076_2	2025-11-26	1263	\N	3052	9	1284.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2068	LB_42_983_1076_3	2025-11-26	1263	\N	3050	7	1012.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2069	LB_42_983_1076_4	2025-11-26	1263	\N	3050	8	1012.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2070	LB_42_983_1076_5	2025-11-26	1263	\N	3050	9	1012.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2071	LB_42_984_1076_6	2025-11-26	1263	\N	3051	7	9.897	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2072	LB_42_984_1076_7	2025-11-26	1263	\N	3051	7	1088.670	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2073	LB_42_984_1076_8	2025-11-26	1263	\N	3051	8	1088.670	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2074	LB_42_984_1076_9	2025-11-26	1263	\N	3051	9	1088.670	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2075	LB_42_40_1076_10	2025-11-26	1263	\N	2108	7	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2076	LB_42_40_1076_11	2025-11-26	1263	\N	2108	8	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2077	LB_42_40_1076_12	2025-11-26	1263	\N	2108	9	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2078	LB_42_279_1076_13	2025-11-26	1263	\N	2346	7	0.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2079	LB_42_279_1076_14	2025-11-26	1263	\N	2346	8	0.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2080	LB_42_229_1076_15	2025-11-26	1263	\N	2296	7	0.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2081	LB_42_229_1076_16	2025-11-26	1263	\N	2296	8	0.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2082	LB_42_229_1076_17	2025-11-26	1263	\N	2296	9	0.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2083	LB_42_90_1077_0	2025-11-26	1263	\N	2157	6	6.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2084	LB_42_90_1077_1	2025-11-26	1263	\N	2157	6	2.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2085	LB_43_914_1086_0	2025-12-03	1263	\N	2980	7	0.470	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2086	LB_43_914_1086_1	2025-12-03	1263	\N	2980	8	0.470	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2087	LB_43_914_1086_2	2025-12-03	1263	\N	2980	9	0.470	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2088	LB_43_862_1087_0	2025-12-03	1263	\N	2929	7	1.462	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2089	LB_43_862_1087_1	2025-12-03	1263	\N	2929	7	1314.338	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2090	LB_43_862_1087_2	2025-12-03	1263	\N	2929	8	1314.338	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2091	LB_43_862_1087_3	2025-12-03	1263	\N	2929	9	1314.338	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2092	LB_43_245_1087_4	2025-12-03	1263	\N	2312	7	297.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2093	LB_43_245_1087_5	2025-12-03	1263	\N	2312	8	297.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2094	LB_43_245_1087_6	2025-12-03	1263	\N	2312	9	297.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2095	LB_43_986_1087_7	2025-12-03	1263	\N	3053	7	1075.104	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2096	LB_43_986_1087_8	2025-12-03	1263	\N	3053	8	1075.104	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2097	LB_43_986_1087_9	2025-12-03	1263	\N	3053	9	1075.104	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2098	LB_43_963_1087_10	2025-12-03	1263	\N	3030	7	1932.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2099	LB_43_963_1087_11	2025-12-03	1263	\N	3030	8	1932.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2100	LB_43_963_1087_12	2025-12-03	1263	\N	3030	9	1932.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2101	LB_43_287_1087_13	2025-12-03	1263	\N	2354	7	180.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2102	LB_43_287_1087_14	2025-12-03	1263	\N	2354	8	180.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2103	LB_43_287_1087_15	2025-12-03	1263	\N	2354	9	180.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2104	LB_43_963_1087_16	2025-12-03	1263	\N	3030	7	47.520	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2105	LB_44_90_1088_0	2025-12-10	1263	\N	2157	6	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2106	LB_44_90_1088_1	2025-12-10	1263	\N	2157	6	3.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2107	LB_44_90_1091_0	2025-12-10	1263	\N	2157	6	2.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2108	LB_44_988_1091_1	2025-12-10	1263	\N	3055	6	36.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2109	LB_45_486_1094_0	2025-12-10	1263	\N	2553	9	1840.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2110	LB_45_88_1094_1	2025-12-10	1263	\N	2155	7	1456.560	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2111	LB_45_88_1094_2	2025-12-10	1263	\N	2155	8	1456.560	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2112	LB_45_88_1094_3	2025-12-10	1263	\N	2155	9	1456.560	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2113	LB_45_987_1094_4	2025-12-10	1263	\N	3054	7	223.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2114	LB_45_987_1094_5	2025-12-10	1263	\N	3054	8	223.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2115	LB_45_987_1094_6	2025-12-10	1263	\N	3054	9	223.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2116	LB_45_974_1094_7	2025-12-10	1263	\N	3041	7	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2117	LB_45_974_1094_8	2025-12-10	1263	\N	3041	8	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2118	LB_45_974_1094_9	2025-12-10	1263	\N	3041	9	1212.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2119	LB_45_989_1094_10	2025-12-10	1263	\N	3056	7	142.335	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2120	LB_45_989_1094_11	2025-12-10	1263	\N	3056	8	142.335	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2121	LB_45_989_1094_12	2025-12-10	1263	\N	3056	9	142.335	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2122	LB_45_990_1094_13	2025-12-10	1263	\N	3057	7	125.568	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2123	LB_45_990_1094_14	2025-12-10	1263	\N	3057	8	125.568	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2124	LB_45_990_1094_15	2025-12-10	1263	\N	3057	9	125.568	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2125	LB_45_486_1094_16	2025-12-10	1263	\N	2553	7	1840.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2126	LB_45_486_1094_17	2025-12-10	1263	\N	2553	8	1840.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2127	LB_45_90_1095_0	2025-12-11	1263	\N	2157	6	8.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2128	LB_45_90_1095_1	2025-12-11	1263	\N	2157	6	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2129	LB_47_869_1099_0	2025-12-24	1263	\N	2936	6	42.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2130	LB_47_978_1099_1	2025-12-24	1263	\N	3045	6	20.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2131	LB_47_974_1100_0	2025-12-24	1263	\N	3041	7	8.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2132	LB_47_974_1100_1	2025-12-24	1263	\N	3041	7	1203.920	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2133	LB_47_974_1100_2	2025-12-24	1263	\N	3041	8	1203.920	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2134	LB_47_974_1100_3	2025-12-24	1263	\N	3041	9	1203.920	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2135	LB_47_869_1100_4	2025-12-24	1263	\N	2936	7	12.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2136	LB_47_90_1101_0	2025-12-24	1263	\N	2157	6	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2137	LB_47_90_1101_1	2025-12-24	1263	\N	2157	6	3.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2138	LB_49_88_1105_0	2026-01-07	1263	\N	2155	7	52.020	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2139	LB_49_88_1105_1	2026-01-07	1263	\N	2155	7	1959.420	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2140	LB_49_88_1105_2	2026-01-07	1263	\N	2155	8	1959.420	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2141	LB_49_88_1105_3	2026-01-07	1263	\N	2155	9	1959.420	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2142	LB_49_452_1105_4	2026-01-07	1263	\N	2519	7	58.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2143	LB_49_452_1105_5	2026-01-07	1263	\N	2519	7	1105.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2144	LB_49_452_1105_6	2026-01-07	1263	\N	2519	8	1105.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2145	LB_49_452_1105_7	2026-01-07	1263	\N	2519	9	1105.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2146	LB_49_394_1105_8	2026-01-07	1263	\N	2461	7	9.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2147	LB_49_394_1105_9	2026-01-07	1263	\N	2461	7	950.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2148	LB_49_394_1105_10	2026-01-07	1263	\N	2461	8	950.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2149	LB_49_394_1105_11	2026-01-07	1263	\N	2461	9	950.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2150	LB_49_990_1105_12	2026-01-07	1263	\N	3057	7	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2151	LB_49_990_1105_13	2026-01-07	1263	\N	3057	8	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2152	LB_49_990_1105_14	2026-01-07	1263	\N	3057	9	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2153	LB_49_909_1105_15	2026-01-07	1263	\N	2975	7	26.310	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2154	LB_49_909_1105_16	2026-01-07	1263	\N	2975	7	1578.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2155	LB_49_909_1105_17	2026-01-07	1263	\N	2975	8	1578.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2156	LB_49_909_1105_18	2026-01-07	1263	\N	2975	9	1578.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2157	LB_49_990_1105_19	2026-01-07	1263	\N	3057	7	31.392	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2158	LB_49_990_1105_20	2026-01-07	1263	\N	3057	7	1083.024	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2159	LB_49_990_1105_21	2026-01-07	1263	\N	3057	8	1083.024	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2160	LB_49_990_1105_22	2026-01-07	1263	\N	3057	9	1083.024	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2161	LB_50_90_1106_0	2026-01-07	1263	\N	2157	6	14.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2162	LB_50_90_1106_1	2026-01-07	1263	\N	2157	6	5.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2163	LB_53_90_1112_0	2026-01-28	1263	\N	2157	6	10.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2164	LB_53_90_1112_1	2026-01-28	1263	\N	2157	6	12.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2165	LB_53_90_1112_2	2026-01-28	1263	\N	2157	6	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2166	LB_54_138_1113_0	2026-02-04	1263	\N	2205	7	3.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2167	LB_54_138_1113_1	2026-02-04	1263	\N	2205	7	836.580	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2168	LB_54_138_1113_2	2026-02-04	1263	\N	2205	8	836.580	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2169	LB_54_138_1113_3	2026-02-04	1263	\N	2205	9	836.580	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2170	LB_54_146_1113_4	2026-02-04	1263	\N	2213	7	5.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2171	LB_54_146_1113_5	2026-02-04	1263	\N	2213	7	801.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2172	LB_54_146_1113_6	2026-02-04	1263	\N	2213	8	801.360	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2173	LB_54_172_1113_7	2026-02-04	1263	\N	2239	7	689.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2174	LB_54_172_1113_8	2026-02-04	1263	\N	2239	8	689.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2175	LB_54_172_1113_9	2026-02-04	1263	\N	2239	9	689.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2176	LB_54_184_1113_10	2026-02-04	1263	\N	2251	7	118.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2177	LB_54_184_1113_11	2026-02-04	1263	\N	2251	8	118.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2178	LB_54_184_1113_12	2026-02-04	1263	\N	2251	9	118.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2179	LB_54_194_1113_13	2026-02-04	1263	\N	2261	7	200.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2180	LB_54_194_1113_14	2026-02-04	1263	\N	2261	8	200.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2181	LB_54_948_1113_15	2026-02-04	1263	\N	3015	7	1701.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2182	LB_54_948_1113_16	2026-02-04	1263	\N	3015	8	1701.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2183	LB_54_948_1113_17	2026-02-04	1263	\N	3015	9	1701.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2184	LB_54_217_1113_18	2026-02-04	1263	\N	2284	7	271.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2185	LB_54_217_1113_19	2026-02-04	1263	\N	2284	8	271.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2186	LB_54_217_1113_20	2026-02-04	1263	\N	2284	9	271.040	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2187	LB_54_991_1113_21	2026-02-04	1263	\N	3058	7	44.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2188	LB_54_991_1113_22	2026-02-04	1263	\N	3058	8	44.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2189	LB_54_991_1113_23	2026-02-04	1263	\N	3058	9	44.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2190	LB_54_5_1113_24	2026-02-04	1263	\N	2073	7	978.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2191	LB_54_5_1113_25	2026-02-04	1263	\N	2073	8	978.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2192	LB_54_5_1113_26	2026-02-04	1263	\N	2073	9	978.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2193	LB_54_188_1113_27	2026-02-04	1263	\N	2255	7	11.685	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2194	LB_54_220_1113_28	2026-02-04	1263	\N	2287	7	22.590	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2195	LB_54_188_1113_29	2026-02-04	1263	\N	2255	7	408.975	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2196	LB_54_188_1113_30	2026-02-04	1263	\N	2255	8	408.975	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2197	LB_54_220_1113_31	2026-02-04	1263	\N	2287	7	687.740	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2198	LB_54_220_1113_32	2026-02-04	1263	\N	2287	8	687.740	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2199	LB_54_299_1113_33	2026-02-04	1263	\N	2366	7	11.814	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2200	LB_54_299_1113_34	2026-02-04	1263	\N	2366	7	1535.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2201	LB_54_299_1113_35	2026-02-04	1263	\N	2366	8	1535.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2202	LB_54_299_1113_36	2026-02-04	1263	\N	2366	9	1535.820	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2203	LB_54_948_1113_37	2026-02-04	1263	\N	3015	7	3.384	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2204	LB_54_948_1113_38	2026-02-04	1263	\N	3015	8	3.384	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2205	LB_54_948_1113_39	2026-02-04	1263	\N	3015	9	3.384	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2206	LB_54_213_1113_40	2026-02-04	1263	\N	2280	7	189.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2207	LB_54_213_1113_41	2026-02-04	1263	\N	2280	8	189.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2208	LB_54_213_1113_42	2026-02-04	1263	\N	2280	9	189.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2209	LB_54_990_1113_43	2026-02-04	1263	\N	3057	7	1098.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2210	LB_54_990_1113_44	2026-02-04	1263	\N	3057	8	1098.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2211	LB_54_990_1113_45	2026-02-04	1263	\N	3057	9	1098.720	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2212	LB_55_217_1114_0	2026-02-11	1263	\N	2284	7	36.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2213	LB_55_217_1114_1	2026-02-11	1263	\N	2284	8	36.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2214	LB_55_217_1114_2	2026-02-11	1263	\N	2284	9	36.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2215	LB_55_990_1114_3	2026-02-11	1263	\N	3057	7	408.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2216	LB_55_990_1114_4	2026-02-11	1263	\N	3057	8	408.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2217	LB_55_990_1114_5	2026-02-11	1263	\N	3057	9	408.096	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2218	LB_57_869_1117_0	2026-03-31	1263	\N	2936	7	15.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2219	LB_57_869_1117_1	2026-03-31	1263	\N	2936	8	15.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
2220	LB_57_869_1117_2	2026-03-31	1263	\N	2936	9	15.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:18.016436	2026-08-03 14:42:18.016436	[]	[]	\N
\.


--
-- Data for Name: salary_vouchers; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.salary_vouchers (id, voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, allowances, deductions, net_salary, narration, created_by, created_at, updated_at) FROM stdin;
11	SAL_1_146	2025-04-12	1875	4	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:18.896429	2026-08-03 14:42:18.896429
12	SAL_2_238	2025-04-18	1875	4	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:18.896429	2026-08-03 14:42:18.896429
13	SAL_3_485	2025-05-05	1875	5	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:18.896429	2026-08-03 14:42:18.896429
14	SAL_4_938	2025-05-15	1875	5	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:18.896429	2026-08-03 14:42:18.896429
15	SAL_5_939	2025-05-15	1875	5	2025	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:18.896429	2026-08-03 14:42:18.896429
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
853	435	1425	0.00	260.00	WATER CAN, MILK
854	435	1335	260.00	0.00	WATER CAN, MILK
855	427	1425	0.00	600.00	Eicher Oil
856	427	1492	600.00	0.00	Eicher Oil
857	428	1425	0.00	200.00	Tea
858	428	1316	200.00	0.00	Tea
859	429	1425	0.00	100.00	DINNER EXPENSE FOR WATCHMAN (SUNDAY DOUBLE DUTY)
860	438	1425	0.00	1925.00	LABOUR CHARGE DT FROM 29.03 TO 04.04
861	438	1664	1925.00	0.00	LABOUR CHARGE DT FROM 29.03 TO 04.04
862	439	1425	0.00	2275.00	LABOUR CHARGE FROM 29.03 TO  04.04
863	439	1680	2275.00	0.00	LABOUR CHARGE FROM 29.03 TO  04.04
864	440	1425	0.00	1560.00	LABOUR CHARGE  FROM 29.03 TO 04.04
865	440	1681	1560.00	0.00	LABOUR CHARGE  FROM 29.03 TO 04.04
866	441	1425	0.00	17496.00	CONTRACT LABOUR CHARGE  01.04 TO 4.4
867	441	1696	17496.00	0.00	CONTRACT LABOUR CHARGE  01.04 TO 4.4
868	442	1425	0.00	356.00	CONTRACTOR CHARGE FOR 29.03
869	442	1587	356.00	0.00	CONTRACTOR CHARGE FOR 29.03
870	443	1425	0.00	350.00	PAID FOR AUTO RENT TO TEXMO
871	443	1587	350.00	0.00	PAID FOR AUTO RENT TO TEXMO
872	444	1387	0.00	100.00	STAFF AUTO CHARGE
873	444	1283	100.00	0.00	STAFF AUTO CHARGE
874	446	1387	0.00	15000.00	AC PURCHASE 2TONE
875	446	1323	15000.00	0.00	AC PURCHASE 2TONE
876	445	1425	0.00	250.00	HINDI LOBOUR AUTO CHARGE
877	445	1283	250.00	0.00	HINDI LOBOUR AUTO CHARGE
878	447	1425	0.00	90.00	JUICE & MILK EXPENSES
879	447	1335	90.00	0.00	JUICE & MILK EXPENSES
880	456	1349	0.00	2700.00	
881	456	1365	2700.00	0.00	
882	457	1425	0.00	2700.00	PURCHASE OF 90 SET GLOUSE
883	457	1349	2700.00	0.00	PURCHASE OF 90 SET GLOUSE
884	455	1425	0.00	400.00	NIGHT SHIFT TIFFEN
885	455	1335	400.00	0.00	NIGHT SHIFT TIFFEN
886	454	1425	0.00	200.00	SHIVA KUMAR
887	454	1350	200.00	0.00	SHIVA KUMAR
888	458	1425	0.00	250.00	PAID FOR HINDHI LABOURS
889	458	1283	250.00	0.00	PAID FOR HINDHI LABOURS
890	459	1425	0.00	900.00	CASH PAID FOR LUNCH
891	459	1335	900.00	0.00	CASH PAID FOR LUNCH
892	460	1719	0.00	14000.00	
893	460	1323	14000.00	0.00	
894	461	1425	0.00	14400.00	PURCHASE OF 2 TONE A/C
895	461	1719	14400.00	0.00	PURCHASE OF 2 TONE A/C
896	462	1425	0.00	90.00	PURCHASE OF TEA AND JUICE
897	462	1335	90.00	0.00	PURCHASE OF TEA AND JUICE
898	463	1425	0.00	200.00	CASH PAID TP MARIMUTHU VECHILE
899	463	1350	200.00	0.00	CASH PAID TP MARIMUTHU VECHILE
900	464	1425	0.00	200.00	PAID FOR WATER CAN AND TEA
901	464	1335	200.00	0.00	PAID FOR WATER CAN AND TEA
902	465	1425	0.00	400.00	PAID FOR LUNCH IN TEXMO  LOADING LABOURS
903	465	1335	400.00	0.00	PAID FOR LUNCH IN TEXMO  LOADING LABOURS
904	466	1425	0.00	200.00	MARIMUTHU
905	466	1350	200.00	0.00	MARIMUTHU
906	467	1425	0.00	100.00	TAPE ROLL, TRIMMING
907	467	1301	100.00	0.00	TAPE ROLL, TRIMMING
908	477	1720	0.00	30000.00	
909	477	1323	30000.00	0.00	
910	478	1425	0.00	30000.00	PURCAHSE OF GRINDING BED
911	478	1720	30000.00	0.00	PURCAHSE OF GRINDING BED
912	475	1425	0.00	600.00	PURCHASE OF (G.BED)
913	475	1283	600.00	0.00	PURCHASE OF (G.BED)
914	474	1425	0.00	400.00	CAN WATER SANTHOSH 10 CAN
915	474	1335	400.00	0.00	CAN WATER SANTHOSH 10 CAN
916	429	1335	100.00	0.00	DINNER EXPENSE FOR WATCHMAN (SUNDAY DOUBLE DUTY)
917	430	1425	0.00	400.00	LUNCH FOR TEXMO LOADING LABOURS
918	430	1315	400.00	0.00	LUNCH FOR TEXMO LOADING LABOURS
919	431	1425	0.00	250.00	NIGHT DINNER
920	431	1335	250.00	0.00	NIGHT DINNER
921	432	1425	0.00	200.00	MARIMUTHU
922	432	1350	200.00	0.00	MARIMUTHU
923	433	1425	0.00	100.00	TAPE ROLL, TRIMMING PIN
924	433	1301	100.00	0.00	TAPE ROLL, TRIMMING PIN
925	434	1425	0.00	600.00	EICHER OIL
926	468	1425	0.00	250.00	DINNER (NIGHT SHIFT WORKERS)
927	468	1335	250.00	0.00	DINNER (NIGHT SHIFT WORKERS)
928	469	1425	0.00	600.00	VECHILES MAINTANCE
929	469	1492	600.00	0.00	VECHILES MAINTANCE
930	470	1425	0.00	200.00	CAN WATER
931	470	1335	200.00	0.00	CAN WATER
932	471	1425	0.00	100.00	PETROL
933	471	1350	100.00	0.00	PETROL
934	472	1425	0.00	100.00	SUGAR
935	472	1335	100.00	0.00	SUGAR
936	473	1425	0.00	350.00	POOJA EXPENSES
937	473	1369	350.00	0.00	POOJA EXPENSES
938	476	1425	0.00	390.00	PURCHASE OF LAKSHMI PAINT
939	476	1323	390.00	0.00	PURCHASE OF LAKSHMI PAINT
940	434	1492	600.00	0.00	EICHER OIL
941	436	1425	0.00	100.00	PAINT
942	436	1336	100.00	0.00	PAINT
943	437	1425	0.00	100.00	Print Out
944	437	1381	100.00	0.00	Print Out
945	479	1721	0.00	1309.00	
946	479	1323	1309.00	0.00	
947	480	1425	0.00	1309.00	PURCHASE ACCOUNT
948	480	1721	1309.00	0.00	PURCHASE ACCOUNT
949	481	1425	0.00	500.00	CASH PAID TO SURESH CHIPPING
950	481	1336	500.00	0.00	CASH PAID TO SURESH CHIPPING
951	482	1425	0.00	80.00	MILK
952	482	1335	80.00	0.00	MILK
953	483	1425	0.00	400.00	SANTHOSH WATER CAN
954	483	1335	400.00	0.00	SANTHOSH WATER CAN
955	484	1425	0.00	100.00	2 DAYS MILK
956	484	1335	100.00	0.00	2 DAYS MILK
957	485	1425	0.00	400.00	NIGHT SHIFT LABOUR DINNER
958	485	1335	400.00	0.00	NIGHT SHIFT LABOUR DINNER
959	486	1425	0.00	100.00	MARIMUTHU LUNCH
960	486	1335	100.00	0.00	MARIMUTHU LUNCH
961	487	1425	0.00	300.00	SUGAR , TEA CUP ,MATCH BOX, WATER GLASS,
962	487	1335	300.00	0.00	SUGAR , TEA CUP ,MATCH BOX, WATER GLASS,
963	488	1425	0.00	200.00	STICKY NOTE , NOTE
964	488	1381	200.00	0.00	STICKY NOTE , NOTE
965	489	1425	0.00	50.00	PURCHASE OF MILK
966	489	1335	50.00	0.00	PURCHASE OF MILK
967	490	1425	0.00	425.00	PURCHASE OF BATTERY, WHEEL,CORBON BRUSH
968	490	1336	425.00	0.00	PURCHASE OF BATTERY, WHEEL,CORBON BRUSH
969	491	1425	0.00	298.00	BOC FILE, CASH VOUCHER,STIC FILE,VOUCER BOOK
970	491	1381	298.00	0.00	BOC FILE, CASH VOUCHER,STIC FILE,VOUCER BOOK
971	492	1425	0.00	140.00	PURCHASES OF MILK, CUP,JUICE
972	492	1335	140.00	0.00	PURCHASES OF MILK, CUP,JUICE
973	448	1350	200.00	0.00	PETROL
974	493	1425	0.00	100.00	PAINT
975	493	1336	100.00	0.00	PAINT
976	494	1321	0.00	10078.00	
977	494	1323	10078.00	0.00	
978	495	1379	0.00	24898.00	
979	495	1323	24898.00	0.00	
980	496	1425	0.00	10078.00	PURCHASES OF 100 LTR OIL
981	496	1321	10078.00	0.00	PURCHASES OF 100 LTR OIL
982	497	1425	0.00	24898.00	PURCHASES OF 100 LTR PAINT
983	497	1379	24898.00	0.00	PURCHASES OF 100 LTR PAINT
984	498	1425	0.00	3953.00	WEEKLY SALARY
985	498	1696	3953.00	0.00	WEEKLY SALARY
986	499	1425	0.00	1846.00	WEEKLY SALARY
987	499	1681	1846.00	0.00	WEEKLY SALARY
988	500	1425	0.00	1500.00	SATHIM,USHAN,SAMIR SALARY
989	500	1696	1500.00	0.00	SATHIM,USHAN,SAMIR SALARY
990	501	1425	0.00	600.00	COMPRESSOR OIL PURCHASED
991	501	1323	600.00	0.00	COMPRESSOR OIL PURCHASED
992	502	1425	0.00	100.00	KOLA PODI, CHANI POWDER PURCHASE
993	502	1589	100.00	0.00	KOLA PODI, CHANI POWDER PURCHASE
994	503	1425	0.00	100.00	MILK PURCHASE(16-04-25 & 17-04-25)
995	503	1335	100.00	0.00	MILK PURCHASE(16-04-25 & 17-04-25)
996	504	1425	0.00	950.00	TURPEN OIL & PAINT TEMPO RENT
997	504	1283	950.00	0.00	TURPEN OIL & PAINT TEMPO RENT
998	505	1425	0.00	100.00	PURCHASE OF MILK & TEACUP
999	505	1335	100.00	0.00	PURCHASE OF MILK & TEACUP
1000	506	1425	0.00	1000.00	PAID FOR DISEAL
1001	506	1422	1000.00	0.00	PAID FOR DISEAL
1002	507	1425	0.00	1320.00	CHANGE OF OIL AND SENCOR
1003	507	1492	1320.00	0.00	CHANGE OF OIL AND SENCOR
1004	508	1425	0.00	500.00	PURCHASE OF STIKY NOTE SUGAR
1005	508	1323	500.00	0.00	PURCHASE OF STIKY NOTE SUGAR
1006	509	1425	0.00	204.00	PURCHASE OF FLOWER
1007	509	1369	204.00	0.00	PURCHASE OF FLOWER
1008	510	1425	0.00	100.00	PURCHASE OF SUGAR
1009	510	1335	100.00	0.00	PURCHASE OF SUGAR
1010	511	1425	0.00	200.00	WATER
1011	511	1335	200.00	0.00	WATER
1012	512	1425	0.00	100.00	FLOWER
1013	512	1369	100.00	0.00	FLOWER
1014	513	1425	0.00	400.00	PURCHASE OF ELLEN KEY
1015	513	1323	400.00	0.00	PURCHASE OF ELLEN KEY
1016	514	1425	0.00	950.00	TUBELIGHTS
1017	514	1323	950.00	0.00	TUBELIGHTS
1018	515	1425	0.00	1000.00	TATA
1019	515	1422	1000.00	0.00	TATA
1020	516	1425	0.00	30000.00	PURCHASE OF GRINDING BED
1021	516	1720	30000.00	0.00	PURCHASE OF GRINDING BED
1022	517	1425	0.00	3000.00	BED STAND
1023	517	1323	3000.00	0.00	BED STAND
1024	518	1425	0.00	600.00	PURCHASE OF GRINDING BED AUTO CHARGE
1025	518	1283	600.00	0.00	PURCHASE OF GRINDING BED AUTO CHARGE
1026	519	1425	0.00	300.00	AUTO CHARGE
1027	519	1283	300.00	0.00	AUTO CHARGE
1028	520	1425	0.00	400.00	AUTO CHARGE FOR AC PURCHASE
1029	520	1283	400.00	0.00	AUTO CHARGE FOR AC PURCHASE
1030	521	1425	0.00	250.00	AUTO RENT
1031	521	1283	250.00	0.00	AUTO RENT
1032	522	1425	0.00	15000.00	PURCHASE OF A/C
1033	522	1323	15000.00	0.00	PURCHASE OF A/C
1034	523	1425	0.00	90.00	TEA
1035	523	1335	90.00	0.00	TEA
1036	524	1425	0.00	100.00	CASH
1037	524	1283	100.00	0.00	CASH
1038	525	1425	0.00	100.00	CASH
1039	525	1350	100.00	0.00	CASH
1040	526	1425	0.00	400.00	LUNCH
1041	526	1335	400.00	0.00	LUNCH
1042	527	1425	0.00	2700.00	PURCHASE OF GLOUSE
1043	527	1349	2700.00	0.00	PURCHASE OF GLOUSE
1044	528	1425	0.00	1309.00	PURCHASE OF GLOUSE AND GLASS
1045	528	1721	1309.00	0.00	PURCHASE OF GLOUSE AND GLASS
1046	529	1727	0.00	400.00	
1047	529	1323	400.00	0.00	
1048	530	1425	0.00	400.00	PURCHASE OF 200  LITTERS
1049	530	1727	400.00	0.00	PURCHASE OF 200  LITTERS
1050	531	1425	0.00	500.00	PURCHASE OF  SUGAR TEA CUP
1051	531	1335	500.00	0.00	PURCHASE OF  SUGAR TEA CUP
1052	532	1425	0.00	50.00	MILK
1053	532	1335	50.00	0.00	MILK
1054	533	1721	0.00	485.00	
1055	533	1323	485.00	0.00	
1056	534	1425	0.00	485.00	PURCHASE OF 4" GRINDING WHEEL
1057	534	1721	485.00	0.00	PURCHASE OF 4" GRINDING WHEEL
1058	535	1425	0.00	268.00	PURCASHE OF BOX FILE AND VOUCHER
1059	535	1351	268.00	0.00	PURCASHE OF BOX FILE AND VOUCHER
1060	536	1425	0.00	268.00	PURCHASE OF PAPER
1061	536	1351	268.00	0.00	PURCHASE OF PAPER
1062	537	1425	0.00	100.00	TEA
1063	537	1335	100.00	0.00	TEA
1064	538	1425	0.00	40.00	TEA
1065	538	1335	40.00	0.00	TEA
1066	539	1425	0.00	600.00	PURCHASE OF COMPRESOR OIL
1067	539	1301	600.00	0.00	PURCHASE OF COMPRESOR OIL
1068	540	1425	0.00	200.00	TEA
1069	540	1335	200.00	0.00	TEA
1070	542	1425	0.00	10000.00	SAMYNATHAN
1071	542	1318	10000.00	0.00	SAMYNATHAN
1072	541	1425	0.00	50000.00	SAMYNATHAN
1073	541	1318	50000.00	0.00	SAMYNATHAN
1074	543	1425	0.00	1500.00	KANAKARAJ COMPRESSOR MAINTANCE
1075	543	1301	1500.00	0.00	KANAKARAJ COMPRESSOR MAINTANCE
1076	544	1425	0.00	750.00	RANGA RAJ COMPRESSOR MAINTANCE
1077	544	1301	750.00	0.00	RANGA RAJ COMPRESSOR MAINTANCE
1078	545	1728	0.00	4800.00	
1079	545	1323	4800.00	0.00	
1080	546	1425	0.00	4800.00	PURCHASE OF BLADE-2 CONTROL-1,IMPELLER-2
1081	546	1728	4800.00	0.00	PURCHASE OF BLADE-2 CONTROL-1,IMPELLER-2
1082	547	1425	0.00	1000.00	COMPRESSOR  FROM MAKESH COMPANY
1083	547	1283	1000.00	0.00	COMPRESSOR  FROM MAKESH COMPANY
1084	548	1425	0.00	1000.00	TATa
1085	548	1422	1000.00	0.00	TATa
1086	549	1425	0.00	1320.00	CHANGE OF SENCOR
1087	549	1492	1320.00	0.00	CHANGE OF SENCOR
1088	550	1729	0.00	15000.00	
1089	550	1323	15000.00	0.00	
1090	551	1425	0.00	15000.00	PURCHASE OF NEW HOISTER
1091	551	1729	15000.00	0.00	PURCHASE OF NEW HOISTER
1092	552	1727	0.00	400.00	
1093	552	1323	400.00	0.00	
1094	553	1721	0.00	500.00	
1095	553	1323	500.00	0.00	
1096	554	1425	0.00	400.00	PURCHASE OF 10 CAN
1097	554	1727	400.00	0.00	PURCHASE OF 10 CAN
1098	555	1425	0.00	500.00	GRINDING WHEEL
1099	555	1721	500.00	0.00	GRINDING WHEEL
1100	556	1425	0.00	200.00	FLOWER
1101	556	1369	200.00	0.00	FLOWER
1102	557	1321	0.00	9558.00	
1103	557	1323	9558.00	0.00	
1104	558	1425	0.00	9558.00	PURCHASE OF TURBON OIL 100 LITTER
1105	558	1321	9558.00	0.00	PURCHASE OF TURBON OIL 100 LITTER
1106	559	1425	0.00	10078.00	PURCHASE OF TURBON OIL
1107	559	1321	10078.00	0.00	PURCHASE OF TURBON OIL
1108	560	1425	0.00	24898.00	PURCHASE OF VASANTHI RED
1109	560	1379	24898.00	0.00	PURCHASE OF VASANTHI RED
1110	561	1323	0.00	12300.00	
1111	561	1323	12300.00	0.00	
1112	562	1425	0.00	12300.00	FAN
1113	562	1323	12300.00	0.00	FAN
1114	563	1730	0.00	12300.00	
1115	563	1323	12300.00	0.00	
1116	564	1425	0.00	12300.00	PURCHASE OF INDUSTRIAL FAN
1117	564	1730	12300.00	0.00	PURCHASE OF INDUSTRIAL FAN
1118	565	1425	0.00	250.00	PURCHASE OF BOLT NUT
1119	565	1301	250.00	0.00	PURCHASE OF BOLT NUT
1120	566	1425	0.00	150.00	TEA
1121	566	1335	150.00	0.00	TEA
1122	567	1425	0.00	250.00	PURCHASE OF TEA
1123	567	1335	250.00	0.00	PURCHASE OF TEA
1124	448	1425	0.00	200.00	PETROL
1125	453	1425	0.00	350.00	AUTO CHARGE
1126	453	1283	350.00	0.00	AUTO CHARGE
1127	568	1425	52672.00	0.00	BILL NO 1
1128	568	1263	0.00	52672.00	BILL NO 1
1129	569	1425	159753.00	0.00	BILL NO 2
1130	569	1263	0.00	159753.00	BILL NO 2
1131	571	1425	0.00	40.00	TEA
1132	571	1335	40.00	0.00	TEA
1133	572	1425	0.00	360.00	TEA
1134	572	1335	360.00	0.00	TEA
1135	574	1425	0.00	6120.00	PURCHASE OF TURBON OIL 60LITTERS
1136	574	1321	6120.00	0.00	PURCHASE OF TURBON OIL 60LITTERS
1137	575	1425	0.00	400.00	TEA
1138	575	1335	400.00	0.00	TEA
1139	576	1425	0.00	200.00	TEA
1140	576	1335	200.00	0.00	TEA
1141	577	1425	0.00	3500.00	COMPRESSOR
1142	577	1301	3500.00	0.00	COMPRESSOR
1143	578	1425	0.00	200.00	TEA
1144	578	1335	200.00	0.00	TEA
1145	579	1425	0.00	200.00	Plumbing Item
1146	579	1301	200.00	0.00	Plumbing Item
1147	580	1425	0.00	200.00	TEA
1148	580	1335	200.00	0.00	TEA
1149	581	1379	0.00	14940.00	
1150	581	1323	14940.00	0.00	
1151	582	1321	0.00	1935.00	
1152	582	1323	1935.00	0.00	
1153	583	1425	0.00	14940.00	PURCHASE OF 60 LITTERS
1154	583	1379	14940.00	0.00	PURCHASE OF 60 LITTERS
1155	584	1425	0.00	1935.00	PPURCHASE OF TURBON OIL
1156	584	1321	1935.00	0.00	PPURCHASE OF TURBON OIL
1157	585	1425	0.00	950.00	HINDI GRINDING FANESH
1158	585	1283	950.00	0.00	HINDI GRINDING FANESH
1159	586	1425	0.00	750.00	PURCHASE OF GP PAINR
1160	586	1283	750.00	0.00	PURCHASE OF GP PAINR
1161	587	1321	0.00	6132.00	
1162	587	1323	6132.00	0.00	
1163	588	1425	0.00	6132.00	60 LITTERS TURBON OIL
1164	588	1321	6132.00	0.00	60 LITTERS TURBON OIL
1165	589	1425	0.00	200.00	FLOWER
1166	589	1369	200.00	0.00	FLOWER
1167	590	1425	0.00	200.00	TEA
1168	590	1335	200.00	0.00	TEA
1169	591	1425	0.00	1000.00	TN38DL1948
1170	591	1422	1000.00	0.00	TN38DL1948
1171	592	1425	0.00	10000.00	COMPRESSOR
1172	592	1301	10000.00	0.00	COMPRESSOR
1173	593	1425	0.00	80.00	WELDDING OF BED PLATE
1174	593	1301	80.00	0.00	WELDDING OF BED PLATE
1175	594	1379	0.00	24898.00	
1176	594	1323	24898.00	0.00	
1177	595	1727	0.00	2000.00	
1178	595	1323	2000.00	0.00	
1179	596	1321	0.00	5952.00	
1180	596	1323	5952.00	0.00	
1181	597	1425	0.00	24898.00	PURCHASE OF 100 LTS OF GP PAING
1182	597	1379	24898.00	0.00	PURCHASE OF 100 LTS OF GP PAING
1183	598	1425	0.00	5952.00	PURCHASE OF 60 LITTERS TURBO OIL
1184	598	1321	5952.00	0.00	PURCHASE OF 60 LITTERS TURBO OIL
1185	599	1425	0.00	150.00	TEA
1186	599	1335	150.00	0.00	TEA
1187	600	1425	0.00	1160.00	Purchase Of Swith And Cut Wheel
1188	600	1301	1160.00	0.00	Purchase Of Swith And Cut Wheel
1189	601	1425	0.00	200.00	Flower
1190	601	1369	200.00	0.00	Flower
1191	602	1425	0.00	510.00	Purchase
1192	602	1369	510.00	0.00	Purchase
1193	603	1425	0.00	250000.00	Deposite Payment
1194	603	1263	250000.00	0.00	Deposite Payment
1195	604	1425	0.00	10000.00	COMPRESSOR AIRWA
1196	604	1301	10000.00	0.00	COMPRESSOR AIRWA
1197	605	1535	0.00	120.00	
1198	605	1323	120.00	0.00	
1199	606	1425	0.00	120.00	CASH
1200	606	1535	120.00	0.00	CASH
1201	607	1425	0.00	200.00	CASH
1202	607	1335	200.00	0.00	CASH
1203	608	1425	0.00	300.00	TEA AND BISCU
1204	608	1335	300.00	0.00	TEA AND BISCU
1205	609	1425	0.00	200.00	LEMON
1206	609	1369	200.00	0.00	LEMON
1207	610	1425	0.00	200.00	TEA
1208	610	1335	200.00	0.00	TEA
1209	611	1425	0.00	150.00	TEA
1210	611	1335	150.00	0.00	TEA
1211	612	1425	0.00	1010.00	TURBONOIL 10 LITTER
1212	612	1323	1010.00	0.00	TURBONOIL 10 LITTER
1213	613	1425	0.00	90.00	TEA
1214	613	1335	90.00	0.00	TEA
1215	614	1425	0.00	50.00	TEA
1216	614	1335	50.00	0.00	TEA
1217	615	1425	0.00	100.00	TEA
1218	615	1335	100.00	0.00	TEA
1219	616	1425	0.00	420.00	LUNCH
1220	616	1335	420.00	0.00	LUNCH
1221	617	1425	0.00	60.00	TEA
1222	617	1335	60.00	0.00	TEA
1223	618	1425	0.00	100.00	Tea
1224	618	1335	100.00	0.00	Tea
1225	619	1395	0.00	25000.00	
1226	619	1323	25000.00	0.00	
1227	620	1425	0.00	25000.00	COMPRESSOR 7.5 HP
1228	620	1395	25000.00	0.00	COMPRESSOR 7.5 HP
1229	621	1425	0.00	3000.00	COMPRESSOR TRANSFER  DINDUGAL
1230	621	1283	3000.00	0.00	COMPRESSOR TRANSFER  DINDUGAL
1231	622	1425	0.00	1500.00	CASH PAID
1232	622	1727	1500.00	0.00	CASH PAID
1233	624	1425	0.00	24898.00	PURCHASE OF 100 LTS
1234	624	1379	24898.00	0.00	PURCHASE OF 100 LTS
1235	623	1379	0.00	24898.00	
1236	623	1323	24898.00	0.00	
1237	625	1321	0.00	6120.00	
1238	625	1323	6120.00	0.00	
1239	573	1321	0.00	6120.00	
1240	573	1323	6120.00	0.00	
1241	626	1425	0.00	14000.00	
1242	626	1719	14000.00	0.00	
1243	449	1425	0.00	200.00	TEA
1244	449	1335	200.00	0.00	TEA
1245	450	1425	0.00	200.00	MARIMUTHU
1246	450	1350	200.00	0.00	MARIMUTHU
1247	451	1425	0.00	160.00	TEA
1248	451	1335	160.00	0.00	TEA
1249	452	1425	0.00	300.00	TEA
1250	452	1335	300.00	0.00	TEA
1251	570	1425	0.00	300.00	TEA
1252	570	1335	300.00	0.00	TEA
1253	627	1727	0.00	400.00	
1254	627	1323	400.00	0.00	
1255	628	1321	0.00	5703.00	
1256	628	1323	5703.00	0.00	
1257	629	1379	0.00	14988.00	
1258	629	1323	14988.00	0.00	
1259	630	1425	0.00	5703.00	PURCASE OF 60 LITTERS
1260	630	1321	5703.00	0.00	PURCASE OF 60 LITTERS
1261	631	1425	0.00	14988.00	PURCHASE OF  60 LITTERS
1262	631	1379	14988.00	0.00	PURCHASE OF  60 LITTERS
1263	632	1425	0.00	1310.00	COMPRESSOR SPARE PURCASE GPAY
1264	632	1301	1310.00	0.00	COMPRESSOR SPARE PURCASE GPAY
1265	633	1425	0.00	300.00	TEA
1266	633	1335	300.00	0.00	TEA
1267	634	1425	0.00	2000.00	RANGARAJ
1268	634	1284	2000.00	0.00	RANGARAJ
1269	635	1721	0.00	1065.00	
1270	635	1323	1065.00	0.00	
1271	636	1425	0.00	1065.00	CAS
1272	636	1721	1065.00	0.00	CAS
1273	637	1425	0.00	265.00	TEA SUGAR AND CUP
1274	637	1335	265.00	0.00	TEA SUGAR AND CUP
1275	638	1425	0.00	50.00	PURCHASE OF WATER
1276	638	1335	50.00	0.00	PURCHASE OF WATER
1277	639	1425	0.00	460.00	CASH
1278	639	1369	460.00	0.00	CASH
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2025_2026; Owner: orbx
--

COPY fy_2025_2026.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
435	PAY_9_17	Payment	2025-04-03	1425	260.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
427	PAY_1_1	Payment	2025-04-01	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
428	PAY_2_2	Payment	2025-04-01	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
438	PAY_12_27	Payment	2025-04-05	1425	1925.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
439	PAY_13_28	Payment	2025-04-05	1425	2275.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
440	PAY_14_29	Payment	2025-04-05	1425	1560.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
441	PAY_15_30	Payment	2025-04-05	1425	17496.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
442	PAY_16_34	Payment	2025-04-05	1425	356.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
443	PAY_17_35	Payment	2025-04-05	1425	350.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
444	PAY_18_47	Payment	2025-04-09	1387	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
446	PAY_20_49	Payment	2025-04-09	1387	15000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
445	PAY_19_48	Payment	2025-04-09	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
447	PAY_21_61	Payment	2025-04-09	1425	90.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
456	PUR_1_76	Purchase	2025-04-11	1349	2700.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
457	PAY_24_77	Payment	2025-04-10	1425	2700.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
455	PAY_23_75	Payment	2025-04-10	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
454	PAY_22_74	Payment	2025-04-10	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
458	PAY_25_78	Payment	2025-04-09	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
459	PAY_26_79	Payment	2025-04-09	1425	900.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
460	PUR_2_80	Purchase	2025-04-09	1719	14000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
461	PAY_27_81	Payment	2025-04-09	1425	14400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
462	PAY_28_82	Payment	2025-04-09	1425	90.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
463	PAY_29_83	Payment	2025-04-01	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
464	PAY_30_84	Payment	2025-04-01	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
465	PAY_31_85	Payment	2025-04-01	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
466	PAY_32_86	Payment	2025-04-02	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
467	PAY_33_87	Payment	2025-04-02	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
477	PUR_3_103	Purchase	2025-04-07	1720	30000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
478	PAY_43_104	Payment	2025-04-07	1425	30000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
475	PAY_41_101	Payment	2025-04-07	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
474	PAY_40_100	Payment	2025-04-07	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
429	PAY_3_3	Payment	2025-04-01	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
430	PAY_4_4	Payment	2025-04-01	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
431	PAY_5_5	Payment	2025-04-02	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
432	PAY_6_6	Payment	2025-04-02	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
433	PAY_7_10	Payment	2025-04-02	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
468	PAY_34_88	Payment	2025-04-11	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
469	PAY_35_89	Payment	2025-04-11	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
470	PAY_36_91	Payment	2025-04-04	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
471	PAY_37_92	Payment	2025-04-04	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
472	PAY_38_93	Payment	2025-04-04	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
473	PAY_39_94	Payment	2025-04-04	1425	350.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
476	PAY_42_102	Payment	2025-04-07	1425	390.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
434	PAY_8_11	Payment	2025-04-02	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
436	PAY_10_18	Payment	2025-04-03	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
437	PAY_11_23	Payment	2025-04-03	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
479	PUR_4_105	Purchase	2025-04-11	1721	1309.00	SGST 99.81 CGST 99.81		\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
480	PAY_44_106	Payment	2025-04-11	1425	1309.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
481	PAY_45_108	Payment	2025-04-11	1425	500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
482	PAY_46_112	Payment	2025-04-11	1425	80.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
483	PAY_47_134	Payment	2025-04-12	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
484	PAY_48_135	Payment	2025-04-12	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
485	PAY_49_136	Payment	2025-04-12	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
486	PAY_50_141	Payment	2025-04-12	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
487	PAY_51_142	Payment	2025-04-12	1425	300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
488	PAY_52_143	Payment	2025-04-12	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
489	PAY_53_147	Payment	2025-04-15	1425	50.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
490	PAY_54_148	Payment	2025-04-15	1425	425.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
491	PAY_55_149	Payment	2025-04-15	1425	298.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
492	PAY_56_150	Payment	2025-04-15	1425	140.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
493	PAY_57_163	Payment	2025-04-15	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
494	PUR_5_164	Purchase	2025-04-16	1321	10078.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
495	PUR_6_165	Purchase	2025-04-16	1379	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
496	PAY_58_166	Payment	2025-04-16	1425	10078.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
497	PAY_59_167	Payment	2025-04-16	1425	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
498	PAY_60_168	Payment	2025-04-12	1425	3953.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
499	PAY_61_169	Payment	2025-04-12	1425	1846.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
500	PAY_62_170	Payment	2025-04-12	1425	1500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
501	PAY_63_181	Payment	2025-04-16	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
502	PAY_64_182	Payment	2025-04-16	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
503	PAY_65_183	Payment	2025-04-16	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
504	PAY_66_184	Payment	2025-04-16	1425	950.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
505	PAY_67_207	Payment	2025-04-16	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
506	PAY_68_242	Payment	2025-04-19	1425	1000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
507	PAY_69_243	Payment	2025-04-19	1425	1320.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
508	PAY_70_271	Payment	2025-04-12	1425	500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
509	PAY_1_294	Payment	2025-04-01	1425	204.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
510	PAY_2_295	Payment	2025-04-01	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
511	PAY_3_296	Payment	2025-04-01	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
512	PAY_4_297	Payment	2025-04-02	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
513	PAY_5_298	Payment	2025-04-05	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
514	PAY_6_299	Payment	2025-04-05	1425	950.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
515	PAY_7_300	Payment	2025-04-05	1425	1000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
516	PAY_8_301	Payment	2025-04-06	1425	30000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
517	PAY_9_302	Payment	2025-04-07	1425	3000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
518	PAY_10_303	Payment	2025-04-07	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
519	PAY_11_304	Payment	2025-04-08	1425	300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
520	PAY_12_305	Payment	2025-04-08	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
521	PAY_13_306	Payment	2025-04-09	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
522	PAY_14_307	Payment	2025-04-09	1425	15000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
523	PAY_15_308	Payment	2025-04-09	1425	90.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
524	PAY_16_309	Payment	2025-04-10	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
525	PAY_17_310	Payment	2025-04-10	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
526	PAY_18_311	Payment	2025-04-10	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
527	PAY_19_312	Payment	2025-04-10	1425	2700.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
528	PAY_20_313	Payment	2025-04-11	1425	1309.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
529	PUR_7_314	Purchase	2025-04-12	1727	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
530	PAY_21_315	Payment	2025-04-12	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
531	PAY_22_316	Payment	2025-04-12	1425	500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
532	PAY_23_317	Payment	2025-04-15	1425	50.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
533	PUR_8_318	Purchase	2025-04-12	1721	485.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
534	PAY_24_319	Payment	2025-04-15	1425	485.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
535	PAY_25_320	Payment	2025-04-15	1425	268.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
536	PAY_26_321	Payment	2025-04-15	1425	268.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
537	PAY_27_322	Payment	2025-04-15	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
538	PAY_28_323	Payment	2025-04-15	1425	40.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
539	PAY_29_324	Payment	2025-04-16	1425	600.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
540	PAY_30_325	Payment	2025-04-16	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
542	PAY_32_327	Payment	2025-04-16	1425	10000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
541	PAY_31_326	Payment	2025-04-16	1425	50000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
543	PAY_33_328	Payment	2025-04-18	1425	1500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
544	PAY_34_329	Payment	2025-04-18	1425	750.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
545	PUR_9_330	Purchase	2025-04-18	1728	4800.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
546	PAY_35_331	Payment	2025-04-18	1425	4800.00	BLADE-400 RS, CONTROL CAGE-600, IMPELLER- 500		\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
547	PAY_36_332	Payment	2025-04-18	1425	1000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
548	PAY_37_333	Payment	2025-04-19	1425	1000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
549	PAY_38_334	Payment	2025-04-19	1425	1320.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
550	PUR_10_335	Purchase	2025-04-19	1729	15000.00	PURCHASE OF NEW HOISTER		\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
551	PAY_39_336	Payment	2025-04-21	1425	15000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
552	PUR_11_337	Purchase	2025-04-22	1727	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
553	PUR_12_338	Purchase	2025-04-22	1721	500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
554	PAY_40_339	Payment	2025-04-22	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
555	PAY_41_340	Payment	2025-04-22	1425	500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
556	PAY_42_341	Payment	2025-04-23	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
557	PUR_13_342	Purchase	2025-04-23	1321	9558.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
558	PAY_43_343	Payment	2025-04-23	1425	9558.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
559	PAY_44_344	Payment	2025-04-16	1425	10078.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
560	PAY_45_345	Payment	2025-04-16	1425	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
561	PUR_14_346	Purchase	2025-04-23	1323	12300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
562	PAY_46_347	Payment	2025-04-23	1425	12300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
563	PUR_14_348	Purchase	2025-04-23	1730	12300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
564	PAY_46_349	Payment	2025-04-23	1425	12300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
565	PAY_47_350	Payment	2025-04-25	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
566	PAY_48_351	Payment	2025-04-25	1425	150.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
567	PAY_49_352	Payment	2025-04-25	1425	250.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
448	PAY_50_353	Payment	2025-04-25	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
453	PAY_55_382	Payment	2025-04-05	1425	350.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
568	REC_1_602	Receipt	2025-04-16	1425	52672.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
569	REC_2_603	Receipt	2025-04-23	1425	159753.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
571	PAY_56_749	Payment	2025-04-29	1425	40.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
572	PAY_57_750	Payment	2025-04-30	1425	360.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
574	PAY_58_752	Payment	2025-05-02	1425	6120.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
575	PAY_59_753	Payment	2025-05-02	1425	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
576	PAY_60_754	Payment	2025-05-02	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
577	PAY_61_755	Payment	2025-05-02	1425	3500.00	RANGARAJ		\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
578	PAY_62_756	Payment	2025-05-03	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
579	PAY_63_757	Payment	2025-05-03	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
580	PAY_64_758	Payment	2025-05-05	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
581	PUR_16_759	Purchase	2025-05-05	1379	14940.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
582	PUR_17_760	Purchase	2025-05-05	1321	1935.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
583	PAY_65_761	Payment	2025-05-05	1425	14940.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
584	PAY_66_762	Payment	2025-05-05	1425	1935.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
585	PAY_67_763	Payment	2025-05-05	1425	950.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
586	PAY_68_764	Payment	2025-05-05	1425	750.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
587	PUR_18_765	Purchase	2025-05-07	1321	6132.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
588	PAY_69_766	Payment	2025-05-06	1425	6132.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
589	PAY_70_767	Payment	2025-05-07	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
590	PAY_71_768	Payment	2025-05-07	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
591	PAY_72_769	Payment	2025-05-07	1425	1000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
592	PAY_73_770	Payment	2025-05-07	1425	10000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
593	PAY_74_771	Payment	2025-05-07	1425	80.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
594	PUR_19_774	Purchase	2025-05-08	1379	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
595	PUR_20_775	Purchase	2025-05-08	1727	2000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
596	PUR_21_776	Purchase	2025-05-08	1321	5952.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
597	PAY_75_777	Payment	2025-05-08	1425	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
598	PAY_76_778	Payment	2025-05-08	1425	5952.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
599	PAY_77_779	Payment	2025-05-08	1425	150.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
600	PAY_78_797	Payment	2025-05-09	1425	1160.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
601	PAY_79_798	Payment	2025-05-09	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
602	PAY_80_799	Payment	2025-05-09	1425	510.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
603	PAY_81_800	Payment	2025-05-09	1425	250000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
604	PAY_82_801	Payment	2025-05-09	1425	10000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
605	PUR_22_816	Purchase	2025-05-09	1535	120.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
606	PAY_83_817	Payment	2025-05-09	1425	120.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
607	PAY_84_818	Payment	2025-05-09	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
608	PAY_85_823	Payment	2025-05-09	1425	300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
609	PAY_86_824	Payment	2025-05-09	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
610	PAY_87_865	Payment	2025-05-10	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
611	PAY_88_879	Payment	2025-05-09	1425	150.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
612	PAY_89_880	Payment	2025-05-10	1425	1010.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
613	PAY_90_883	Payment	2025-05-14	1425	90.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
614	PAY_91_888	Payment	2025-05-12	1425	50.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
615	PAY_92_892	Payment	2025-05-13	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
616	PAY_93_893	Payment	2025-05-13	1425	420.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
617	PAY_93_901	Payment	2025-05-13	1425	60.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
618	PAY_94_902	Payment	2025-05-13	1425	100.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
619	PUR_23_909	Purchase	2025-05-13	1395	25000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
620	PAY_95_910	Payment	2025-05-13	1425	25000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
621	PAY_96_911	Payment	2025-05-13	1425	3000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
622	PAY_97_922	Payment	2025-05-08	1425	1500.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
624	PAY_98_924	Payment	2025-04-24	1425	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
623	PUR_24_923	Purchase	2025-04-24	1379	24898.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
625	PUR_25_925	Purchase	2025-05-02	1321	6120.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
573	PUR_15_751	Purchase	2025-04-30	1321	6120.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
626	PAY_99_926	Payment	2025-05-01	1425	14000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
449	PAY_51_354	Payment	2025-04-27	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
450	PAY_52_355	Payment	2025-04-27	1425	200.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
451	PAY_53_356	Payment	2025-04-28	1425	160.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
452	PAY_54_357	Payment	2025-04-28	1425	300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
570	PAY_55_748	Payment	2025-04-29	1425	300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
627	PUR_26_935	Purchase	2025-05-12	1727	400.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
628	PUR_27_941	Purchase	2025-05-15	1321	5703.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
629	PUR_28_942	Purchase	2025-05-15	1379	14988.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
630	PAY_100_943	Payment	2025-05-15	1425	5703.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
631	PAY_101_944	Payment	2025-05-15	1425	14988.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
632	PAY_102_945	Payment	2025-05-15	1425	1310.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
633	PAY_103_946	Payment	2025-05-15	1425	300.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
634	PAY_104_947	Payment	2025-05-15	1425	2000.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
635	PUR_29_957	Purchase	2025-05-15	1721	1065.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
636	PAY_105_958	Payment	2025-05-15	1425	1065.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
637	PAY_106_959	Payment	2025-05-16	1425	265.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
638	PAY_107_962	Payment	2025-05-16	1425	50.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
639	PAY_108_973	Payment	2025-05-16	1425	460.00			\N	2026-08-03 14:42:12.843041	2026-08-03 14:42:12.843041
\.


--
-- Data for Name: advance_payments; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.advance_payments (id, voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by, created_at, updated_at) FROM stdin;
685	ADV_1_2	2026-04-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
686	ADV_15_35	2026-04-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
687	ADV_15_39	2026-04-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
688	ADV_16_40	2026-04-02	1742	Payment	Contractor	0.00	1000 Rs For Train And 1500 For Food	\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
689	ADV_17_42	2026-04-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
690	ADV_17_43	2026-04-02	1742	Payment	Contractor	0.00	GPAY TO MARKET TO JITHENDAR NUMBER	\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
691	ADV_18_44	2026-04-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
692	ADV_19_45	2026-04-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
693	ADV_20_51	2026-04-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
694	ADV_21_52	2026-04-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
695	ADV_22_68	2026-04-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
696	ADV_23_69	2026-04-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
697	ADV_194_744	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
698	ADV_195_754	2026-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
699	ADV_196_755	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
700	ADV_198_757	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
701	ADV_199_758	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
702	ADV_200_759	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
703	ADV_201_760	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
704	ADV_202_761	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
705	ADV_203_762	2026-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
706	ADV_204_763	2026-05-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
707	ADV_205_776	2026-05-07	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
708	ADV_368_1430	2026-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
709	ADV_369_1431	2026-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
710	ADV_370_1432	2026-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
711	ADV_371_1433	2026-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
712	ADV_372_1434	2026-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
713	ADV_373_1435	2026-06-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
714	ADV_374_1436	2026-06-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
715	ADV_375_1437	2026-06-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
716	ADV_376_1438	2026-06-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
717	ADV_377_1439	2026-06-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
718	ADV_378_1440	2026-06-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
719	ADV_379_1441	2026-06-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
720	ADV_380_1442	2026-06-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
721	ADV_381_1443	2026-06-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
722	ADV_382_1444	2026-06-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
723	ADV_383_1445	2026-06-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
724	ADV_384_1446	2026-06-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
725	ADV_385_1447	2026-06-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
726	ADV_386_1448	2026-06-04	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
727	ADV_387_1449	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
728	ADV_388_1450	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
729	ADV_389_1451	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
730	ADV_390_1452	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
731	ADV_391_1453	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
732	ADV_392_1454	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
733	ADV_393_1455	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
734	ADV_394_1456	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
735	ADV_395_1457	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
736	ADV_396_1458	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
737	ADV_397_1459	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
738	ADV_398_1460	2026-06-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
739	ADV_25_78	2026-04-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
740	ADV_27_86	2026-04-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
741	ADV_28_87	2026-04-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
742	ADV_29_90	2026-04-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
743	ADV_50_162	2026-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
744	ADV_51_163	2026-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
745	ADV_52_165	2026-04-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
746	ADV_53_167	2026-04-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
747	ADV_54_168	2026-04-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
748	ADV_56_171	2026-04-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
749	ADV_59_174	2026-04-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
750	ADV_60_175	2026-04-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
751	ADV_61_179	2026-04-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
752	ADV_70_221	2026-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
753	ADV_74_231	2026-04-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
754	ADV_82_239	2026-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
755	ADV_83_240	2026-04-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
756	ADV_94_254	2026-04-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
757	ADV_96_263	2026-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
758	ADV_98_270	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
759	ADV_99_271	2026-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
760	ADV_104_313	2026-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
761	ADV_107_317	2026-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
762	ADV_110_321	2026-04-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
763	ADV_111_322	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
764	ADV_115_326	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
765	ADV_116_327	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
766	ADV_117_328	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
767	ADV_118_329	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
768	ADV_120_331	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
769	ADV_121_332	2026-04-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
770	ADV_122_333	2026-04-19	1742	Payment	Contractor	0.00	PAID TO VINOTH SALARY ADVANCE	\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
771	ADV_123_334	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
772	ADV_124_335	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
773	ADV_125_336	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
774	ADV_126_337	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
775	ADV_127_338	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
776	ADV_128_339	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
777	ADV_129_340	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
778	ADV_130_341	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
779	ADV_131_342	2026-04-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
780	ADV_1_357	2026-04-22	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
781	ADV_1_390	2026-04-24	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
782	ADV_1_412	2026-04-24	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
783	ADV_2_413	2026-04-24	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
784	ADV_3_414	2026-04-24	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
785	ADV_4_415	2026-04-24	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
786	ADV_134_416	2026-04-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
787	ADV_135_417	2026-04-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
788	ADV_7_441	2026-04-25	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
789	ADV_139_454	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
790	ADV_8_458	2026-04-25	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
791	ADV_9_465	2026-04-04	1742	Receipt	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
792	ADV_140_470	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
793	ADV_141_495	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
794	ADV_142_496	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
795	ADV_143_497	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
796	ADV_144_498	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
797	ADV_145_499	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
798	ADV_146_500	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
799	ADV_147_504	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
800	ADV_148_505	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
801	ADV_150_527	2026-04-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
802	ADV_151_555	2026-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
803	ADV_152_584	2026-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
804	ADV_153_585	2026-04-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
805	ADV_159_591	2026-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
806	ADV_167_601	2026-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
807	ADV_176_638	2026-04-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
808	ADV_180_663	2026-04-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
809	ADV_182_697	2026-05-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
810	ADV_193_708	2026-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
811	ADV_206_802	2026-05-05	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
812	ADV_207_803	2026-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
813	ADV_208_804	2026-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
814	ADV_209_805	2026-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
815	ADV_210_806	2026-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
816	ADV_211_807	2026-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
817	ADV_212_808	2026-05-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
818	ADV_214_858	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
819	ADV_215_859	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
820	ADV_216_860	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
821	ADV_217_861	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
822	ADV_218_862	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
823	ADV_219_863	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
824	ADV_220_864	2026-05-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
825	ADV_221_865	2026-05-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
826	ADV_222_866	2026-05-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
827	ADV_223_917	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
828	ADV_224_918	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
829	ADV_225_919	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
830	ADV_226_920	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
831	ADV_227_921	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
832	ADV_228_922	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
833	ADV_229_923	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
834	ADV_230_924	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
835	ADV_231_925	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
836	ADV_232_942	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
837	ADV_233_943	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
838	ADV_234_944	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
839	ADV_235_945	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
840	ADV_236_946	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
841	ADV_237_947	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
842	ADV_238_948	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
843	ADV_239_949	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
844	ADV_240_950	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
845	ADV_242_987	2026-05-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
846	ADV_243_1040	2026-05-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
847	ADV_244_1041	2026-05-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
848	ADV_246_1054	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
849	ADV_247_1055	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
850	ADV_248_1056	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
851	ADV_249_1057	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
852	ADV_250_1058	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
853	ADV_251_1059	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
854	ADV_252_1060	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
855	ADV_253_1061	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
856	ADV_254_1062	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
857	ADV_255_1063	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
858	ADV_256_1064	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
859	ADV_257_1065	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
860	ADV_258_1066	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
861	ADV_259_1067	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
862	ADV_260_1068	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
863	ADV_261_1069	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
864	ADV_262_1070	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
865	ADV_263_1071	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
866	ADV_264_1072	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
867	ADV_265_1073	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
868	ADV_266_1074	2026-05-13	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
869	ADV_267_1075	2026-05-14	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
870	ADV_268_1076	2026-05-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
871	ADV_269_1077	2026-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
872	ADV_270_1078	2026-05-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
873	ADV_271_1079	2026-05-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
874	ADV_272_1080	2026-05-20	1742	Payment	Contractor	0.00	KAVITHAA  DROP  100	\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
875	ADV_273_1081	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
876	ADV_274_1083	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
877	ADV_275_1084	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
878	ADV_276_1088	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
879	ADV_277_1089	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
880	ADV_278_1090	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
881	ADV_279_1091	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
882	ADV_280_1092	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
883	ADV_281_1093	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
884	ADV_282_1094	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
885	ADV_283_1095	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
886	ADV_284_1096	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
887	ADV_285_1097	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
888	ADV_286_1134	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
889	ADV_287_1135	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
890	ADV_288_1136	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
891	ADV_289_1137	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
892	ADV_290_1138	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
893	ADV_291_1139	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
894	ADV_292_1140	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
895	ADV_293_1141	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
896	ADV_294_1142	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
897	ADV_295_1143	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
898	ADV_296_1144	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
899	ADV_297_1145	2026-05-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
900	ADV_298_1146	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
901	ADV_299_1163	2026-05-22	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
902	ADV_300_1171	2026-05-21	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
903	ADV_301_1209	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
904	ADV_302_1210	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
905	ADV_303_1211	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
906	ADV_304_1212	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
907	ADV_305_1213	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
908	ADV_306_1214	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
909	ADV_307_1215	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
910	ADV_308_1216	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
911	ADV_309_1217	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
912	ADV_310_1218	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
913	ADV_311_1219	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
914	ADV_312_1220	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
915	ADV_313_1221	2026-05-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
916	ADV_314_1222	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
917	ADV_315_1223	2026-05-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
918	ADV_316_1224	2026-05-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
919	ADV_317_1225	2026-05-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
920	ADV_318_1226	2026-05-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
921	ADV_319_1227	2026-05-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
922	ADV_320_1228	2026-05-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
923	ADV_321_1229	2026-05-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
924	ADV_322_1230	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
925	ADV_323_1231	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
926	ADV_324_1232	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
927	ADV_325_1233	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
928	ADV_326_1234	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
929	ADV_327_1235	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
930	ADV_328_1236	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
931	ADV_329_1237	2026-05-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
932	ADV_330_1238	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
933	ADV_331_1262	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
934	ADV_332_1263	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
935	ADV_333_1264	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
936	ADV_335_1266	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
937	ADV_336_1267	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
938	ADV_337_1268	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
939	ADV_338_1269	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
940	ADV_339_1270	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
941	ADV_340_1273	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
942	ADV_341_1274	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
943	ADV_342_1275	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
944	ADV_343_1276	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
945	ADV_344_1277	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
946	ADV_345_1278	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
947	ADV_346_1279	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
948	ADV_347_1280	2026-05-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
949	ADV_348_1294	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
950	ADV_349_1295	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
951	ADV_350_1296	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
952	ADV_351_1297	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
953	ADV_352_1298	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
954	ADV_353_1299	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
955	ADV_354_1300	2026-05-28	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
956	ADV_355_1306	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
957	ADV_356_1307	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
958	ADV_357_1308	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
959	ADV_358_1309	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
960	ADV_359_1310	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
961	ADV_360_1324	2026-05-27	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
962	ADV_361_1327	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
963	ADV_362_1331	2026-05-29	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
964	ADV_366_1405	2026-05-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
965	ADV_367_1406	2026-05-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
966	ADV_399_1473	2026-06-30	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
967	ADV_400_1477	2026-06-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
968	ADV_401_1482	2026-06-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
969	ADV_402_1580	2026-06-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
970	ADV_403_1581	2026-06-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
971	ADV_404_1582	2026-06-06	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
972	ADV_405_1583	2026-06-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
973	ADV_406_1584	2026-06-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
974	ADV_407_1585	2026-06-08	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
975	ADV_408_1586	2026-06-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
976	ADV_409_1587	2026-06-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
977	ADV_410_1588	2026-06-09	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
978	ADV_411_1589	2026-06-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
979	ADV_412_1590	2026-06-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
980	ADV_413_1591	2026-06-10	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
981	ADV_414_1592	2026-06-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
982	ADV_415_1593	2026-06-11	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
983	ADV_416_1594	2026-06-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
984	ADV_417_1595	2026-06-12	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
985	ADV_418_1709	2026-06-15	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
986	ADV_419_1710	2026-06-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
987	ADV_420_1711	2026-06-16	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
988	ADV_421_1712	2026-06-17	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
989	ADV_422_1713	2026-06-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
990	ADV_423_1714	2026-06-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
991	ADV_424_1715	2026-06-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
992	ADV_425_1716	2026-06-18	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
993	ADV_426_1733	2026-06-20	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
994	ADV_427_1779	2026-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
995	ADV_428_1780	2026-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
996	ADV_429_1781	2026-06-19	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
997	ADV_430_1841	2026-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
998	ADV_431_1842	2026-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
999	ADV_432_1843	2026-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1000	ADV_433_1844	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1001	ADV_434_1845	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1002	ADV_435_1846	2026-06-23	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1003	ADV_436_1847	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1004	ADV_437_1848	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1005	ADV_438_1849	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1006	ADV_439_1850	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1007	ADV_440_1851	2026-06-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1008	ADV_441_1852	2026-06-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1009	ADV_442_1853	2026-06-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1010	ADV_443_1854	2026-06-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1011	ADV_444_1855	2026-06-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1012	ADV_445_1856	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1013	ADV_446_1857	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1014	ADV_447_1858	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1015	ADV_448_1859	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1016	ADV_449_1873	2026-06-24	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1017	ADV_450_1874	2026-06-25	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1018	ADV_452_2004	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1019	ADV_453_2005	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1020	ADV_454_2006	2026-06-26	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1021	ADV_455_2007	2026-07-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1022	ADV_456_2008	2026-07-01	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1023	ADV_457_2009	2026-07-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1024	ADV_458_2010	2026-07-02	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1025	ADV_459_2011	2026-07-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
1026	ADV_460_2012	2026-07-03	1742	Payment	Contractor	0.00		\N	2026-08-03 14:42:23.989748	2026-08-03 14:42:23.989748
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
267	LB_2_40_120_0	2026-04-08	1263	\N	2108	7	1001.950	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
268	LB_2_40_120_1	2026-04-08	1263	\N	2108	8	1001.950	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
269	LB_2_40_120_2	2026-04-08	1263	\N	2108	9	1001.950	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
270	LB_2_169_120_3	2026-04-08	1263	\N	2236	7	4.902	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
271	LB_2_169_120_4	2026-04-08	1263	\N	2236	7	950.988	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
272	LB_2_169_120_5	2026-04-08	1263	\N	2236	8	950.988	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
273	LB_2_169_120_6	2026-04-08	1263	\N	2236	9	950.988	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
274	LB_2_573_120_7	2026-04-08	1263	\N	2705	7	216.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
275	LB_2_573_120_8	2026-04-08	1263	\N	2705	8	216.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
276	LB_2_573_120_9	2026-04-08	1263	\N	2705	9	216.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
277	LB_2_952_120_10	2026-04-08	1263	\N	3019	7	535.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
278	LB_2_952_120_11	2026-04-08	1263	\N	3019	8	535.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
279	LB_2_952_120_12	2026-04-08	1263	\N	3019	9	535.680	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
280	LB_2_5_120_13	2026-04-08	1263	\N	2073	7	5.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
281	LB_2_5_120_14	2026-04-08	1263	\N	2073	7	3084.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
282	LB_2_5_120_15	2026-04-08	1263	\N	2073	8	3084.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
283	LB_2_5_120_16	2026-04-08	1263	\N	2073	9	3084.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
284	LB_2_6_120_17	2026-04-08	1263	\N	2074	7	16.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
285	LB_2_6_120_18	2026-04-08	1263	\N	2074	7	405.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
286	LB_2_6_120_19	2026-04-08	1263	\N	2074	8	405.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
287	LB_2_6_120_20	2026-04-08	1263	\N	2074	9	405.650	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
288	LB_2_13_120_21	2026-04-08	1263	\N	2081	7	73.612	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
289	LB_2_13_120_22	2026-04-08	1263	\N	2081	8	73.612	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
290	LB_2_13_120_23	2026-04-08	1263	\N	2081	9	73.612	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
291	LB_2_40_120_24	2026-04-08	1263	\N	2108	7	11.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
292	LB_2_191_120_25	2026-04-08	1263	\N	2258	7	9.250	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
293	LB_2_191_120_26	2026-04-08	1263	\N	2258	7	229.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
294	LB_2_191_120_27	2026-04-08	1263	\N	2258	8	229.400	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
295	LB_2_195_120_28	2026-04-08	1263	\N	2262	7	325.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
296	LB_2_195_120_29	2026-04-08	1263	\N	2262	8	325.480	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
297	LB_2_212_120_30	2026-04-08	1263	\N	2279	7	26.220	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
298	LB_2_212_120_31	2026-04-08	1263	\N	2279	7	414.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
299	LB_2_212_120_32	2026-04-08	1263	\N	2279	8	414.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
300	LB_2_212_120_33	2026-04-08	1263	\N	2279	9	414.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
301	LB_2_307_120_34	2026-04-08	1263	\N	2374	7	512.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
302	LB_2_307_120_35	2026-04-08	1263	\N	2374	8	512.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
303	LB_2_307_120_36	2026-04-08	1263	\N	2374	9	512.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
304	LB_2_454_120_37	2026-04-08	1263	\N	2521	7	1070.944	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
305	LB_2_454_120_38	2026-04-08	1263	\N	2521	8	1070.944	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
306	LB_2_454_120_39	2026-04-08	1263	\N	2521	9	1070.944	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
307	LB_2_583_120_40	2026-04-08	1263	\N	2715	7	159.300	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
308	LB_2_583_120_41	2026-04-08	1263	\N	2715	8	159.300	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
309	LB_2_583_120_42	2026-04-08	1263	\N	2715	9	159.300	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
310	LB_2_1010_120_43	2026-04-08	1263	\N	3077	7	108.188	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
311	LB_2_1010_120_44	2026-04-08	1263	\N	3077	7	438.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
312	LB_2_1010_120_45	2026-04-08	1263	\N	3077	8	438.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
313	LB_2_1010_120_46	2026-04-08	1263	\N	3077	9	438.600	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
314	LB_2_1_122_0	2026-04-08	1263	\N	2069	6	1.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
315	LB_4_90_201_0	2026-04-15	1263	\N	2157	6	17.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
316	LB_4_90_201_1	2026-04-15	1263	\N	2157	6	9.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
317	LB_5_329_359_0	2026-04-22	1263	\N	2396	7	13.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
318	LB_5_329_359_1	2026-04-22	1263	\N	2396	8	13.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
319	LB_5_329_359_2	2026-04-22	1263	\N	2396	9	13.500	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
320	LB_5_680_359_3	2026-04-22	1263	\N	2747	7	10.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
321	LB_5_680_359_4	2026-04-22	1263	\N	2747	8	10.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
322	LB_5_680_359_5	2026-04-22	1263	\N	2747	9	10.240	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
323	LB_5_961_359_6	2026-04-22	1263	\N	3028	7	9.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
324	LB_5_961_359_7	2026-04-22	1263	\N	3028	8	9.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
325	LB_5_961_359_8	2026-04-22	1263	\N	3028	9	9.260	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
326	LB_5_212_359_9	2026-04-22	1263	\N	2279	7	1.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
327	LB_5_212_359_10	2026-04-22	1263	\N	2279	8	1.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
328	LB_5_212_359_11	2026-04-22	1263	\N	2279	9	1.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
329	LB_5_32_359_12	2026-04-22	1263	\N	2100	7	23.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
330	LB_5_32_359_13	2026-04-22	1263	\N	2100	8	23.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
331	LB_5_32_359_14	2026-04-22	1263	\N	2100	9	23.940	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
332	LB_5_40_359_15	2026-04-22	1263	\N	2108	7	2.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
333	LB_5_40_359_16	2026-04-22	1263	\N	2108	8	2.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
334	LB_5_40_359_17	2026-04-22	1263	\N	2108	9	2.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
335	LB_5_8_359_18	2026-04-22	1263	\N	2076	7	30.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
336	LB_5_8_359_19	2026-04-22	1263	\N	2076	8	30.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
337	LB_5_8_359_20	2026-04-22	1263	\N	2076	9	30.800	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
338	LB_5_879_359_21	2026-04-22	1263	\N	2946	7	3.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
339	LB_5_879_359_22	2026-04-22	1263	\N	2946	8	3.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
340	LB_5_191_359_23	2026-04-22	1263	\N	2258	7	1.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
341	LB_5_191_359_24	2026-04-22	1263	\N	2258	8	1.850	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
342	LB_5_323_359_25	2026-04-22	1263	\N	2390	7	6.292	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
343	LB_5_323_359_26	2026-04-22	1263	\N	2390	8	6.292	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
344	LB_5_323_359_27	2026-04-22	1263	\N	2390	9	6.292	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
345	LB_5_40_359_28	2026-04-22	1263	\N	2108	7	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
346	LB_5_40_359_29	2026-04-22	1263	\N	2108	8	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
347	LB_5_40_359_30	2026-04-22	1263	\N	2108	9	1.450	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
348	LB_5_307_359_31	2026-04-22	1263	\N	2374	8	11.840	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
349	LB_5_862_359_32	2026-04-22	1263	\N	2929	7	4.389	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
350	LB_5_862_359_33	2026-04-22	1263	\N	2929	8	4.389	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
351	LB_5_862_359_34	2026-04-22	1263	\N	2929	9	4.389	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
352	LB_5_102_359_35	2026-04-22	1263	\N	2169	7	65.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
353	LB_5_102_359_36	2026-04-22	1263	\N	2169	8	65.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
354	LB_5_102_359_37	2026-04-22	1263	\N	2169	9	65.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
355	LB_5_160_359_38	2026-04-22	1263	\N	2227	7	5.216	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
356	LB_5_160_359_39	2026-04-22	1263	\N	2227	8	5.216	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
357	LB_5_160_359_40	2026-04-22	1263	\N	2227	9	5.216	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
358	LB_5_146_359_41	2026-04-22	1263	\N	2213	7	2.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
359	LB_5_146_359_42	2026-04-22	1263	\N	2213	8	2.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
360	LB_5_146_359_43	2026-04-22	1263	\N	2213	9	2.550	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
361	LB_5_152_359_44	2026-04-22	1263	\N	2219	7	4.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
362	LB_5_152_359_45	2026-04-22	1263	\N	2219	8	4.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
363	LB_5_152_359_46	2026-04-22	1263	\N	2219	9	4.760	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
364	LB_5_32_359_47	2026-04-22	1263	\N	2100	7	1.710	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
365	LB_5_32_359_48	2026-04-22	1263	\N	2100	8	1.710	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
366	LB_5_32_359_49	2026-04-22	1263	\N	2100	9	1.710	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
367	LB_5_480_359_50	2026-04-22	1263	\N	2547	7	19.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
368	LB_5_480_359_51	2026-04-22	1263	\N	2547	8	19.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
369	LB_5_480_359_52	2026-04-22	1263	\N	2547	9	19.380	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
370	LB_5_85_359_53	2026-04-22	1263	\N	2152	7	9.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
371	LB_5_85_359_54	2026-04-22	1263	\N	2152	8	9.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
372	LB_5_85_359_55	2026-04-22	1263	\N	2152	9	9.460	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
373	LB_5_596_359_56	2026-04-22	1263	\N	2598	7	10.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
374	LB_5_596_359_57	2026-04-22	1263	\N	2598	8	10.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
375	LB_5_596_359_58	2026-04-22	1263	\N	2598	9	10.200	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
376	LB_5_22_359_59	2026-04-22	1263	\N	2090	7	56.070	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
377	LB_5_22_359_60	2026-04-22	1263	\N	2090	8	56.070	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
378	LB_5_22_359_61	2026-04-22	1263	\N	2090	9	56.070	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
379	LB_6_642_559_0	2026-04-29	1263	\N	2644	7	243.045	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
380	LB_6_642_559_1	2026-04-29	1263	\N	2644	8	243.045	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
381	LB_6_642_559_2	2026-04-29	1263	\N	2644	9	243.045	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
382	LB_6_5_559_3	2026-04-29	1263	\N	2073	7	5.150	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
383	LB_6_5_559_4	2026-04-29	1263	\N	2073	7	2003.350	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
384	LB_6_5_559_5	2026-04-29	1263	\N	2073	8	2003.350	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
385	LB_6_5_559_6	2026-04-29	1263	\N	2073	9	2003.350	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
386	LB_6_19_559_7	2026-04-29	1263	\N	2087	7	5.876	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
387	LB_6_19_559_8	2026-04-29	1263	\N	2087	7	581.724	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
388	LB_6_19_559_9	2026-04-29	1263	\N	2087	8	581.724	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
389	LB_6_19_559_10	2026-04-29	1263	\N	2087	9	581.724	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
390	LB_6_164_559_11	2026-04-29	1263	\N	2231	7	4.960	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
391	LB_6_164_559_12	2026-04-29	1263	\N	2231	7	982.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
392	LB_6_164_559_13	2026-04-29	1263	\N	2231	8	982.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
393	LB_6_164_559_14	2026-04-29	1263	\N	2231	9	982.080	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
394	LB_6_213_559_15	2026-04-29	1263	\N	2280	7	666.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
395	LB_6_213_559_16	2026-04-29	1263	\N	2280	8	666.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
396	LB_6_213_559_17	2026-04-29	1263	\N	2280	9	666.000	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
397	LB_6_242_559_18	2026-04-29	1263	\N	2309	7	498.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
398	LB_6_242_559_19	2026-04-29	1263	\N	2309	8	498.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
399	LB_6_242_559_20	2026-04-29	1263	\N	2309	9	498.900	0.00	0.00	18.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00		f	\N	\N	2026-08-03 14:42:23.810951	2026-08-03 14:42:23.810951	[]	[]	\N
\.


--
-- Data for Name: salary_vouchers; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.salary_vouchers (id, voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, allowances, deductions, net_salary, narration, created_by, created_at, updated_at) FROM stdin;
5	SAL_8_775	2026-05-07	1875	5	2026	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:23.979757	2026-08-03 14:42:23.979757
6	SAL_11_984	2026-05-18	1875	5	2026	0.0	0.00	0.00	0.00	0.00		\N	2026-08-03 14:42:23.979757	2026-08-03 14:42:23.979757
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
5	ST_20_22	2026-05-22	2241	2241	360.000		\N	2026-08-03 14:42:24.672165
6	ST_31_33	2026-06-04	2711	2711	111.000		\N	2026-08-03 14:42:24.672165
\.


--
-- Data for Name: voucher_lines; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.voucher_lines (id, voucher_id, ledger_id, dr_amount, cr_amount, narration) FROM stdin;
1273	637	1387	0.00	109000.00	PAID AMOUNT FOR JAN
1274	637	1396	109000.00	0.00	PAID AMOUNT FOR JAN
1275	638	1425	0.00	350.00	PURCHASE OF GP PANT
1276	638	1283	350.00	0.00	PURCHASE OF GP PANT
1277	639	1397	0.00	700.00	PURCASE OF WIRE AND SWITCH
1278	639	1336	700.00	0.00	PURCASE OF WIRE AND SWITCH
1279	640	1425	0.00	360.00	FAN FROM LODGE AUTO CHARGE
1280	640	1283	360.00	0.00	FAN FROM LODGE AUTO CHARGE
1281	641	1397	0.00	450.00	PURCHASE OF PEN AND ACOUNT NOTES
1282	641	1351	450.00	0.00	PURCHASE OF PEN AND ACOUNT NOTES
1283	642	1387	0.00	75.00	PURCHASE OF TESTER
1284	642	1336	75.00	0.00	PURCHASE OF TESTER
1285	645	1387	0.00	300.00	LATHE WORK
1286	645	1336	300.00	0.00	LATHE WORK
1287	646	1387	0.00	140.00	PURCHASE OF BED PLATES SHREE KUMARAN STEELS
1288	646	1336	140.00	0.00	PURCHASE OF BED PLATES SHREE KUMARAN STEELS
1289	647	1387	0.00	700.00	BOLT AND NUT
1290	647	1323	700.00	0.00	BOLT AND NUT
1291	648	1387	0.00	3050.00	PURCHASE OF DUST COLLECTOR BAG
1292	648	1481	3050.00	0.00	PURCHASE OF DUST COLLECTOR BAG
1293	649	1387	0.00	180.00	RAPIDO
1294	649	1482	180.00	0.00	RAPIDO
1295	643	1387	0.00	105.00	RAPIDO TO IBHARIM
1296	643	1482	105.00	0.00	RAPIDO TO IBHARIM
1297	644	1397	0.00	180.00	RAPIDO KANNAN GRINDING
1298	644	1482	180.00	0.00	RAPIDO KANNAN GRINDING
1299	650	1387	0.00	200.00	KANNAN
1300	650	1482	200.00	0.00	KANNAN
1301	651	1365	0.00	1450.00	
1302	651	1365	1450.00	0.00	
1303	652	1425	0.00	450.00	Purchase Of Printer Caterage
1304	652	1323	450.00	0.00	Purchase Of Printer Caterage
1305	653	1425	0.00	830.00	Paper Bundle
1306	653	1323	830.00	0.00	Paper Bundle
1307	654	1425	0.00	100.00	From Gandhipuram
1308	654	1482	100.00	0.00	From Gandhipuram
1309	655	1425	0.00	1420.00	Purcase Of Gloves
1310	655	1365	1420.00	0.00	Purcase Of Gloves
1311	656	1387	0.00	1000.00	Diseal
1312	656	1465	1000.00	0.00	Diseal
1313	657	1425	0.00	1000.00	Tata
1314	657	1422	1000.00	0.00	Tata
1315	658	1425	0.00	220.00	Food
1316	658	1335	220.00	0.00	Food
1317	668	1387	0.00	5000.00	Paid For Crainloading And Unloading
1318	668	1493	5000.00	0.00	Paid For Crainloading And Unloading
1319	669	1425	0.00	200.00	Tea
1320	669	1335	200.00	0.00	Tea
1321	670	1425	0.00	1000.00	Diseal
1322	670	1465	1000.00	0.00	Diseal
1323	671	1425	0.00	2500.00	Syscli
1324	671	1323	2500.00	0.00	Syscli
1325	672	1425	0.00	110.00	Gandhipuram
1326	672	1482	110.00	0.00	Gandhipuram
1327	673	1425	0.00	2242.00	Welding Rod
1328	673	1323	2242.00	0.00	Welding Rod
1329	674	1425	0.00	300.00	Bolt And Nut For Power Factor
1330	674	1323	300.00	0.00	Bolt And Nut For Power Factor
1331	675	1425	0.00	300.00	Bolt And Nut For Shotblasting
1332	675	1323	300.00	0.00	Bolt And Nut For Shotblasting
1333	676	1425	0.00	200.00	TEA
1334	676	1335	200.00	0.00	TEA
1335	677	1425	0.00	2500.00	AC FROM AVANCASHI
1336	677	1283	2500.00	0.00	AC FROM AVANCASHI
1337	678	1387	0.00	800.00	SAND JALLADAI
1338	678	1323	800.00	0.00	SAND JALLADAI
1339	679	1387	0.00	1900.00	ALUMINIUM SCREW AND RUBBER BEADING
1340	679	1323	1900.00	0.00	ALUMINIUM SCREW AND RUBBER BEADING
1341	680	1387	0.00	250.00	PURCHASE OF AG4 WHEEL
1342	680	1323	250.00	0.00	PURCHASE OF AG4 WHEEL
1343	681	1379	0.00	29618.00	
1344	681	1323	29618.00	0.00	
1345	682	1387	0.00	29618.00	PURCHASE OF 100 LTS PAINT
1346	682	1379	29618.00	0.00	PURCHASE OF 100 LTS PAINT
1347	683	1387	0.00	200.00	FOR MOTOR FROM COMPANY TO AVERAMPALAYAM
1348	683	1482	200.00	0.00	FOR MOTOR FROM COMPANY TO AVERAMPALAYAM
1349	684	1349	0.00	38704.00	
1350	684	1323	38704.00	0.00	
1351	685	1349	0.00	500.00	
1352	685	1323	500.00	0.00	
1353	686	1387	0.00	870.00	PURCHASE OF CAKE FOR SURESH BIRTHDAY
1354	686	1335	870.00	0.00	PURCHASE OF CAKE FOR SURESH BIRTHDAY
1355	687	1282	0.00	10000.00	
1356	687	1658	10000.00	0.00	
1357	688	1387	0.00	10000.00	PURCHASE OF SHOTS 150 KGS
1358	688	1282	10000.00	0.00	PURCHASE OF SHOTS 150 KGS
1359	689	1387	0.00	550.00	PURCHASE OF BUSH FOR SHOTBLASTING
1360	689	1323	550.00	0.00	PURCHASE OF BUSH FOR SHOTBLASTING
1361	690	1425	0.00	100.00	ARUMUGAM
1362	690	1482	100.00	0.00	ARUMUGAM
1363	691	1387	0.00	140.00	PURCHASE OF GROOME 2 NOS
1364	691	1323	140.00	0.00	PURCHASE OF GROOME 2 NOS
1365	692	1397	0.00	10000.00	Paid For Grinding Stone
1366	692	1349	10000.00	0.00	Paid For Grinding Stone
1367	693	1397	0.00	600.00	Purchase Of 14 Inch Cutting Wheel
1368	693	1323	600.00	0.00	Purchase Of 14 Inch Cutting Wheel
1369	694	1387	0.00	350.00	Krishna Grinding Auto Charge
1370	694	1283	350.00	0.00	Krishna Grinding Auto Charge
1371	695	1387	0.00	200.00	Hindi Labour From Room To Company
1372	695	1283	200.00	0.00	Hindi Labour From Room To Company
1373	696	1387	0.00	5000.00	Payed For Crain
1374	696	1493	5000.00	0.00	Payed For Crain
1375	697	1387	0.00	2000.00	TATA
1376	697	1422	2000.00	0.00	TATA
1377	698	1387	0.00	100.00	PAID FOR ARUMUGAM
1378	698	1283	100.00	0.00	PAID FOR ARUMUGAM
1379	699	1425	0.00	200.00	HINDIN LABOURS FROM ROOM
1380	699	1283	200.00	0.00	HINDIN LABOURS FROM ROOM
1381	700	1387	0.00	400.00	PURCHASE OF 4 INCH WHEEL
1382	700	1323	400.00	0.00	PURCHASE OF 4 INCH WHEEL
1383	701	1387	0.00	1000.00	FORKLIFT
1384	701	1422	1000.00	0.00	FORKLIFT
1385	702	1387	0.00	120.00	PURCHASE OF FLANGE BEARING
1386	702	1482	120.00	0.00	PURCHASE OF FLANGE BEARING
1387	703	1387	0.00	2000.00	TATA
1388	703	1422	2000.00	0.00	TATA
1389	704	1387	0.00	200.00	HINDI LABOUR
1390	704	1283	200.00	0.00	HINDI LABOUR
1391	705	1387	0.00	1500.00	PURCHASE OF ALUMINIUM L ANGLE
1392	705	1323	1500.00	0.00	PURCHASE OF ALUMINIUM L ANGLE
1393	706	1387	0.00	1300.00	FLANGE BEARING
1394	706	1323	1300.00	0.00	FLANGE BEARING
1395	743	1379	0.00	29618.00	
1396	743	1323	29618.00	0.00	
1397	744	1282	0.00	11505.00	
1398	744	1323	11505.00	0.00	
1399	745	1727	0.00	1600.00	
1400	745	1323	1600.00	0.00	
1401	746	1387	0.00	28497.00	PAID FOR TURBON OIL
1402	746	1633	28497.00	0.00	PAID FOR TURBON OIL
1403	747	1387	0.00	20000.00	PAID FOR GRINDING STONE
1404	747	1349	20000.00	0.00	PAID FOR GRINDING STONE
1405	748	1387	0.00	29618.00	PURCHSE OF 100 LTS GP  PAINT
1406	748	1379	29618.00	0.00	PURCHSE OF 100 LTS GP  PAINT
1407	749	1387	0.00	1600.00	PURCHASE  OF DRINKING WATER
1408	749	1727	1600.00	0.00	PURCHASE  OF DRINKING WATER
1409	750	1387	0.00	10000.00	MOTOR REPAIR
1410	750	1345	10000.00	0.00	MOTOR REPAIR
1411	751	1387	0.00	10000.00	PAID FOR CRAIN
1412	751	1493	10000.00	0.00	PAID FOR CRAIN
1413	756	1387	0.00	3700.00	Ac Repair And Gas Filing
1414	756	1336	3700.00	0.00	Ac Repair And Gas Filing
1415	757	1387	0.00	5700.00	Purchase Of Water Tank
1416	757	1323	5700.00	0.00	Purchase Of Water Tank
1417	758	1387	0.00	100.00	Marimuthu Lunch
1418	758	1335	100.00	0.00	Marimuthu Lunch
1419	759	1425	0.00	200.00	Texmo
1420	759	1482	200.00	0.00	Texmo
1421	659	1425	0.00	200.00	TEXMO
1422	659	1482	200.00	0.00	TEXMO
1423	660	1425	0.00	200.00	TEA
1424	660	1335	200.00	0.00	TEA
1425	661	1425	0.00	100.00	ZIP COVER AND LEMON
1426	661	1323	100.00	0.00	ZIP COVER AND LEMON
1427	662	1387	0.00	4000.00	ASHOK SAMY
1428	662	1369	4000.00	0.00	ASHOK SAMY
1429	663	1387	0.00	44000.00	LOAN AMOUNT PAID
1430	663	1313	44000.00	0.00	LOAN AMOUNT PAID
1431	664	1387	0.00	200.00	TEXMO
1432	664	1482	200.00	0.00	TEXMO
1433	665	1387	0.00	1862.00	WEEKLY TEA PAYMENT
1434	665	1630	1862.00	0.00	WEEKLY TEA PAYMENT
1435	666	1387	0.00	15000.00	WEEKLY PAPYMENT
1436	666	1493	15000.00	0.00	WEEKLY PAPYMENT
1437	667	1387	252002.00	0.00	BILL NO - 6
1438	667	1263	0.00	252002.00	BILL NO - 6
1439	919	1425	0.00	20000.00	PAID FOR GRINDING STONE
1440	919	1349	20000.00	0.00	PAID FOR GRINDING STONE
1441	920	1349	0.00	16992.00	
1442	920	1323	16992.00	0.00	
1443	921	1633	0.00	28497.00	
1444	921	1323	28497.00	0.00	
1445	922	1379	0.00	16992.00	
1446	922	1323	16992.00	0.00	
1447	923	1387	0.00	28497.00	PAID FOR THE PURCHASE OF 210 LITTERS
1448	923	1633	28497.00	0.00	PAID FOR THE PURCHASE OF 210 LITTERS
1449	925	1387	0.00	41300.00	RENT PAID
1450	925	1665	41300.00	0.00	RENT PAID
1451	926	1665	0.00	76300.00	
1452	926	1323	76300.00	0.00	
1453	927	1387	0.00	41600.00	RENT PAID FOR THE MONTH OF JUNE
1454	927	1665	41600.00	0.00	RENT PAID FOR THE MONTH OF JUNE
1455	928	1387	0.00	2303.00	LABOUR WELFARE
1456	928	1630	2303.00	0.00	LABOUR WELFARE
1457	929	1387	0.00	10000.00	PAID FOR THE CRAIN
1458	929	1493	10000.00	0.00	PAID FOR THE CRAIN
1459	924	1387	0.00	16992.00	CASH PAID FOR 60 LITTERS
1460	924	1379	16992.00	0.00	CASH PAID FOR 60 LITTERS
1461	707	1425	0.00	2500.00	DRINKS
1462	707	1335	2500.00	0.00	DRINKS
1463	708	1387	0.00	1500.00	Paid For Water
1464	708	1727	1500.00	0.00	Paid For Water
1465	709	1387	0.00	288.00	Texmo For Strainer Bracket
1466	709	1283	288.00	0.00	Texmo For Strainer Bracket
1467	710	1387	0.00	3000.00	Paid For Labour Welfare
1468	710	1630	3000.00	0.00	Paid For Labour Welfare
1469	711	1387	0.00	170.00	Texmo Labours
1470	711	1283	170.00	0.00	Texmo Labours
1471	712	1387	0.00	820.00	Purchase Of Wire And Switch Boxs For Office
1472	712	1323	820.00	0.00	Purchase Of Wire And Switch Boxs For Office
1473	713	1387	0.00	300.00	Paid For Rapido For Modi And Ibharim
1474	713	1283	300.00	0.00	Paid For Rapido For Modi And Ibharim
1475	714	1387	0.00	5100.00	Purchase Of Floor Mat For Office
1476	714	1323	5100.00	0.00	Purchase Of Floor Mat For Office
1477	715	1633	0.00	56994.00	
1478	715	1323	56994.00	0.00	
1479	716	1387	0.00	28497.00	PAID FOR TURBON OIL
1480	716	1633	28497.00	0.00	PAID FOR TURBON OIL
1481	717	1387	0.00	20000.00	PAID FOR GRINDING WHEEL
1482	717	1349	20000.00	0.00	PAID FOR GRINDING WHEEL
1483	718	1387	0.00	500.00	CASH PAID
1484	718	1349	500.00	0.00	CASH PAID
1485	719	1349	0.00	1900.00	
1486	719	1323	1900.00	0.00	
1487	720	1349	0.00	10856.00	
1488	720	1323	10856.00	0.00	
1489	721	1727	0.00	7200.00	
1490	721	1323	7200.00	0.00	
1491	722	1387	0.00	1648.00	BALANCE AMOUNT PAID
1492	722	1630	1648.00	0.00	BALANCE AMOUNT PAID
1493	723	1387	0.00	2000.00	PAID FOR DRINKING WATER
1494	723	1727	2000.00	0.00	PAID FOR DRINKING WATER
1495	725	1282	0.00	9750.00	
1496	725	1323	9750.00	0.00	
1497	726	1551	0.00	4956.00	
1498	726	1323	4956.00	0.00	
1499	727	1387	0.00	4956.00	Gpay Paid For Narrow Plate
1500	727	1551	4956.00	0.00	Gpay Paid For Narrow Plate
1501	724	1282	0.00	23010.00	
1502	724	1323	23010.00	0.00	
1503	728	1379	0.00	28618.00	
1504	728	1323	28618.00	0.00	
1505	729	1379	0.00	29618.00	
1506	729	1323	29618.00	0.00	
1507	730	1387	0.00	29618.00	Purchase Of Gp Paint 100 Lts
1508	730	1379	29618.00	0.00	Purchase Of Gp Paint 100 Lts
1509	731	1387	0.00	29618.00	Purchase Of Gp Paint 100 Lts
1636	807	1323	17770.00	0.00	
1510	731	1379	29618.00	0.00	Purchase Of Gp Paint 100 Lts
1511	732	1387	0.00	5000.00	Paid For Crain
1512	732	1493	5000.00	0.00	Paid For Crain
1513	733	1387	0.00	23010.00	Paid In  Cheque
1514	733	1282	23010.00	0.00	Paid In  Cheque
1515	734	1387	57600.00	0.00	Paid Bill No 01
1516	734	1263	0.00	57600.00	Paid Bill No 01
1517	735	1387	223480.00	0.00	Paid For Bil  No 2 And 3
1518	735	1263	0.00	223480.00	Paid For Bil  No 2 And 3
1519	736	1387	0.00	300.00	Modi And Ibrahim
1520	736	1482	300.00	0.00	Modi And Ibrahim
1521	737	1387	0.00	300.00	Evening Tea
1522	737	1335	300.00	0.00	Evening Tea
1523	738	1387	0.00	2000.00	Tata
1524	738	1422	2000.00	0.00	Tata
1525	752	1387	0.00	1500.00	ACTING  DRIVER
1526	752	1645	1500.00	0.00	ACTING  DRIVER
1527	739	1425	0.00	200.00	Texmo
1528	739	1482	200.00	0.00	Texmo
1529	740	1425	0.00	500.00	Acting Driver Tips
1530	740	1645	500.00	0.00	Acting Driver Tips
1531	741	1387	0.00	1200.00	SALARY FOR A DAY
1532	741	1645	1200.00	0.00	SALARY FOR A DAY
1533	742	1425	0.00	200.00	TEXMO
1534	742	1482	200.00	0.00	TEXMO
1535	753	1387	0.00	115666.00	PAID FEB MONTH
1536	753	1396	115666.00	0.00	PAID FEB MONTH
1537	754	1387	0.00	1776.00	PAID
1538	754	1630	1776.00	0.00	PAID
1539	755	1387	0.00	11505.00	PAID PURCHASE OF SHOTS 150 KGS
1540	755	1282	11505.00	0.00	PAID PURCHASE OF SHOTS 150 KGS
1541	761	1282	0.00	11505.00	
1542	761	1323	11505.00	0.00	
1543	762	1425	0.00	100.00	MARIMUTHU LUNCH
1544	762	1335	100.00	0.00	MARIMUTHU LUNCH
1545	763	1425	0.00	60.00	LUNCH MARIMUTHU
1546	763	1335	60.00	0.00	LUNCH MARIMUTHU
1547	764	1425	0.00	350.00	WELDING ROD
1548	764	1288	350.00	0.00	WELDING ROD
1549	760	1387	234452.00	0.00	Received
1550	760	1263	0.00	234452.00	Received
1551	765	1633	0.00	28497.00	
1552	765	1323	28497.00	0.00	
1553	766	1387	0.00	200.00	TEXMO
1554	766	1482	200.00	0.00	TEXMO
1555	767	1387	0.00	350.00	PURCHASE OF WELDING ROD
1556	767	1323	350.00	0.00	PURCHASE OF WELDING ROD
1557	768	1387	0.00	200.00	WHITE PAINT AND BLUE PAINT
1558	768	1323	200.00	0.00	WHITE PAINT AND BLUE PAINT
1559	769	1387	0.00	200.00	TEXMO
1560	769	1482	200.00	0.00	TEXMO
1561	770	1387	0.00	60.00	MARIMUTHU  LUNCH
1562	770	1335	60.00	0.00	MARIMUTHU  LUNCH
1563	771	1387	0.00	300.00	PURCHASE OF LOCK AND SANAL
1564	771	1323	300.00	0.00	PURCHASE OF LOCK AND SANAL
1565	772	1387	0.00	150.00	TEA
1566	772	1335	150.00	0.00	TEA
1567	773	1387	0.00	200.00	BROOM
1568	773	1323	200.00	0.00	BROOM
1569	774	1317	0.00	28409.00	
1570	774	1323	28409.00	0.00	
1571	776	1387	0.00	23677.00	Paid For Eb Deposite
1572	776	1665	23677.00	0.00	Paid For Eb Deposite
1573	777	1387	0.00	28409.00	Cheque Paid To E.B With Deposite Amount
1574	777	1317	28409.00	0.00	Cheque Paid To E.B With Deposite Amount
1575	775	1665	0.00	93948.00	
1576	775	1323	93948.00	0.00	
1577	784	1666	0.00	600.00	
1578	784	1323	600.00	0.00	
1579	785	1387	0.00	600.00	1000 LTS WATER
1580	785	1666	600.00	0.00	1000 LTS WATER
1581	786	1282	0.00	11505.00	
1582	786	1323	11505.00	0.00	
1583	787	1387	0.00	880.00	VALUE FOR COMPRESSOR
1584	787	1323	880.00	0.00	VALUE FOR COMPRESSOR
1585	788	1387	0.00	4800.00	HOSE FOR COMPRESSOR
1586	788	1323	4800.00	0.00	HOSE FOR COMPRESSOR
1587	789	1387	0.00	200.00	TEXMO
1588	789	1482	200.00	0.00	TEXMO
1589	790	1387	0.00	330.00	SHOTS
1590	790	1283	330.00	0.00	SHOTS
1591	791	1387	0.00	2000.00	TATA
1592	791	1422	2000.00	0.00	TATA
1593	792	1387	0.00	390.00	TEA
1594	792	1335	390.00	0.00	TEA
1595	778	1387	0.00	28497.00	Turboil
1596	778	1633	28497.00	0.00	Turboil
1597	779	1387	0.00	11505.00	Purchase Of Shots 150 Kgs
1598	779	1282	11505.00	0.00	Purchase Of Shots 150 Kgs
1599	780	1387	0.00	20000.00	Payment Paid
1600	780	1349	20000.00	0.00	Payment Paid
1601	781	1379	0.00	29618.00	
1602	781	1323	29618.00	0.00	
1603	782	1387	0.00	29618.00	Payment Made For 100 Lts Paint
1604	782	1379	29618.00	0.00	Payment Made For 100 Lts Paint
1605	783	1387	265931.00	0.00	Invoice No 01-06  Dated 22/04/26
1606	783	1263	0.00	265931.00	Invoice No 01-06  Dated 22/04/26
1607	793	1425	0.00	1500.00	SALARY
1608	793	1645	1500.00	0.00	SALARY
1609	794	1425	0.00	200.00	TEA
1610	794	1335	200.00	0.00	TEA
1611	796	1387	0.00	20000.00	PURCHASE OF GRINDING STONE
1612	796	1349	20000.00	0.00	PURCHASE OF GRINDING STONE
1613	797	1387	0.00	2000.00	WATER
1614	797	1727	2000.00	0.00	WATER
1615	795	1349	0.00	100034.00	
1616	795	1323	100034.00	0.00	
1617	798	1397	0.00	41300.00	RENT PAID FOR THE MONTH OF APRIL
1618	798	1665	41300.00	0.00	RENT PAID FOR THE MONTH OF APRIL
1619	799	1633	0.00	28497.00	
1620	799	1323	28497.00	0.00	
1621	800	1633	0.00	28497.00	
1622	800	1323	28497.00	0.00	
1623	801	1425	0.00	200.00	CASH
1624	801	1482	200.00	0.00	CASH
1625	802	1425	0.00	250.00	CASH
1626	802	1369	250.00	0.00	CASH
1627	803	1425	0.00	200.00	CAS
1628	803	1482	200.00	0.00	CAS
1629	804	1425	0.00	150.00	MOP
1630	804	1336	150.00	0.00	MOP
1631	805	1425	0.00	20000.00	RENT BALANCE PAID
1632	805	1665	20000.00	0.00	RENT BALANCE PAID
1633	806	1397	0.00	8971.00	RENT BALANCE TRANSFER
1634	806	1665	8971.00	0.00	RENT BALANCE TRANSFER
1635	807	1379	0.00	17770.00	
1637	808	1379	0.00	16992.00	
1638	808	1323	16992.00	0.00	
1639	809	1387	0.00	17770.00	PURCHASE OF PAINT 60 LTS
1640	809	1379	17770.00	0.00	PURCHASE OF PAINT 60 LTS
1641	810	1387	0.00	16992.00	PURCCHASE OF PAINT 60 LITERS
1642	810	1379	16992.00	0.00	PURCCHASE OF PAINT 60 LITERS
1643	811	1425	0.00	100.00	MARIMUTHU
1644	811	1335	100.00	0.00	MARIMUTHU
1645	812	1387	0.00	200.00	TEXMO
1646	812	1482	200.00	0.00	TEXMO
1647	813	1425	0.00	100.00	TEXMO
1648	813	1482	100.00	0.00	TEXMO
1649	814	1425	0.00	300.00	PURCHASE OF GP PAINT 60 LTS
1650	814	1283	300.00	0.00	PURCHASE OF GP PAINT 60 LTS
1651	815	1387	0.00	20000.00	Paid For Grinding Stone Purchasse
1652	815	1349	20000.00	0.00	Paid For Grinding Stone Purchasse
1653	816	1387	0.00	11505.00	Purchase Of Shots 150  Kgs
1654	816	1282	11505.00	0.00	Purchase Of Shots 150  Kgs
1655	818	1387	0.00	1800.00	Paid For Labour Welfare Tea Dt.Till 10.05.2026
1656	818	1630	1800.00	0.00	Paid For Labour Welfare Tea Dt.Till 10.05.2026
1657	819	1387	0.00	600.00	Paid For Drinking Water 1000 Lts
1658	819	1666	600.00	0.00	Paid For Drinking Water 1000 Lts
1659	820	1387	0.00	600.00	Paid For Drinking Water 1000 Lts
1660	820	1666	600.00	0.00	Paid For Drinking Water 1000 Lts
1661	817	1387	0.00	28497.00	Purchase Of Turbonoil 210 Litters
1662	817	1633	28497.00	0.00	Purchase Of Turbonoil 210 Litters
1663	821	1387	0.00	11328.00	PURCAHSE OF 40 LTS PAINT INV NO 1265300482
1664	821	1379	11328.00	0.00	PURCAHSE OF 40 LTS PAINT INV NO 1265300482
1665	822	1379	0.00	11328.00	
1666	822	1323	11328.00	0.00	
1667	823	1387	218313.00	0.00	BILL NO
1668	823	1263	0.00	218313.00	BILL NO
1669	824	1349	0.00	3930.00	
1670	824	1323	3930.00	0.00	
1671	825	1282	0.00	11505.00	
1672	825	1323	11505.00	0.00	
1673	826	1387	0.00	28497.00	Paid For Turbon Oil
1674	826	1633	28497.00	0.00	Paid For Turbon Oil
1675	827	1387	0.00	20000.00	PAID FOR GRINDING STONE
1676	827	1349	20000.00	0.00	PAID FOR GRINDING STONE
1677	828	1387	0.00	11505.00	PAID FOR SHOTS 150 KGS
1678	828	1282	11505.00	0.00	PAID FOR SHOTS 150 KGS
1679	829	1379	0.00	33984.00	
1680	829	1323	33984.00	0.00	
1681	830	1387	0.00	33984.00	PURCHASE OF GP PAINT 120 LITS
1682	830	1379	33984.00	0.00	PURCHASE OF GP PAINT 120 LITS
1683	831	1387	0.00	1860.00	PURCASE OF TEA
1684	831	1630	1860.00	0.00	PURCASE OF TEA
1685	832	1387	0.00	20000.00	CRAIN PAYMENT
1686	832	1493	20000.00	0.00	CRAIN PAYMENT
1687	833	1551	0.00	4200.00	
1688	833	1323	4200.00	0.00	
1689	834	1551	0.00	4500.00	
1690	834	1323	4500.00	0.00	
1691	835	1387	0.00	4200.00	PAID FOR LONG NARROW PLATE
1692	835	1551	4200.00	0.00	PAID FOR LONG NARROW PLATE
1693	836	1425	0.00	1400.00	FROM DT 12-21
1694	836	1482	1400.00	0.00	FROM DT 12-21
1695	837	1425	0.00	200.00	TEXMO
1696	837	1482	200.00	0.00	TEXMO
1697	838	1425	0.00	600.00	FRIDAY EXPENSES
1698	838	1369	600.00	0.00	FRIDAY EXPENSES
1699	839	1633	0.00	56994.00	
1700	839	1323	56994.00	0.00	
1701	840	1379	0.00	33984.00	
1702	840	1323	33984.00	0.00	
1703	841	1425	0.00	33984.00	PURCHASE OF GP PAINT 120 LIT
1704	841	1379	33984.00	0.00	PURCHASE OF GP PAINT 120 LIT
1705	842	1387	0.00	28497.00	PURCHASE OF 210 LITTERS TURBON OIL
1706	842	1633	28497.00	0.00	PURCHASE OF 210 LITTERS TURBON OIL
1707	843	1387	0.00	10000.00	PURCHASE OF GRINDING STONE
1708	843	1349	10000.00	0.00	PURCHASE OF GRINDING STONE
1709	844	1551	0.00	6000.00	
1710	844	1323	6000.00	0.00	
1711	845	1425	0.00	6000.00	PURCHASE OF 100 KGS SHOTS
1712	845	1551	6000.00	0.00	PURCHASE OF 100 KGS SHOTS
1713	846	1425	0.00	2100.00	LABOUR WELFARE
1714	846	1630	2100.00	0.00	LABOUR WELFARE
1715	847	1387	0.00	20000.00	PAID FOR CRAIN
1716	847	1493	20000.00	0.00	PAID FOR CRAIN
1717	848	1387	264360.00	0.00	BILL NO 10 AND 11
1718	851	1425	0.00	300.00	TEXMO
1719	851	1482	300.00	0.00	TEXMO
1720	852	1425	0.00	600.00	CUTTING WHEEL AND BOLT NUT
1721	852	1336	600.00	0.00	CUTTING WHEEL AND BOLT NUT
1722	853	1425	0.00	180.00	WAY BRIDGE
1723	853	1336	180.00	0.00	WAY BRIDGE
1724	854	1387	0.00	137060.00	PAID FOR APRIL MONTH
1725	854	1396	137060.00	0.00	PAID FOR APRIL MONTH
1726	855	1425	0.00	3800.00	JCB SAND
1727	855	1336	3800.00	0.00	JCB SAND
1728	856	1425	0.00	150.00	LUNCH FOR SHOTBLASTING WORKER
1729	856	1335	150.00	0.00	LUNCH FOR SHOTBLASTING WORKER
1730	857	1551	0.00	16500.00	
1731	857	1323	16500.00	0.00	
1732	848	1263	0.00	264360.00	BILL NO 10 AND 11
1733	849	1675	0.00	24500.00	
1734	849	1323	24500.00	0.00	
1735	850	1425	0.00	24500.00	PURCHASE OF INNER DISK AND MS PLATE
1736	850	1675	24500.00	0.00	PURCHASE OF INNER DISK AND MS PLATE
1737	858	1379	0.00	16992.00	
1738	858	1323	16992.00	0.00	
1739	859	1425	0.00	16992.00	PURCHASE OF PAINT 60 LITTER
1740	859	1379	16992.00	0.00	PURCHASE OF PAINT 60 LITTER
1741	860	1349	0.00	68558.00	
1742	860	1323	68558.00	0.00	
1743	861	1387	0.00	20000.00	PAID FOR PURCASE OF GRINDING WHEEEL
1744	861	1349	20000.00	0.00	PAID FOR PURCASE OF GRINDING WHEEEL
1745	862	1379	0.00	16992.00	
1746	862	1323	16992.00	0.00	
1747	863	1387	0.00	16992.00	PURCHASE OF PAINT 60 LITTERS
1748	863	1379	16992.00	0.00	PURCHASE OF PAINT 60 LITTERS
1749	864	1387	0.00	28497.00	PURCHASE OF  TURBON OIL
1750	864	1633	28497.00	0.00	PURCHASE OF  TURBON OIL
1751	866	1387	0.00	35000.00	PAID RENT FOR THE MONTH OF MAY
1752	866	1665	35000.00	0.00	PAID RENT FOR THE MONTH OF MAY
1753	867	1387	0.00	8250.00	PAID FOR SHOTS 150 KGS
1754	867	1551	8250.00	0.00	PAID FOR SHOTS 150 KGS
1755	868	1425	0.00	1175.00	PURCHASE OF TEA LABOUR WELFARE
1756	868	1630	1175.00	0.00	PURCHASE OF TEA LABOUR WELFARE
1757	865	1665	0.00	76300.00	
1758	865	1323	76300.00	0.00	
1759	869	1387	255389.00	0.00	BILL NO 01-12
1760	869	1263	0.00	255389.00	BILL NO 01-12
1761	870	1379	0.00	22656.00	
1762	870	1323	22656.00	0.00	
1763	871	1633	0.00	56994.00	
1764	871	1323	56994.00	0.00	
1765	872	1387	0.00	28497.00	PAID FOR 210 LITTERS OF TURBONOIL
1766	872	1633	28497.00	0.00	PAID FOR 210 LITTERS OF TURBONOIL
1767	873	1387	0.00	20000.00	PAID FOR GRINDING STONE
1768	873	1349	20000.00	0.00	PAID FOR GRINDING STONE
1769	874	1387	0.00	10000.00	PAID FOR CRAIN
1770	874	1493	10000.00	0.00	PAID FOR CRAIN
1771	875	1387	0.00	1701.00	PAID FOR LABOUR WELFARE
1772	875	1630	1701.00	0.00	PAID FOR LABOUR WELFARE
1773	876	1425	0.00	200.00	TEXMO
1774	876	1482	200.00	0.00	TEXMO
1775	877	1425	0.00	200.00	LABOUR WELFARE
1776	877	1666	200.00	0.00	LABOUR WELFARE
1777	878	1425	0.00	200.00	TA
1778	878	1316	200.00	0.00	TA
1779	879	1425	0.00	300.00	GREASE
1780	879	1336	300.00	0.00	GREASE
1781	880	1425	0.00	200.00	PURCHASE OF BREAING FROM GANDHIPURAM
1782	880	1482	200.00	0.00	PURCHASE OF BREAING FROM GANDHIPURAM
1783	881	1425	0.00	200.00	TEXMO
1784	881	1482	200.00	0.00	TEXMO
1785	882	1425	0.00	400.00	PURCHASE OF GP PAINT
1786	882	1482	400.00	0.00	PURCHASE OF GP PAINT
1787	883	1425	0.00	200.00	TEA
1788	883	1316	200.00	0.00	TEA
1789	884	1425	0.00	200.00	TEXMO
1790	884	1482	200.00	0.00	TEXMO
1791	885	1425	0.00	150.00	TEA
1792	885	1316	150.00	0.00	TEA
1793	886	1425	0.00	300.00	TEXMO
1794	886	1482	300.00	0.00	TEXMO
1795	887	1425	0.00	200.00	TEA
1796	887	1316	200.00	0.00	TEA
1797	888	1425	0.00	200.00	TEXMO
1798	888	1482	200.00	0.00	TEXMO
1799	889	1425	0.00	700.00	SAKU
1800	889	1336	700.00	0.00	SAKU
1801	890	1425	0.00	200.00	TEA
1802	890	1316	200.00	0.00	TEA
1803	891	1387	0.00	13982.00	PAID FOR THE GRINDING STONE
1804	891	1349	13982.00	0.00	PAID FOR THE GRINDING STONE
1805	892	1387	0.00	28497.00	PAID FOR THE TURBON OIL
1806	892	1633	28497.00	0.00	PAID FOR THE TURBON OIL
1807	893	1387	0.00	10000.00	PAID FOR THE CRAIN
1808	893	1493	10000.00	0.00	PAID FOR THE CRAIN
1809	894	1387	0.00	1901.00	PAID FOR LABOUR WELFARE
1810	894	1630	1901.00	0.00	PAID FOR LABOUR WELFARE
1811	895	1379	0.00	28320.00	
1812	895	1323	28320.00	0.00	
1813	896	1387	0.00	28320.00	PURCHASE OF GP PAINT 100 LITTERS
1814	896	1379	28320.00	0.00	PURCHASE OF GP PAINT 100 LITTERS
1815	897	1387	0.00	22656.00	PURCHASE OF GP PAINT
1816	897	1379	22656.00	0.00	PURCHASE OF GP PAINT
1817	898	1379	0.00	28320.00	
1818	898	1323	28320.00	0.00	
1819	899	1387	0.00	28320.00	PURCHASE OF GP PAINT 100 LITTERS
1820	899	1379	28320.00	0.00	PURCHASE OF GP PAINT 100 LITTERS
1821	900	1551	0.00	8250.00	
1822	900	1323	8250.00	0.00	
1823	901	1349	0.00	28108.00	
1824	901	1323	28108.00	0.00	
1825	902	1425	0.00	200.00	CASH
1826	902	1335	200.00	0.00	CASH
1827	903	1425	0.00	200.00	TEXMO
1828	903	1482	200.00	0.00	TEXMO
1829	904	1425	0.00	200.00	TEA
1830	904	1335	200.00	0.00	TEA
1831	905	1425	0.00	1000.00	PANNEL BOARD SERVICE
1832	905	1301	1000.00	0.00	PANNEL BOARD SERVICE
1833	906	1425	0.00	200.00	TEXMO
1834	906	1482	200.00	0.00	TEXMO
1835	907	1425	0.00	100.00	AKBAR
1836	907	1482	100.00	0.00	AKBAR
1837	908	1425	0.00	250.00	TEA
1838	908	1335	250.00	0.00	TEA
1839	909	1425	0.00	200.00	TEXMO
1840	909	1482	200.00	0.00	TEXMO
1841	910	1425	0.00	100.00	KANNAN AND AKBAR
1842	910	1482	100.00	0.00	KANNAN AND AKBAR
1843	915	1482	200.00	0.00	TEXMO
1844	916	1425	0.00	200.00	AKBAR
1845	916	1482	200.00	0.00	AKBAR
1846	917	1425	0.00	200.00	LABOUR WELFARE
1847	917	1316	200.00	0.00	LABOUR WELFARE
1848	918	1425	0.00	200.00	LABOUR WELFARE
1849	918	1316	200.00	0.00	LABOUR WELFARE
1850	911	1387	0.00	20000.00	PAYMENT MAID FOR GRINDING STONE
1851	911	1349	20000.00	0.00	PAYMENT MAID FOR GRINDING STONE
1852	912	1387	0.00	8250.00	PAID FOR SHOTS 150 KGS
1853	912	1551	8250.00	0.00	PAID FOR SHOTS 150 KGS
1854	913	1425	0.00	200.00	TEXMO
1855	913	1482	200.00	0.00	TEXMO
1856	914	1425	0.00	200.00	AKBAR
1857	914	1482	200.00	0.00	AKBAR
1858	915	1425	0.00	200.00	TEXMO
1859	930	1425	0.00	200.00	TEXMO
1860	930	1482	200.00	0.00	TEXMO
1861	931	1425	0.00	200.00	AKBAR
1862	931	1482	200.00	0.00	AKBAR
1863	932	1425	0.00	200.00	LABOUR WELFARE
1864	932	1316	200.00	0.00	LABOUR WELFARE
1865	933	1425	0.00	200.00	LABOUR WELFARE
1866	933	1316	200.00	0.00	LABOUR WELFARE
1867	934	1425	0.00	200.00	SHOTBLAST BOLT
1868	934	1371	200.00	0.00	SHOTBLAST BOLT
1869	935	1425	0.00	200.00	TEXMO
1870	935	1482	200.00	0.00	TEXMO
1871	936	1425	0.00	430.00	CEMENT
1872	936	1336	430.00	0.00	CEMENT
1873	937	1425	0.00	200.00	LABUR WELFARE
1874	937	1316	200.00	0.00	LABUR WELFARE
1875	938	1425	0.00	200.00	TEXMO
1876	938	1482	200.00	0.00	TEXMO
1877	939	1425	0.00	200.00	BLUE  AND WHITE PAINT
1878	939	1336	200.00	0.00	BLUE  AND WHITE PAINT
1879	940	1425	0.00	100.00	GLASS
1880	940	1365	100.00	0.00	GLASS
1881	941	1425	0.00	400.00	TEXMO AND AKBAR
1882	941	1482	400.00	0.00	TEXMO AND AKBAR
1883	942	1425	0.00	200.00	LABOUR WELFARE
1884	942	1316	200.00	0.00	LABOUR WELFARE
1885	943	1425	0.00	2000.00	TATA
1886	943	1422	2000.00	0.00	TATA
1887	944	1425	0.00	200.00	SHIVA KUMAR
1888	944	1350	200.00	0.00	SHIVA KUMAR
1889	945	1425	0.00	1000.00	PURCHASE OF SHOE
1890	945	1335	1000.00	0.00	PURCHASE OF SHOE
1891	946	1425	0.00	400.00	TEXMO AND AKBAR
1892	946	1482	400.00	0.00	TEXMO AND AKBAR
1893	947	1425	0.00	200.00	LABOUR WELFARE
1894	947	1316	200.00	0.00	LABOUR WELFARE
1895	948	1425	0.00	200.00	TEXMO AND AKBAR
1896	948	1482	200.00	0.00	TEXMO AND AKBAR
1897	949	1425	0.00	200.00	LABOUR WELFARE
1898	949	1316	200.00	0.00	LABOUR WELFARE
1899	950	1425	0.00	500.00	MEDICAL EXPENSES
1900	950	1336	500.00	0.00	MEDICAL EXPENSES
1901	951	1387	231651.00	0.00	PAYMENT RECEIVED  BILL NO 01-14
1902	951	1263	0.00	231651.00	PAYMENT RECEIVED  BILL NO 01-14
1903	952	1387	380434.00	0.00	PAYMENT RECEIVED BILL NO 01-17
1904	952	1263	0.00	380434.00	PAYMENT RECEIVED BILL NO 01-17
1905	953	1387	224928.00	0.00	PAYMENT RECEIVED BILL NO 01-15
1906	953	1263	0.00	224928.00	PAYMENT RECEIVED BILL NO 01-15
1907	954	1633	0.00	22302.00	
1908	954	1323	22302.00	0.00	
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: fy_2026_2027; Owner: orbx
--

COPY fy_2026_2027.vouchers (id, voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at) FROM stdin;
637	PAY_1_3	Payment	2026-04-01	1387	109000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
638	PAY_2_4	Payment	2026-04-01	1425	350.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
639	PAY_3_5	Payment	2026-04-01	1397	700.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
640	PAY_4_6	Payment	2026-04-01	1425	360.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
641	PAY_5_18	Payment	2026-04-02	1397	450.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
642	PAY_6_21	Payment	2026-04-01	1387	75.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
645	PAY_9_28	Payment	2026-04-02	1387	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
646	PAY_10_29	Payment	2026-04-02	1387	140.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
647	PAY_11_31	Payment	2026-04-02	1387	700.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
648	PAY_12_34	Payment	2026-04-02	1387	3050.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
649	PAY_13_38	Payment	2026-04-02	1387	180.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
643	PAY_7_26	Payment	2026-04-01	1387	105.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
644	PAY_8_27	Payment	2026-04-01	1397	180.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
650	PAY_14_41	Payment	2026-04-02	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
651	PUR_1_46	Purchase	2026-04-03	1365	1450.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
652	PAY_15_47	Payment	2026-04-03	1425	450.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
653	PAY_16_48	Payment	2026-04-03	1425	830.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
654	PAY_17_49	Payment	2026-04-03	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
655	PAY_18_50	Payment	2026-04-03	1425	1420.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
656	PAY_19_54	Payment	2026-04-03	1387	1000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
657	PAY_20_65	Payment	2026-04-03	1425	1000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
658	PAY_21_70	Payment	2026-04-04	1425	220.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
668	PAY_22_76	Payment	2026-04-04	1387	5000.00	Total Amount Rs 17500 -5000  Balance 12500		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
669	PAY_23_77	Payment	2026-04-04	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
670	PAY_24_80	Payment	2026-04-06	1425	1000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
671	PAY_25_81	Payment	2026-04-06	1425	2500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
672	PAY_26_82	Payment	2026-04-06	1425	110.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
673	PAY_27_83	Payment	2026-04-06	1425	2242.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
674	PAY_28_84	Payment	2026-04-06	1425	300.00	For		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
675	PAY_29_85	Payment	2026-04-06	1425	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
676	PAY_30_91	Payment	2026-04-06	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
677	PAY_31_92	Payment	2026-04-07	1425	2500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
678	PAY_32_93	Payment	2026-04-07	1387	800.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
679	PAY_33_94	Payment	2026-04-07	1387	1900.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
680	PAY_34_95	Payment	2026-04-07	1387	250.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
681	PUR_2_100	Purchase	2026-04-07	1379	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
682	PAY_35_101	Payment	2026-04-07	1387	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
683	PAY_36_102	Payment	2026-04-07	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
684	PUR_3_103	Purchase	2026-04-07	1349	38704.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
685	PUR_4_104	Purchase	2026-04-07	1349	500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
686	PAY_37_105	Payment	2026-04-07	1387	870.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
687	PUR_5_115	Purchase	2026-04-08	1282	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
688	PAY_38_116	Payment	2026-04-08	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
689	PAY_39_117	Payment	2026-04-08	1387	550.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
690	PAY_40_118	Payment	2026-04-08	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
691	PAY_41_119	Payment	2026-04-08	1387	140.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
692	PAY_42_124	Payment	2026-04-09	1397	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
693	PAY_43_125	Payment	2026-04-09	1397	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
694	PAY_44_126	Payment	2026-04-09	1387	350.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
695	PAY_45_127	Payment	2026-04-09	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
696	PAY_46_128	Payment	2026-04-09	1387	5000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
697	PAY_47_132	Payment	2026-04-09	1387	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
698	PAY_48_133	Payment	2026-04-09	1387	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
699	PAY_49_134	Payment	2026-04-10	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
700	PAY_50_135	Payment	2026-04-11	1387	400.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
701	PAY_51_136	Payment	2026-04-10	1387	1000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
702	PAY_52_137	Payment	2026-04-10	1387	120.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
703	PAY_53_138	Payment	2026-04-10	1387	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
704	PAY_54_139	Payment	2026-04-11	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
705	PAY_55_140	Payment	2026-04-11	1387	1500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
706	PAY_56_141	Payment	2026-04-11	1387	1300.00	INDUSTRIAL BEARING		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
743	PUR_15_360	Purchase	2026-04-22	1379	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
744	PUR_16_361	Purchase	2026-04-22	1282	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
745	PUR_17_362	Purchase	2026-04-22	1727	1600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
746	PAY_81_363	Payment	2026-04-22	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
747	PAY_82_364	Payment	2026-04-22	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
748	PAY_83_365	Payment	2026-04-22	1387	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
749	PAY_84_366	Payment	2026-04-22	1387	1600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
750	PAY_85_367	Payment	2026-04-22	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
751	PAY_86_368	Payment	2026-04-22	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
756	PAY_91_420	Payment	2026-04-24	1387	3700.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
757	PAY_92_421	Payment	2026-04-24	1387	5700.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
758	PAY_93_422	Payment	2026-04-24	1387	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
759	PAY_94_423	Payment	2026-04-24	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
659	PAY_124_765	Payment	2026-05-06	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
660	PAY_125_766	Payment	2026-05-06	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
661	PAY_126_767	Payment	2026-05-06	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
662	PAY_127_768	Payment	2026-05-07	1387	4000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
663	PAY_128_769	Payment	2026-05-07	1387	44000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
664	PAY_129_770	Payment	2026-05-07	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
665	PAY_130_771	Payment	2026-05-07	1387	1862.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
666	PAY_131_772	Payment	2026-05-07	1387	15000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
667	REC_5_773	Receipt	2026-05-06	1387	252002.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
919	PAY_224_1962	Payment	2026-07-01	1425	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
920	PUR_51_1963	Purchase	2026-07-02	1349	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
921	PUR_52_1964	Purchase	2026-06-25	1633	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
922	PUR_53_1965	Purchase	2026-06-30	1379	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
923	PAY_225_1966	Payment	2026-07-01	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
925	PAY_227_1968	Payment	2026-06-10	1387	41300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
926	PUR_54_1969	Purchase	2026-07-01	1665	76300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
927	PAY_228_1970	Payment	2026-07-02	1387	41600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
928	PAY_229_1971	Payment	2026-07-02	1387	2303.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
929	PAY_230_1972	Payment	2026-07-02	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
924	PAY_226_1967	Payment	2026-06-30	1387	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
707	PAY_57_166	Payment	2026-04-12	1425	2500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
708	PAY_58_180	Payment	2026-04-13	1387	1500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
709	PAY_59_181	Payment	2026-04-13	1387	288.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
710	PAY_60_182	Payment	2026-04-13	1387	3000.00	Balance Rs 1648		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
711	PAY_61_183	Payment	2026-04-13	1387	170.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
712	PAY_62_184	Payment	2026-04-13	1387	820.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
713	PAY_63_185	Payment	2026-04-15	1387	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
714	PAY_64_186	Payment	2026-04-15	1387	5100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
715	PUR_6_192	Purchase	2026-04-11	1633	56994.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
716	PAY_65_193	Payment	2026-04-15	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
717	PAY_66_194	Payment	2026-04-15	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
718	PAY_67_195	Payment	2026-04-15	1387	500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
719	PUR_7_196	Purchase	2026-04-11	1349	1900.00	BILL NO 601		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
720	PUR_8_197	Purchase	2026-04-15	1349	10856.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
721	PUR_9_198	Purchase	2026-04-15	1727	7200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
722	PAY_68_199	Payment	2026-04-15	1387	1648.00	NILL BALANCE PAID TILL 11.04.2026		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
723	PAY_69_200	Payment	2026-04-15	1387	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
725	PUR_11_203	Purchase	2026-04-11	1282	9750.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
726	PUR_12_204	Purchase	2026-04-01	1551	4956.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
727	PAY_70_205	Payment	2026-04-15	1387	4956.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
724	PUR_10_202	Purchase	2026-04-01	1282	23010.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
728	PUR_13_207	Purchase	2026-04-07	1379	28618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
729	PUR_14_208	Purchase	2026-04-15	1379	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
730	PAY_71_209	Payment	2026-04-07	1387	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
731	PAY_71_210	Payment	2026-04-15	1387	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
732	PAY_72_211	Payment	2026-04-15	1387	5000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
733	PAY_73_212	Payment	2026-04-15	1387	23010.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
734	REC_1_214	Receipt	2026-04-08	1387	57600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
735	REC_2_215	Receipt	2026-04-15	1387	223480.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
736	PAY_74_243	Payment	2026-04-16	1387	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
737	PAY_75_244	Payment	2026-04-16	1387	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
738	PAY_76_245	Payment	2026-04-17	1387	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
752	PAY_87_369	Payment	2026-04-22	1387	1500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
739	PAY_77_273	Payment	2026-04-19	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
740	PAY_78_274	Payment	2026-04-19	1425	500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
741	PAY_79_275	Payment	2026-04-21	1387	1200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
742	PAY_80_343	Payment	2026-04-21	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
753	PAY_88_370	Payment	2026-04-22	1387	115666.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
754	PAY_89_371	Payment	2026-04-22	1387	1776.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
755	PAY_90_375	Payment	2026-04-22	1387	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
761	PUR_18_489	Purchase	2026-04-27	1282	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
762	PAY_95_501	Payment	2026-04-25	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
763	PAY_96_502	Payment	2026-04-27	1425	60.00	60		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
764	PAY_97_503	Payment	2026-04-27	1425	350.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
760	REC_3_472	Receipt	2026-04-25	1387	234452.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
765	PUR_19_518	Purchase	2026-04-28	1633	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
766	PAY_98_519	Payment	2026-04-27	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
767	PAY_99_520	Payment	2026-04-27	1387	350.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
768	PAY_100_521	Payment	2026-04-27	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
769	PAY_101_522	Payment	2026-04-28	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
770	PAY_102_523	Payment	2026-04-28	1387	60.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
771	PAY_103_524	Payment	2026-04-28	1387	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
772	PAY_104_525	Payment	2026-04-28	1387	150.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
773	PAY_105_526	Payment	2026-04-28	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
774	PUR_20_528	Purchase	2026-04-28	1317	28409.00	IN THIS BILL DEPOSITE PAID RS 23677		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
776	PAY_106_530	Payment	2026-04-28	1387	23677.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
777	PAY_107_531	Payment	2026-04-28	1387	28409.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
775	PUR_21_529	Purchase	2026-04-28	1665	93948.00	FOR THE MONTH OF APRIL INVOICE NUMBER 05  DATED 29/04/2026		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
784	PUR_23_577	Purchase	2026-04-30	1666	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
785	PAY_112_578	Payment	2026-04-30	1387	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
786	PUR_24_579	Purchase	2026-04-30	1282	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
787	PAY_113_580	Payment	2026-04-30	1387	880.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
788	PAY_114_581	Payment	2026-04-30	1387	4800.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
789	PAY_115_582	Payment	2026-04-30	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
790	PAY_116_583	Payment	2026-04-30	1387	330.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
791	PAY_117_606	Payment	2026-04-30	1387	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
792	PAY_118_607	Payment	2026-04-30	1387	390.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
778	PAY_108_549	Payment	2026-04-29	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
779	PAY_109_550	Payment	2026-04-29	1387	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
780	PAY_110_551	Payment	2026-04-29	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
781	PUR_22_552	Purchase	2026-04-29	1379	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
782	PAY_111_553	Payment	2026-04-29	1387	29618.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
783	REC_4_554	Receipt	2026-04-29	1387	265931.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
793	PAY_119_709	Payment	2026-05-05	1425	1500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
794	PAY_120_710	Payment	2026-05-05	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
796	PAY_121_736	Payment	2026-05-06	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
797	PAY_122_737	Payment	2026-05-06	1387	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
795	PUR_25_735	Purchase	2026-05-06	1349	100034.00	INVOICE NO 3841.   DC NO 606,609,624		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
798	PAY_123_739	Payment	2026-05-06	1397	41300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
799	PUR_26_740	Purchase	2026-05-06	1633	28497.00	BILL NO 26-27/INV85		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
800	PUR_27_741	Purchase	2026-05-06	1633	28497.00	26/27/INV84		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
801	PAY_132_809	Payment	2026-05-08	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
802	PAY_133_810	Payment	2026-05-09	1425	250.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
803	PAY_134_811	Payment	2026-05-09	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
804	PAY_135_812	Payment	2026-05-09	1425	150.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
805	PAY_136_841	Payment	2026-05-11	1425	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
806	PAY_137_842	Payment	2026-05-11	1397	8971.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
807	PUR_28_853	Purchase	2026-05-08	1379	17770.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
808	PUR_29_854	Purchase	2026-05-12	1379	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
809	PAY_138_855	Payment	2026-05-08	1387	17770.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
810	PAY_139_856	Payment	2026-05-12	1387	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
811	PAY_140_867	Payment	2026-05-12	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
812	PAY_141_868	Payment	2026-05-11	1387	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
813	PAY_142_869	Payment	2026-05-12	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
814	PAY_143_870	Payment	2026-05-12	1425	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
815	PAY_144_894	Payment	2026-05-13	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
816	PAY_145_895	Payment	2026-05-13	1387	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
818	PAY_147_897	Payment	2026-05-13	1387	1800.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
819	PAY_148_898	Payment	2026-04-30	1387	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
820	PAY_149_899	Payment	2026-05-13	1387	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
817	PAY_146_896	Payment	2026-05-13	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
821	PAY_150_985	Payment	2026-05-12	1387	11328.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
822	PUR_30_986	Purchase	2026-05-12	1379	11328.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
823	REC_6_993	Receipt	2026-05-13	1387	218313.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
824	PUR_31_1017	Purchase	2026-05-20	1349	3930.00	DC NO-662		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
825	PUR_32_1018	Purchase	2026-05-14	1282	11505.00	INVOICE NO-SA/26-27/30		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
826	PAY_151_1030	Payment	2026-05-20	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
827	PAY_152_1031	Payment	2026-05-20	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
828	PAY_153_1032	Payment	2026-05-20	1387	11505.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
829	PUR_33_1033	Purchase	2026-05-20	1379	33984.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
830	PAY_154_1034	Payment	2026-05-20	1387	33984.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
831	PAY_155_1035	Payment	2026-05-20	1387	1860.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
832	PAY_156_1036	Payment	2026-05-20	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
833	PUR_34_1037	Purchase	2026-05-20	1551	4200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
834	PUR_35_1038	Purchase	2026-05-20	1551	4500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
835	PAY_157_1039	Payment	2026-05-20	1387	4200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
836	PAY_158_1082	Payment	2026-05-21	1425	1400.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
837	PAY_159_1098	Payment	2026-05-22	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
838	PAY_160_1121	Payment	2026-05-22	1425	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
839	PUR_36_1122	Purchase	2026-05-22	1633	56994.00	INVOICE NO 26-27/INV-127		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
840	PUR_37_1208	Purchase	2026-05-27	1379	33984.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
841	PAY_161_1239	Payment	2026-05-27	1425	33984.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
842	PAY_162_1240	Payment	2026-05-27	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
843	PAY_163_1241	Payment	2026-05-27	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
844	PUR_38_1242	Purchase	2026-05-21	1551	6000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
845	PAY_164_1243	Payment	2026-05-27	1425	6000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
846	PAY_165_1244	Payment	2026-05-27	1425	2100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
847	PAY_166_1245	Payment	2026-05-27	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
851	PAY_168_1301	Payment	2026-05-29	1425	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
852	PAY_169_1302	Payment	2026-05-29	1425	600.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
853	PAY_170_1303	Payment	2026-05-29	1425	180.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
854	PAY_171_1304	Payment	2026-05-29	1387	137060.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
855	PAY_172_1305	Payment	2026-05-29	1425	3800.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
856	PAY_173_1311	Payment	2026-05-29	1425	150.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
857	PUR_40_1312	Purchase	2026-05-28	1551	16500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
848	REC_7_1259	Receipt	2026-05-27	1387	264360.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
849	PUR_39_1271	Purchase	2026-05-28	1675	24500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
850	PAY_167_1272	Payment	2026-05-28	1425	24500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
858	PUR_41_1341	Purchase	2026-05-30	1379	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
859	PAY_174_1342	Payment	2026-05-30	1425	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
860	PUR_42_1393	Purchase	2026-06-03	1349	68558.00	BILL NO 3869		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
861	PAY_175_1394	Payment	2026-06-03	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
862	PUR_43_1395	Purchase	2026-06-30	1379	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
863	PAY_176_1396	Payment	2026-06-05	1387	16992.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
864	PAY_177_1397	Payment	2026-06-03	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
866	PAY_178_1399	Payment	2026-06-03	1387	35000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
867	PAY_179_1400	Payment	2026-06-03	1387	8250.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
868	PAY_180_1401	Payment	2026-06-05	1425	1175.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
865	PUR_44_1398	Purchase	2026-06-01	1665	76300.00	Invoice No.08 Dated 29/05/2026		\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
869	REC_8_1484	Receipt	2026-06-03	1387	255389.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
870	PUR_45_1532	Purchase	2026-06-09	1379	22656.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
871	PUR_46_1533	Purchase	2026-06-06	1633	56994.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
872	PAY_181_1563	Payment	2026-06-10	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
873	PAY_182_1564	Payment	2026-06-10	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
874	PAY_183_1565	Payment	2026-06-10	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
875	PAY_184_1566	Payment	2026-06-10	1387	1701.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
876	PAY_185_1596	Payment	2026-06-08	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
877	PAY_186_1597	Payment	2026-06-13	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
878	PAY_187_1598	Payment	2026-06-13	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
879	PAY_188_1599	Payment	2026-06-13	1425	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
880	PAY_189_1600	Payment	2026-06-08	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
881	PAY_190_1601	Payment	2026-06-09	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
882	PAY_191_1602	Payment	2026-06-09	1425	400.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
883	PAY_192_1603	Payment	2026-06-09	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
884	PAY_193_1604	Payment	2026-06-10	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
885	PAY_194_1605	Payment	2026-06-10	1425	150.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
886	PAY_195_1606	Payment	2026-06-11	1425	300.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
887	PAY_196_1607	Payment	2026-06-10	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
888	PAY_197_1608	Payment	2026-06-12	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
889	PAY_198_1609	Payment	2026-06-12	1425	700.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
890	PAY_199_1610	Payment	2026-06-12	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
891	PAY_200_1663	Payment	2026-06-17	1387	13982.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
892	PAY_201_1664	Payment	2026-06-17	1387	28497.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
893	PAY_202_1665	Payment	2026-06-17	1387	10000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
894	PAY_203_1666	Payment	2026-06-17	1387	1901.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
895	PUR_47_1676	Purchase	2026-06-12	1379	28320.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
896	PAY_204_1677	Payment	2026-06-12	1387	28320.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
897	PAY_205_1678	Payment	2026-06-09	1387	22656.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
898	PUR_48_1696	Purchase	2026-06-19	1379	28320.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
899	PAY_206_1697	Payment	2026-06-19	1387	28320.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
900	PUR_49_1764	Purchase	2026-06-18	1551	8250.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
901	PUR_50_1765	Purchase	2026-06-16	1349	28108.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
902	PAY_207_1782	Payment	2026-06-20	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
903	PAY_208_1783	Payment	2026-06-20	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
904	PAY_209_1784	Payment	2026-06-22	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
905	PAY_210_1785	Payment	2026-06-20	1425	1000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
906	PAY_211_1786	Payment	2026-06-23	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
907	PAY_212_1787	Payment	2026-06-23	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
908	PAY_213_1788	Payment	2026-06-23	1425	250.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
909	PAY_214_1789	Payment	2026-06-24	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
910	PAY_215_1790	Payment	2026-06-23	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
916	PAY_221_1863	Payment	2026-06-26	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
917	PAY_222_1864	Payment	2026-06-26	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
918	PAY_223_1865	Payment	2026-06-25	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
911	PAY_216_1808	Payment	2026-06-24	1387	20000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
912	PAY_217_1809	Payment	2026-06-24	1387	8250.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
913	PAY_218_1860	Payment	2026-06-25	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
914	PAY_219_1861	Payment	2026-06-25	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
915	PAY_220_1862	Payment	2026-06-26	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
930	PAY_231_2013	Payment	2026-06-27	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
931	PAY_232_2014	Payment	2026-06-27	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
932	PAY_233_2015	Payment	2026-06-27	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
933	PAY_234_2016	Payment	2026-07-29	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
934	PAY_235_2017	Payment	2026-06-29	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
935	PAY_236_2018	Payment	2026-06-29	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
936	PAY_237_2019	Payment	2026-06-29	1425	430.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
937	PAY_238_2020	Payment	2026-06-30	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
938	PAY_239_2021	Payment	2026-06-30	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
939	PAY_240_2022	Payment	2026-06-30	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
940	PAY_241_2023	Payment	2026-06-30	1425	100.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
941	PAY_242_2024	Payment	2026-07-01	1425	400.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
942	PAY_243_2025	Payment	2026-07-01	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
943	PAY_244_2026	Payment	2026-07-01	1425	2000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
944	PAY_245_2027	Payment	2026-07-01	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
945	PAY_246_2028	Payment	2026-07-01	1425	1000.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
946	PAY_247_2029	Payment	2026-07-02	1425	400.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
947	PAY_248_2030	Payment	2026-07-02	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
948	PAY_249_2031	Payment	2026-07-03	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
949	PAY_250_2032	Payment	2026-07-03	1425	200.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
950	PAY_251_2033	Payment	2026-07-03	1425	500.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
951	REC_9_2052	Receipt	2026-06-10	1387	231651.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
952	REC_10_2053	Receipt	2026-06-24	1387	380434.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
953	REC_11_2054	Receipt	2026-06-17	1387	224928.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
954	PUR_55_2055	Purchase	2026-07-04	1633	22302.00			\N	2026-08-03 14:42:20.313529	2026-08-03 14:42:20.313529
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.company (id, name, address, city, state, pincode, phone, mobile, email, gstin, pan, tan, financial_year_start_month, logo_path, created_at, updated_at) FROM stdin;
1	SRI METAL	S.F NO 497/2 BHARATHI STREET CHINNAVEDAMPATTY	COIMBATORE	Tamilnadu	641049			srimetal6email@gmail.com	\N	\N	\N	4	\N	2026-08-03 14:42:06.73539+00	2026-08-03 14:42:06.73539+00
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
67	Duties & Taxes	73	Liability	f	2026-08-03 14:42:06.849214+00
68	Fixed Assets	68	Liability	f	2026-08-03 14:42:06.849214+00
69	Current Assets	69	Liability	f	2026-08-03 14:42:06.849214+00
70	Cash & Bank	70	Liability	f	2026-08-03 14:42:06.849214+00
71	Capital Accounts	71	Liability	f	2026-08-03 14:42:06.849214+00
72	Loans (Liabilities)	72	Liability	f	2026-08-03 14:42:06.849214+00
73	Current Liabilities	73	Liability	f	2026-08-03 14:42:06.849214+00
74	Incomes	74	Liability	f	2026-08-03 14:42:06.849214+00
75	Expenses	75	Liability	f	2026-08-03 14:42:06.849214+00
76	Deposits (Assets)	69	Liability	f	2026-08-03 14:42:06.849214+00
77	Loans & Advances (Assets)	69	Liability	f	2026-08-03 14:42:06.849214+00
78	Misc. expenses (Assets)	69	Liability	f	2026-08-03 14:42:06.849214+00
79	Sundry Debtors	69	Liability	f	2026-08-03 14:42:06.849214+00
80	Suppliers	69	Liability	f	2026-08-03 14:42:06.849214+00
81	Investments	69	Liability	f	2026-08-03 14:42:06.849214+00
82	Salary Advance (Assets)	69	Liability	f	2026-08-03 14:42:06.849214+00
83	Contractor Advance (Assets)	69	Liability	f	2026-08-03 14:42:06.849214+00
84	Bank Accounts	70	Liability	f	2026-08-03 14:42:06.849214+00
85	Cash In Hand	70	Liability	f	2026-08-03 14:42:06.849214+00
86	Reserves & Surplus	71	Liability	f	2026-08-03 14:42:06.849214+00
87	Secured Loans	72	Liability	f	2026-08-03 14:42:06.849214+00
88	Unsecured Loans	72	Liability	f	2026-08-03 14:42:06.849214+00
89	Bank O.D A/c	72	Liability	f	2026-08-03 14:42:06.849214+00
90	Provisions	73	Liability	f	2026-08-03 14:42:06.849214+00
91	Sundry Creditors	73	Liability	f	2026-08-03 14:42:06.849214+00
92	Sales Account	74	Liability	f	2026-08-03 14:42:06.849214+00
93	Labour Bill Account	74	Liability	f	2026-08-03 14:42:06.849214+00
94	Loading And UnLoading Charges (Income)	74	Liability	f	2026-08-03 14:42:06.849214+00
95	Purchase Account	75	Liability	f	2026-08-03 14:42:06.849214+00
96	Salary Expenses	75	Liability	f	2026-08-03 14:42:06.849214+00
97	Contractor Expenses	75	Liability	f	2026-08-03 14:42:06.849214+00
98	Fuel Expenses	75	Liability	f	2026-08-03 14:42:06.849214+00
99	Mobile Charges	75	Liability	f	2026-08-03 14:42:06.849214+00
\.


--
-- Data for Name: ledgers; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.ledgers (id, name, ledger_code, group_id, ledger_type, opening_balance, balance_type, phone, mobile, address, city, pincode, state, gstin, pan, bank_name, bank_account_no, bank_ifsc, designation, department, basic_salary, join_date, is_active, created_at, updated_at) FROM stdin;
1263	TEXMO INDUSTRIES  PUMP DIVISION	15	80	Account	0.00	Dr			THUDIYALUR POST	\N	\N	\N	33432020074	33AABFT1899B1ZC	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1264	TEXMO INDUSTRIES MOTOR DIVISION	19	80	Account	0.00	Dr			GNANAMBIKAI MILL POST MTP ROAD	\N	\N	\N	33432020074		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1265	V.KAVITHA - (Staff Advance)	20	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1266	V.KAVITHA - (Staff Salary)	21	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1267	SHIVA KUMAR - (Staff Advance)	22	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1268	SHIVA KUMAR - (Staff Salary)	23	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1269	MARI MUTHU RAMAKRISHNAN - (Contractor Advance)	24	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1270	MARI MUTHU RAMAKRISHNAN - (Job Work Payment)	25	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1271	GAJARAJ - (Staff Advance)	30	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1272	GAJARAJ - (Staff Salary)	31	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1273	PINTHU KUMAR - (Contractor Advance)	36	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1274	PINTHU KUMAR - (Job Work Payment)	37	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1275	LVB A/C 0192611000000430	48	84	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1276	LVB  C/A 0350360000000374	49	84	Account	0.00	Dr			KK PUDUR	\N	\N	\N			\N	0350360000000374	\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1277	LVB S/A. 0192301000056540	50	84	Account	0.00	Dr			GOUNDAMPALAYAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1278	IOB L/A. 013103401400008	51	84	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1279	IGST	239	67	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1280	CGST	240	67	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1281	SGST	241	67	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1282	SAS SHOTS	325	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1283	AUTO OR TEMPO RENT	326	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1284	COMPRESSOR EXPENSES	327	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1285	CAMERA EXPENSES	328	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1286	BABU RAJESH - (Staff Advance)	329	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1287	BABU RAJESH - (Staff Salary)	330	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1288	ELECTRICAL WORK	331	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1289	KRISHANA    GRINDING - (Contractor Advance)	332	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1290	KRISHANA    GRINDING - (Job Work Payment)	333	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1291	MADHAN GRINDING - (Contractor Advance)	334	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1292	CHANDRU (CHIPPING) - (Contractor Advance)	407	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1293	CHANDRU (CHIPPING) - (Job Work Payment)	408	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1294	Sanjai Helper - (Contractor Advance)	545	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1295	IOB C/A. 0192301000056540	52	84	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1296	MOHAN RAJ SRINIVASAN	53	71	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1297	MOHAN RAJ.S	54	91	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1298	MADHAN GRINDING - (Job Work Payment)	335	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1299	SUPER CUT	336	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1300	GRINDING STONE	337	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1301	MAINTANCE EXPENSES	338	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1302	RAVI WELDING	339	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1303	ARUMUGAM GRINDING - (Contractor Advance)	340	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1304	ARUMUGAM GRINDING - (Job Work Payment)	341	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1305	HOUSE KEEPING	342	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1306	FINECAST INDUSTRIES	343	80	Account	0.00	Dr			18/11 THADAGAM ROAD KNG PUDUR	\N	\N	\N	33AAAFF9592J1Z4	33AAAFF9592J1Z4	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1307	Deepak Helper - (Contractor Advance)	344	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1308	Deepak Helper - (Job Work Payment)	345	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1309	Babu Driver - (Staff Advance)	346	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1310	Babu Driver - (Staff Salary)	347	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1311	KOUSAL - (Contractor Advance)	348	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1312	KOUSAL - (Job Work Payment)	349	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1313	TATA VECHILE	350	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1314	JS AUTO CAST FOUNDRY INDIA PRIVATE LIMITED	351	80	Account	0.00	Dr			PLOT NO KK5,KK7 SIPCOT INDUSTRIES GROWTH CENTRE PERUNDURAI	\N	\N	\N	33AABCJ4470D1ZZ	33AABCJ4470D1ZZ	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1315	LUNCH EXPENSES	73	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1316	TEA	74	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1317	E.B	75	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1318	RENT	76	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1319	BANK CHARGES	77	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1320	TDS	78	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1321	T.V BROS	79	91	Account	0.00	Dr	04222398074	04222398074	500, R G STREET	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1322	UNIVERSAL PAINTS	80	91	Account	0.00	Dr	9843045547	9843045547	5/229, KNG PUDUR ROAD, THADAGAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1323	PURCHASE ACCOUNT	81	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1324	SOFTWARE PURCHASE	82	69	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1325	SALARY	83	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1326	TN 07 F 7090	84	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1327	TEXMO INDUSTRIES (SBL)	85	80	Account	0.00	Dr			THUDIYALUR ROAD	\N	\N	\N	33432020074		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1328	EDDY CURRENT	86	80	Account	0.00	Dr			5/233,KNG PUDUR SOMAYAMPALAYAM	\N	\N	\N	33266200237		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1329	EM EM	89	80	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1330	THAMBI DURAI - (Staff Advance)	90	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1331	THAMBI DURAI - (Staff Salary)	91	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1332	TANK WATER	92	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1333	GRACE CAST ALLOYS	352	80	Account	0.00	Dr			5/371-3F3 KNG PUDUR COIMBATORE	\N	\N	\N		33HWLPD7795B1ZA	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1334	Sri Krishna Equipment	353	80	Account	0.00	Dr			305, Lakshmi Nagar Vadavalli Road Edayarpalayam	\N	\N	\N	33DNJPS4380C1ZY	33DNJPS4380C1ZY	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1335	LABOUR WELFARE	93	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1336	MISCELLANEOUS EXP	94	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1337	BEARING	95	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1338	LVB INTREST	96	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1339	APPLE METAL	97	80	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1340	SAI MULTY PUMPS	98	80	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1341	KHAJA - (Contractor Advance)	99	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1342	KHAJA - (Job Work Payment)	100	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1343	ALAMU LODGE A/C	101	91	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1344	HOSPITAL EXPENSES	102	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1345	MOTOR MAINTANCE	103	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1346	KARPAGAM METAL	104	80	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1347	TN 66 M 5757	105	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1348	SALARY EXPENSES	106	92	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1349	V.S.AGENCIES	107	91	Account	0.00	Dr			142/238,SHIDDIVINAGAR STREET, COIMBATORE	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1350	PETROL EXPENSES	108	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1351	STATIONERS	109	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1352	PARAMESWARI FOOD PRODUCTS	110	91	Account	0.00	Dr	9843090905	9843090905	55A, BHARATHI ROAD TELUNGUPALAYAM PUDUR COIMBATORE	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1353	RUKMANI CAST ALLOYS	111	80	Account	0.00	Dr	04222404649	04222404649	568, KUPPANAICKAN ROAD, 3RD CROSS SOMAYAMPALAYAM	\N	\N	\N	33616203391		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1354	KARTHICK GRINDING - (Contractor Advance)	354	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1355	SANTHI CASTING	430	80	Account	0.00	Dr			SF NO 415&416 DOOR NO 2/229 NARASIMMANAICKENPALAYAM POST,KURUDAMPALAYAM VILLAG	\N	\N	\N		33ADPFS8454C1ZU	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1356	TELEPHONE BILL	114	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1357	JAGATHSHREE CASTINGS	115	80	Account	0.00	Dr			404/1B2 VADAVALLI KANUVAI ROAD,SOMAYAMPALAYAM	\N	\N	\N	33376202553	33BZZPR7759G1ZC	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1358	VIGNESHWARE AGENCIES	116	91	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1359	WASTE SAND	117	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1360	ANNAI ENGINEERING	118	80	Account	0.00	Dr			11/10 KAUNDAMPALAYAM EDAYARPALATYAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1361	PINDU KUMAR - (Contractor Advance)	119	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1362	PINDU KUMAR - (Job Work Payment)	120	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1363	GUN METAL	121	80	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1364	KSR COTTAGE INDUSTRIES	122	80	Account	0.00	Dr			1/99 VELAMMAL COLONY NGGO COLONY POST	\N	\N	\N	33112026264		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1365	GLOUSE	123	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1366	SRI METALS - (Contractor Advance)	124	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1367	SRI METALS - (Job Work Payment)	125	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1368	KAVITHA	126	91	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1369	POOJA EXPENSES	127	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1370	BUILDING EXPENSES (NEW)	128	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1371	MACHINE ERECTION	129	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1372	LOADING & UNLOADING	130	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1373	KARTHICK GRINDING - (Job Work Payment)	355	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1374	Ankit Kumar - (Contractor Advance)	356	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1375	Ankit Kumar - (Job Work Payment)	357	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1376	Eicher Rent	141	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1377	RAMESH GRINDING - (Contractor Advance)	142	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1378	RAMESH GRINDING - (Job Work Payment)	143	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1379	GRAND POLYCOATS COMPANY PVT LTD	144	91	Account	0.00	Dr	04224200801	04224200801	79, VENKATASAMY ROAD WEST R.S. PURAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1380	GOODLUCK PAINTS & CHEMICALS	145	91	Account	0.00	Dr	04222552115	04222552115	15/11 C PONNUSAMY STREET,METTUPALAYAM ROAD R.S PURAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1381	PRINTING & STATIONARY	148	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1382	GEEKAY ENGG (Steel Shots )	149	91	Account	0.00	Dr	9750917896	9750917896	542/2 COSMOFAN FOUNDRY, ARASUR	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1383	ANAND GRINDING - (Contractor Advance)	257	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1384	ANAND GRINDING - (Job Work Payment)	258	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1385	SARVAN GRINDIND - (Contractor Advance)	259	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1386	SARVAN GRINDIND - (Job Work Payment)	260	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1387	HDFC SRI METAL	261	84	Account	0.00	Dr				\N	\N	\N			\N	50200080117707	\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1388	MIDAS GLOUSE	262	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1389	LODING GLOUSE	263	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1390	AUGISTIAN - (Contractor Advance)	264	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1391	AUGISTIAN - (Job Work Payment)	265	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1392	MARI MUTHU GRINDING - (Contractor Advance)	266	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1393	MARI MUTHU GRINDING - (Job Work Payment)	267	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1394	MOUNT POINT STONE	268	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1395	JOTHI ENTERPRISES	323	80	Account	0.00	Dr			1-12 P25E, A.T.S NAGAR EXTENSION GANDHIGRAM	\N	\N	\N		33AERPN9276QIZB	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1396	GST SRI METAL	577	67	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1397	YES BANK	578	84	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1398	SELVAM (MELTER) - (Contractor Advance)	579	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1399	SELVAM (MELTER) - (Job Work Payment)	580	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1400	RAJIV (MELTER) - (Contractor Advance)	581	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1401	RAJIV (MELTER) - (Job Work Payment)	582	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1402	SANKAR (SELVAM MELTER) - (Contractor Advance)	583	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1403	SANKAR (SELVAM MELTER) - (Job Work Payment)	584	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1404	ANKIT KUMAR (BRIENDAR) - (Contractor Advance)	458	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1405	ANKIT KUMAR (BRIENDAR) - (Job Work Payment)	459	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1406	MANIKANDAN (GRINDING) - (Contractor Advance)	460	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1407	MANIKANDAN (GRINDING) - (Job Work Payment)	461	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1408	RAGUL (BRINDER) - (Contractor Advance)	462	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1409	RAGUL (BRINDER) - (Job Work Payment)	463	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1410	ANAND (GRINDING) - (Contractor Advance)	464	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1411	ANAND (GRINDING) - (Job Work Payment)	465	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1412	SURAJ (HINDI) - (Contractor Advance)	466	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1413	SURAJ (HINDI) - (Job Work Payment)	467	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1414	MD INTHA(HINDI) - (Contractor Advance)	468	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1415	MD INTHA(HINDI) - (Job Work Payment)	469	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1416	SIVAGURUNATHAN - (Contractor Advance)	470	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1417	SIVAGURUNATHAN - (Job Work Payment)	471	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1418	SHAKIL (HINDI) - (Contractor Advance)	472	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1419	SHAKIL (HINDI) - (Job Work Payment)	473	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1420	GURU (CRANE) - (Contractor Advance)	476	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1421	GURU (CRANE) - (Job Work Payment)	477	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1422	DISEAL	478	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1423	GANESH (MARI MUTHU) HELPER - (Contractor Advance)	585	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1424	GANESH (MARI MUTHU) HELPER - (Job Work Payment)	586	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1425	Cash	1	85	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1426	Profit & Loss A/c	2	86	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1427	Transport Charges	3	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1428	Round Off	4	74	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1429	PRAKASH CASTING	156	80	Account	0.00	Dr			2/323,A2,GCT NAGAR,KASTHURINAPALAYAM, VADAVALLI	\N	\N	\N	33696206839		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1430	SAKTHIVEL - (Contractor Advance)	157	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1431	SAKTHIVEL - (Job Work Payment)	158	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1432	KUMAR - (Contractor Advance)	159	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1433	KUMAR - (Job Work Payment)	160	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1434	AREMPEE COMPRESSORS PVT.LTD	161	80	Account	0.00	Dr			KANUVAI	\N	\N	\N	33936203409		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1435	P.MAHAKRISHNAN - (Contractor Advance)	162	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1436	P.MAHAKRISHNAN - (Job Work Payment)	163	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1437	Manish Kumar - (Contractor Advance)	358	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1438	Manish Kumar - (Job Work Payment)	359	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1439	Dinanath Kumar - (Contractor Advance)	360	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1440	MODI HELPER - (Contractor Advance)	587	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1441	MADHESWARAN - (Contractor Advance)	500	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1442	MADHESWARAN - (Job Work Payment)	501	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1443	SATHISH - (Contractor Advance)	502	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1444	SATHISH - (Job Work Payment)	503	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1445	MOHAMAAD - (Contractor Advance)	504	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1446	MOHAMAAD - (Job Work Payment)	505	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1447	THESER HINDHI HELPER - (Contractor Advance)	506	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1448	THESER HINDHI HELPER - (Job Work Payment)	507	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1449	MOHAMAAD NAZUREL - (Contractor Advance)	508	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1450	MOHAMAAD NAZUREL - (Job Work Payment)	509	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1451	PRAWEZ ALAM - (Contractor Advance)	510	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1452	PRAWEZ ALAM - (Job Work Payment)	511	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1453	MAKESH HELPER - (Contractor Advance)	512	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1454	MAKESH HELPER - (Job Work Payment)	513	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1455	ANITHA HELPER - (Contractor Advance)	514	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1456	ANITHA HELPER - (Job Work Payment)	515	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1457	DHANANJAY - (Contractor Advance)	516	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1458	DHANANJAY - (Job Work Payment)	517	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1459	ISRAFUL - (Contractor Advance)	518	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1460	ISRAFUL - (Job Work Payment)	519	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1461	GOBI NATH - (Contractor Advance)	520	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1462	T.SATHISH KUMAR - (Staff Advance)	187	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1463	T.SATHISH KUMAR - (Staff Salary)	188	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1464	Generator	189	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1465	Forklift	190	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1466	NATRAJ AND CO	191	91	Account	0.00	Dr	2230825,4377480	2230825,4377480	450 DR.NANJAPPA ROAD	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1467	THE COSMAFAN MARKETING SOCIETY	192	91	Account	0.00	Dr	2561819	2561819	42-D,SNR COLLEGE ROAD, PEELAMEDU	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1468	AZA WATER	195	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1469	Dinanath Kumar - (Job Work Payment)	361	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1470	Ramesh Contract - (Contractor Advance)	362	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1471	Ramesh Contract - (Job Work Payment)	363	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1472	Kasi Muthu - (Contractor Advance)	364	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1473	Kasi Muthu - (Job Work Payment)	365	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1474	MODI HELPER - (Job Work Payment)	588	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1475	SKD SATHISH - (Contractor Advance)	589	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1476	SKD SATHISH - (Job Work Payment)	590	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1477	SURESH DRIVER - (Contractor Advance)	591	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1478	SURESH DRIVER - (Job Work Payment)	592	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1479	JITHENDAR GRINDING - (Contractor Advance)	593	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1480	JITHENDAR GRINDING - (Job Work Payment)	594	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1481	DUST COLLECTOR	595	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1482	RAPIDO	596	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1483	Naveena Agency	208	91	Account	0.00	Dr	9952482393	9952482393	8/16,Kk Lane No 2, Hirudaya Building,	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1484	HINDUSTAN FOUNDRY	215	80	Account	0.00	Dr	04222560383	04222560383	48.NAVAINDIA ROAD, S.S COMPLEX	\N	\N	\N	33852028961		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1485	VASANTH AGENCIES	378	80	Account	0.00	Dr			2/2,  STANES GARDEN, THUDIYALUR	\N	\N	\N		33AHGPG8472K1Z3	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1486	NATIONAL HARDWARES	379	91	Account	0.00	Dr	9894653889	9894653889	61/1 BHARATHIYAR ROAD MANIYAKARANPALAYAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1487	SELVAM (GRINDING) - (Contractor Advance)	380	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1488	SELVAM (GRINDING) - (Job Work Payment)	381	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1489	ANKIT (LABOUR) - (Contractor Advance)	382	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1490	ANKIT (LABOUR) - (Job Work Payment)	383	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1491	SWAMINATHAN	384	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1492	VECHILES MAINTANCE	385	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1493	Crain	597	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1494	Indra Kumar(Grinding) - (Contractor Advance)	598	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1495	Indra Kumar(Grinding) - (Job Work Payment)	599	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1496	KANNAN GRINDING - (Contractor Advance)	600	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1497	KANNAN GRINDING - (Job Work Payment)	601	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1498	ARUMUGAM GRINDING NEW - (Contractor Advance)	602	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1499	ARUMUGAM GRINDING NEW - (Job Work Payment)	603	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1500	MANDU - (Contractor Advance)	604	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1501	GOBI NATH - (Job Work Payment)	521	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1502	SARDAR - (Contractor Advance)	522	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1503	SARDAR - (Job Work Payment)	523	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1504	MD CHAND - (Contractor Advance)	524	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1505	MD CHAND - (Job Work Payment)	525	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1506	ANYAR RAIN - (Contractor Advance)	526	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1507	ANYAR RAIN - (Job Work Payment)	527	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1508	SADAM LABOUR - (Contractor Advance)	528	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1509	SADAM LABOUR - (Job Work Payment)	529	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1510	MADHAN LABOUR - (Contractor Advance)	530	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1511	MADHAN LABOUR - (Job Work Payment)	531	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1512	JABAR LABOUR - (Contractor Advance)	532	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1513	JABAR LABOUR - (Job Work Payment)	533	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1514	RAVI GRINDING - (Contractor Advance)	534	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1515	RAVI GRINDING - (Job Work Payment)	535	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1516	Ranjith - (Contractor Advance)	536	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1517	Ranjith - (Job Work Payment)	537	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1518	RAJA ACCOUNTANT - (Staff Advance)	538	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1519	RAJA ACCOUNTANT - (Staff Salary)	539	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1520	Diiser Helper - (Contractor Advance)	540	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1521	Diiser Helper - (Job Work Payment)	541	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1522	MUNISH - (Contractor Advance)	542	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1523	MUNISH - (Job Work Payment)	543	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1524	Sanjai Helper - (Job Work Payment)	546	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1525	GANESH (GRINDING) - (Contractor Advance)	547	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1526	GANESH (GRINDING) - (Job Work Payment)	548	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1527	PAPALU GRINDING - (Contractor Advance)	549	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1528	PAPALU GRINDING - (Job Work Payment)	550	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1529	ASIF GRINDING - (Contractor Advance)	551	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1530	ASIF GRINDING - (Job Work Payment)	552	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1531	RAMU GRINDING - (Contractor Advance)	553	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1532	RAMU GRINDING - (Job Work Payment)	554	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1533	VINOTH  CHIPPING - (Contractor Advance)	555	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1534	VINOTH  CHIPPING - (Job Work Payment)	556	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1535	PAINT	557	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1536	PRADEEP SINGH - (Contractor Advance)	558	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1537	PRADEEP SINGH - (Job Work Payment)	559	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1538	DIPTI - (Contractor Advance)	560	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1539	DIPTI - (Job Work Payment)	561	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1540	SARAVANAN (RAJA) - (Contractor Advance)	562	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1541	SARAVANAN (RAJA) - (Job Work Payment)	563	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1542	KRISHANAN (CHIPPING) - (Contractor Advance)	564	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1543	KRISHANAN (CHIPPING) - (Job Work Payment)	565	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1544	RAMESH CHIPPING - (Contractor Advance)	566	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1545	RAMESH CHIPPING - (Job Work Payment)	567	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1546	TEXMO INDUSTRIES (PUMP DIVISION)	568	80	Account	0.00	Dr			THUDIYALUR POST METTUPALAYAM ROAD	\N	\N	\N		33AABFT1899B1ZC	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1547	SELVALAKSHMI INDUSTRIES	569	80	Account	0.00	Dr			S.F NO26/1APPG NURSING COLLEGE BACKSIDE VKV KUMARAGURU NAGAR,KEERANATHAM ROAD,SARAVANAMPAT	\N	\N	\N		33AUBPK7362A1Z3	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1548	CHENNAI CAST ALLOYS	570	80	Account	0.00	Dr	9965405351	9965405351	498/1b2,1a2 BHARATHI STREET PUTTU THOTTAM,CHINNAVEDAMPATTI	\N	\N	\N		33AAVFC4616K1Z5	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1549	ASIAN FERRO CAST	571	80	Account	0.00	Dr			74,ATHIPALAYAM ROAD CHINNAVEDAMPATTI	\N	\N	\N		33ABMFA713B1ZX	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1550	SHRI MAHA VISHNU HI HEAT TREATER	572	80	Account	0.00	Dr			9/219 MASAGOUNDEN PALAYAM CHETTIPALAYAM POST KOVIL PALAYAM	\N	\N	\N		33DMKPS0705R1ZJ	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1551	MM TRADERS	573	80	Account	0.00	Dr			9/88-3,VIVEKANANDA NAGAR KURUMBAPALAYAM	\N	\N	\N		33AWWPD2196C1ZJ	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1552	SEENU INDUSTRIES	574	80	Account	0.00	Dr			24-A KK NAGAR,VG RAO NAGAR EB COLONY NEAR,GANAPATHY,	\N	\N	\N		33AWNPJ0817B1ZO	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1553	CONSTRUCATION EQUPIMENTS OWNERS ASSOCIATION	575	80	Account	0.00	Dr			SAMARPANIKA AUDITORIUM ATHIKODE	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1554	STAR ELETRICAL WOKS	576	80	Account	0.00	Dr			Sc/266 THANGAMMAL NAGAR LAKSHMIPURAM,GANAPATHY	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1555	MANDU - (Job Work Payment)	605	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1556	PALANISAMY (MELTER) - (Contractor Advance)	606	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1557	PALANISAMY (MELTER) - (Job Work Payment)	607	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1558	PRAMASIVAM (MELTER) - (Contractor Advance)	608	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1559	SURAN MODI HELPER - (Contractor Advance)	652	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1560	SURAN MODI HELPER - (Job Work Payment)	653	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1561	SUKHAN MODI HELPER - (Contractor Advance)	654	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1562	SUKHAN MODI HELPER - (Job Work Payment)	655	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1563	SUBHAM MODI HELPER - (Contractor Advance)	656	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1564	SUBHAM MODI HELPER - (Job Work Payment)	657	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1565	TAPAN MODI HELPER - (Contractor Advance)	658	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1566	TAPAN MODI HELPER - (Job Work Payment)	659	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1567	KAUTUKA MODI HELPER - (Contractor Advance)	660	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1568	KAUTUKA MODI HELPER - (Job Work Payment)	661	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1569	Kumar Modi Helper - (Contractor Advance)	662	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1570	Kumar Modi Helper - (Job Work Payment)	663	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1571	SANDRAM GRINDING - (Contractor Advance)	664	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1572	SANDRAM GRINDING - (Job Work Payment)	665	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1573	AKBAR GRINDING - (Contractor Advance)	666	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1574	AKBAR GRINDING - (Job Work Payment)	667	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1575	SURAJ  PAL GRINDING - (Contractor Advance)	668	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1576	SURAJ  PAL GRINDING - (Job Work Payment)	669	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1577	SRI KRISHNA FAFABRICATION	170	80	Account	0.00	Dr			334/1F SOMIYAMPALAYAM THADAGAM	\N	\N	\N	33436203005		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1578	KALYANASUNDRAM C - (Contractor Advance)	171	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1579	KALYANASUNDRAM C - (Job Work Payment)	172	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1580	ANBU SELVAM (GRINDING ) - (Contractor Advance)	175	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1581	ANBU SELVAM (GRINDING ) - (Job Work Payment)	176	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1582	SHRI EASWARA ENGINEERING COMPANY	179	80	Account	0.00	Dr			633,BETTATHAPURAM KARAMADAI POST	\N	\N	\N	33302030282		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1583	SOLAR FOUNDRY	180	80	Account	0.00	Dr			51,ARAVINDA NAGAR THADAGAM	\N	\N	\N	33596200201		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1584	M.Palaniswamy - (Staff Advance)	183	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1585	M.Palaniswamy - (Staff Salary)	184	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1586	CAN WATER	386	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1587	SELVAM	387	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1588	RAJAN  SALARY	388	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1589	OFFICE	389	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1590	Rajan  Grinding - (Contractor Advance)	390	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1591	Rajan  Grinding - (Job Work Payment)	391	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1592	Keerthi Room Rent	392	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1593	Mathi Driver - (Staff Advance)	393	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1594	Mathi Driver - (Staff Salary)	394	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1595	TEE Y LIFTING SOLUTIONS	395	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1596	ORIENT	396	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1597	GRINDING WHEEL	397	68	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1598	SRI SAKTHIVELAN INDUSTRIES	230	80	Account	0.00	Dr			SOMIYAMPALAYAM KNG PUDUR	\N	\N	\N	33496267671		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1599	ASHOK CONTRACT - (Contractor Advance)	231	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1600	ASHOK CONTRACT - (Job Work Payment)	232	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1601	SRI DHARSHINI MALLEABLE	233	80	Account	0.00	Dr	9843296216	9843296216	624/1A,THADAGAM ROAD AGARWALSCHOOL ROAD, SOMAYAMPALAYAM POST	\N	\N	\N	33636204156		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1602	ENBEST PUMPS INDIA PVT LTD	236	80	Account	0.00	Dr			NO,362/3,SOMAYAMPALAYAM COIMBATORE	\N	\N	\N	33286201380		\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1603	INTEGRA AUTOMATION PVT LTD UNIt IV	242	80	Account	0.00	Dr			S.F.NO238,KURUNALLIPALAYAM VILLAGE NEAR, KOTHAVAD VADACHITTUR VIA,	\N	\N	\N		33AAAC17412H1ZX	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1604	INTEGRA AUTOMATION PVT LTD METTUBAVI UNIT	243	80	Account	0.00	Dr			SF NO. 7, METULAKSHMINAYAKAMPALAYAM ROAD, METTUBAVI VILLAGE,KINATHUKAAVU TALUK,	\N	\N	\N		33AAACI7412H1ZX	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1605	SRI METAL	244	80	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1606	U CLAMP	398	68	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1607	GOPINATH - (Staff Advance)	399	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1608	GOPINATH - (Staff Salary)	400	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1609	RAVI CHANDRAN (GRINDING STONE)	401	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1610	RAJ KUMAR - (Contractor Advance)	402	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1611	RAJ KUMAR - (Job Work Payment)	403	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1612	PRAMASIVAM (MELTER) - (Job Work Payment)	609	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1613	RAJESH (MODI) - (Contractor Advance)	610	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1614	RAJESH (MODI) - (Job Work Payment)	611	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1615	MURUGESH (GRINDING) - (Contractor Advance)	612	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1616	SRI METAL PURCHASE	269	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1617	SM TRADERS	270	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1618	SARVAN  HINDI LABOUR	271	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1619	PINDHU KUMAR	272	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1620	SARVAN LABOUR	275	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1621	SARVAN HINDI  LABOUR - (Contractor Advance)	276	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1622	SARVAN HINDI  LABOUR - (Job Work Payment)	277	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1623	ANAND GRINDING1 - (Staff Advance)	281	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1624	ANAND GRINDING1 - (Staff Salary)	282	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1625	SARVAN GRINDING 1 - (Staff Advance)	283	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1626	SARVAN GRINDING 1 - (Staff Salary)	284	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1627	MURUGESH (GRINDING) - (Job Work Payment)	613	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1628	Dhanpathdass - (Contractor Advance)	614	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1629	Dhanpathdass - (Job Work Payment)	615	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1630	Anbu (Tea)	616	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1631	Sathish Skd - (Staff Advance)	617	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1632	Sathish Skd - (Staff Salary)	618	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1633	VM MINERALS	619	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1634	PRADEEP HELPER) MODI - (Contractor Advance)	620	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1635	PRADEEP HELPER) MODI - (Job Work Payment)	621	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1636	Rajiv (Father) - (Contractor Advance)	622	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1637	Rajiv (Father) - (Job Work Payment)	623	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1638	INDOTHERMTECHNOLOGIES	299	80	Account	0.00	Dr			2/55, MASAGOUNPUDUR,ELLAPALAYAM PO KATTAMPATTY	\N	\N	\N		33AAFF11997K1Z1	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1639	MAHALAKSHMI INDUSTRIES	302	80	Account	0.00	Dr			THIRUVASAKAM STREET VINAYAGAPURAM	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1640	33	305	80	Account	0.00	Dr	04222642484	04222642484	254/1,258/1,CHINNAKUYALI,KALLAPALAYAM(PO) ONDIPUDUR(VIA)	\N	\N	\N	33AADFA80281Z9	33AADFA8028P1Z9	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1641	BALU SCRAP	306	91	Account	0.00	Dr			UYIUYUIY UIYIUYI	\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1642	CI BOARINGS	307	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1643	PASANTH KUMAR (PAINTER) - (Contractor Advance)	624	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1644	PASANTH KUMAR (PAINTER) - (Job Work Payment)	625	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1645	Acting Driver	626	78	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1646	SRIDHU MODI HELPER - (Contractor Advance)	627	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1647	SRIDHU MODI HELPER - (Job Work Payment)	628	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1648	BALA MODI HELPER - (Contractor Advance)	629	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1649	BALA MODI HELPER - (Job Work Payment)	630	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1650	MAKESH KISHNA HELPER - (Contractor Advance)	631	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1651	MAKESH KISHNA HELPER - (Job Work Payment)	632	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1652	INDRA DEV RAJIV HELPER - (Contractor Advance)	633	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1653	INDRA DEV RAJIV HELPER - (Job Work Payment)	634	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1654	DIAMOND EQUIPMENTS & ENGINEERS	635	80	Account	0.00	Dr	908790660	908790660	D.NO-17/2 BHARATHI NAGAR 4TH STREETKRISHNARAYAPURAM	\N	\N	\N		33BLPPM0067E1Z8	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1655	KRISHNA CCA - (Contractor Advance)	636	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1656	KRISHNA CCA - (Job Work Payment)	637	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1657	TANDEM ENTERPRISES	322	80	Account	0.00	Dr			SF 245/1 , ORAIKKALAPALAYAM ROAD KUNNATHUR, SS KULAM	\N	\N	\N		33AADFT0017H1ZQ	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1658	SHOTS	324	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1659	ANAND DRIVER - (Staff Advance)	404	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1660	ANAND DRIVER - (Staff Salary)	405	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1661	COMPUTER AND ACCESSORIES	406	68	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1662	RAJ KUMAR (COMPANY)	410	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1663	SELVAM (COMPANY)	411	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1664	ANKIT (COMPANY)	412	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1665	RAJESH RENT	638	75	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1666	DRINKING WATER	639	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1667	KAVITHA 1 - (Staff Advance)	640	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1668	KAVITHA 1 - (Staff Salary)	641	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1669	GUNA SELVAM - (Contractor Advance)	642	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1670	GUNA SELVAM - (Job Work Payment)	643	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1671	HARI HELPER - (Contractor Advance)	644	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1672	HARI HELPER - (Job Work Payment)	645	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1673	MAKESH DRIVER - (Contractor Advance)	646	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1674	MAKESH DRIVER - (Job Work Payment)	647	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1675	YAZHINI ENTERPRISES	648	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1676	GREEN ENERGY TRANSPORT	649	80	Account	0.00	Dr			PLOT NO 6,ROJA NAGAR FIRST STRET SILAPADAI	\N	\N	\N		33GMXPM5480D1ZK	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1677	JITHENDAR CCA - (Contractor Advance)	650	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1678	JITHENDAR CCA - (Job Work Payment)	651	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1679	SANJEEV (COMPANY)	413	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1680	JANARTHAN	414	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1681	LAKSHMI (COMPANY)	415	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1682	SANJEEV - (Contractor Advance)	416	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1683	SANJEEV - (Job Work Payment)	417	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1684	JANARTHAN (COMPANY) - (Contractor Advance)	418	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1685	JANARTHAN (COMPANY) - (Job Work Payment)	419	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1686	LAKSHMI - (Contractor Advance)	420	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1687	LAKSHMI - (Job Work Payment)	421	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1688	RAHUL - (Staff Advance)	422	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1689	RAHUL - (Staff Salary)	423	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1690	RANJITHA - (Staff Advance)	424	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1691	RANJITHA - (Staff Salary)	425	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1692	MARIMUTHU (WATCH MAN) - (Contractor Advance)	426	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1693	MARIMUTHU (WATCH MAN) - (Job Work Payment)	427	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1694	MARIMUTHU - (Staff Advance)	428	82	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1695	MARIMUTHU - (Staff Salary)	429	96	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1696	M.D. CHAND	431	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1697	VENKATESH GRINDING - (Contractor Advance)	432	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1698	VENKATESH GRINDING - (Job Work Payment)	433	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1699	EASWAR (BRINDAR) - (Contractor Advance)	434	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1700	EASWAR (BRINDAR) - (Job Work Payment)	435	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1701	KABU - (Contractor Advance)	436	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1702	KABU - (Job Work Payment)	437	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1703	RAJESH - (Contractor Advance)	438	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1704	RAJESH - (Job Work Payment)	439	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1705	AJITH KUMAR - (Contractor Advance)	440	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1706	AJITH KUMAR - (Job Work Payment)	441	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1707	SELVAM LABOUR - (Contractor Advance)	442	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1708	SELVAM LABOUR - (Job Work Payment)	443	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1709	DEEPAK LABOUR - (Contractor Advance)	444	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1710	DEEPAK LABOUR - (Job Work Payment)	445	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1711	IBHARIM - (Contractor Advance)	446	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1712	IBHARIM - (Job Work Payment)	447	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1713	VENKATESH LABOUR - (Contractor Advance)	448	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1714	VENKATESH LABOUR - (Job Work Payment)	449	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1715	PRABU LABOUR - (Contractor Advance)	450	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1716	PRABU LABOUR - (Job Work Payment)	451	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1717	SELVAM (SHIVA) - (Contractor Advance)	453	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1718	SELVAM (SHIVA) - (Job Work Payment)	454	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1719	AJEES A/C MECHANIC	455	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1720	SELVAM AQUA SUB	456	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1721	BABU AGENCIES	457	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1722	SRI SAKTHI VADIVELAN INDUSTRIES	479	80	Account	0.00	Dr			399/1B SOMAYAMPALAYAM THADAGAM ROAD	\N	\N	\N		33AEXPA2369F1ZH	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1723	AIRWA	480	80	Account	0.00	Dr			367,V.K ROAD, THANNERPANDAL PEELAMEDU	\N	\N	\N		33DADPS8282N1ZZ	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1724	MAHABULLA HINDI LABOUR	482	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1725	MAHABULLA HINDHI LABOUR - (Contractor Advance)	483	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1726	MAHABULLA HINDHI LABOUR - (Job Work Payment)	484	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1727	SANTHOSH (WATER)	485	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1728	DHARSAHINI MANABALES	486	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1729	HOISTER	487	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1730	FAN	488	95	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1731	SANJAI SAMY HINDHI CONTRACTOR	489	94	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1732	ARUN - (Contractor Advance)	490	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1733	ARUN - (Job Work Payment)	491	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1734	JAYARAM - (Contractor Advance)	492	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1735	JAYARAM - (Job Work Payment)	493	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1736	MUNISHWARAN - (Contractor Advance)	494	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1737	MUNISHWARAN - (Job Work Payment)	495	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1738	MURALI - (Contractor Advance)	496	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1739	MURALI - (Job Work Payment)	497	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1740	ROHIT - (Contractor Advance)	498	83	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1741	ROHIT - (Job Work Payment)	499	97	Account	0.00	Dr				\N	\N	\N			\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:06.911725+00	2026-08-03 14:42:06.911725+00
1742	MARI MUTHU RAMAKRISHNAN	CON_1	83	Contractor	0.00	Dr			8/181, DEVARAJ NAGAR, KEERANATHAM PUDHU PALAYAM	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1743	PINTHU KUMAR	CON_4	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1744	KHAJA	CON_20	83	Contractor	0.00	Dr	9655744542	9655744542	64 E ,KARAMBU KADAI, CHERAN NAGAR	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1745	PINDU KUMAR	CON_22	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1746	SRI METALS	CON_23	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1747	KRISHANA    GRINDING	CON_68	83	Contractor	0.00	Dr	6387378764	6387378764		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1748	MADHAN GRINDING	CON_69	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1749	ARUMUGAM GRINDING	CON_70	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1750	Deepak Helper	CON_71	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1751	KOUSAL	CON_72	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1752	KARTHICK GRINDING	CON_73	83	Contractor	0.00	Dr	9787130680	9787130680	18, RAMASWAMY GOUNDER STREET RATHINAPURI	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1753	Ankit Kumar	CON_74	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1754	Manish Kumar	CON_75	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1755	Dinanath Kumar	CON_76	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1756	Ramesh Contract	CON_77	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1757	Kasi Muthu	CON_78	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1758	SELVAM (GRINDING)	CON_79	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1759	ANKIT (LABOUR)	CON_80	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1760	Rajan  Grinding	CON_81	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1761	RAJ KUMAR	CON_82	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1762	CHANDRU (CHIPPING)	CON_83	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1763	SANJEEV	CON_84	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1764	JANARTHAN (COMPANY)	CON_85	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1765	LAKSHMI	CON_86	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1766	MARIMUTHU (WATCH MAN)	CON_87	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1767	KANNAN GRINDING	CON_155	83	Contractor	0.00	Dr	7339505806	7339505806		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1768	ARUMUGAM GRINDING NEW	CON_156	83	Contractor	0.00	Dr	9363132301	9363132301		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1769	MANDU	CON_157	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1770	PALANISAMY (MELTER)	CON_158	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1771	PRAMASIVAM (MELTER)	CON_159	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1772	RAJESH (MODI)	CON_160	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1773	MURUGESH (GRINDING)	CON_161	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1774	Dhanpathdass	CON_162	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1775	PRADEEP HELPER) MODI	CON_163	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1776	Rajiv (Father)	CON_164	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1777	PASANTH KUMAR (PAINTER)	CON_165	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1778	SRIDHU MODI HELPER	CON_166	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1779	BALA MODI HELPER	CON_167	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1780	MAKESH KISHNA HELPER	CON_168	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1781	INDRA DEV RAJIV HELPER	CON_169	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1782	KRISHNA CCA	CON_170	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1783	GUNA SELVAM	CON_171	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1784	HARI HELPER	CON_172	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1785	MAKESH DRIVER	CON_173	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1786	JITHENDAR CCA	CON_174	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1787	SURAN MODI HELPER	CON_175	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1788	SUKHAN MODI HELPER	CON_176	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1789	SUBHAM MODI HELPER	CON_177	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1790	TAPAN MODI HELPER	CON_178	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1791	KAUTUKA MODI HELPER	CON_179	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1792	RAMESH GRINDING	CON_29	83	Contractor	0.00	Dr	7305787077	7305787077		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1793	SAKTHIVEL	CON_34	83	Contractor	0.00	Dr	9943108008	9943108008	3/6A ALMARA STREET PERUR	\N	\N	\N	\N	\N	\N	99431	\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1794	KUMAR	CON_35	83	Contractor	0.00	Dr	8012641226	8012641226	5/291,KUPPANAICKEN PALAYAM SOMAYAMPALAYAM	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1795	P.MAHAKRISHNAN	CON_36	83	Contractor	0.00	Dr	9842008293	9842008293	BOMMIAMMAN KOVIL STREET POMMANAMPALAYAM	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1796	KALYANASUNDRAM C	CON_40	83	Contractor	0.00	Dr	96773557744	96773557744	82-6-777,,MANADAKAPADI STREET AYIIKUDY	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1797	ANBU SELVAM (GRINDING )	CON_42	83	Contractor	0.00	Dr	8973884677	8973884677		\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1798	VENKATESH GRINDING	CON_88	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1799	EASWAR (BRINDAR)	CON_89	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1800	KABU	CON_90	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1801	RAJESH	CON_91	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1802	AJITH KUMAR	CON_92	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1803	SELVAM LABOUR	CON_93	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1804	DEEPAK LABOUR	CON_94	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1805	IBHARIM	CON_95	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1806	VENKATESH LABOUR	CON_96	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1807	PRABU LABOUR	CON_97	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1808	SELVAM (SHIVA)	CON_98	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1809	ANKIT KUMAR (BRIENDAR)	CON_99	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1810	MANIKANDAN (GRINDING)	CON_100	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1811	RAGUL (BRINDER)	CON_101	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1812	ANAND (GRINDING)	CON_102	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1813	SURAJ (HINDI)	CON_103	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1814	MD INTHA(HINDI)	CON_104	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1815	SIVAGURUNATHAN	CON_105	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1816	SHAKIL (HINDI)	CON_106	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1817	MADHAN LABOUR	CON_129	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1818	JABAR LABOUR	CON_130	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1819	RAVI GRINDING	CON_131	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1820	Ranjith	CON_132	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1821	Diiser Helper	CON_133	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1822	MUNISH	CON_134	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1823	Sanjai Helper	CON_135	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1824	GANESH (GRINDING)	CON_136	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1825	PAPALU GRINDING	CON_137	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1826	ASIF GRINDING	CON_138	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1827	RAMU GRINDING	CON_139	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1828	VINOTH  CHIPPING	CON_140	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1829	PRADEEP SINGH	CON_141	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1830	DIPTI	CON_142	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1831	SARAVANAN (RAJA)	CON_143	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1832	KRISHANAN (CHIPPING)	CON_144	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1833	RAMESH CHIPPING	CON_145	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1834	SELVAM (MELTER)	CON_146	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1835	RAJIV (MELTER)	CON_147	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1836	SANKAR (SELVAM MELTER)	CON_148	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1837	GANESH (MARI MUTHU) HELPER	CON_149	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1838	MODI HELPER	CON_150	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1839	SKD SATHISH	CON_151	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1840	SURESH DRIVER	CON_152	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1841	JITHENDAR GRINDING	CON_153	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1842	Indra Kumar(Grinding)	CON_154	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1843	Kumar Modi Helper	CON_180	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1844	SANDRAM GRINDING	CON_181	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1845	AKBAR GRINDING	CON_182	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1846	SURAJ  PAL GRINDING	CON_183	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1847	ASHOK CONTRACT	CON_60	83	Contractor	0.00	Dr	9994640518	9994640518	15,VADUKUTHOTTAM,	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1848	ANAND GRINDING	CON_63	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1849	SARVAN GRINDIND	CON_64	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1850	AUGISTIAN	CON_65	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1851	MARI MUTHU GRINDING	CON_66	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1852	SARVAN HINDI  LABOUR	CON_67	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1853	GURU (CRANE)	CON_107	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1854	MAHABULLA HINDHI LABOUR	CON_108	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1855	ARUN	CON_109	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1856	JAYARAM	CON_110	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1857	MUNISHWARAN	CON_111	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1858	MURALI	CON_112	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1859	ROHIT	CON_113	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1860	MADHESWARAN	CON_114	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1861	SATHISH	CON_115	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1862	MOHAMAAD	CON_116	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1863	THESER HINDHI HELPER	CON_117	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1864	MOHAMAAD NAZUREL	CON_118	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1865	PRAWEZ ALAM	CON_119	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1866	MAKESH HELPER	CON_120	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1867	ANITHA HELPER	CON_121	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1868	DHANANJAY	CON_122	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1869	ISRAFUL	CON_123	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1870	GOBI NATH	CON_124	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1871	SARDAR	CON_125	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1872	MD CHAND	CON_126	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1873	ANYAR RAIN	CON_127	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1874	SADAM LABOUR	CON_128	83	Contractor	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.361391+00	2026-08-03 14:42:07.361391+00
1875	V.KAVITHA	STF_1	67	Staff	0.00	Dr	9976073013	9976073013	4T1, PERMAL LAYOUR KATTOR	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1876	SHIVA KUMAR	STF_2	67	Staff	0.00	Dr			SOWRIMUTHU CHETTIYAR RED FIELD	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1877	GAJARAJ	STF_3	67	Staff	0.00	Dr	8903649728	8903649728	7/9, PERMAL KOVIL , NAICKNUR, 4 VEERAPANDI,PRESS COLONY PO	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1878	THAMBI DURAI	STF_6	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1879	M.Palaniswamy	STF_7	67	Staff	0.00	Dr	7200399068,8220408405	7200399068,8220408405	5/14,Vinayagarkovil Street, Sengalipalayam,Nggo Colony Post	\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1880	T.SATHISH KUMAR	STF_8	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1881	ANAND GRINDING1	STF_9	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1882	SARVAN GRINDING 1	STF_10	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1883	BABU RAJESH	STF_11	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1884	Babu Driver	STF_12	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1885	Mathi Driver	STF_13	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1886	GOPINATH	STF_14	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1887	ANAND DRIVER	STF_15	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1888	RAHUL	STF_16	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1889	RANJITHA	STF_17	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1890	MARIMUTHU	STF_18	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1891	RAJA ACCOUNTANT	STF_19	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1892	Sathish Skd	STF_20	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
1893	KAVITHA 1	STF_21	67	Staff	0.00	Dr				\N	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	t	2026-08-03 14:42:07.483785+00	2026-08-03 14:42:07.483785+00
\.


--
-- Data for Name: processes; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.processes (id, name, process_code, product_id, sequence, company_rate, contractor_rate, gst_percent, description, is_active, created_at) FROM stdin;
3	Chipping	12	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
4	SBL/FET//GPP	14	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
5	TRANSPORT	544	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
6	Return	5	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
7	SBL	6	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
8	FET	7	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
9	GPP	9	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
10	PRM	10	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
11	SBL/GPP	216	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
12	SBL/FET	371	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
13	SCRAP	452	\N	0	0.0000	0.0000	0.00		t	2026-08-03 14:42:08.355822+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.products (id, name, product_code, description, uom_id, weight, is_active, created_at, updated_at) FROM stdin;
2069	Scrap-Waste Materials	1	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2070	CGC051-CASING	2	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2071	CGC052-CASING	3	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2072	CGH100-CASING	4	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2073	GBS015-MOTOR BASE	5	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2074	GBS019-MOTOR BASE	6	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2075	RCG011-REAR COVER	7	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2076	YOH044-YOKE	8	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2077	CDF022-COVER DOME	9	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2078	CDF027-COVER DOME	10	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2079	GBS003-MOTOR BASE	11	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2080	GBS021-MOTOR BASE	12	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2081	RCG005-REAR COVER	13	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2082	GOS007-TOP HOUSING	14	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2083	BDF005-TSM MOTOR BODY	15	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2084	DBS061-BOTTOM HOUSING	16	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2085	CGH090-CASING	17	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2086	SKA008-STRAINER BRACKET	18	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2087	CDA005-CASING	19	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2088	RCF001-REAR COVER	20	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2089	RCH005-REAR COVER	21	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2090	CGH085-CASING	22	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2091	DHA001-DIFFFUSER HOUSING	23	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2092	DHC005-DIFFUSER HOUSING	24	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2093	RCI004-REAR COVER	25	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2094	BOI001-BODY	26	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2095	FTA008-FRONT COVER	27	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2096	BDF007-TSM MOTOR BODY	28	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2097	GOS023-TOP HOUSING	29	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2098	FSK001-FAN SHIELD	30	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2099	DHA001-DIFFUSER HOUSING	31	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2100	DHC005-DIFFFUSER HOUSING	32	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2101	BDA008-TSM MOTOR BODY	33	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2102	DBS072-TOP HOUSING	34	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2103	ECA008-END COVER	35	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2104	FSL001-FAN SHIELD	36	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2105	GBS020-TRUST INSERT	37	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2106	ECA007-END COVER	38	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2107	FNA017-FAN	39	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2108	DHC008-DIFFUSER HOUSING	40	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2109	IMI017-IMPELLER	41	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2110	SKA009-STRAINER BRACKET	42	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2111	YOS008-YOKE	43	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2112	GGS001-BOTTOM HOUSING	44	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2113	FTC009-FRONT COVER	45	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2114	FTC011-FRONT COVER	46	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2115	RCE001-REAR COVER	47	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2116	RCK001-REAR COVER	48	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2117	RCL001-REAR COVER	49	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2118	BDA010-TSM MOTOR BODY	50	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2119	DHA003-DIFFUSER HOUSING	51	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2120	YOS003-YOKE	52	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2121	BDC019-MOTOR BODY	53	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2122	BDF006-MOTOR BODY	54	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2123	CGH084-OH40Q CASING	55	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2124	CGH087 -1H65Q CASING	56	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2125	CGH088- 2H50Q CASING	57	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2126	GH091-2H65AQ CASING	58	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2127	CGH093-2H75Q CASING	59	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2128	CGH091-2H65AQ CASING	60	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2129	CGH098-1H75Q S185 CASING	61	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2130	CGH086-1H50Q CASING	62	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2131	FCG001-FRONT COVER	63	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2132	CGH101-4H50Q CASING	64	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2133	FSG001-FAN SHIELD	65	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2134	RAK009-REAR COVER	66	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2135	YOH006-YOKE	67	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2136	YOS002-YOKE	68	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2137	BDB001-TSM MOTOR BODY	69	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2138	BDF003-TSM MOTOR BODY	70	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2139	DBS064-TOP HOUSING	72	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2140	RAK007-REAR COVER	73	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2141	FTM007-FRONT COVER	74	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2142	FTM008-FRONT COVER	75	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2143	CGC015-7025 CASING	76	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2144	FTM010- FRONT COVER	77	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2145	CGC054-50Q CASING	78	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2146	HIS015-INLET BRACKET	79	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2147	HIS106-INLET BRACKET	80	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2148	IBA001-CASING	81	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2149	CDK004-COVER DOME	82	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2150	CGH105-3H40SQ CASING	83	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2151	GPS002-CABLE BOX	84	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2152	HIS001-INLRT BRACKET	85	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2153	DHA002-DIFFUSER HOUSING	86	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2154	FCF006-FRONT COVER	87	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2155	GGS006-BOTTOM HOUSING	88	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2156	BDF006-TSM M OTOR BODY	89	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2157	MS PALLET	90	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2158	SHOTBLSTING	91	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2159	CGC053- SM 40Q CASING	92	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2160	FTC008-FRONT COVER	93	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2161	HCA001-DELIVERY CHAMBER	94	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2162	DBS071-TOP HOUSING	95	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2163	RCE003-REAR COVER	96	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2164	DHA005-DIFFUSER HOUSING	97	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2165	IMI008-IMPELLER	98	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2166	IMS009-IMPELLER	99	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2167	RUNNER	100	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2168	CGC044-CASING	101	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2169	HPS045-PUMP HOUSING	102	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2170	RAC006-REAR COVER	103	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2171	CGH099-CASING	104	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2172	BDB004-TSM MOTOR BODY	105	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2173	BDD002-VSM MOTOR BODY	106	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2174	BDE003-VSM MOTOR BODY	107	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2175	CASING  ASM 30J	108	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2176	BDA011-TSM MOTOR BODY	109	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2177	CGCF016-CASING	110	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2178	FNA019-FAN	111	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2179	CGC016-CASING	112	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2180	IMI049-IMPELLER	113	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2181	CDK001-COVER DOME	114	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2182	DHC016-DIFFUSER HOUSING	115	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2183	FCI002-FRONT COVER	116	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2184	BDC017-MOTOR BODY	117	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2185	CGC017-CASING	118	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2186	FCG003-FRONT COVER	119	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2187	HCS006-DELLIVERY CASING	120	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2188	ECC002-MOTOR BASE	121	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2189	FTC007-FRONT COVER	122	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2190	RAB001-REAR COVER	123	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2191	IMH086-IMPELLER	124	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2192	TCH001-TERMINAL BOX COVER	125	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2193	IMH060 -H14/H18 IMPELLER	126	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2194	IMI017-H30 IMPELLER	127	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2195	IMI027-IMPELLER	128	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2196	TXH001-TEMINAL BOX	129	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2197	FTB001-FRONT COVER	130	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2198	FTC004-FRONT COVER	131	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2199	CGH089-CASING	132	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2200	TCG001-TERMINAL BOX COVER	133	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2201	CGH103-5H65Q CASING	134	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2202	GBS023- MOTORBASE	135	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2203	RAA003-REAR COVER	136	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2204	RCK002-REAR COVER	137	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2205	FSF005-FAN SHIELD	138	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2206	FTC016-FRONT COVER	139	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2207	YOH038-YOKE	140	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2208	HIS034-INLET BRACKET	141	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2209	HIS026-INLET BRACKET	142	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2210	IBA002 - CASING	143	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2211	BDE001-VSM MOTOR BODY	144	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2212	IMI034-IMPELLER	145	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2213	IMI043-IMPELLER	146	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2214	IMK005-IMPELLER	147	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2215	FCF003-FRONT COVER	148	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2216	FCH003-FRONT COVER	149	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2217	IMH071-IMPELLER	150	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2218	IMI005-IMPELLER	151	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2219	IMI050-IMPELLER	152	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2220	BDD001-VSM MOTOR BODY	153	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2221	BDE005-MOTOR BODY	154	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2222	BFI001- CASING	155	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2223	HCA009-DELIVERY CHAMBER	156	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2224	IMJ069-IMPELLER	157	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2225	HIS102-INLET BRACKET	158	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2226	IMH068-IMPELLER	159	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2227	IMH090-IMPELLER	160	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2228	FLS039-FLANGE SQUARE	161	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2229	IMH003-IMPELLER	162	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2230	HCS178-DELIVERY CASING	163	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2231	RCF005-REAR COVER	164	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2232	RCG001-REAR COVER	165	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2233	RCG008-REAR COVER	166	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2234	IMH097- IMPELLER	167	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2235	RAC002-REAR COVER	168	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2236	HIS111-INLET BRACKET	169	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2237	CGH092-2H65SQ CASING	170	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2238	IMI045-IMPELLER	171	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2239	HIS002-INLET BRACKET	172	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2240	BDD003-VSM BODY	173	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2241	GBS012-MOTOR BASE	174	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2242	IMS004-S13 IMPELLER	175	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2243	FTA010-FRONT COVER	176	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2244	BOK003-BODY	177	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2245	FTA007-FRONT COVER	178	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2246	FTM009-FRONT COVER	179	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2247	IMH030-IMPELLER	180	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2248	IMC008-IMPELLER	181	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2249	IMJ070-IMPELLER	182	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2250	FTC015-FRONT COVER	183	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2251	HES128-BOWL	184	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2252	IMC016-IMPELLER	185	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2253	IMC042-IMPELLER	186	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2254	IMI16-IMPELLER	187	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2255	IMI016-IMPELLER	188	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2256	DHC004-DIFFUSER HOUSING	189	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2257	IMH014-IMPELLER	190	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2258	IMH022-IMPELLER	191	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2259	IMI032-IMPELLER	192	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2260	IMO019-IMPELLER	193	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2261	IMS033-IMPELLER	194	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2262	IMH055-IMPELLER	195	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2263	IMS005-IMPELLER	196	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2264	IMH069-IMPELLER	197	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2265	BOS003-BODY	198	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2266	FTM006-FRONT COVER	199	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2267	BDA009-MOTOR BODY	200	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2268	FSH001-FAN SHIELD	201	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2269	IMS002-IMPELLER	202	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2270	DBS055-BOTTOM HOUSING	203	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2271	HES123-BOWL	204	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2272	HES133-BOWL	205	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2273	BDH001-VSM BODY	206	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2274	IMC052-IMPELLER	207	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2275	IMH091-IMPELLER	208	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2276	BDC016-MOTOR BODY	209	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2277	IMI009-IMPELLER	210	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2278	BDH002-VSM MOTORBODY	211	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2279	HIS010-INLET BRACKET	212	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2280	YOS022-YOKE	213	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2281	FLC009-FLANGE	214	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2282	BDC007-CAP	215	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2283	FSF001-FAN SHIELD	216	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2284	HPS039-PUMP HOUSING	217	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2285	IMI018-IMPELLER	218	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2286	IMI021-IMPELLER	219	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2287	IMI022-IMPELLER	220	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2288	CGS022-CASING	221	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2289	IMI090-IMPELLER	222	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2290	IMI052-IMPELLER	223	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2291	IMS014-IMPELLER	224	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2292	YOH001-YOKE	225	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2293	IMI048-IMPELLER	226	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2294	IMH051-IMPELER	227	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2295	BCB011-CAP	228	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2296	HNS017-NVR SEAT RETAINER	229	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2297	YOH012-YOKE	230	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2298	IMI031-IMPELLER	231	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2299	YOC002-YOKE	232	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2300	IMH004-IMPELLER	233	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2301	IMH076 - IMPELLER	234	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2302	IMH095- IMPELLER	235	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2303	IMI003-IMPELLER	236	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2304	IMS031-IMPELLER	237	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2305	CDB003-COVER DOME	238	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2306	GGAS001-CAP	239	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2307	GAS001-CAP	240	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2308	IMS015-IMPELLER	241	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2309	ECA006-END COVER	242	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2310	IMH015-IMPELLER	243	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2311	YOS010-YOKE	244	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2312	YOS011-YOKE	245	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2313	IMH017-IMPELLER	246	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2314	IMI028-IMPELLER	247	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2315	IMS003-IMPELLER	248	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2316	YOH016-YOKE	249	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2317	IMH026-IMPELLER	250	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2318	YOS021--YOKE	251	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2319	RCG009-REAR COVER	252	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2320	FCF008-FRONT COVER	253	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2321	RCF012-REAR COVER	254	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2322	RCG014-REAR COVER	255	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2323	ECA002-END COVER	256	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2324	ECB001-END COVER	257	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2325	IMH073-IMPELLER	258	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2326	YOH009-YOKE	259	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2327	IMH035-IMPELLER	260	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2328	RAA002-REAR COVER	261	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2329	GBS058-BOTTOM HOUSING	262	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2330	DBS058-BOTTOM HOUSING	263	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2331	IMH062-IMPELLER	264	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2332	IMK002-IMPELLER	265	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2333	IMH054-IMPELLER	266	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2334	YOS009-YOKE	267	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2335	FCF005-CASIING COVER	268	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2336	FTM011-FRONT COVER	269	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2337	IMC006-IMPELLER	270	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2338	IMC025-IMPELLER	271	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2339	IMK003-IMPELLER	272	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2340	HIS038-INLET BRACKET	273	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2341	DBS040-BOTTOM HOUSING	274	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2342	FCH002-FRONT COVER	275	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2343	CDK003-COVER DOME	276	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2344	IMC007-IMPELLER	277	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2345	FLS027-FLANGE	278	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2346	IMI035-IMPELLER	279	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2347	HCA002-REAR COVER	280	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2348	IMI044-IMPELLER	281	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2349	GAS011-REAR CAP	282	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2350	HCS158-SHELL DELIVERYCASING	283	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2351	RCK004 - REAR COVER	284	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2352	BON008-BODY	285	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2353	CDA010-COVER DOME	286	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2354	BDC015-MOTOR BODY	287	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2355	BOG008-BODY	288	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2356	CDB002-COVER DOME	289	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2357	IMH058-IMPELLER	290	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2358	IMH100-IMPELLER	291	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2359	IMC002-IMPELLER	292	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2360	IMH059-IMPELLER	293	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2361	CGC055-CASING	294	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2362	GAS005-CAP	295	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2363	FNA034-FAN	296	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2364	IMI020-IMPELLER	297	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2365	HIS087-INLET BRACKET	298	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2366	IAA002-CHAMBER	299	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2367	IMI007- IMPELLER	300	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2368	IMH096- IMPELLER	301	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2369	YOH019-YOKE	302	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2370	GBS007-THRUST INSERT	303	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2371	HCA008-DELIVERY CHAMBER	304	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2372	IMC056-IMPELLER	305	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2373	IML002-IMPELLER	306	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2374	GPS006-CABLE BOX	307	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2375	IMH033-IMPELLER	308	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2376	IMH070-IMPELLER	309	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2377	DHC001-DIFFUSER	310	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2378	IMI026-IMPELLER	311	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2379	IMI025-IMPELLER	312	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2380	IMI056-IMPELLER	313	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2381	IMO021-IMPELLER	314	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2382	CGH095-3H65 Q CASING	315	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2383	IMH019-IMPELLER	316	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2384	HIS103-INLETBRACKET	317	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2385	IMH0080-IMPELLER	318	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2386	IMH080-IMPELLER	319	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2387	IPB00I- INTERMIDATE PLATE	320	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2388	IPB003-INTERMIDATE PLATE	321	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2389	IPB001- INTERMIDATE PLATE	322	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2390	SKA010- STRAINER BRACKET	323	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2391	CGS020-1S100 Q CASING	324	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2392	CGH014--2H65A CASING	325	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2393	FLO004-FLANGE OVAL	326	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2394	GBS011-THRUST BASE	327	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2395	BDF002-MOTOR BODY	328	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2396	CGH051-2H65S CASING	329	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2397	IMI010-IMPELLER	330	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2398	HNS018-NNRV SEAT RETAINER	331	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2399	HNS020-NRV SEAT RETAINER	332	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2400	BOF016-BODY	333	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2401	BCC004-CAP	334	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2402	CGS004-1S125 CASING	335	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2403	IMI006-IMPELLER	336	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2404	IMT003-IMPELLER	337	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2405	IMS027-IMPELLER	338	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2406	IMS017-IMPELLER	339	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2407	IMH012-IMPELLER	340	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2408	CDF018-COVER DOME	341	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2409	GAS004-CAP	342	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2410	IMS007-IMPELLER	343	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2411	RCK003-REAR COVER	344	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2412	YOH040-YOKE	345	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2413	CGS007-1S50A CASING	346	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2414	CDB001-COVER DOME	347	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2415	HCS021-DELIVERY CASING	348	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2416	YOS001-YOKE	349	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2417	FLS028-FLANGE	350	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2418	HCS177--DELIVERY CASING	351	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2419	IML004-IMPELLER	352	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2420	HHCS0080-DELIVERY CASING	353	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2421	HPS001-PUMP HOUSING	354	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2422	HCS080-DELIVERY CASING	355	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2423	IMH009-IMPELLER	356	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2424	IMI054-IMPELLER	357	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2425	IMK004-IMPELLER	358	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2426	CGS002-0S75 CASING	359	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2427	CGH011-2H50 CASING	360	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2428	CGH036-1H75 CASING	361	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2429	HES001-BOWL	362	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2430	IMS032 IMPELLER	363	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2431	CGS001-0S65 CASING	364	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2432	BOF006-BODY	365	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2433	YOS006-YOKE	366	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2434	IMS011-IMPELLER	367	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2435	IMI041-IMPELLER	368	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2436	IMC058-IMPELLER	369	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2437	RCF004-REAR COVER	370	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2438	RCH002-REAR COVER	371	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2439	IMO024-IMPELLER	372	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2440	IAA012 DELIVERY CHAMBER	373	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2441	RCG013-REAR COVER	374	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2442	IMI033-IMPELLER	375	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2443	IMI051-IMPELLER	376	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2444	CGC015 - 7025 CASING	377	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2445	IMC014-IMPELLER	378	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2446	HES007-BOWL	379	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2447	BCD004-CAP	380	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2448	IMC018-IMPELLER	381	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2449	TXG007-TERMINAL BOX	382	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2450	IMS021-IMPELLER	383	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2451	CDC003-COVER DOME	384	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2452	CJA004-CASING	385	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2453	RCJ005-REAR COVER	386	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2454	BCC014-CAP	387	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2455	CGH039 4H40-CASING	388	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2456	IMH040-IMPELLER	389	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2457	IMI038-IMPELLER	390	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2458	RCD001-REAR COVER	391	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2459	RCD002-REAR COVER	392	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2460	IMI046-IMPELLER	393	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2461	CDB004-COVER DOME	394	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2462	IMI030-IMPELLER	395	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2463	IMH061-IMPELLER	396	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2464	BCE004-CAP	397	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2465	HPV005-PUMP HOUSING	398	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2466	7.5 FLANGE	399	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2467	5.5 FLANGE	400	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2468	5.5 DTG FLANGE	401	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2469	IMK009-IMPELLER	402	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2470	IMC019-IMELLER	403	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2471	RAK006-REARCOVER	404	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2472	IMO040-IMPELLER	405	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2473	CDC001-COVER DOME	406	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2474	FCI001-FRONT COVER	407	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2475	FSJ002-FAN SHIELD	408	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2476	DBS039-TOP HOUSING	409	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2477	DHA006-DIFFUSER HOUSING	410	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2478	IMH009 - IMPELLER	411	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2479	IMO017-IMPELLER	412	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2480	BCE001-CAP	413	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2481	FSL032-FLANGE SQUARE	414	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2482	IPB002-INTERMMADIATE PLATE	415	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2483	IMH016-IMPELLER	416	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2484	BCI003-CAP	417	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2485	FTE006-SUCTION CHAMBER	418	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2486	IML003-IMPELLER	419	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2487	FLC028-FLANGE SQUARE	420	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2488	BOC014 - BODY	421	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2489	IMI042-IMPELLER	422	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2490	IMK008-IMPELLER	423	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2491	IMI057-IMPELLER	424	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2492	IMS012-IMPELLER	425	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2493	CDK007 - COVER DOME	426	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2494	FLS017- FLANGE SQUARE	427	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2495	FLC006-FLANGE CIRCULAR	428	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2496	GBS025-THRUST INSERT	429	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2497	ECC001-MOTOR BODY	430	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2498	ECD001-MOTOR BASE	431	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2499	FSL040-FLANGE SQUARE	432	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2500	FLS040 - FLANGE SQUARE	433	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2501	BOG001-BODY	434	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2502	RAE001-BOTTOM BUSH	435	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2503	IMH002 -IMPELLER	436	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2504	IMH057-IMPELLER	437	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2505	IMH028- IMPELLER	438	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2506	CGC-023 MOTOR BASE	439	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2507	CGC-023 CASING	440	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2508	CDA004-COVER DOME	441	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2509	IMC001-IMPELLER	442	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2510	CDF023 - COVER DOME	443	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2511	FLS032-FLANGE SQUARE	444	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2512	FLS031-FLANGE SQUARE	445	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2513	BCA002-CAP	446	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2514	HIS116-INLET SEALING RING	447	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2515	HNS019-SEAT RETAINER	448	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2516	YOH027 - YOKE	449	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2517	BOK007-BODY	450	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2518	BCD007-CAP	451	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2519	FTA009-FRONT COVER	452	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2520	YOS004-YOKE	453	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2521	ECA010 - END COVER	454	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2522	CDK005-COVER DOME	455	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2523	IMC026-IMPELLER	456	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2524	CGC034~1125-CASING	457	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2525	YOH018-YOKE	458	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2526	IMI058-IMPELLER	459	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2527	IMH042-IMPELLER	460	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2528	IMC068-IMPELLER	461	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2529	IMC029-IMPELLER	462	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2530	CGC023-CASING	463	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2531	IMH099-IMPELLER	464	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2532	IMH078- IMPELLER	465	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2533	IMH078-IMPPELLER	466	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2534	IMH078 IMPELLER	467	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2535	IMH021-IMPELLER	468	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2536	RAC003-REAR COVER	469	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2537	FLC008-FRONT COVER	470	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2538	HCS191-DELIVERY CASING	471	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2539	HIS084-INLET BRACKET	472	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2540	BON003-BODY	473	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2541	CGC009 - 1S75 CASING	474	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2542	CGS009-1S75 CASING	475	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2543	BDF001-TSM BODY	476	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2544	YOS01-YOKE	477	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2545	YOS014 - YOKE	478	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2546	BCF002-CAP	479	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2547	GPS014-CABLE BOX	480	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2548	CGC013 - 2S50 CASING	481	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2549	MCC004-FRONT COVER	482	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2550	IMI012-IMPELLER	483	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2551	YOH039-YOKE	484	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2552	GBS008-MOTOR BASE	485	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2553	HCS001-DELIVERY CASING	486	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2554	HCS038-INTEGRAL DELIVERY	487	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2555	HIS089-INLET BRACKET	488	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2556	FCF004 - CASING  COVER	489	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2557	HES026-BOWL	490	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2558	GBS024-MOTOR BASE	491	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2559	FCJ004-FRONT COVER	492	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2560	IMS024 - IMPELLER	493	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2561	IMI045 - IMPELLER	494	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2562	IMS010 - IMPELLER	495	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2563	CDF007-COVER DOME	496	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2564	HCS202 - DELIVERY CASING	497	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2565	FLS041-FLANGE SQUARE	498	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2566	IAA001- SD CHAMBER	499	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2567	CGC041 - CASING	500	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2568	FTE003- SUCTION CHAMBER	501	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2569	CGH106- OH50 CASING	502	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2570	SHOTBLASTING HOUSING SOFT	503	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2571	GGS009-BOTTOM HOUSING	504	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2572	HIS123-INLET BRACKET	505	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2573	EAR005-STATOR END RING	506	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2574	CGC020 - 1S100CASING	507	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2575	BCI004-CAP	508	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2576	HIS117 - INLET BRACKET	509	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2577	ECC007- MOTORBASE	510	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2578	DHA039-DIFFUSER HOUSING	511	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2579	DHA040-DIFFUSER HOUSING	512	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2580	DHA041-DIFFUSER HOUSING	513	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2581	CGH088 2H50Q CASING	514	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2582	CGH098-1H75Q CASING	515	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2583	CGS021-2S100 Q CASING	516	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2584	FLC034-FLANGE CIRCULAR	517	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2585	FCG002-FRONT COVER	518	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2586	GUN-METAL	519	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2587	HIS032-INLET BRACKET	520	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2588	IMC073 - IMPELLER	521	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2589	CDC004 - COVER DOME	522	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2590	BCB001-THRUST BASE	523	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2591	IMC015-IMPELLER	524	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2592	BCB001-CAP	525	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2593	YOH014-YOKE	526	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2594	ECA011-END COVER	527	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2595	HCS206 - DELIVERYCASING	528	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2596	RAH001-BOTTOM BUSH HOUSING	594	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2597	BOL001-BODY	595	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2598	IMJ218-IMPELLER	596	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2599	MIM048-WEAR PLATE	597	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2600	FLS0205- FLANGE SQUARE	598	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2601	FLS025-FLANGE SQUUARE	599	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2602	BOK005-BODY	600	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2603	BCB013-CAP	601	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2604	HCS234-DELIVERY CASING	602	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2605	YOS017-YOKE	603	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2606	HES078-BOWL	604	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2607	YOH041-YOKE	605	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2608	CGH053-3H35 CASING	606	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2609	CGH104-4H75 CASING	607	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2610	CGS008-1S65 CASING	608	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2611	HES233-DELIVERY CASING	609	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2612	HCS233-DELIVERY CASING	610	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2613	CGH017-3H40S CASING	611	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2614	HCS232-DELIVERY CASING	612	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2615	BDE011-BODY	613	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2616	CGS005-1S150 CASING	614	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2617	HES030- BOWL	615	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2618	DHC014-DIFFUSER HOUSING	616	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2619	GPS003-CABLE BOX	617	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2620	IMC047-IMPELLER	618	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2621	IMS042-IMPELLER	619	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2622	HES038-BOWL	620	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2623	BDB005-TSM BOBY	621	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2624	FLO013-FLANGE OVAL	622	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2625	IMK013-IMPELLER	623	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2626	BCB021-CAP	624	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2627	HIS121-INLET SEALING RING	625	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2628	HIS024-INLET BRACKET	626	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2629	CIVIL WORK	627	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2630	HIS126-INLET BRACKET	628	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2631	IMJ213-IMPELLER	629	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2632	IMK007-IMPELLER	630	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2633	HCS235-DELIVERY CASING	631	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2634	FLO009-FLANGE OVAL	632	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2635	HCS029-DELIVERY CASING	633	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2636	IMC028-IMPELLER	634	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2637	DBS009-BOTTOM HOUSING	635	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2638	EXPENSES FOR DISA (SPARES & LABOUR)	636	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2639	HNV004-NRV SEAT	637	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2640	CDC002-COVER DOME	638	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2641	HNM005-DISC FACE	639	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2642	MIM034-WEAR PLATE	640	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2643	CCGC022-S30Q CASING	641	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2644	CDG001-COVER DOME	642	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2645	FLS034-FLANGE SQUARE	643	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2646	IPA003-INTERMEDIATE PLATE	644	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2647	HNF017-NRV SEATHOLDER	645	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2648	HIS122-INLETBRACKET	646	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2649	IMS008-IMPELLER	647	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2650	MIM042-WEAR PLATE	648	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2651	CDA009-COVER DOME	649	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2652	IMJ219-IMPELLER	650	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2653	ATTANCE	651	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2654	FLS038-FLANGE	652	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2655	GLD006-GLAND	653	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2656	GLD007-GLAND	654	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2657	BCB009-CAP	655	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2658	HES077-BOWL	656	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2659	IMS020-IMPELLER	657	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2660	HNM013-NRV DISC FACE	658	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2661	CDF022-COVERDOME	529	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2662	CGH018  -3H50 CASING	530	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2663	HCS105 - DELIVERY CASING	531	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2664	HCS138-DELIVERY CASING	532	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2665	BOK001-BODY	533	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2666	HIS092-INLET BRACKET	534	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2667	FTC019-FRONT COVER	535	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2668	HCS120 - INTEGRAL DELIVERY CASING	536	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2669	HCS205- DELIVERY CASING	537	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2670	CGC059 - CASING	538	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2671	HCS122-DELIVERY CASING	539	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2672	YOH046-YOKE	540	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2673	IMC064-IMPELLER	541	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2674	IMC010-IMPELLER	542	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2675	YOH047-YOKE	543	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2676	IMI059-IMPELLER	544	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2677	FLS005-FLANGE SQUARE	545	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2678	HIIS124-INLET BRACKET	546	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2679	HIS124 - INLET BRACKET	547	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2680	HCA006-DELIIVEVERY CHAMBER	548	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2681	DFA037-DIFFUSER	549	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2682	HES141-BOWL	550	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2683	IMI047-IMPELLER	551	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2684	HCS116-DELIVERY CASING	552	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2685	BCF009-CAP	553	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2686	FLS033-FLANGE	554	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2687	FLC044-FLANGE SQUARE	555	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2688	IMJ212-IMPELLER	556	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2689	FLS004-FLANGE SQUARE	557	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2690	FLS052-FLANGE CIRCULAR	558	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2691	FLI004-FLANGE PROFILE	559	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2692	YOH037-YOKE	560	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2693	FLC052-FLANGE CIRCULAR	561	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2694	IMJ217-IMPELLER	562	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2695	IMJ211-IMPELLER	563	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2696	IMT004-IMPELLER	564	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2697	HES106-BOWL	565	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2698	HES129-BOWL	566	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2699	FTC018-FRONT COVER	567	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2700	HCS238-DELIVERY CASING	568	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2701	BOS008-BODY	569	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2702	HCS193-DELIVERY CASING	570	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2703	FTE002-SUCTION CHAMBER	571	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2704	IML005-IMPELLER	572	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2705	GAS014-DIAPHRAM CAP	573	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2706	FLC032-FLANGE CIRCULAR	574	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2707	IMT006-IMPELLER	575	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2708	FTE001-SUCTION CHAMBER	576	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2709	IMI011-IMPELLER	577	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2710	CDF024-COVER DOME	578	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2711	CGC062-CASING	579	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2712	CGC045-CASING	580	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2713	BCG011-CAP	581	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2714	IMJ215-IMPELLER	582	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2715	IMJ216-IMPELLER	583	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2716	IMO018-IMPELLER	584	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2717	HIS045-INLETBRACKET	585	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2718	HCS100-DELIVERY CASING	586	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2719	HCS185-DELIVERY CASING	587	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2720	FLS037-FLANGE SQUARE	588	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2721	FTM012-FRONT COVER	589	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2722	IMJ223-IMPELLER	590	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2723	HIS095-INLET BRACKET	591	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2724	MIM027-WEAR PLATE	592	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2725	BOE007-BODY	593	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2726	DBS034-BOTTOM HOUSING	659	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2727	FLC038-FLANGE SQUARE	660	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2728	PYF001-FLAT PULLEY	661	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2729	BDD009-MOTOR BODY	662	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2730	HES044-BOWL	663	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2731	FTE004-SUCTION CHAMBER	664	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2732	IMH052-IMPELLER	665	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2733	HCS002-DELIVERY CASING	666	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2734	HIS128-INLETBRACKET	667	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2735	DBS021-TOPHOUSING	668	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2736	BDD008-BODY	669	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2737	YOS016-YOKE	670	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2738	BOT002-BODY	671	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2739	HCS240 - DELIVERY CASING	672	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2740	HES046-BOWL	673	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2741	FLI002-FLANGE	674	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2742	IMH006-IMPELLER	675	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2743	MIM047-REAR COVER	676	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2744	HIS019-INLET BRACKET	677	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2745	IMC057-IMPELLER	678	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2746	IMJ227-IMPELLER	679	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2747	RAK010-REAR COVER	680	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2748	IMH032-IMPELLER	681	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2749	CGC064-CASING	682	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2750	BOF001-1544 OUTER CASING	683	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2751	HCS228  - DELIVERY CASING	684	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2752	CGC065-4025 CASING	685	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2753	CGH037-2H75 CASING	686	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2754	IMH024-IMPELLER	687	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2755	0.5 HP ADAPTER	688	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2756	1 HP SHALLO ADAPTOR	689	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2757	2 STAGE	690	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2758	1 HP AV CASING	691	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2759	A TYPE ADOPTER	692	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2760	FTM013 S M FRONT COVER	693	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2761	LMW0002 INTERMEDIATE FRAME	694	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2762	GEAR BOX HOUSING (FRONT HALF)	695	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2763	GEAR BOX HOUSING (REAR HALF)	696	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2764	PP TATA 380 (VALVO PRESSURE PLATE)	697	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2765	OUTER HOUSING MACHINED	698	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2766	MANIFOLD ASSY	699	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2767	INTERMEDIATE FRAME_G039072	700	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2768	BRAKE CALIPER (DELLNER)	701	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2769	SUMP LUB OIL(ADDISON SUMP103)	702	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2770	SUMP LUB OIL (ADDISON SUMP 3005)	703	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2771	IND-PACKER -ASSY	704	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2772	PLANET CARRIER	705	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2773	CENTER HOUSING	706	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2774	ATTANANCE ( PINHU)	707	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2775	ATANANCE ( LABOUR)	708	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2776	RAJ BHIHARI	709	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2777	SANTHOSH HINDI	710	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2778	MISHOTAN HINDI	711	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2779	OUTER HOUSING  IU4A0057	712	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2780	OUTER HOUSING NPDT0015	713	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2781	KNUCKLE STEERING 0041	714	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2782	KNUCKLE STEERING 0046	715	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2783	FRAME 0072	716	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2784	DIFF CASE	717	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2785	IND CAP FUNCTI ONAL	718	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2786	GEAR BOX INTERMEDIATE	719	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2787	GEAR BOX FRONT 5830	720	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2788	IND PLUG-1 1/4 NPT	721	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2789	GEAR BOX REAR 5830	722	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2790	BODY INJECTOR MACH	723	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2791	IND PLUG 2	724	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2792	COVER CAPACTOR	725	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2793	IND PLUG 2 BOX RED	726	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2794	LMW FRAME 002	727	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2795	DISC BRAKE 0082597	728	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2796	IND BODY INJECTOR	729	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2797	FURNACE 500 KG CRUISABLE	730	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2798	PANNEL BOARD 350 KW	731	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2799	IU4A0078 AXLE CASING	732	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2800	NPDT0225 AXLE CASING	733	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2801	STANCHION WITH CYLINDER	734	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2802	ABC PANNEL	735	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2803	MV PANNEL	736	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2804	FRONTCOVER ASM30J	737	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2805	C.I SCRAP	738	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2806	COVER CASING DMS3	739	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2807	S&D CHAMBER DMS2	740	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2808	ASM 30J FRONT COVER	741	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2809	COOLING COVER 100	742	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2810	EMPTYOIL CAN	743	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2811	GP SEAL CAST DP VAS LT	744	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2812	JERLAC THINNER 104	745	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2813	BOWL STAGE MS65A (CASTING)	746	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2814	ASM1J FRONT COVER	747	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2815	DMS3 VOLUTE CASING	748	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2816	BOTTOM BEARING HOUSING CASTING SM610	749	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2817	ASM14J REAR COVER	750	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2818	DOME CHAMBER DMS2	751	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2819	DOME CHAMBER DMS3	752	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2820	500 KVA TRANSFORMER	753	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2821	ELGI COMPRESSOR -E30	754	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2822	IR COMPRESSOR UP5-22	755	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2823	SG1-06 FRAME	756	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2824	SG1-06B FRAME	757	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2825	YN54D0168P1-01 BRACKET CASTING	758	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2826	1-572-001-100 ROTOR CASTING	759	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2827	2A50111910SG BRACKET	760	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2828	150-00202-01 CLAW ROTOR CASTING QDP80	761	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2829	047-Traction Sheave (320 Pcd X08x5g)(2648)	762	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2830	CRX MOTAR BODY	763	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2831	YN30P01029 P1 BRACKET	764	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2832	YN02P01397 BRACKET	765	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2833	045-TRACTION SHEAVE 4ES-00-0045	766	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2834	08006011710355-OUTER HOUSING CASTED	767	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2835	END SHIELD	768	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2836	MOUNT HUB	769	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2837	BREAKDRUM	770	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2838	4121 GEAR	771	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2839	PTO CASING	772	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2840	015 POPPET	773	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2841	1.564 ROTAR	774	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2842	007 BONUT	775	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2843	Segment	776	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2844	Cam Gear	777	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2845	Hub	778	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2846	Geneva Top	779	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2847	Geneva Bottom	780	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2848	08 Frame	781	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2849	BOX CASTING	782	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2850	BRACKET	783	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2851	501 Hub	784	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2852	2" BOTTOM	785	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2853	2*11/2 RED	786	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2854	1 1/4 TOP	787	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2855	1 1/4*1 RED	788	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2856	1 1/2 * 1 1/4 RED BUSH	789	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2857	1 1/4  BOTTOM	790	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2858	1 1/4*1 1/2 EXP BUSH	791	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2859	1 1/4 SUPER HEVY BOTTOM	792	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2860	1 1/2 TOP SUPER HEAVY	793	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2861	7" PLATE (R)	794	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2862	7" PLATE (S)	795	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2863	TEL S105 TURBINE HOUSINFB RAW PART	796	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2864	HYU S01 MANIFOLD EXHAUST	797	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2865	LP54D01002P1-01-CST BRACKET SK 14O CASTING	798	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2866	PRESSURE RELIEVE CASING 1147239453SG	799	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2867	END COVERV CASING 25 SERIES	800	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2868	SHOTBLAST BLOWER MACHINE	801	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2869	SHOTBLASTING MACHINE	802	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2870	COMPURSURE 10 HP	803	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2871	CONVER BELT	804	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2872	SUNG MOTOR	805	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2873	PANNAL BOARD	806	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2874	Grinding Machine	807	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2875	Bed	808	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2876	Coat	809	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2877	DELIVERY CASING	810	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2878	NRV SEAT HOLDER	811	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2879	S.D CHAMBER	812	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2880	IAA004 S. D CHAMBER	813	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2881	CHAIN SLING 1 TON CAPACITY 1.5 METER 4 LEG	814	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2882	ALLEN KEY 1.5MM TO 10MM	815	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2883	ALLEN KEY 12MM	816	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2884	ALLEN KEY 14MM	817	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2885	ALLEN KEY 17MM	818	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2886	ALLEN KEY 19MM	819	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2887	ALLEN KEY 22MM	820	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2888	DROP FORGED	821	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2889	6 TO 32 MM , VANDIUM STEEL	822	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2890	Socket Sq. Drive  Hex 30mm	823	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2891	Sq. Drive ,Hex 32mm,	824	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2892	Sq.Drive , 26mm,	825	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2893	Sq. Drive, Hex 24mm,	826	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2894	Sq. Drive Hex 20mm,	827	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2895	Sq. Drive , Hex 22mm,	828	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2896	Taparia T-Handle	829	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2897	Bullwark Tool Box	830	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2898	ALLEN KEY SHORT FLAT 9	831	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2899	ALLEN KEY SHORT FLAT 12MM	832	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2900	ALLEN KEY SHORT FLAT 14MM	833	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2901	ALLEN KEY SHORT FLAT 17MM	834	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2902	ALLEN KEY SHORT FLAT 19MM	835	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2903	ALLEN KEY SHORT FLAT 22MM	836	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2904	RING SPANNER 12Pcs	837	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2905	DOUBLE OPEN END SPANNER 12Pcs	838	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2906	Sq. Drive Hex 30mm	839	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2907	Sq. Drive 32mm	840	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2908	Sq Drive 26mm	841	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2909	Sq. Drive Hex 24mm	842	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2910	Sq. Drive Hex 20mm	843	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2911	Sq. Drive Hex 22mm	844	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2912	Sq, Drive 12" Length	845	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2913	Collapsible 17*9*6.5"	846	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2914	F 180 12 303 Cover Dome	847	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2915	Ms Cover Dome	848	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2916	2H65S CASING	849	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2917	7032 S 4H CASING	850	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2918	RC DIFFUSER HOUSING INTEGRAL	851	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2919	2DH DIAPHRAGM CAP	852	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2920	525H S D CHAMBER	853	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2921	TSP 1/2 CASING	854	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2922	TSP 3 CASING	855	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2923	CDE010 COVER DOME	856	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2924	CJA009 -CASING	857	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2925	CDA006 COVER DOME	858	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2926	DHC018 DIFFUSER HOUSING	859	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2927	IMS058 IMPELLER	860	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2928	DHC024 DIFFUSER HOUSING	861	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2929	HIS150 INLET BRACKET	862	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2930	MCI DRUM	863	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2931	KAPPA FLYWHEEL 23211-08200	864	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2932	CDF029 COVER DOME	865	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2933	A/C 2 TONE	866	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2934	GRINDING BED	867	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2935	HES134 BOWL	868	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2936	FMZ077 RING PATTERN	869	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2937	REAR CAP 1505C	870	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2938	DHA042 DIFFUSER HOUSING	871	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2939	CGC046 CASING	872	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2940	RAE002 BOTTOM BUSH HOUSING	873	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2941	RAH003 BOTTOM BUSH HOUSING	874	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2942	RAC005 REARCOVER	875	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2943	CGH077-7025 CASING	876	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2944	IAA011 CHAMBER	877	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2945	10 PISTON COMPRESSOR RENTAL PURPOSE	878	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2946	IMC078 IMPELLER	879	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2947	BFO002 OUTER CASING	880	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2948	HIO001INLET BRACKET	881	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2949	HCA012 DELIVERY CHAMBER	882	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2950	WATER	883	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2951	SANTOR WHEEL 4"	884	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2952	ECD004-MOTOR BASE	886	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2953	BDD006 - MOTOR BODY	887	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2954	IMI060-IMPELLER	888	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2955	BOD003-BODY	889	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2956	IMK015-IMPELLER	890	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2957	IMC021-IMPELLER	891	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2958	ECC010-MOTOR BASE	892	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2959	FTE007-SUCTION CHAMBER	893	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2960	BOD009	894	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2961	BOF021 BODY	895	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2962	CGC066 CASING	896	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2963	HCA016 DELIVERY CHAMBER	897	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2964	IMI062 IMPELLER	898	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2965	FCD004 CASING COVER	899	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2966	HES144 BOWL	900	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2967	HES126 BOWL	901	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2968	HES039 PUMP HOUSING	902	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2969	IMK014 IMPELLER	903	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2970	RCE004 REAR COVER	904	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2971	CGC022 4025 CASING	905	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2972	FTC013 FRONT COVER	906	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2973	DBS079 BOTTOM HOUSING	907	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2974	IMI063 IMPELLER	908	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2975	DBO001 TOP BUSH HOUSING	909	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2976	FLS045 FLANGE	910	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2977	FLS046 FLANGE	911	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2978	CORE SHUTER	912	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2979	CGC035 CASING	913	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2980	MIM033 DRAIN COVER	914	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2981	IMK011 IMPELLER	915	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2982	GPS016 CABLE BOX	916	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2983	CUT WIRE SHOTS	917	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2984	400*50*127 C163 ZRC	1028	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2985	BCG012 CAP	918	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2986	BDE012 BODY	919	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2987	MIM038 WEAR PLATE	920	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2988	DHA044MDIFFUSER HOUSING	921	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2989	HCA014 DELIVERY CHAMBER	922	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2990	BLADE	923	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2991	BLADE-14MM(HC)	924	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2992	BLADE MOUNTING BOLT@NUT	925	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2993	IMPELLER	926	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2994	CONTROLGUAGE	927	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2995	NARROW PLATE	928	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2996	CURVED PLATE	929	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2997	200*400 GUIDE PLATE	930	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2998	700*400 WALL PLATE	931	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
2999	300 KGS BLADE	932	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3000	BLADEMOUNT&NUT	933	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3001	300 KGS IMPELLER	934	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3002	300 KGS CONTROL GUAGE	935	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3003	300 KGS NARROW PLATE	936	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3004	300 KGS CURVED PLATE	937	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3005	150*300 GUIDE PLATE	938	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3006	300 KGS BEARING END	939	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3007	300 KGS FEEDING END	940	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3008	HNM010 NRV DISC FACE	941	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3009	BDD004 BODY	942	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3010	CDF013 COVER DOME	943	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3011	ECC008	944	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3012	COMPRESSOR 7.5 HP	945	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3013	FNA036-FAN	946	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3014	DBS089-TOP HUSING	947	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3015	HCS252 DELIVERY CASING	948	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3016	DBO005 TOPBUSH	949	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3017	DBS088 BOTTOM HOUSING	950	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3018	CGH054  4H65 CASING	951	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3019	CGC067 CASING	952	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3020	CGC048 50H CASING	953	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3021	HIO002 INLET BRACKET	954	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3022	HPS067 INTERMEDIATE HOUSING	955	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3023	JCB LSRS\t\t	956	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3024	JCB CENTER CUTTER\t\t	957	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3025	BDF009 TSM BODY	958	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3026	FTM015 FRONT COVER	959	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3027	CGH056-H38	960	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3028	RAK011 REAR COVER	961	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3029	HCS253 DELIVERY CASING	962	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3030	CGH115-1H40 CASING	963	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3031	CDF002-COVER DOME	964	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3032	ROPE GRINDING	965	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3033	FTC020 FRONT COVER	966	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3034	FTC014 REAR COVER	967	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3035	RCF014 REAR COVER	968	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3036	GP PAINT FOR REWORK PURPOSE	969	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3037	SKA011 STRAINER BRACKET	970	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3038	ECD004-MOTAR BASE	971	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3039	CGH117-IH65 CASING	972	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3040	GBS002 MOTAR BASE	973	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3041	FTM014 FRONT COVER	974	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3042	CDI015 COVER DOME	975	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3043	NFD CASTING	976	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3044	YOS005 YOKE	977	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3045	FMZ078 MATCH RING	978	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3046	FTM016 FRONT COVER	979	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3047	FTM017 FRONT COVER	980	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3048	FTM018 FRONTCOVER	981	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3049	CDA008 COVER DOME	982	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3050	CGH121 2H50 CASING	983	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3051	CGH122 2H40QN CASING	984	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3052	CGH123 2H65A CASING	985	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3053	RAK012 REAR COVER	986	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3054	BOD012 BODY	987	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3055	RING PATTERN	988	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3056	YOS018 YOKE	989	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3057	BDF010 BODY	990	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3058	CDI011 COVER DOME	991	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3059	2000 A COVER	992	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3060	1-567-410 ROTAR	993	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3061	IMPELLER -	994	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3062	GOS014 TOP HOUSING	995	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3063	IAB008 DELIVERY CHAMBER	996	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3064	HIS166 INLET BRACKET	997	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3065	SKA012 STRAINER BRACKET	998	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3066	BDE014 BODY	999	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3067	RGS001 SUCTION CHAMBER	1000	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3068	BDF011 BODY	1001	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3069	BOK009-BODY	1002	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3070	CGH120-0H40QN CASING	1003	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3071	HNM003 NRV DISC	1004	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3072	FCD008 FRONT COVER	1005	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3073	CDA013 COVER DOME	1006	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3074	BOH002- BODY	1007	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3075	BON005 BODY	1008	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3076	CGH116-1H50 QN CASING	1009	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3077	HIS167 INLET BRACKET	1010	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3078	BOH003-MOTOR BODY	1011	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3079	CDI013 COVER DOME	1012	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3080	SS 304	1013	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3081	GBS022 MOTARBASE	1014	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3082	GAS002 CAP	1015	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3083	HIS168 INLETBRACKET	1016	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3084	HCA015 -DELIVER CASING	1017	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3085	HCS178 DELIVERY CASING	1018	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3086	HCS153-IMPELLER	1019	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3087	BOWL	1020	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3088	GGS012 BOTTOM HOUSING	1021	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3089	FCE006 REAR COVER	1022	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3090	CDB008 COVER DOME	1023	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3091	HCS247 DELIVERY CASING	1024	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3092	FTC017 FRONT COVER	1025	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3093	GBS028 - THRUST INSERT	1026	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3094	MOTAR	1027	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3095	400*50*127 C163 ZRC SPEED WHEEL	1029	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3096	FORK LIFT MAINTANCE	1030	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3097	EB	1031	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3098	BFI002	1032	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3099	CDF017 COVER DOME	1033	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3100	IAA009 SUCTION CHAMBER	1034	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3101	DHC019 DIFFUSER HOUSING	1035	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
3102	BOH008 BODY	1036	\N	\N	\N	t	2026-08-03 14:42:07.512141+00	2026-08-03 14:42:07.512141+00
\.


--
-- Data for Name: rates; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.rates (id, process_id, ledger_id, product_id, rate, uom_id, effective_from, effective_to, is_active, created_at) FROM stdin;
1	8	\N	\N	3.4000	\N	\N	\N	t	2026-08-03 14:42:08.380159+00
2	8	\N	\N	1.5000	\N	\N	\N	t	2026-08-03 14:42:08.380159+00
3	8	\N	\N	1.5000	\N	\N	\N	t	2026-08-03 14:42:08.380159+00
4	5	\N	\N	0.8000	\N	\N	\N	t	2026-08-03 14:42:08.380159+00
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
197	STEEL SHOTS	1	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
198	SHOTS	2	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
199	GRINDING STONE 400*50*127	3	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
200	GRINDING STONE 350*50*50.8	4	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
201	ROD PAINT	5	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
202	GPP PAINT	6	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
203	GRN PAINT	7	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
204	TURBON OIL	8	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
205	TINNER	9	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
206	GLOUSE	10	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
207	GLASS	11	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
208	GRINDING STONE CORNER WHEEL 230*7*22.23	12	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
209	BEARING	13	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
210	PAPER	14	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
211	TEA	15	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
212	COTTON GLOUSE	16	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
213	GRINDING WHEEL 100*6*15.88 AG4	17	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
214	GP SEAL CAST VASANTHI RED OXIDE	18	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
215	GLOUSE INNER	19	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
216	GLOUSE LEATHER	20	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
217	CONTROL GUAGE	21	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
218	NARROW PLATE	22	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
219	CURVE PLATE	23	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
220	IMPELLER	24	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
221	IMPELLER COLLER	25	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
222	BLADE	26	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
223	SPANNER RING	27	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
224	SPANNER DOUBLE HAND	28	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
225	WIRE CUTTER	29	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
226	ALLEN KEY (1.5mm To 10mm)	30	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
227	CUTTING PLAYER	31	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
228	CIRCLIP PLAYER	32	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
229	HAMMER	33	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
230	ADJUSTABLE SPANNER	34	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
231	MAGNET	35	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
232	CHUTTY	36	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
233	MOUNTED POINT STONE	37	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
234	CUTTER CB1022	38	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
235	CUTTER CTP 1224	39	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
236	GRINDING STONE  BT 400/50/127MM	40	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
237	GRINDING STONE B+	41	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
238	GRINDING STONE SIC 1675	42	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
239	GRINDING STONE DIAMOND CUT	43	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
240	CI BORINGS	44	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
241	JOIST (150*75) (20")	45	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
242	JOIST (150*75) (4.5")	46	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
243	M S ANGLE (50*5 R)	47	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
244	HR SHEETS	48	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
245	CHAIN	49	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
246	CGST 9%	50	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
247	SGST 9%	51	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
248	Allen Key (12 MM)	52	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
249	ALLEN KEY (14 MM)	53	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
250	ALLEN KEY (17 MM)	54	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
251	ALLEN KEY (19 MM)	55	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
252	ALLEN KEY (22 MM)	56	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
253	RING SPANNER (6 TO 32 MM)	57	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
254	DOUBLE OPEN END SPANNER (6 TO 32 MM)	58	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
255	SOCKET 1/2" HEX 30 MM	59	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
256	SOCKET 1/2" HEX 32 MM	60	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
257	SOCKET 1/2" HEX 26 MM	61	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
258	SOCKET 1/2" HEX 24 MM	62	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
259	SOCKET 1/2" HEX 20 MM	63	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
260	SOCKET 1/2" HEX 22 MM	64	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
261	T HANDLE (12" LENGTH)	65	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
262	TOOL BOX COLLAPSIBLE 17*9*6.5"	66	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
263	A/C 2 TONE	67	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
264	GRINDING BED	68	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
265	BOLT AND NUT	69	8	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
266	WATER	70	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
267	SANTOR WHEEL 4"	71	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
268	BOX FILE	72	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
269	SHOTBLASTING BLADE	73	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
270	SHOTBLASTING IMPELLER	74	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
271	SHOTBLASTING CONTROL CAGE	75	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
272	HOSITER	76	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
273	FAN	77	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
274	WHITE PAINT	78	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
275	BLUE PAING	79	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
276	COMPRESSOR	80	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
277	ADI 230*7*22.23 MM	81	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
278	J24 300*7*25.4	82	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
279	DC WHEEL	83	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
280	RPW 400*50*127	84	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
281	NAGA 400*50*127	85	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
282	400*50*127 C163 ZRC	86	7	1.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
283	400*50*127 C163 ZRC SPEED WHEEL	87	7	1.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
284	TURPENTINE OIL	88	9	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
285	ATTANCE	89	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
286	EB	90	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
287	RENT	91	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
288	AG 4 WHEEL	92	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
289	230*5*22.23 C 30	93	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
290	9 DC WHEEL C30	94	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
291	15 MM DIAMOND MOUNT POINTED	95	7	1.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
292	15 MM SPINDLE	96	7	1.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
293	DISK INNER	97	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
294	MS PLATE FOR INNER DISK	98	7	0.000	0.000	t	2026-08-03 14:42:06.757882+00	2026-08-03 14:42:06.757882+00
\.


--
-- Data for Name: units_of_measure; Type: TABLE DATA; Schema: master; Owner: orbx
--

COPY master.units_of_measure (id, name, symbol, created_at) FROM stdin;
7	Numbers	nos	2026-08-03 14:42:06.740983+00
8	Kilogram	kgs	2026-08-03 14:42:06.740983+00
9	Liter	ltr	2026-08-03 14:42:06.740983+00
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

SELECT pg_catalog.setval('fy_2023_2024.advance_payments_id_seq', 57, true);


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

SELECT pg_catalog.setval('fy_2023_2024.job_work_entries_id_seq', 3, true);


--
-- Name: labour_bills_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.labour_bills_id_seq', 777, true);


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

SELECT pg_catalog.setval('fy_2023_2024.stock_inward_id_seq', 1440, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_outward_id_seq', 1911, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.stock_transfer_id_seq', 1, false);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.voucher_lines_id_seq', 78, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2023_2024; Owner: orbx
--

SELECT pg_catalog.setval('fy_2023_2024.vouchers_id_seq', 39, true);


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.advance_payments_id_seq', 6, true);


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

SELECT pg_catalog.setval('fy_2024_2025.labour_bills_id_seq', 330, true);


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

SELECT pg_catalog.setval('fy_2024_2025.stock_inward_id_seq', 528, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_outward_id_seq', 558, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.stock_transfer_id_seq', 1, false);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.voucher_lines_id_seq', 1662, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2024_2025; Owner: orbx
--

SELECT pg_catalog.setval('fy_2024_2025.vouchers_id_seq', 837, true);


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.advance_payments_id_seq', 1488, true);


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

SELECT pg_catalog.setval('fy_2025_2026.labour_bills_id_seq', 2220, true);


--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.salary_vouchers_id_seq', 15, true);


--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_adjustments_id_seq', 1, false);


--
-- Name: stock_inward_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_inward_id_seq', 10770, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_outward_id_seq', 333, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.stock_transfer_id_seq', 1, false);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.voucher_lines_id_seq', 1278, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2025_2026; Owner: orbx
--

SELECT pg_catalog.setval('fy_2025_2026.vouchers_id_seq', 639, true);


--
-- Name: advance_payments_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.advance_payments_id_seq', 1026, true);


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

SELECT pg_catalog.setval('fy_2026_2027.labour_bills_id_seq', 399, true);


--
-- Name: salary_vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.salary_vouchers_id_seq', 6, true);


--
-- Name: stock_adjustments_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_adjustments_id_seq', 1, false);


--
-- Name: stock_inward_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_inward_id_seq', 4056, true);


--
-- Name: stock_item_movements_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_item_movements_id_seq', 1, false);


--
-- Name: stock_outward_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_outward_id_seq', 3, true);


--
-- Name: stock_transfer_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.stock_transfer_id_seq', 6, true);


--
-- Name: voucher_lines_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.voucher_lines_id_seq', 1908, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: fy_2026_2027; Owner: orbx
--

SELECT pg_catalog.setval('fy_2026_2027.vouchers_id_seq', 954, true);


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

SELECT pg_catalog.setval('master.ledger_groups_id_seq', 99, true);


--
-- Name: ledgers_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.ledgers_id_seq', 1893, true);


--
-- Name: processes_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.processes_id_seq', 13, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.products_id_seq', 3102, true);


--
-- Name: rates_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.rates_id_seq', 4, true);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.role_permissions_id_seq', 1, false);


--
-- Name: stock_items_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.stock_items_id_seq', 294, true);


--
-- Name: units_of_measure_id_seq; Type: SEQUENCE SET; Schema: master; Owner: orbx
--

SELECT pg_catalog.setval('master.units_of_measure_id_seq', 9, true);


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

\unrestrict 2Ie990lwVOelci6ymv4nLygUOn0GcVgHLWbQ56xiSaIGhAMR4kEBHxUTJUaETpj

