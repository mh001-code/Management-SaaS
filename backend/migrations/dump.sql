--
-- PostgreSQL database cluster dump
--

-- Started on 2026-03-24 16:11:00

\restrict K0kThDg3OL8tRTdTwqCE8gD5Jyvawd8htLXgUI6nAZfNICd7uXCBg5E9YigUmYr

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:6+g9qEYbXSGbL8GoTCOXPg==$bXccnvVGs/gG1htwTd6Tdp2cNZW321t7a7AY0aravp4=:NbRNAmG/5QFfwWIrofEA9ymqdY8WW5Ik78bk4FiqB0s=';
CREATE ROLE saas_user;
ALTER ROLE saas_user WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:eMh8XBii3Dk0UwyE3dTzJA==$hIZVb9iBEmNFtAzNkDyB0EgK4zoYQKlC7uVlhLzGfHA=:c10k+gM7cZTtCl4TfGTxxlqHR7nO9VFTDzBeVrk+F+0=';

--
-- User Configurations
--








\unrestrict K0kThDg3OL8tRTdTwqCE8gD5Jyvawd8htLXgUI6nAZfNICd7uXCBg5E9YigUmYr

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict CxYswWcUuqIT81i1BHt6y8o7nVKTr8MtYdkHaUusCd7eE7xZeI3oSB0xvhTmWsG

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.6

-- Started on 2026-03-24 16:11:00

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

-- Completed on 2026-03-24 16:11:00

--
-- PostgreSQL database dump complete
--

\unrestrict CxYswWcUuqIT81i1BHt6y8o7nVKTr8MtYdkHaUusCd7eE7xZeI3oSB0xvhTmWsG

--
-- Database "management_saas" dump
--

--
-- PostgreSQL database dump
--

\restrict De1dZAp3oGA5KtnTnInpt97z5YcjPb9XxuDlmRE1axOegvSGzj6XT9ZIaB3m3LV

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.6

-- Started on 2026-03-24 16:11:00

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
-- TOC entry 5032 (class 1262 OID 16399)
-- Name: management_saas; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE management_saas WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'pt-BR';


ALTER DATABASE management_saas OWNER TO postgres;

\unrestrict De1dZAp3oGA5KtnTnInpt97z5YcjPb9XxuDlmRE1axOegvSGzj6XT9ZIaB3m3LV
\connect management_saas
\restrict De1dZAp3oGA5KtnTnInpt97z5YcjPb9XxuDlmRE1axOegvSGzj6XT9ZIaB3m3LV

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
-- TOC entry 2 (class 3079 OID 16585)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16437)
-- Name: clients; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(150),
    phone character varying(20),
    address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT clients_name_check CHECK ((TRIM(BOTH FROM name) <> ''::text))
);


ALTER TABLE public.clients OWNER TO saas_user;

--
-- TOC entry 220 (class 1259 OID 16436)
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO saas_user;

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 220
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- TOC entry 229 (class 1259 OID 16500)
-- Name: logs; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    user_id integer,
    route text NOT NULL,
    method character varying(10) NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.logs OWNER TO saas_user;

--
-- TOC entry 228 (class 1259 OID 16499)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO saas_user;

--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 228
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 237 (class 1259 OID 16576)
-- Name: migrations; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.migrations OWNER TO saas_user;

--
-- TOC entry 236 (class 1259 OID 16575)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO saas_user;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 236
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 225 (class 1259 OID 16468)
-- Name: order_items; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(12,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO saas_user;

--
-- TOC entry 224 (class 1259 OID 16467)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO saas_user;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 224
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 223 (class 1259 OID 16449)
-- Name: orders; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    client_id integer NOT NULL,
    user_id integer NOT NULL,
    total numeric(12,2) NOT NULL,
    status character varying(50) DEFAULT 'Pendente'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT orders_total_check CHECK ((total > (0)::numeric))
);


ALTER TABLE public.orders OWNER TO saas_user;

--
-- TOC entry 222 (class 1259 OID 16448)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO saas_user;

--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 222
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 219 (class 1259 OID 16426)
-- Name: products; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    stock integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric))
);


ALTER TABLE public.products OWNER TO saas_user;

--
-- TOC entry 218 (class 1259 OID 16425)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO saas_user;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 243 (class 1259 OID 16668)
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.purchase_order_items (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_cost numeric(12,2) NOT NULL,
    CONSTRAINT purchase_order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT purchase_order_items_unit_cost_check CHECK ((unit_cost >= (0)::numeric))
);


ALTER TABLE public.purchase_order_items OWNER TO saas_user;

--
-- TOC entry 242 (class 1259 OID 16667)
-- Name: purchase_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.purchase_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_order_items_id_seq OWNER TO saas_user;

--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 242
-- Name: purchase_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.purchase_order_items_id_seq OWNED BY public.purchase_order_items.id;


--
-- TOC entry 241 (class 1259 OID 16644)
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.purchase_orders (
    id integer NOT NULL,
    supplier_id integer NOT NULL,
    user_id integer,
    total numeric(12,2) DEFAULT 0 NOT NULL,
    status character varying(20) DEFAULT 'pendente'::character varying NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT purchase_orders_status_check CHECK (((status)::text = ANY ((ARRAY['pendente'::character varying, 'confirmado'::character varying, 'recebido'::character varying, 'cancelado'::character varying])::text[]))),
    CONSTRAINT purchase_orders_total_check CHECK ((total >= (0)::numeric))
);


ALTER TABLE public.purchase_orders OWNER TO saas_user;

--
-- TOC entry 240 (class 1259 OID 16643)
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.purchase_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_orders_id_seq OWNER TO saas_user;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 240
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- TOC entry 227 (class 1259 OID 16485)
-- Name: stock; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.stock (
    id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.stock OWNER TO saas_user;

--
-- TOC entry 226 (class 1259 OID 16484)
-- Name: stock_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_id_seq OWNER TO saas_user;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 226
-- Name: stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.stock_id_seq OWNED BY public.stock.id;


--
-- TOC entry 239 (class 1259 OID 16623)
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.stock_movements (
    id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    type character varying(30) NOT NULL,
    reference_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.stock_movements OWNER TO saas_user;

--
-- TOC entry 238 (class 1259 OID 16622)
-- Name: stock_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.stock_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_movements_id_seq OWNER TO saas_user;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 238
-- Name: stock_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.stock_movements_id_seq OWNED BY public.stock_movements.id;


--
-- TOC entry 231 (class 1259 OID 16511)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(255),
    phone character varying(30),
    document character varying(30),
    contact_name character varying(150),
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.suppliers OWNER TO saas_user;

--
-- TOC entry 230 (class 1259 OID 16510)
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_seq OWNER TO saas_user;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 230
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- TOC entry 233 (class 1259 OID 16525)
-- Name: transaction_categories; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.transaction_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT transaction_categories_type_check CHECK (((type)::text = ANY ((ARRAY['receita'::character varying, 'despesa'::character varying, 'ambos'::character varying])::text[])))
);


ALTER TABLE public.transaction_categories OWNER TO saas_user;

--
-- TOC entry 232 (class 1259 OID 16524)
-- Name: transaction_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.transaction_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_categories_id_seq OWNER TO saas_user;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 232
-- Name: transaction_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.transaction_categories_id_seq OWNED BY public.transaction_categories.id;


--
-- TOC entry 235 (class 1259 OID 16536)
-- Name: transactions; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    type character varying(10) NOT NULL,
    description character varying(255) NOT NULL,
    amount numeric(12,2) NOT NULL,
    due_date date NOT NULL,
    paid_date date,
    status character varying(20) DEFAULT 'pendente'::character varying NOT NULL,
    category_id integer,
    order_id integer,
    client_id integer,
    supplier_id integer,
    user_id integer,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_dates_check CHECK (((paid_date IS NULL) OR (paid_date >= due_date))),
    CONSTRAINT transactions_status_check CHECK (((status)::text = ANY ((ARRAY['pendente'::character varying, 'pago'::character varying, 'vencido'::character varying, 'cancelado'::character varying])::text[]))),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['receita'::character varying, 'despesa'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO saas_user;

--
-- TOC entry 234 (class 1259 OID 16535)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO saas_user;

--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 234
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- TOC entry 217 (class 1259 OID 16414)
-- Name: users; Type: TABLE; Schema: public; Owner: saas_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    role character varying(20) DEFAULT 'user'::character varying,
    CONSTRAINT users_email_check CHECK ((TRIM(BOTH FROM email) <> ''::text))
);


ALTER TABLE public.users OWNER TO saas_user;

--
-- TOC entry 216 (class 1259 OID 16413)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: saas_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO saas_user;

--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saas_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4743 (class 2604 OID 16440)
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- TOC entry 4753 (class 2604 OID 16503)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 4762 (class 2604 OID 16579)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 16471)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 16452)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 16429)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 4770 (class 2604 OID 16671)
-- Name: purchase_order_items id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_order_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_items_id_seq'::regclass);


--
-- TOC entry 4766 (class 2604 OID 16647)
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 16488)
-- Name: stock id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock ALTER COLUMN id SET DEFAULT nextval('public.stock_id_seq'::regclass);


--
-- TOC entry 4764 (class 2604 OID 16626)
-- Name: stock_movements id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock_movements ALTER COLUMN id SET DEFAULT nextval('public.stock_movements_id_seq'::regclass);


--
-- TOC entry 4755 (class 2604 OID 16514)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 4757 (class 2604 OID 16528)
-- Name: transaction_categories id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transaction_categories ALTER COLUMN id SET DEFAULT nextval('public.transaction_categories_id_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 16539)
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 16417)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5004 (class 0 OID 16437)
-- Dependencies: 221
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.clients (id, name, email, phone, address, created_at) FROM stdin;
2	Empresa ABC	contato@empresaabc.com	+55 11 99999-8888	Rua A, 123, São Paulo	2025-09-17 15:27:28.940315
6	Microsoft	mocrosoft@microsoft.com		\N	2025-11-07 18:01:59.297451
7	Meta	meta@meta.com		\N	2025-11-07 18:02:07.964659
5	Google	google@google.com		\N	2025-11-07 18:01:35.37511
9	Loja Tech Center	contato@techcenter.com.br	+55 21 98888-7777	Av. Atlântica, 500, Copacabana, Rio de Janeiro - RJ	2026-03-18 16:16:51.058434
10	Distribuidora Digital Max	vendas@digitalmax.com.br	+55 31 97777-6666	Rua das Flores, 250, Savassi, Belo Horizonte - MG	2026-03-18 16:17:04.965505
11	Shopping Eletrônicos Prime	prime@shoppingeletronicos.com.br	+55 41 96666-5555	Av. das Torres, 1200, Centro, Curitiba - PR	2026-03-18 16:17:17.860578
12	Empresa Conecta Solutions	suporte@conectasolutions.com.br	+55 51 95555-4444	Rua Independência, 45, Cidade Baixa, Porto Alegre - RS	2026-03-18 16:17:29.197788
13	Rede SmartHouse	compras@smarthouse.com.br	+55 62 94444-3333	Av. Goiás, 789, Setor Central, Goiânia - GO	2026-03-18 16:17:41.39795
14	TechWorld Comércio Ltda	contato@techworld.com.br	+55 11 98888-1111	Av. Paulista, 1500, Bela Vista, São Paulo - SP	2026-03-18 16:18:05.987332
15	Eletrônicos Nova Era	\N	\N	\N	2026-03-18 16:18:09.069859
16	Eletrônicos Nova Era	vendas@novaeraeletronicos.com.br	+55 21 97777-2222	Rua das Laranjeiras, 300, Laranjeiras, Rio de Janeiro - RJ	2026-03-18 16:18:28.672403
17	Digital House Distribuidora	suporte@digitalhouse.com.br	+55 31 96666-3333	Av. Afonso Pena, 1200, Centro, Belo Horizonte - MG	2026-03-18 16:18:39.701782
18	MegaTech Solutions	compras@megatech.com.br	+55 41 95555-4444	Rua XV de Novembro, 789, Centro, Curitiba - PR	2026-03-18 16:18:51.973557
19	SmartShop Eletrônicos	atendimento@smartshop.com.br	+55 51 94444-5555	Av. Ipiranga, 2000, Jardim Botânico, Porto Alegre - RS	2026-03-18 16:19:08.598
20	Conecta Digital Ltda	contato@conectadigital.com.br	+55 62 93333-6666	Av. Anhanguera, 500, Setor Central, Goiânia - GO	2026-03-18 16:19:20.927508
21	Infinity Tech Comércio	vendas@infinitytech.com.br	+55 85 92222-7777	Rua Floriano Peixoto, 250, Centro, Fortaleza - CE	2026-03-18 16:19:35.129468
22	Prime Eletrônicos S.A.	prime@eletronicosprime.com.br	+55 71 91111-8888	Av. Tancredo Neves, 1000, Caminho das Árvores, Salvador - BA	2026-03-18 16:19:47.797463
23	DigitalMax Importadora	suporte@digitalmax.com.br	+55 95 90000-9999	Av. Getúlio Vargas, 400, Centro, Manaus - AM	2026-03-18 16:19:59.906025
24	TechStore Brasil	compras@techstore.com.br	+55 48 98888-0000	Rua Hercílio Luz, 350, Centro, Florianópolis - SC	2026-03-18 16:20:10.352506
\.


--
-- TOC entry 5012 (class 0 OID 16500)
-- Dependencies: 229
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.logs (id, user_id, route, method, status, created_at) FROM stdin;
1	1	/api/orders	GET	200	2025-09-18 17:15:27.656313
2	1	/api/logs	GET	200	2025-09-18 17:17:28.713855
3	1	/api/logs	GET	200	2025-09-18 17:17:38.731172
4	\N	/api/auth/login	POST	401	2025-09-19 16:26:38.511963
5	\N	/api/auth/login	POST	401	2025-09-19 16:32:36.112536
6	\N	/api/users/5	DELETE	401	2025-09-19 16:40:40.177183
7	\N	/api/auth/login	POST	200	2025-09-19 16:40:51.419349
8	1	/api/users/5	DELETE	403	2025-09-19 16:41:08.46011
9	\N	/api/auth/register	POST	201	2025-09-19 16:51:16.842753
10	\N	/api/auth/login	POST	200	2025-09-19 16:51:36.650968
11	\N	/api/summary	GET	404	2025-09-19 16:51:36.75328
12	\N	/api/summary	GET	404	2025-09-19 16:51:36.788904
13	\N	/api/auth/login	POST	200	2025-09-19 17:02:23.561897
14	\N	/api/auth/login	POST	200	2025-09-19 17:02:48.312786
15	\N	/api/auth/login	POST	200	2025-09-19 17:10:18.53749
16	\N	/api/auth/login	POST	200	2025-09-19 17:12:39.882846
17	\N	/api/auth/login	POST	200	2025-09-19 17:14:44.268991
18	\N	/api/auth/login	POST	200	2025-09-19 17:19:10.900247
19	\N	/api/auth/login	POST	200	2025-09-19 17:22:06.456716
20	\N	/	GET	200	2025-10-17 21:25:22.338607
21	\N	/favicon.ico	GET	404	2025-10-17 21:25:22.664265
22	\N	/api/auth/login	POST	200	2025-10-17 21:51:56.413529
23	6	/api/clients	GET	200	2025-10-17 21:52:10.401998
24	6	/api/clients	GET	304	2025-10-17 21:52:10.541716
25	6	/api/products	GET	200	2025-10-17 21:52:12.575594
26	6	/api/products	GET	304	2025-10-17 21:52:12.578812
27	6	/api/orders	GET	200	2025-10-17 21:52:14.745664
28	6	/api/orders	GET	304	2025-10-17 21:52:14.748685
29	6	/api/users	GET	403	2025-10-17 21:52:16.727611
30	6	/api/users	GET	403	2025-10-17 21:52:16.73028
31	6	/api/clients	GET	304	2025-10-17 21:54:28.16707
32	6	/api/clients	GET	304	2025-10-17 21:54:28.200093
33	6	/api/products	GET	304	2025-10-17 21:54:29.33301
34	6	/api/products	GET	304	2025-10-17 21:54:29.337064
35	6	/api/orders	GET	304	2025-10-17 21:54:30.543533
36	6	/api/orders	GET	304	2025-10-17 21:54:30.546555
37	6	/api/orders	GET	304	2025-10-17 21:54:40.298333
38	6	/api/orders	GET	304	2025-10-17 21:54:40.300735
39	6	/api/products	GET	304	2025-10-17 21:54:49.703454
40	6	/api/products	GET	304	2025-10-17 21:54:49.706412
41	6	/api/clients	GET	304	2025-10-17 21:54:51.57435
42	6	/api/clients	GET	304	2025-10-17 21:54:51.576114
43	\N	/api/users	GET	401	2025-10-17 21:55:28.122433
44	\N	/api/auth/login	POST	200	2025-10-17 21:55:40.753368
45	1	/api/users	GET	403	2025-10-17 21:55:55.506948
46	\N	/api/auth/login/5	POST	404	2025-10-17 21:56:17.516325
47	\N	/api/auth/login/	POST	200	2025-10-17 21:56:33.117711
48	\N	/api/auth/login/2	POST	404	2025-10-17 21:56:40.127757
49	\N	/api/auth/login	POST	200	2025-10-17 22:08:06.341879
50	\N	/api/auth/login	POST	401	2025-10-17 22:08:26.125418
51	\N	/api/auth/login	POST	401	2025-10-17 22:08:27.611113
52	\N	/api/auth/login	POST	401	2025-10-17 22:08:31.545598
53	\N	/api/auth/login	POST	200	2025-10-17 22:08:35.18935
54	\N	/api/auth/login	POST	200	2025-10-17 22:12:44.097726
55	5	/api/clients	GET	304	2025-10-17 22:12:47.780576
56	5	/api/clients	GET	304	2025-10-17 22:12:47.814009
57	5	/api/products	GET	304	2025-10-17 22:12:48.204953
58	5	/api/products	GET	304	2025-10-17 22:12:48.209632
59	5	/api/orders	GET	304	2025-10-17 22:12:48.644044
60	5	/api/orders	GET	304	2025-10-17 22:12:48.647372
61	\N	/api/auth/login	POST	200	2025-10-17 22:16:51.684457
62	\N	/api/products	GET	401	2025-10-17 22:18:54.306046
63	\N	/api/products	GET	401	2025-10-17 22:18:54.306195
64	\N	/api/auth/login	POST	200	2025-10-17 22:19:08.064677
65	\N	/api/auth/login	POST	200	2025-10-17 22:21:30.29359
66	\N	/api/auth/login	POST	401	2025-10-17 22:21:58.990857
67	\N	/api/auth/login	POST	200	2025-10-17 22:22:01.279137
68	\N	/api/auth/login	POST	200	2025-10-17 22:26:06.481494
69	7	/api/clients	GET	304	2025-10-17 22:26:09.33938
70	7	/api/clients	GET	304	2025-10-17 22:26:09.373128
71	\N	/api/auth/login	POST	200	2025-10-17 22:29:08.681105
72	\N	/api/auth/login	POST	401	2025-10-17 22:29:21.456758
73	\N	/api/auth/login	POST	200	2025-10-17 22:29:24.766112
74	7	/api/orders	GET	304	2025-10-17 22:29:44.796864
75	7	/api/orders	GET	304	2025-10-17 22:29:44.830459
76	7	/api/products	GET	304	2025-10-17 22:29:46.270381
77	7	/api/products	GET	304	2025-10-17 22:29:46.275032
78	7	/api/clients	GET	304	2025-10-17 22:29:47.880272
79	7	/api/clients	GET	304	2025-10-17 22:29:47.883901
80	\N	/api/auth/login	POST	200	2025-10-17 22:39:49.752551
81	7	/api/clients	GET	200	2025-10-17 22:43:37.265253
82	7	/api/clients	GET	200	2025-10-17 22:43:37.297082
83	7	/api/clients	GET	304	2025-10-17 22:43:39.247849
84	7	/api/clients	GET	304	2025-10-17 22:43:39.249789
85	7	/api/products	GET	304	2025-10-17 22:43:40.075757
86	7	/api/products	GET	304	2025-10-17 22:43:40.080613
87	7	/api/orders	GET	304	2025-10-17 22:43:40.684708
88	7	/api/orders	GET	304	2025-10-17 22:43:40.688076
89	7	/api/clients	GET	304	2025-10-17 22:46:52.343872
90	7	/api/clients	GET	304	2025-10-17 22:46:52.490682
91	7	/api/products	GET	304	2025-10-17 22:46:57.126995
92	7	/api/products	GET	304	2025-10-17 22:46:57.133089
93	7	/api/orders	GET	304	2025-10-17 22:46:58.780168
94	7	/api/orders	GET	304	2025-10-17 22:46:58.786128
95	\N	/api/auth/login	POST	200	2025-10-17 22:51:21.095777
96	7	/api/users	GET	200	2025-10-17 22:51:36.389373
97	7	/api/users	GET	304	2025-10-17 22:51:36.425513
98	7	/api/orders	GET	304	2025-10-17 22:51:45.974434
99	7	/api/orders	GET	304	2025-10-17 22:51:45.979081
100	7	/api/products	GET	304	2025-10-17 22:51:48.126602
101	7	/api/products	GET	304	2025-10-17 22:51:48.13337
102	7	/api/clients	GET	304	2025-10-17 22:51:49.747328
103	7	/api/clients	GET	304	2025-10-17 22:51:49.751888
104	7	/api/users	GET	304	2025-10-17 22:51:57.656982
105	7	/api/users	GET	304	2025-10-17 22:51:57.661143
106	7	/api/orders	GET	304	2025-10-17 22:51:59.035767
107	7	/api/orders	GET	304	2025-10-17 22:51:59.038722
108	7	/api/products	GET	304	2025-10-17 22:52:00.409224
109	7	/api/products	GET	304	2025-10-17 22:52:00.41349
110	7	/api/users	GET	304	2025-10-17 22:52:01.199484
111	7	/api/users	GET	304	2025-10-17 22:52:01.203319
112	7	/api/orders	GET	304	2025-10-17 22:52:04.054446
113	7	/api/orders	GET	304	2025-10-17 22:52:04.056809
114	7	/api/products	GET	304	2025-10-17 22:52:04.484536
115	7	/api/products	GET	304	2025-10-17 22:52:04.488111
116	7	/api/clients	GET	304	2025-10-17 22:52:04.937677
117	7	/api/clients	GET	304	2025-10-17 22:52:04.9401
118	7	/api/products	GET	304	2025-10-17 22:52:56.882775
119	7	/api/products	GET	304	2025-10-17 22:52:57.019291
120	7	/api/clients	GET	304	2025-10-17 22:52:59.168174
121	7	/api/clients	GET	304	2025-10-17 22:52:59.171555
122	7	/api/products	GET	304	2025-10-17 22:53:00.568087
125	7	/api/orders	GET	304	2025-10-17 22:53:01.196173
1275	7	/api/clients	GET	304	2025-10-28 16:47:52.516623
1292	7	/api/orders	GET	200	2025-10-28 16:47:57.775829
1293	7	/api/clients	GET	304	2025-10-28 16:48:05.131638
1297	7	/api/products	GET	304	2025-10-28 16:48:05.143684
1300	7	/api/products	GET	200	2025-10-28 16:48:06.963346
1315	7	/api/products	GET	200	2025-10-28 16:48:11.228217
1318	7	/api/products	GET	304	2025-10-28 16:48:15.852177
1322	7	/api/orders	GET	304	2025-10-28 16:48:15.863026
1323	7	/api/clients	GET	304	2025-10-28 16:48:18.252826
1327	7	/api/products	GET	304	2025-10-28 16:48:18.261542
1330	7	/api/products	GET	304	2025-10-28 16:48:20.557608
1334	7	/api/orders	GET	304	2025-10-28 16:48:20.566358
1335	7	/api/clients	GET	304	2025-10-28 16:48:24.738371
1339	7	/api/products	GET	304	2025-10-28 16:48:24.747533
1342	7	/api/products	GET	304	2025-10-28 16:48:26.243401
1346	7	/api/orders	GET	304	2025-10-28 16:48:26.253032
1347	7	/api/clients	GET	200	2025-10-28 16:48:27.212121
1354	7	/api/products	GET	200	2025-10-28 16:49:21.208448
1362	7	/api/products	GET	200	2025-10-28 16:49:51.297385
1368	7	/api/orders	GET	200	2025-10-28 16:49:54.304566
1373	7	/api/clients	GET	200	2025-10-28 16:50:00.230897
1380	7	/api/clients	GET	200	2025-10-28 16:50:00.837163
1388	7	/api/orders	GET	304	2025-10-28 16:51:41.923639
1389	7	/api/clients	GET	304	2025-10-28 16:51:42.33715
1400	7	/api/orders	GET	200	2025-10-28 16:51:43.205161
1408	7	/api/products	GET	304	2025-10-28 16:52:14.596002
1411	7	/api/orders	GET	304	2025-10-28 16:52:14.606985
1414	7	/api/clients	GET	304	2025-10-28 16:52:16.077821
1415	7	/api/products	GET	304	2025-10-28 16:52:17.287511
1418	7	/api/clients	GET	304	2025-10-28 16:52:18.310297
1419	7	/api/clients	GET	304	2025-10-28 16:52:19.715575
1422	7	/api/products	GET	304	2025-10-28 16:52:20.674504
1423	7	/api/clients	GET	304	2025-10-28 16:52:21.635002
1436	7	/api/orders	GET	304	2025-10-28 16:52:23.161519
1451	7	/api/orders	GET	304	2025-10-28 16:52:30.477324
1453	7	/api/users	GET	304	2025-10-28 16:52:31.501231
1456	7	/api/orders	GET	304	2025-10-28 16:52:32.545499
1460	7	/api/clients	GET	304	2025-10-28 16:52:32.556275
1461	7	/api/users	GET	304	2025-10-28 16:52:33.663315
1469	7	/api/orders	GET	304	2025-10-28 16:54:01.847773
1472	7	/api/users	GET	304	2025-10-28 16:54:04.647597
1473	7	/api/clients	GET	304	2025-10-28 16:54:05.676631
1475	7	/api/orders	GET	304	2025-10-28 16:54:05.685235
1478	7	/api/products	GET	304	2025-10-28 16:54:05.694181
1479	7	/api/products	GET	304	2025-10-28 16:54:06.100709
1482	7	/api/clients	GET	304	2025-10-28 16:54:06.693149
1483	7	/api/users	GET	304	2025-10-28 16:54:07.426361
1520	7	/api/users	GET	304	2025-10-28 16:57:31.24077
1570	7	/api/clients	GET	304	2025-10-28 16:59:06.296263
1571	7	/api/clients	GET	304	2025-10-28 16:59:07.764464
1634	7	/api/clients	GET	304	2025-10-28 17:00:15.955398
1674	7	/api/orders	GET	304	2025-10-28 17:01:35.389229
1684	7	/api/orders	GET	304	2025-10-28 17:01:52.19939
1685	7	/api/clients	GET	304	2025-10-28 17:01:56.226165
1689	7	/api/products	GET	304	2025-10-28 17:01:56.236045
1692	7	/api/products	GET	304	2025-10-28 17:02:02.010679
1696	7	/api/orders	GET	304	2025-10-28 17:02:02.020998
1697	7	/api/clients	GET	304	2025-10-28 17:02:08.001971
1701	7	/api/products	GET	304	2025-10-28 17:02:08.010608
1704	7	/api/users	GET	304	2025-10-28 17:02:14.38018
1705	7	/api/products	GET	304	2025-10-28 17:02:18.863292
1708	7	/api/clients	GET	304	2025-10-28 17:02:21.639608
1710	7	/api/orders	GET	304	2025-10-28 17:02:21.681218
1784	7	/api/clients	GET	304	2025-10-28 17:04:37.817406
1798	7	/api/clients	GET	304	2025-10-28 17:11:28.493605
1799	7	/api/products	GET	304	2025-10-28 17:11:28.981811
1802	7	/api/clients	GET	304	2025-10-28 17:11:30.161435
1803	7	/api/products	GET	304	2025-10-28 17:11:31.320808
1806	7	/api/products	GET	304	2025-10-28 17:11:31.949175
1809	7	/api/orders	GET	304	2025-10-28 17:11:31.998557
1812	7	/api/users	GET	304	2025-10-28 17:11:33.056342
1817	7	/api/products	GET	304	2025-10-28 17:11:44.181162
1820	7	/api/products	GET	304	2025-10-28 17:11:45.391598
1821	7	/api/clients	GET	304	2025-10-28 17:11:46.039301
1824	7	/api/clients	GET	304	2025-10-28 17:11:51.949926
1825	7	/api/products	GET	304	2025-10-28 17:11:53.241992
1828	7	/api/products	GET	304	2025-10-28 17:11:54.348602
1831	7	/api/orders	GET	304	2025-10-28 17:11:54.391723
1834	7	/api/products	GET	304	2025-10-28 17:11:58.438801
1835	7	/api/users	GET	304	2025-10-28 17:11:59.365861
1838	7	/api/clients	GET	304	2025-10-28 17:11:59.911903
1842	7	/api/orders	GET	304	2025-10-28 17:11:59.921476
1843	7	/api/products	GET	304	2025-10-28 17:12:00.527758
1846	7	/api/clients	GET	304	2025-10-28 17:12:00.851372
1850	7	/api/clients	GET	200	2025-10-28 17:48:04.986483
1872	7	/api/clients	GET	304	2025-10-28 18:12:35.433382
1896	7	/api/clients	GET	304	2025-10-28 18:15:40.849606
1899	7	/api/clients	GET	304	2025-10-28 18:15:42.803698
1928	7	/api/clients	GET	304	2025-10-28 18:20:36.197993
1931	7	/api/clients	GET	304	2025-10-28 18:20:45.852624
1932	7	/api/clients	GET	304	2025-10-28 18:20:51.994726
1935	7	/api/clients	GET	200	2025-10-28 18:20:52.575521
1936	7	/api/clients	GET	304	2025-10-28 18:20:54.204756
1950	7	/api/products	GET	200	2025-10-28 18:21:41.197813
1953	7	/api/users	GET	200	2025-10-28 18:21:42.664305
1954	7	/api/clients	GET	200	2025-10-28 18:21:44.256495
1964	7	/api/clients	GET	200	2025-10-28 18:25:30.62688
1966	7	/api/clients	GET	200	2025-10-28 18:25:34.983696
1969	7	/api/clients	GET	200	2025-10-28 18:25:45.353327
1970	7	/api/products	GET	304	2025-10-28 18:25:47.915509
1985	7	/api/products	GET	200	2025-10-28 18:28:08.810761
1996	7	/api/clients	GET	304	2025-10-28 18:30:53.162356
1999	7	/api/clients	GET	200	2025-10-28 18:30:53.477884
2000	7	/api/products	GET	304	2025-10-28 18:31:01.456761
2003	7	/api/users	GET	304	2025-10-28 18:31:03.306726
2011	7	/api/users	GET	304	2025-10-28 18:33:12.097252
2012	7	/api/users	GET	200	2025-10-28 18:33:13.271933
2020	7	/api/clients	GET	304	2025-10-28 18:34:49.192689
2027	7	/api/orders	GET	304	2025-10-28 18:35:15.883293
2035	7	/api/clients	GET	304	2025-10-28 18:35:34.735072
2040	7	/api/clients	GET	200	2025-10-28 18:35:35.768318
2050	7	/api/clients	GET	304	2025-10-28 18:36:13.607958
2053	7	/api/users	GET	304	2025-10-28 18:36:15.170466
2054	7	/api/clients	GET	304	2025-10-28 18:36:16.796646
2083	7	/api/orders	GET	200	2025-10-28 18:36:38.330283
2084	7	/api/users	GET	200	2025-10-28 18:36:42.059143
2093	7	/api/products	GET	304	2025-10-28 18:43:04.535684
123	7	/api/products	GET	304	2025-10-17 22:53:00.57213
124	7	/api/orders	GET	304	2025-10-17 22:53:01.192175
126	7	/api/orders	GET	304	2025-10-17 22:59:21.099022
127	7	/api/orders	GET	304	2025-10-17 22:59:21.133977
128	7	/api/users	GET	304	2025-10-17 22:59:23.559032
129	7	/api/users	GET	304	2025-10-17 22:59:23.564423
130	7	/api/users	GET	200	2025-10-17 22:59:25.186852
131	7	/api/users	GET	200	2025-10-17 22:59:25.187529
132	7	/api/users/6	DELETE	200	2025-10-17 22:59:46.010416
133	7	/api/users	GET	200	2025-10-17 22:59:46.018165
134	7	/api/users/5	PUT	400	2025-10-17 22:59:58.377411
135	7	/api/users	GET	304	2025-10-17 23:01:18.829828
136	7	/api/users	GET	304	2025-10-17 23:01:18.864733
137	7	/api/users	GET	304	2025-10-17 23:01:53.767369
138	7	/api/users	GET	304	2025-10-17 23:01:53.801401
139	7	/api/users	GET	304	2025-10-17 23:01:55.738033
140	7	/api/users	GET	304	2025-10-17 23:01:55.742129
141	7	/api/users	GET	200	2025-10-17 23:01:58.427567
142	7	/api/users	GET	200	2025-10-17 23:01:58.428406
143	7	/api/users/5	PUT	400	2025-10-17 23:02:07.395708
144	7	/api/users	GET	200	2025-10-17 23:03:26.320123
145	7	/api/users	GET	200	2025-10-17 23:03:26.463013
146	7	/api/users/5	PUT	400	2025-10-17 23:03:34.853788
147	7	/api/users	GET	304	2025-10-17 23:04:36.219252
148	7	/api/users	GET	304	2025-10-17 23:04:36.257676
149	7	/api/users	GET	304	2025-10-17 23:04:37.903909
150	7	/api/users	GET	304	2025-10-17 23:04:37.909858
151	7	/api/users	GET	200	2025-10-17 23:04:40.623272
152	7	/api/users	GET	200	2025-10-17 23:04:40.624301
153	7	/api/users/5	PUT	400	2025-10-17 23:04:46.133126
154	7	/api/users	GET	200	2025-10-17 23:06:21.230636
155	7	/api/users	GET	200	2025-10-17 23:06:21.267048
156	7	/api/users/5	PUT	400	2025-10-17 23:06:34.029107
157	\N	/api/auth/login	POST	200	2025-10-17 23:07:54.231307
158	7	/api/users	GET	304	2025-10-17 23:07:58.742015
159	7	/api/users	GET	304	2025-10-17 23:07:58.77819
160	7	/api/orders	GET	304	2025-10-17 23:08:00.773638
161	7	/api/orders	GET	304	2025-10-17 23:08:00.777864
162	7	/api/users	GET	304	2025-10-17 23:08:01.814258
163	7	/api/users	GET	304	2025-10-17 23:08:01.818769
164	7	/api/users/5	PUT	400	2025-10-17 23:08:10.175047
165	7	/api/users	GET	200	2025-10-17 23:10:10.11336
166	7	/api/users	GET	200	2025-10-17 23:10:10.148671
167	7	/api/users/5	PUT	400	2025-10-17 23:10:17.696352
168	\N	/api/auth/login	POST	200	2025-10-17 23:10:49.310345
169	7	/api/users	GET	304	2025-10-17 23:10:52.105086
170	7	/api/users	GET	304	2025-10-17 23:10:52.248991
171	7	/api/users/5	PUT	400	2025-10-17 23:10:58.512966
172	7	/api/users	GET	304	2025-10-17 23:12:27.1465
173	7	/api/users	GET	304	2025-10-17 23:12:27.181706
174	7	/api/users	GET	200	2025-10-17 23:12:34.690671
175	7	/api/users	GET	200	2025-10-17 23:12:34.691771
176	7	/api/users/5	PUT	400	2025-10-17 23:12:40.557331
177	\N	/api/auth/login	POST	200	2025-10-22 14:38:18.708555
178	7	/api/clients	GET	304	2025-10-22 14:48:01.225458
179	7	/api/clients	GET	304	2025-10-22 14:48:01.26126
180	7	/api/products	GET	304	2025-10-22 14:48:02.317155
181	7	/api/products	GET	304	2025-10-22 14:48:02.322819
182	7	/api/orders	GET	304	2025-10-22 14:48:03.897955
183	7	/api/orders	GET	304	2025-10-22 14:48:03.901297
184	7	/api/users	GET	304	2025-10-22 14:48:04.430049
185	7	/api/users	GET	304	2025-10-22 14:48:04.435586
186	7	/api/users/2	PUT	200	2025-10-22 14:48:41.999651
187	7	/api/users	GET	200	2025-10-22 14:48:42.034276
188	7	/api/users/2	PUT	400	2025-10-22 14:48:57.172399
189	7	/api/users	GET	304	2025-10-22 14:50:34.796153
190	7	/api/users	GET	304	2025-10-22 14:50:34.839751
191	7	/api/users/2	PUT	200	2025-10-22 14:50:47.011331
192	7	/api/users	GET	200	2025-10-22 14:50:47.030554
193	7	/api/users/2	PUT	400	2025-10-22 14:50:56.64507
194	7	/api/users	GET	304	2025-10-22 14:52:47.673563
195	7	/api/users	GET	304	2025-10-22 14:52:47.71287
196	7	/api/users/2	PUT	200	2025-10-22 14:52:54.545414
197	7	/api/users	GET	304	2025-10-22 14:52:54.565569
198	7	/api/users/2	PUT	400	2025-10-22 14:53:05.186262
199	\N	/api/auth/login	POST	200	2025-10-22 14:53:48.983902
200	7	/api/users	GET	304	2025-10-22 14:53:55.115609
201	7	/api/users	GET	304	2025-10-22 14:53:55.152991
202	7	/api/users/2	PUT	400	2025-10-22 14:54:24.110517
203	7	/api/users	GET	200	2025-10-22 14:57:28.035184
204	7	/api/users	GET	200	2025-10-22 14:57:28.075455
205	7	/api/users/2	PUT	200	2025-10-22 14:57:38.826955
206	7	/api/users	GET	200	2025-10-22 14:57:38.848027
207	7	/api/users/2	PUT	400	2025-10-22 14:57:57.989455
208	7	/api/users	GET	200	2025-10-22 14:58:34.040382
209	7	/api/users	GET	200	2025-10-22 14:58:34.076772
210	7	/api/users/2	PUT	400	2025-10-22 14:58:57.339332
211	7	/api/users	GET	200	2025-10-22 15:00:30.037205
212	7	/api/users	GET	200	2025-10-22 15:00:30.074341
213	7	/api/users/2	PUT	400	2025-10-22 15:00:36.131171
214	7	/api/users	GET	304	2025-10-22 15:01:50.27731
215	7	/api/users	GET	304	2025-10-22 15:01:50.316196
216	7	/api/users	GET	200	2025-10-22 15:01:54.695547
217	7	/api/users	GET	200	2025-10-22 15:01:54.696412
218	7	/api/users/2	PUT	400	2025-10-22 15:02:06.020914
219	7	/api/users	GET	200	2025-10-22 15:03:38.094421
220	7	/api/users	GET	200	2025-10-22 15:03:38.131606
221	7	/api/users/2	PUT	400	2025-10-22 15:03:43.832962
222	7	/api/users	GET	304	2025-10-22 15:04:17.612506
223	7	/api/users	GET	304	2025-10-22 15:04:17.655616
224	7	/api/users/2	PUT	400	2025-10-22 15:04:31.797705
225	\N	/api/auth/login	POST	200	2025-10-22 15:05:53.30172
226	7	/api/users	GET	304	2025-10-22 15:05:57.132345
227	7	/api/users	GET	304	2025-10-22 15:05:57.171001
228	7	/api/users/2	PUT	400	2025-10-22 15:06:09.665415
229	7	/api/users	GET	200	2025-10-22 15:07:58.434513
230	7	/api/users	GET	200	2025-10-22 15:07:58.471134
231	7	/api/users/2	PUT	400	2025-10-22 15:08:14.434164
232	7	/api/users	GET	200	2025-10-22 15:18:36.06673
233	7	/api/users	GET	200	2025-10-22 15:18:36.10167
234	7	/api/users/2	PUT	200	2025-10-22 15:18:43.578215
235	7	/api/users	GET	200	2025-10-22 15:18:43.589197
236	7	/api/users	POST	404	2025-10-22 15:20:50.212936
237	7	/api/users	GET	304	2025-10-22 15:21:17.899008
238	7	/api/users	GET	304	2025-10-22 15:21:17.937206
239	7	/api/users/2	PUT	200	2025-10-22 15:21:45.658899
240	7	/api/users	GET	200	2025-10-22 15:21:45.666842
241	7	/api/users	POST	404	2025-10-22 15:21:59.363184
242	7	/api/users	GET	200	2025-10-22 15:26:06.943674
243	7	/api/users	GET	200	2025-10-22 15:26:06.946215
244	7	/api/users	POST	404	2025-10-22 15:26:19.183335
245	7	/api/users	GET	200	2025-10-22 15:29:34.711611
246	7	/api/users	GET	200	2025-10-22 15:29:34.749369
247	7	/api/users	POST	201	2025-10-22 15:29:50.688848
248	7	/api/users	GET	200	2025-10-22 15:29:50.695919
249	7	/api/users/8	PUT	200	2025-10-22 15:30:01.609029
250	7	/api/users	GET	200	2025-10-22 15:30:01.616374
251	\N	/api/auth/login	POST	200	2025-10-22 15:30:12.688007
252	8	/api/orders	GET	304	2025-10-22 15:30:18.45389
253	8	/api/orders	GET	304	2025-10-22 15:30:18.488322
254	8	/api/products	GET	304	2025-10-22 15:30:19.098366
255	8	/api/products	GET	304	2025-10-22 15:30:19.103557
256	8	/api/orders	GET	304	2025-10-22 15:30:19.914429
257	8	/api/orders	GET	304	2025-10-22 15:30:19.919685
258	8	/api/products	GET	304	2025-10-22 15:30:20.82775
259	8	/api/products	GET	304	2025-10-22 15:30:20.831642
260	8	/api/clients	GET	304	2025-10-22 15:30:22.101435
261	8	/api/clients	GET	304	2025-10-22 15:30:22.105209
262	8	/api/orders	GET	304	2025-10-22 15:31:43.790015
263	8	/api/orders	GET	304	2025-10-22 15:31:43.824286
264	\N	/api/auth/login	POST	200	2025-10-22 15:31:55.897744
265	7	/api/users	GET	304	2025-10-22 15:31:59.188422
266	7	/api/users	GET	304	2025-10-22 15:31:59.229917
267	7	/api/orders	GET	304	2025-10-22 15:32:03.39027
268	7	/api/orders	GET	304	2025-10-22 15:32:03.392744
269	7	/api/products	GET	304	2025-10-22 15:32:03.970356
270	7	/api/products	GET	304	2025-10-22 15:32:03.975801
271	7	/api/clients	GET	304	2025-10-22 15:32:04.947594
272	7	/api/clients	GET	304	2025-10-22 15:32:04.950673
273	7	/api/products	GET	304	2025-10-22 15:35:19.009236
274	7	/api/products	GET	304	2025-10-22 15:35:19.015501
275	7	/api/products	GET	304	2025-10-22 15:38:11.408472
276	7	/api/products	GET	304	2025-10-22 15:38:11.443832
277	7	/api/products	GET	304	2025-10-22 15:39:08.51545
278	7	/api/products	GET	304	2025-10-22 15:39:08.549128
279	7	/api/products	GET	304	2025-10-22 15:39:11.364603
280	7	/api/products	GET	304	2025-10-22 15:39:11.370556
281	7	/api/products	GET	304	2025-10-22 15:39:13.382056
282	7	/api/products	GET	304	2025-10-22 15:39:13.386075
283	7	/api/products	GET	200	2025-10-22 15:39:17.795839
284	7	/api/products	GET	200	2025-10-22 15:39:17.796496
285	7	/api/products	GET	304	2025-10-22 15:40:31.137226
286	7	/api/products	GET	304	2025-10-22 15:40:31.171205
287	7	/api/products	GET	200	2025-10-22 15:40:32.80291
288	7	/api/products	GET	200	2025-10-22 15:40:32.803772
289	7	/api/products	POST	201	2025-10-22 15:42:08.408602
290	7	/api/products	GET	200	2025-10-22 15:42:08.415492
291	7	/api/products/7	PUT	200	2025-10-22 15:42:15.170701
292	7	/api/products	GET	200	2025-10-22 15:42:15.176703
293	7	/api/products/7	DELETE	200	2025-10-22 15:42:17.273365
294	7	/api/products	GET	200	2025-10-22 15:42:17.279058
295	7	/api/products	POST	400	2025-10-22 15:42:23.589053
296	7	/api/products	POST	400	2025-10-22 15:42:25.119109
297	7	/api/products	POST	400	2025-10-22 15:42:25.261383
298	7	/api/products	POST	400	2025-10-22 15:42:25.413078
299	7	/api/products	POST	400	2025-10-22 15:42:25.565114
300	7	/api/products	GET	304	2025-10-22 15:44:24.407952
301	7	/api/products	GET	304	2025-10-22 15:44:24.441907
302	7	/api/products	GET	304	2025-10-22 15:44:26.034545
303	7	/api/products	GET	304	2025-10-22 15:44:26.038657
304	7	/api/products	GET	200	2025-10-22 15:44:27.601517
305	7	/api/products	GET	200	2025-10-22 15:44:27.602849
306	7	/api/products	POST	201	2025-10-22 15:44:47.502502
307	7	/api/products	GET	200	2025-10-22 15:44:47.509128
308	7	/api/products	GET	304	2025-10-22 15:47:00.148553
309	7	/api/products	GET	304	2025-10-22 15:47:00.183514
310	7	/api/products	GET	304	2025-10-22 15:47:01.097766
311	7	/api/products	GET	304	2025-10-22 15:47:01.102162
312	7	/api/products	GET	200	2025-10-22 15:47:01.857389
313	7	/api/products	GET	200	2025-10-22 15:47:01.858089
314	7	/api/products	POST	201	2025-10-22 15:47:13.551855
315	7	/api/products	GET	200	2025-10-22 15:47:13.588387
316	7	/api/products	GET	304	2025-10-22 15:49:14.424902
317	7	/api/products	GET	304	2025-10-22 15:49:14.460081
318	7	/api/products	GET	304	2025-10-22 15:49:15.076074
319	7	/api/products	GET	304	2025-10-22 15:49:15.08008
320	7	/api/products	GET	304	2025-10-22 15:49:18.069229
321	7	/api/products	GET	304	2025-10-22 15:49:18.073245
322	7	/api/products	GET	304	2025-10-22 15:49:19.092853
323	7	/api/products	GET	304	2025-10-22 15:49:19.097957
324	7	/api/products	GET	304	2025-10-22 15:49:21.114265
325	7	/api/products	GET	304	2025-10-22 15:49:21.118098
326	7	/api/products	GET	304	2025-10-22 15:49:36.285357
327	7	/api/products	GET	304	2025-10-22 15:49:36.320443
328	7	/api/products	GET	200	2025-10-22 15:49:37.319308
329	7	/api/products	GET	200	2025-10-22 15:49:37.320215
330	7	/api/products/9	DELETE	200	2025-10-22 15:49:42.344274
331	7	/api/products	GET	200	2025-10-22 15:49:42.350703
332	7	/api/products	GET	304	2025-10-22 15:52:01.158057
333	7	/api/products	GET	304	2025-10-22 15:52:01.193461
334	7	/api/products	GET	304	2025-10-22 15:52:03.116133
335	7	/api/products	GET	304	2025-10-22 15:52:03.120488
336	7	/api/clients	GET	304	2025-10-22 15:52:17.593965
337	7	/api/clients	GET	304	2025-10-22 15:52:17.626399
338	7	/api/clients	GET	200	2025-10-22 15:52:18.811221
339	7	/api/clients	GET	200	2025-10-22 15:52:18.812358
340	7	/api/clients	POST	201	2025-10-22 15:52:36.57706
341	7	/api/clients	GET	200	2025-10-22 15:52:36.58152
342	7	/api/clients/3	PUT	200	2025-10-22 15:52:42.526461
343	7	/api/clients	GET	200	2025-10-22 15:52:42.531585
344	7	/api/clients/3	DELETE	200	2025-10-22 15:53:07.592952
345	7	/api/clients	GET	200	2025-10-22 15:53:07.598078
346	7	/api/products	GET	304	2025-10-22 15:53:08.647403
347	7	/api/products	GET	304	2025-10-22 15:53:08.827401
348	7	/api/orders	GET	304	2025-10-22 15:53:09.494252
349	7	/api/orders	GET	304	2025-10-22 15:53:09.496352
350	7	/api/clients	GET	304	2025-10-22 15:53:34.437003
351	7	/api/clients	GET	304	2025-10-22 15:53:34.468509
352	7	/api/clients	GET	200	2025-10-22 15:57:06.979533
353	7	/api/clients	GET	200	2025-10-22 15:57:06.979972
354	7	/api/clients	POST	201	2025-10-22 15:57:15.914738
355	7	/api/clients	GET	200	2025-10-22 15:57:15.923574
356	7	/api/clients/4	PUT	200	2025-10-22 15:57:20.265415
357	7	/api/clients	GET	200	2025-10-22 15:57:20.269529
358	7	/api/clients/4	DELETE	200	2025-10-22 15:57:26.168522
359	7	/api/clients	GET	200	2025-10-22 15:57:26.175197
360	7	/api/clients	GET	304	2025-10-22 15:57:28.889096
361	7	/api/clients	GET	304	2025-10-22 15:57:28.922617
362	7	/api/clients	GET	200	2025-10-22 15:59:45.104628
363	7	/api/clients	GET	200	2025-10-22 15:59:45.105066
364	7	/api/orders	GET	304	2025-10-22 15:59:47.246392
1276	7	/api/products	GET	304	2025-10-28 16:47:52.517202
1291	7	/api/products	GET	200	2025-10-28 16:47:57.775084
1294	7	/api/products	GET	304	2025-10-28 16:48:05.132411
1298	7	/api/orders	GET	304	2025-10-28 16:48:05.145492
1299	7	/api/clients	GET	200	2025-10-28 16:48:06.955144
1316	7	/api/orders	GET	200	2025-10-28 16:48:11.228957
1317	7	/api/clients	GET	304	2025-10-28 16:48:15.851155
1321	7	/api/products	GET	304	2025-10-28 16:48:15.862173
1324	7	/api/products	GET	304	2025-10-28 16:48:18.253287
1328	7	/api/orders	GET	304	2025-10-28 16:48:18.26253
1329	7	/api/clients	GET	304	2025-10-28 16:48:20.556452
1351	7	/api/products	GET	200	2025-10-28 16:48:27.214543
1355	7	/api/clients	GET	200	2025-10-28 16:49:21.209837
1363	7	/api/clients	GET	200	2025-10-28 16:49:51.298663
1366	7	/api/products	GET	200	2025-10-28 16:49:54.30237
1375	7	/api/products	GET	200	2025-10-28 16:50:00.232093
1378	7	/api/products	GET	200	2025-10-28 16:50:00.83598
1401	7	/api/clients	GET	200	2025-10-28 16:51:55.631425
1409	7	/api/orders	GET	304	2025-10-28 16:52:14.600336
1425	7	/api/clients	GET	304	2025-10-28 16:52:21.64516
1433	7	/api/orders	GET	304	2025-10-28 16:52:23.151118
1438	7	/api/products	GET	304	2025-10-28 16:52:24.921977
1439	7	/api/clients	GET	304	2025-10-28 16:52:25.822474
1442	7	/api/clients	GET	304	2025-10-28 16:52:26.975981
1443	7	/api/products	GET	304	2025-10-28 16:52:28.718814
1446	7	/api/clients	GET	304	2025-10-28 16:52:30.043936
1447	7	/api/clients	GET	304	2025-10-28 16:52:30.468131
1485	7	/api/users	GET	304	2025-10-28 16:55:39.03435
1488	7	/api/users	GET	304	2025-10-28 16:55:40.814869
1489	7	/api/users	GET	304	2025-10-28 16:55:47.827948
1492	7	/api/users	GET	304	2025-10-28 16:55:53.595078
1493	7	/api/users	GET	200	2025-10-28 16:55:55.189679
1496	7	/api/products	GET	304	2025-10-28 16:55:56.752537
1506	7	/api/clients	GET	304	2025-10-28 16:55:58.753017
1515	7	/api/products	GET	304	2025-10-28 16:56:00.677051
1518	7	/api/users	GET	304	2025-10-28 16:56:05.364413
1521	7	/api/products	GET	200	2025-10-28 16:57:48.700166
1524	7	/api/users	GET	304	2025-10-28 16:57:52.716461
1525	7	/api/clients	GET	304	2025-10-28 16:57:53.862663
1537	7	/api/products	GET	304	2025-10-28 16:57:55.005771
1551	7	/api/clients	GET	304	2025-10-28 16:57:59.81057
1561	7	/api/clients	GET	304	2025-10-28 16:58:01.980651
1573	7	/api/clients	GET	304	2025-10-28 16:59:21.981674
1576	7	/api/clients	GET	304	2025-10-28 16:59:22.795666
1577	7	/api/clients	GET	304	2025-10-28 16:59:28.809922
1580	7	/api/clients	GET	304	2025-10-28 16:59:29.473552
1581	7	/api/clients	GET	200	2025-10-28 16:59:30.089737
1584	7	/api/clients	GET	304	2025-10-28 16:59:33.473503
1585	7	/api/products	GET	304	2025-10-28 16:59:34.208454
1588	7	/api/products	GET	304	2025-10-28 16:59:34.812866
1592	7	/api/orders	GET	304	2025-10-28 16:59:34.85937
1594	7	/api/users	GET	304	2025-10-28 16:59:35.280161
1595	7	/api/products	GET	304	2025-10-28 16:59:35.686281
1620	7	/api/orders	GET	304	2025-10-28 16:59:39.940244
1627	7	/api/orders	GET	304	2025-10-28 16:59:41.946615
1629	7	/api/products	GET	304	2025-10-28 16:59:42.64384
1632	7	/api/clients	GET	304	2025-10-28 16:59:43.736419
1635	7	/api/clients	GET	304	2025-10-28 17:00:27.35177
1638	7	/api/products	GET	304	2025-10-28 17:00:27.851869
1639	7	/api/products	GET	304	2025-10-28 17:00:34.190699
1642	7	/api/products	GET	304	2025-10-28 17:00:35.906668
1643	7	/api/products	GET	304	2025-10-28 17:00:39.602154
1646	7	/api/clients	GET	304	2025-10-28 17:00:42.947706
1656	7	/api/clients	GET	304	2025-10-28 17:00:45.091455
1670	7	/api/clients	GET	304	2025-10-28 17:00:51.206085
1676	7	/api/products	GET	304	2025-10-28 17:01:35.42079
1678	7	/api/clients	GET	304	2025-10-28 17:01:35.510433
1709	7	/api/orders	GET	304	2025-10-28 17:02:21.678787
1785	7	/api/clients	GET	304	2025-10-28 17:09:50.451254
1788	7	/api/products	GET	304	2025-10-28 17:09:51.117936
1789	7	/api/clients	GET	304	2025-10-28 17:09:51.674943
1807	7	/api/products	GET	304	2025-10-28 17:11:31.993386
1818	7	/api/orders	GET	304	2025-10-28 17:11:44.184237
1819	7	/api/products	GET	304	2025-10-28 17:11:45.387099
1822	7	/api/clients	GET	304	2025-10-28 17:11:46.042198
1823	7	/api/clients	GET	304	2025-10-28 17:11:51.94781
1826	7	/api/products	GET	304	2025-10-28 17:11:53.246674
1827	7	/api/clients	GET	304	2025-10-28 17:11:54.345636
1851	7	/api/clients	GET	200	2025-10-28 17:48:04.987297
1873	7	/api/clients	GET	304	2025-10-28 18:12:35.464459
1897	7	/api/clients	GET	304	2025-10-28 18:15:40.882286
1898	7	/api/clients	GET	304	2025-10-28 18:15:42.800725
1929	7	/api/clients	GET	304	2025-10-28 18:20:36.236253
1930	7	/api/clients	GET	304	2025-10-28 18:20:45.849644
1933	7	/api/clients	GET	304	2025-10-28 18:20:51.998098
1934	7	/api/clients	GET	200	2025-10-28 18:20:52.574743
1937	7	/api/clients	GET	304	2025-10-28 18:20:54.20665
1951	7	/api/orders	GET	200	2025-10-28 18:21:41.199136
1952	7	/api/users	GET	200	2025-10-28 18:21:42.662688
1955	7	/api/clients	GET	200	2025-10-28 18:21:44.256884
1965	7	/api/clients	GET	200	2025-10-28 18:25:30.627833
1967	7	/api/clients	GET	200	2025-10-28 18:25:34.984261
1968	7	/api/clients	GET	200	2025-10-28 18:25:45.352566
1971	7	/api/products	GET	304	2025-10-28 18:25:47.919358
1986	7	/api/clients	GET	304	2025-10-28 18:28:22.042062
1997	7	/api/clients	GET	304	2025-10-28 18:30:53.193783
1998	7	/api/clients	GET	200	2025-10-28 18:30:53.47715
2001	7	/api/products	GET	304	2025-10-28 18:31:01.462994
2002	7	/api/users	GET	304	2025-10-28 18:31:03.300987
2014	7	/api/clients	GET	304	2025-10-28 18:33:28.604019
2021	7	/api/products	GET	304	2025-10-28 18:34:49.193326
2029	7	/api/products	GET	304	2025-10-28 18:35:15.915182
2031	7	/api/clients	GET	304	2025-10-28 18:35:15.989571
2036	7	/api/products	GET	304	2025-10-28 18:35:34.744658
2039	7	/api/products	GET	200	2025-10-28 18:35:35.767703
2051	7	/api/products	GET	304	2025-10-28 18:36:13.609355
2052	7	/api/users	GET	304	2025-10-28 18:36:15.164896
2055	7	/api/products	GET	304	2025-10-28 18:36:16.796992
2061	7	/api/users	GET	304	2025-10-28 18:36:18.03296
2062	7	/api/products	GET	304	2025-10-28 18:36:19.852255
2065	7	/api/products	GET	304	2025-10-28 18:36:20.292857
2068	7	/api/clients	GET	304	2025-10-28 18:36:20.298085
2071	7	/api/products	GET	304	2025-10-28 18:36:21.055916
2072	7	/api/clients	GET	304	2025-10-28 18:36:21.404442
2074	7	/api/clients	GET	200	2025-10-28 18:36:31.572449
2077	7	/api/products	GET	200	2025-10-28 18:36:34.258872
2078	7	/api/products	GET	200	2025-10-28 18:36:38.280191
2086	7	/api/clients	GET	304	2025-10-28 18:42:46.930804
365	7	/api/orders	GET	304	2025-10-22 15:59:47.24986
366	7	/api/orders	GET	304	2025-10-22 16:01:30.460986
367	7	/api/products	GET	304	2025-10-22 16:01:30.461824
368	7	/api/orders	GET	304	2025-10-22 16:01:30.501297
369	7	/api/products	GET	304	2025-10-22 16:01:30.50281
370	7	/api/clients	GET	304	2025-10-22 16:01:30.556935
371	7	/api/clients	GET	304	2025-10-22 16:01:30.560881
372	7	/api/clients	GET	304	2025-10-22 16:01:31.229954
373	7	/api/orders	GET	304	2025-10-22 16:01:31.23115
374	7	/api/products	GET	304	2025-10-22 16:01:31.23232
375	7	/api/clients	GET	304	2025-10-22 16:01:31.242569
376	7	/api/orders	GET	304	2025-10-22 16:01:31.24316
377	7	/api/products	GET	304	2025-10-22 16:01:31.24455
378	7	/api/orders	POST	400	2025-10-22 16:02:00.459447
379	7	/api/orders	POST	400	2025-10-22 16:02:02.74075
380	7	/api/clients	GET	304	2025-10-22 16:02:26.313585
381	7	/api/orders	GET	304	2025-10-22 16:02:26.317477
382	7	/api/products	GET	304	2025-10-22 16:02:26.32078
383	7	/api/orders	GET	304	2025-10-22 16:02:26.325839
384	7	/api/products	GET	304	2025-10-22 16:02:26.328153
385	7	/api/clients	GET	304	2025-10-22 16:02:26.350322
386	7	/api/orders	POST	400	2025-10-22 16:02:35.275031
387	7	/api/clients	GET	304	2025-10-22 16:04:16.529066
388	7	/api/products	GET	304	2025-10-22 16:04:16.54219
389	7	/api/orders	GET	304	2025-10-22 16:04:16.543244
390	7	/api/products	GET	304	2025-10-22 16:04:16.550487
391	7	/api/clients	GET	304	2025-10-22 16:04:16.571961
392	7	/api/orders	GET	304	2025-10-22 16:04:16.580913
393	7	/api/clients	GET	304	2025-10-22 16:04:17.438898
394	7	/api/products	GET	304	2025-10-22 16:04:17.439554
395	7	/api/orders	GET	304	2025-10-22 16:04:17.440079
396	7	/api/clients	GET	304	2025-10-22 16:04:17.446594
397	7	/api/products	GET	304	2025-10-22 16:04:17.447746
398	7	/api/orders	GET	304	2025-10-22 16:04:17.448792
399	7	/api/clients	GET	200	2025-10-22 16:04:23.349622
400	7	/api/products	GET	200	2025-10-22 16:04:23.361138
401	7	/api/orders	GET	200	2025-10-22 16:04:23.36151
402	7	/api/clients	GET	200	2025-10-22 16:04:23.362089
403	7	/api/products	GET	200	2025-10-22 16:04:23.363005
404	7	/api/orders	GET	200	2025-10-22 16:04:23.394092
405	7	/api/orders	POST	400	2025-10-22 16:04:30.645505
406	7	/api/clients	GET	304	2025-10-22 16:06:29.561528
407	7	/api/products	GET	304	2025-10-22 16:06:29.566859
408	7	/api/orders	GET	304	2025-10-22 16:06:29.572922
409	7	/api/products	GET	304	2025-10-22 16:06:29.577241
410	7	/api/orders	GET	304	2025-10-22 16:06:29.578261
411	7	/api/clients	GET	304	2025-10-22 16:06:29.600037
412	7	/api/clients	GET	304	2025-10-22 16:06:30.417221
413	7	/api/products	GET	304	2025-10-22 16:06:30.418265
414	7	/api/orders	GET	304	2025-10-22 16:06:30.42201
415	7	/api/clients	GET	304	2025-10-22 16:06:30.430956
416	7	/api/products	GET	304	2025-10-22 16:06:30.471009
417	7	/api/orders	GET	304	2025-10-22 16:06:30.473165
418	7	/api/clients	GET	200	2025-10-22 16:06:35.920714
419	7	/api/products	GET	200	2025-10-22 16:06:35.921689
420	7	/api/orders	GET	200	2025-10-22 16:06:35.922231
421	7	/api/clients	GET	200	2025-10-22 16:06:35.923055
422	7	/api/products	GET	200	2025-10-22 16:06:35.92445
423	7	/api/orders	GET	200	2025-10-22 16:06:35.925542
424	7	/api/clients	GET	304	2025-10-22 16:08:17.54889
425	7	/api/orders	GET	304	2025-10-22 16:08:17.5523
426	7	/api/products	GET	304	2025-10-22 16:08:17.55293
427	7	/api/orders	GET	304	2025-10-22 16:08:17.561372
428	7	/api/products	GET	304	2025-10-22 16:08:17.593294
429	7	/api/clients	GET	304	2025-10-22 16:08:17.698427
430	7	/api/clients	GET	304	2025-10-22 16:08:18.980995
431	7	/api/products	GET	304	2025-10-22 16:08:18.981524
432	7	/api/orders	GET	304	2025-10-22 16:08:18.982011
433	7	/api/clients	GET	304	2025-10-22 16:08:18.99226
434	7	/api/products	GET	304	2025-10-22 16:08:18.99331
435	7	/api/orders	GET	304	2025-10-22 16:08:18.994451
436	7	/api/clients	GET	200	2025-10-22 16:08:22.256642
437	7	/api/products	GET	200	2025-10-22 16:08:22.259277
438	7	/api/clients	GET	200	2025-10-22 16:08:22.259933
439	7	/api/orders	GET	200	2025-10-22 16:08:22.260465
440	7	/api/products	GET	200	2025-10-22 16:08:22.261044
441	7	/api/orders	GET	200	2025-10-22 16:08:22.292879
442	7	/api/orders	GET	304	2025-10-22 16:10:46.517123
443	7	/api/products	GET	304	2025-10-22 16:10:46.517915
444	7	/api/orders	GET	304	2025-10-22 16:10:46.558024
445	7	/api/products	GET	304	2025-10-22 16:10:46.558818
446	7	/api/clients	GET	304	2025-10-22 16:10:46.613406
447	7	/api/clients	GET	304	2025-10-22 16:10:46.61712
448	7	/api/clients	GET	200	2025-10-22 16:11:19.873327
449	7	/api/products	GET	200	2025-10-22 16:11:19.894362
450	7	/api/orders	GET	200	2025-10-22 16:11:19.895021
451	7	/api/clients	GET	200	2025-10-22 16:11:19.897645
452	7	/api/orders	GET	200	2025-10-22 16:11:19.900051
453	7	/api/products	GET	200	2025-10-22 16:11:19.900934
454	7	/api/clients	GET	200	2025-10-22 16:18:14.62244
455	7	/api/orders	GET	200	2025-10-22 16:18:14.678587
456	7	/api/products	GET	200	2025-10-22 16:18:14.679925
457	7	/api/orders	GET	200	2025-10-22 16:18:14.682166
458	7	/api/products	GET	200	2025-10-22 16:18:14.683236
459	7	/api/clients	GET	200	2025-10-22 16:18:14.810448
460	7	/api/orders	POST	500	2025-10-22 16:18:24.087736
461	7	/api/clients	GET	304	2025-10-22 16:22:18.512391
462	7	/api/orders	GET	304	2025-10-22 16:22:18.523251
463	7	/api/products	GET	304	2025-10-22 16:22:18.524545
464	7	/api/orders	GET	304	2025-10-22 16:22:18.531203
465	7	/api/clients	GET	304	2025-10-22 16:22:18.549348
466	7	/api/products	GET	304	2025-10-22 16:22:18.563948
467	7	/api/clients	GET	304	2025-10-22 16:22:20.125905
468	7	/api/products	GET	304	2025-10-22 16:22:20.126717
469	7	/api/orders	GET	304	2025-10-22 16:22:20.127473
470	7	/api/clients	GET	304	2025-10-22 16:22:20.134114
471	7	/api/products	GET	304	2025-10-22 16:22:20.134615
472	7	/api/orders	GET	304	2025-10-22 16:22:20.135172
473	7	/api/clients	GET	200	2025-10-22 16:22:23.908519
474	7	/api/products	GET	200	2025-10-22 16:22:23.909666
475	7	/api/clients	GET	200	2025-10-22 16:22:23.910406
476	7	/api/orders	GET	200	2025-10-22 16:22:23.910939
477	7	/api/products	GET	200	2025-10-22 16:22:23.91197
478	7	/api/orders	GET	200	2025-10-22 16:22:23.942148
479	7	/api/clients	GET	200	2025-10-22 16:22:27.205324
480	7	/api/products	GET	200	2025-10-22 16:22:27.205839
481	7	/api/clients	GET	200	2025-10-22 16:22:27.206505
482	7	/api/orders	GET	200	2025-10-22 16:22:27.207171
483	7	/api/products	GET	200	2025-10-22 16:22:27.207919
484	7	/api/orders	GET	200	2025-10-22 16:22:27.208712
485	7	/api/orders	POST	500	2025-10-22 16:22:38.101705
486	7	/api/clients	GET	200	2025-10-22 16:23:46.230209
487	7	/api/orders	GET	200	2025-10-22 16:23:46.27429
488	7	/api/products	GET	200	2025-10-22 16:23:46.275477
489	7	/api/orders	GET	200	2025-10-22 16:23:46.277801
490	7	/api/products	GET	200	2025-10-22 16:23:46.278868
491	7	/api/clients	GET	200	2025-10-22 16:23:46.376405
492	7	/api/orders	POST	500	2025-10-22 16:23:55.283427
493	7	/api/clients	GET	200	2025-10-22 16:25:38.117824
494	7	/api/products	GET	200	2025-10-22 16:25:38.163506
495	7	/api/orders	GET	200	2025-10-22 16:25:38.166515
496	7	/api/clients	GET	200	2025-10-22 16:25:38.167623
497	7	/api/products	GET	200	2025-10-22 16:25:38.16904
498	7	/api/orders	GET	200	2025-10-22 16:25:38.170294
499	7	/api/orders	POST	500	2025-10-22 16:25:49.039849
500	7	/api/clients	GET	200	2025-10-22 16:29:32.008256
501	7	/api/orders	GET	500	2025-10-22 16:29:32.067309
502	7	/api/products	GET	200	2025-10-22 16:29:32.069935
503	7	/api/clients	GET	200	2025-10-22 16:29:32.070855
504	7	/api/orders	GET	500	2025-10-22 16:29:32.073273
505	7	/api/products	GET	200	2025-10-22 16:29:32.075883
506	7	/api/orders	GET	500	2025-10-22 16:29:38.144493
507	7	/api/orders	GET	500	2025-10-22 16:29:38.15011
508	7	/api/clients	GET	200	2025-10-22 16:29:38.150919
509	7	/api/products	GET	200	2025-10-22 16:29:38.151604
510	7	/api/clients	GET	200	2025-10-22 16:29:38.152271
511	7	/api/products	GET	200	2025-10-22 16:29:38.153576
512	7	/api/clients	GET	200	2025-10-22 16:30:38.987275
513	7	/api/products	GET	200	2025-10-22 16:30:39.045123
514	7	/api/orders	GET	200	2025-10-22 16:30:39.04628
515	7	/api/clients	GET	200	2025-10-22 16:30:39.049172
516	7	/api/products	GET	200	2025-10-22 16:30:39.050353
517	7	/api/orders	GET	200	2025-10-22 16:30:39.052473
518	7	/api/orders	POST	201	2025-10-22 16:30:49.301171
519	7	/api/clients	GET	304	2025-10-22 16:30:58.209496
520	7	/api/products	GET	200	2025-10-22 16:30:58.210993
521	7	/api/products	GET	304	2025-10-22 16:30:58.221407
522	7	/api/orders	GET	200	2025-10-22 16:30:58.249367
523	7	/api/orders	GET	304	2025-10-22 16:30:58.252036
524	7	/api/clients	GET	304	2025-10-22 16:30:58.25674
525	\N	/api/orders	GET	401	2025-10-22 16:33:35.087601
526	\N	/favicon.ico	GET	404	2025-10-22 16:33:35.485794
527	\N	/api/clients	GET	401	2025-10-22 16:33:55.865241
528	\N	/api/products	GET	401	2025-10-22 16:33:55.865342
529	\N	/api/orders	GET	401	2025-10-22 16:33:55.866433
530	\N	/api/clients	GET	401	2025-10-22 16:33:55.867502
531	\N	/api/products	GET	401	2025-10-22 16:33:55.868459
532	\N	/api/orders	GET	401	2025-10-22 16:33:55.868761
533	\N	/api/clients	GET	401	2025-10-22 16:35:06.556248
534	\N	/api/products	GET	401	2025-10-22 16:35:06.564315
535	\N	/api/orders	GET	401	2025-10-22 16:35:06.623055
536	\N	/api/clients	GET	401	2025-10-22 16:35:06.624188
537	\N	/api/products	GET	401	2025-10-22 16:35:06.625054
538	\N	/api/orders	GET	401	2025-10-22 16:35:06.626598
539	\N	/api/clients	GET	401	2025-10-22 16:35:07.983071
540	\N	/api/products	GET	401	2025-10-22 16:35:07.987552
541	\N	/api/orders	GET	401	2025-10-22 16:35:07.99219
542	\N	/api/clients	GET	401	2025-10-22 16:35:07.996144
543	\N	/api/products	GET	401	2025-10-22 16:35:07.998982
544	\N	/api/orders	GET	401	2025-10-22 16:35:08.002723
545	\N	/api/auth/login	POST	200	2025-10-22 16:35:31.072801
546	7	/api/products	GET	200	2025-10-22 16:35:34.321136
547	7	/api/products	GET	304	2025-10-22 16:35:34.357125
548	7	/api/products	GET	304	2025-10-22 16:35:34.796521
549	7	/api/clients	GET	200	2025-10-22 16:35:34.797484
550	7	/api/clients	GET	304	2025-10-22 16:35:34.843012
551	7	/api/products	GET	304	2025-10-22 16:35:34.843962
552	7	/api/orders	GET	200	2025-10-22 16:35:34.941365
553	7	/api/orders	GET	304	2025-10-22 16:35:34.944296
554	7	/api/clients	GET	200	2025-10-22 16:35:39.827427
555	7	/api/products	GET	200	2025-10-22 16:35:39.884709
556	7	/api/orders	GET	200	2025-10-22 16:35:39.887405
557	7	/api/clients	GET	200	2025-10-22 16:35:39.890056
558	7	/api/orders	GET	200	2025-10-22 16:35:39.891222
559	7	/api/products	GET	200	2025-10-22 16:35:39.892217
560	\N	/api/orders	GET	401	2025-10-22 16:35:57.589091
561	\N	/favicon.ico	GET	404	2025-10-22 16:35:57.894043
562	7	/api/clients	GET	304	2025-10-22 16:38:07.982611
563	7	/api/products	GET	304	2025-10-22 16:38:07.983289
564	7	/api/orders	GET	200	2025-10-22 16:38:08.021791
565	7	/api/orders	GET	200	2025-10-22 16:38:08.025233
566	7	/api/clients	GET	304	2025-10-22 16:38:08.031011
567	7	/api/products	GET	304	2025-10-22 16:38:08.03225
568	7	/api/clients	GET	304	2025-10-22 16:38:40.63889
569	7	/api/orders	GET	200	2025-10-22 16:38:40.641653
570	7	/api/orders	GET	200	2025-10-22 16:38:40.647002
571	7	/api/clients	GET	304	2025-10-22 16:38:40.680361
572	7	/api/products	GET	304	2025-10-22 16:38:40.740065
573	7	/api/products	GET	304	2025-10-22 16:38:40.747457
574	\N	/api/orders	GET	401	2025-10-22 16:41:01.668629
575	\N	/.well-known/appspecific/com.chrome.devtools.json	GET	404	2025-10-22 16:41:01.706654
576	\N	/favicon.ico	GET	404	2025-10-22 16:41:02.039647
577	7	/api/orders	GET	200	2025-10-22 16:41:05.548837
578	7	/api/orders	GET	200	2025-10-22 16:41:05.584275
579	7	/api/clients	GET	304	2025-10-22 16:41:07.331786
580	7	/api/products	GET	304	2025-10-22 16:41:07.332673
581	7	/api/orders	GET	200	2025-10-22 16:41:07.374035
582	7	/api/orders	GET	200	2025-10-22 16:41:07.376739
583	7	/api/clients	GET	304	2025-10-22 16:41:07.381398
584	7	/api/products	GET	304	2025-10-22 16:41:07.382104
585	7	/api/clients	GET	304	2025-10-22 16:41:47.955191
586	7	/api/orders	GET	200	2025-10-22 16:41:47.955801
587	7	/api/products	GET	304	2025-10-22 16:41:47.956493
588	7	/api/orders	GET	200	2025-10-22 16:41:47.964862
589	7	/api/clients	GET	304	2025-10-22 16:41:48.009103
590	7	/api/products	GET	304	2025-10-22 16:41:48.00992
591	7	/api/orders	GET	200	2025-10-22 16:42:15.333304
592	7	/api/clients	GET	304	2025-10-22 16:42:15.334066
593	7	/api/products	GET	304	2025-10-22 16:42:15.334732
594	7	/api/orders	GET	200	2025-10-22 16:42:15.381494
595	7	/api/clients	GET	304	2025-10-22 16:42:15.382487
596	7	/api/products	GET	304	2025-10-22 16:42:15.385131
597	7	/api/orders	GET	200	2025-10-22 16:43:03.590254
598	7	/api/clients	GET	200	2025-10-22 16:44:45.872517
599	7	/api/products	GET	200	2025-10-22 16:44:45.877235
600	7	/api/clients	GET	200	2025-10-22 16:44:45.884379
601	7	/api/orders	GET	200	2025-10-22 16:44:45.885062
602	7	/api/orders	GET	200	2025-10-22 16:44:45.88579
603	7	/api/products	GET	200	2025-10-22 16:44:45.886502
604	7	/api/products	GET	304	2025-10-22 16:45:13.917512
605	7	/api/orders	GET	200	2025-10-22 16:45:13.921677
606	7	/api/products	GET	304	2025-10-22 16:45:13.958012
607	7	/api/orders	GET	200	2025-10-22 16:45:13.960274
608	7	/api/clients	GET	304	2025-10-22 16:45:14.05381
609	7	/api/clients	GET	304	2025-10-22 16:45:14.057159
610	\N	/api/orders	GET	401	2025-10-22 16:45:56.401385
611	\N	/favicon.ico	GET	404	2025-10-22 16:45:56.764856
612	\N	/api/orders	GET	401	2025-10-22 16:46:25.937679
613	7	/api/clients	GET	304	2025-10-22 16:49:50.457775
614	7	/api/orders	GET	200	2025-10-22 16:49:50.468759
615	7	/api/products	GET	304	2025-10-22 16:49:50.470523
616	7	/api/orders	GET	200	2025-10-22 16:49:50.477399
617	7	/api/products	GET	304	2025-10-22 16:49:50.509501
618	7	/api/clients	GET	304	2025-10-22 16:49:50.601149
619	7	/api/clients	GET	304	2025-10-22 16:49:54.126755
620	7	/api/products	GET	304	2025-10-22 16:49:54.127552
621	7	/api/orders	GET	200	2025-10-22 16:49:54.128456
622	7	/api/clients	GET	304	2025-10-22 16:49:54.136208
623	7	/api/products	GET	304	2025-10-22 16:49:54.13715
624	7	/api/orders	GET	200	2025-10-22 16:49:54.137892
625	7	/api/clients	GET	304	2025-10-22 16:51:53.2227
626	7	/api/orders	GET	200	2025-10-22 16:51:53.224697
627	7	/api/products	GET	304	2025-10-22 16:51:53.225873
628	7	/api/clients	GET	304	2025-10-22 16:51:53.268659
629	7	/api/orders	GET	200	2025-10-22 16:51:53.269528
630	7	/api/products	GET	304	2025-10-22 16:51:53.373398
631	7	/api/clients	GET	304	2025-10-22 16:51:55.087841
632	7	/api/orders	GET	200	2025-10-22 16:51:55.088901
633	7	/api/products	GET	304	2025-10-22 16:51:55.094266
634	7	/api/clients	GET	304	2025-10-22 16:51:55.094915
635	7	/api/orders	GET	200	2025-10-22 16:51:55.095543
636	7	/api/products	GET	304	2025-10-22 16:51:55.100732
637	7	/api/clients	GET	200	2025-10-22 16:51:57.457292
638	7	/api/products	GET	200	2025-10-22 16:51:57.457944
639	7	/api/orders	GET	200	2025-10-22 16:51:57.458556
640	7	/api/clients	GET	200	2025-10-22 16:51:57.459079
641	7	/api/products	GET	200	2025-10-22 16:51:57.46065
642	7	/api/orders	GET	200	2025-10-22 16:51:57.461547
643	7	/api/orders	GET	200	2025-10-22 16:52:09.714337
644	7	/api/clients	GET	200	2025-10-22 16:52:09.721109
645	7	/api/products	GET	200	2025-10-22 16:52:09.723607
646	7	/api/orders	GET	200	2025-10-22 16:52:09.725495
647	7	/api/clients	GET	200	2025-10-22 16:52:09.795679
648	7	/api/products	GET	200	2025-10-22 16:52:09.81241
649	7	/api/clients	GET	304	2025-10-22 16:53:42.563538
650	7	/api/orders	GET	200	2025-10-22 16:53:42.564295
651	7	/api/products	GET	304	2025-10-22 16:53:42.565294
652	7	/api/orders	GET	200	2025-10-22 16:53:42.610846
653	7	/api/products	GET	304	2025-10-22 16:53:42.613954
654	7	/api/clients	GET	304	2025-10-22 16:53:42.726308
655	7	/api/clients	GET	304	2025-10-22 16:53:44.439499
656	7	/api/products	GET	304	2025-10-22 16:53:44.440154
657	7	/api/orders	GET	200	2025-10-22 16:53:44.441142
658	7	/api/clients	GET	304	2025-10-22 16:53:44.450278
659	7	/api/products	GET	304	2025-10-22 16:53:44.450903
660	7	/api/orders	GET	200	2025-10-22 16:53:44.451748
661	7	/api/clients	GET	200	2025-10-22 16:53:47.419859
662	7	/api/products	GET	200	2025-10-22 16:53:47.428331
663	7	/api/orders	GET	200	2025-10-22 16:53:47.429976
664	7	/api/clients	GET	200	2025-10-22 16:53:47.430711
665	7	/api/products	GET	200	2025-10-22 16:53:47.431644
666	7	/api/orders	GET	200	2025-10-22 16:53:47.432978
667	7	/api/clients	GET	200	2025-10-22 16:53:50.468433
668	7	/api/products	GET	200	2025-10-22 16:53:50.468914
669	7	/api/orders	GET	200	2025-10-22 16:53:50.469515
670	7	/api/clients	GET	200	2025-10-22 16:53:50.470275
671	7	/api/products	GET	200	2025-10-22 16:53:50.471226
672	7	/api/orders	GET	200	2025-10-22 16:53:50.47223
673	7	/api/clients	GET	200	2025-10-22 16:54:02.511268
674	7	/api/products	GET	200	2025-10-22 16:54:02.516924
675	7	/api/orders	GET	200	2025-10-22 16:54:02.523617
676	7	/api/clients	GET	200	2025-10-22 16:54:02.524174
677	7	/api/orders	GET	200	2025-10-22 16:54:02.5248
678	7	/api/products	GET	200	2025-10-22 16:54:02.525432
679	7	/api/clients	GET	304	2025-10-22 16:54:05.763098
680	7	/api/products	GET	304	2025-10-22 16:54:05.76382
681	7	/api/orders	GET	200	2025-10-22 16:54:05.768193
682	7	/api/clients	GET	304	2025-10-22 16:54:05.775055
683	7	/api/products	GET	304	2025-10-22 16:54:05.776015
684	7	/api/orders	GET	200	2025-10-22 16:54:05.776775
685	7	/api/clients	GET	200	2025-10-22 16:54:06.147703
686	7	/api/products	GET	200	2025-10-22 16:54:06.148387
687	7	/api/orders	GET	200	2025-10-22 16:54:06.149017
688	7	/api/clients	GET	200	2025-10-22 16:54:06.149666
689	7	/api/products	GET	200	2025-10-22 16:54:06.150471
690	7	/api/orders	GET	200	2025-10-22 16:54:06.151131
691	7	/api/clients	GET	200	2025-10-22 16:56:49.406618
692	7	/api/clients	GET	200	2025-10-22 16:56:49.45385
693	7	/api/products	GET	200	2025-10-22 16:56:49.455093
694	7	/api/products	GET	200	2025-10-22 16:56:49.456112
695	7	/api/orders	GET	200	2025-10-22 16:56:49.458746
696	7	/api/orders	GET	200	2025-10-22 16:56:49.460574
697	7	/api/clients	GET	304	2025-10-22 16:58:00.748055
698	7	/api/products	GET	304	2025-10-22 16:58:00.750578
699	7	/api/orders	GET	304	2025-10-22 16:58:00.752054
700	7	/api/products	GET	304	2025-10-22 16:58:00.758657
701	7	/api/clients	GET	304	2025-10-22 16:58:00.789929
702	7	/api/orders	GET	304	2025-10-22 16:58:00.796855
703	7	/api/clients	GET	200	2025-10-22 16:58:02.046752
704	7	/api/clients	GET	200	2025-10-22 16:58:02.05934
705	7	/api/products	GET	200	2025-10-22 16:58:02.060036
706	7	/api/orders	GET	200	2025-10-22 16:58:02.060682
707	7	/api/products	GET	200	2025-10-22 16:58:02.061375
708	7	/api/orders	GET	200	2025-10-22 16:58:02.062249
709	7	/api/clients	GET	200	2025-10-22 16:58:15.13307
710	7	/api/products	GET	200	2025-10-22 16:58:15.134273
711	7	/api/clients	GET	200	2025-10-22 16:58:15.135258
712	7	/api/products	GET	200	2025-10-22 16:58:15.140115
713	7	/api/orders	GET	200	2025-10-22 16:58:15.141401
714	7	/api/orders	GET	200	2025-10-22 16:58:15.244625
715	7	/api/clients	GET	200	2025-10-22 16:58:47.598896
716	7	/api/products	GET	200	2025-10-22 16:58:47.599544
717	7	/api/products	GET	200	2025-10-22 16:58:47.604248
718	7	/api/orders	GET	200	2025-10-22 16:58:47.605042
719	7	/api/orders	GET	200	2025-10-22 16:58:47.605955
720	7	/api/clients	GET	200	2025-10-22 16:58:47.67406
721	7	/api/orders	POST	500	2025-10-22 16:59:21.90878
722	7	/api/orders	POST	500	2025-10-22 16:59:41.106668
723	7	/api/clients	GET	304	2025-10-22 17:02:40.979763
724	7	/api/products	GET	304	2025-10-22 17:02:40.982339
725	7	/api/orders	GET	304	2025-10-22 17:02:40.987532
1277	7	/api/orders	GET	304	2025-10-28 16:47:52.51819
1283	7	/api/clients	GET	304	2025-10-28 16:47:56.985422
1289	7	/api/orders	GET	200	2025-10-28 16:47:57.773509
1296	7	/api/clients	GET	304	2025-10-28 16:48:05.142735
1301	7	/api/clients	GET	200	2025-10-28 16:48:06.964122
1308	7	/api/clients	GET	304	2025-10-28 16:48:10.230474
1313	7	/api/orders	GET	200	2025-10-28 16:48:11.227029
1320	7	/api/clients	GET	304	2025-10-28 16:48:15.861251
1325	7	/api/orders	GET	304	2025-10-28 16:48:18.253916
1332	7	/api/clients	GET	304	2025-10-28 16:48:20.565566
1337	7	/api/orders	GET	304	2025-10-28 16:48:24.740165
1344	7	/api/clients	GET	304	2025-10-28 16:48:26.252074
1349	7	/api/orders	GET	200	2025-10-28 16:48:27.213017
1356	7	/api/orders	GET	200	2025-10-28 16:49:21.211256
1364	7	/api/orders	GET	200	2025-10-28 16:49:51.301571
1365	7	/api/clients	GET	200	2025-10-28 16:49:54.291787
1376	7	/api/orders	GET	200	2025-10-28 16:50:00.232952
1377	7	/api/clients	GET	200	2025-10-28 16:50:00.835521
1402	7	/api/products	GET	200	2025-10-28 16:51:55.634367
1412	7	/api/clients	GET	304	2025-10-28 16:52:14.628098
1413	7	/api/clients	GET	304	2025-10-28 16:52:16.075441
1416	7	/api/products	GET	304	2025-10-28 16:52:17.294122
1417	7	/api/clients	GET	304	2025-10-28 16:52:18.3076
1420	7	/api/clients	GET	304	2025-10-28 16:52:19.718844
1421	7	/api/products	GET	304	2025-10-28 16:52:20.669481
1424	7	/api/products	GET	304	2025-10-28 16:52:21.635909
1434	7	/api/clients	GET	304	2025-10-28 16:52:23.159882
1437	7	/api/products	GET	304	2025-10-28 16:52:24.91702
1440	7	/api/clients	GET	304	2025-10-28 16:52:25.826039
1441	7	/api/clients	GET	304	2025-10-28 16:52:26.973893
1444	7	/api/products	GET	304	2025-10-28 16:52:28.723369
1445	7	/api/clients	GET	304	2025-10-28 16:52:30.041567
1448	7	/api/products	GET	304	2025-10-28 16:52:30.468778
1454	7	/api/users	GET	304	2025-10-28 16:52:31.505839
1455	7	/api/products	GET	304	2025-10-28 16:52:32.544738
1459	7	/api/orders	GET	304	2025-10-28 16:52:32.555627
1462	7	/api/users	GET	304	2025-10-28 16:52:33.668845
1486	7	/api/users	GET	304	2025-10-28 16:55:39.183187
1487	7	/api/users	GET	304	2025-10-28 16:55:40.810581
1490	7	/api/users	GET	304	2025-10-28 16:55:47.831957
1491	7	/api/users	GET	304	2025-10-28 16:55:53.589832
1494	7	/api/users	GET	200	2025-10-28 16:55:55.19077
1495	7	/api/clients	GET	304	2025-10-28 16:55:56.75177
1497	7	/api/products	GET	304	2025-10-28 16:55:56.761601
1499	7	/api/orders	GET	304	2025-10-28 16:55:56.794505
1502	7	/api/products	GET	304	2025-10-28 16:55:57.822559
1503	7	/api/clients	GET	304	2025-10-28 16:55:58.743433
1516	7	/api/orders	GET	304	2025-10-28 16:56:00.677874
1517	7	/api/users	GET	304	2025-10-28 16:56:05.36038
1522	7	/api/products	GET	200	2025-10-28 16:57:48.701541
1523	7	/api/users	GET	304	2025-10-28 16:57:52.711032
1526	7	/api/products	GET	304	2025-10-28 16:57:53.863153
1528	7	/api/orders	GET	304	2025-10-28 16:57:53.907597
1535	7	/api/orders	GET	304	2025-10-28 16:57:54.997675
1550	7	/api/products	GET	304	2025-10-28 16:57:59.809924
1563	7	/api/products	GET	304	2025-10-28 16:58:01.987233
1566	7	/api/users	GET	304	2025-10-28 16:58:02.397461
1567	7	/api/clients	GET	304	2025-10-28 16:58:03.398372
1574	7	/api/clients	GET	304	2025-10-28 16:59:22.01781
1575	7	/api/clients	GET	304	2025-10-28 16:59:22.792913
1578	7	/api/clients	GET	304	2025-10-28 16:59:28.812268
1579	7	/api/clients	GET	304	2025-10-28 16:59:29.471353
1582	7	/api/clients	GET	200	2025-10-28 16:59:30.090858
1583	7	/api/clients	GET	304	2025-10-28 16:59:33.471022
1586	7	/api/products	GET	304	2025-10-28 16:59:34.212945
1587	7	/api/clients	GET	304	2025-10-28 16:59:34.809773
1599	7	/api/clients	GET	304	2025-10-28 16:59:35.695609
1619	7	/api/products	GET	304	2025-10-28 16:59:39.937397
1625	7	/api/clients	GET	304	2025-10-28 16:59:41.93859
1630	7	/api/products	GET	304	2025-10-28 16:59:42.647611
1631	7	/api/clients	GET	304	2025-10-28 16:59:43.734068
1636	7	/api/clients	GET	304	2025-10-28 17:00:27.38329
1637	7	/api/products	GET	304	2025-10-28 17:00:27.845972
1640	7	/api/products	GET	304	2025-10-28 17:00:34.194348
1641	7	/api/products	GET	304	2025-10-28 17:00:35.902338
1644	7	/api/products	GET	304	2025-10-28 17:00:39.607245
1645	7	/api/products	GET	304	2025-10-28 17:00:42.947141
1647	7	/api/clients	GET	304	2025-10-28 17:00:42.954572
1649	7	/api/orders	GET	304	2025-10-28 17:00:42.988885
1652	7	/api/products	GET	304	2025-10-28 17:00:43.90506
1653	7	/api/clients	GET	304	2025-10-28 17:00:45.084476
1672	7	/api/orders	GET	304	2025-10-28 17:00:51.209374
1677	7	/api/clients	GET	304	2025-10-28 17:01:35.506114
1711	7	/api/clients	GET	304	2025-10-28 17:02:21.685187
1714	7	/api/products	GET	304	2025-10-28 17:02:22.980779
1715	7	/api/clients	GET	304	2025-10-28 17:02:29.195421
1718	7	/api/products	GET	304	2025-10-28 17:02:29.602007
1719	7	/api/clients	GET	304	2025-10-28 17:02:30.395476
1722	7	/api/products	GET	304	2025-10-28 17:02:32.48552
1723	7	/api/clients	GET	304	2025-10-28 17:02:32.821256
1725	7	/api/clients	GET	304	2025-10-28 17:02:32.831731
1733	7	/api/products	GET	304	2025-10-28 17:02:35.228467
1744	7	/api/clients	GET	304	2025-10-28 17:02:37.328931
1753	7	/api/orders	GET	304	2025-10-28 17:02:38.833892
1768	7	/api/clients	GET	304	2025-10-28 17:02:43.975183
1775	7	/api/orders	GET	304	2025-10-28 17:02:49.527201
1786	7	/api/clients	GET	304	2025-10-28 17:09:50.486738
1787	7	/api/products	GET	304	2025-10-28 17:09:51.112938
1790	7	/api/products	GET	304	2025-10-28 17:09:51.675528
1808	7	/api/orders	GET	304	2025-10-28 17:11:31.99405
1829	7	/api/orders	GET	304	2025-10-28 17:11:54.387195
1840	7	/api/products	GET	304	2025-10-28 17:11:59.918608
1852	7	/api/clients	GET	200	2025-10-28 17:50:00.514112
1854	7	/api/products	GET	200	2025-10-28 17:50:04.295394
1874	7	/api/clients	GET	304	2025-10-28 18:14:10.151393
1877	7	/api/clients	GET	304	2025-10-28 18:14:11.79246
1878	7	/api/clients	GET	304	2025-10-28 18:14:19.817595
1881	7	/api/clients	GET	304	2025-10-28 18:14:27.809622
1882	7	/api/clients	GET	304	2025-10-28 18:14:31.145225
1885	7	/api/clients	GET	200	2025-10-28 18:14:31.805335
1900	7	/api/clients	GET	304	2025-10-28 18:15:58.380491
1903	7	/api/clients	GET	200	2025-10-28 18:15:59.489295
1904	7	/api/clients	GET	200	2025-10-28 18:16:09.087134
1907	7	/api/clients	GET	200	2025-10-28 18:16:10.413945
1908	7	/api/clients	GET	200	2025-10-28 18:16:10.731588
1911	7	/api/clients	GET	304	2025-10-28 18:16:18.058283
1938	7	/api/clients	GET	200	2025-10-28 18:21:09.477709
1956	7	/api/clients	GET	304	2025-10-28 18:24:35.286035
1972	7	/api/products	GET	304	2025-10-28 18:27:19.204716
726	7	/api/products	GET	304	2025-10-22 17:02:40.99015
1278	7	/api/clients	GET	304	2025-10-28 16:47:52.529059
1284	7	/api/orders	GET	304	2025-10-28 16:47:56.985915
1286	7	/api/orders	GET	304	2025-10-28 16:47:56.989663
1287	7	/api/clients	GET	200	2025-10-28 16:47:57.771557
1304	7	/api/orders	GET	200	2025-10-28 16:48:06.966564
1305	7	/api/clients	GET	304	2025-10-28 16:48:10.221146
1309	7	/api/products	GET	304	2025-10-28 16:48:10.231157
1312	7	/api/products	GET	200	2025-10-28 16:48:11.226515
1333	7	/api/products	GET	304	2025-10-28 16:48:20.565942
1336	7	/api/products	GET	304	2025-10-28 16:48:24.739527
1340	7	/api/orders	GET	304	2025-10-28 16:48:24.748049
1341	7	/api/clients	GET	304	2025-10-28 16:48:26.242686
1345	7	/api/products	GET	304	2025-10-28 16:48:26.252474
1348	7	/api/products	GET	200	2025-10-28 16:48:27.212532
1357	7	/api/products	GET	200	2025-10-28 16:49:21.214804
1383	7	/api/clients	GET	304	2025-10-28 16:51:41.866968
1394	7	/api/orders	GET	304	2025-10-28 16:51:42.350203
1398	7	/api/orders	GET	200	2025-10-28 16:51:43.20395
1403	7	/api/clients	GET	200	2025-10-28 16:51:55.636287
1427	7	/api/products	GET	304	2025-10-28 16:52:21.686966
1430	7	/api/users	GET	304	2025-10-28 16:52:22.513708
1431	7	/api/clients	GET	304	2025-10-28 16:52:23.14941
1452	7	/api/orders	GET	304	2025-10-28 16:52:30.481696
1498	7	/api/orders	GET	304	2025-10-28 16:55:56.789869
1505	7	/api/orders	GET	304	2025-10-28 16:55:58.746097
1513	7	/api/orders	GET	304	2025-10-28 16:56:00.669054
1527	7	/api/orders	GET	304	2025-10-28 16:57:53.902548
1536	7	/api/clients	GET	304	2025-10-28 16:57:55.005203
1540	7	/api/products	GET	304	2025-10-28 16:57:55.709431
1541	7	/api/clients	GET	304	2025-10-28 16:57:56.685615
1544	7	/api/clients	GET	304	2025-10-28 16:57:58.733453
1545	7	/api/products	GET	304	2025-10-28 16:57:59.206471
1548	7	/api/clients	GET	304	2025-10-28 16:57:59.80406
1562	7	/api/orders	GET	304	2025-10-28 16:58:01.981203
1565	7	/api/users	GET	304	2025-10-28 16:58:02.391059
1568	7	/api/clients	GET	304	2025-10-28 16:58:03.400687
1589	7	/api/orders	GET	304	2025-10-28 16:59:34.854327
1598	7	/api/products	GET	304	2025-10-28 16:59:35.695105
1610	7	/api/clients	GET	304	2025-10-28 16:59:38.344383
1617	7	/api/clients	GET	304	2025-10-28 16:59:39.933174
1622	7	/api/users	GET	304	2025-10-28 16:59:41.299241
1623	7	/api/products	GET	304	2025-10-28 16:59:41.93732
1648	7	/api/orders	GET	304	2025-10-28 17:00:42.984946
1655	7	/api/products	GET	304	2025-10-28 17:00:45.091078
1671	7	/api/products	GET	304	2025-10-28 17:00:51.208782
1679	7	/api/clients	GET	304	2025-10-28 17:01:52.148351
1712	7	/api/products	GET	304	2025-10-28 17:02:21.685692
1713	7	/api/products	GET	304	2025-10-28 17:02:22.975262
1716	7	/api/clients	GET	304	2025-10-28 17:02:29.200575
1717	7	/api/products	GET	304	2025-10-28 17:02:29.597421
1720	7	/api/clients	GET	304	2025-10-28 17:02:30.397658
1721	7	/api/products	GET	304	2025-10-28 17:02:32.480619
1724	7	/api/products	GET	304	2025-10-28 17:02:32.828875
1734	7	/api/orders	GET	304	2025-10-28 17:02:35.234156
1743	7	/api/orders	GET	304	2025-10-28 17:02:37.325297
1754	7	/api/clients	GET	304	2025-10-28 17:02:38.834434
1767	7	/api/orders	GET	304	2025-10-28 17:02:43.974608
1776	7	/api/clients	GET	304	2025-10-28 17:02:49.534603
1791	7	/api/clients	GET	304	2025-10-28 17:09:51.71963
1796	7	/api/users	GET	304	2025-10-28 17:09:52.084024
1810	7	/api/clients	GET	304	2025-10-28 17:11:32.089621
1811	7	/api/users	GET	304	2025-10-28 17:11:33.050896
1830	7	/api/products	GET	304	2025-10-28 17:11:54.389488
1839	7	/api/orders	GET	304	2025-10-28 17:11:59.917955
1853	7	/api/clients	GET	200	2025-10-28 17:50:00.51472
1855	7	/api/products	GET	200	2025-10-28 17:50:04.296421
1875	7	/api/clients	GET	304	2025-10-28 18:14:10.18522
1876	7	/api/clients	GET	304	2025-10-28 18:14:11.790109
1879	7	/api/clients	GET	304	2025-10-28 18:14:19.820673
1880	7	/api/clients	GET	304	2025-10-28 18:14:27.807341
1883	7	/api/clients	GET	304	2025-10-28 18:14:31.148384
1884	7	/api/clients	GET	200	2025-10-28 18:14:31.804663
1901	7	/api/clients	GET	304	2025-10-28 18:15:58.517529
1902	7	/api/clients	GET	200	2025-10-28 18:15:59.488755
1905	7	/api/clients	GET	200	2025-10-28 18:16:09.087824
1906	7	/api/clients	GET	200	2025-10-28 18:16:10.412948
1909	7	/api/clients	GET	200	2025-10-28 18:16:10.732226
1910	7	/api/clients	GET	304	2025-10-28 18:16:18.055932
1939	7	/api/clients	GET	200	2025-10-28 18:21:09.47824
1957	7	/api/clients	GET	304	2025-10-28 18:24:35.319536
1973	7	/api/products	GET	304	2025-10-28 18:27:19.350262
1974	7	/api/products	GET	304	2025-10-28 18:27:20.822623
1987	7	/api/clients	GET	304	2025-10-28 18:28:22.073949
2004	7	/api/users	GET	304	2025-10-28 18:32:45.142078
2007	7	/api/users	GET	304	2025-10-28 18:32:48.830164
2015	7	/api/products	GET	304	2025-10-28 18:33:28.60452
2022	7	/api/orders	GET	304	2025-10-28 18:34:49.198595
2030	7	/api/clients	GET	304	2025-10-28 18:35:15.986181
2037	7	/api/orders	GET	304	2025-10-28 18:35:34.746084
2038	7	/api/clients	GET	200	2025-10-28 18:35:35.760068
2059	7	/api/orders	GET	304	2025-10-28 18:36:16.836899
2060	7	/api/users	GET	304	2025-10-28 18:36:18.02869
2063	7	/api/products	GET	304	2025-10-28 18:36:19.85628
2064	7	/api/products	GET	304	2025-10-28 18:36:20.286463
2066	7	/api/clients	GET	304	2025-10-28 18:36:20.293233
2069	7	/api/orders	GET	304	2025-10-28 18:36:20.298565
2070	7	/api/products	GET	304	2025-10-28 18:36:21.052662
2073	7	/api/clients	GET	304	2025-10-28 18:36:21.40706
2075	7	/api/clients	GET	200	2025-10-28 18:36:31.57312
2076	7	/api/products	GET	200	2025-10-28 18:36:34.258458
2079	7	/api/clients	GET	200	2025-10-28 18:36:38.280634
2087	7	/api/clients	GET	304	2025-10-28 18:42:46.964832
2088	7	/api/clients	GET	200	2025-10-28 18:42:48.076405
2091	7	/api/clients	GET	200	2025-10-28 18:42:51.490807
2094	7	/api/clients	GET	304	2025-10-28 18:43:05.04777
2097	7	/api/products	GET	304	2025-10-28 18:43:05.492186
2098	7	/api/clients	GET	304	2025-10-28 18:43:05.850092
2101	7	/api/clients	GET	304	2025-10-28 18:43:08.346738
2102	7	/api/products	GET	304	2025-10-28 18:43:08.729047
2105	7	/api/products	GET	304	2025-10-28 18:43:09.348696
2108	7	/api/orders	GET	304	2025-10-28 18:43:09.494327
2111	7	/api/users	GET	304	2025-10-28 18:43:09.813494
2112	7	/api/orders	GET	304	2025-10-28 18:43:10.922462
2115	7	/api/orders	GET	304	2025-10-28 18:43:10.930622
2119	7	/api/products	GET	304	2025-10-28 18:43:11.190741
2121	7	/api/products	GET	304	2025-10-28 18:44:15.23718
2134	7	/api/products	GET	304	2025-10-28 18:46:17.163219
2137	7	/api/products	GET	304	2025-10-28 18:46:32.884752
2138	7	/api/products	GET	200	2025-10-28 18:46:34.986456
727	7	/api/orders	GET	304	2025-10-22 17:02:40.99308
728	7	/api/clients	GET	304	2025-10-22 17:02:41.018059
729	7	/api/orders	POST	201	2025-10-22 17:02:46.008076
730	7	/api/clients	GET	200	2025-10-22 17:02:52.444103
731	7	/api/products	GET	200	2025-10-22 17:02:52.444804
732	7	/api/orders	GET	200	2025-10-22 17:02:52.483484
733	7	/api/products	GET	200	2025-10-22 17:02:52.487038
734	7	/api/orders	GET	200	2025-10-22 17:02:52.488701
735	7	/api/clients	GET	200	2025-10-22 17:02:52.600538
736	7	/api/orders	GET	304	2025-10-22 17:03:01.140857
737	7	/api/orders	GET	304	2025-10-22 17:03:01.145604
738	7	/api/clients	GET	304	2025-10-22 17:08:10.475146
739	7	/api/products	GET	200	2025-10-22 17:08:10.48942
740	7	/api/orders	GET	304	2025-10-22 17:08:10.493827
741	7	/api/products	GET	304	2025-10-22 17:08:10.4974
742	7	/api/orders	GET	304	2025-10-22 17:08:10.500499
743	7	/api/clients	GET	304	2025-10-22 17:08:10.63827
744	7	/api/clients	GET	304	2025-10-22 17:08:12.156961
745	7	/api/products	GET	304	2025-10-22 17:08:12.158005
746	7	/api/orders	GET	304	2025-10-22 17:08:12.163516
747	7	/api/clients	GET	304	2025-10-22 17:08:12.16417
748	7	/api/products	GET	304	2025-10-22 17:08:12.166634
749	7	/api/orders	GET	304	2025-10-22 17:08:12.167357
750	7	/api/clients	GET	304	2025-10-22 17:08:13.104374
751	7	/api/products	GET	304	2025-10-22 17:08:13.10568
752	7	/api/orders	GET	304	2025-10-22 17:08:13.107388
753	7	/api/clients	GET	304	2025-10-22 17:08:13.117932
754	7	/api/products	GET	304	2025-10-22 17:08:13.264089
755	7	/api/orders	GET	304	2025-10-22 17:08:13.266044
756	7	/api/clients	GET	304	2025-10-22 17:08:14.119198
757	7	/api/products	GET	304	2025-10-22 17:08:14.119704
758	7	/api/orders	GET	304	2025-10-22 17:08:14.120234
759	7	/api/clients	GET	304	2025-10-22 17:08:14.126387
760	7	/api/products	GET	304	2025-10-22 17:08:14.12696
761	7	/api/orders	GET	304	2025-10-22 17:08:14.127518
762	7	/api/clients	GET	304	2025-10-22 17:08:16.121663
763	7	/api/products	GET	304	2025-10-22 17:08:16.124158
764	7	/api/orders	GET	304	2025-10-22 17:08:16.126667
765	7	/api/clients	GET	304	2025-10-22 17:08:16.13016
766	7	/api/products	GET	304	2025-10-22 17:08:16.132305
767	7	/api/orders	GET	304	2025-10-22 17:08:16.133956
768	7	/api/clients	GET	304	2025-10-22 17:08:46.186554
769	7	/api/products	GET	304	2025-10-22 17:08:46.189002
770	7	/api/orders	GET	304	2025-10-22 17:08:46.193194
771	7	/api/products	GET	304	2025-10-22 17:08:46.196204
772	7	/api/orders	GET	304	2025-10-22 17:08:46.198898
773	7	/api/clients	GET	304	2025-10-22 17:08:46.22223
774	7	/api/clients	GET	304	2025-10-22 17:08:47.088527
775	7	/api/products	GET	304	2025-10-22 17:08:47.089502
776	7	/api/orders	GET	304	2025-10-22 17:08:47.094396
777	7	/api/clients	GET	304	2025-10-22 17:08:47.094951
778	7	/api/products	GET	304	2025-10-22 17:08:47.130722
779	7	/api/orders	GET	304	2025-10-22 17:08:47.134442
780	7	/api/clients	GET	304	2025-10-22 17:08:49.11886
781	7	/api/products	GET	304	2025-10-22 17:08:49.119489
782	7	/api/orders	GET	304	2025-10-22 17:08:49.120178
783	7	/api/clients	GET	304	2025-10-22 17:08:49.126678
784	7	/api/products	GET	304	2025-10-22 17:08:49.127145
785	7	/api/orders	GET	304	2025-10-22 17:08:49.129799
786	7	/api/products	GET	304	2025-10-22 17:08:51.498232
787	7	/api/products	GET	304	2025-10-22 17:08:51.502187
788	7	/api/products	GET	200	2025-10-22 17:08:52.628693
789	7	/api/products	GET	200	2025-10-22 17:08:52.630015
790	7	/api/products	GET	200	2025-10-22 17:08:54.591522
791	7	/api/products	GET	200	2025-10-22 17:08:54.592502
792	7	/api/products	GET	200	2025-10-22 17:08:55.225902
793	7	/api/products	GET	200	2025-10-22 17:08:55.226935
794	7	/api/products	GET	200	2025-10-22 17:08:55.724213
795	7	/api/products	GET	200	2025-10-22 17:08:55.725212
796	7	/api/products	GET	200	2025-10-22 17:09:08.455285
797	7	/api/products	GET	200	2025-10-22 17:09:08.562371
798	7	/api/clients	GET	304	2025-10-22 17:09:11.937415
799	7	/api/clients	GET	304	2025-10-22 17:09:11.941304
800	7	/api/products	GET	304	2025-10-22 17:09:12.775317
801	7	/api/products	GET	304	2025-10-22 17:09:12.779503
802	7	/api/clients	GET	304	2025-10-22 17:09:13.231843
803	7	/api/products	GET	304	2025-10-22 17:09:13.232984
804	7	/api/clients	GET	304	2025-10-22 17:09:13.280617
805	7	/api/products	GET	304	2025-10-22 17:09:13.281107
806	7	/api/orders	GET	304	2025-10-22 17:09:13.282104
807	7	/api/orders	GET	304	2025-10-22 17:09:13.287116
808	7	/api/products	GET	304	2025-10-22 17:09:22.441384
809	7	/api/products	GET	304	2025-10-22 17:09:22.446083
810	7	/api/products	GET	200	2025-10-22 17:09:24.619884
811	7	/api/products	GET	200	2025-10-22 17:09:24.620825
812	7	/api/products	GET	304	2025-10-22 17:10:09.292652
813	7	/api/products	GET	304	2025-10-22 17:10:09.331164
814	7	/api/products	GET	304	2025-10-22 17:10:10.31177
815	7	/api/products	GET	304	2025-10-22 17:10:10.316752
816	7	/api/products	GET	200	2025-10-22 17:10:10.851694
817	7	/api/products	GET	200	2025-10-22 17:10:10.852343
818	7	/api/products	GET	200	2025-10-22 17:10:12.235214
819	7	/api/products	GET	200	2025-10-22 17:10:12.236328
820	7	/api/products	GET	200	2025-10-22 17:10:12.662993
821	7	/api/products	GET	200	2025-10-22 17:10:12.663741
822	7	/api/products	GET	304	2025-10-22 17:11:03.156176
823	7	/api/products	GET	304	2025-10-22 17:11:03.19125
824	7	/api/products	GET	304	2025-10-22 17:11:04.449509
825	7	/api/products	GET	304	2025-10-22 17:11:04.454141
826	7	/api/products	GET	200	2025-10-22 17:11:05.132403
827	7	/api/products	GET	200	2025-10-22 17:11:05.133361
828	7	/api/products	GET	200	2025-10-22 17:11:05.89839
829	7	/api/products	GET	200	2025-10-22 17:11:05.899326
830	7	/api/products	GET	200	2025-10-22 17:11:09.131837
831	7	/api/products	GET	200	2025-10-22 17:11:09.132858
832	\N	/api/auth/login	POST	200	2025-10-22 17:11:52.627935
833	7	/api/products	GET	304	2025-10-22 17:11:55.321454
834	7	/api/products	GET	304	2025-10-22 17:11:55.357477
835	7	/api/products	GET	200	2025-10-22 17:12:09.733592
836	7	/api/products	GET	200	2025-10-22 17:12:09.734434
837	7	/api/products	GET	200	2025-10-22 17:12:10.558881
838	7	/api/products	GET	200	2025-10-22 17:12:10.560346
839	7	/api/products	GET	200	2025-10-22 17:12:31.454537
840	7	/api/products	GET	200	2025-10-22 17:12:31.455349
841	7	/api/products	GET	200	2025-10-22 17:12:32.333703
842	7	/api/products	GET	200	2025-10-22 17:12:32.334843
843	7	/api/products	GET	200	2025-10-22 17:13:24.615366
844	7	/api/products	GET	200	2025-10-22 17:13:24.61848
845	7	/api/products	GET	200	2025-10-22 17:13:25.545151
846	7	/api/products	GET	200	2025-10-22 17:13:25.54594
847	7	/api/products	GET	304	2025-10-22 17:13:28.902437
850	7	/api/products	GET	200	2025-10-22 17:13:29.136998
851	7	/api/products	GET	200	2025-10-22 17:13:29.649568
854	7	/api/products	GET	200	2025-10-22 17:13:30.490322
1279	7	/api/products	GET	304	2025-10-28 16:47:52.529726
1282	7	/api/products	GET	304	2025-10-28 16:47:56.980446
1290	7	/api/clients	GET	200	2025-10-28 16:47:57.774263
1295	7	/api/orders	GET	304	2025-10-28 16:48:05.133809
1302	7	/api/orders	GET	200	2025-10-28 16:48:06.964942
1307	7	/api/orders	GET	304	2025-10-28 16:48:10.222086
1314	7	/api/clients	GET	200	2025-10-28 16:48:11.227508
1319	7	/api/orders	GET	304	2025-10-28 16:48:15.85316
1326	7	/api/clients	GET	304	2025-10-28 16:48:18.260813
1331	7	/api/orders	GET	304	2025-10-28 16:48:20.558516
1338	7	/api/clients	GET	304	2025-10-28 16:48:24.747113
1343	7	/api/orders	GET	304	2025-10-28 16:48:26.244242
1350	7	/api/clients	GET	200	2025-10-28 16:48:27.213463
1358	7	/api/orders	GET	200	2025-10-28 16:49:21.218896
1384	7	/api/products	GET	304	2025-10-28 16:51:41.867745
1392	7	/api/clients	GET	304	2025-10-28 16:51:42.344646
1399	7	/api/products	GET	200	2025-10-28 16:51:43.204459
1404	7	/api/products	GET	200	2025-10-28 16:51:55.637165
1428	7	/api/orders	GET	304	2025-10-28 16:52:21.68915
1429	7	/api/users	GET	304	2025-10-28 16:52:22.507992
1432	7	/api/products	GET	304	2025-10-28 16:52:23.15007
1450	7	/api/products	GET	304	2025-10-28 16:52:30.476792
1457	7	/api/clients	GET	304	2025-10-28 16:52:32.546113
1500	7	/api/clients	GET	304	2025-10-28 16:55:56.795686
1501	7	/api/products	GET	304	2025-10-28 16:55:57.81803
1504	7	/api/products	GET	304	2025-10-28 16:55:58.745219
1514	7	/api/clients	GET	304	2025-10-28 16:56:00.676313
1529	7	/api/clients	GET	304	2025-10-28 16:57:53.909641
1532	7	/api/users	GET	304	2025-10-28 16:57:54.478096
1533	7	/api/clients	GET	304	2025-10-28 16:57:54.995688
1552	7	/api/orders	GET	304	2025-10-28 16:57:59.816777
1553	7	/api/users	GET	304	2025-10-28 16:58:00.443746
1556	7	/api/clients	GET	304	2025-10-28 16:58:01.083496
1557	7	/api/products	GET	304	2025-10-28 16:58:01.562477
1560	7	/api/products	GET	304	2025-10-28 16:58:01.980075
1590	7	/api/products	GET	304	2025-10-28 16:59:34.857012
1596	7	/api/clients	GET	304	2025-10-28 16:59:35.690063
1602	7	/api/products	GET	304	2025-10-28 16:59:36.027272
1603	7	/api/clients	GET	304	2025-10-28 16:59:37.024372
1606	7	/api/products	GET	304	2025-10-28 16:59:37.491807
1607	7	/api/clients	GET	304	2025-10-28 16:59:38.33588
1611	7	/api/products	GET	304	2025-10-28 16:59:38.345328
1614	7	/api/products	GET	304	2025-10-28 16:59:39.222482
1615	7	/api/clients	GET	304	2025-10-28 16:59:39.925035
1628	7	/api/clients	GET	304	2025-10-28 16:59:41.947291
1650	7	/api/products	GET	304	2025-10-28 17:00:42.992129
1651	7	/api/products	GET	304	2025-10-28 17:00:43.901792
1654	7	/api/orders	GET	304	2025-10-28 17:00:45.090581
1669	7	/api/orders	GET	304	2025-10-28 17:00:51.202667
1680	7	/api/products	GET	304	2025-10-28 17:01:52.151324
1688	7	/api/clients	GET	304	2025-10-28 17:01:56.233251
1693	7	/api/orders	GET	304	2025-10-28 17:02:02.016547
1700	7	/api/clients	GET	304	2025-10-28 17:02:08.009629
1726	7	/api/products	GET	304	2025-10-28 17:02:32.868461
1728	7	/api/orders	GET	304	2025-10-28 17:02:33.011904
1729	7	/api/users	GET	304	2025-10-28 17:02:34.050207
1732	7	/api/clients	GET	304	2025-10-28 17:02:35.227595
1736	7	/api/products	GET	304	2025-10-28 17:02:35.235408
1737	7	/api/products	GET	304	2025-10-28 17:02:35.929434
1740	7	/api/users	GET	304	2025-10-28 17:02:36.868615
1741	7	/api/clients	GET	304	2025-10-28 17:02:37.321654
1755	7	/api/products	GET	304	2025-10-28 17:02:38.83519
1758	7	/api/products	GET	304	2025-10-28 17:02:39.188676
1759	7	/api/clients	GET	304	2025-10-28 17:02:39.503316
1762	7	/api/clients	GET	304	2025-10-28 17:02:40.703148
1763	7	/api/products	GET	304	2025-10-28 17:02:41.902988
1766	7	/api/products	GET	304	2025-10-28 17:02:43.966529
1770	7	/api/orders	GET	304	2025-10-28 17:02:43.97844
1771	7	/api/users	GET	304	2025-10-28 17:02:47.148702
1774	7	/api/products	GET	304	2025-10-28 17:02:49.526687
1778	7	/api/orders	GET	304	2025-10-28 17:02:49.536257
1779	7	/api/products	GET	304	2025-10-28 17:02:57.052725
1782	7	/api/clients	GET	304	2025-10-28 17:02:57.715221
1792	7	/api/products	GET	304	2025-10-28 17:09:51.722881
1795	7	/api/users	GET	304	2025-10-28 17:09:52.077415
1813	7	/api/clients	GET	304	2025-10-28 17:11:44.135764
1832	7	/api/clients	GET	304	2025-10-28 17:11:54.495279
1833	7	/api/products	GET	304	2025-10-28 17:11:58.435094
1836	7	/api/users	GET	304	2025-10-28 17:11:59.370933
1837	7	/api/products	GET	304	2025-10-28 17:11:59.90939
1841	7	/api/clients	GET	304	2025-10-28 17:11:59.919156
1844	7	/api/products	GET	304	2025-10-28 17:12:00.531714
1845	7	/api/clients	GET	304	2025-10-28 17:12:00.848936
1856	7	/api/clients	GET	304	2025-10-28 18:10:31.267342
1859	7	/api/clients	GET	200	2025-10-28 18:10:33.029623
1860	7	/api/clients	GET	200	2025-10-28 18:10:34.493999
1886	7	/api/clients	GET	200	2025-10-28 18:14:43.932517
1889	7	/api/clients	GET	304	2025-10-28 18:14:46.272758
1890	7	/api/clients	GET	200	2025-10-28 18:14:47.966726
1912	7	/api/clients	GET	304	2025-10-28 18:17:25.837147
1915	7	/api/clients	GET	304	2025-10-28 18:17:27.819622
1916	7	/api/clients	GET	304	2025-10-28 18:17:35.818991
1919	7	/api/clients	GET	304	2025-10-28 18:17:36.800445
1920	7	/api/clients	GET	200	2025-10-28 18:17:38.894971
1940	\N	/api/auth/login	POST	401	2025-10-28 18:21:30.007626
1941	\N	/api/auth/login	POST	200	2025-10-28 18:21:32.431163
1943	7	/api/clients	GET	200	2025-10-28 18:21:37.527158
1945	7	/api/products	GET	200	2025-10-28 18:21:39.695103
1946	7	/api/clients	GET	200	2025-10-28 18:21:41.147104
1958	7	/api/clients	GET	304	2025-10-28 18:24:48.002638
1975	7	/api/products	GET	304	2025-10-28 18:27:20.826746
1988	7	/api/clients	GET	304	2025-10-28 18:30:03.168166
1991	7	/api/products	GET	304	2025-10-28 18:30:03.551823
1992	7	/api/products	GET	200	2025-10-28 18:30:04.591137
2005	7	/api/users	GET	304	2025-10-28 18:32:45.176207
2006	7	/api/users	GET	304	2025-10-28 18:32:48.826026
2016	7	/api/orders	GET	304	2025-10-28 18:33:28.609104
2023	7	/api/clients	GET	304	2025-10-28 18:34:49.238429
2032	7	/api/clients	GET	304	2025-10-28 18:35:34.695479
2043	7	/api/orders	GET	200	2025-10-28 18:35:35.771285
2044	7	/api/users	GET	304	2025-10-28 18:36:08.487864
2047	7	/api/products	GET	304	2025-10-28 18:36:13.563782
2049	7	/api/orders	GET	304	2025-10-28 18:36:13.607342
2056	7	/api/orders	GET	304	2025-10-28 18:36:16.79737
2080	7	/api/clients	GET	200	2025-10-28 18:36:38.328149
2089	7	/api/clients	GET	200	2025-10-28 18:42:48.076807
848	7	/api/products	GET	304	2025-10-22 17:13:28.906284
849	7	/api/products	GET	200	2025-10-22 17:13:29.136265
852	7	/api/products	GET	200	2025-10-22 17:13:29.650271
853	7	/api/products	GET	200	2025-10-22 17:13:30.489649
855	7	/api/products	GET	304	2025-10-22 17:14:06.756754
856	7	/api/products	GET	304	2025-10-22 17:14:06.793998
857	7	/api/products	GET	200	2025-10-22 17:14:07.155979
858	7	/api/products	GET	200	2025-10-22 17:14:07.157033
859	7	/api/products	GET	200	2025-10-22 17:14:07.748003
860	7	/api/products	GET	200	2025-10-22 17:14:07.748736
861	7	/api/products	GET	304	2025-10-22 17:14:16.830329
862	7	/api/products	GET	304	2025-10-22 17:14:16.833711
863	7	/api/products	GET	304	2025-10-22 17:14:19.489099
864	7	/api/products	GET	304	2025-10-22 17:14:19.493768
865	7	/api/products	GET	304	2025-10-22 17:14:23.348798
866	7	/api/products	GET	304	2025-10-22 17:14:23.353307
867	7	/api/products	GET	200	2025-10-22 17:14:24.632002
868	7	/api/products	GET	200	2025-10-22 17:14:24.632735
869	7	/api/products	GET	200	2025-10-22 17:14:25.703546
870	7	/api/products	GET	200	2025-10-22 17:14:25.704305
871	7	/api/products	GET	304	2025-10-22 17:14:25.853943
872	7	/api/products	GET	304	2025-10-22 17:14:25.857756
873	7	/api/products	GET	304	2025-10-22 17:14:27.657895
874	7	/api/products	GET	304	2025-10-22 17:14:27.664008
875	7	/api/products	GET	304	2025-10-22 17:14:27.790505
876	7	/api/products	GET	304	2025-10-22 17:14:27.794747
877	7	/api/products	GET	304	2025-10-22 17:14:27.97709
878	7	/api/products	GET	304	2025-10-22 17:14:27.980981
879	7	/api/clients	GET	304	2025-10-22 17:14:29.892697
880	7	/api/clients	GET	304	2025-10-22 17:14:29.896338
881	7	/api/products	GET	304	2025-10-22 17:14:32.018134
882	7	/api/products	GET	304	2025-10-22 17:14:32.02185
883	7	/api/clients	GET	304	2025-10-22 17:14:32.731187
884	7	/api/products	GET	304	2025-10-22 17:14:32.732065
885	7	/api/clients	GET	304	2025-10-22 17:14:32.781385
886	7	/api/products	GET	304	2025-10-22 17:14:32.781997
887	7	/api/orders	GET	304	2025-10-22 17:14:32.783787
888	7	/api/orders	GET	304	2025-10-22 17:14:32.789142
889	7	/api/users	GET	304	2025-10-22 17:14:34.564223
890	7	/api/users	GET	304	2025-10-22 17:14:34.56972
891	7	/api/products	GET	304	2025-10-22 17:14:36.686897
892	7	/api/orders	GET	304	2025-10-22 17:14:36.687543
893	7	/api/clients	GET	304	2025-10-22 17:14:36.6886
894	7	/api/products	GET	304	2025-10-22 17:14:36.696725
895	7	/api/orders	GET	304	2025-10-22 17:14:36.697653
896	7	/api/clients	GET	304	2025-10-22 17:14:36.7328
897	7	/api/products	GET	304	2025-10-22 17:14:36.98558
898	7	/api/products	GET	304	2025-10-22 17:14:36.989711
899	7	/api/products	GET	200	2025-10-22 17:14:47.532882
900	7	/api/products	GET	200	2025-10-22 17:14:47.533495
901	7	/api/products	GET	200	2025-10-22 17:14:48.084848
902	7	/api/products	GET	200	2025-10-22 17:14:48.085694
903	7	/api/clients	GET	304	2025-10-22 17:15:42.96596
904	7	/api/clients	GET	304	2025-10-22 17:15:43.001189
905	7	/api/products	GET	304	2025-10-22 17:15:43.308462
906	7	/api/products	GET	304	2025-10-22 17:15:43.31373
907	7	/api/clients	GET	304	2025-10-22 17:15:44.614468
908	7	/api/clients	GET	304	2025-10-22 17:15:44.617488
909	7	/api/products	GET	304	2025-10-22 17:15:45.837583
910	7	/api/products	GET	304	2025-10-22 17:15:45.841357
911	7	/api/clients	GET	304	2025-10-22 17:15:46.814082
912	7	/api/products	GET	304	2025-10-22 17:15:46.8165
913	7	/api/clients	GET	304	2025-10-22 17:15:46.859221
914	7	/api/products	GET	304	2025-10-22 17:15:46.860581
915	7	/api/orders	GET	304	2025-10-22 17:15:46.861538
916	7	/api/orders	GET	304	2025-10-22 17:15:46.865921
917	7	/api/users	GET	304	2025-10-22 17:15:47.396182
918	7	/api/users	GET	304	2025-10-22 17:15:47.401155
919	7	/api/products	GET	304	2025-10-22 17:15:47.979685
920	7	/api/orders	GET	304	2025-10-22 17:15:47.980407
921	7	/api/clients	GET	304	2025-10-22 17:15:47.984922
922	7	/api/products	GET	304	2025-10-22 17:15:47.985424
923	7	/api/orders	GET	304	2025-10-22 17:15:47.986048
924	7	/api/clients	GET	304	2025-10-22 17:15:48.019707
925	7	/api/products	GET	304	2025-10-22 17:15:50.240232
926	7	/api/products	GET	304	2025-10-22 17:15:50.245762
927	\N	/api/auth/login	POST	200	2025-10-22 17:19:09.254023
928	7	/api/products	GET	304	2025-10-22 17:19:12.030038
929	7	/api/products	GET	304	2025-10-22 17:19:12.066008
930	7	/api/products	GET	304	2025-10-22 17:19:37.418333
931	7	/api/products	GET	304	2025-10-22 17:19:37.457652
932	7	/api/products	GET	200	2025-10-22 17:19:38.422138
933	7	/api/products	GET	200	2025-10-22 17:19:38.423246
934	7	/api/products	GET	304	2025-10-22 17:21:11.90829
935	7	/api/products	GET	304	2025-10-22 17:21:11.941874
936	7	/api/products	GET	200	2025-10-22 17:21:13.627921
937	7	/api/products	GET	200	2025-10-22 17:21:13.628796
938	7	/api/clients	GET	304	2025-10-22 17:21:23.432856
939	7	/api/clients	GET	304	2025-10-22 17:21:23.436849
940	7	/api/products	GET	304	2025-10-22 17:21:26.623904
941	7	/api/products	GET	304	2025-10-22 17:21:26.627658
942	7	/api/products	GET	304	2025-10-22 17:23:25.330209
943	7	/api/products	GET	304	2025-10-22 17:23:25.490068
944	7	/api/products	GET	304	2025-10-22 17:23:27.156221
945	7	/api/products	GET	304	2025-10-22 17:23:27.160162
946	7	/api/products	GET	304	2025-10-22 17:23:30.144587
947	7	/api/products	GET	304	2025-10-22 17:23:30.149476
948	7	/api/products	GET	200	2025-10-22 17:23:32.388048
949	7	/api/products	GET	200	2025-10-22 17:23:32.38876
950	7	/api/products	GET	200	2025-10-22 17:23:33.573483
951	7	/api/products	GET	200	2025-10-22 17:23:33.574582
952	7	/api/products	GET	304	2025-10-22 17:23:59.583129
953	7	/api/products	GET	304	2025-10-22 17:23:59.618777
954	7	/api/products	GET	304	2025-10-22 17:24:08.759658
955	7	/api/products	GET	304	2025-10-22 17:24:08.763567
956	7	/api/products	GET	304	2025-10-22 17:24:28.62569
957	7	/api/products	GET	304	2025-10-22 17:24:28.657931
958	7	/api/products/8	PUT	200	2025-10-22 17:24:35.935691
959	7	/api/products	GET	304	2025-10-22 17:24:35.942024
960	7	/api/products	GET	200	2025-10-22 17:24:37.548934
961	7	/api/products	GET	200	2025-10-22 17:24:37.549527
962	7	/api/products/8	PUT	200	2025-10-22 17:24:52.696206
963	7	/api/products	GET	304	2025-10-22 17:24:52.703738
964	7	/api/products	GET	304	2025-10-22 17:26:26.463842
965	7	/api/products	GET	304	2025-10-22 17:26:26.497641
966	7	/api/products	GET	304	2025-10-22 17:26:29.10805
967	7	/api/products	GET	304	2025-10-22 17:26:29.112073
968	7	/api/products	GET	304	2025-10-22 17:27:19.189617
969	7	/api/products	GET	304	2025-10-22 17:27:19.334784
970	7	/api/products	GET	200	2025-10-22 17:27:21.115554
971	7	/api/products	GET	200	2025-10-22 17:27:21.116434
972	7	/api/products/8	PUT	200	2025-10-22 17:27:26.516488
973	7	/api/products	GET	304	2025-10-22 17:27:26.523187
974	7	/api/products	GET	304	2025-10-22 17:27:28.153111
977	7	/api/products	GET	200	2025-10-22 17:27:32.130509
978	7	/api/products/8	PUT	200	2025-10-22 17:27:35.737932
979	7	/api/products	GET	304	2025-10-22 17:27:35.746757
1280	7	/api/orders	GET	304	2025-10-28 16:47:52.531387
1281	7	/api/clients	GET	304	2025-10-28 16:47:56.97959
1285	7	/api/products	GET	304	2025-10-28 16:47:56.986474
1288	7	/api/products	GET	200	2025-10-28 16:47:57.772481
1303	7	/api/products	GET	200	2025-10-28 16:48:06.965729
1306	7	/api/products	GET	304	2025-10-28 16:48:10.221612
1310	7	/api/orders	GET	304	2025-10-28 16:48:10.232031
1311	7	/api/clients	GET	200	2025-10-28 16:48:11.222032
1359	7	/api/clients	GET	200	2025-10-28 16:49:51.270016
1370	7	/api/orders	GET	200	2025-10-28 16:49:54.306129
1371	7	/api/clients	GET	200	2025-10-28 16:50:00.222009
1382	7	/api/orders	GET	200	2025-10-28 16:50:00.838991
1385	7	/api/orders	GET	304	2025-10-28 16:51:41.87314
1393	7	/api/products	GET	304	2025-10-28 16:51:42.347107
1396	7	/api/products	GET	200	2025-10-28 16:51:43.202752
1405	7	/api/orders	GET	200	2025-10-28 16:51:55.640823
1463	7	/api/products	GET	304	2025-10-28 16:54:00.201151
1466	7	/api/clients	GET	304	2025-10-28 16:54:01.802745
1467	7	/api/clients	GET	304	2025-10-28 16:54:01.812488
1476	7	/api/products	GET	304	2025-10-28 16:54:05.68613
1507	7	/api/products	GET	304	2025-10-28 16:55:58.789679
1510	7	/api/users	GET	304	2025-10-28 16:55:59.450861
1511	7	/api/clients	GET	304	2025-10-28 16:56:00.667517
1530	7	/api/products	GET	304	2025-10-28 16:57:53.910105
1531	7	/api/users	GET	304	2025-10-28 16:57:54.472134
1534	7	/api/products	GET	304	2025-10-28 16:57:54.996479
1549	7	/api/orders	GET	304	2025-10-28 16:57:59.8093
1554	7	/api/users	GET	304	2025-10-28 16:58:00.448079
1555	7	/api/clients	GET	304	2025-10-28 16:58:01.080852
1558	7	/api/products	GET	304	2025-10-28 16:58:01.566376
1559	7	/api/clients	GET	304	2025-10-28 16:58:01.97317
1591	7	/api/clients	GET	304	2025-10-28 16:59:34.858452
1593	7	/api/users	GET	304	2025-10-28 16:59:35.274058
1597	7	/api/orders	GET	304	2025-10-28 16:59:35.690581
1609	7	/api/orders	GET	304	2025-10-28 16:59:38.337558
1618	7	/api/orders	GET	304	2025-10-28 16:59:39.936898
1621	7	/api/users	GET	304	2025-10-28 16:59:41.293414
1624	7	/api/orders	GET	304	2025-10-28 16:59:41.937949
1657	7	/api/products	GET	304	2025-10-28 17:00:45.131546
1660	7	/api/products	GET	304	2025-10-28 17:00:48.180345
1661	7	/api/clients	GET	304	2025-10-28 17:00:48.979372
1664	7	/api/clients	GET	304	2025-10-28 17:00:50.084004
1665	7	/api/products	GET	304	2025-10-28 17:00:50.655541
1668	7	/api/products	GET	304	2025-10-28 17:00:51.200363
1681	7	/api/orders	GET	304	2025-10-28 17:01:52.155143
1727	7	/api/orders	GET	304	2025-10-28 17:02:33.007341
1730	7	/api/users	GET	304	2025-10-28 17:02:34.055804
1731	7	/api/orders	GET	304	2025-10-28 17:02:35.219632
1735	7	/api/clients	GET	304	2025-10-28 17:02:35.23473
1738	7	/api/products	GET	304	2025-10-28 17:02:35.933923
1739	7	/api/users	GET	304	2025-10-28 17:02:36.863559
1742	7	/api/products	GET	304	2025-10-28 17:02:37.322264
1745	7	/api/orders	GET	304	2025-10-28 17:02:37.331655
1748	7	/api/products	GET	304	2025-10-28 17:02:37.889993
1749	7	/api/users	GET	304	2025-10-28 17:02:38.439222
1752	7	/api/products	GET	304	2025-10-28 17:02:38.826354
1756	7	/api/orders	GET	304	2025-10-28 17:02:38.83834
1757	7	/api/products	GET	304	2025-10-28 17:02:39.183568
1760	7	/api/clients	GET	304	2025-10-28 17:02:39.505609
1761	7	/api/clients	GET	304	2025-10-28 17:02:40.700237
1764	7	/api/products	GET	304	2025-10-28 17:02:41.906802
1765	7	/api/clients	GET	304	2025-10-28 17:02:43.965305
1793	7	/api/orders	GET	304	2025-10-28 17:09:51.726033
1814	7	/api/products	GET	304	2025-10-28 17:11:44.136431
1847	\N	/api/auth/login	POST	200	2025-10-28 17:31:05.079004
1857	7	/api/clients	GET	304	2025-10-28 18:10:31.301076
1858	7	/api/clients	GET	200	2025-10-28 18:10:33.029125
1861	7	/api/clients	GET	200	2025-10-28 18:10:34.495048
1887	7	/api/clients	GET	200	2025-10-28 18:14:43.933664
1888	7	/api/clients	GET	304	2025-10-28 18:14:46.269388
1891	7	/api/clients	GET	200	2025-10-28 18:14:47.967292
1913	7	/api/clients	GET	304	2025-10-28 18:17:25.870623
1914	7	/api/clients	GET	304	2025-10-28 18:17:27.817405
1917	7	/api/clients	GET	304	2025-10-28 18:17:35.821366
1918	7	/api/clients	GET	304	2025-10-28 18:17:36.798163
1921	7	/api/clients	GET	200	2025-10-28 18:17:38.895408
1942	7	/api/clients	GET	200	2025-10-28 18:21:37.526297
1944	7	/api/products	GET	200	2025-10-28 18:21:39.694042
1947	7	/api/products	GET	200	2025-10-28 18:21:41.147525
1959	7	/api/clients	GET	304	2025-10-28 18:24:48.139925
1976	7	/api/products	GET	304	2025-10-28 18:27:33.837157
1979	7	/api/products	GET	304	2025-10-28 18:27:42.386669
1980	7	/api/products	GET	200	2025-10-28 18:27:43.844226
1983	7	/api/products	GET	200	2025-10-28 18:27:44.618255
1989	7	/api/clients	GET	304	2025-10-28 18:30:03.305174
1990	7	/api/products	GET	304	2025-10-28 18:30:03.546075
1993	7	/api/products	GET	200	2025-10-28 18:30:04.591553
2008	7	/api/users	GET	304	2025-10-28 18:33:00.973325
2017	7	/api/clients	GET	304	2025-10-28 18:33:28.647402
2024	7	/api/products	GET	304	2025-10-28 18:34:49.24078
2033	7	/api/products	GET	304	2025-10-28 18:35:34.697797
2041	7	/api/orders	GET	200	2025-10-28 18:35:35.768964
2045	7	/api/users	GET	304	2025-10-28 18:36:08.52168
2046	7	/api/clients	GET	304	2025-10-28 18:36:13.562775
2058	7	/api/products	GET	304	2025-10-28 18:36:16.804933
2081	7	/api/products	GET	200	2025-10-28 18:36:38.328586
2090	7	/api/clients	GET	200	2025-10-28 18:42:51.490092
2106	7	/api/clients	GET	304	2025-10-28 18:43:09.389614
2114	7	/api/products	GET	304	2025-10-28 18:43:10.925603
2117	7	/api/products	GET	304	2025-10-28 18:43:10.96204
2118	7	/api/products	GET	304	2025-10-28 18:43:11.187021
2122	7	/api/products	GET	304	2025-10-28 18:44:28.911728
2125	7	/api/products	GET	304	2025-10-28 18:44:32.820012
2126	7	/api/products	GET	304	2025-10-28 18:44:39.822491
2129	7	/api/products	GET	304	2025-10-28 18:44:41.185326
2130	7	/api/products	GET	200	2025-10-28 18:44:42.752667
2133	7	/api/products	GET	200	2025-10-28 18:44:47.245358
2135	7	/api/products	GET	304	2025-10-28 18:46:17.196503
2141	7	/api/clients	GET	304	2025-10-28 18:46:35.333141
2143	7	/api/orders	GET	304	2025-10-28 18:46:35.376361
2144	7	/api/clients	GET	304	2025-10-28 18:46:35.378833
2147	7	/api/products	GET	200	2025-10-28 18:46:36.405476
2148	7	/api/orders	GET	200	2025-10-28 18:46:36.406027
975	7	/api/products	GET	304	2025-10-22 17:27:28.156977
976	7	/api/products	GET	200	2025-10-22 17:27:32.129664
980	7	/api/products	POST	201	2025-10-22 17:28:10.93099
981	7	/api/products	GET	200	2025-10-22 17:28:10.937351
982	\N	/api/auth/login	POST	200	2025-10-28 15:44:50.017551
983	7	/api/clients	GET	304	2025-10-28 15:44:55.64585
984	7	/api/clients	GET	304	2025-10-28 15:44:55.812337
985	7	/api/clients	GET	304	2025-10-28 15:44:59.413424
986	7	/api/products	GET	200	2025-10-28 15:44:59.423288
987	7	/api/products	GET	304	2025-10-28 15:44:59.429674
988	7	/api/clients	GET	304	2025-10-28 15:44:59.464724
989	7	/api/orders	GET	304	2025-10-28 15:44:59.46754
990	7	/api/orders	GET	304	2025-10-28 15:44:59.472719
991	7	/api/products	GET	304	2025-10-28 15:44:59.903634
992	7	/api/products	GET	304	2025-10-28 15:44:59.9093
993	7	/api/products	GET	304	2025-10-28 15:45:01.759779
994	7	/api/orders	GET	304	2025-10-28 15:45:01.76034
995	7	/api/clients	GET	304	2025-10-28 15:45:01.761154
996	7	/api/products	GET	304	2025-10-28 15:45:01.769784
997	7	/api/clients	GET	304	2025-10-28 15:45:01.805303
998	7	/api/orders	GET	304	2025-10-28 15:45:01.807279
999	7	/api/products	GET	304	2025-10-28 15:45:04.039226
1000	7	/api/products	GET	304	2025-10-28 15:45:04.045359
1001	7	/api/clients	GET	304	2025-10-28 15:45:08.828883
1002	7	/api/products	GET	304	2025-10-28 15:45:08.829526
1003	7	/api/orders	GET	304	2025-10-28 15:45:08.830325
1004	7	/api/clients	GET	304	2025-10-28 15:45:08.837937
1005	7	/api/products	GET	304	2025-10-28 15:45:08.838443
1006	7	/api/orders	GET	304	2025-10-28 15:45:08.839297
1007	7	/api/users	GET	200	2025-10-28 15:45:20.877428
1008	7	/api/users	GET	304	2025-10-28 15:45:20.912617
1009	7	/api/products	GET	304	2025-10-28 15:45:22.338538
1010	7	/api/products	GET	304	2025-10-28 15:45:22.344149
1011	7	/api/products/2	PUT	200	2025-10-28 15:45:48.12958
1012	7	/api/products	GET	304	2025-10-28 15:45:48.137646
1013	7	/api/products	GET	304	2025-10-28 15:45:50.218126
1014	7	/api/products	GET	304	2025-10-28 15:45:50.257583
1015	7	/api/products/5	PUT	200	2025-10-28 15:46:17.345419
1016	7	/api/products	GET	200	2025-10-28 15:46:17.354801
1017	7	/api/products/2	PUT	200	2025-10-28 15:48:51.388485
1018	7	/api/products	GET	200	2025-10-28 15:48:51.395911
1019	7	/api/products	GET	304	2025-10-28 15:51:10.14767
1020	7	/api/products	GET	304	2025-10-28 15:51:10.204731
1021	7	/api/products	GET	304	2025-10-28 15:51:10.775199
1022	7	/api/products	GET	304	2025-10-28 15:51:10.77896
1023	7	/api/products	GET	304	2025-10-28 15:51:28.828065
1024	7	/api/products	GET	304	2025-10-28 15:51:28.861407
1025	7	/api/products	GET	304	2025-10-28 15:51:55.821473
1026	7	/api/products	GET	304	2025-10-28 15:51:55.856146
1027	7	/api/products	GET	304	2025-10-28 15:51:57.758148
1028	7	/api/products	GET	304	2025-10-28 15:51:57.7619
1029	7	/api/products/2	PUT	200	2025-10-28 15:52:14.352214
1030	7	/api/products	GET	200	2025-10-28 15:52:14.361091
1031	7	/api/products/2	PUT	500	2025-10-28 15:57:59.633441
1032	7	/api/products	GET	200	2025-10-28 16:06:45.874656
1033	7	/api/products	GET	200	2025-10-28 16:06:45.910003
1034	7	/api/products/2	PUT	200	2025-10-28 16:06:51.446078
1035	7	/api/products	GET	304	2025-10-28 16:06:51.453323
1036	7	/api/products	GET	304	2025-10-28 16:08:16.487775
1037	7	/api/products	GET	304	2025-10-28 16:08:16.524809
1038	7	/api/products/2	PUT	200	2025-10-28 16:08:30.49968
1039	7	/api/products	GET	200	2025-10-28 16:08:30.509864
1040	7	/api/products	GET	304	2025-10-28 16:20:28.407413
1041	7	/api/products	GET	304	2025-10-28 16:20:28.446624
1042	7	/api/products/2	PUT	200	2025-10-28 16:20:32.922243
1043	7	/api/products	GET	304	2025-10-28 16:20:32.929468
1044	7	/api/products/10	DELETE	200	2025-10-28 16:20:47.05296
1045	7	/api/products	GET	200	2025-10-28 16:20:47.059718
1046	7	/api/products	POST	201	2025-10-28 16:20:53.16946
1047	7	/api/products	GET	200	2025-10-28 16:20:53.175298
1048	7	/api/products	GET	304	2025-10-28 16:22:31.400816
1049	7	/api/products	GET	304	2025-10-28 16:22:31.439072
1050	7	/api/products/11	PUT	500	2025-10-28 16:22:45.603112
1051	7	/api/products	GET	200	2025-10-28 16:23:34.664247
1052	7	/api/products	GET	200	2025-10-28 16:23:34.829693
1053	7	/api/products/11	PUT	500	2025-10-28 16:23:41.109733
1054	7	/api/products	GET	200	2025-10-28 16:25:43.226009
1055	7	/api/products	GET	200	2025-10-28 16:25:43.227072
1056	7	/api/products/11	PUT	200	2025-10-28 16:25:51.067573
1057	7	/api/products	GET	200	2025-10-28 16:25:51.07579
1058	7	/api/products	GET	200	2025-10-28 16:32:01.659258
1059	7	/api/products	GET	200	2025-10-28 16:32:01.811116
1060	7	/api/products/11	PUT	200	2025-10-28 16:32:14.349915
1061	7	/api/products	GET	200	2025-10-28 16:32:14.358146
1062	7	/api/products	GET	200	2025-10-28 16:34:48.435597
1063	7	/api/products	GET	200	2025-10-28 16:34:48.472212
1064	7	/api/products/11	PUT	200	2025-10-28 16:35:01.592337
1065	7	/api/products	GET	200	2025-10-28 16:35:01.604384
1066	7	/api/products	GET	200	2025-10-28 16:36:28.256116
1067	7	/api/products	GET	200	2025-10-28 16:36:28.287702
1068	7	/api/products/11	PUT	200	2025-10-28 16:36:38.202846
1069	7	/api/products	GET	200	2025-10-28 16:36:38.210411
1070	7	/api/products/11	DELETE	200	2025-10-28 16:36:51.612762
1071	7	/api/products	GET	200	2025-10-28 16:36:51.620132
1072	7	/api/products	POST	201	2025-10-28 16:36:58.868771
1073	7	/api/products	GET	200	2025-10-28 16:36:58.874121
1074	7	/api/clients	GET	304	2025-10-28 16:37:10.799704
1075	7	/api/products	GET	304	2025-10-28 16:37:10.800365
1076	7	/api/orders	GET	200	2025-10-28 16:37:10.805847
1077	7	/api/clients	GET	304	2025-10-28 16:37:10.843946
1078	7	/api/products	GET	304	2025-10-28 16:37:10.846627
1079	7	/api/orders	GET	304	2025-10-28 16:37:10.850678
1080	7	/api/products	GET	304	2025-10-28 16:37:44.263597
1081	7	/api/products	GET	304	2025-10-28 16:37:44.29664
1082	7	/api/products	GET	304	2025-10-28 16:37:44.983651
1083	7	/api/clients	GET	304	2025-10-28 16:37:44.984589
1084	7	/api/clients	GET	304	2025-10-28 16:37:44.993375
1085	7	/api/orders	GET	304	2025-10-28 16:37:45.024813
1086	7	/api/products	GET	304	2025-10-28 16:37:45.027112
1087	7	/api/orders	GET	304	2025-10-28 16:37:45.029269
1088	7	/api/clients	GET	304	2025-10-28 16:37:45.748914
1089	7	/api/clients	GET	304	2025-10-28 16:37:45.753266
1090	7	/api/products	GET	304	2025-10-28 16:37:46.17932
1091	7	/api/products	GET	304	2025-10-28 16:37:46.183596
1092	7	/api/clients	GET	304	2025-10-28 16:37:47.113941
1093	7	/api/clients	GET	304	2025-10-28 16:37:47.116616
1094	7	/api/products	GET	304	2025-10-28 16:37:49.710495
1095	7	/api/products	GET	304	2025-10-28 16:37:49.715194
1096	7	/api/clients	GET	304	2025-10-28 16:38:09.259436
1097	7	/api/clients	GET	304	2025-10-28 16:38:09.291773
1098	7	/api/clients	GET	304	2025-10-28 16:39:05.123482
1099	7	/api/clients	GET	304	2025-10-28 16:39:05.155354
1100	7	/api/clients	GET	304	2025-10-28 16:41:23.843275
1101	7	/api/clients	GET	304	2025-10-28 16:41:23.877094
1102	7	/api/clients	GET	304	2025-10-28 16:41:32.793486
1103	7	/api/clients	GET	304	2025-10-28 16:41:32.79623
1104	7	/api/clients	GET	304	2025-10-28 16:41:35.799225
1105	7	/api/clients	GET	304	2025-10-28 16:41:35.801837
1106	7	/api/clients	GET	304	2025-10-28 16:41:37.805384
1107	7	/api/clients	GET	304	2025-10-28 16:41:37.80907
1108	7	/api/clients	GET	304	2025-10-28 16:41:44.839179
1109	7	/api/clients	GET	304	2025-10-28 16:41:44.842337
1110	7	/api/products	GET	304	2025-10-28 16:41:45.856288
1111	7	/api/products	GET	304	2025-10-28 16:41:45.862034
1112	7	/api/products	GET	200	2025-10-28 16:41:47.669216
1113	7	/api/products	GET	200	2025-10-28 16:41:47.670264
1114	7	/api/products	GET	200	2025-10-28 16:42:03.370793
1115	7	/api/products	GET	200	2025-10-28 16:42:03.371842
1116	7	/api/products	GET	200	2025-10-28 16:42:04.781913
1117	7	/api/products	GET	200	2025-10-28 16:42:04.782687
1118	7	/api/products	GET	200	2025-10-28 16:42:08.216745
1119	7	/api/products	GET	200	2025-10-28 16:42:08.217327
1120	7	/api/clients	GET	304	2025-10-28 16:42:09.980528
1121	7	/api/clients	GET	304	2025-10-28 16:42:09.984623
1122	7	/api/products	GET	304	2025-10-28 16:42:11.09853
1123	7	/api/products	GET	304	2025-10-28 16:42:11.102323
1124	7	/api/clients	GET	304	2025-10-28 16:42:12.398749
1125	7	/api/clients	GET	304	2025-10-28 16:42:12.401394
1126	7	/api/products	GET	304	2025-10-28 16:42:13.524833
1127	7	/api/products	GET	304	2025-10-28 16:42:13.529493
1128	7	/api/products	GET	304	2025-10-28 16:42:22.268832
1129	7	/api/products	GET	304	2025-10-28 16:42:22.272654
1130	7	/api/products	GET	304	2025-10-28 16:42:25.400707
1131	7	/api/products	GET	304	2025-10-28 16:42:25.405227
1132	7	/api/products	GET	304	2025-10-28 16:42:28.235563
1133	7	/api/products	GET	304	2025-10-28 16:42:28.240288
1134	7	/api/clients	GET	304	2025-10-28 16:42:36.011943
1135	7	/api/clients	GET	304	2025-10-28 16:42:36.014569
1136	7	/api/products	GET	304	2025-10-28 16:42:37.535684
1137	7	/api/products	GET	304	2025-10-28 16:42:37.540534
1138	7	/api/clients	GET	304	2025-10-28 16:42:38.622912
1139	7	/api/clients	GET	304	2025-10-28 16:42:38.625394
1140	7	/api/products	GET	304	2025-10-28 16:42:39.896417
1141	7	/api/products	GET	304	2025-10-28 16:42:39.900747
1142	7	/api/clients	GET	304	2025-10-28 16:42:40.436905
1143	7	/api/clients	GET	304	2025-10-28 16:42:40.439369
1144	7	/api/products	GET	304	2025-10-28 16:42:41.432766
1145	7	/api/products	GET	304	2025-10-28 16:42:41.436823
1146	7	/api/clients	GET	304	2025-10-28 16:42:42.458788
1147	7	/api/clients	GET	304	2025-10-28 16:42:42.46215
1148	7	/api/products	GET	304	2025-10-28 16:42:43.110934
1149	7	/api/products	GET	304	2025-10-28 16:42:43.115399
1150	7	/api/clients	GET	304	2025-10-28 16:42:43.59859
1151	7	/api/clients	GET	304	2025-10-28 16:42:43.600853
1152	7	/api/products	GET	304	2025-10-28 16:42:44.182395
1153	7	/api/products	GET	304	2025-10-28 16:42:44.186667
1154	7	/api/clients	GET	304	2025-10-28 16:42:46.34272
1155	7	/api/clients	GET	304	2025-10-28 16:42:46.345035
1156	7	/api/products	GET	304	2025-10-28 16:42:47.725988
1157	7	/api/products	GET	304	2025-10-28 16:42:47.730049
1158	7	/api/clients	GET	304	2025-10-28 16:42:48.399545
1159	7	/api/clients	GET	304	2025-10-28 16:42:48.402026
1160	7	/api/products	GET	304	2025-10-28 16:42:50.102916
1161	7	/api/products	GET	304	2025-10-28 16:42:50.107388
1162	7	/api/products	GET	304	2025-10-28 16:43:34.922827
1163	7	/api/products	GET	304	2025-10-28 16:43:34.960843
1164	7	/api/clients	GET	304	2025-10-28 16:43:36.555943
1165	7	/api/clients	GET	304	2025-10-28 16:43:36.561082
1166	7	/api/products	GET	304	2025-10-28 16:43:37.847664
1167	7	/api/products	GET	304	2025-10-28 16:43:37.852559
1168	7	/api/clients	GET	304	2025-10-28 16:43:38.264575
1169	7	/api/products	GET	304	2025-10-28 16:43:38.268965
1170	7	/api/products	GET	304	2025-10-28 16:43:38.277097
1171	7	/api/clients	GET	304	2025-10-28 16:43:38.30926
1172	7	/api/orders	GET	304	2025-10-28 16:43:38.309974
1173	7	/api/orders	GET	304	2025-10-28 16:43:38.314535
1174	7	/api/clients	GET	304	2025-10-28 16:43:41.624477
1175	7	/api/clients	GET	304	2025-10-28 16:43:41.627482
1176	7	/api/clients	GET	304	2025-10-28 16:43:43.305307
1177	7	/api/clients	GET	304	2025-10-28 16:43:43.308027
1178	7	/api/products	GET	304	2025-10-28 16:43:43.840464
1179	7	/api/products	GET	304	2025-10-28 16:43:43.845511
1180	7	/api/clients	GET	304	2025-10-28 16:43:44.904604
1181	7	/api/products	GET	304	2025-10-28 16:43:44.905284
1182	7	/api/clients	GET	304	2025-10-28 16:43:44.913565
1183	7	/api/orders	GET	304	2025-10-28 16:43:44.914346
1184	7	/api/orders	GET	304	2025-10-28 16:43:44.918601
1185	7	/api/products	GET	304	2025-10-28 16:43:44.947556
1186	7	/api/products	GET	304	2025-10-28 16:43:45.211983
1187	7	/api/products	GET	304	2025-10-28 16:43:45.217046
1188	7	/api/clients	GET	304	2025-10-28 16:43:45.572781
1189	7	/api/clients	GET	304	2025-10-28 16:43:45.576547
1190	7	/api/products	GET	304	2025-10-28 16:43:46.808099
1191	7	/api/products	GET	304	2025-10-28 16:43:46.812972
1192	7	/api/clients	GET	304	2025-10-28 16:43:47.291763
1193	7	/api/clients	GET	304	2025-10-28 16:43:47.293816
1194	7	/api/products	GET	304	2025-10-28 16:43:47.632003
1195	7	/api/products	GET	304	2025-10-28 16:43:47.635734
1196	7	/api/clients	GET	304	2025-10-28 16:43:48.932515
1197	7	/api/clients	GET	304	2025-10-28 16:43:48.935082
1198	7	/api/products	GET	304	2025-10-28 16:43:50.728258
1199	7	/api/products	GET	304	2025-10-28 16:43:50.732197
1200	7	/api/clients	GET	304	2025-10-28 16:43:52.06682
1201	7	/api/clients	GET	304	2025-10-28 16:43:52.069551
1202	7	/api/products	GET	304	2025-10-28 16:43:53.259393
1203	7	/api/products	GET	304	2025-10-28 16:43:53.263275
1204	7	/api/products	GET	304	2025-10-28 16:43:53.848367
1205	7	/api/clients	GET	304	2025-10-28 16:43:53.85049
1206	7	/api/orders	GET	304	2025-10-28 16:43:53.854322
1207	7	/api/products	GET	304	2025-10-28 16:43:53.857325
1208	7	/api/clients	GET	304	2025-10-28 16:43:53.860667
1209	7	/api/orders	GET	304	2025-10-28 16:43:53.863071
1210	\N	/api/auth/login	POST	401	2025-10-28 16:46:26.508405
1211	\N	/api/auth/login	POST	401	2025-10-28 16:46:30.38374
1212	\N	/api/auth/login	POST	200	2025-10-28 16:46:42.722198
1213	7	/api/clients	GET	304	2025-10-28 16:46:47.151047
1214	7	/api/clients	GET	304	2025-10-28 16:46:47.185888
1215	7	/api/products	GET	304	2025-10-28 16:46:48.258974
1216	7	/api/products	GET	304	2025-10-28 16:46:48.26428
1217	7	/api/clients	GET	304	2025-10-28 16:46:49.018198
1229	7	/api/products	GET	304	2025-10-28 16:46:50.510729
1232	7	/api/users	GET	304	2025-10-28 16:46:50.927357
1233	7	/api/products	GET	304	2025-10-28 16:46:52.879257
1352	7	/api/orders	GET	200	2025-10-28 16:48:27.249452
1360	7	/api/orders	GET	200	2025-10-28 16:49:51.292123
1369	7	/api/products	GET	200	2025-10-28 16:49:54.305184
1372	7	/api/products	GET	200	2025-10-28 16:50:00.230299
1381	7	/api/products	GET	200	2025-10-28 16:50:00.837932
1386	7	/api/clients	GET	304	2025-10-28 16:51:41.916679
1391	7	/api/orders	GET	304	2025-10-28 16:51:42.34393
1395	7	/api/clients	GET	200	2025-10-28 16:51:43.19437
1406	7	/api/orders	GET	200	2025-10-28 16:51:55.76772
1464	7	/api/products	GET	304	2025-10-28 16:54:00.235496
1465	7	/api/products	GET	304	2025-10-28 16:54:01.802103
1508	7	/api/orders	GET	304	2025-10-28 16:55:58.791477
1509	7	/api/users	GET	304	2025-10-28 16:55:59.444007
1512	7	/api/products	GET	304	2025-10-28 16:56:00.668246
1538	7	/api/orders	GET	304	2025-10-28 16:57:55.037159
1539	7	/api/products	GET	304	2025-10-28 16:57:55.703396
1542	7	/api/clients	GET	304	2025-10-28 16:57:56.68769
1543	7	/api/clients	GET	304	2025-10-28 16:57:58.73092
1546	7	/api/products	GET	304	2025-10-28 16:57:59.209946
1547	7	/api/products	GET	304	2025-10-28 16:57:59.803156
1564	7	/api/orders	GET	304	2025-10-28 16:58:01.988296
1600	7	/api/orders	GET	304	2025-10-28 16:59:35.830548
1601	7	/api/products	GET	304	2025-10-28 16:59:36.023012
1604	7	/api/clients	GET	304	2025-10-28 16:59:37.026887
1605	7	/api/products	GET	304	2025-10-28 16:59:37.486971
1608	7	/api/products	GET	304	2025-10-28 16:59:38.336719
1612	7	/api/orders	GET	304	2025-10-28 16:59:38.346221
1613	7	/api/products	GET	304	2025-10-28 16:59:39.218756
1616	7	/api/products	GET	304	2025-10-28 16:59:39.93124
1626	7	/api/products	GET	304	2025-10-28 16:59:41.94584
1658	7	/api/orders	GET	304	2025-10-28 17:00:45.133224
1659	7	/api/products	GET	304	2025-10-28 17:00:48.176351
1662	7	/api/clients	GET	304	2025-10-28 17:00:48.982379
1663	7	/api/clients	GET	304	2025-10-28 17:00:50.081806
1666	7	/api/products	GET	304	2025-10-28 17:00:50.660016
1667	7	/api/clients	GET	304	2025-10-28 17:00:51.197491
1682	7	/api/clients	GET	304	2025-10-28 17:01:52.190371
1687	7	/api/orders	GET	304	2025-10-28 17:01:56.232661
1694	7	/api/clients	GET	304	2025-10-28 17:02:02.017149
1699	7	/api/orders	GET	304	2025-10-28 17:02:08.003098
1746	7	/api/products	GET	304	2025-10-28 17:02:37.362139
1747	7	/api/products	GET	304	2025-10-28 17:02:37.885248
1750	7	/api/users	GET	304	2025-10-28 17:02:38.445094
1751	7	/api/clients	GET	304	2025-10-28 17:02:38.825496
1769	7	/api/products	GET	304	2025-10-28 17:02:43.975817
1772	7	/api/users	GET	304	2025-10-28 17:02:47.153187
1773	7	/api/clients	GET	304	2025-10-28 17:02:49.526065
1777	7	/api/products	GET	304	2025-10-28 17:02:49.53507
1780	7	/api/products	GET	304	2025-10-28 17:02:57.056738
1781	7	/api/clients	GET	304	2025-10-28 17:02:57.712647
1794	7	/api/orders	GET	304	2025-10-28 17:09:51.761407
1815	7	/api/orders	GET	304	2025-10-28 17:11:44.141332
1848	\N	/api/auth/login	POST	200	2025-10-28 17:34:11.630637
1862	7	/api/clients	GET	304	2025-10-28 18:11:21.116304
1865	7	/api/clients	GET	304	2025-10-28 18:11:30.849089
1866	7	/api/clients	GET	304	2025-10-28 18:11:32.907391
1869	7	/api/clients	GET	304	2025-10-28 18:11:42.013007
1870	7	/api/clients	GET	304	2025-10-28 18:11:47.186709
1892	7	/api/clients	GET	304	2025-10-28 18:15:28.19471
1895	7	/api/clients	GET	304	2025-10-28 18:15:29.790182
1922	7	/api/products	GET	304	2025-10-28 18:17:54.453156
1925	7	/api/clients	GET	304	2025-10-28 18:17:55.036606
1926	7	/api/clients	GET	304	2025-10-28 18:18:02.244173
1948	7	/api/clients	GET	200	2025-10-28 18:21:41.196267
1960	7	/api/clients	GET	304	2025-10-28 18:24:59.637384
1963	7	/api/clients	GET	200	2025-10-28 18:25:00.406281
1977	7	/api/products	GET	304	2025-10-28 18:27:33.871153
1978	7	/api/products	GET	304	2025-10-28 18:27:42.382727
1981	7	/api/products	GET	200	2025-10-28 18:27:43.844676
1982	7	/api/products	GET	200	2025-10-28 18:27:44.617782
1994	7	/api/clients	GET	304	2025-10-28 18:30:16.527759
2009	7	/api/users	GET	304	2025-10-28 18:33:01.015058
2018	7	/api/products	GET	304	2025-10-28 18:33:28.648765
2025	7	/api/orders	GET	304	2025-10-28 18:34:49.242712
2034	7	/api/orders	GET	304	2025-10-28 18:35:34.69857
2042	7	/api/products	GET	200	2025-10-28 18:35:35.769514
2048	7	/api/orders	GET	304	2025-10-28 18:36:13.602449
2057	7	/api/clients	GET	304	2025-10-28 18:36:16.804559
2067	7	/api/orders	GET	304	2025-10-28 18:36:20.293712
2082	7	/api/orders	GET	200	2025-10-28 18:36:38.329786
2085	7	/api/users	GET	200	2025-10-28 18:36:42.060135
2092	7	/api/products	GET	304	2025-10-28 18:43:04.387318
2095	7	/api/clients	GET	304	2025-10-28 18:43:05.051835
2096	7	/api/products	GET	304	2025-10-28 18:43:05.487782
2099	7	/api/clients	GET	304	2025-10-28 18:43:05.852612
2100	7	/api/clients	GET	304	2025-10-28 18:43:08.344782
2103	7	/api/products	GET	304	2025-10-28 18:43:08.732573
2104	7	/api/clients	GET	304	2025-10-28 18:43:09.348247
2107	7	/api/products	GET	304	2025-10-28 18:43:09.391085
2109	7	/api/orders	GET	304	2025-10-28 18:43:09.499003
2110	7	/api/users	GET	304	2025-10-28 18:43:09.808485
2113	7	/api/clients	GET	304	2025-10-28 18:43:10.923038
2116	7	/api/clients	GET	304	2025-10-28 18:43:10.931043
2120	7	/api/products	GET	304	2025-10-28 18:44:15.201329
2123	7	/api/products	GET	304	2025-10-28 18:44:28.947267
2124	7	/api/products	GET	304	2025-10-28 18:44:32.815557
2127	7	/api/products	GET	304	2025-10-28 18:44:39.826718
2128	7	/api/products	GET	304	2025-10-28 18:44:41.181382
2131	7	/api/products	GET	200	2025-10-28 18:44:42.753338
2132	7	/api/products	GET	200	2025-10-28 18:44:47.243906
2136	7	/api/products	GET	304	2025-10-28 18:46:32.848293
2139	7	/api/products	GET	200	2025-10-28 18:46:34.986846
2140	7	/api/products	GET	304	2025-10-28 18:46:35.332696
2142	7	/api/orders	GET	304	2025-10-28 18:46:35.372549
2145	7	/api/products	GET	304	2025-10-28 18:46:35.379328
2146	7	/api/clients	GET	200	2025-10-28 18:46:36.399468
2149	7	/api/clients	GET	200	2025-10-28 18:46:36.406685
2150	7	/api/products	GET	200	2025-10-28 18:46:36.407111
2151	7	/api/orders	GET	200	2025-10-28 18:46:36.440021
2152	7	/api/clients	GET	200	2025-10-28 18:46:39.870768
2153	7	/api/products	GET	200	2025-10-28 18:46:39.87624
2154	7	/api/orders	GET	200	2025-10-28 18:46:39.881775
2155	7	/api/clients	GET	200	2025-10-28 18:46:39.882907
2156	7	/api/products	GET	200	2025-10-28 18:46:39.883764
2157	7	/api/orders	GET	200	2025-10-28 18:46:39.884787
2158	7	/api/clients	GET	304	2025-10-28 18:48:24.205067
1218	7	/api/products	GET	304	2025-10-28 16:46:49.018947
1219	7	/api/clients	GET	304	2025-10-28 16:46:49.066062
1220	7	/api/products	GET	304	2025-10-28 16:46:49.067298
1221	7	/api/orders	GET	304	2025-10-28 16:46:49.067999
1222	7	/api/orders	GET	304	2025-10-28 16:46:49.07241
1223	7	/api/users	GET	304	2025-10-28 16:46:49.903597
1224	7	/api/users	GET	304	2025-10-28 16:46:49.908416
1225	7	/api/clients	GET	304	2025-10-28 16:46:50.497778
1226	7	/api/products	GET	304	2025-10-28 16:46:50.504873
1227	7	/api/clients	GET	304	2025-10-28 16:46:50.505421
1228	7	/api/orders	GET	304	2025-10-28 16:46:50.510024
1230	7	/api/orders	GET	304	2025-10-28 16:46:50.515497
1231	7	/api/users	GET	304	2025-10-28 16:46:50.922893
1234	7	/api/orders	GET	304	2025-10-28 16:46:52.879987
1235	7	/api/clients	GET	304	2025-10-28 16:46:52.880602
1236	7	/api/products	GET	304	2025-10-28 16:46:52.887616
1237	7	/api/orders	GET	304	2025-10-28 16:46:52.888259
1238	7	/api/clients	GET	304	2025-10-28 16:46:52.919115
1239	7	/api/products	GET	304	2025-10-28 16:46:53.19819
1240	7	/api/products	GET	304	2025-10-28 16:46:53.2038
1241	7	/api/clients	GET	304	2025-10-28 16:46:54.966959
1242	7	/api/clients	GET	304	2025-10-28 16:46:54.969188
1243	7	/api/products	GET	304	2025-10-28 16:46:55.942241
1244	7	/api/products	GET	304	2025-10-28 16:46:55.946953
1245	7	/api/clients	GET	304	2025-10-28 16:46:56.333949
1246	7	/api/products	GET	304	2025-10-28 16:46:56.3353
1247	7	/api/clients	GET	304	2025-10-28 16:46:56.342317
1248	7	/api/orders	GET	304	2025-10-28 16:46:56.343501
1249	7	/api/products	GET	304	2025-10-28 16:46:56.344317
1250	7	/api/orders	GET	304	2025-10-28 16:46:56.347416
1251	7	/api/users	GET	304	2025-10-28 16:46:57.746859
1252	7	/api/users	GET	304	2025-10-28 16:46:57.752959
1253	7	/api/users	GET	304	2025-10-28 16:47:15.023762
1254	7	/api/users	GET	304	2025-10-28 16:47:15.059043
1255	7	/api/users	GET	304	2025-10-28 16:47:28.819458
1256	7	/api/users	GET	304	2025-10-28 16:47:28.853013
1257	7	/api/users	GET	304	2025-10-28 16:47:30.795117
1258	7	/api/users	GET	304	2025-10-28 16:47:30.799353
1259	7	/api/users	GET	304	2025-10-28 16:47:38.806449
1260	7	/api/users	GET	304	2025-10-28 16:47:38.810363
1261	7	/api/users	GET	304	2025-10-28 16:47:39.607035
1262	7	/api/users	GET	304	2025-10-28 16:47:39.611997
1263	7	/api/clients	GET	304	2025-10-28 16:47:42.038792
1264	7	/api/products	GET	304	2025-10-28 16:47:42.040342
1265	7	/api/orders	GET	304	2025-10-28 16:47:42.085405
1266	7	/api/clients	GET	304	2025-10-28 16:47:42.08972
1268	7	/api/orders	GET	304	2025-10-28 16:47:42.091909
1267	7	/api/products	GET	304	2025-10-28 16:47:42.091121
1269	7	/api/clients	GET	200	2025-10-28 16:47:43.418019
1270	7	/api/products	GET	200	2025-10-28 16:47:43.418418
1271	7	/api/clients	GET	200	2025-10-28 16:47:43.418916
1272	7	/api/orders	GET	200	2025-10-28 16:47:43.419553
1273	7	/api/products	GET	200	2025-10-28 16:47:43.420405
1274	7	/api/orders	GET	200	2025-10-28 16:47:43.453735
1353	7	/api/clients	GET	200	2025-10-28 16:49:21.161459
1361	7	/api/products	GET	200	2025-10-28 16:49:51.296324
1367	7	/api/clients	GET	200	2025-10-28 16:49:54.303471
1374	7	/api/orders	GET	200	2025-10-28 16:50:00.231493
1379	7	/api/orders	GET	200	2025-10-28 16:50:00.836591
1387	7	/api/products	GET	304	2025-10-28 16:51:41.920056
1390	7	/api/products	GET	304	2025-10-28 16:51:42.338286
1397	7	/api/clients	GET	200	2025-10-28 16:51:43.203436
1407	7	/api/clients	GET	304	2025-10-28 16:52:14.592514
1410	7	/api/products	GET	304	2025-10-28 16:52:14.603609
1426	7	/api/orders	GET	304	2025-10-28 16:52:21.64626
1435	7	/api/products	GET	304	2025-10-28 16:52:23.160783
1449	7	/api/clients	GET	304	2025-10-28 16:52:30.474815
1458	7	/api/products	GET	304	2025-10-28 16:52:32.555106
1468	7	/api/products	GET	304	2025-10-28 16:54:01.846299
1470	7	/api/orders	GET	304	2025-10-28 16:54:01.852626
1471	7	/api/users	GET	304	2025-10-28 16:54:04.642347
1474	7	/api/clients	GET	304	2025-10-28 16:54:05.681812
1477	7	/api/orders	GET	304	2025-10-28 16:54:05.69309
1480	7	/api/products	GET	304	2025-10-28 16:54:06.105241
1481	7	/api/clients	GET	304	2025-10-28 16:54:06.690927
1484	7	/api/users	GET	304	2025-10-28 16:54:07.432761
1519	7	/api/users	GET	304	2025-10-28 16:57:31.201727
1569	7	/api/clients	GET	304	2025-10-28 16:59:06.261967
1572	7	/api/clients	GET	304	2025-10-28 16:59:07.767138
1633	7	/api/clients	GET	304	2025-10-28 17:00:15.922738
1673	7	/api/products	GET	304	2025-10-28 17:01:35.385221
1675	7	/api/orders	GET	304	2025-10-28 17:01:35.394358
1683	7	/api/products	GET	304	2025-10-28 17:01:52.197752
1686	7	/api/products	GET	304	2025-10-28 17:01:56.226868
1690	7	/api/orders	GET	304	2025-10-28 17:01:56.23871
1691	7	/api/clients	GET	304	2025-10-28 17:02:02.009947
1695	7	/api/products	GET	304	2025-10-28 17:02:02.017732
1698	7	/api/products	GET	304	2025-10-28 17:02:08.002522
1702	7	/api/orders	GET	304	2025-10-28 17:02:08.011237
1703	7	/api/users	GET	304	2025-10-28 17:02:14.374877
1706	7	/api/products	GET	304	2025-10-28 17:02:18.867442
1707	7	/api/products	GET	304	2025-10-28 17:02:21.639204
1783	7	/api/clients	GET	304	2025-10-28 17:04:37.783262
1797	7	/api/clients	GET	304	2025-10-28 17:11:28.459737
1800	7	/api/products	GET	304	2025-10-28 17:11:28.986378
1801	7	/api/clients	GET	304	2025-10-28 17:11:30.158812
1804	7	/api/products	GET	304	2025-10-28 17:11:31.32522
1805	7	/api/clients	GET	304	2025-10-28 17:11:31.94843
1816	7	/api/clients	GET	304	2025-10-28 17:11:44.179406
1849	\N	/api/auth/login	POST	200	2025-10-28 17:38:22.495202
1863	7	/api/clients	GET	304	2025-10-28 18:11:21.147891
1864	7	/api/clients	GET	304	2025-10-28 18:11:30.846474
1867	7	/api/clients	GET	304	2025-10-28 18:11:32.910887
1868	7	/api/clients	GET	304	2025-10-28 18:11:42.009818
1871	7	/api/clients	GET	304	2025-10-28 18:11:47.189056
1893	7	/api/clients	GET	304	2025-10-28 18:15:28.229696
1894	7	/api/clients	GET	304	2025-10-28 18:15:29.787463
1923	7	/api/products	GET	304	2025-10-28 18:17:54.487009
1924	7	/api/clients	GET	304	2025-10-28 18:17:55.032368
1927	7	/api/clients	GET	304	2025-10-28 18:18:02.248872
1949	7	/api/orders	GET	200	2025-10-28 18:21:41.197008
1961	7	/api/clients	GET	304	2025-10-28 18:24:59.782174
1962	7	/api/clients	GET	200	2025-10-28 18:25:00.405711
1984	7	/api/products/8	PUT	200	2025-10-28 18:28:08.667972
1995	7	/api/clients	GET	304	2025-10-28 18:30:16.560245
2010	7	/api/users	GET	304	2025-10-28 18:33:12.061484
2013	7	/api/users	GET	200	2025-10-28 18:33:13.272483
2019	7	/api/orders	GET	304	2025-10-28 18:33:28.652197
2026	7	/api/products	GET	304	2025-10-28 18:35:15.879978
2028	7	/api/orders	GET	304	2025-10-28 18:35:15.889013
2159	7	/api/products	GET	304	2025-10-28 18:48:24.207919
2160	7	/api/orders	GET	304	2025-10-28 18:48:24.212586
2162	7	/api/orders	GET	304	2025-10-28 18:48:24.217527
2165	7	/api/products	GET	304	2025-10-28 18:48:29.841502
2167	7	/api/clients	GET	304	2025-10-28 18:48:29.84626
2169	7	/api/orders	GET	304	2025-10-28 18:48:29.849078
2170	7	/api/users	GET	304	2025-10-28 18:48:32.114821
2173	7	/api/users	GET	200	2025-10-28 18:48:32.944696
2174	7	/api/users	GET	200	2025-10-28 18:48:36.576753
4059	7	/api/auth/me	GET	304	2025-11-10 18:18:19.021583
4061	7	/api/products	GET	304	2025-11-10 18:18:19.052659
4064	7	/api/auth/me	GET	304	2025-11-10 18:18:23.741551
4065	7	/api/products	GET	304	2025-11-10 18:18:23.755649
4068	7	/api/auth/me	GET	304	2025-11-10 18:18:25.704491
4069	7	/api/products	GET	304	2025-11-10 18:18:25.718949
4072	7	/api/auth/me	GET	304	2025-11-10 18:18:31.677682
4073	7	/api/products	GET	304	2025-11-10 18:18:31.693325
4134	7	/api/orders	GET	304	2025-11-10 18:24:27.080162
4141	7	/api/orders	GET	304	2025-11-10 18:24:29.609878
4275	7	/api/products	GET	304	2025-11-10 18:32:13.245235
4413	7	/api/clients	GET	304	2025-11-10 18:41:15.616832
4417	7	/api/products	GET	304	2025-11-10 18:41:15.625738
4425	7	/api/clients	GET	304	2025-11-10 18:41:16.831899
4566	7	/api/products	GET	304	2025-11-10 18:44:58.395097
4576	7	/api/clients	GET	304	2025-11-10 18:45:03.35415
4586	7	/api/orders	GET	304	2025-11-10 18:45:09.404216
4663	7	/api/auth/me	GET	200	2025-11-11 16:29:11.073354
4740	7	/api/auth/me	GET	304	2025-11-11 16:55:33.61018
4791	\N	/api/auth/me	GET	401	2025-11-12 15:29:50.691307
4807	\N	/api/auth/me	GET	401	2026-02-25 17:31:27.525124
4892	7	/api/products	GET	304	2026-03-12 17:14:56.284626
4894	7	/api/users	GET	304	2026-03-12 17:14:57.73105
4895	7	/api/clients	GET	304	2026-03-12 17:15:00.82938
4898	7	/api/products	GET	304	2026-03-12 17:15:01.426032
4899	7	/api/products	GET	304	2026-03-12 17:15:01.873388
4975	\N	/api/auth/me	GET	401	2026-03-12 18:48:41.82827
4976	\N	/api/auth/me	GET	401	2026-03-12 18:48:41.831126
5071	7	/api/clients	GET	304	2026-03-12 19:02:48.672977
5145	7	/api/products	GET	304	2026-03-12 20:59:44.502389
5211	7	/api/products	GET	304	2026-03-12 21:14:19.940653
5212	7	/api/users	GET	304	2026-03-12 21:14:21.673936
5215	7	/api/clients	GET	304	2026-03-12 21:14:24.824801
5344	7	/api/clients	GET	304	2026-03-12 21:26:10.412901
5454	7	/api/clients	GET	304	2026-03-13 13:45:07.665547
5455	7	/api/clients	GET	304	2026-03-13 13:45:10.785212
5458	7	/api/products	GET	304	2026-03-13 13:45:13.496968
5459	7	/api/products	GET	304	2026-03-13 13:45:15.60874
5461	7	/api/clients	GET	304	2026-03-13 13:45:15.616967
5469	7	/api/orders	GET	304	2026-03-13 13:45:18.322563
5549	7	/api/clients	GET	304	2026-03-13 13:55:00.232431
5552	7	/api/products	GET	304	2026-03-13 13:55:01.517676
5618	7	/api/auth/me	GET	200	2026-03-13 14:18:05.878356
5663	7	/api/products	GET	200	2026-03-13 14:26:38.248319
5781	7	/api/auth/me	GET	200	2026-03-17 18:19:45.474418
5784	7	/api/clients	GET	200	2026-03-17 18:19:48.586882
5785	7	/api/products	GET	200	2026-03-17 18:19:50.026549
5788	7	/api/products	GET	200	2026-03-17 18:19:50.883885
5803	7	/api/orders	GET	200	2026-03-17 18:19:55.310988
5806	7	/api/users	GET	200	2026-03-17 18:19:55.823985
5881	7	/api/clients	GET	200	2026-03-17 21:05:19.182575
5882	7	/api/users	GET	200	2026-03-17 21:05:19.70406
5885	7	/api/summary	GET	200	2026-03-17 21:05:20.582918
5973	7	/api/clients	GET	200	2026-03-17 21:45:16.599473
5981	7	/api/orders	GET	200	2026-03-17 21:45:23.584422
5990	7	/api/orders	GET	200	2026-03-17 21:45:29.123636
6083	7	/api/summary	GET	200	2026-03-18 15:31:50.57646
6084	7	/api/clients	GET	200	2026-03-18 15:31:57.975498
6087	7	/api/products	GET	200	2026-03-18 15:31:58.54409
6088	7	/api/clients	GET	200	2026-03-18 15:31:59.275001
6090	7	/api/products	GET	200	2026-03-18 15:31:59.280477
6156	7	/api/users	GET	200	2026-03-18 15:57:51.81963
6157	7	/api/suppliers	GET	200	2026-03-18 15:57:53.321719
6221	7	/api/orders	GET	200	2026-03-18 16:16:06.154072
6224	7	/api/summary	GET	200	2026-03-18 16:16:12.954521
6225	7	/api/clients	GET	200	2026-03-18 16:16:19.577931
6286	7	/api/orders	GET	200	2026-03-18 16:21:36.76703
6363	7	/api/auth/me	GET	200	2026-03-18 16:35:39.768305
6364	7	/api/products	GET	200	2026-03-18 16:35:39.786474
6448	7	/api/auth/me	GET	200	2026-03-18 17:12:16.425776
6450	7	/api/products	GET	200	2026-03-18 17:12:16.43799
6452	7	/api/financial/categories	GET	200	2026-03-18 17:12:17.776132
6539	7	/api/auth/me	GET	200	2026-03-18 17:36:51.670174
6545	7	/api/financial/categories	GET	200	2026-03-18 17:36:59.300708
6611	\N	/api/users	GET	401	2026-03-18 18:00:58.108353
6615	7	/api/summary	GET	200	2026-03-18 18:01:05.854407
6616	7	/api/clients	GET	200	2026-03-18 18:01:09.583823
6617	7	/api/clients	GET	200	2026-03-18 18:01:09.599006
6618	7	/api/products	GET	200	2026-03-18 18:01:11.601841
6621	7	/api/products	GET	200	2026-03-18 18:01:12.904233
6632	7	/api/financial?from=2026-03-01&to=2026-03-18	GET	200	2026-03-18 18:01:15.404184
6635	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-18	GET	200	2026-03-18 18:01:15.450798
6640	7	/api/financial/categories	GET	200	2026-03-18 18:01:17.448092
6643	7	/api/suppliers	GET	200	2026-03-18 18:01:21.395557
6644	7	/api/products	GET	200	2026-03-18 18:01:29.085024
6647	7	/api/summary	GET	200	2026-03-18 18:01:37.023743
6690	7	/api/summary	GET	200	2026-03-18 18:17:03.009151
6691	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:17:03.015888
6761	7	/api/summary	GET	200	2026-03-18 21:20:56.26404
6847	7	/api/auth/me	GET	200	2026-03-18 21:38:32.006482
6849	7	/api/products	GET	200	2026-03-18 21:38:32.163838
6910	7	/api/financial/categories	GET	200	2026-03-18 21:41:51.483523
6914	7	/api/products	GET	200	2026-03-18 21:41:53.236642
6917	7	/api/purchase-orders	GET	200	2026-03-18 21:41:53.247424
6921	7	/api/financial/categories	GET	200	2026-03-18 21:41:55.50977
6928	7	/api/financial?status=vencido	GET	200	2026-03-18 21:41:58.04037
6935	7	/api/financial?	GET	200	2026-03-18 21:41:58.088163
6938	7	/api/products	GET	200	2026-03-18 21:42:06.479955
6939	7	/api/purchase-orders	GET	200	2026-03-18 21:42:13.301789
7027	7	/api/financial/categories	GET	200	2026-03-18 21:48:00.072584
7088	7	/api/auth/me	GET	200	2026-03-18 21:51:41.995167
7137	7	/api/financial?	GET	200	2026-03-19 15:44:23.432418
7139	7	/api/summary	GET	200	2026-03-19 15:44:31.908708
7142	7	/api/summary	GET	200	2026-03-19 15:44:38.663969
7192	7	/api/financial/17	PUT	200	2026-03-19 15:59:45.965943
7193	7	/api/financial?	GET	200	2026-03-19 15:59:45.974326
7194	7	/api/financial/17	PUT	200	2026-03-19 15:59:50.812434
2161	7	/api/products	GET	304	2025-10-28 18:48:24.215013
2163	7	/api/clients	GET	304	2025-10-28 18:48:24.371573
2164	7	/api/clients	GET	304	2025-10-28 18:48:29.841018
2166	7	/api/orders	GET	304	2025-10-28 18:48:29.845858
2168	7	/api/products	GET	304	2025-10-28 18:48:29.848265
2171	7	/api/users	GET	304	2025-10-28 18:48:32.120297
2172	7	/api/users	GET	200	2025-10-28 18:48:32.943975
2175	7	/api/users	GET	200	2025-10-28 18:48:36.577762
2176	7	/api/users	GET	304	2025-10-28 18:51:19.227881
2177	7	/api/users	GET	304	2025-10-28 18:51:19.262371
2178	7	/api/users	GET	304	2025-10-28 18:51:20.788434
2179	7	/api/users	GET	304	2025-10-28 18:51:20.792927
2180	7	/api/users	GET	304	2025-10-28 18:51:29.827193
2181	7	/api/users	GET	304	2025-10-28 18:51:29.83101
2182	7	/api/users	GET	304	2025-10-28 18:51:37.814988
2183	7	/api/users	GET	304	2025-10-28 18:51:37.81812
2184	7	/api/users	GET	304	2025-10-28 18:51:40.818014
2185	7	/api/users	GET	304	2025-10-28 18:51:40.822016
2186	7	/api/users	GET	304	2025-10-28 18:51:48.824778
2187	7	/api/users	GET	304	2025-10-28 18:51:48.828365
2188	7	/api/users	GET	304	2025-10-28 18:51:56.851621
2189	7	/api/users	GET	304	2025-10-28 18:51:56.855569
2190	7	/api/users	GET	200	2025-10-28 18:51:58.563141
2191	7	/api/users	GET	200	2025-10-28 18:51:58.563727
2192	7	/api/users	GET	200	2025-10-28 18:51:59.30335
2193	7	/api/users	GET	200	2025-10-28 18:51:59.305105
2194	7	/api/clients	GET	304	2025-10-28 18:52:00.535215
2195	7	/api/products	GET	304	2025-10-28 18:52:00.535658
2196	7	/api/orders	GET	304	2025-10-28 18:52:00.574471
2197	7	/api/orders	GET	304	2025-10-28 18:52:00.579557
2198	7	/api/clients	GET	304	2025-10-28 18:52:00.580361
2199	7	/api/products	GET	304	2025-10-28 18:52:00.581419
2200	7	/api/products	GET	304	2025-10-28 18:52:01.340862
2201	7	/api/products	GET	304	2025-10-28 18:52:01.345958
2202	7	/api/clients	GET	304	2025-10-28 18:52:01.800618
2203	7	/api/clients	GET	304	2025-10-28 18:52:01.803782
2204	7	/api/products	GET	304	2025-10-28 18:52:02.132295
2205	7	/api/products	GET	304	2025-10-28 18:52:02.136003
2206	7	/api/clients	GET	304	2025-10-28 18:52:02.50612
2207	7	/api/products	GET	304	2025-10-28 18:52:02.506634
2208	7	/api/orders	GET	304	2025-10-28 18:52:02.507315
2209	7	/api/clients	GET	304	2025-10-28 18:52:02.514322
2210	7	/api/products	GET	304	2025-10-28 18:52:02.515773
2211	7	/api/orders	GET	304	2025-10-28 18:52:02.547096
2212	7	/api/users	GET	304	2025-10-28 18:52:02.918208
2213	7	/api/users	GET	304	2025-10-28 18:52:02.923018
2214	7	/api/users	GET	304	2025-10-28 18:52:06.781398
2215	7	/api/users	GET	304	2025-10-28 18:52:06.785674
2216	7	/api/users	GET	304	2025-10-28 18:52:09.557373
2217	7	/api/users	GET	304	2025-10-28 18:52:09.561255
2218	7	/api/users	GET	200	2025-10-28 18:52:13.610709
2219	7	/api/users	GET	200	2025-10-28 18:52:13.611243
2220	7	/api/users	GET	200	2025-10-28 18:52:14.423859
2221	7	/api/users	GET	200	2025-10-28 18:52:14.424396
2222	7	/api/users	GET	304	2025-10-28 18:52:18.47685
2223	7	/api/users	GET	304	2025-10-28 18:52:18.4823
2224	7	/api/products	GET	304	2025-10-28 18:52:21.67148
2225	7	/api/products	GET	304	2025-10-28 18:52:21.674837
2226	7	/api/products	GET	304	2025-10-28 18:52:22.103784
2227	7	/api/clients	GET	304	2025-10-28 18:52:22.105677
2228	7	/api/products	GET	304	2025-10-28 18:52:22.147311
2229	7	/api/orders	GET	304	2025-10-28 18:52:22.149023
2230	7	/api/clients	GET	304	2025-10-28 18:52:22.149683
2231	7	/api/orders	GET	304	2025-10-28 18:52:22.154197
2232	7	/api/clients	GET	304	2025-10-28 18:52:25.634661
2233	7	/api/products	GET	304	2025-10-28 18:52:25.635111
2234	7	/api/orders	GET	304	2025-10-28 18:52:25.635753
2235	7	/api/clients	GET	304	2025-10-28 18:52:25.642968
2236	7	/api/products	GET	304	2025-10-28 18:52:25.643513
2237	7	/api/orders	GET	304	2025-10-28 18:52:25.645437
2238	7	/api/products	GET	304	2025-10-28 18:52:26.874622
2239	7	/api/products	GET	304	2025-10-28 18:52:26.87789
2240	7	/api/clients	GET	304	2025-10-28 18:52:28.287359
2241	7	/api/clients	GET	304	2025-10-28 18:52:28.292172
2242	7	/api/clients	GET	304	2025-10-28 18:52:30.531553
2243	7	/api/products	GET	304	2025-10-28 18:52:30.531886
2244	7	/api/clients	GET	304	2025-10-28 18:52:30.536406
2245	7	/api/products	GET	304	2025-10-28 18:52:30.539059
2246	7	/api/orders	GET	304	2025-10-28 18:52:30.54241
2247	7	/api/orders	GET	304	2025-10-28 18:52:30.677543
2248	7	/api/orders	GET	304	2025-10-28 18:52:34.559314
2249	7	/api/clients	GET	304	2025-10-28 18:52:34.559677
2250	7	/api/products	GET	304	2025-10-28 18:52:34.560386
2251	7	/api/orders	GET	304	2025-10-28 18:52:34.566581
2252	7	/api/clients	GET	304	2025-10-28 18:52:34.566932
2253	7	/api/products	GET	304	2025-10-28 18:52:34.567348
2254	7	/api/clients	GET	304	2025-10-28 18:52:39.253092
2255	7	/api/products	GET	304	2025-10-28 18:52:39.257126
2256	7	/api/orders	GET	304	2025-10-28 18:52:39.258544
2257	7	/api/clients	GET	304	2025-10-28 18:52:39.25922
2258	7	/api/products	GET	304	2025-10-28 18:52:39.264497
2259	7	/api/orders	GET	304	2025-10-28 18:52:39.264937
2260	7	/api/clients	GET	304	2025-10-28 18:52:39.346252
2261	7	/api/clients	GET	304	2025-10-28 18:52:39.348771
2262	7	/api/products	GET	304	2025-10-28 18:53:12.544143
2263	7	/api/products	GET	304	2025-10-28 18:53:12.577407
2264	7	/api/products	GET	304	2025-10-28 18:53:12.991079
2265	7	/api/clients	GET	304	2025-10-28 18:53:12.994596
2266	7	/api/products	GET	304	2025-10-28 18:53:13.032583
2267	7	/api/clients	GET	304	2025-10-28 18:53:13.036163
2268	7	/api/orders	GET	304	2025-10-28 18:53:13.037289
2269	7	/api/orders	GET	304	2025-10-28 18:53:13.042119
2270	7	/api/users	GET	304	2025-10-28 18:53:13.78313
2271	7	/api/users	GET	304	2025-10-28 18:53:13.788679
2272	7	/api/clients	GET	304	2025-10-28 18:53:14.46103
2273	7	/api/clients	GET	304	2025-10-28 18:53:14.463291
2274	7	/api/clients	GET	200	2025-10-28 18:53:16.47683
2275	7	/api/clients	GET	200	2025-10-28 18:53:16.477339
2276	7	/api/products	GET	304	2025-10-28 18:53:25.349497
2277	7	/api/products	GET	304	2025-10-28 18:53:25.35435
2278	7	/api/products	GET	304	2025-10-28 18:53:27.782394
2279	7	/api/clients	GET	304	2025-10-28 18:53:27.784391
2280	7	/api/clients	GET	304	2025-10-28 18:53:27.82634
2281	7	/api/products	GET	304	2025-10-28 18:53:27.82674
2282	7	/api/orders	GET	304	2025-10-28 18:53:27.828593
2283	7	/api/orders	GET	304	2025-10-28 18:53:27.833054
2284	7	/api/users	GET	304	2025-10-28 18:53:28.974244
2285	7	/api/users	GET	304	2025-10-28 18:53:28.979254
2286	7	/api/clients	GET	304	2025-10-28 18:53:32.575878
2287	7	/api/orders	GET	304	2025-10-28 18:53:32.576246
2288	7	/api/clients	GET	304	2025-10-28 18:53:32.579744
4060	7	/api/products	GET	304	2025-11-10 18:18:19.047001
4144	7	/api/orders	GET	304	2025-11-10 18:24:29.651582
4145	7	/api/orders/19/status	PUT	500	2025-11-10 18:24:31.154156
4278	7	/api/auth/me	GET	304	2025-11-10 18:34:39.959143
4283	7	/api/products	GET	304	2025-11-10 18:34:40.005169
4285	7	/api/orders	GET	304	2025-11-10 18:34:40.014246
4286	7	/api/auth/me	GET	200	2025-11-10 18:34:48.458676
4289	7	/api/products	GET	304	2025-11-10 18:34:48.481224
4293	7	/api/orders	GET	304	2025-11-10 18:34:48.491994
4414	7	/api/products	GET	304	2025-11-10 18:41:15.619377
4567	7	/api/orders	GET	304	2025-11-10 18:44:58.397428
4569	7	/api/clients	GET	304	2025-11-10 18:44:58.489155
4570	7	/api/orders/24/status	PUT	200	2025-11-10 18:44:59.961923
4571	7	/api/orders	GET	200	2025-11-10 18:44:59.966769
4572	7	/api/products	GET	200	2025-11-10 18:45:01.703343
4575	7	/api/products	GET	304	2025-11-10 18:45:03.348686
4578	7	/api/orders	GET	304	2025-11-10 18:45:03.357647
4583	7	/api/products	GET	304	2025-11-10 18:45:06.853953
4584	7	/api/products	GET	304	2025-11-10 18:45:09.398058
4589	7	/api/orders	GET	304	2025-11-10 18:45:09.410001
4664	7	/api/auth/me	GET	200	2025-11-11 16:29:11.074608
4741	7	/api/auth/me	GET	304	2025-11-11 16:55:33.61035
4792	\N	/api/auth/login	POST	200	2025-11-12 15:50:50.658999
4794	7	/api/clients	GET	304	2025-11-12 15:50:55.450334
4795	7	/api/products	GET	304	2025-11-12 15:50:57.53923
4798	7	/api/products	GET	304	2025-11-12 15:50:58.825432
4808	\N	/api/auth/me	GET	401	2026-02-25 17:31:27.621986
4904	7	/api/orders	GET	304	2026-03-12 17:15:01.919851
4905	7	/api/users	GET	304	2026-03-12 17:15:02.391211
4977	\N	/api/auth/login	POST	200	2026-03-12 18:48:52.691784
4978	7	/api/auth/me	GET	304	2026-03-12 18:49:02.335846
5072	7	/api/orders	GET	304	2026-03-12 19:02:48.675412
5074	7	/api/orders	GET	304	2026-03-12 19:02:48.715892
5146	7	/api/clients	GET	304	2026-03-12 21:00:12.126688
5148	7	/api/products	GET	304	2026-03-12 21:00:12.135982
5150	7	/api/orders	GET	304	2026-03-12 21:00:12.147291
5218	7	/api/products	GET	304	2026-03-12 21:14:24.867279
5347	7	/api/orders	GET	304	2026-03-12 21:26:10.41733
5354	7	/api/products	GET	304	2026-03-12 21:26:29.444174
5462	7	/api/products	GET	304	2026-03-13 13:45:15.650442
5464	7	/api/orders	GET	304	2026-03-13 13:45:15.662565
5465	7	/api/users	GET	304	2026-03-13 13:45:17.068475
5468	7	/api/products	GET	304	2026-03-13 13:45:18.319783
5550	7	/api/products	GET	304	2026-03-13 13:55:00.232916
5551	7	/api/products	GET	304	2026-03-13 13:55:01.51136
5619	7	/api/auth/me	GET	200	2026-03-13 14:18:05.956686
5665	7	/api/clients	GET	200	2026-03-13 14:28:54.913683
5668	7	/api/products	GET	200	2026-03-13 14:28:57.656207
5669	7	/api/clients	GET	200	2026-03-13 14:28:58.364389
5682	7	/api/orders	GET	200	2026-03-13 14:28:59.92353
5683	7	/api/orders/2	PUT	200	2026-03-13 14:29:07.141228
5684	7	/api/orders	GET	200	2026-03-13 14:29:07.14678
5685	7	/api/orders/2	PUT	200	2026-03-13 14:29:13.151755
5686	7	/api/orders	GET	200	2026-03-13 14:29:13.156901
5687	7	/api/orders/2	PUT	200	2026-03-13 14:29:17.507165
5688	7	/api/orders	GET	200	2026-03-13 14:29:17.511288
5689	7	/api/orders/2	PUT	200	2026-03-13 14:29:20.689212
5690	7	/api/orders	GET	200	2026-03-13 14:29:20.694385
5691	7	/api/orders/2	PUT	200	2026-03-13 14:29:26.329099
5692	7	/api/orders	GET	200	2026-03-13 14:29:26.333807
5693	7	/api/products	GET	200	2026-03-13 14:29:30.215207
5696	7	/api/clients	GET	200	2026-03-13 14:29:33.077766
5782	7	/api/auth/me	GET	200	2026-03-17 18:19:45.576026
5783	7	/api/clients	GET	200	2026-03-17 18:19:48.584917
5786	7	/api/products	GET	200	2026-03-17 18:19:50.032215
5787	7	/api/clients	GET	200	2026-03-17 18:19:50.883379
5886	7	/api/clients	GET	200	2026-03-17 21:16:35.05638
5889	7	/api/summary	GET	200	2026-03-17 21:16:35.863996
5890	7	/api/clients	GET	200	2026-03-17 21:16:36.97406
5893	7	/api/products	GET	200	2026-03-17 21:16:37.883063
5894	7	/api/clients	GET	200	2026-03-17 21:16:38.377906
5974	7	/api/orders	GET	200	2026-03-17 21:45:16.600863
5977	7	/api/users	GET	200	2026-03-17 21:45:19.996396
5978	7	/api/clients	GET	200	2026-03-17 21:45:23.579704
5993	7	/api/orders	GET	200	2026-03-17 21:45:29.130448
5994	7	/api/summary	GET	200	2026-03-17 21:45:31.420736
6091	7	/api/clients	GET	200	2026-03-18 15:31:59.315685
6093	7	/api/orders	GET	200	2026-03-18 15:31:59.328386
6094	7	/api/users	GET	200	2026-03-18 15:32:00.269311
6159	7	/api/suppliers/1	PUT	200	2026-03-18 15:58:14.193678
6160	7	/api/suppliers	GET	200	2026-03-18 15:58:14.199688
6161	7	/api/suppliers/1	PUT	200	2026-03-18 15:58:19.606188
6162	7	/api/suppliers	GET	200	2026-03-18 15:58:19.611421
6227	7	/api/clients	POST	201	2026-03-18 16:16:51.060807
6228	7	/api/clients	GET	200	2026-03-18 16:16:51.065658
6287	7	/api/products	GET	200	2026-03-18 16:21:36.801065
6365	7	/api/products	GET	200	2026-03-18 16:35:39.829586
6368	7	/api/summary	GET	200	2026-03-18 16:35:44.506493
6369	7	/api/products	GET	200	2026-03-18 16:35:49.711909
6449	7	/api/auth/me	GET	200	2026-03-18 17:12:16.432779
6451	7	/api/products	GET	200	2026-03-18 17:12:16.443011
6453	7	/api/financial?	GET	200	2026-03-18 17:12:17.778442
6540	7	/api/auth/me	GET	200	2026-03-18 17:36:51.670422
6542	7	/api/summary	GET	200	2026-03-18 17:36:51.767795
6544	7	/api/financial?	GET	200	2026-03-18 17:36:59.296468
6612	\N	/api/users	GET	401	2026-03-18 18:00:58.212254
6613	\N	/api/auth/login	POST	200	2026-03-18 18:01:05.75459
6614	7	/api/summary	GET	200	2026-03-18 18:01:05.842373
6619	7	/api/products	GET	200	2026-03-18 18:01:11.60408
6620	7	/api/clients	GET	200	2026-03-18 18:01:12.903549
6631	7	/api/products	GET	200	2026-03-18 18:01:15.402825
6692	7	/api/financial?status=vencido	GET	200	2026-03-18 18:22:02.997396
6762	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:20:56.299341
6848	7	/api/auth/me	GET	200	2026-03-18 21:38:32.109113
6850	7	/api/purchase-orders	GET	200	2026-03-18 21:38:32.167396
6911	7	/api/financial?	GET	200	2026-03-18 21:41:51.49695
6913	7	/api/suppliers	GET	200	2026-03-18 21:41:53.233388
7028	7	/api/financial?	GET	200	2026-03-18 21:48:00.076769
7089	7	/api/suppliers	GET	200	2026-03-18 21:52:09.084715
7143	7	/api/financial?status=vencido	GET	200	2026-03-19 15:47:50.760976
7144	7	/api/summary	GET	200	2026-03-19 15:47:50.76655
7195	7	/api/financial?	GET	200	2026-03-19 15:59:50.824439
7196	7	/api/summary	GET	200	2026-03-19 15:59:53.228093
7199	7	/api/auth/me	GET	200	2026-03-19 15:59:55.265108
7200	7	/api/summary	GET	200	2026-03-19 15:59:55.289224
7204	7	/api/summary	GET	200	2026-03-19 15:59:55.331661
7210	7	/api/financial?	GET	200	2026-03-19 16:00:00.686503
2289	7	/api/orders	GET	304	2025-10-28 18:53:32.583242
4062	7	/api/auth/me	GET	304	2025-11-10 18:18:19.130837
4063	7	/api/auth/me	GET	304	2025-11-10 18:18:23.738862
4066	7	/api/products	GET	304	2025-11-10 18:18:23.760716
4067	7	/api/auth/me	GET	304	2025-11-10 18:18:25.702256
4070	7	/api/products	GET	304	2025-11-10 18:18:25.722552
4071	7	/api/auth/me	GET	304	2025-11-10 18:18:31.675223
4074	7	/api/products	GET	304	2025-11-10 18:18:31.696719
4146	7	/api/orders/3/status	PUT	500	2025-11-10 18:25:13.531182
4147	7	/api/orders/2/status	PUT	500	2025-11-10 18:25:16.192022
4279	7	/api/auth/me	GET	304	2025-11-10 18:34:39.959575
4282	7	/api/clients	GET	304	2025-11-10 18:34:40.00332
4290	7	/api/orders	GET	304	2025-11-10 18:34:48.486037
4416	7	/api/orders	GET	304	2025-11-10 18:41:15.624826
4424	7	/api/orders	GET	304	2025-11-10 18:41:16.82505
4568	7	/api/clients	GET	304	2025-11-10 18:44:58.486683
4573	7	/api/products	GET	304	2025-11-10 18:45:01.709146
4574	7	/api/clients	GET	304	2025-11-10 18:45:03.347387
4587	7	/api/products	GET	304	2025-11-10 18:45:09.406833
4665	\N	/api/auth/login	POST	200	2025-11-11 16:29:23.349041
4742	7	/api/auth/me	GET	304	2025-11-11 16:56:04.598484
4793	7	/api/clients	GET	304	2025-11-12 15:50:55.445067
4796	7	/api/products	GET	304	2025-11-12 15:50:57.544125
4797	7	/api/clients	GET	304	2025-11-12 15:50:58.824334
4809	\N	/api/auth/login	POST	200	2026-02-25 17:32:51.30132
4907	7	/api/auth/me	GET	304	2026-03-12 17:16:08.578492
4910	7	/api/clients	GET	304	2026-03-12 17:16:15.220802
4911	7	/api/auth/me	GET	304	2026-03-12 17:16:19.609699
4914	7	/api/auth/me	GET	200	2026-03-12 17:16:23.81785
4915	7	/api/clients	GET	304	2026-03-12 17:16:25.955781
4918	7	/api/products	GET	304	2026-03-12 17:16:26.815901
4919	7	/api/clients	GET	304	2026-03-12 17:16:27.425758
4931	7	/api/products	GET	304	2026-03-12 17:16:29.318226
4979	7	/api/auth/me	GET	304	2026-03-12 18:49:02.367551
5073	7	/api/orders	GET	304	2026-03-12 19:02:48.712304
5075	7	/api/orders	GET	304	2026-03-12 19:02:48.718956
5077	7	/api/products	GET	304	2026-03-12 19:02:48.769408
5079	7	/api/products	GET	304	2026-03-12 19:02:48.77677
5081	7	/api/clients	GET	304	2026-03-12 19:02:48.810063
5147	7	/api/products	GET	304	2026-03-12 21:00:12.129778
5219	7	/api/clients	GET	304	2026-03-12 21:14:24.867714
5348	7	/api/auth/me	GET	304	2026-03-12 21:26:10.453247
5349	7	/api/orders/27	PUT	200	2026-03-12 21:26:17.075203
5350	7	/api/orders	GET	200	2026-03-12 21:26:17.082583
5351	7	/api/orders/27	PUT	200	2026-03-12 21:26:24.973881
5352	7	/api/orders	GET	200	2026-03-12 21:26:24.979985
5353	7	/api/products	GET	200	2026-03-12 21:26:29.434293
5463	7	/api/orders	GET	304	2026-03-13 13:45:15.657256
5466	7	/api/users	GET	304	2026-03-13 13:45:17.073688
5467	7	/api/clients	GET	304	2026-03-13 13:45:18.319105
5553	7	/api/clients	GET	304	2026-03-13 13:59:04.705242
5556	7	/api/products	GET	304	2026-03-13 13:59:04.720649
5563	7	/api/orders	GET	304	2026-03-13 13:59:08.486492
5620	7	/api/auth/me	GET	200	2026-03-13 14:20:25.422544
5623	7	/api/auth/me	GET	200	2026-03-13 14:20:27.321111
5666	7	/api/clients	GET	200	2026-03-13 14:28:54.949038
5667	7	/api/products	GET	200	2026-03-13 14:28:57.650399
5670	7	/api/products	GET	200	2026-03-13 14:28:58.365358
5680	7	/api/products	GET	200	2026-03-13 14:28:59.916993
5789	7	/api/products	GET	200	2026-03-17 18:19:50.927333
5792	7	/api/orders	GET	200	2026-03-17 18:19:50.934007
5793	7	/api/users	GET	200	2026-03-17 18:19:52.17498
5796	7	/api/clients	GET	200	2026-03-17 18:19:54.054041
5797	7	/api/products	GET	200	2026-03-17 18:19:54.830149
5801	7	/api/clients	GET	200	2026-03-17 18:19:55.307727
5804	7	/api/products	GET	200	2026-03-17 18:19:55.313902
5805	7	/api/users	GET	200	2026-03-17 18:19:55.819855
5887	7	/api/clients	GET	200	2026-03-17 21:16:35.092098
5888	7	/api/summary	GET	200	2026-03-17 21:16:35.856116
5891	7	/api/clients	GET	200	2026-03-17 21:16:36.978121
5892	7	/api/products	GET	200	2026-03-17 21:16:37.879901
5895	7	/api/products	GET	200	2026-03-17 21:16:38.378931
5899	7	/api/orders	GET	200	2026-03-17 21:16:38.438731
5900	7	/api/users	GET	200	2026-03-17 21:16:38.90915
5903	7	/api/summary	GET	200	2026-03-17 21:16:39.51166
5982	7	/api/products	GET	200	2026-03-17 21:45:23.622542
5985	7	/api/products	GET	200	2026-03-17 21:45:26.078593
5986	7	/api/clients	GET	200	2026-03-17 21:45:27.890234
5989	7	/api/products	GET	200	2026-03-17 21:45:29.122262
6092	7	/api/orders	GET	200	2026-03-18 15:31:59.32429
6095	7	/api/users	GET	200	2026-03-18 15:32:00.274312
6163	7	/api/auth/me	GET	200	2026-03-18 15:59:31.048227
6166	7	/api/suppliers	GET	200	2026-03-18 15:59:31.067778
6229	7	/api/clients	POST	201	2026-03-18 16:17:04.967309
6230	7	/api/clients	GET	200	2026-03-18 16:17:04.972272
6288	7	/api/orders	GET	200	2026-03-18 16:21:36.804464
6290	7	/api/clients	GET	200	2026-03-18 16:21:36.855401
6366	7	/api/auth/me	GET	200	2026-03-18 16:35:39.875814
6367	7	/api/summary	GET	200	2026-03-18 16:35:44.498481
6370	7	/api/products	GET	200	2026-03-18 16:35:49.714501
6454	7	/api/financial/categories	GET	200	2026-03-18 17:12:17.820153
6541	7	/api/summary	GET	200	2026-03-18 17:36:51.752749
6543	7	/api/financial/categories	GET	200	2026-03-18 17:36:59.29481
6622	7	/api/clients	GET	200	2026-03-18 18:01:12.94844
6625	7	/api/orders	GET	200	2026-03-18 18:01:12.959517
6627	7	/api/users	GET	200	2026-03-18 18:01:14.065248
6628	7	/api/products	GET	200	2026-03-18 18:01:15.391579
6633	7	/api/clients	GET	200	2026-03-18 18:01:15.410121
6693	7	/api/summary	GET	200	2026-03-18 18:22:03.002722
6694	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:22:03.009455
6763	7	/api/summary	GET	200	2026-03-18 21:24:49.720132
6765	7	/api/suppliers	GET	200	2026-03-18 21:24:53.49634
6783	7	/api/products	GET	200	2026-03-18 21:24:59.965086
6851	7	/api/financial?status=vencido	GET	200	2026-03-18 21:38:32.176949
6912	7	/api/financial/categories	GET	200	2026-03-18 21:41:51.51515
6915	7	/api/purchase-orders	GET	200	2026-03-18 21:41:53.238291
6924	7	/api/financial?	GET	200	2026-03-18 21:41:55.519886
6925	7	/api/auth/me	GET	200	2026-03-18 21:41:58.010847
6927	7	/api/financial?status=vencido	GET	200	2026-03-18 21:41:58.035691
6936	7	/api/financial/categories	GET	200	2026-03-18 21:41:58.089037
6937	7	/api/products	GET	200	2026-03-18 21:42:06.477991
6940	7	/api/suppliers	GET	200	2026-03-18 21:42:13.302581
6945	7	/api/financial/categories	GET	200	2026-03-18 21:42:21.266763
6952	7	/api/summary	GET	200	2026-03-18 21:42:28.710368
6959	7	/api/financial?	GET	200	2026-03-18 21:42:28.77433
7029	7	/api/financial/18	PUT	200	2026-03-18 21:48:11.219134
7030	7	/api/financial?	GET	200	2026-03-18 21:48:11.228238
2290	7	/api/products	GET	304	2025-10-28 18:53:32.583627
2291	7	/api/products	GET	304	2025-10-28 18:53:32.617723
2292	\N	/api/auth/login	POST	200	2025-11-07 18:00:49.858858
2293	7	/api/clients	GET	304	2025-11-07 18:00:59.258144
2294	7	/api/clients	GET	304	2025-11-07 18:00:59.293403
2295	7	/api/products	GET	304	2025-11-07 18:01:00.711497
2296	7	/api/products	GET	304	2025-11-07 18:01:00.716725
2297	7	/api/clients	GET	304	2025-11-07 18:01:19.841918
2298	7	/api/clients	GET	304	2025-11-07 18:01:19.983721
2299	7	/api/clients	POST	201	2025-11-07 18:01:35.379613
2300	7	/api/clients	GET	200	2025-11-07 18:01:35.384157
2301	7	/api/clients	POST	201	2025-11-07 18:01:59.299351
2302	7	/api/clients	GET	200	2025-11-07 18:01:59.30481
2303	7	/api/clients	POST	201	2025-11-07 18:02:07.967901
2304	7	/api/clients	GET	200	2025-11-07 18:02:08.150166
2305	7	/api/products	GET	304	2025-11-07 18:02:24.435045
2306	7	/api/products	GET	304	2025-11-07 18:02:24.470011
2307	7	/api/products/5	PUT	200	2025-11-07 18:02:34.410307
2308	7	/api/products	GET	200	2025-11-07 18:02:34.418386
2309	7	/api/products/6	PUT	200	2025-11-07 18:02:40.14947
2310	7	/api/products	GET	200	2025-11-07 18:02:40.155546
2311	7	/api/clients	GET	304	2025-11-07 18:02:45.257106
2312	7	/api/clients	GET	304	2025-11-07 18:02:45.29194
2313	7	/api/products	GET	304	2025-11-07 18:02:45.801488
2314	7	/api/products	GET	304	2025-11-07 18:02:45.805203
2315	7	/api/clients	GET	304	2025-11-07 18:02:46.482635
2316	7	/api/products	GET	304	2025-11-07 18:02:46.483165
2317	7	/api/clients	GET	304	2025-11-07 18:02:46.528488
2318	7	/api/products	GET	304	2025-11-07 18:02:46.531713
2319	7	/api/orders	GET	304	2025-11-07 18:02:46.533018
2320	7	/api/orders	GET	304	2025-11-07 18:02:46.53746
2321	7	/api/clients	GET	304	2025-11-07 18:02:56.927374
2322	7	/api/products	GET	304	2025-11-07 18:02:56.966345
2324	7	/api/products	GET	304	2025-11-07 18:02:56.970767
2323	7	/api/orders	GET	304	2025-11-07 18:02:56.970283
2325	7	/api/orders	GET	304	2025-11-07 18:02:56.975852
2326	7	/api/clients	GET	304	2025-11-07 18:02:57.075822
2327	7	/api/clients	GET	304	2025-11-07 18:03:01.0342
2328	7	/api/clients	GET	304	2025-11-07 18:03:01.036734
2329	7	/api/clients/5	PUT	200	2025-11-07 18:03:07.27716
2330	7	/api/clients	GET	200	2025-11-07 18:03:07.282556
2331	7	/api/products	GET	304	2025-11-07 18:03:08.551398
2332	7	/api/products	GET	304	2025-11-07 18:03:08.562076
2333	7	/api/clients	GET	304	2025-11-07 18:03:09.36446
2334	7	/api/products	GET	304	2025-11-07 18:03:09.365111
2335	7	/api/clients	GET	304	2025-11-07 18:03:09.408093
2336	7	/api/products	GET	304	2025-11-07 18:03:09.410182
2337	7	/api/orders	GET	304	2025-11-07 18:03:09.529842
2338	7	/api/orders	GET	304	2025-11-07 18:03:09.534667
2339	7	/api/orders	POST	500	2025-11-07 18:03:35.936372
2340	7	/api/clients	GET	200	2025-11-07 18:04:19.462142
2341	7	/api/products	GET	200	2025-11-07 18:04:19.464323
2342	7	/api/clients	GET	200	2025-11-07 18:04:19.467499
2343	7	/api/products	GET	200	2025-11-07 18:04:19.472581
2344	7	/api/orders	GET	200	2025-11-07 18:04:19.475327
2345	7	/api/orders	GET	200	2025-11-07 18:04:19.475986
2346	7	/api/clients	GET	200	2025-11-07 18:04:42.655193
2347	7	/api/products	GET	200	2025-11-07 18:04:42.656903
2348	7	/api/clients	GET	200	2025-11-07 18:04:42.70085
2349	7	/api/orders	GET	200	2025-11-07 18:04:42.70534
2350	7	/api/products	GET	200	2025-11-07 18:04:42.706486
2351	7	/api/orders	GET	200	2025-11-07 18:04:42.70779
2352	7	/api/clients	GET	200	2025-11-07 18:06:18.400573
2353	7	/api/clients	GET	200	2025-11-07 18:06:18.401325
2354	7	/api/products	GET	200	2025-11-07 18:06:20.386655
2355	7	/api/products	GET	200	2025-11-07 18:06:20.387746
2356	7	/api/users	GET	200	2025-11-07 18:06:23.091509
2357	7	/api/users	GET	200	2025-11-07 18:06:23.093292
2358	7	/api/clients	GET	200	2025-11-07 18:06:25.357161
2359	7	/api/products	GET	200	2025-11-07 18:06:25.357908
2360	7	/api/clients	GET	200	2025-11-07 18:06:25.403626
2361	7	/api/products	GET	200	2025-11-07 18:06:25.404565
2362	7	/api/orders	GET	200	2025-11-07 18:06:25.405807
2363	7	/api/orders	GET	200	2025-11-07 18:06:25.409461
2364	7	/api/clients	GET	200	2025-11-07 18:11:09.421107
2365	7	/api/products	GET	200	2025-11-07 18:11:09.424601
2366	7	/api/clients	GET	200	2025-11-07 18:11:09.42591
2367	7	/api/products	GET	200	2025-11-07 18:11:09.428942
2368	7	/api/orders	GET	200	2025-11-07 18:11:09.430458
2369	7	/api/orders	GET	200	2025-11-07 18:11:09.43168
2370	7	/api/clients	GET	200	2025-11-07 18:11:11.389554
2371	7	/api/products	GET	200	2025-11-07 18:11:11.390159
2372	7	/api/clients	GET	200	2025-11-07 18:11:11.390848
2373	7	/api/orders	GET	200	2025-11-07 18:11:11.391777
2374	7	/api/products	GET	200	2025-11-07 18:11:11.392372
2375	7	/api/orders	GET	200	2025-11-07 18:11:11.393542
2376	7	/api/clients	GET	200	2025-11-07 18:11:45.413757
2377	7	/api/products	GET	200	2025-11-07 18:11:45.414385
2378	7	/api/clients	GET	200	2025-11-07 18:11:45.416285
2379	7	/api/orders	GET	200	2025-11-07 18:11:45.42004
2380	7	/api/products	GET	200	2025-11-07 18:11:45.420651
2381	7	/api/orders	GET	200	2025-11-07 18:11:45.421837
2382	7	/api/clients	GET	200	2025-11-07 18:11:56.049332
2383	7	/api/clients	GET	200	2025-11-07 18:11:56.049851
2384	7	/api/products	GET	200	2025-11-07 18:11:56.055579
2385	7	/api/orders	GET	200	2025-11-07 18:11:56.056453
2386	7	/api/orders	GET	200	2025-11-07 18:11:56.05809
2387	7	/api/products	GET	200	2025-11-07 18:11:56.161867
2388	7	/api/orders	POST	500	2025-11-07 18:12:06.448702
2389	7	/api/clients	GET	200	2025-11-07 18:17:00.43312
2390	7	/api/products	GET	200	2025-11-07 18:17:00.438509
2391	7	/api/clients	GET	200	2025-11-07 18:17:00.439517
2392	7	/api/orders	GET	200	2025-11-07 18:17:00.441891
2393	7	/api/products	GET	200	2025-11-07 18:17:00.442509
2394	7	/api/orders	GET	200	2025-11-07 18:17:00.444015
2395	7	/api/clients	GET	200	2025-11-07 18:17:02.365037
2396	7	/api/products	GET	200	2025-11-07 18:17:02.365879
2397	7	/api/orders	GET	200	2025-11-07 18:17:02.366631
2398	7	/api/clients	GET	200	2025-11-07 18:17:02.367273
2399	7	/api/products	GET	200	2025-11-07 18:17:02.368126
2400	7	/api/orders	GET	200	2025-11-07 18:17:02.369336
2401	7	/api/clients	GET	200	2025-11-07 18:17:58.361847
2402	7	/api/products	GET	200	2025-11-07 18:17:58.363863
2403	7	/api/clients	GET	200	2025-11-07 18:17:58.366559
2404	7	/api/orders	GET	200	2025-11-07 18:17:58.367793
2405	7	/api/products	GET	200	2025-11-07 18:17:58.370786
2406	7	/api/orders	GET	200	2025-11-07 18:17:58.372611
2407	7	/api/clients	GET	200	2025-11-07 18:18:04.384911
2408	7	/api/products	GET	200	2025-11-07 18:18:04.392293
2409	7	/api/orders	GET	200	2025-11-07 18:18:04.392922
2410	7	/api/clients	GET	200	2025-11-07 18:18:04.393495
4075	7	/api/auth/me	GET	304	2025-11-10 18:18:57.758261
4148	7	/api/auth/me	GET	200	2025-11-10 18:28:19.751657
4149	7	/api/clients	GET	304	2025-11-10 18:28:19.783007
4162	7	/api/products	GET	304	2025-11-10 18:28:25.396172
4170	7	/api/products	GET	304	2025-11-10 18:28:32.783596
4177	7	/api/products	GET	304	2025-11-10 18:28:38.041589
4178	7	/api/products	GET	304	2025-11-10 18:28:40.173418
4280	7	/api/clients	GET	304	2025-11-10 18:34:39.995658
4419	7	/api/auth/me	GET	304	2025-11-10 18:41:15.688389
4420	7	/api/auth/me	GET	200	2025-11-10 18:41:16.802527
4423	7	/api/products	GET	304	2025-11-10 18:41:16.824343
4427	7	/api/orders	GET	304	2025-11-10 18:41:16.83466
4590	7	/api/auth/me	GET	200	2025-11-10 18:46:17.279736
4591	7	/api/clients	GET	304	2025-11-10 18:46:17.305182
4604	7	/api/products	GET	304	2025-11-10 18:46:20.243085
4609	7	/api/products	GET	304	2025-11-10 18:46:23.820843
4610	7	/api/products	GET	304	2025-11-10 18:46:25.182696
4666	7	/api/clients	GET	304	2025-11-11 16:29:35.944413
4670	7	/api/products	GET	304	2025-11-11 16:29:35.994788
4743	7	/api/auth/me	GET	304	2025-11-11 16:56:04.59864
4799	7	/api/clients	GET	304	2025-11-12 15:50:58.873003
4810	\N	/api/auth/me	GET	401	2026-03-12 15:49:15.047787
4908	7	/api/auth/me	GET	304	2026-03-12 17:16:08.68044
4909	7	/api/clients	GET	304	2026-03-12 17:16:15.218563
4912	7	/api/auth/me	GET	304	2026-03-12 17:16:19.612044
4913	7	/api/auth/me	GET	200	2026-03-12 17:16:23.813974
4916	7	/api/clients	GET	304	2026-03-12 17:16:25.957835
4917	7	/api/products	GET	304	2026-03-12 17:16:26.811635
4920	7	/api/products	GET	304	2026-03-12 17:16:27.426512
4929	7	/api/clients	GET	304	2026-03-12 17:16:29.316927
4934	7	/api/products	GET	304	2026-03-12 17:16:30.301436
4935	7	/api/clients	GET	304	2026-03-12 17:16:30.811017
4938	7	/api/clients	GET	304	2026-03-12 17:16:34.547368
4939	7	/api/products	GET	304	2026-03-12 17:16:35.29875
4980	7	/api/auth/me	GET	304	2026-03-12 18:51:56.000266
5076	7	/api/products	GET	304	2026-03-12 19:02:48.764394
5078	7	/api/products	GET	304	2026-03-12 19:02:48.772756
5149	7	/api/orders	GET	304	2026-03-12 21:00:12.141975
5220	7	/api/clients	GET	304	2026-03-12 21:18:09.379846
5223	7	/api/products	GET	304	2026-03-12 21:18:09.983413
5224	7	/api/clients	GET	304	2026-03-12 21:18:10.442985
5236	7	/api/products	GET	304	2026-03-12 21:18:13.822189
5355	7	/api/auth/me	GET	304	2026-03-12 21:29:49.589287
5356	7	/api/products	GET	304	2026-03-12 21:29:49.636553
5369	7	/api/orders	GET	304	2026-03-12 21:29:58.10385
5471	7	/api/products	GET	304	2026-03-13 13:45:18.362802
5474	7	/api/products	GET	304	2026-03-13 13:45:19.995596
5475	7	/api/clients	GET	304	2026-03-13 13:45:20.440375
5554	7	/api/products	GET	304	2026-03-13 13:59:04.713268
5557	7	/api/orders	GET	304	2026-03-13 13:59:04.724538
5560	7	/api/users	GET	304	2026-03-13 13:59:07.28553
5561	7	/api/clients	GET	304	2026-03-13 13:59:08.482677
5621	7	/api/auth/me	GET	200	2026-03-13 14:20:25.518019
5622	7	/api/auth/me	GET	200	2026-03-13 14:20:27.318195
5671	7	/api/products	GET	200	2026-03-13 14:28:58.40907
5673	7	/api/orders	GET	200	2026-03-13 14:28:58.415931
5676	7	/api/users	GET	200	2026-03-13 14:28:59.482393
5677	7	/api/products	GET	200	2026-03-13 14:28:59.913418
5790	7	/api/orders	GET	200	2026-03-17 18:19:50.92895
5802	7	/api/products	GET	200	2026-03-17 18:19:55.309894
5896	7	/api/clients	GET	200	2026-03-17 21:16:38.430224
5983	7	/api/orders	GET	200	2026-03-17 21:45:23.62518
5984	7	/api/products	GET	200	2026-03-17 21:45:26.07656
5987	7	/api/clients	GET	200	2026-03-17 21:45:27.892216
5988	7	/api/clients	GET	200	2026-03-17 21:45:29.121274
6096	7	/api/auth/me	GET	200	2026-03-18 15:36:03.54338
6099	7	/api/auth/me	GET	200	2026-03-18 15:36:11.913274
6164	7	/api/auth/me	GET	200	2026-03-18 15:59:31.048676
6165	7	/api/suppliers	GET	200	2026-03-18 15:59:31.062401
6231	7	/api/clients	POST	201	2026-03-18 16:17:17.888605
6232	7	/api/clients	GET	200	2026-03-18 16:17:17.894504
6289	7	/api/clients	GET	200	2026-03-18 16:21:36.852786
6371	7	/api/products/19	PUT	500	2026-03-18 16:36:07.183329
6372	7	/api/summary	GET	200	2026-03-18 16:36:08.826125
6375	7	/api/products	GET	200	2026-03-18 16:36:10.816087
6455	7	/api/financial?	GET	200	2026-03-18 17:12:17.82136
6546	7	/api/financial?	GET	200	2026-03-18 17:36:59.332244
6623	7	/api/orders	GET	200	2026-03-18 18:01:12.953183
6629	7	/api/clients	GET	200	2026-03-18 18:01:15.399727
6695	7	/api/auth/me	GET	200	2026-03-18 18:24:35.663146
6702	7	/api/financial/categories	GET	200	2026-03-18 18:24:35.702819
6709	7	/api/products	GET	200	2026-03-18 18:24:36.949798
6764	7	/api/summary	GET	200	2026-03-18 21:24:49.770014
6766	7	/api/purchase-orders	GET	200	2026-03-18 21:24:53.499453
6769	7	/api/products	GET	200	2026-03-18 21:24:53.538877
6772	7	/api/auth/me	GET	200	2026-03-18 21:24:59.894358
6774	7	/api/summary	GET	200	2026-03-18 21:24:59.923774
6780	7	/api/products	GET	200	2026-03-18 21:24:59.962081
6852	7	/api/financial?status=vencido	GET	200	2026-03-18 21:38:32.178772
6918	7	/api/products	GET	200	2026-03-18 21:41:53.275172
6919	7	/api/purchase-orders/3/status	PATCH	200	2026-03-18 21:41:54.19086
6920	7	/api/purchase-orders	GET	200	2026-03-18 21:41:54.195755
6923	7	/api/financial?	GET	200	2026-03-18 21:41:55.513566
6926	7	/api/auth/me	GET	200	2026-03-18 21:41:58.012307
6929	7	/api/summary	GET	200	2026-03-18 21:41:58.044931
6934	7	/api/financial/categories	GET	200	2026-03-18 21:41:58.086985
7031	7	/api/summary	GET	200	2026-03-18 21:48:27.409514
7090	7	/api/suppliers	GET	200	2026-03-18 21:52:09.11508
7145	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:47:50.909599
7197	7	/api/summary	GET	200	2026-03-19 15:59:53.273471
7198	7	/api/auth/me	GET	200	2026-03-19 15:59:55.262788
7201	7	/api/summary	GET	200	2026-03-19 15:59:55.290112
7205	7	/api/summary	GET	200	2026-03-19 15:59:55.33285
7207	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:59:55.44106
7208	7	/api/financial?	GET	200	2026-03-19 16:00:00.682656
7211	7	/api/financial/categories	GET	200	2026-03-19 16:00:00.686927
7244	7	/api/financial?status=vencido	GET	200	2026-03-19 16:10:34.364779
7281	7	/api/summary	GET	200	2026-03-19 16:15:18.196531
7283	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:15:18.212203
7284	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:15:18.222573
7285	7	/api/summary	GET	200	2026-03-19 16:15:18.270666
7287	7	/api/financial?status=vencido	GET	200	2026-03-19 16:15:20.835013
7384	7	/api/summary	GET	200	2026-03-19 16:17:50.87086
7440	7	/api/auth/me	GET	200	2026-03-19 16:21:41.912945
2411	7	/api/products	GET	200	2025-11-07 18:18:04.394108
4076	7	/api/auth/me	GET	304	2025-11-10 18:18:57.758458
4078	7	/api/products	GET	304	2025-11-10 18:18:57.775202
4079	7	/api/auth/me	GET	304	2025-11-10 18:18:59.67372
4082	7	/api/products	GET	304	2025-11-10 18:18:59.693521
4083	7	/api/auth/me	GET	304	2025-11-10 18:19:03.705361
4086	7	/api/products	GET	304	2025-11-10 18:19:03.725333
4087	7	/api/auth/me	GET	304	2025-11-10 18:19:09.699492
4093	7	/api/orders	GET	200	2025-11-10 18:19:17.523515
4150	7	/api/auth/me	GET	200	2025-11-10 18:28:19.792732
4154	7	/api/products	GET	304	2025-11-10 18:28:19.830979
4157	7	/api/products	GET	304	2025-11-10 18:28:22.543815
4158	7	/api/clients	GET	304	2025-11-10 18:28:25.38709
4173	7	/api/orders	GET	304	2025-11-10 18:28:32.789199
4174	7	/api/orders/19/status	PUT	200	2025-11-10 18:28:35.271567
4175	7	/api/orders	GET	200	2025-11-10 18:28:35.276405
4176	7	/api/products	GET	304	2025-11-10 18:28:38.037875
4179	7	/api/clients	GET	304	2025-11-10 18:28:40.174355
4187	7	/api/products	GET	304	2025-11-10 18:28:49.994227
4281	7	/api/products	GET	304	2025-11-10 18:34:39.996699
4291	7	/api/clients	GET	304	2025-11-10 18:34:48.486894
4428	7	/api/products	GET	304	2025-11-10 18:41:41.798909
4431	7	/api/clients	GET	304	2025-11-10 18:41:43.406556
4433	7	/api/orders	GET	304	2025-11-10 18:41:43.447926
4592	7	/api/auth/me	GET	200	2025-11-10 18:46:17.31724
4596	7	/api/products	GET	304	2025-11-10 18:46:17.353354
4599	7	/api/products	GET	304	2025-11-10 18:46:19.101927
4600	7	/api/clients	GET	304	2025-11-10 18:46:20.232509
4667	7	/api/products	GET	304	2025-11-11 16:29:35.990366
4671	7	/api/orders	GET	304	2025-11-11 16:29:35.999681
4744	7	/api/auth/me	GET	304	2025-11-11 16:57:46.889952
4800	7	/api/products	GET	304	2025-11-12 15:50:58.874935
4802	7	/api/orders	GET	304	2025-11-12 15:50:58.89795
4803	7	/api/users	GET	304	2025-11-12 15:51:05.613968
4811	\N	/api/auth/me	GET	401	2026-03-12 15:49:15.146496
4921	7	/api/clients	GET	304	2026-03-12 17:16:27.471086
4930	7	/api/orders	GET	304	2026-03-12 17:16:29.317485
4981	7	/api/auth/me	GET	304	2026-03-12 18:51:56.000394
4982	\N	/api/auth/login	POST	200	2026-03-12 18:52:04.015763
4983	7	/api/auth/me	GET	304	2026-03-12 18:52:09.883175
4986	7	/api/products	GET	304	2026-03-12 18:52:10.970622
4987	7	/api/products	GET	304	2026-03-12 18:52:12.043585
4999	7	/api/products	GET	304	2026-03-12 18:52:18.841718
5080	7	/api/clients	GET	304	2026-03-12 19:02:48.807264
5082	7	/api/clients	GET	304	2026-03-12 19:02:48.812673
5151	7	/api/auth/me	GET	304	2026-03-12 21:00:12.152506
5221	7	/api/clients	GET	304	2026-03-12 21:18:09.412588
5222	7	/api/products	GET	304	2026-03-12 21:18:09.978816
5225	7	/api/products	GET	304	2026-03-12 21:18:10.445527
5234	7	/api/clients	GET	304	2026-03-12 21:18:13.81977
5357	7	/api/products	GET	304	2026-03-12 21:29:49.67448
5360	7	/api/auth/me	GET	200	2026-03-12 21:29:51.884498
5361	7	/api/products	GET	304	2026-03-12 21:29:51.915507
5364	7	/api/clients	GET	304	2026-03-12 21:29:56.615316
5365	7	/api/products	GET	304	2026-03-12 21:29:57.439884
5368	7	/api/products	GET	304	2026-03-12 21:29:58.09422
5472	7	/api/orders	GET	304	2026-03-13 13:45:18.365299
5473	7	/api/products	GET	304	2026-03-13 13:45:19.990422
5476	7	/api/clients	GET	304	2026-03-13 13:45:20.443684
5555	7	/api/orders	GET	304	2026-03-13 13:59:04.717635
5564	7	/api/clients	GET	304	2026-03-13 13:59:08.487282
5624	7	/api/auth/me	GET	200	2026-03-13 14:21:03.082603
5672	7	/api/orders	GET	200	2026-03-13 14:28:58.411279
5678	7	/api/clients	GET	200	2026-03-13 14:28:59.914111
5681	7	/api/clients	GET	200	2026-03-13 14:28:59.922653
5694	7	/api/products	GET	200	2026-03-13 14:29:30.219915
5695	7	/api/products	GET	200	2026-03-13 14:29:33.075731
5791	7	/api/clients	GET	200	2026-03-17 18:19:50.92962
5794	7	/api/users	GET	200	2026-03-17 18:19:52.178945
5795	7	/api/clients	GET	200	2026-03-17 18:19:54.051846
5798	7	/api/products	GET	200	2026-03-17 18:19:54.835347
5799	7	/api/clients	GET	200	2026-03-17 18:19:55.300637
5800	7	/api/orders	GET	200	2026-03-17 18:19:55.307224
5897	7	/api/orders	GET	200	2026-03-17 21:16:38.431724
5996	7	/api/clients	GET	200	2026-03-17 21:47:57.22397
5999	7	/api/products	GET	200	2026-03-17 21:47:58.46592
6097	7	/api/auth/me	GET	200	2026-03-18 15:36:03.543504
6098	7	/api/auth/me	GET	200	2026-03-18 15:36:11.91148
6167	7	/api/suppliers	POST	201	2026-03-18 15:59:50.941312
6168	7	/api/suppliers	GET	200	2026-03-18 15:59:50.946283
6233	7	/api/clients	POST	201	2026-03-18 16:17:29.225666
6234	7	/api/clients	GET	200	2026-03-18 16:17:29.230508
6291	7	/api/orders	POST	201	2026-03-18 16:21:55.00696
6292	7	/api/orders	GET	200	2026-03-18 16:21:55.011793
6293	7	/api/summary	GET	200	2026-03-18 16:21:56.097619
6296	7	/api/products	GET	200	2026-03-18 16:22:03.941375
6373	7	/api/summary	GET	200	2026-03-18 16:36:08.866094
6374	7	/api/clients	GET	200	2026-03-18 16:36:10.814946
6456	7	/api/financial	POST	500	2026-03-18 17:13:23.673089
6547	7	/api/financial	POST	201	2026-03-18 17:37:41.276216
6548	7	/api/financial?	GET	200	2026-03-18 17:37:41.285082
6549	7	/api/summary	GET	200	2026-03-18 17:37:43.227427
6552	7	/api/auth/me	GET	200	2026-03-18 17:37:45.37079
6553	7	/api/summary	GET	200	2026-03-18 17:37:45.421036
6556	7	/api/auth/me	GET	200	2026-03-18 17:37:50.195127
6557	7	/api/summary	GET	200	2026-03-18 17:37:50.255455
6624	7	/api/products	GET	200	2026-03-18 18:01:12.95553
6626	7	/api/users	GET	200	2026-03-18 18:01:14.060891
6630	7	/api/orders?	GET	200	2026-03-18 18:01:15.400853
6696	7	/api/auth/me	GET	200	2026-03-18 18:24:35.663885
6703	7	/api/financial?	GET	200	2026-03-18 18:24:35.704924
6704	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:24:35.70929
6707	7	/api/suppliers	GET	200	2026-03-18 18:24:36.945935
6710	7	/api/products	GET	200	2026-03-18 18:24:36.954064
6711	7	/api/purchase-orders	GET	500	2026-03-18 18:24:36.968889
6712	7	/api/purchase-orders	GET	500	2026-03-18 18:24:36.973042
6767	7	/api/products	GET	200	2026-03-18 21:24:53.536284
6775	7	/api/financial?status=vencido	GET	200	2026-03-18 21:24:59.924407
6776	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:24:59.930376
6779	7	/api/suppliers	GET	200	2026-03-18 21:24:59.959748
6853	7	/api/summary	GET	200	2026-03-18 21:38:32.199177
6856	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:38:32.220964
6858	7	/api/suppliers	GET	200	2026-03-18 21:38:32.232809
6941	7	/api/products	GET	200	2026-03-18 21:42:13.342408
6946	7	/api/financial/categories	GET	200	2026-03-18 21:42:21.270257
6948	7	/api/financial?	GET	200	2026-03-18 21:42:21.280134
6949	7	/api/auth/me	GET	200	2026-03-18 21:42:28.670472
2412	7	/api/orders	GET	200	2025-11-07 18:18:04.395455
2413	7	/api/orders	POST	500	2025-11-07 18:18:15.617516
2414	7	/api/orders	POST	500	2025-11-07 18:19:03.89703
2415	7	/api/orders	POST	500	2025-11-07 18:19:15.609319
2416	7	/api/clients	GET	200	2025-11-07 18:21:37.395768
2417	7	/api/products	GET	200	2025-11-07 18:21:37.442068
2418	7	/api/clients	GET	200	2025-11-07 18:21:37.445116
2419	7	/api/orders	GET	200	2025-11-07 18:21:37.447407
2420	7	/api/products	GET	200	2025-11-07 18:21:37.449716
2421	7	/api/orders	GET	200	2025-11-07 18:21:37.451099
2422	7	/api/orders	POST	201	2025-11-07 18:21:47.015629
2423	7	/api/orders	GET	200	2025-11-07 18:21:47.02278
2424	7	/api/products	GET	200	2025-11-07 18:22:14.964198
2425	7	/api/products	GET	304	2025-11-07 18:22:14.998611
2426	7	/api/clients	GET	304	2025-11-07 18:22:20.345794
2427	7	/api/products	GET	304	2025-11-07 18:22:20.346698
2428	7	/api/orders	GET	304	2025-11-07 18:22:20.387022
2429	7	/api/orders	GET	304	2025-11-07 18:22:20.391931
2430	7	/api/products	GET	304	2025-11-07 18:22:20.393833
2431	7	/api/clients	GET	304	2025-11-07 18:22:20.394608
2432	7	/api/products	GET	304	2025-11-07 18:22:47.534525
2433	7	/api/products	GET	304	2025-11-07 18:22:47.568125
2434	7	/api/products	GET	304	2025-11-07 18:22:50.143268
2435	7	/api/clients	GET	304	2025-11-07 18:22:50.144297
2436	7	/api/orders	GET	304	2025-11-07 18:22:50.186224
2437	7	/api/orders	GET	304	2025-11-07 18:22:50.189937
2438	7	/api/clients	GET	304	2025-11-07 18:22:50.192051
2439	7	/api/products	GET	304	2025-11-07 18:22:50.192689
2440	7	/api/orders	POST	201	2025-11-07 18:22:55.814431
2441	7	/api/orders	GET	200	2025-11-07 18:22:55.819811
2442	7	/api/products	GET	200	2025-11-07 18:22:56.580548
2443	7	/api/products	GET	304	2025-11-07 18:22:56.585443
2444	7	/api/clients	GET	304	2025-11-07 18:23:06.060916
2445	7	/api/products	GET	304	2025-11-07 18:23:06.061461
2446	7	/api/orders	GET	304	2025-11-07 18:23:06.100316
2447	7	/api/orders	GET	304	2025-11-07 18:23:06.103295
2448	7	/api/products	GET	304	2025-11-07 18:23:06.107342
2449	7	/api/clients	GET	304	2025-11-07 18:23:06.202745
2450	7	/api/orders/14	PUT	200	2025-11-07 18:23:38.134888
2451	7	/api/orders	GET	200	2025-11-07 18:23:38.146702
2452	7	/api/clients	GET	200	2025-11-07 18:23:54.390857
2453	7	/api/clients	GET	200	2025-11-07 18:23:54.391403
2454	7	/api/products	GET	200	2025-11-07 18:23:54.392407
2455	7	/api/orders	GET	200	2025-11-07 18:23:54.39378
2456	7	/api/orders	GET	200	2025-11-07 18:23:54.395309
2457	7	/api/products	GET	200	2025-11-07 18:23:54.396057
2458	7	/api/products	GET	200	2025-11-07 18:23:58.633196
2459	7	/api/products	GET	200	2025-11-07 18:23:58.634182
2460	7	/api/clients	GET	200	2025-11-07 18:24:01.843424
2461	7	/api/products	GET	200	2025-11-07 18:24:01.844064
2462	7	/api/orders	GET	200	2025-11-07 18:24:01.844638
2463	7	/api/clients	GET	200	2025-11-07 18:24:01.845325
2464	7	/api/products	GET	200	2025-11-07 18:24:01.84878
2465	7	/api/orders	GET	200	2025-11-07 18:24:01.852469
2466	7	/api/orders/14	PUT	200	2025-11-07 18:24:10.466323
2467	7	/api/orders	GET	200	2025-11-07 18:24:10.473585
2468	7	/api/clients	GET	200	2025-11-07 18:27:42.194689
2469	7	/api/products	GET	200	2025-11-07 18:27:42.252221
2470	7	/api/clients	GET	200	2025-11-07 18:27:42.257388
2471	7	/api/orders	GET	200	2025-11-07 18:27:42.258768
2472	7	/api/products	GET	200	2025-11-07 18:27:42.260164
2473	7	/api/orders	GET	200	2025-11-07 18:27:42.261774
2474	7	/api/orders/14	PUT	500	2025-11-07 18:27:49.655196
2475	7	/api/clients	GET	200	2025-11-07 18:29:10.320142
2476	7	/api/products	GET	200	2025-11-07 18:29:10.321468
2477	7	/api/orders	GET	200	2025-11-07 18:29:10.32678
2478	7	/api/clients	GET	200	2025-11-07 18:29:10.328822
2479	7	/api/orders	GET	200	2025-11-07 18:29:10.330368
2480	7	/api/products	GET	200	2025-11-07 18:29:10.331248
2481	7	/api/orders/14	PUT	500	2025-11-07 18:29:18.565457
2482	7	/api/products	GET	200	2025-11-07 18:29:40.337509
2483	7	/api/products	GET	200	2025-11-07 18:29:40.338348
2484	7	/api/products	GET	200	2025-11-07 18:31:54.0059
2485	7	/api/products	GET	200	2025-11-07 18:31:54.042349
2486	7	/api/clients	GET	200	2025-11-07 18:31:56.090044
2487	7	/api/products	GET	200	2025-11-07 18:31:56.090909
2488	7	/api/clients	GET	200	2025-11-07 18:31:56.135822
2489	7	/api/products	GET	200	2025-11-07 18:31:56.136933
2490	7	/api/orders	GET	200	2025-11-07 18:31:56.13866
2491	7	/api/orders	GET	200	2025-11-07 18:31:56.1395
2492	7	/api/orders/13	PUT	500	2025-11-07 18:32:05.337791
2493	7	/api/products	GET	200	2025-11-07 18:32:21.197038
2494	7	/api/products	GET	200	2025-11-07 18:32:21.197727
2495	7	/api/products	GET	200	2025-11-07 18:33:16.855333
2496	7	/api/products	GET	200	2025-11-07 18:33:16.889087
2497	7	/api/users	GET	200	2025-11-07 18:33:17.805861
2498	7	/api/users	GET	200	2025-11-07 18:33:17.808175
2499	7	/api/clients	GET	200	2025-11-07 18:33:19.816124
2500	7	/api/products	GET	200	2025-11-07 18:33:19.816795
2501	7	/api/clients	GET	200	2025-11-07 18:33:19.861568
2502	7	/api/products	GET	200	2025-11-07 18:33:19.862203
2503	7	/api/orders	GET	200	2025-11-07 18:33:19.987833
2504	7	/api/orders	GET	200	2025-11-07 18:33:19.988862
2505	7	/api/clients	GET	200	2025-11-07 18:33:32.922245
2506	7	/api/clients	GET	200	2025-11-07 18:33:32.923222
2507	7	/api/users	GET	200	2025-11-07 18:33:36.037585
2508	7	/api/users	GET	200	2025-11-07 18:33:36.039001
2509	7	/api/products	GET	200	2025-11-07 18:33:38.799809
2510	7	/api/products	GET	200	2025-11-07 18:33:38.800878
2511	7	/api/clients	GET	200	2025-11-07 18:33:39.150817
2512	7	/api/products	GET	200	2025-11-07 18:33:39.151604
2513	7	/api/clients	GET	200	2025-11-07 18:33:39.196731
2514	7	/api/orders	GET	200	2025-11-07 18:33:39.199006
2515	7	/api/products	GET	200	2025-11-07 18:33:39.199744
2516	7	/api/orders	GET	200	2025-11-07 18:33:39.200694
2517	7	/api/clients	GET	200	2025-11-07 18:33:45.383932
2518	7	/api/products	GET	200	2025-11-07 18:33:45.385959
2519	7	/api/orders	GET	200	2025-11-07 18:33:45.386643
2520	7	/api/clients	GET	200	2025-11-07 18:33:45.387205
2521	7	/api/products	GET	200	2025-11-07 18:33:45.387708
2522	7	/api/orders	GET	200	2025-11-07 18:33:45.388198
2523	7	/api/orders	POST	201	2025-11-07 18:33:53.533444
2524	7	/api/orders	GET	200	2025-11-07 18:33:53.540489
2525	7	/api/products	GET	200	2025-11-07 18:33:58.013097
2526	7	/api/products	GET	200	2025-11-07 18:33:58.013503
2527	7	/api/clients	GET	200	2025-11-07 18:34:00.754519
2528	7	/api/products	GET	200	2025-11-07 18:34:00.755021
2529	7	/api/orders	GET	200	2025-11-07 18:34:00.79901
2530	7	/api/clients	GET	200	2025-11-07 18:34:00.799643
2531	7	/api/products	GET	200	2025-11-07 18:34:00.801874
2532	7	/api/orders	GET	200	2025-11-07 18:34:00.803882
2533	7	/api/orders/15	PUT	500	2025-11-07 18:34:12.275556
2534	7	/api/products	GET	200	2025-11-07 18:34:20.430498
2535	7	/api/products	GET	200	2025-11-07 18:34:20.462929
2536	7	/api/clients	GET	200	2025-11-07 18:34:22.711213
2537	7	/api/products	GET	200	2025-11-07 18:34:22.71178
2538	7	/api/products	GET	200	2025-11-07 18:34:22.755461
2539	7	/api/orders	GET	200	2025-11-07 18:34:22.756058
2540	7	/api/orders	GET	200	2025-11-07 18:34:22.75867
2541	7	/api/clients	GET	200	2025-11-07 18:34:22.847449
2542	7	/api/clients	GET	200	2025-11-07 18:34:49.765904
2543	7	/api/products	GET	200	2025-11-07 18:34:49.766381
2544	7	/api/clients	GET	200	2025-11-07 18:34:49.81097
2545	7	/api/orders	GET	200	2025-11-07 18:34:49.812709
2546	7	/api/orders	GET	200	2025-11-07 18:34:49.814847
2547	7	/api/products	GET	200	2025-11-07 18:34:49.815586
2548	7	/api/clients	GET	200	2025-11-07 18:35:34.331455
2549	7	/api/clients	GET	200	2025-11-07 18:35:34.331937
2550	7	/api/products	GET	200	2025-11-07 18:35:34.337517
2551	7	/api/products	GET	200	2025-11-07 18:35:34.338085
2552	7	/api/orders	GET	200	2025-11-07 18:35:34.339421
2553	7	/api/orders	GET	200	2025-11-07 18:35:34.340903
2554	7	/api/clients	GET	200	2025-11-07 18:38:36.548086
2555	7	/api/products	GET	200	2025-11-07 18:38:36.595043
2556	7	/api/clients	GET	200	2025-11-07 18:38:36.596227
2557	7	/api/orders	GET	200	2025-11-07 18:38:36.597761
2558	7	/api/products	GET	200	2025-11-07 18:38:36.598646
2559	7	/api/orders	GET	200	2025-11-07 18:38:36.601713
2560	7	/api/orders	POST	201	2025-11-07 18:39:31.423048
2561	7	/api/orders	GET	200	2025-11-07 18:39:31.43147
2562	7	/api/clients	GET	200	2025-11-07 18:39:35.149925
2563	7	/api/products	GET	200	2025-11-07 18:39:35.15046
2564	7	/api/clients	GET	200	2025-11-07 18:39:35.190541
2565	7	/api/products	GET	200	2025-11-07 18:39:35.192661
2566	7	/api/orders	GET	200	2025-11-07 18:39:35.194655
2567	7	/api/orders	GET	200	2025-11-07 18:39:35.297867
2568	7	/api/orders/16	PUT	200	2025-11-07 18:39:42.11693
2569	7	/api/orders	GET	200	2025-11-07 18:39:42.124151
2570	7	/api/products	GET	200	2025-11-07 18:39:50.773542
2571	7	/api/products	GET	200	2025-11-07 18:39:50.774326
2572	7	/api/clients	GET	200	2025-11-07 18:39:55.633608
2573	7	/api/products	GET	200	2025-11-07 18:39:55.634092
2574	7	/api/clients	GET	200	2025-11-07 18:39:55.679376
2575	7	/api/products	GET	200	2025-11-07 18:39:55.680931
2576	7	/api/orders	GET	200	2025-11-07 18:39:55.682762
2577	7	/api/orders	GET	200	2025-11-07 18:39:55.684873
2578	7	/api/orders/16	PUT	200	2025-11-07 18:40:02.752914
2579	7	/api/orders	GET	200	2025-11-07 18:40:02.760015
2580	7	/api/users	GET	200	2025-11-07 18:40:03.910905
2581	7	/api/users	GET	200	2025-11-07 18:40:03.912893
2582	7	/api/products	GET	200	2025-11-07 18:40:05.312403
2583	7	/api/products	GET	200	2025-11-07 18:40:05.313391
2584	7	/api/clients	GET	200	2025-11-07 18:40:07.463991
2585	7	/api/products	GET	200	2025-11-07 18:40:07.46454
2586	7	/api/clients	GET	200	2025-11-07 18:40:07.507846
2587	7	/api/orders	GET	200	2025-11-07 18:40:07.51318
2588	7	/api/products	GET	200	2025-11-07 18:40:07.51376
2589	7	/api/orders	GET	200	2025-11-07 18:40:07.514828
2590	7	/api/orders/16	PUT	200	2025-11-07 18:40:18.567504
2591	7	/api/orders	GET	200	2025-11-07 18:40:18.577064
2592	7	/api/products	GET	200	2025-11-07 18:40:21.265202
2593	7	/api/products	GET	200	2025-11-07 18:40:21.266586
2594	7	/api/clients	GET	200	2025-11-07 18:40:26.278782
2595	7	/api/products	GET	200	2025-11-07 18:40:26.279301
2596	7	/api/clients	GET	200	2025-11-07 18:40:26.321163
2597	7	/api/orders	GET	200	2025-11-07 18:40:26.323232
2598	7	/api/orders	GET	200	2025-11-07 18:40:26.324113
2599	7	/api/products	GET	200	2025-11-07 18:40:26.414422
2600	7	/api/orders/16	PUT	200	2025-11-07 18:40:45.969801
2601	7	/api/orders	GET	200	2025-11-07 18:40:45.978432
2602	7	/api/products	GET	200	2025-11-07 18:40:50.363976
2603	7	/api/products	GET	200	2025-11-07 18:40:50.366185
2604	7	/api/clients	GET	200	2025-11-07 18:40:55.387809
2605	7	/api/products	GET	200	2025-11-07 18:40:55.388319
2606	7	/api/clients	GET	200	2025-11-07 18:40:55.451503
2607	7	/api/products	GET	200	2025-11-07 18:40:55.453469
2608	7	/api/orders	GET	200	2025-11-07 18:40:55.457911
2609	7	/api/orders	GET	200	2025-11-07 18:40:55.458457
2610	7	/api/clients	GET	200	2025-11-07 18:42:01.310435
2611	7	/api/products	GET	200	2025-11-07 18:42:01.311273
2612	7	/api/clients	GET	200	2025-11-07 18:42:01.313147
2613	7	/api/orders	GET	200	2025-11-07 18:42:01.316219
2614	7	/api/products	GET	200	2025-11-07 18:42:01.318456
2615	7	/api/orders	GET	200	2025-11-07 18:42:01.320924
2616	7	/api/clients	GET	200	2025-11-07 18:43:44.767927
2617	7	/api/clients	GET	200	2025-11-07 18:43:44.770042
2618	7	/api/products	GET	200	2025-11-07 18:43:44.771414
2619	7	/api/orders	GET	200	2025-11-07 18:43:44.774195
2620	7	/api/products	GET	200	2025-11-07 18:43:44.777261
2621	7	/api/orders	GET	200	2025-11-07 18:43:44.857169
2622	7	/api/products	GET	200	2025-11-07 18:44:01.358643
2623	7	/api/products	GET	200	2025-11-07 18:44:01.359177
2624	7	/api/clients	GET	200	2025-11-07 18:44:05.58908
2625	7	/api/products	GET	200	2025-11-07 18:44:05.58964
2626	7	/api/clients	GET	200	2025-11-07 18:44:05.631626
2627	7	/api/orders	GET	200	2025-11-07 18:44:05.632643
2628	7	/api/products	GET	200	2025-11-07 18:44:05.633259
2629	7	/api/orders	GET	200	2025-11-07 18:44:05.72911
2630	7	/api/orders/16	PUT	200	2025-11-07 18:44:18.544301
2631	7	/api/orders	GET	200	2025-11-07 18:44:18.552835
2632	7	/api/products	GET	200	2025-11-07 18:44:26.458164
2633	7	/api/products	GET	200	2025-11-07 18:44:26.459654
2634	7	/api/clients	GET	200	2025-11-07 18:44:32.274361
2635	7	/api/products	GET	200	2025-11-07 18:44:32.276837
2636	7	/api/clients	GET	200	2025-11-07 18:44:32.321472
2637	7	/api/products	GET	200	2025-11-07 18:44:32.322549
2638	7	/api/orders	GET	200	2025-11-07 18:44:32.324023
2639	7	/api/orders	GET	200	2025-11-07 18:44:32.326051
2640	7	/api/orders/16	PUT	200	2025-11-07 18:44:39.17917
2641	7	/api/orders	GET	200	2025-11-07 18:44:39.18633
2642	7	/api/products	GET	200	2025-11-07 18:44:40.672267
2643	7	/api/products	GET	200	2025-11-07 18:44:40.672857
2644	7	/api/products	GET	200	2025-11-07 18:45:04.922573
2645	7	/api/products	GET	200	2025-11-07 18:45:04.923018
2646	7	/api/clients	GET	200	2025-11-07 18:45:06.626125
2647	7	/api/products	GET	200	2025-11-07 18:45:06.626867
2648	7	/api/clients	GET	200	2025-11-07 18:45:06.670446
2649	7	/api/products	GET	200	2025-11-07 18:45:06.673516
2650	7	/api/orders	GET	200	2025-11-07 18:45:06.675156
2651	7	/api/orders	GET	200	2025-11-07 18:45:06.677511
2652	7	/api/clients	GET	200	2025-11-07 18:47:29.426313
2653	7	/api/products	GET	200	2025-11-07 18:47:29.427947
2654	7	/api/orders	GET	200	2025-11-07 18:47:29.429562
2655	7	/api/clients	GET	200	2025-11-07 18:47:29.432363
2656	7	/api/products	GET	200	2025-11-07 18:47:29.433334
2657	7	/api/orders	GET	200	2025-11-07 18:47:29.434835
2658	7	/api/clients	GET	200	2025-11-07 18:47:31.343886
2659	7	/api/products	GET	200	2025-11-07 18:47:31.34776
2660	7	/api/clients	GET	200	2025-11-07 18:47:31.348259
2661	7	/api/orders	GET	200	2025-11-07 18:47:31.349049
2662	7	/api/products	GET	200	2025-11-07 18:47:31.349709
2663	7	/api/orders	GET	200	2025-11-07 18:47:31.351745
2664	7	/api/clients	GET	200	2025-11-07 18:47:58.42253
2665	7	/api/clients	GET	200	2025-11-07 18:47:58.433677
2666	7	/api/orders	GET	200	2025-11-07 18:47:58.437834
2667	7	/api/products	GET	200	2025-11-07 18:47:58.438268
2668	7	/api/orders	GET	200	2025-11-07 18:47:58.440076
2669	7	/api/products	GET	200	2025-11-07 18:47:58.52623
2670	7	/api/clients	GET	200	2025-11-07 18:48:00.363852
2671	7	/api/products	GET	200	2025-11-07 18:48:00.364399
2672	7	/api/clients	GET	200	2025-11-07 18:48:00.364964
2673	7	/api/orders	GET	200	2025-11-07 18:48:00.365889
2674	7	/api/products	GET	200	2025-11-07 18:48:00.366751
2675	7	/api/orders	GET	200	2025-11-07 18:48:00.368539
2676	7	/api/clients	GET	200	2025-11-07 18:49:25.673195
2677	7	/api/products	GET	200	2025-11-07 18:49:25.676548
2678	7	/api/clients	GET	200	2025-11-07 18:49:25.679026
2679	7	/api/orders	GET	200	2025-11-07 18:49:25.682748
2680	7	/api/products	GET	200	2025-11-07 18:49:25.685265
2681	7	/api/orders	GET	200	2025-11-07 18:49:25.687306
2682	7	/api/clients	GET	200	2025-11-07 18:49:27.18738
2683	7	/api/clients	GET	200	2025-11-07 18:49:27.188041
2684	7	/api/products	GET	200	2025-11-07 18:49:27.188609
2685	7	/api/orders	GET	200	2025-11-07 18:49:27.189406
2686	7	/api/products	GET	200	2025-11-07 18:49:27.19024
2687	7	/api/orders	GET	200	2025-11-07 18:49:27.192303
2688	7	/api/clients	GET	200	2025-11-07 18:49:28.296625
2689	7	/api/products	GET	200	2025-11-07 18:49:28.305494
2690	7	/api/clients	GET	200	2025-11-07 18:49:28.306465
2691	7	/api/products	GET	200	2025-11-07 18:49:28.307705
2692	7	/api/orders	GET	200	2025-11-07 18:49:28.308312
2693	7	/api/orders	GET	200	2025-11-07 18:49:28.308948
2694	7	/api/orders/16	PUT	200	2025-11-07 18:49:48.888965
2695	7	/api/orders	GET	200	2025-11-07 18:49:48.898653
2696	7	/api/products	GET	200	2025-11-07 18:49:52.096387
2697	7	/api/products	GET	200	2025-11-07 18:49:52.097642
2698	7	/api/clients	GET	200	2025-11-07 18:49:57.05638
2699	7	/api/products	GET	200	2025-11-07 18:49:57.056763
2700	7	/api/clients	GET	200	2025-11-07 18:49:57.100108
2701	7	/api/products	GET	200	2025-11-07 18:49:57.100568
2702	7	/api/orders	GET	200	2025-11-07 18:49:57.10325
2703	7	/api/orders	GET	200	2025-11-07 18:49:57.104601
2704	7	/api/orders/16	PUT	200	2025-11-07 18:50:02.607254
2705	7	/api/orders	GET	200	2025-11-07 18:50:02.613915
2706	7	/api/products	GET	200	2025-11-07 18:50:03.876922
2707	7	/api/products	GET	200	2025-11-07 18:50:03.877631
2708	7	/api/clients	GET	200	2025-11-07 18:50:06.075688
2709	7	/api/products	GET	200	2025-11-07 18:50:06.076414
2710	7	/api/clients	GET	200	2025-11-07 18:50:06.077026
2711	7	/api/orders	GET	200	2025-11-07 18:50:06.077664
2712	7	/api/products	GET	200	2025-11-07 18:50:06.078109
2713	7	/api/orders	GET	200	2025-11-07 18:50:06.079015
2714	7	/api/orders/16	PUT	200	2025-11-07 18:50:11.329486
2715	7	/api/orders	GET	200	2025-11-07 18:50:11.336743
2716	7	/api/products	GET	200	2025-11-07 18:50:13.576626
2717	7	/api/products	GET	200	2025-11-07 18:50:13.57723
2718	7	/api/clients	GET	200	2025-11-07 18:50:22.73763
2719	7	/api/clients	GET	200	2025-11-07 18:50:22.738241
2720	7	/api/products	GET	200	2025-11-07 18:50:22.781992
2721	7	/api/orders	GET	200	2025-11-07 18:50:22.78386
2722	7	/api/products	GET	200	2025-11-07 18:50:22.784596
2723	7	/api/orders	GET	200	2025-11-07 18:50:22.788241
2724	7	/api/orders/16	PUT	200	2025-11-07 18:50:32.831408
2725	7	/api/orders	GET	200	2025-11-07 18:50:32.837899
2726	7	/api/products	GET	200	2025-11-07 18:50:33.855776
2727	7	/api/products	GET	200	2025-11-07 18:50:33.8572
2728	7	/api/products	GET	200	2025-11-07 18:51:59.3888
2729	7	/api/products	GET	200	2025-11-07 18:51:59.389246
2730	7	/api/products	GET	200	2025-11-07 18:52:51.357068
2731	7	/api/products	GET	200	2025-11-07 18:52:51.357511
2732	7	/api/clients	GET	200	2025-11-07 18:53:51.14182
2733	7	/api/products	GET	200	2025-11-07 18:53:51.142585
2734	7	/api/orders	GET	200	2025-11-07 18:53:51.147803
2735	7	/api/clients	GET	200	2025-11-07 18:53:51.148319
2736	7	/api/products	GET	200	2025-11-07 18:53:51.149674
2737	7	/api/orders	GET	200	2025-11-07 18:53:51.15334
2738	7	/api/clients	GET	200	2025-11-07 18:55:27.372117
2739	7	/api/products	GET	200	2025-11-07 18:55:27.373091
2740	7	/api/orders	GET	200	2025-11-07 18:55:27.37539
2741	7	/api/clients	GET	200	2025-11-07 18:55:27.377443
2742	7	/api/products	GET	200	2025-11-07 18:55:27.378713
2743	7	/api/orders	GET	200	2025-11-07 18:55:27.470915
2744	7	/api/clients	GET	200	2025-11-07 18:55:32.474544
2745	7	/api/products	GET	200	2025-11-07 18:55:32.483957
2746	7	/api/clients	GET	200	2025-11-07 18:55:32.485145
2747	7	/api/orders	GET	200	2025-11-07 18:55:32.486007
2748	7	/api/products	GET	200	2025-11-07 18:55:32.486866
2749	7	/api/orders	GET	200	2025-11-07 18:55:32.488528
2750	7	/api/clients	GET	200	2025-11-07 18:55:42.011329
2751	7	/api/products	GET	200	2025-11-07 18:55:42.022608
2752	7	/api/clients	GET	200	2025-11-07 18:55:42.02322
2753	7	/api/orders	GET	200	2025-11-07 18:55:42.02428
2754	7	/api/products	GET	200	2025-11-07 18:55:42.02492
2755	7	/api/orders	GET	200	2025-11-07 18:55:42.025625
2756	7	/api/products	GET	200	2025-11-07 18:55:58.612622
2757	7	/api/orders	GET	200	2025-11-07 18:55:58.613472
2758	7	/api/clients	GET	200	2025-11-07 18:55:58.619058
2759	7	/api/products	GET	200	2025-11-07 18:55:58.620831
2760	7	/api/clients	GET	200	2025-11-07 18:55:58.747546
2761	7	/api/orders	GET	200	2025-11-07 18:55:58.749679
2762	7	/api/clients	GET	200	2025-11-07 18:55:59.911729
2763	7	/api/products	GET	200	2025-11-07 18:55:59.925159
2764	7	/api/clients	GET	200	2025-11-07 18:55:59.925695
2765	7	/api/orders	GET	200	2025-11-07 18:55:59.926295
2766	7	/api/products	GET	200	2025-11-07 18:55:59.926963
2767	7	/api/orders	GET	200	2025-11-07 18:55:59.927793
2768	7	/api/clients	GET	200	2025-11-07 18:56:01.293695
2769	7	/api/products	GET	200	2025-11-07 18:56:01.294123
2770	7	/api/orders	GET	200	2025-11-07 18:56:01.294876
2771	7	/api/clients	GET	200	2025-11-07 18:56:01.295676
2772	7	/api/products	GET	200	2025-11-07 18:56:01.296936
4077	7	/api/products	GET	304	2025-11-10 18:18:57.770608
4080	7	/api/auth/me	GET	304	2025-11-10 18:18:59.676357
4081	7	/api/products	GET	304	2025-11-10 18:18:59.690171
4084	7	/api/auth/me	GET	304	2025-11-10 18:19:03.707654
4085	7	/api/products	GET	304	2025-11-10 18:19:03.721791
4088	7	/api/auth/me	GET	304	2025-11-10 18:19:09.701279
4090	7	/api/products	GET	304	2025-11-10 18:19:09.749092
4091	7	/api/clients	GET	304	2025-11-10 18:19:17.512167
4151	7	/api/products	GET	304	2025-11-10 18:28:19.822934
4161	7	/api/clients	GET	304	2025-11-10 18:28:25.395594
4172	7	/api/orders	GET	304	2025-11-10 18:28:32.785084
4182	7	/api/clients	GET	304	2025-11-10 18:28:40.182932
4284	7	/api/orders	GET	304	2025-11-10 18:34:40.009579
4287	7	/api/auth/me	GET	200	2025-11-10 18:34:48.461153
4288	7	/api/clients	GET	304	2025-11-10 18:34:48.480665
4292	7	/api/products	GET	304	2025-11-10 18:34:48.487857
4429	7	/api/products	GET	304	2025-11-10 18:41:41.833673
4430	7	/api/products	GET	304	2025-11-10 18:41:43.406072
4593	7	/api/clients	GET	304	2025-11-10 18:46:17.345249
4603	7	/api/clients	GET	304	2025-11-10 18:46:20.240622
4612	7	/api/clients	GET	304	2025-11-10 18:46:25.183805
4668	7	/api/clients	GET	304	2025-11-11 16:29:35.993639
4745	7	/api/auth/me	GET	304	2025-11-11 16:57:46.892231
4747	7	/api/auth/me	GET	200	2025-11-11 16:57:49.888387
4801	7	/api/orders	GET	304	2025-11-12 15:50:58.8919
4804	7	/api/users	GET	304	2025-11-12 15:51:05.619071
4812	\N	/api/auth/login	POST	200	2026-03-12 15:49:26.857543
4922	7	/api/products	GET	304	2026-03-12 17:16:27.471633
4924	7	/api/orders	GET	304	2026-03-12 17:16:27.479699
4925	7	/api/users	GET	304	2026-03-12 17:16:28.234073
4928	7	/api/products	GET	304	2026-03-12 17:16:29.311576
4984	7	/api/auth/me	GET	304	2026-03-12 18:52:09.918407
4985	7	/api/products	GET	304	2026-03-12 18:52:10.966558
4988	7	/api/clients	GET	304	2026-03-12 18:52:12.046078
4998	7	/api/clients	GET	304	2026-03-12 18:52:18.841166
5083	7	/api/products	GET	304	2026-03-12 19:03:30.087157
5152	7	/api/auth/me	GET	304	2026-03-12 21:00:12.152599
5226	7	/api/clients	GET	304	2026-03-12 21:18:10.487906
5235	7	/api/orders	GET	304	2026-03-12 21:18:13.820816
5239	7	/api/products	GET	304	2026-03-12 21:18:15.01814
5240	7	/api/clients	GET	304	2026-03-12 21:18:15.428591
5243	7	/api/auth/me	GET	304	2026-03-12 21:18:17.273668
5244	7	/api/auth/me	GET	200	2026-03-12 21:18:19.852593
5247	7	/api/auth/me	GET	200	2026-03-12 21:18:21.562066
5248	7	/api/clients	GET	304	2026-03-12 21:18:29.791284
5251	7	/api/products	GET	304	2026-03-12 21:18:31.421309
5252	7	/api/clients	GET	304	2026-03-12 21:18:31.842607
5264	7	/api/products	GET	304	2026-03-12 21:18:33.214239
5275	7	/api/products	GET	304	2026-03-12 21:18:35.725644
5358	7	/api/auth/me	GET	304	2026-03-12 21:29:49.722396
5359	7	/api/auth/me	GET	200	2026-03-12 21:29:51.880308
5362	7	/api/products	GET	304	2026-03-12 21:29:51.922009
5363	7	/api/clients	GET	304	2026-03-12 21:29:56.611637
5366	7	/api/products	GET	304	2026-03-12 21:29:57.444001
5367	7	/api/clients	GET	304	2026-03-12 21:29:58.093591
5477	7	/api/auth/me	GET	304	2026-03-13 13:45:52.103864
5480	7	/api/auth/me	GET	200	2026-03-13 13:45:53.360528
5558	7	/api/clients	GET	304	2026-03-13 13:59:04.74217
5559	7	/api/users	GET	304	2026-03-13 13:59:07.279306
5562	7	/api/products	GET	304	2026-03-13 13:59:08.485422
5625	7	/api/auth/me	GET	200	2026-03-13 14:21:03.085067
5674	7	/api/clients	GET	200	2026-03-13 14:28:58.508071
5675	7	/api/users	GET	200	2026-03-13 14:28:59.478056
5679	7	/api/orders	GET	200	2026-03-13 14:28:59.916422
5807	\N	/api/users	GET	401	2026-03-17 20:49:18.330935
5898	7	/api/products	GET	200	2026-03-17 21:16:38.435047
5901	7	/api/users	GET	200	2026-03-17 21:16:38.913419
5902	7	/api/summary	GET	200	2026-03-17 21:16:39.507968
5997	7	/api/clients	GET	200	2026-03-17 21:47:57.260915
5998	7	/api/products	GET	200	2026-03-17 21:47:58.46138
6100	\N	/api/suppliers	GET	404	2026-03-18 15:37:47.611923
6103	7	/api/summary	GET	200	2026-03-18 15:37:51.96545
6104	\N	/api/suppliers	GET	404	2026-03-18 15:37:52.749139
6169	7	/api/suppliers	POST	201	2026-03-18 16:00:09.129029
6170	7	/api/suppliers	GET	200	2026-03-18 16:00:09.134039
6235	7	/api/clients	POST	201	2026-03-18 16:17:41.426799
6236	7	/api/clients	GET	200	2026-03-18 16:17:41.431732
6237	7	/api/summary	GET	200	2026-03-18 16:17:42.908617
6294	7	/api/summary	GET	200	2026-03-18 16:21:56.132274
6295	7	/api/clients	GET	200	2026-03-18 16:22:03.937283
6376	7	/api/clients	GET	200	2026-03-18 16:36:10.85864
6457	7	/api/financial	POST	201	2026-03-18 17:14:40.802291
6458	7	/api/financial?	GET	200	2026-03-18 17:14:40.810789
6459	7	/api/summary	GET	200	2026-03-18 17:14:43.36865
6550	7	/api/summary	GET	200	2026-03-18 17:37:43.26863
6551	7	/api/auth/me	GET	200	2026-03-18 17:37:45.369305
6554	7	/api/summary	GET	200	2026-03-18 17:37:45.425358
6555	7	/api/auth/me	GET	200	2026-03-18 17:37:50.192897
6558	7	/api/summary	GET	200	2026-03-18 17:37:50.256203
6634	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-18	GET	200	2026-03-18 18:01:15.447027
6641	7	/api/financial?	GET	200	2026-03-18 18:01:17.453723
6697	7	/api/financial?status=vencido	GET	200	2026-03-18 18:24:35.688689
6701	7	/api/financial/categories	GET	200	2026-03-18 18:24:35.702048
6708	7	/api/suppliers	GET	200	2026-03-18 18:24:36.948942
6768	7	/api/suppliers	GET	200	2026-03-18 21:24:53.537946
6777	7	/api/summary	GET	200	2026-03-18 21:24:59.932205
6778	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:24:59.945551
6781	7	/api/purchase-orders	GET	200	2026-03-18 21:24:59.963258
6854	7	/api/summary	GET	200	2026-03-18 21:38:32.201339
6855	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:38:32.213722
6942	7	/api/suppliers	GET	200	2026-03-18 21:42:13.346197
6947	7	/api/financial?	GET	200	2026-03-18 21:42:21.271805
6950	7	/api/auth/me	GET	200	2026-03-18 21:42:28.671677
6953	7	/api/summary	GET	200	2026-03-18 21:42:28.711969
6954	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:42:28.722674
6958	7	/api/financial/categories	GET	200	2026-03-18 21:42:28.773377
7032	7	/api/summary	GET	200	2026-03-18 21:48:27.450073
7091	7	/api/financial/categories	GET	200	2026-03-18 21:52:19.270467
7093	7	/api/financial?	GET	200	2026-03-18 21:52:19.281495
7095	7	/api/clients	GET	200	2026-03-18 21:52:20.112668
7146	7	/api/financial?status=vencido	GET	200	2026-03-19 15:52:50.770198
7202	7	/api/financial?status=vencido	GET	200	2026-03-19 15:59:55.323615
7203	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:59:55.32981
7245	7	/api/summary	GET	200	2026-03-19 16:10:34.372459
2773	7	/api/orders	GET	200	2025-11-07 18:56:01.298371
2774	7	/api/clients	GET	200	2025-11-07 18:56:34.512247
2775	7	/api/products	GET	200	2025-11-07 18:56:34.512822
2776	7	/api/clients	GET	200	2025-11-07 18:56:34.514598
2777	7	/api/products	GET	200	2025-11-07 18:56:34.519208
2778	7	/api/orders	GET	200	2025-11-07 18:56:34.519804
2779	7	/api/orders	GET	200	2025-11-07 18:56:34.520716
2780	7	/api/clients	GET	200	2025-11-07 18:56:36.323817
2781	7	/api/products	GET	200	2025-11-07 18:56:36.333117
2782	7	/api/clients	GET	200	2025-11-07 18:56:36.333937
2783	7	/api/orders	GET	200	2025-11-07 18:56:36.334943
2784	7	/api/products	GET	200	2025-11-07 18:56:36.33584
2785	7	/api/orders	GET	200	2025-11-07 18:56:36.337271
2786	7	/api/clients	GET	200	2025-11-07 18:56:43.337559
2787	7	/api/clients	GET	200	2025-11-07 18:56:43.338612
2788	7	/api/products	GET	200	2025-11-07 18:56:43.339989
2789	7	/api/orders	GET	200	2025-11-07 18:56:43.340725
2790	7	/api/products	GET	200	2025-11-07 18:56:43.343331
2791	7	/api/orders	GET	200	2025-11-07 18:56:43.344003
2792	7	/api/clients	GET	200	2025-11-07 18:56:56.450196
2793	7	/api/products	GET	200	2025-11-07 18:56:56.455788
2794	7	/api/products	GET	200	2025-11-07 18:56:56.456289
2795	7	/api/orders	GET	200	2025-11-07 18:56:56.458195
2796	7	/api/orders	GET	200	2025-11-07 18:56:56.459326
2797	7	/api/clients	GET	200	2025-11-07 18:56:56.571565
2798	7	/api/products	GET	200	2025-11-07 18:58:53.45899
2799	7	/api/clients	GET	200	2025-11-07 18:58:53.460842
2800	7	/api/products	GET	200	2025-11-07 18:58:53.462204
2801	7	/api/orders	GET	200	2025-11-07 18:58:53.463744
2802	7	/api/orders	GET	200	2025-11-07 18:58:53.466775
2803	7	/api/clients	GET	200	2025-11-07 18:58:53.551585
2804	7	/api/clients	GET	200	2025-11-07 19:00:41.42041
2805	7	/api/products	GET	200	2025-11-07 19:00:41.424105
2806	7	/api/clients	GET	200	2025-11-07 19:00:41.427222
2807	7	/api/products	GET	200	2025-11-07 19:00:41.430949
2808	7	/api/orders	GET	200	2025-11-07 19:00:41.432501
2809	7	/api/orders	GET	200	2025-11-07 19:00:41.436144
2810	7	/api/clients	GET	200	2025-11-07 19:00:42.374994
2811	7	/api/products	GET	200	2025-11-07 19:00:42.381855
2812	7	/api/clients	GET	200	2025-11-07 19:00:42.382516
2813	7	/api/orders	GET	200	2025-11-07 19:00:42.383923
2814	7	/api/products	GET	200	2025-11-07 19:00:42.38452
2815	7	/api/orders	GET	200	2025-11-07 19:00:42.385518
2816	7	/api/clients	GET	200	2025-11-07 19:00:44.366808
2817	7	/api/clients	GET	200	2025-11-07 19:00:44.368239
2818	7	/api/products	GET	200	2025-11-07 19:00:44.36884
2819	7	/api/orders	GET	200	2025-11-07 19:00:44.369774
2820	7	/api/products	GET	200	2025-11-07 19:00:44.370595
2821	7	/api/orders	GET	200	2025-11-07 19:00:44.371413
2822	\N	/api/orders/16	PUT	401	2025-11-07 19:01:20.738118
2823	\N	/api/users	GET	401	2025-11-07 19:01:38.057541
2824	\N	/api/users	GET	401	2025-11-07 19:01:38.058531
2825	\N	/api/clients	GET	401	2025-11-07 19:01:39.601312
2826	\N	/api/products	GET	401	2025-11-07 19:01:39.604627
2827	\N	/api/clients	GET	401	2025-11-07 19:01:39.660638
2828	\N	/api/orders	GET	401	2025-11-07 19:01:39.662469
2829	\N	/api/orders	GET	401	2025-11-07 19:01:39.664245
2830	\N	/api/products	GET	401	2025-11-07 19:01:39.664289
2831	\N	/api/products	GET	401	2025-11-07 19:01:41.011418
2832	\N	/api/products	GET	401	2025-11-07 19:01:41.014938
2833	\N	/api/products	GET	401	2025-11-07 19:01:45.728431
2834	\N	/api/products	GET	401	2025-11-07 19:01:45.732158
2835	\N	/api/products	GET	401	2025-11-07 19:01:46.921071
2836	\N	/api/products	GET	401	2025-11-07 19:01:46.925391
2837	\N	/api/auth/login	POST	200	2025-11-07 19:02:04.116123
2839	7	/api/clients	GET	200	2025-11-07 19:02:08.079836
2838	7	/api/clients	GET	200	2025-11-07 19:02:08.079185
2840	7	/api/products	GET	200	2025-11-07 19:02:08.642586
2841	7	/api/products	GET	200	2025-11-07 19:02:08.643508
2842	7	/api/clients	GET	200	2025-11-07 19:02:09.836899
2843	7	/api/products	GET	200	2025-11-07 19:02:09.837319
2844	7	/api/clients	GET	200	2025-11-07 19:02:09.881987
2845	7	/api/orders	GET	200	2025-11-07 19:02:09.882524
2846	7	/api/products	GET	200	2025-11-07 19:02:09.883077
2847	7	/api/orders	GET	200	2025-11-07 19:02:09.885658
2848	7	/api/users	GET	200	2025-11-07 19:02:14.851766
2849	7	/api/users	GET	200	2025-11-07 19:02:14.853191
2850	7	/api/clients	GET	200	2025-11-07 19:02:15.472405
2851	7	/api/products	GET	200	2025-11-07 19:02:15.472917
2852	7	/api/orders	GET	200	2025-11-07 19:02:15.473538
2853	7	/api/clients	GET	200	2025-11-07 19:02:15.474024
2854	7	/api/products	GET	200	2025-11-07 19:02:15.474438
2855	7	/api/orders	GET	200	2025-11-07 19:02:15.474865
2856	7	/api/users	GET	200	2025-11-07 19:02:16.181903
2857	7	/api/users	GET	200	2025-11-07 19:02:16.183121
2858	7	/api/products	GET	200	2025-11-07 19:02:17.007496
2859	7	/api/products	GET	200	2025-11-07 19:02:17.008385
2860	7	/api/clients	GET	200	2025-11-07 19:02:21.760644
2861	7	/api/products	GET	200	2025-11-07 19:02:21.761096
2862	7	/api/clients	GET	200	2025-11-07 19:02:21.761698
2863	7	/api/orders	GET	200	2025-11-07 19:02:21.762428
2864	7	/api/products	GET	200	2025-11-07 19:02:21.762908
2865	7	/api/orders	GET	200	2025-11-07 19:02:21.763331
2866	7	/api/orders/16	PUT	200	2025-11-07 19:02:27.717972
2867	7	/api/orders	GET	200	2025-11-07 19:02:27.726432
2868	7	/api/products	GET	200	2025-11-07 19:02:30.16946
2869	7	/api/products	GET	200	2025-11-07 19:02:30.16989
2870	7	/api/clients	GET	200	2025-11-07 19:02:32.130876
2871	7	/api/products	GET	200	2025-11-07 19:02:32.131279
2872	7	/api/clients	GET	200	2025-11-07 19:02:32.172795
2873	7	/api/products	GET	200	2025-11-07 19:02:32.175796
2874	7	/api/orders	GET	200	2025-11-07 19:02:32.177672
2875	7	/api/orders	GET	200	2025-11-07 19:02:32.179752
2876	7	/api/orders/16	PUT	200	2025-11-07 19:02:44.070429
2877	7	/api/orders	GET	200	2025-11-07 19:02:44.078941
2878	7	/api/products	GET	200	2025-11-07 19:02:46.06434
2879	7	/api/products	GET	200	2025-11-07 19:02:46.067108
2880	7	/api/clients	GET	200	2025-11-07 19:02:49.352
2881	7	/api/products	GET	200	2025-11-07 19:02:49.352579
2882	7	/api/clients	GET	200	2025-11-07 19:02:49.395096
2883	7	/api/orders	GET	200	2025-11-07 19:02:49.397396
2884	7	/api/products	GET	200	2025-11-07 19:02:49.398375
2885	7	/api/orders	GET	200	2025-11-07 19:02:49.400536
2886	7	/api/orders/16	PUT	200	2025-11-07 19:03:00.217394
2887	7	/api/orders	GET	200	2025-11-07 19:03:00.225394
2888	7	/api/products	GET	200	2025-11-07 19:03:02.403335
2889	7	/api/products	GET	200	2025-11-07 19:03:02.404894
2890	7	/api/clients	GET	200	2025-11-07 19:03:30.875316
2891	7	/api/products	GET	200	2025-11-07 19:03:30.875769
2892	7	/api/orders	GET	200	2025-11-07 19:03:30.877655
2893	7	/api/clients	GET	200	2025-11-07 19:03:30.87863
2894	7	/api/products	GET	200	2025-11-07 19:03:30.881944
2895	7	/api/orders	GET	200	2025-11-07 19:03:30.885933
2896	7	/api/products	GET	200	2025-11-07 19:03:31.637963
2897	7	/api/products	GET	200	2025-11-07 19:03:31.638328
2898	7	/api/products/12	PUT	200	2025-11-07 19:03:37.181016
2899	7	/api/products	GET	200	2025-11-07 19:03:37.188411
2900	7	/api/clients	GET	200	2025-11-07 19:03:42.145562
2901	7	/api/clients	GET	200	2025-11-07 19:03:42.177069
2902	7	/api/clients	GET	200	2025-11-07 19:03:43.25753
2903	7	/api/products	GET	200	2025-11-07 19:03:43.258178
2904	7	/api/clients	GET	200	2025-11-07 19:03:43.302331
2905	7	/api/products	GET	200	2025-11-07 19:03:43.303703
2906	7	/api/orders	GET	200	2025-11-07 19:03:43.304519
2907	7	/api/orders	GET	200	2025-11-07 19:03:43.306393
2908	7	/api/clients	GET	200	2025-11-07 19:13:32.450283
2909	7	/api/products	GET	200	2025-11-07 19:13:32.451371
2910	7	/api/products	GET	200	2025-11-07 19:13:32.452559
2911	7	/api/orders	GET	200	2025-11-07 19:13:32.454137
2912	7	/api/orders	GET	200	2025-11-07 19:13:32.45508
2913	7	/api/clients	GET	200	2025-11-07 19:13:32.53185
2914	7	/api/clients	GET	200	2025-11-07 19:13:33.346067
2915	7	/api/products	GET	200	2025-11-07 19:13:33.352861
2916	7	/api/clients	GET	200	2025-11-07 19:13:33.354228
2917	7	/api/orders	GET	200	2025-11-07 19:13:33.355399
2918	7	/api/products	GET	200	2025-11-07 19:13:33.356143
2919	7	/api/orders	GET	200	2025-11-07 19:13:33.357297
2920	7	/api/clients	GET	200	2025-11-07 19:13:34.323369
2921	7	/api/products	GET	200	2025-11-07 19:13:34.32432
2922	7	/api/clients	GET	200	2025-11-07 19:13:34.325049
2923	7	/api/orders	GET	200	2025-11-07 19:13:34.325788
2924	7	/api/products	GET	200	2025-11-07 19:13:34.326547
2925	7	/api/orders	GET	200	2025-11-07 19:13:34.328098
2926	7	/api/products	GET	200	2025-11-07 19:14:23.418194
2927	7	/api/clients	GET	200	2025-11-07 19:14:23.433869
2928	7	/api/orders	GET	200	2025-11-07 19:14:23.43527
2929	7	/api/products	GET	200	2025-11-07 19:14:23.439022
2930	7	/api/orders	GET	200	2025-11-07 19:14:23.44074
2931	7	/api/clients	GET	200	2025-11-07 19:14:23.515505
2932	7	/api/clients	GET	200	2025-11-07 19:14:25.325975
2933	7	/api/products	GET	200	2025-11-07 19:14:25.33111
2934	7	/api/clients	GET	200	2025-11-07 19:14:25.331818
2935	7	/api/orders	GET	200	2025-11-07 19:14:25.332654
2936	7	/api/products	GET	200	2025-11-07 19:14:25.333763
2937	7	/api/orders	GET	200	2025-11-07 19:14:25.335416
2938	7	/api/products	GET	200	2025-11-07 19:15:01.401014
2939	7	/api/clients	GET	200	2025-11-07 19:15:01.40159
2940	7	/api/orders	GET	200	2025-11-07 19:15:01.402421
2941	7	/api/orders	GET	200	2025-11-07 19:15:01.40627
2942	7	/api/clients	GET	200	2025-11-07 19:15:01.482838
2943	7	/api/products	GET	200	2025-11-07 19:15:01.499183
2944	7	/api/clients	GET	200	2025-11-07 19:16:50.404682
2945	7	/api/products	GET	200	2025-11-07 19:16:50.421513
2946	7	/api/clients	GET	200	2025-11-07 19:16:50.42578
2947	7	/api/orders	GET	200	2025-11-07 19:16:50.428127
2948	7	/api/products	GET	200	2025-11-07 19:16:50.432398
2949	7	/api/orders	GET	200	2025-11-07 19:16:50.436248
2950	7	/api/clients	GET	200	2025-11-07 19:16:51.395737
2951	7	/api/products	GET	200	2025-11-07 19:16:51.396326
2952	7	/api/orders	GET	200	2025-11-07 19:16:51.397037
2953	7	/api/clients	GET	200	2025-11-07 19:16:51.397728
2954	7	/api/products	GET	200	2025-11-07 19:16:51.398426
2955	7	/api/orders	GET	200	2025-11-07 19:16:51.400176
2956	7	/api/clients	GET	200	2025-11-07 19:16:52.36439
2957	7	/api/products	GET	200	2025-11-07 19:16:52.369197
2958	7	/api/clients	GET	200	2025-11-07 19:16:52.369755
2959	7	/api/orders	GET	200	2025-11-07 19:16:52.37033
2960	7	/api/products	GET	200	2025-11-07 19:16:52.370928
2961	7	/api/orders	GET	200	2025-11-07 19:16:52.372271
2962	7	/api/clients	GET	200	2025-11-07 19:16:56.193169
2963	7	/api/products	GET	200	2025-11-07 19:16:56.205168
2964	7	/api/clients	GET	200	2025-11-07 19:16:56.206158
2965	7	/api/products	GET	200	2025-11-07 19:16:56.207329
2966	7	/api/orders	GET	200	2025-11-07 19:16:56.208341
2967	7	/api/orders	GET	200	2025-11-07 19:16:56.209477
2968	7	/api/products	GET	200	2025-11-07 19:16:58.742943
2969	7	/api/products	GET	200	2025-11-07 19:16:58.744742
2970	7	/api/clients	GET	200	2025-11-07 19:17:03.780301
2971	7	/api/products	GET	200	2025-11-07 19:17:03.783979
2972	7	/api/orders	GET	200	2025-11-07 19:17:03.784971
2973	7	/api/clients	GET	200	2025-11-07 19:17:03.785645
2974	7	/api/products	GET	200	2025-11-07 19:17:03.78613
2975	7	/api/orders	GET	200	2025-11-07 19:17:03.786621
2976	7	/api/orders/16	PUT	500	2025-11-07 19:17:27.370371
2977	7	/api/clients	GET	200	2025-11-07 19:18:14.258773
2978	7	/api/clients	GET	200	2025-11-07 19:18:14.303744
2979	7	/api/products	GET	200	2025-11-07 19:18:14.305747
2980	7	/api/orders	GET	200	2025-11-07 19:18:14.306981
2981	7	/api/orders	GET	200	2025-11-07 19:18:14.308971
2982	7	/api/products	GET	200	2025-11-07 19:18:14.443891
2983	7	/api/products	GET	200	2025-11-07 19:18:17.521965
2984	7	/api/products	GET	200	2025-11-07 19:18:17.522783
2985	7	/api/clients	GET	200	2025-11-07 19:18:18.790206
2986	7	/api/products	GET	200	2025-11-07 19:18:18.791091
2987	7	/api/orders	GET	200	2025-11-07 19:18:18.792122
2988	7	/api/clients	GET	200	2025-11-07 19:18:18.792876
2989	7	/api/products	GET	200	2025-11-07 19:18:18.793534
2990	7	/api/orders	GET	200	2025-11-07 19:18:18.794189
2991	7	/api/orders/16	PUT	500	2025-11-07 19:18:25.651032
2992	7	/api/clients	GET	200	2025-11-07 19:19:07.713893
2993	7	/api/clients	GET	200	2025-11-07 19:19:07.761211
2994	7	/api/products	GET	200	2025-11-07 19:19:07.762667
2995	7	/api/orders	GET	200	2025-11-07 19:19:07.764382
2996	7	/api/products	GET	200	2025-11-07 19:19:07.765865
2997	7	/api/orders	GET	200	2025-11-07 19:19:07.770733
2998	7	/api/products	GET	200	2025-11-07 19:19:11.301351
2999	7	/api/products	GET	200	2025-11-07 19:19:11.302214
3000	7	/api/clients	GET	200	2025-11-07 19:19:17.417817
3001	7	/api/products	GET	200	2025-11-07 19:19:17.418524
3002	7	/api/orders	GET	200	2025-11-07 19:19:17.419152
3003	7	/api/clients	GET	200	2025-11-07 19:19:17.419649
3004	7	/api/orders	GET	200	2025-11-07 19:19:17.420183
3005	7	/api/products	GET	200	2025-11-07 19:19:17.420697
3006	7	/api/products	GET	200	2025-11-07 19:19:20.549399
3007	7	/api/products	GET	200	2025-11-07 19:19:20.549901
3008	7	/api/products/12	PUT	200	2025-11-07 19:19:26.224688
3009	7	/api/products	GET	200	2025-11-07 19:19:26.232297
3010	7	/api/clients	GET	200	2025-11-07 19:19:28.313321
3011	7	/api/products	GET	200	2025-11-07 19:19:28.314115
3012	7	/api/clients	GET	200	2025-11-07 19:19:28.358731
3013	7	/api/orders	GET	200	2025-11-07 19:19:28.360335
3014	7	/api/products	GET	200	2025-11-07 19:19:28.361472
3015	7	/api/orders	GET	200	2025-11-07 19:19:28.362399
3016	7	/api/orders/16	PUT	500	2025-11-07 19:19:33.936319
3017	7	/api/products	GET	200	2025-11-07 19:22:32.738952
3018	7	/api/clients	GET	200	2025-11-07 19:22:32.740384
3019	7	/api/orders	GET	200	2025-11-07 19:22:32.742812
3020	7	/api/orders	GET	200	2025-11-07 19:22:32.74514
3021	7	/api/products	GET	200	2025-11-07 19:22:32.745767
3022	7	/api/clients	GET	200	2025-11-07 19:22:32.825815
3023	7	/api/products	GET	200	2025-11-07 19:22:34.214233
3024	7	/api/products	GET	200	2025-11-07 19:22:34.216275
3025	7	/api/products/12	PUT	200	2025-11-07 19:22:40.46995
3026	7	/api/products	GET	200	2025-11-07 19:22:40.47747
3027	7	/api/clients	GET	200	2025-11-07 19:22:41.2503
3028	7	/api/products	GET	200	2025-11-07 19:22:41.251135
3029	7	/api/orders	GET	200	2025-11-07 19:22:41.252337
3030	7	/api/clients	GET	200	2025-11-07 19:22:41.254217
3031	7	/api/products	GET	200	2025-11-07 19:22:41.25494
3032	7	/api/orders	GET	200	2025-11-07 19:22:41.255697
3033	7	/api/orders/16	PUT	500	2025-11-07 19:22:45.907969
3034	7	/api/clients	GET	200	2025-11-07 19:23:47.772014
3035	7	/api/products	GET	200	2025-11-07 19:23:47.817671
3036	7	/api/clients	GET	200	2025-11-07 19:23:47.819439
3037	7	/api/orders	GET	200	2025-11-07 19:23:47.824668
3038	7	/api/products	GET	200	2025-11-07 19:23:47.82617
3039	7	/api/orders	GET	200	2025-11-07 19:23:47.827837
3040	7	/api/products	GET	200	2025-11-07 19:23:48.780213
3041	7	/api/products	GET	200	2025-11-07 19:23:48.780897
3042	7	/api/products/12	PUT	200	2025-11-07 19:23:53.380411
3043	7	/api/products	GET	200	2025-11-07 19:23:53.38832
3044	7	/api/clients	GET	200	2025-11-07 19:23:54.607549
3045	7	/api/products	GET	200	2025-11-07 19:23:54.608095
3046	7	/api/orders	GET	200	2025-11-07 19:23:54.608708
3047	7	/api/clients	GET	200	2025-11-07 19:23:54.609301
3048	7	/api/products	GET	200	2025-11-07 19:23:54.609758
3049	7	/api/orders	GET	200	2025-11-07 19:23:54.610239
3050	7	/api/orders/16	PUT	200	2025-11-07 19:23:58.139111
3051	7	/api/orders	GET	200	2025-11-07 19:23:58.14724
3052	7	/api/products	GET	200	2025-11-07 19:24:04.950918
3053	7	/api/products	GET	200	2025-11-07 19:24:04.951921
3054	7	/api/clients	GET	200	2025-11-07 19:24:07.127665
3055	7	/api/products	GET	200	2025-11-07 19:24:07.12826
3056	7	/api/clients	GET	200	2025-11-07 19:24:07.172756
3057	7	/api/products	GET	200	2025-11-07 19:24:07.174465
3058	7	/api/orders	GET	200	2025-11-07 19:24:07.175593
3059	7	/api/orders	GET	200	2025-11-07 19:24:07.176822
3060	7	/api/orders/16	PUT	200	2025-11-07 19:24:21.618183
3061	7	/api/orders	GET	200	2025-11-07 19:24:21.626321
3062	7	/api/products	GET	200	2025-11-07 19:24:22.891258
3063	7	/api/products	GET	200	2025-11-07 19:24:22.893
3064	7	/api/clients	GET	200	2025-11-07 19:24:24.320316
3065	7	/api/products	GET	200	2025-11-07 19:24:24.320885
3066	7	/api/clients	GET	200	2025-11-07 19:24:24.363713
3067	7	/api/products	GET	200	2025-11-07 19:24:24.366443
3068	7	/api/orders	GET	200	2025-11-07 19:24:24.367767
3069	7	/api/orders	GET	200	2025-11-07 19:24:24.370786
3070	7	/api/orders/16	PUT	200	2025-11-07 19:24:29.432695
3071	7	/api/orders	GET	200	2025-11-07 19:24:29.439465
3072	7	/api/products	GET	200	2025-11-07 19:24:30.479694
3073	7	/api/products	GET	200	2025-11-07 19:24:30.480453
3074	7	/api/clients	GET	200	2025-11-07 19:24:40.601433
3075	7	/api/products	GET	200	2025-11-07 19:24:40.605038
3076	7	/api/clients	GET	200	2025-11-07 19:24:40.605723
3077	7	/api/orders	GET	200	2025-11-07 19:24:40.608858
3078	7	/api/products	GET	200	2025-11-07 19:24:40.609545
3079	7	/api/orders	GET	200	2025-11-07 19:24:40.614092
3080	7	/api/products	GET	304	2025-11-07 19:24:49.911027
3081	7	/api/products	GET	304	2025-11-07 19:24:49.914681
3082	7	/api/products	GET	304	2025-11-07 19:24:52.936901
3083	7	/api/orders	GET	304	2025-11-07 19:24:52.937894
3084	7	/api/products	GET	304	2025-11-07 19:24:52.981864
3085	7	/api/orders	GET	304	2025-11-07 19:24:52.983612
3086	7	/api/clients	GET	304	2025-11-07 19:24:53.101305
3087	7	/api/clients	GET	304	2025-11-07 19:24:53.104259
3088	7	/api/products	GET	304	2025-11-07 19:30:07.322272
3089	7	/api/orders	GET	304	2025-11-07 19:30:07.326464
3090	7	/api/orders	GET	304	2025-11-07 19:30:07.334018
3091	7	/api/products	GET	304	2025-11-07 19:30:07.361281
3092	7	/api/clients	GET	304	2025-11-07 19:30:07.464057
3093	7	/api/clients	GET	304	2025-11-07 19:30:07.468239
3094	7	/api/clients	GET	304	2025-11-07 19:30:08.952064
3095	7	/api/products	GET	304	2025-11-07 19:30:08.952855
3096	7	/api/orders	GET	304	2025-11-07 19:30:08.953745
3097	7	/api/clients	GET	304	2025-11-07 19:30:08.959661
3098	7	/api/products	GET	304	2025-11-07 19:30:08.96038
3099	7	/api/orders	GET	304	2025-11-07 19:30:08.962042
3100	7	/api/clients	GET	304	2025-11-07 19:31:32.994183
3101	7	/api/products	GET	304	2025-11-07 19:31:32.995222
3102	7	/api/orders	GET	304	2025-11-07 19:31:33.000906
3103	7	/api/orders	GET	304	2025-11-07 19:31:33.007614
3104	7	/api/clients	GET	304	2025-11-07 19:31:33.039376
3105	7	/api/products	GET	304	2025-11-07 19:31:33.040888
3106	7	/api/clients	GET	304	2025-11-07 19:31:47.011222
3107	7	/api/orders	GET	304	2025-11-07 19:31:47.015059
3108	7	/api/orders	GET	304	2025-11-07 19:31:47.021713
3109	7	/api/products	GET	304	2025-11-07 19:31:47.0246
3110	7	/api/products	GET	304	2025-11-07 19:31:47.030204
3111	7	/api/clients	GET	304	2025-11-07 19:31:47.050316
3112	7	/api/clients	GET	304	2025-11-07 19:33:15.019822
3113	7	/api/products	GET	304	2025-11-07 19:33:15.030648
3114	7	/api/orders	GET	304	2025-11-07 19:33:15.03539
3115	7	/api/clients	GET	304	2025-11-07 19:33:15.055355
3116	7	/api/products	GET	304	2025-11-07 19:33:15.071737
3117	7	/api/orders	GET	304	2025-11-07 19:33:15.074921
3118	7	/api/clients	GET	304	2025-11-07 19:33:15.955968
3119	7	/api/products	GET	304	2025-11-07 19:33:15.957182
3120	7	/api/orders	GET	304	2025-11-07 19:33:15.962794
3121	7	/api/clients	GET	304	2025-11-07 19:33:15.963849
3122	7	/api/products	GET	304	2025-11-07 19:33:15.96607
3123	7	/api/orders	GET	304	2025-11-07 19:33:15.968815
3124	7	/api/clients	GET	304	2025-11-07 19:33:16.949707
3125	7	/api/products	GET	304	2025-11-07 19:33:16.950527
3126	7	/api/orders	GET	304	2025-11-07 19:33:16.951393
3127	7	/api/clients	GET	304	2025-11-07 19:33:16.957897
3128	7	/api/products	GET	304	2025-11-07 19:33:16.958427
3129	7	/api/orders	GET	304	2025-11-07 19:33:16.95935
3130	7	/api/clients	GET	304	2025-11-07 19:33:28.012125
3131	7	/api/products	GET	304	2025-11-07 19:33:28.014684
3132	7	/api/orders	GET	304	2025-11-07 19:33:28.015601
3139	7	/api/clients	GET	304	2025-11-07 19:33:32.969618
3144	7	/api/orders	GET	304	2025-11-07 19:33:35.978135
3151	7	/api/clients	GET	304	2025-11-07 19:33:39.011086
4089	7	/api/products	GET	304	2025-11-10 18:19:09.74531
4092	7	/api/products	GET	304	2025-11-10 18:19:17.519061
4102	7	/api/clients	GET	304	2025-11-10 18:19:18.87396
4152	7	/api/clients	GET	304	2025-11-10 18:28:19.824063
4155	7	/api/orders	GET	304	2025-11-10 18:28:19.83411
4156	7	/api/products	GET	304	2025-11-10 18:28:22.539892
4159	7	/api/products	GET	304	2025-11-10 18:28:25.387782
4171	7	/api/clients	GET	304	2025-11-10 18:28:32.784279
4180	7	/api/orders	GET	304	2025-11-10 18:28:40.175007
4184	7	/api/orders/19/status	PUT	200	2025-11-10 18:28:44.517214
4185	7	/api/orders	GET	200	2025-11-10 18:28:44.52169
4186	7	/api/products	GET	304	2025-11-10 18:28:49.990436
4294	7	/api/auth/me	GET	304	2025-11-10 18:35:18.717074
4300	7	/api/products	GET	304	2025-11-10 18:35:18.758381
4432	7	/api/orders	GET	304	2025-11-10 18:41:43.443407
4594	7	/api/products	GET	304	2025-11-10 18:46:17.346086
4597	7	/api/orders	GET	304	2025-11-10 18:46:17.356418
4598	7	/api/products	GET	304	2025-11-10 18:46:19.097552
4601	7	/api/products	GET	304	2025-11-10 18:46:20.23318
4613	7	/api/products	GET	304	2025-11-10 18:46:25.190898
4669	7	/api/orders	GET	304	2025-11-11 16:29:35.994225
4746	7	/api/auth/me	GET	200	2025-11-11 16:57:49.886337
4806	7	/api/auth/me	GET	304	2025-11-12 16:13:28.218642
4813	7	/api/auth/me	GET	200	2026-03-12 16:01:07.903448
4923	7	/api/orders	GET	304	2026-03-12 17:16:27.474633
4926	7	/api/users	GET	304	2026-03-12 17:16:28.239176
4927	7	/api/clients	GET	304	2026-03-12 17:16:29.310665
4989	7	/api/clients	GET	304	2026-03-12 18:52:12.089731
4997	7	/api/orders	GET	304	2026-03-12 18:52:18.840711
5084	7	/api/products	GET	304	2026-03-12 19:03:30.119797
5086	7	/api/clients	GET	304	2026-03-12 19:03:30.193076
5153	7	/api/clients	GET	304	2026-03-12 21:00:12.167455
5227	7	/api/products	GET	304	2026-03-12 21:18:10.488544
5229	7	/api/orders	GET	304	2026-03-12 21:18:10.495619
5230	7	/api/users	GET	304	2026-03-12 21:18:10.948277
5233	7	/api/products	GET	304	2026-03-12 21:18:13.811357
5370	7	/api/clients	GET	304	2026-03-12 21:29:58.14417
5478	7	/api/auth/me	GET	304	2026-03-13 13:45:52.141708
5479	7	/api/auth/me	GET	200	2026-03-13 13:45:53.35681
5565	7	/api/products	GET	304	2026-03-13 13:59:08.532955
5568	7	/api/products	GET	304	2026-03-13 13:59:09.555072
5569	7	/api/clients	GET	304	2026-03-13 13:59:10.242185
5572	7	/api/users	GET	304	2026-03-13 13:59:13.020916
5573	7	/api/clients	GET	304	2026-03-13 13:59:19.652527
5626	7	/api/auth/me	GET	200	2026-03-13 14:21:58.244839
5697	7	/api/products	GET	200	2026-03-13 14:29:33.12051
5700	7	/api/orders	GET	200	2026-03-13 14:29:33.127235
5701	7	/api/clients	GET	200	2026-03-13 14:29:37.009437
5808	\N	/api/users	GET	401	2026-03-17 20:49:18.340136
5904	7	/api/users	GET	200	2026-03-17 21:16:51.591199
5907	7	/api/products	GET	200	2026-03-17 21:16:52.676021
6000	7	/api/orders	GET	200	2026-03-17 21:48:09.008122
6101	\N	/api/suppliers	GET	404	2026-03-18 15:37:47.717396
6102	7	/api/summary	GET	200	2026-03-18 15:37:51.954052
6105	\N	/api/suppliers	GET	404	2026-03-18 15:37:52.75017
6171	7	/api/suppliers	POST	201	2026-03-18 16:00:27.180104
6172	7	/api/suppliers	GET	200	2026-03-18 16:00:27.185834
6238	7	/api/summary	GET	200	2026-03-18 16:17:42.944487
6297	7	/api/clients	GET	200	2026-03-18 16:22:03.979175
6300	7	/api/orders	GET	200	2026-03-18 16:22:03.986517
6301	7	/api/orders/3	PUT	200	2026-03-18 16:22:11.217599
6302	7	/api/orders	GET	200	2026-03-18 16:22:11.222892
6303	7	/api/orders/6	PUT	200	2026-03-18 16:22:16.470064
6304	7	/api/orders	GET	200	2026-03-18 16:22:16.476106
6305	7	/api/summary	GET	200	2026-03-18 16:22:18.29186
6377	7	/api/products	GET	200	2026-03-18 16:36:10.859198
6379	7	/api/orders	GET	200	2026-03-18 16:36:10.880768
6380	7	/api/products	GET	200	2026-03-18 16:36:11.754049
6383	7	/api/summary	GET	200	2026-03-18 16:36:19.768836
6460	7	/api/summary	GET	200	2026-03-18 17:14:43.522585
6559	7	/api/financial/categories	GET	200	2026-03-18 17:38:23.662116
6561	7	/api/financial?	GET	200	2026-03-18 17:38:23.671942
6566	7	/api/summary	GET	200	2026-03-18 17:38:29.203127
6567	7	/api/financial?	GET	200	2026-03-18 17:38:32.276428
6636	7	/api/financial?from=2026-03-01&to=2026-03-18	GET	200	2026-03-18 18:01:15.453155
6638	7	/api/financial/categories	GET	200	2026-03-18 18:01:17.444294
6698	7	/api/financial?status=vencido	GET	200	2026-03-18 18:24:35.691759
6700	7	/api/financial?	GET	200	2026-03-18 18:24:35.701215
6770	7	/api/purchase-orders	GET	200	2026-03-18 21:24:53.540027
6771	7	/api/auth/me	GET	200	2026-03-18 21:24:59.893061
6773	7	/api/financial?status=vencido	GET	200	2026-03-18 21:24:59.919758
6782	7	/api/purchase-orders	GET	200	2026-03-18 21:24:59.96426
6857	7	/api/suppliers	GET	200	2026-03-18 21:38:32.228422
6943	7	/api/purchase-orders	GET	200	2026-03-18 21:42:13.347834
7033	7	/api/financial?status=vencido	GET	200	2026-03-18 21:48:38.534329
7092	7	/api/financial?	GET	200	2026-03-18 21:52:19.273736
7096	7	/api/products	GET	200	2026-03-18 21:52:20.113747
7102	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-18 21:52:20.165509
7110	7	/api/orders	GET	200	2026-03-18 21:52:21.160318
7147	7	/api/summary	GET	200	2026-03-19 15:52:50.776416
7148	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:52:50.784247
7206	7	/api/financial?status=vencido	GET	200	2026-03-19 15:59:55.432504
7209	7	/api/financial/categories	GET	200	2026-03-19 16:00:00.683295
7246	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:10:34.380871
7282	7	/api/summary	GET	200	2026-03-19 16:15:18.209331
7286	7	/api/summary	GET	200	2026-03-19 16:15:18.271406
7289	7	/api/summary	GET	200	2026-03-19 16:15:20.839632
7292	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:15:20.85422
7293	7	/api/auth/me	GET	200	2026-03-19 16:15:29.38482
7295	7	/api/financial?status=vencido	GET	200	2026-03-19 16:15:29.410902
7385	7	/api/summary	GET	200	2026-03-19 16:21:11.203802
7442	7	/api/clients	GET	200	2026-03-19 16:21:41.978461
7453	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:44.004817
7462	7	/api/orders	GET	200	2026-03-19 16:21:45.760136
7471	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:47.577277
7473	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:47.5878
7476	7	/api/products	GET	200	2026-03-19 16:21:47.598688
7479	7	/api/products	GET	200	2026-03-19 16:21:48.515002
3133	7	/api/products	GET	304	2025-11-07 19:33:28.021665
3134	7	/api/clients	GET	304	2025-11-07 19:33:28.049404
3135	7	/api/orders	GET	304	2025-11-07 19:33:28.056174
3136	7	/api/clients	GET	304	2025-11-07 19:33:32.963093
3137	7	/api/products	GET	304	2025-11-07 19:33:32.963966
3138	7	/api/orders	GET	304	2025-11-07 19:33:32.96906
3140	7	/api/products	GET	304	2025-11-07 19:33:32.971463
3141	7	/api/orders	GET	304	2025-11-07 19:33:32.973738
3142	7	/api/clients	GET	304	2025-11-07 19:33:35.977016
3143	7	/api/products	GET	304	2025-11-07 19:33:35.977521
3145	7	/api/clients	GET	304	2025-11-07 19:33:35.984116
3146	7	/api/products	GET	304	2025-11-07 19:33:35.984926
3147	7	/api/orders	GET	304	2025-11-07 19:33:35.985508
3148	7	/api/clients	GET	304	2025-11-07 19:33:39.002023
3149	7	/api/products	GET	304	2025-11-07 19:33:39.002894
3150	7	/api/orders	GET	304	2025-11-07 19:33:39.004066
3152	7	/api/products	GET	304	2025-11-07 19:33:39.011841
3153	7	/api/orders	GET	304	2025-11-07 19:33:39.012616
3154	7	/api/clients	GET	304	2025-11-07 19:34:41.055479
3155	7	/api/products	GET	304	2025-11-07 19:34:41.056387
3156	7	/api/orders	GET	304	2025-11-07 19:34:41.062051
3157	7	/api/orders	GET	304	2025-11-07 19:34:41.068886
3158	7	/api/clients	GET	304	2025-11-07 19:34:41.101567
3159	7	/api/products	GET	304	2025-11-07 19:34:41.102077
3160	7	/api/clients	GET	304	2025-11-07 19:34:42.962766
3161	7	/api/products	GET	304	2025-11-07 19:34:42.963765
3162	7	/api/orders	GET	304	2025-11-07 19:34:42.964732
3163	7	/api/clients	GET	304	2025-11-07 19:34:42.97139
3164	7	/api/products	GET	304	2025-11-07 19:34:42.971866
3165	7	/api/orders	GET	304	2025-11-07 19:34:42.974069
3166	7	/api/clients	GET	304	2025-11-07 19:34:44.975061
3167	7	/api/products	GET	304	2025-11-07 19:34:44.975642
3168	7	/api/orders	GET	304	2025-11-07 19:34:44.976268
3169	7	/api/clients	GET	304	2025-11-07 19:34:44.982276
3170	7	/api/products	GET	304	2025-11-07 19:34:44.982861
3171	7	/api/orders	GET	304	2025-11-07 19:34:44.984448
3172	7	/api/clients	GET	304	2025-11-07 19:34:47.966643
3173	7	/api/products	GET	304	2025-11-07 19:34:47.967271
3174	7	/api/orders	GET	304	2025-11-07 19:34:47.968392
3175	7	/api/clients	GET	304	2025-11-07 19:34:47.974259
3176	7	/api/products	GET	304	2025-11-07 19:34:47.975469
3177	7	/api/orders	GET	304	2025-11-07 19:34:48.006797
3178	7	/api/clients	GET	304	2025-11-07 19:34:54.995529
3179	7	/api/products	GET	304	2025-11-07 19:34:54.995999
3180	7	/api/orders	GET	304	2025-11-07 19:34:54.996783
3181	7	/api/clients	GET	304	2025-11-07 19:34:55.003863
3182	7	/api/products	GET	304	2025-11-07 19:34:55.004541
3183	7	/api/orders	GET	304	2025-11-07 19:34:55.00602
3184	7	/api/clients	GET	304	2025-11-07 19:34:55.968053
3185	7	/api/products	GET	304	2025-11-07 19:34:55.968623
3186	7	/api/orders	GET	304	2025-11-07 19:34:55.969237
3187	7	/api/clients	GET	304	2025-11-07 19:34:55.975538
3188	7	/api/products	GET	304	2025-11-07 19:34:55.976527
3189	7	/api/orders	GET	304	2025-11-07 19:34:55.977428
3190	7	/api/clients	GET	200	2025-11-07 19:39:32.566616
3191	7	/api/products	GET	200	2025-11-07 19:39:32.581493
3192	7	/api/products	GET	200	2025-11-07 19:39:32.585723
3193	7	/api/orders	GET	200	2025-11-07 19:39:32.588663
3194	7	/api/clients	GET	200	2025-11-07 19:39:32.690444
3195	7	/api/orders	GET	200	2025-11-07 19:39:32.692424
3196	7	/api/products	GET	304	2025-11-07 19:39:34.68434
3197	7	/api/products	GET	304	2025-11-07 19:39:34.690374
3198	7	/api/clients	GET	304	2025-11-07 19:39:35.469202
3199	7	/api/products	GET	304	2025-11-07 19:39:35.46997
3200	7	/api/orders	GET	304	2025-11-07 19:39:35.475975
3201	7	/api/clients	GET	304	2025-11-07 19:39:35.476483
3202	7	/api/products	GET	304	2025-11-07 19:39:35.476935
3203	7	/api/orders	GET	304	2025-11-07 19:39:35.481838
3204	7	/api/clients	GET	304	2025-11-07 19:42:11.318375
3205	7	/api/products	GET	304	2025-11-07 19:42:11.328589
3206	7	/api/orders	GET	304	2025-11-07 19:42:11.333319
3207	7	/api/products	GET	304	2025-11-07 19:42:11.336335
3208	7	/api/orders	GET	304	2025-11-07 19:42:11.33935
3209	7	/api/clients	GET	304	2025-11-07 19:42:11.354524
3210	7	/api/clients	GET	304	2025-11-07 19:42:11.959361
3211	7	/api/products	GET	304	2025-11-07 19:42:11.960108
3212	7	/api/orders	GET	304	2025-11-07 19:42:11.965194
3213	7	/api/clients	GET	304	2025-11-07 19:42:11.965827
3214	7	/api/products	GET	304	2025-11-07 19:42:11.968213
3215	7	/api/orders	GET	304	2025-11-07 19:42:11.969474
3216	7	/api/products	GET	304	2025-11-07 19:42:35.00145
3217	7	/api/orders	GET	304	2025-11-07 19:42:35.005136
3218	7	/api/orders	GET	304	2025-11-07 19:42:35.010562
3219	7	/api/products	GET	304	2025-11-07 19:42:35.036747
3220	7	/api/clients	GET	304	2025-11-07 19:42:35.124844
3221	7	/api/clients	GET	304	2025-11-07 19:42:35.128701
3222	7	/api/clients	GET	304	2025-11-07 19:42:35.982857
3223	7	/api/products	GET	304	2025-11-07 19:42:35.98345
3224	7	/api/orders	GET	304	2025-11-07 19:42:35.984354
3225	7	/api/clients	GET	304	2025-11-07 19:42:35.990914
3226	7	/api/products	GET	304	2025-11-07 19:42:35.991575
3227	7	/api/orders	GET	304	2025-11-07 19:42:35.992802
3228	7	/api/clients	GET	304	2025-11-07 19:43:09.98349
3229	7	/api/products	GET	304	2025-11-07 19:43:09.986147
3230	7	/api/orders	GET	304	2025-11-07 19:43:09.990421
3231	7	/api/products	GET	304	2025-11-07 19:43:09.992902
3232	7	/api/orders	GET	304	2025-11-07 19:43:09.995601
3233	7	/api/clients	GET	304	2025-11-07 19:43:10.121055
3234	7	/api/clients	GET	304	2025-11-07 19:43:32.987666
3235	7	/api/products	GET	304	2025-11-07 19:43:32.993116
3236	7	/api/orders	GET	304	2025-11-07 19:43:32.994322
3237	7	/api/clients	GET	304	2025-11-07 19:43:33.032906
3238	7	/api/products	GET	304	2025-11-07 19:43:33.039931
3239	7	/api/orders	GET	304	2025-11-07 19:43:33.0422
3240	7	/api/clients	GET	304	2025-11-07 19:43:34.952341
3241	7	/api/products	GET	304	2025-11-07 19:43:34.953853
3242	7	/api/orders	GET	304	2025-11-07 19:43:34.959291
3243	7	/api/clients	GET	304	2025-11-07 19:43:34.959874
3244	7	/api/products	GET	304	2025-11-07 19:43:34.960755
3245	7	/api/orders	GET	304	2025-11-07 19:43:34.966178
3246	7	/api/clients	GET	200	2025-11-07 19:43:37.903611
3247	7	/api/products	GET	200	2025-11-07 19:43:37.908049
3248	7	/api/orders	GET	200	2025-11-07 19:43:37.910698
3249	7	/api/clients	GET	200	2025-11-07 19:43:37.911503
3250	7	/api/products	GET	200	2025-11-07 19:43:37.912691
3251	7	/api/orders	GET	200	2025-11-07 19:43:37.913944
3252	7	/api/clients	GET	200	2025-11-07 19:43:40.69894
3253	7	/api/clients	GET	200	2025-11-07 19:43:40.877083
3254	7	/api/products	GET	200	2025-11-07 19:43:40.885835
3255	7	/api/orders	GET	200	2025-11-07 19:43:40.887638
3256	7	/api/clients	GET	200	2025-11-07 19:43:40.888082
3261	7	/api/clients	GET	200	2025-11-07 19:43:41.411979
4094	7	/api/clients	GET	304	2025-11-10 18:19:17.557207
4101	7	/api/orders	GET	304	2025-11-10 18:19:18.873279
4153	7	/api/orders	GET	304	2025-11-10 18:28:19.827828
4160	7	/api/orders	GET	304	2025-11-10 18:28:25.388695
4167	7	/api/products	GET	304	2025-11-10 18:28:30.982689
4168	7	/api/products	GET	304	2025-11-10 18:28:32.775565
4183	7	/api/orders	GET	304	2025-11-10 18:28:40.183605
4295	7	/api/auth/me	GET	304	2025-11-10 18:35:18.717889
4299	7	/api/clients	GET	304	2025-11-10 18:35:18.755921
4434	7	/api/clients	GET	304	2025-11-10 18:41:43.449965
4439	7	/api/products	GET	304	2025-11-10 18:41:52.634547
4440	7	/api/products	GET	304	2025-11-10 18:41:55.456115
4454	7	/api/clients	GET	304	2025-11-10 18:42:03.543567
4459	7	/api/products	GET	304	2025-11-10 18:42:10.114379
4460	7	/api/products	GET	304	2025-11-10 18:42:11.114106
4464	7	/api/orders	GET	304	2025-11-10 18:42:11.125847
4466	7	/api/orders/22/status	PUT	200	2025-11-10 18:42:16.261798
4467	7	/api/orders	GET	200	2025-11-10 18:42:16.267315
4468	7	/api/products	GET	304	2025-11-10 18:42:17.257641
4471	7	/api/clients	GET	304	2025-11-10 18:42:18.924628
4482	7	/api/products	GET	304	2025-11-10 18:42:22.586863
4595	7	/api/orders	GET	304	2025-11-10 18:46:17.350565
4602	7	/api/orders	GET	304	2025-11-10 18:46:20.233955
4614	7	/api/orders	GET	304	2025-11-10 18:46:25.191499
4672	7	/api/auth/me	GET	304	2025-11-11 16:30:30.904418
4748	7	/api/auth/me	GET	200	2025-11-11 17:03:34.170996
4805	7	/api/auth/me	GET	304	2025-11-12 16:13:28.218432
4814	7	/api/auth/me	GET	304	2026-03-12 16:01:08.013912
4815	7	/api/auth/me	GET	304	2026-03-12 16:01:14.19193
4932	7	/api/orders	GET	304	2026-03-12 17:16:29.352058
4933	7	/api/products	GET	304	2026-03-12 17:16:30.297343
4936	7	/api/clients	GET	304	2026-03-12 17:16:30.814077
4937	7	/api/clients	GET	304	2026-03-12 17:16:34.544386
4940	7	/api/products	GET	304	2026-03-12 17:16:35.301905
4990	7	/api/products	GET	304	2026-03-12 18:52:12.090259
4992	7	/api/orders	GET	304	2026-03-12 18:52:12.102723
4993	7	/api/auth/me	GET	304	2026-03-12 18:52:18.798167
4996	7	/api/products	GET	304	2026-03-12 18:52:18.834604
5000	7	/api/orders	GET	304	2026-03-12 18:52:18.844239
5085	7	/api/clients	GET	304	2026-03-12 19:03:30.188857
5154	7	/api/auth/me	GET	304	2026-03-12 21:00:24.617332
5228	7	/api/orders	GET	304	2026-03-12 21:18:10.490384
5231	7	/api/users	GET	304	2026-03-12 21:18:10.952975
5232	7	/api/clients	GET	304	2026-03-12 21:18:13.810193
5371	7	/api/products	GET	304	2026-03-12 21:29:58.145544
5481	7	/api/clients	GET	304	2026-03-13 13:48:18.405925
5484	7	/api/products	GET	304	2026-03-13 13:48:19.182418
5566	7	/api/orders	GET	304	2026-03-13 13:59:08.534426
5567	7	/api/products	GET	304	2026-03-13 13:59:09.548421
5570	7	/api/clients	GET	304	2026-03-13 13:59:10.245861
5571	7	/api/users	GET	304	2026-03-13 13:59:13.014201
5574	7	/api/products	GET	304	2026-03-13 13:59:19.653045
5576	7	/api/orders	GET	304	2026-03-13 13:59:19.695162
5627	7	/api/auth/me	GET	200	2026-03-13 14:21:58.29479
5698	7	/api/clients	GET	200	2026-03-13 14:29:33.121702
5809	\N	/api/users	GET	401	2026-03-17 20:49:18.342791
5905	7	/api/users	GET	200	2026-03-17 21:16:51.628303
5906	7	/api/clients	GET	200	2026-03-17 21:16:52.674609
6001	7	/api/orders	GET	200	2026-03-17 21:48:09.050071
6003	7	/api/clients	GET	200	2026-03-17 21:48:09.099864
6005	7	/api/products	GET	200	2026-03-17 21:48:09.115955
6106	\N	/api/auth/login	POST	200	2026-03-18 15:42:08.433733
6107	7	/api/summary	GET	200	2026-03-18 15:42:08.553958
6173	7	/api/suppliers	POST	201	2026-03-18 16:00:45.793573
6174	7	/api/suppliers	GET	200	2026-03-18 16:00:45.799531
6239	7	/api/clients	GET	200	2026-03-18 16:17:56.283186
6298	7	/api/products	GET	200	2026-03-18 16:22:03.980873
6378	7	/api/orders	GET	200	2026-03-18 16:36:10.875721
6381	7	/api/products	GET	200	2026-03-18 16:36:11.757952
6382	7	/api/summary	GET	200	2026-03-18 16:36:19.762304
6461	7	/api/financial?	GET	200	2026-03-18 17:14:54.709705
6560	7	/api/financial?	GET	200	2026-03-18 17:38:23.66496
6569	7	/api/financial?	GET	200	2026-03-18 17:38:32.28191
6637	7	/api/orders?	GET	200	2026-03-18 18:01:15.454001
6639	7	/api/financial?	GET	200	2026-03-18 18:01:17.447345
6642	7	/api/suppliers	GET	200	2026-03-18 18:01:21.392187
6645	7	/api/products	GET	200	2026-03-18 18:01:29.089547
6646	7	/api/summary	GET	200	2026-03-18 18:01:37.01825
6699	7	/api/summary	GET	200	2026-03-18 18:24:35.699339
6784	7	/api/suppliers	GET	200	2026-03-18 21:24:59.996032
6859	7	/api/products	GET	200	2026-03-18 21:38:32.234303
6864	7	/api/products	GET	200	2026-03-18 21:38:41.571391
6865	7	/api/products	GET	200	2026-03-18 21:38:45.143615
6944	7	/api/products	GET	200	2026-03-18 21:42:13.376532
7034	7	/api/summary	GET	200	2026-03-18 21:48:38.540166
7094	7	/api/financial/categories	GET	200	2026-03-18 21:52:19.306186
7097	7	/api/orders?	GET	200	2026-03-18 21:52:20.116189
7103	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-18 21:52:20.168638
7106	7	/api/users	GET	200	2026-03-18 21:52:20.629333
7107	7	/api/clients	GET	200	2026-03-18 21:52:21.15453
7149	7	/api/summary	GET	200	2026-03-19 15:56:23.249447
7151	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:56:23.360595
7153	7	/api/summary	GET	200	2026-03-19 15:56:23.920764
7156	7	/api/financial/categories	GET	200	2026-03-19 15:56:29.982455
7212	\N	/api/auth/login	POST	200	2026-03-19 16:00:34.256483
7213	7	/api/summary	GET	200	2026-03-19 16:00:34.301647
7215	7	/api/financial?status=vencido	GET	200	2026-03-19 16:00:34.328235
7223	7	/api/financial?	GET	200	2026-03-19 16:00:40.612821
7247	7	/api/summary	GET	200	2026-03-19 16:10:55.739744
7299	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:15:29.423025
7300	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:15:29.42869
7301	7	/api/summary	GET	200	2026-03-19 16:15:29.477587
7386	7	/api/auth/me	GET	200	2026-03-19 16:21:22.002767
7415	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:21:25.179329
7419	7	/api/financial/categories	GET	200	2026-03-19 16:21:25.504795
7422	7	/api/suppliers	GET	200	2026-03-19 16:21:25.852239
7425	7	/api/products	GET	200	2026-03-19 16:21:26.271106
7430	7	/api/summary	GET	200	2026-03-19 16:21:26.98547
7433	7	/api/clients	GET	200	2026-03-19 16:21:36.044514
7434	7	/api/products	GET	200	2026-03-19 16:21:36.50673
7437	7	/api/summary	GET	200	2026-03-19 16:21:38.797403
7438	7	/api/clients	GET	200	2026-03-19 16:21:40.428146
7441	7	/api/auth/me	GET	200	2026-03-19 16:21:41.915014
3257	7	/api/products	GET	200	2025-11-07 19:43:40.888581
3260	7	/api/products	GET	200	2025-11-07 19:43:41.410788
4095	7	/api/products	GET	304	2025-11-10 18:19:17.562586
4098	7	/api/auth/me	GET	200	2025-11-10 18:19:18.850376
4099	7	/api/clients	GET	304	2025-11-10 18:19:18.867111
4103	7	/api/products	GET	304	2025-11-10 18:19:18.87471
4163	7	/api/orders	GET	304	2025-11-10 18:28:25.532546
4164	7	/api/orders/19/status	PUT	200	2025-11-10 18:28:28.815907
4165	7	/api/orders	GET	200	2025-11-10 18:28:28.821682
4166	7	/api/products	GET	200	2025-11-10 18:28:30.978332
4169	7	/api/clients	GET	304	2025-11-10 18:28:32.776445
4181	7	/api/products	GET	304	2025-11-10 18:28:40.182368
4296	7	/api/clients	GET	304	2025-11-10 18:35:18.749523
4435	7	/api/products	GET	304	2025-11-10 18:41:43.585315
4436	7	/api/orders	POST	201	2025-11-10 18:41:50.246593
4437	7	/api/orders	GET	200	2025-11-10 18:41:50.251738
4438	7	/api/products	GET	304	2025-11-10 18:41:52.629174
4441	7	/api/clients	GET	304	2025-11-10 18:41:55.458177
4445	7	/api/orders	GET	304	2025-11-10 18:41:55.503856
4446	7	/api/orders/22/status	PUT	200	2025-11-10 18:41:58.303137
4447	7	/api/orders	GET	200	2025-11-10 18:41:58.307657
4448	7	/api/products	GET	200	2025-11-10 18:42:01.869627
4451	7	/api/clients	GET	304	2025-11-10 18:42:03.536444
4455	7	/api/orders	GET	304	2025-11-10 18:42:03.545942
4456	7	/api/orders/22/status	PUT	200	2025-11-10 18:42:08.372561
4457	7	/api/orders	GET	200	2025-11-10 18:42:08.377431
4458	7	/api/products	GET	304	2025-11-10 18:42:10.10978
4461	7	/api/clients	GET	304	2025-11-10 18:42:11.119668
4473	7	/api/products	GET	304	2025-11-10 18:42:18.932335
4480	7	/api/clients	GET	304	2025-11-10 18:42:22.582849
4483	7	/api/orders	GET	304	2025-11-10 18:42:22.58961
4605	7	/api/orders	GET	304	2025-11-10 18:46:20.381274
4606	7	/api/orders/24/status	PUT	200	2025-11-10 18:46:22.646504
4607	7	/api/orders	GET	200	2025-11-10 18:46:22.652698
4608	7	/api/products	GET	200	2025-11-10 18:46:23.817787
4611	7	/api/orders	GET	304	2025-11-10 18:46:25.183276
4615	7	/api/clients	GET	304	2025-11-10 18:46:25.192093
4673	7	/api/auth/me	GET	304	2025-11-11 16:30:30.905246
4749	7	/api/auth/me	GET	200	2025-11-11 17:03:34.206865
4816	7	/api/auth/me	GET	304	2026-03-12 16:01:14.194774
4941	7	/api/auth/me	GET	304	2026-03-12 17:26:40.555254
4991	7	/api/orders	GET	304	2026-03-12 18:52:12.097317
4994	7	/api/auth/me	GET	304	2026-03-12 18:52:18.800616
4995	7	/api/clients	GET	304	2026-03-12 18:52:18.83412
5087	\N	/api/auth/me	GET	401	2026-03-12 20:55:38.64331
5155	7	/api/auth/me	GET	304	2026-03-12 21:00:24.617476
5158	7	/api/clients	GET	304	2026-03-12 21:00:24.663872
5161	7	/api/orders	GET	304	2026-03-12 21:00:24.67226
5237	7	/api/orders	GET	304	2026-03-12 21:18:13.856747
5238	7	/api/products	GET	304	2026-03-12 21:18:15.013584
5241	7	/api/clients	GET	304	2026-03-12 21:18:15.431657
5242	7	/api/auth/me	GET	304	2026-03-12 21:18:17.271256
5245	7	/api/auth/me	GET	200	2026-03-12 21:18:19.855206
5246	7	/api/auth/me	GET	200	2026-03-12 21:18:21.559477
5249	7	/api/clients	GET	304	2026-03-12 21:18:29.793682
5250	7	/api/products	GET	304	2026-03-12 21:18:31.417512
5253	7	/api/products	GET	304	2026-03-12 21:18:31.844937
5257	7	/api/orders	GET	304	2026-03-12 21:18:31.889597
5258	7	/api/users	GET	304	2026-03-12 21:18:32.736754
5261	7	/api/products	GET	304	2026-03-12 21:18:33.206334
5274	7	/api/clients	GET	304	2026-03-12 21:18:35.718314
5372	7	/api/orders	GET	304	2026-03-12 21:29:58.14991
5373	7	/api/orders/27	PUT	200	2026-03-12 21:30:06.213919
5374	7	/api/orders	GET	200	2026-03-12 21:30:06.220497
5375	7	/api/orders	POST	201	2026-03-12 21:30:15.67786
5376	7	/api/orders	GET	200	2026-03-12 21:30:15.682425
5377	7	/api/orders/28	PUT	200	2026-03-12 21:30:21.117215
5378	7	/api/orders	GET	200	2026-03-12 21:30:21.123241
5379	7	/api/orders/28	PUT	200	2026-03-12 21:30:25.449002
5380	7	/api/orders	GET	200	2026-03-12 21:30:25.454051
5381	7	/api/orders/28	PUT	200	2026-03-12 21:30:31.459134
5382	7	/api/orders	GET	200	2026-03-12 21:30:31.464645
5482	7	/api/clients	GET	304	2026-03-13 13:48:18.437546
5483	7	/api/products	GET	304	2026-03-13 13:48:19.175205
5575	7	/api/orders	GET	304	2026-03-13 13:59:19.691872
5628	7	/api/auth/me	GET	200	2026-03-13 14:22:11.003426
5629	7	/api/auth/me	GET	200	2026-03-13 14:22:11.00838
5699	7	/api/orders	GET	200	2026-03-13 14:29:33.12309
5702	7	/api/clients	GET	200	2026-03-13 14:29:37.011321
5810	\N	/api/users	GET	401	2026-03-17 20:49:18.425781
5908	7	/api/clients	GET	200	2026-03-17 21:16:52.728562
5911	7	/api/orders	GET	200	2026-03-17 21:16:52.738902
5912	7	/api/products	GET	200	2026-03-17 21:16:53.323974
5915	7	/api/clients	GET	200	2026-03-17 21:16:53.994789
5916	7	/api/summary	GET	200	2026-03-17 21:16:54.710604
6002	7	/api/clients	GET	200	2026-03-17 21:48:09.098082
6108	7	/api/summary	GET	200	2026-03-18 15:42:08.706295
6175	7	/api/suppliers	POST	201	2026-03-18 16:01:10.481793
6176	7	/api/suppliers	GET	200	2026-03-18 16:01:10.486945
6177	7	/api/users	GET	200	2026-03-18 16:01:13.283748
6180	7	/api/products	GET	200	2026-03-18 16:01:16.959109
6240	7	/api/clients	GET	200	2026-03-18 16:17:56.316187
6241	7	/api/clients	POST	201	2026-03-18 16:18:06.018665
6242	7	/api/clients	GET	200	2026-03-18 16:18:06.022861
6243	7	/api/clients	POST	201	2026-03-18 16:18:09.076753
6244	7	/api/clients	GET	200	2026-03-18 16:18:09.080432
6299	7	/api/orders	GET	200	2026-03-18 16:22:03.981526
6306	7	/api/summary	GET	200	2026-03-18 16:22:18.297237
6384	7	/api/auth/me	GET	200	2026-03-18 16:38:03.506965
6385	7	/api/auth/me	GET	200	2026-03-18 16:38:03.511971
6386	7	/api/summary	GET	200	2026-03-18 16:38:03.579983
6389	7	/api/products	GET	200	2026-03-18 16:38:05.088488
6462	7	/api/financial?	GET	200	2026-03-18 17:14:54.741604
6464	7	/api/financial/categories	GET	200	2026-03-18 17:14:54.808758
6562	7	/api/financial/categories	GET	200	2026-03-18 17:38:23.694874
6563	7	/api/financial/17	PUT	200	2026-03-18 17:38:28.345346
6564	7	/api/financial?	GET	200	2026-03-18 17:38:28.352722
6565	7	/api/summary	GET	200	2026-03-18 17:38:29.192516
6568	7	/api/financial/categories	GET	200	2026-03-18 17:38:32.277253
6648	7	/api/auth/me	GET	200	2026-03-18 18:02:55.462768
6652	7	/api/summary	GET	200	2026-03-18 18:02:55.522804
6705	7	/api/summary	GET	200	2026-03-18 18:24:35.787351
6706	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:24:35.794391
6785	7	/api/purchase-orders	POST	201	2026-03-18 21:25:31.490814
6786	7	/api/purchase-orders	GET	200	2026-03-18 21:25:31.495612
6860	7	/api/purchase-orders	GET	200	2026-03-18 21:38:32.247183
6861	7	/api/purchase-orders/2/status	PATCH	200	2026-03-18 21:38:33.606932
3258	7	/api/orders	GET	200	2025-11-07 19:43:40.889925
3259	7	/api/clients	GET	200	2025-11-07 19:43:41.403043
4096	7	/api/orders	GET	304	2025-11-10 18:19:17.566124
4097	7	/api/auth/me	GET	200	2025-11-10 18:19:18.846528
4100	7	/api/products	GET	304	2025-11-10 18:19:18.867677
4104	7	/api/orders	GET	304	2025-11-10 18:19:18.877999
4188	7	/api/auth/me	GET	304	2025-11-10 18:30:16.571792
4202	7	/api/orders	GET	304	2025-11-10 18:30:19.413523
4297	7	/api/products	GET	304	2025-11-10 18:35:18.750075
4301	7	/api/orders	GET	304	2025-11-10 18:35:18.761079
4442	7	/api/orders	GET	304	2025-11-10 18:41:55.499936
4453	7	/api/products	GET	304	2025-11-10 18:42:03.542984
4462	7	/api/products	GET	304	2025-11-10 18:42:11.122074
4465	7	/api/orders	GET	304	2025-11-10 18:42:11.129371
4469	7	/api/products	GET	304	2025-11-10 18:42:17.262012
4470	7	/api/products	GET	304	2025-11-10 18:42:18.924046
4616	7	/api/orders/24	PUT	200	2025-11-10 18:46:43.661612
4617	7	/api/orders	GET	304	2025-11-10 18:46:43.66919
4618	7	/api/products	GET	304	2025-11-10 18:46:45.76899
4621	7	/api/clients	GET	304	2025-11-10 18:46:48.328547
4674	7	/api/auth/me	GET	304	2025-11-11 16:32:48.589224
4675	7	/api/auth/me	GET	304	2025-11-11 16:32:48.594355
4676	7	/api/auth/me	GET	200	2025-11-11 16:32:49.613302
4750	7	/api/auth/me	GET	200	2025-11-11 17:04:56.143467
4817	\N	/api/auth/me	GET	401	2026-03-12 16:50:57.297273
4818	\N	/api/auth/me	GET	401	2026-03-12 16:50:57.297747
4942	7	/api/auth/me	GET	304	2026-03-12 17:26:40.557912
5001	7	/api/products	GET	304	2026-03-12 18:52:49.057661
5088	\N	/api/auth/me	GET	401	2026-03-12 20:55:38.650344
5156	7	/api/clients	GET	304	2026-03-12 21:00:24.656828
5160	7	/api/products	GET	304	2026-03-12 21:00:24.668237
5254	7	/api/products	GET	304	2026-03-12 21:18:31.885702
5263	7	/api/clients	GET	304	2026-03-12 21:18:33.213805
5277	7	/api/orders	GET	304	2026-03-12 21:18:35.72734
5383	7	/api/clients	GET	304	2026-03-12 21:33:12.882962
5386	7	/api/products	GET	304	2026-03-12 21:33:13.69984
5387	7	/api/clients	GET	304	2026-03-12 21:33:14.194834
5486	7	/api/auth/me	GET	304	2026-03-13 13:50:04.355773
5488	7	/api/auth/me	GET	200	2026-03-13 13:50:10.074942
5489	7	/api/auth/me	GET	200	2026-03-13 13:50:12.433908
5577	7	/api/clients	GET	304	2026-03-13 13:59:19.696423
5580	7	/api/products	GET	304	2026-03-13 13:59:21.914357
5581	7	/api/clients	GET	304	2026-03-13 13:59:23.620767
5630	7	/api/products	GET	200	2026-03-13 14:22:24.503817
5633	7	/api/clients	GET	200	2026-03-13 14:22:24.515726
5703	7	/api/clients	POST	201	2026-03-13 14:30:31.327083
5704	7	/api/clients	GET	200	2026-03-13 14:30:31.33168
5811	\N	/api/auth/login	POST	200	2026-03-17 20:51:18.639721
5812	7	/api/clients	GET	200	2026-03-17 20:51:21.621964
5815	7	/api/clients	GET	200	2026-03-17 20:51:25.20464
5816	7	/api/products	GET	200	2026-03-17 20:51:25.890993
5819	7	/api/products	GET	200	2026-03-17 20:51:26.625607
5909	7	/api/products	GET	200	2026-03-17 21:16:52.731128
6004	7	/api/products	GET	200	2026-03-17 21:48:09.113351
6109	7	/api/products	GET	200	2026-03-18 15:42:19.956335
6112	7	/api/clients	GET	200	2026-03-18 15:42:20.543069
6113	7	/api/clients	GET	200	2026-03-18 15:42:21.155624
6115	7	/api/products	GET	200	2026-03-18 15:42:21.163193
6178	7	/api/users	GET	200	2026-03-18 16:01:13.316817
6179	7	/api/clients	GET	200	2026-03-18 16:01:16.957914
6181	7	/api/products	GET	200	2026-03-18 16:01:16.965268
6184	7	/api/orders	GET	200	2026-03-18 16:01:16.999832
6185	7	/api/products	GET	200	2026-03-18 16:01:21.573937
6245	7	/api/clients	POST	201	2026-03-18 16:18:28.705292
6246	7	/api/clients	GET	200	2026-03-18 16:18:28.710048
6307	7	/api/clients	GET	200	2026-03-18 16:22:34.211139
6387	7	/api/summary	GET	200	2026-03-18 16:38:03.618157
6388	7	/api/products	GET	200	2026-03-18 16:38:05.086351
6390	7	/api/products/19	PUT	500	2026-03-18 16:38:11.401956
6391	7	/api/auth/me	GET	200	2026-03-18 16:38:17.995156
6394	7	/api/products	GET	200	2026-03-18 16:38:18.048969
6463	7	/api/financial/categories	GET	200	2026-03-18 17:14:54.806747
6570	7	/api/financial/categories	GET	200	2026-03-18 17:38:32.316758
6649	7	/api/summary	GET	200	2026-03-18 18:02:55.513021
6713	7	/api/clients	GET	200	2026-03-18 18:24:48.998068
6716	7	/api/products	GET	200	2026-03-18 18:24:49.010576
6721	7	/api/purchase-orders	GET	500	2026-03-18 18:24:58.329648
6787	7	/api/purchase-orders/1/status	PATCH	404	2026-03-18 21:25:48.995117
6862	7	/api/purchase-orders	GET	200	2026-03-18 21:38:33.616394
6863	7	/api/products	GET	200	2026-03-18 21:38:41.569006
6866	7	/api/purchase-orders	GET	200	2026-03-18 21:38:45.144596
6868	7	/api/suppliers	GET	200	2026-03-18 21:38:45.18804
6951	7	/api/financial?status=vencido	GET	200	2026-03-18 21:42:28.698739
6960	7	/api/financial/categories	GET	200	2026-03-18 21:42:28.774894
7035	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:48:38.576382
7098	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-18 21:52:20.159298
7150	7	/api/financial?status=vencido	GET	200	2026-03-19 15:56:23.354031
7152	7	/api/financial?status=vencido	GET	200	2026-03-19 15:56:23.918477
7157	7	/api/financial?	GET	200	2026-03-19 15:56:29.986551
7161	7	/api/financial?status=vencido	GET	200	2026-03-19 15:56:39.205672
7165	7	/api/summary	GET	200	2026-03-19 15:56:40.469878
7166	7	/api/clients	GET	200	2026-03-19 15:56:43.481053
7169	7	/api/summary	GET	200	2026-03-19 15:56:43.928144
7170	7	/api/auth/me	GET	200	2026-03-19 15:56:44.928897
7172	7	/api/financial?status=vencido	GET	200	2026-03-19 15:56:44.968246
7174	7	/api/summary	GET	200	2026-03-19 15:56:44.981357
7181	7	/api/products	GET	200	2026-03-19 15:56:47.73586
7191	7	/api/financial/categories	GET	200	2026-03-19 15:56:49.455028
7214	7	/api/financial?status=vencido	GET	200	2026-03-19 16:00:34.322525
7216	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:00:34.331558
7219	7	/api/summary	GET	200	2026-03-19 16:00:34.362876
7222	7	/api/financial/categories	GET	200	2026-03-19 16:00:40.609173
7248	7	/api/summary	GET	200	2026-03-19 16:10:55.778582
7250	7	/api/financial?status=vencido	GET	200	2026-03-19 16:10:55.852769
7303	7	/api/auth/me	GET	200	2026-03-19 16:17:02.002151
7331	7	/api/orders?	GET	200	2026-03-19 16:17:09.713314
7333	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:17:09.723683
7336	7	/api/financial/categories	GET	200	2026-03-19 16:17:10.245149
7344	7	/api/purchase-orders	GET	200	2026-03-19 16:17:10.999992
7355	7	/api/clients	GET	200	2026-03-19 16:17:15.49654
7363	7	/api/products	GET	200	2026-03-19 16:17:19.297516
7368	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:17:19.30497
7373	7	/api/financial?	GET	200	2026-03-19 16:17:20.029747
3262	7	/api/orders	GET	200	2025-11-07 19:43:41.412658
4105	\N	/api/auth/me	GET	401	2025-11-10 18:21:03.812709
4189	7	/api/auth/me	GET	304	2025-11-10 18:30:16.57272
4191	7	/api/products	GET	304	2025-11-10 18:30:16.59659
4192	7	/api/auth/me	GET	200	2025-11-10 18:30:17.592757
4195	7	/api/products	GET	304	2025-11-10 18:30:17.612748
4196	7	/api/auth/me	GET	200	2025-11-10 18:30:18.306814
4199	7	/api/products	GET	304	2025-11-10 18:30:18.327412
4200	7	/api/products	GET	304	2025-11-10 18:30:19.406844
4204	7	/api/orders	GET	304	2025-11-10 18:30:19.420139
4207	7	/api/products	GET	304	2025-11-10 18:30:27.50686
4208	7	/api/products	GET	304	2025-11-10 18:30:29.449998
4222	7	/api/clients	GET	304	2025-11-10 18:30:35.373953
4298	7	/api/orders	GET	304	2025-11-10 18:35:18.754933
4443	7	/api/products	GET	304	2025-11-10 18:41:55.500435
4452	7	/api/orders	GET	304	2025-11-10 18:42:03.542101
4463	7	/api/clients	GET	304	2025-11-10 18:42:11.124908
4472	7	/api/orders	GET	304	2025-11-10 18:42:18.925398
4619	7	/api/products	GET	304	2025-11-10 18:46:45.774799
4620	7	/api/products	GET	304	2025-11-10 18:46:48.325693
4622	7	/api/clients	GET	304	2025-11-10 18:46:48.33542
4625	7	/api/orders	GET	304	2025-11-10 18:46:48.373216
4677	7	/api/auth/me	GET	200	2025-11-11 16:32:49.722897
4678	7	/api/auth/me	GET	304	2025-11-11 16:32:52.563558
4751	7	/api/auth/me	GET	200	2025-11-11 17:04:56.143592
4819	\N	/api/auth/login	POST	200	2026-03-12 16:51:11.444835
4820	7	/api/clients	GET	200	2026-03-12 16:51:15.165911
4823	7	/api/products	GET	304	2026-03-12 16:51:17.469456
4824	7	/api/clients	GET	304	2026-03-12 16:51:18.212504
4943	7	/api/auth/me	GET	304	2026-03-12 17:26:40.585177
4946	7	/api/products	GET	304	2026-03-12 17:26:40.602331
5002	7	/api/products	GET	304	2026-03-12 18:52:49.090163
5089	\N	/api/auth/login	POST	200	2026-03-12 20:56:03.850983
5090	7	/api/clients	GET	304	2026-03-12 20:56:06.729575
5093	7	/api/products	GET	304	2026-03-12 20:56:07.963556
5094	7	/api/clients	GET	304	2026-03-12 20:56:08.817539
5096	7	/api/orders	GET	304	2026-03-12 20:56:08.825037
5105	7	/api/products	GET	304	2026-03-12 20:56:12.099492
5110	7	/api/products	GET	304	2026-03-12 20:56:14.632602
5113	7	/api/users	GET	304	2026-03-12 20:56:15.504916
5114	7	/api/clients	GET	304	2026-03-12 20:56:16.51059
5157	7	/api/products	GET	304	2026-03-12 21:00:24.659214
5255	7	/api/orders	GET	304	2026-03-12 21:18:31.886178
5262	7	/api/orders	GET	304	2026-03-12 21:18:33.208617
5267	7	/api/products	GET	304	2026-03-12 21:18:33.626513
5268	7	/api/clients	GET	304	2026-03-12 21:18:34.032518
5271	7	/api/products	GET	304	2026-03-12 21:18:35.29551
5272	7	/api/products	GET	304	2026-03-12 21:18:35.716426
5384	7	/api/clients	GET	304	2026-03-12 21:33:12.915346
5385	7	/api/products	GET	304	2026-03-12 21:33:13.694606
5388	7	/api/products	GET	304	2026-03-12 21:33:14.195442
5485	7	/api/auth/me	GET	304	2026-03-13 13:50:04.355691
5487	7	/api/auth/me	GET	200	2026-03-13 13:50:10.07283
5490	7	/api/auth/me	GET	200	2026-03-13 13:50:12.436724
5578	7	/api/products	GET	304	2026-03-13 13:59:19.699614
5579	7	/api/products	GET	304	2026-03-13 13:59:21.906796
5582	7	/api/clients	GET	304	2026-03-13 13:59:23.627323
5631	7	/api/clients	GET	200	2026-03-13 14:22:24.507824
5634	7	/api/orders	GET	200	2026-03-13 14:22:24.519316
5705	7	/api/clients/8	PUT	200	2026-03-13 14:30:47.212319
5706	7	/api/clients	GET	200	2026-03-13 14:30:47.217195
5707	7	/api/products	GET	200	2026-03-13 14:30:51.172078
5813	7	/api/clients	GET	200	2026-03-17 20:51:21.658319
5814	7	/api/clients	GET	200	2026-03-17 20:51:25.202075
5817	7	/api/products	GET	200	2026-03-17 20:51:25.895046
5818	7	/api/clients	GET	200	2026-03-17 20:51:26.625021
5910	7	/api/orders	GET	200	2026-03-17 21:16:52.73246
5913	7	/api/products	GET	200	2026-03-17 21:16:53.328483
5914	7	/api/clients	GET	200	2026-03-17 21:16:53.992754
5917	7	/api/summary	GET	200	2026-03-17 21:16:54.714516
6006	7	/api/summary	GET	200	2026-03-17 21:48:34.70094
6110	7	/api/products	GET	200	2026-03-18 15:42:19.989196
6111	7	/api/clients	GET	200	2026-03-18 15:42:20.538779
6114	7	/api/products	GET	200	2026-03-18 15:42:21.156545
6182	7	/api/clients	GET	200	2026-03-18 16:01:16.99512
6247	7	/api/clients	POST	201	2026-03-18 16:18:39.736066
6248	7	/api/clients	GET	200	2026-03-18 16:18:39.745447
6308	7	/api/products	GET	200	2026-03-18 16:22:34.212389
6310	7	/api/orders	GET	200	2026-03-18 16:22:34.269271
6392	7	/api/auth/me	GET	200	2026-03-18 16:38:18.031508
6393	7	/api/products	GET	200	2026-03-18 16:38:18.045971
6465	7	/api/financial	POST	201	2026-03-18 17:15:36.267096
6466	7	/api/financial?	GET	200	2026-03-18 17:15:36.275049
6467	7	/api/summary	GET	200	2026-03-18 17:15:37.179052
6470	7	/api/auth/me	GET	200	2026-03-18 17:15:38.96706
6471	7	/api/summary	GET	200	2026-03-18 17:15:39.027902
6571	7	/api/summary	GET	200	2026-03-18 17:41:53.57743
6650	7	/api/financial?status=vencido	GET	200	2026-03-18 18:02:55.514048
6714	7	/api/products	GET	200	2026-03-18 18:24:49.004807
6717	7	/api/orders	GET	200	2026-03-18 18:24:49.014405
6720	7	/api/products	GET	200	2026-03-18 18:24:50.061553
6788	7	/api/financial/categories	GET	200	2026-03-18 21:25:59.829962
6790	7	/api/financial?	GET	200	2026-03-18 21:25:59.840467
6792	7	/api/suppliers	GET	200	2026-03-18 21:26:02.47382
6867	7	/api/suppliers	GET	200	2026-03-18 21:38:45.185739
6955	7	/api/financial?status=vencido	GET	200	2026-03-18 21:42:28.744745
6956	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:42:28.757294
6957	7	/api/financial?	GET	200	2026-03-18 21:42:28.772691
7036	7	/api/summary?from=2026-03-17&to=2026-03-17	GET	200	2026-03-18 21:49:38.417007
7099	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-18 21:52:20.159773
7112	7	/api/orders	GET	200	2026-03-18 21:52:21.16845
7154	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:56:23.955195
7155	7	/api/financial?	GET	200	2026-03-19 15:56:29.981761
7158	7	/api/financial/categories	GET	200	2026-03-19 15:56:29.987449
7159	7	/api/financial/17	PUT	200	2026-03-19 15:56:34.203813
7160	7	/api/financial?	GET	200	2026-03-19 15:56:34.208666
7162	7	/api/summary	GET	200	2026-03-19 15:56:39.245158
7163	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:56:39.249841
7164	7	/api/summary	GET	200	2026-03-19 15:56:40.458974
7167	7	/api/clients	GET	200	2026-03-19 15:56:43.482825
7168	7	/api/summary	GET	200	2026-03-19 15:56:43.923603
7171	7	/api/auth/me	GET	200	2026-03-19 15:56:44.930345
7173	7	/api/summary	GET	200	2026-03-19 15:56:44.97298
7175	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:56:44.982485
7177	7	/api/summary	GET	200	2026-03-19 15:56:45.013539
3263	7	/api/products	GET	200	2025-11-07 19:43:41.413243
4106	\N	/api/auth/me	GET	401	2025-11-10 18:21:03.81287
4190	7	/api/products	GET	304	2025-11-10 18:30:16.591497
4193	7	/api/auth/me	GET	200	2025-11-10 18:30:17.596583
4194	7	/api/products	GET	304	2025-11-10 18:30:17.609059
4197	7	/api/auth/me	GET	200	2025-11-10 18:30:18.309225
4198	7	/api/products	GET	304	2025-11-10 18:30:18.323227
4201	7	/api/clients	GET	304	2025-11-10 18:30:19.407498
4203	7	/api/clients	GET	304	2025-11-10 18:30:19.414456
4302	7	/api/auth/me	GET	304	2025-11-10 18:35:42.72967
4306	7	/api/clients	GET	304	2025-11-10 18:35:42.773434
4314	7	/api/orders	GET	304	2025-11-10 18:35:46.718829
4444	7	/api/clients	GET	304	2025-11-10 18:41:55.501036
4449	7	/api/products	GET	304	2025-11-10 18:42:01.875719
4450	7	/api/products	GET	304	2025-11-10 18:42:03.535641
4623	7	/api/products	GET	304	2025-11-10 18:46:48.368624
4679	7	/api/auth/me	GET	304	2025-11-11 16:32:52.566952
4752	\N	/api/auth/login	POST	200	2025-11-11 17:06:56.602282
4821	7	/api/clients	GET	304	2026-03-12 16:51:15.202066
4822	7	/api/products	GET	200	2026-03-12 16:51:17.464084
4825	7	/api/products	GET	304	2026-03-12 16:51:18.213286
4944	7	/api/auth/me	GET	304	2026-03-12 17:26:40.589152
5003	7	/api/clients	GET	304	2026-03-12 18:57:13.445374
5006	7	/api/products	GET	304	2026-03-12 18:57:14.292987
5007	7	/api/clients	GET	304	2026-03-12 18:57:14.877832
5091	7	/api/clients	GET	304	2026-03-12 20:56:06.758988
5092	7	/api/products	GET	304	2026-03-12 20:56:07.958439
5095	7	/api/products	GET	304	2026-03-12 20:56:08.818073
5097	7	/api/orders	GET	304	2026-03-12 20:56:08.830989
5103	7	/api/clients	GET	304	2026-03-12 20:56:12.091812
5107	7	/api/orders	GET	304	2026-03-12 20:56:12.10057
5108	7	/api/auth/me	GET	304	2026-03-12 20:56:14.603594
5116	7	/api/orders	GET	304	2026-03-12 20:56:16.518254
5159	7	/api/orders	GET	304	2026-03-12 21:00:24.664787
5256	7	/api/clients	GET	304	2026-03-12 21:18:31.886831
5259	7	/api/users	GET	304	2026-03-12 21:18:32.741564
5260	7	/api/clients	GET	304	2026-03-12 21:18:33.205682
5276	7	/api/clients	GET	304	2026-03-12 21:18:35.726572
5389	7	/api/clients	GET	304	2026-03-12 21:33:14.239536
5491	7	/api/clients	GET	304	2026-03-13 13:50:34.453188
5494	7	/api/clients	GET	304	2026-03-13 13:50:35.492339
5495	7	/api/products	GET	304	2026-03-13 13:50:35.854186
5498	7	/api/products	GET	304	2026-03-13 13:50:36.307174
5583	7	/api/clients	GET	304	2026-03-13 13:59:47.548299
5586	7	/api/products	GET	304	2026-03-13 13:59:48.699079
5587	7	/api/clients	GET	304	2026-03-13 13:59:49.973418
5632	7	/api/orders	GET	200	2026-03-13 14:22:24.509048
5708	7	/api/products	GET	200	2026-03-13 14:30:51.209036
5820	7	/api/clients	GET	200	2026-03-17 20:51:26.677564
5823	7	/api/orders	GET	200	2026-03-17 20:51:26.687599
5824	7	/api/users	GET	200	2026-03-17 20:51:27.290316
5918	7	/api/clients	GET	200	2026-03-17 21:29:49.881328
5921	7	/api/products	GET	200	2026-03-17 21:29:50.406564
5922	7	/api/clients	GET	200	2026-03-17 21:29:50.883807
6007	7	/api/summary	GET	200	2026-03-17 21:48:34.740175
6116	7	/api/clients	GET	200	2026-03-18 15:42:21.197477
6118	7	/api/orders	GET	200	2026-03-18 15:42:21.206296
6119	7	/api/users	GET	200	2026-03-18 15:42:22.431862
6122	\N	/api/suppliers	GET	404	2026-03-18 15:42:23.032233
6123	7	/api/auth/me	GET	200	2026-03-18 15:42:26.553712
6126	\N	/api/suppliers	GET	404	2026-03-18 15:42:26.593268
6183	7	/api/orders	GET	200	2026-03-18 16:01:16.996111
6186	7	/api/products	GET	200	2026-03-18 16:01:21.579009
6249	7	/api/clients	POST	201	2026-03-18 16:18:52.007148
6250	7	/api/clients	GET	200	2026-03-18 16:18:52.01175
6309	7	/api/orders	GET	200	2026-03-18 16:22:34.262601
6395	7	/api/auth/me	GET	200	2026-03-18 16:39:32.322755
6468	7	/api/summary	GET	200	2026-03-18 17:15:37.222958
6469	7	/api/auth/me	GET	200	2026-03-18 17:15:38.965567
6472	7	/api/summary	GET	200	2026-03-18 17:15:39.031593
6572	7	/api/summary	GET	200	2026-03-18 17:41:53.621501
6651	7	/api/financial?status=vencido	GET	200	2026-03-18 18:02:55.514981
6653	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:02:55.524081
6715	7	/api/orders	GET	200	2026-03-18 18:24:49.007503
6723	7	/api/products	GET	200	2026-03-18 18:24:58.336428
6789	7	/api/financial?	GET	200	2026-03-18 21:25:59.834786
6793	7	/api/products	GET	200	2026-03-18 21:26:02.476259
6869	7	/api/products	GET	200	2026-03-18 21:38:45.188962
6874	7	/api/products	GET	200	2026-03-18 21:38:53.592298
6876	7	/api/financial?	GET	200	2026-03-18 21:38:58.463341
6961	7	/api/purchase-orders	GET	200	2026-03-18 21:46:25.920811
6963	7	/api/suppliers	GET	200	2026-03-18 21:46:25.974876
6966	7	/api/products	GET	200	2026-03-18 21:46:25.987768
6967	7	/api/auth/me	GET	200	2026-03-18 21:46:27.680477
6969	7	/api/financial?status=vencido	GET	200	2026-03-18 21:46:27.706227
6975	7	/api/purchase-orders	GET	200	2026-03-18 21:46:27.742726
6978	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:46:27.755641
7037	7	/api/summary	GET	200	2026-03-18 21:49:56.501949
7038	7	/api/clients	GET	200	2026-03-18 21:50:02.212977
7041	7	/api/products	GET	200	2026-03-18 21:50:05.66893
7042	7	/api/clients	GET	200	2026-03-18 21:50:06.380567
7053	7	/api/products	GET	200	2026-03-18 21:50:07.281617
7056	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-18 21:50:07.295211
7063	7	/api/financial?	GET	200	2026-03-18 21:50:07.720353
7068	7	/api/purchase-orders	GET	200	2026-03-18 21:50:08.753021
7100	7	/api/clients	GET	200	2026-03-18 21:52:20.161743
7111	7	/api/products	GET	200	2026-03-18 21:52:21.161229
7114	7	/api/products	GET	200	2026-03-18 21:52:21.817093
7115	7	/api/clients	GET	200	2026-03-18 21:52:22.43671
7118	7	/api/summary	GET	200	2026-03-18 21:52:22.852891
7176	7	/api/financial?status=vencido	GET	200	2026-03-19 15:56:45.00782
7179	7	/api/summary	GET	200	2026-03-19 15:56:45.02722
7183	7	/api/purchase-orders	GET	200	2026-03-19 15:56:47.741616
7190	7	/api/financial?	GET	200	2026-03-19 15:56:49.45432
7217	7	/api/summary	GET	200	2026-03-19 16:00:34.349551
7218	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:00:34.357543
7220	7	/api/summary	GET	200	2026-03-19 16:00:34.367983
7221	7	/api/financial?	GET	200	2026-03-19 16:00:40.608369
7249	7	/api/financial?status=vencido	GET	200	2026-03-19 16:10:55.848107
7251	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:10:55.853569
7252	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:10:55.857106
7304	7	/api/financial?status=vencido	GET	200	2026-03-19 16:17:02.047704
7311	7	/api/summary	GET	200	2026-03-19 16:17:02.089868
7314	7	/api/clients	GET	200	2026-03-19 16:17:06.540133
3264	7	/api/orders	GET	200	2025-11-07 19:43:41.414038
3265	7	/api/clients	GET	200	2025-11-07 19:44:13.664556
3266	7	/api/products	GET	200	2025-11-07 19:44:13.67053
3267	7	/api/clients	GET	200	2025-11-07 19:44:13.671625
3268	7	/api/orders	GET	200	2025-11-07 19:44:13.672807
3269	7	/api/products	GET	200	2025-11-07 19:44:13.674632
3270	7	/api/orders	GET	200	2025-11-07 19:44:13.677781
3271	7	/api/orders	POST	500	2025-11-07 19:44:34.827314
3272	7	/api/clients	GET	200	2025-11-07 19:46:44.581743
3273	7	/api/clients	GET	200	2025-11-07 19:46:44.628141
3274	7	/api/products	GET	200	2025-11-07 19:46:44.629718
3275	7	/api/orders	GET	200	2025-11-07 19:46:44.630998
3276	7	/api/products	GET	200	2025-11-07 19:46:44.634299
3277	7	/api/orders	GET	200	2025-11-07 19:46:44.637857
3278	7	/api/orders	POST	201	2025-11-07 19:46:54.447621
3279	7	/api/orders	GET	200	2025-11-07 19:46:54.452693
3280	7	/api/products	GET	200	2025-11-07 19:47:04.439339
3281	7	/api/products	GET	304	2025-11-07 19:47:04.476361
3282	7	/api/products	GET	304	2025-11-07 19:47:06.773932
3283	7	/api/clients	GET	304	2025-11-07 19:47:06.776351
3284	7	/api/products	GET	304	2025-11-07 19:47:06.819499
3285	7	/api/clients	GET	304	2025-11-07 19:47:06.820144
3286	7	/api/orders	GET	304	2025-11-07 19:47:06.822209
3287	7	/api/orders	GET	304	2025-11-07 19:47:06.826688
3288	7	/api/orders/18	PUT	500	2025-11-07 19:47:13.084261
3289	7	/api/products	GET	200	2025-11-07 19:47:22.239984
3290	7	/api/products	GET	304	2025-11-07 19:47:22.244354
3291	7	/api/products	GET	304	2025-11-07 19:47:24.983292
3292	7	/api/clients	GET	304	2025-11-07 19:47:24.984412
3293	7	/api/orders	GET	304	2025-11-07 19:47:25.021783
3294	7	/api/orders	GET	304	2025-11-07 19:47:25.024734
3295	7	/api/clients	GET	304	2025-11-07 19:47:25.029266
3296	7	/api/products	GET	304	2025-11-07 19:47:25.12749
3297	7	/api/clients	GET	200	2025-11-07 19:48:26.581887
3298	7	/api/products	GET	200	2025-11-07 19:48:26.63872
3299	7	/api/clients	GET	200	2025-11-07 19:48:26.639933
3300	7	/api/orders	GET	200	2025-11-07 19:48:26.641888
3301	7	/api/products	GET	200	2025-11-07 19:48:26.643947
3302	7	/api/orders	GET	200	2025-11-07 19:48:26.647412
3303	7	/api/products	GET	304	2025-11-07 19:48:30.119717
3304	7	/api/products	GET	304	2025-11-07 19:48:30.125657
3305	7	/api/products/8	PUT	200	2025-11-07 19:48:36.770576
3306	7	/api/products	GET	200	2025-11-07 19:48:36.777211
3307	7	/api/products	GET	304	2025-11-07 19:48:37.66675
3308	7	/api/clients	GET	304	2025-11-07 19:48:37.669249
3309	7	/api/products	GET	304	2025-11-07 19:48:37.712255
3310	7	/api/clients	GET	304	2025-11-07 19:48:37.712861
3311	7	/api/orders	GET	304	2025-11-07 19:48:37.713523
3312	7	/api/orders	GET	304	2025-11-07 19:48:37.71889
3313	7	/api/orders/18	PUT	500	2025-11-07 19:48:45.506721
3314	7	/api/products	GET	200	2025-11-07 19:48:57.606547
3315	7	/api/products	GET	304	2025-11-07 19:48:57.641875
3316	7	/api/products/8	PUT	200	2025-11-07 19:50:03.981048
3317	7	/api/products	GET	200	2025-11-07 19:50:03.988517
3318	7	/api/products	GET	304	2025-11-07 19:50:04.916211
3319	7	/api/clients	GET	304	2025-11-07 19:50:04.956039
3320	7	/api/orders	GET	304	2025-11-07 19:50:04.959216
3321	7	/api/clients	GET	304	2025-11-07 19:50:04.960029
3322	7	/api/products	GET	304	2025-11-07 19:50:04.96453
3323	7	/api/orders	GET	304	2025-11-07 19:50:04.96567
3324	7	/api/clients	GET	500	2025-11-07 19:50:20.509376
3325	7	/api/orders	GET	304	2025-11-07 19:50:20.513862
3326	7	/api/clients	GET	200	2025-11-07 19:50:20.519548
3327	7	/api/orders	GET	304	2025-11-07 19:50:20.523969
3328	7	/api/products	GET	304	2025-11-07 19:50:20.55377
3329	7	/api/products	GET	304	2025-11-07 19:50:23.473417
3330	7	/api/products	GET	304	2025-11-07 19:50:23.478601
3331	7	/api/clients	GET	304	2025-11-07 19:50:26.182656
3332	7	/api/products	GET	304	2025-11-07 19:50:26.183478
3333	7	/api/orders	GET	304	2025-11-07 19:50:26.189486
3334	7	/api/clients	GET	304	2025-11-07 19:50:26.190066
3335	7	/api/products	GET	304	2025-11-07 19:50:26.228119
3336	7	/api/orders	GET	304	2025-11-07 19:50:26.229669
3337	7	/api/clients	GET	304	2025-11-07 19:50:34.854846
3338	7	/api/products	GET	304	2025-11-07 19:50:34.8559
3339	7	/api/orders	GET	304	2025-11-07 19:50:34.861069
3340	7	/api/clients	GET	304	2025-11-07 19:50:34.861655
3341	7	/api/products	GET	304	2025-11-07 19:50:34.862175
3342	7	/api/orders	GET	304	2025-11-07 19:50:34.89699
3343	7	/api/products	GET	304	2025-11-07 19:55:03.517976
3344	7	/api/products	GET	304	2025-11-07 19:55:03.552619
3345	7	/api/products	GET	200	2025-11-07 19:55:53.254409
3346	7	/api/products	GET	200	2025-11-07 19:55:53.287582
3347	7	/api/products	GET	304	2025-11-07 19:55:57.761156
3348	7	/api/clients	GET	304	2025-11-07 19:55:57.768799
3349	7	/api/orders	GET	304	2025-11-07 19:55:57.775192
3350	7	/api/orders	GET	304	2025-11-07 19:55:57.780922
3351	7	/api/products	GET	304	2025-11-07 19:55:57.810495
3352	7	/api/clients	GET	304	2025-11-07 19:55:57.812883
3353	7	/api/orders/18	PUT	500	2025-11-07 19:56:01.759218
3354	7	/api/clients	GET	200	2025-11-07 19:57:39.174489
3355	7	/api/products	GET	200	2025-11-07 19:57:39.231529
3356	7	/api/clients	GET	200	2025-11-07 19:57:39.232783
3357	7	/api/orders	GET	200	2025-11-07 19:57:39.234339
3358	7	/api/products	GET	200	2025-11-07 19:57:39.239276
3359	7	/api/orders	GET	200	2025-11-07 19:57:39.240692
3360	7	/api/products	GET	304	2025-11-07 19:57:41.050802
3361	7	/api/products	GET	304	2025-11-07 19:57:41.055226
3362	7	/api/clients	GET	304	2025-11-07 19:57:43.543839
3363	7	/api/products	GET	304	2025-11-07 19:57:43.544638
3364	7	/api/orders	GET	304	2025-11-07 19:57:43.545428
3365	7	/api/clients	GET	304	2025-11-07 19:57:43.553439
3366	7	/api/products	GET	304	2025-11-07 19:57:43.554728
3367	7	/api/orders	GET	304	2025-11-07 19:57:43.557344
3368	7	/api/orders/18	PUT	500	2025-11-07 19:57:48.422344
3369	7	/api/clients	GET	200	2025-11-07 19:59:56.819956
3370	7	/api/products	GET	200	2025-11-07 19:59:56.877534
3371	7	/api/clients	GET	200	2025-11-07 19:59:56.880275
3372	7	/api/orders	GET	200	2025-11-07 19:59:56.882066
3373	7	/api/products	GET	200	2025-11-07 19:59:56.883478
3374	7	/api/orders	GET	200	2025-11-07 19:59:56.885168
3375	7	/api/orders/18	PUT	500	2025-11-07 20:00:00.404718
3376	7	/api/products	GET	200	2025-11-07 20:02:01.490436
3377	7	/api/products	GET	304	2025-11-07 20:02:01.639771
3378	\N	/api/products	GET	401	2025-11-07 20:02:05.50601
3379	\N	/api/orders	GET	401	2025-11-07 20:02:05.51212
3380	\N	/api/clients	GET	401	2025-11-07 20:02:05.569735
3381	\N	/api/products	GET	401	2025-11-07 20:02:05.569972
3382	\N	/api/clients	GET	401	2025-11-07 20:02:05.57012
3383	\N	/api/orders	GET	401	2025-11-07 20:02:05.570939
3384	\N	/api/clients	GET	401	2025-11-07 20:02:07.60983
4107	\N	/api/auth/login	POST	200	2025-11-10 18:21:53.750839
4109	7	/api/products	GET	304	2025-11-10 18:22:00.278239
4205	7	/api/products	GET	304	2025-11-10 18:30:19.446135
4206	7	/api/products	GET	304	2025-11-10 18:30:27.503336
4209	7	/api/clients	GET	304	2025-11-10 18:30:29.4505
4212	7	/api/orders	GET	304	2025-11-10 18:30:29.496833
4220	7	/api/orders	GET	304	2025-11-10 18:30:35.365996
4303	7	/api/clients	GET	304	2025-11-10 18:35:42.766226
4307	7	/api/products	GET	304	2025-11-10 18:35:42.777034
4312	7	/api/clients	GET	304	2025-11-10 18:35:46.71329
4474	7	/api/orders	GET	304	2025-11-10 18:42:18.966785
4477	7	/api/products	GET	304	2025-11-10 18:42:20.286618
4478	7	/api/clients	GET	304	2025-11-10 18:42:22.574783
4481	7	/api/orders	GET	304	2025-11-10 18:42:22.586133
4624	7	/api/orders	GET	304	2025-11-10 18:46:48.369458
4680	7	/api/auth/me	GET	304	2025-11-11 16:41:13.972408
4687	7	/api/orders	GET	304	2025-11-11 16:41:16.446486
4753	7	/api/auth/me	GET	200	2025-11-11 17:08:34.563567
4826	7	/api/clients	GET	304	2026-03-12 16:51:18.258842
4945	7	/api/products	GET	304	2026-03-12 17:26:40.595683
5004	7	/api/clients	GET	304	2026-03-12 18:57:13.477305
5005	7	/api/products	GET	304	2026-03-12 18:57:14.284795
5008	7	/api/products	GET	304	2026-03-12 18:57:14.879073
5098	7	/api/clients	GET	304	2026-03-12 20:56:08.857804
5101	7	/api/auth/me	GET	304	2026-03-12 20:56:12.05749
5102	7	/api/products	GET	304	2026-03-12 20:56:12.091322
5106	7	/api/clients	GET	304	2026-03-12 20:56:12.099982
5109	7	/api/auth/me	GET	304	2026-03-12 20:56:14.605573
5111	7	/api/products	GET	304	2026-03-12 20:56:14.635883
5112	7	/api/users	GET	304	2026-03-12 20:56:15.500696
5115	7	/api/products	GET	304	2026-03-12 20:56:16.511541
5162	7	/api/auth/me	GET	304	2026-03-12 21:00:42.820564
5163	7	/api/auth/me	GET	304	2026-03-12 21:00:42.820172
5166	7	/api/clients	GET	304	2026-03-12 21:00:42.859376
5265	7	/api/orders	GET	304	2026-03-12 21:18:33.350041
5266	7	/api/products	GET	304	2026-03-12 21:18:33.620835
5269	7	/api/clients	GET	304	2026-03-12 21:18:34.035252
5270	7	/api/products	GET	304	2026-03-12 21:18:35.292241
5273	7	/api/orders	GET	304	2026-03-12 21:18:35.717622
5390	7	/api/products	GET	304	2026-03-12 21:33:14.240804
5392	7	/api/orders	GET	304	2026-03-12 21:33:14.249167
5393	7	/api/users	GET	304	2026-03-12 21:33:14.65951
5396	7	/api/auth/me	GET	304	2026-03-12 21:33:21.44768
5397	7	/api/auth/me	GET	200	2026-03-12 21:33:23.169308
5492	7	/api/clients	GET	304	2026-03-13 13:50:34.482196
5493	7	/api/clients	GET	304	2026-03-13 13:50:35.489493
5496	7	/api/products	GET	304	2026-03-13 13:50:35.85899
5497	7	/api/clients	GET	304	2026-03-13 13:50:36.306468
5584	7	/api/clients	GET	304	2026-03-13 13:59:47.580113
5585	7	/api/products	GET	304	2026-03-13 13:59:48.693197
5588	7	/api/products	GET	304	2026-03-13 13:59:49.975357
5598	7	/api/products	GET	304	2026-03-13 13:59:53.330626
5635	7	/api/products	GET	200	2026-03-13 14:22:24.544302
5709	7	/api/products	POST	500	2026-03-13 14:31:26.576831
5710	7	/api/products	POST	500	2026-03-13 14:31:35.339506
5821	7	/api/orders	GET	200	2026-03-17 20:51:26.681332
5919	7	/api/clients	GET	200	2026-03-17 21:29:50.026118
5920	7	/api/products	GET	200	2026-03-17 21:29:50.402091
5923	7	/api/products	GET	200	2026-03-17 21:29:50.886067
5926	7	/api/orders	GET	200	2026-03-17 21:29:50.936077
5929	7	/api/users	GET	200	2026-03-17 21:29:51.48159
5930	7	/api/summary	GET	200	2026-03-17 21:29:54.451282
6008	\N	/api/clients	GET	401	2026-03-17 21:51:47.910264
6117	7	/api/orders	GET	200	2026-03-18 15:42:21.200571
6120	7	/api/users	GET	200	2026-03-18 15:42:22.436685
6121	\N	/api/suppliers	GET	404	2026-03-18 15:42:23.031456
6124	7	/api/auth/me	GET	200	2026-03-18 15:42:26.555938
6125	\N	/api/suppliers	GET	404	2026-03-18 15:42:26.591777
6187	7	/api/auth/me	GET	200	2026-03-18 16:02:12.806729
6251	7	/api/clients	POST	201	2026-03-18 16:19:08.632027
6252	7	/api/clients	GET	200	2026-03-18 16:19:08.636792
6311	7	/api/clients	GET	200	2026-03-18 16:22:34.297122
6322	7	/api/summary	GET	200	2026-03-18 16:23:01.029281
6323	7	/api/clients	GET	200	2026-03-18 16:23:07.1417
6396	7	/api/auth/me	GET	200	2026-03-18 16:39:32.327773
6473	7	/api/clients	GET	200	2026-03-18 17:18:45.567169
6476	7	/api/products	GET	200	2026-03-18 17:18:46.329494
6477	7	/api/clients	GET	200	2026-03-18 17:18:47.196551
6479	7	/api/products	GET	200	2026-03-18 17:18:47.202367
6487	7	/api/financial/categories	GET	200	2026-03-18 17:18:48.430128
6490	7	/api/suppliers	GET	200	2026-03-18 17:18:49.169611
6491	7	/api/summary	GET	200	2026-03-18 17:18:50.055471
6573	7	/api/auth/me	GET	200	2026-03-18 17:42:11.194946
6574	7	/api/summary	GET	200	2026-03-18 17:42:11.2448
6654	7	/api/summary	GET	200	2026-03-18 18:02:55.525715
6655	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:02:55.543777
6718	7	/api/clients	GET	200	2026-03-18 18:24:49.032517
6719	7	/api/products	GET	200	2026-03-18 18:24:50.059569
6722	7	/api/suppliers	GET	200	2026-03-18 18:24:58.331103
6724	7	/api/purchase-orders	GET	500	2026-03-18 18:24:58.370302
6791	7	/api/financial/categories	GET	200	2026-03-18 21:25:59.865741
6794	7	/api/purchase-orders	GET	200	2026-03-18 21:26:02.477888
6870	7	/api/purchase-orders	GET	200	2026-03-18 21:38:45.192465
6871	7	/api/purchase-orders/2/status	PATCH	200	2026-03-18 21:38:46.435473
6872	7	/api/purchase-orders	GET	200	2026-03-18 21:38:46.439374
6873	7	/api/products	GET	200	2026-03-18 21:38:53.589953
6875	7	/api/financial/categories	GET	200	2026-03-18 21:38:58.458559
6962	7	/api/suppliers	GET	200	2026-03-18 21:46:25.971326
6970	7	/api/financial?status=vencido	GET	200	2026-03-18 21:46:27.708859
6976	7	/api/products	GET	200	2026-03-18 21:46:27.744295
6977	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:46:27.754938
7039	7	/api/clients	GET	200	2026-03-18 21:50:02.252306
7040	7	/api/products	GET	200	2026-03-18 21:50:05.666543
7043	7	/api/products	GET	200	2026-03-18 21:50:06.381264
7054	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-18 21:50:07.285996
7057	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-18 21:50:07.298491
7062	7	/api/financial/categories	GET	200	2026-03-18 21:50:07.718579
7065	7	/api/suppliers	GET	200	2026-03-18 21:50:08.218534
7066	7	/api/suppliers	GET	200	2026-03-18 21:50:08.746934
7101	7	/api/products	GET	200	2026-03-18 21:52:20.163797
7109	7	/api/clients	GET	200	2026-03-18 21:52:21.158889
7113	7	/api/products	GET	200	2026-03-18 21:52:21.815126
7116	7	/api/clients	GET	200	2026-03-18 21:52:22.438512
7117	7	/api/summary	GET	200	2026-03-18 21:52:22.842149
3385	\N	/api/products	GET	401	2025-11-07 20:02:07.614085
4108	7	/api/clients	GET	304	2025-11-10 18:22:00.277223
4210	7	/api/orders	GET	304	2025-11-10 18:30:29.491522
4221	7	/api/products	GET	304	2025-11-10 18:30:35.373231
4304	7	/api/products	GET	304	2025-11-10 18:35:42.76899
4308	7	/api/orders	GET	304	2025-11-10 18:35:42.782152
4311	7	/api/auth/me	GET	304	2025-11-10 18:35:46.694719
4475	7	/api/clients	GET	304	2025-11-10 18:42:19.072813
4476	7	/api/products	GET	304	2025-11-10 18:42:20.281793
4479	7	/api/products	GET	304	2025-11-10 18:42:22.580333
4627	\N	/api/auth/me	GET	401	2025-11-11 15:27:04.335772
4681	7	/api/auth/me	GET	304	2025-11-11 16:41:13.973958
4683	7	/api/users	GET	304	2025-11-11 16:41:14.814293
4684	7	/api/clients	GET	304	2025-11-11 16:41:16.43789
4686	7	/api/clients	GET	304	2025-11-11 16:41:16.444915
4688	7	/api/orders	GET	304	2025-11-11 16:41:16.453713
4691	7	/api/products	GET	304	2025-11-11 16:41:17.409435
4692	7	/api/clients	GET	304	2025-11-11 16:41:17.875958
4754	7	/api/auth/me	GET	200	2025-11-11 17:08:34.56387
4827	7	/api/products	GET	304	2026-03-12 16:51:18.260637
4829	7	/api/orders	GET	304	2026-03-12 16:51:18.303925
4830	7	/api/users	GET	200	2026-03-12 16:51:19.313162
4947	7	/api/auth/me	GET	304	2026-03-12 17:27:31.213635
5009	7	/api/clients	GET	304	2026-03-12 18:57:14.919979
5099	7	/api/products	GET	304	2026-03-12 20:56:08.858419
5100	7	/api/auth/me	GET	304	2026-03-12 20:56:12.055201
5104	7	/api/orders	GET	304	2026-03-12 20:56:12.09264
5117	7	/api/clients	GET	304	2026-03-12 20:56:16.519214
5164	7	/api/clients	GET	304	2026-03-12 21:00:42.850755
5167	7	/api/products	GET	304	2026-03-12 21:00:42.861987
5169	7	/api/orders	GET	304	2026-03-12 21:00:42.871529
5278	7	/api/orders	POST	201	2026-03-12 21:18:55.555041
5279	7	/api/orders	GET	200	2026-03-12 21:18:55.560645
5391	7	/api/orders	GET	304	2026-03-12 21:33:14.243474
5394	7	/api/users	GET	304	2026-03-12 21:33:14.664359
5395	7	/api/auth/me	GET	304	2026-03-12 21:33:21.445438
5398	7	/api/auth/me	GET	200	2026-03-12 21:33:23.172192
5499	7	/api/clients	GET	304	2026-03-13 13:50:36.348301
5502	7	/api/orders	GET	304	2026-03-13 13:50:36.356142
5503	7	/api/users	GET	304	2026-03-13 13:50:36.768708
5506	7	/api/clients	GET	304	2026-03-13 13:50:39.103227
5507	7	/api/auth/me	GET	304	2026-03-13 13:50:48.85944
5589	7	/api/products	GET	304	2026-03-13 13:59:50.017976
5591	7	/api/orders	GET	304	2026-03-13 13:59:50.025064
5594	7	/api/users	GET	304	2026-03-13 13:59:51.656182
5595	7	/api/products	GET	304	2026-03-13 13:59:53.323929
5599	7	/api/clients	GET	304	2026-03-13 13:59:53.33141
5636	7	/api/orders/18	PUT	500	2026-03-13 14:23:28.649602
5711	7	/api/products/2	PUT	500	2026-03-13 14:32:54.769857
5712	7	/api/products/2	PUT	500	2026-03-13 14:32:59.274606
5713	7	/api/auth/me	GET	200	2026-03-13 14:33:07.61448
5716	7	/api/products	GET	200	2026-03-13 14:33:07.66868
5717	7	/api/products/13	DELETE	200	2026-03-13 14:33:15.658799
5718	7	/api/products	GET	200	2026-03-13 14:33:15.665957
5822	7	/api/products	GET	200	2026-03-17 20:51:26.685137
5825	7	/api/users	GET	200	2026-03-17 20:51:27.294821
5924	7	/api/clients	GET	200	2026-03-17 21:29:50.931053
6009	\N	/api/clients	GET	401	2026-03-17 21:51:47.912042
6127	7	/api/auth/me	GET	200	2026-03-18 15:46:28.725599
6128	7	/api/auth/me	GET	200	2026-03-18 15:46:28.731394
6129	7	/api/suppliers	GET	200	2026-03-18 15:46:28.78759
6188	7	/api/auth/me	GET	200	2026-03-18 16:02:12.810129
6190	7	/api/products	GET	200	2026-03-18 16:02:12.864837
6191	7	/api/products	POST	201	2026-03-18 16:02:22.057987
6192	7	/api/products	GET	200	2026-03-18 16:02:22.063052
6253	7	/api/clients	POST	201	2026-03-18 16:19:20.961638
6254	7	/api/clients	GET	200	2026-03-18 16:19:20.96643
6312	7	/api/products	GET	200	2026-03-18 16:22:34.300156
6313	7	/api/orders/2	PUT	200	2026-03-18 16:22:40.405831
6314	7	/api/orders	GET	200	2026-03-18 16:22:40.412439
6315	7	/api/orders/3	PUT	200	2026-03-18 16:22:47.305268
6316	7	/api/orders	GET	200	2026-03-18 16:22:47.310985
6317	7	/api/orders/6	PUT	200	2026-03-18 16:22:53.562044
6318	7	/api/orders	GET	200	2026-03-18 16:22:53.567988
6319	7	/api/orders/7	PUT	200	2026-03-18 16:22:58.521584
6320	7	/api/orders	GET	200	2026-03-18 16:22:58.526645
6321	7	/api/summary	GET	200	2026-03-18 16:23:01.023557
6324	7	/api/products	GET	200	2026-03-18 16:23:07.142661
6397	7	/api/products	GET	200	2026-03-18 16:39:32.378479
6474	7	/api/clients	GET	200	2026-03-18 17:18:45.606666
6475	7	/api/products	GET	200	2026-03-18 17:18:46.32371
6478	7	/api/products	GET	200	2026-03-18 17:18:47.197069
6575	7	/api/auth/me	GET	200	2026-03-18 17:42:11.300017
6656	7	/api/summary	GET	200	2026-03-18 18:02:55.557411
6725	7	/api/suppliers	GET	200	2026-03-18 18:24:58.371083
6795	7	/api/suppliers	GET	200	2026-03-18 21:26:02.515918
6877	7	/api/financial/categories	GET	200	2026-03-18 21:38:58.498998
6964	7	/api/products	GET	200	2026-03-18 21:46:25.982146
6971	7	/api/summary	GET	200	2026-03-18 21:46:27.719021
6974	7	/api/suppliers	GET	200	2026-03-18 21:46:27.741781
7044	7	/api/clients	GET	200	2026-03-18 21:50:06.42299
7052	7	/api/clients	GET	200	2026-03-18 21:50:07.280763
7071	7	/api/purchase-orders	GET	200	2026-03-18 21:50:08.763494
7104	7	/api/orders?	GET	200	2026-03-18 21:52:20.276675
7105	7	/api/users	GET	200	2026-03-18 21:52:20.625443
7108	7	/api/products	GET	200	2026-03-18 21:52:21.155083
7178	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:56:45.021056
7180	7	/api/suppliers	GET	200	2026-03-19 15:56:47.73528
7182	7	/api/products	GET	200	2026-03-19 15:56:47.740508
7184	7	/api/purchase-orders	GET	200	2026-03-19 15:56:47.747168
7187	7	/api/suppliers	GET	200	2026-03-19 15:56:49.001384
7188	7	/api/financial?	GET	200	2026-03-19 15:56:49.449511
7224	7	/api/financial/categories	GET	200	2026-03-19 16:00:40.644608
7253	7	/api/financial?status=vencido	GET	200	2026-03-19 16:11:10.587389
7255	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:11:10.610645
7266	7	/api/summary	GET	200	2026-03-19 16:11:19.175994
7270	7	/api/summary	GET	200	2026-03-19 16:11:19.226369
7305	7	/api/summary	GET	200	2026-03-19 16:17:02.049057
7310	7	/api/summary	GET	200	2026-03-19 16:17:02.083214
7321	7	/api/orders	GET	200	2026-03-19 16:17:08.015126
7324	7	/api/users	GET	200	2026-03-19 16:17:08.694418
7325	7	/api/clients	GET	200	2026-03-19 16:17:09.694218
7332	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:17:09.717094
7338	7	/api/financial?	GET	200	2026-03-19 16:17:10.249227
7339	7	/api/suppliers	GET	200	2026-03-19 16:17:10.643662
7342	7	/api/products	GET	200	2026-03-19 16:17:10.995755
7356	7	/api/products	GET	200	2026-03-19 16:17:15.497477
3386	\N	/api/orders	GET	401	2025-11-07 20:02:07.617799
4110	7	/api/clients	GET	304	2025-11-10 18:22:00.317563
4211	7	/api/products	GET	304	2025-11-10 18:30:29.496042
4215	7	/api/orders	GET	200	2025-11-10 18:30:31.606484
4216	7	/api/products	GET	304	2025-11-10 18:30:32.668105
4219	7	/api/clients	GET	304	2025-11-10 18:30:35.365353
4305	7	/api/orders	GET	304	2025-11-10 18:35:42.77277
4313	7	/api/products	GET	304	2025-11-10 18:35:46.713856
4323	7	/api/clients	GET	304	2025-11-10 18:35:50.728223
4330	7	/api/orders	GET	304	2025-11-10 18:35:53.744736
4339	7	/api/clients	GET	304	2025-11-10 18:35:59.782655
4346	7	/api/orders	GET	304	2025-11-10 18:36:00.745298
4355	7	/api/clients	GET	304	2025-11-10 18:36:04.758387
4362	7	/api/orders	GET	304	2025-11-10 18:36:07.372118
4371	7	/api/clients	GET	304	2025-11-10 18:36:08.544756
4379	7	/api/orders	GET	304	2025-11-10 18:36:15.788165
4382	7	/api/orders	GET	304	2025-11-10 18:36:15.798377
4383	7	/api/orders/21/status	PUT	400	2025-11-10 18:36:18.237585
4484	7	/api/auth/me	GET	200	2025-11-10 18:43:42.187271
4485	7	/api/clients	GET	304	2025-11-10 18:43:42.212749
4489	7	/api/products	GET	304	2025-11-10 18:43:42.261924
4500	7	/api/orders	GET	304	2025-11-10 18:43:50.237229
4626	\N	/api/auth/me	GET	401	2025-11-11 15:27:04.335594
4682	7	/api/users	GET	304	2025-11-11 16:41:14.808367
4685	7	/api/products	GET	304	2025-11-11 16:41:16.438818
4755	7	/api/auth/me	GET	200	2025-11-11 17:08:54.76688
4828	7	/api/orders	GET	200	2026-03-12 16:51:18.298796
4831	7	/api/users	GET	304	2026-03-12 16:51:19.320053
4948	7	/api/auth/me	GET	304	2026-03-12 17:27:31.213742
5010	7	/api/products	GET	304	2026-03-12 18:57:14.943503
5012	7	/api/orders	GET	304	2026-03-12 18:57:14.950364
5013	7	/api/auth/me	GET	304	2026-03-12 18:57:18.122633
5016	7	/api/auth/me	GET	304	2026-03-12 18:57:18.672006
5118	7	/api/products	GET	304	2026-03-12 20:56:16.551807
5165	7	/api/products	GET	304	2026-03-12 21:00:42.854282
5280	7	/api/orders/27	PUT	200	2026-03-12 21:19:06.769825
5281	7	/api/orders	GET	304	2026-03-12 21:19:06.777341
5282	7	/api/orders/27	PUT	200	2026-03-12 21:19:12.335078
5399	7	/api/auth/me	GET	304	2026-03-12 21:37:12.766225
5402	7	/api/clients	GET	304	2026-03-12 21:37:13.984372
5403	7	/api/products	GET	304	2026-03-12 21:37:14.726103
5406	7	/api/products	GET	304	2026-03-12 21:37:15.28155
5416	7	/api/clients	GET	304	2026-03-12 21:37:16.7381
5420	7	/api/products	GET	304	2026-03-12 21:37:17.575242
5421	7	/api/clients	GET	304	2026-03-12 21:37:18.634387
5500	7	/api/products	GET	304	2026-03-13 13:50:36.350819
5590	7	/api/orders	GET	304	2026-03-13 13:59:50.020156
5596	7	/api/clients	GET	304	2026-03-13 13:59:53.324588
5600	7	/api/orders	GET	304	2026-03-13 13:59:53.335105
5637	7	/api/auth/me	GET	200	2026-03-13 14:24:22.275892
5638	7	/api/clients	GET	200	2026-03-13 14:24:22.303064
5642	7	/api/products	GET	200	2026-03-13 14:24:22.364012
5714	7	/api/auth/me	GET	200	2026-03-13 14:33:07.647766
5715	7	/api/products	GET	200	2026-03-13 14:33:07.662898
5826	7	/api/auth/me	GET	200	2026-03-17 20:55:56.818072
5829	7	/api/users	GET	200	2026-03-17 20:55:56.886641
5925	7	/api/orders	GET	200	2026-03-17 21:29:50.932245
6010	\N	/api/auth/login	POST	200	2026-03-17 21:52:08.190399
6011	7	/api/summary	GET	200	2026-03-17 21:52:08.222826
6014	7	/api/clients	GET	200	2026-03-17 21:52:12.725182
6015	7	/api/products	GET	200	2026-03-17 21:52:13.346062
6018	7	/api/products	GET	200	2026-03-17 21:52:13.986707
6027	7	/api/clients	GET	200	2026-03-17 21:52:15.231302
6130	7	/api/suppliers	GET	200	2026-03-18 15:46:28.829952
6189	7	/api/products	GET	200	2026-03-18 16:02:12.85866
6255	7	/api/clients	POST	201	2026-03-18 16:19:35.16405
6256	7	/api/clients	GET	200	2026-03-18 16:19:35.169159
6325	7	/api/clients	GET	200	2026-03-18 16:23:07.183546
6398	7	/api/products	GET	200	2026-03-18 16:39:32.380646
6399	7	/api/products/19	PUT	200	2026-03-18 16:39:40.216702
6400	7	/api/products	GET	200	2026-03-18 16:39:40.221871
6401	7	/api/summary	GET	200	2026-03-18 16:39:42.944904
6404	7	/api/products	GET	200	2026-03-18 16:39:52.028594
6480	7	/api/clients	GET	200	2026-03-18 17:18:47.237312
6482	7	/api/orders	GET	200	2026-03-18 17:18:47.245334
6483	7	/api/users	GET	200	2026-03-18 17:18:47.85314
6485	7	/api/financial/categories	GET	200	2026-03-18 17:18:48.422804
6488	7	/api/financial?	GET	200	2026-03-18 17:18:48.435365
6489	7	/api/suppliers	GET	200	2026-03-18 17:18:49.16562
6492	7	/api/summary	GET	200	2026-03-18 17:18:50.063533
6576	7	/api/summary	GET	200	2026-03-18 17:42:11.384352
6657	7	/api/auth/me	GET	200	2026-03-18 18:02:55.564065
6726	7	/api/products	GET	200	2026-03-18 18:24:58.476759
6796	7	/api/products	GET	200	2026-03-18 21:26:02.520957
6878	7	/api/financial?	GET	200	2026-03-18 21:38:58.509296
6965	7	/api/purchase-orders	GET	200	2026-03-18 21:46:25.98552
6968	7	/api/auth/me	GET	200	2026-03-18 21:46:27.683047
6972	7	/api/summary	GET	200	2026-03-18 21:46:27.720274
6973	7	/api/purchase-orders	GET	200	2026-03-18 21:46:27.740757
7045	7	/api/products	GET	200	2026-03-18 21:50:06.426559
7047	7	/api/orders	GET	200	2026-03-18 21:50:06.437053
7048	7	/api/users	GET	200	2026-03-18 21:50:06.825772
7051	7	/api/orders?	GET	200	2026-03-18 21:50:07.278954
7119	\N	/api/financial?status=vencido	GET	401	2026-03-19 15:42:23.524813
7185	7	/api/suppliers	GET	200	2026-03-19 15:56:47.772481
7186	7	/api/suppliers	GET	200	2026-03-19 15:56:48.999405
7189	7	/api/financial/categories	GET	200	2026-03-19 15:56:49.451438
7225	7	/api/summary	GET	200	2026-03-19 16:01:04.113122
7254	7	/api/summary	GET	200	2026-03-19 16:11:10.593226
7264	7	/api/financial?status=vencido	GET	200	2026-03-19 16:11:19.166515
7306	7	/api/financial?status=vencido	GET	200	2026-03-19 16:17:02.050836
7308	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:17:02.070987
7329	7	/api/clients	GET	200	2026-03-19 16:17:09.705131
7358	7	/api/orders	GET	200	2026-03-19 16:17:15.507222
7369	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:17:19.305352
7372	7	/api/financial/categories	GET	200	2026-03-19 16:17:20.026595
7380	7	/api/purchase-orders	GET	200	2026-03-19 16:17:21.485621
7387	7	/api/summary	GET	200	2026-03-19 16:21:22.039241
7390	7	/api/summary	GET	200	2026-03-19 16:21:22.052082
7411	7	/api/clients	GET	200	2026-03-19 16:21:25.168113
7428	7	/api/products	GET	200	2026-03-19 16:21:26.273991
7431	7	/api/summary	GET	200	2026-03-19 16:21:26.989241
7432	7	/api/clients	GET	200	2026-03-19 16:21:36.039507
7435	7	/api/products	GET	200	2026-03-19 16:21:36.508382
7436	7	/api/summary	GET	200	2026-03-19 16:21:38.792336
7439	7	/api/clients	GET	200	2026-03-19 16:21:40.42977
3387	\N	/api/clients	GET	401	2025-11-07 20:02:07.620956
4111	7	/api/products	GET	304	2025-11-10 18:22:00.318306
4113	7	/api/orders	GET	304	2025-11-10 18:22:00.429486
4213	7	/api/clients	GET	304	2025-11-10 18:30:29.498931
4214	7	/api/orders/3/status	PUT	200	2025-11-10 18:30:31.599142
4217	7	/api/products	GET	304	2025-11-10 18:30:32.673428
4218	7	/api/products	GET	304	2025-11-10 18:30:35.364561
4309	7	/api/auth/me	GET	304	2025-11-10 18:35:42.827402
4310	7	/api/auth/me	GET	304	2025-11-10 18:35:46.692212
4486	7	/api/clients	GET	304	2025-11-10 18:43:42.253407
4502	7	/api/clients	GET	304	2025-11-10 18:43:50.238474
4504	7	/api/orders	POST	201	2025-11-10 18:43:56.900338
4505	7	/api/orders	GET	200	2025-11-10 18:43:56.906301
4506	7	/api/products	GET	304	2025-11-10 18:43:58.944133
4509	7	/api/orders	GET	304	2025-11-10 18:44:01.67893
4511	7	/api/clients	GET	304	2025-11-10 18:44:01.719477
4520	7	/api/clients	GET	304	2025-11-10 18:44:08.199861
4532	7	/api/products	GET	304	2025-11-10 18:44:15.463049
4628	\N	/api/auth/login	POST	200	2025-11-11 16:08:47.781213
4629	7	/api/clients	GET	304	2025-11-11 16:08:56.115124
4632	7	/api/products	GET	304	2025-11-11 16:08:57.372281
4633	7	/api/clients	GET	304	2025-11-11 16:08:59.862308
4636	7	/api/orders	GET	304	2025-11-11 16:08:59.879038
4689	7	/api/products	GET	304	2025-11-11 16:41:16.480036
4690	7	/api/products	GET	304	2025-11-11 16:41:17.405081
4693	7	/api/clients	GET	304	2025-11-11 16:41:17.880825
4756	7	/api/auth/me	GET	200	2025-11-11 17:08:54.896648
4832	7	/api/auth/me	GET	304	2026-03-12 17:01:44.428709
4949	7	/api/auth/me	GET	304	2026-03-12 17:28:11.176579
5011	7	/api/orders	GET	304	2026-03-12 18:57:14.945451
5014	7	/api/auth/me	GET	304	2026-03-12 18:57:18.125355
5015	7	/api/auth/me	GET	304	2026-03-12 18:57:18.669705
5119	7	/api/orders	GET	304	2026-03-12 20:56:16.555173
5168	7	/api/orders	GET	304	2026-03-12 21:00:42.867214
5283	7	/api/orders	GET	304	2026-03-12 21:19:12.34342
5284	7	/api/orders/27	PUT	200	2026-03-12 21:19:18.780214
5285	7	/api/orders	GET	304	2026-03-12 21:19:18.785921
5400	7	/api/auth/me	GET	304	2026-03-12 21:37:12.799704
5401	7	/api/clients	GET	304	2026-03-12 21:37:13.981964
5404	7	/api/products	GET	304	2026-03-12 21:37:14.730375
5405	7	/api/clients	GET	304	2026-03-12 21:37:15.280757
5417	7	/api/products	GET	304	2026-03-12 21:37:16.738728
5425	7	/api/products	GET	304	2026-03-12 21:37:18.653871
5501	7	/api/orders	GET	304	2026-03-13 13:50:36.351459
5504	7	/api/users	GET	304	2026-03-13 13:50:36.773396
5505	7	/api/clients	GET	304	2026-03-13 13:50:39.100745
5508	7	/api/auth/me	GET	304	2026-03-13 13:50:48.861699
5592	7	/api/clients	GET	304	2026-03-13 13:59:50.119744
5593	7	/api/users	GET	304	2026-03-13 13:59:51.648106
5597	7	/api/orders	GET	304	2026-03-13 13:59:53.330025
5639	7	/api/products	GET	200	2026-03-13 14:24:22.352745
5643	7	/api/orders	GET	200	2026-03-13 14:24:22.36796
5719	7	/api/products/14	DELETE	200	2026-03-13 14:34:11.118421
5720	7	/api/products	GET	200	2026-03-13 14:34:11.124656
5827	7	/api/auth/me	GET	200	2026-03-17 20:55:56.818305
5828	7	/api/users	GET	200	2026-03-17 20:55:56.880863
5927	7	/api/products	GET	200	2026-03-17 21:29:51.036419
5928	7	/api/users	GET	200	2026-03-17 21:29:51.477493
5931	7	/api/summary	GET	200	2026-03-17 21:29:54.457567
6012	7	/api/summary	GET	200	2026-03-17 21:52:08.262976
6013	7	/api/clients	GET	200	2026-03-17 21:52:12.723256
6016	7	/api/products	GET	200	2026-03-17 21:52:13.350009
6017	7	/api/clients	GET	200	2026-03-17 21:52:13.985938
6019	7	/api/products	GET	200	2026-03-17 21:52:13.991987
6022	7	/api/orders	GET	200	2026-03-17 21:52:14.03791
6023	7	/api/users	GET	200	2026-03-17 21:52:14.502233
6026	7	/api/products	GET	200	2026-03-17 21:52:15.227481
6131	7	/api/suppliers	POST	500	2026-03-18 15:48:47.982648
6193	7	/api/products	POST	201	2026-03-18 16:02:37.343369
6194	7	/api/products	GET	200	2026-03-18 16:02:37.348617
6257	7	/api/clients	POST	201	2026-03-18 16:19:47.833131
6258	7	/api/clients	GET	200	2026-03-18 16:19:47.838271
6326	7	/api/products	GET	200	2026-03-18 16:23:07.184387
6328	7	/api/orders	GET	200	2026-03-18 16:23:07.191448
6329	7	/api/orders/16	PUT	200	2026-03-18 16:23:16.178554
6330	7	/api/orders	GET	200	2026-03-18 16:23:16.184173
6331	7	/api/orders/19	PUT	200	2026-03-18 16:23:21.435132
6332	7	/api/orders	GET	200	2026-03-18 16:23:21.440044
6333	7	/api/orders/24	PUT	200	2026-03-18 16:23:26.129554
6334	7	/api/orders	GET	200	2026-03-18 16:23:26.142688
6335	7	/api/orders/25	PUT	200	2026-03-18 16:23:30.564856
6336	7	/api/orders	GET	200	2026-03-18 16:23:30.570085
6337	7	/api/orders/26	PUT	200	2026-03-18 16:23:35.268528
6338	7	/api/orders	GET	200	2026-03-18 16:23:35.273478
6339	7	/api/orders/27	PUT	200	2026-03-18 16:23:41.242016
6340	7	/api/orders	GET	200	2026-03-18 16:23:41.247335
6341	7	/api/orders/28	PUT	200	2026-03-18 16:23:50.795057
6342	7	/api/orders	GET	200	2026-03-18 16:23:50.800212
6343	7	/api/summary	GET	200	2026-03-18 16:23:56.123199
6402	7	/api/summary	GET	200	2026-03-18 16:39:42.984855
6403	7	/api/clients	GET	200	2026-03-18 16:39:52.027857
6481	7	/api/orders	GET	200	2026-03-18 17:18:47.239964
6484	7	/api/users	GET	200	2026-03-18 17:18:47.857853
6486	7	/api/financial?	GET	200	2026-03-18 17:18:48.426538
6577	7	/api/auth/me	GET	200	2026-03-18 17:42:22.241128
6580	7	/api/summary	GET	200	2026-03-18 17:42:22.300041
6658	7	/api/clients	GET	200	2026-03-18 18:03:06.564432
6727	7	/api/purchase-orders	POST	500	2026-03-18 18:25:16.566763
6797	7	/api/purchase-orders	GET	200	2026-03-18 21:26:02.521628
6879	7	/api/auth/me	GET	200	2026-03-18 21:40:38.123111
6881	7	/api/summary	GET	200	2026-03-18 21:40:38.189549
6883	7	/api/financial?	GET	200	2026-03-18 21:40:38.221738
6979	7	/api/suppliers	GET	200	2026-03-18 21:46:27.784173
7046	7	/api/orders	GET	200	2026-03-18 21:50:06.430594
7049	7	/api/users	GET	200	2026-03-18 21:50:06.83037
7050	7	/api/products	GET	200	2026-03-18 21:50:07.270949
7055	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-18 21:50:07.291317
7070	7	/api/products	GET	200	2026-03-18 21:50:08.754685
7120	\N	/api/summary	GET	401	2026-03-19 15:42:23.534997
7226	7	/api/summary	GET	200	2026-03-19 16:01:04.157839
7256	7	/api/financial?status=vencido	GET	200	2026-03-19 16:11:10.629911
7259	7	/api/summary	GET	200	2026-03-19 16:11:10.652226
7262	7	/api/auth/me	GET	200	2026-03-19 16:11:19.140407
7265	7	/api/summary	GET	200	2026-03-19 16:11:19.168288
7267	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:11:19.176986
7268	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:11:19.185604
7269	7	/api/summary	GET	200	2026-03-19 16:11:19.225165
3388	\N	/api/products	GET	401	2025-11-07 20:02:07.624375
3391	\N	/api/products	GET	401	2025-11-07 20:02:09.534653
3392	\N	/api/clients	GET	401	2025-11-07 20:02:10.680297
4112	7	/api/orders	GET	304	2025-11-10 18:22:00.423768
4223	7	/api/orders	GET	304	2025-11-10 18:30:35.406241
4315	7	/api/clients	GET	304	2025-11-10 18:35:46.756937
4322	7	/api/orders	GET	304	2025-11-10 18:35:50.727651
4331	7	/api/clients	GET	304	2025-11-10 18:35:53.751417
4338	7	/api/orders	GET	304	2025-11-10 18:35:59.775713
4347	7	/api/clients	GET	304	2025-11-10 18:36:00.751884
4354	7	/api/orders	GET	304	2025-11-10 18:36:04.752343
4363	7	/api/clients	GET	304	2025-11-10 18:36:07.380611
4370	7	/api/orders	GET	304	2025-11-10 18:36:08.538405
4380	7	/api/clients	GET	304	2025-11-10 18:36:15.795362
4487	7	/api/products	GET	304	2025-11-10 18:43:42.254363
4490	7	/api/orders	GET	304	2025-11-10 18:43:42.264601
4497	7	/api/products	GET	304	2025-11-10 18:43:48.328864
4498	7	/api/products	GET	304	2025-11-10 18:43:50.231181
4630	7	/api/clients	GET	304	2025-11-11 16:08:56.149858
4631	7	/api/products	GET	304	2025-11-11 16:08:57.367896
4634	7	/api/products	GET	304	2025-11-11 16:08:59.863057
4635	7	/api/orders	GET	304	2025-11-11 16:08:59.874774
4694	7	/api/auth/me	GET	304	2025-11-11 16:42:52.658419
4698	7	/api/auth/me	GET	200	2025-11-11 16:42:55.374579
4757	7	/api/clients	GET	200	2025-11-11 17:09:47.678114
4833	7	/api/auth/me	GET	304	2026-03-12 17:01:44.431266
4950	7	/api/auth/me	GET	304	2026-03-12 17:28:11.176997
5017	7	/api/auth/me	GET	304	2026-03-12 18:57:50.350893
5120	7	/api/auth/me	GET	304	2026-03-12 20:57:10.134958
5170	7	/api/users	GET	304	2026-03-12 21:00:53.789525
5173	7	/api/products	GET	304	2026-03-12 21:00:56.305619
5187	7	/api/products	GET	304	2026-03-12 21:01:05.175449
5286	7	/api/orders/27	PUT	200	2026-03-12 21:19:30.138587
5287	7	/api/orders	GET	304	2026-03-12 21:19:30.146178
5407	7	/api/clients	GET	304	2026-03-12 21:37:15.325
5415	7	/api/orders	GET	304	2026-03-12 21:37:16.737618
5423	7	/api/orders	GET	304	2026-03-12 21:37:18.635497
5509	7	/api/clients	GET	304	2026-03-13 13:53:04.271056
5512	7	/api/products	GET	304	2026-03-13 13:53:05.912606
5513	7	/api/clients	GET	304	2026-03-13 13:53:06.370191
5601	7	/api/auth/me	GET	304	2026-03-13 14:01:33.56918
5640	7	/api/clients	GET	200	2026-03-13 14:24:22.358765
5721	7	/api/clients	GET	200	2026-03-13 14:35:11.80106
5724	7	/api/products	GET	200	2026-03-13 14:35:12.485392
5725	7	/api/clients	GET	200	2026-03-13 14:35:13.138125
5737	7	/api/products	GET	200	2026-03-13 14:35:15.134937
5748	7	/api/orders	GET	200	2026-03-13 14:35:21.467078
5830	7	/api/users	GET	200	2026-03-17 20:58:52.445667
5833	7	/api/users	GET	200	2026-03-17 20:58:53.301451
5932	7	/api/auth/me	GET	200	2026-03-17 21:37:43.870523
5933	7	/api/summary	GET	200	2026-03-17 21:37:43.903262
6020	7	/api/clients	GET	200	2026-03-17 21:52:14.034226
6028	7	/api/orders	GET	200	2026-03-17 21:52:15.232191
6132	7	/api/auth/me	GET	200	2026-03-18 15:49:03.029003
6195	7	/api/products	POST	201	2026-03-18 16:02:50.902581
6196	7	/api/products	GET	200	2026-03-18 16:02:50.907896
6259	7	/api/clients	POST	201	2026-03-18 16:19:59.941766
6260	7	/api/clients	GET	200	2026-03-18 16:19:59.94705
6327	7	/api/orders	GET	200	2026-03-18 16:23:07.18624
6344	7	/api/summary	GET	200	2026-03-18 16:23:56.127749
6405	7	/api/clients	GET	200	2026-03-18 16:39:52.069992
6493	7	/api/summary	GET	200	2026-03-18 17:30:19.682514
6578	7	/api/auth/me	GET	200	2026-03-18 17:42:22.241272
6579	7	/api/summary	GET	200	2026-03-18 17:42:22.284767
6659	7	/api/clients	GET	200	2026-03-18 18:03:06.597119
6728	\N	/api/summary	GET	401	2026-03-18 21:14:24.622015
6798	7	/api/financial?status=vencido	GET	200	2026-03-18 21:29:59.960719
6880	7	/api/auth/me	GET	200	2026-03-18 21:40:38.170529
6884	7	/api/financial/categories	GET	200	2026-03-18 21:40:38.223054
6885	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:40:38.239965
6980	7	/api/products	GET	200	2026-03-18 21:46:27.785058
7058	7	/api/clients	GET	200	2026-03-18 21:50:07.326836
7060	7	/api/financial/categories	GET	200	2026-03-18 21:50:07.710506
7069	7	/api/suppliers	GET	200	2026-03-18 21:50:08.753926
7121	\N	/api/auth/login	POST	200	2026-03-19 15:42:49.683715
7122	7	/api/summary	GET	200	2026-03-19 15:42:49.737589
7124	7	/api/financial?status=vencido	GET	200	2026-03-19 15:42:49.766796
7125	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:42:49.780986
7127	7	/api/summary	GET	200	2026-03-19 15:42:49.808772
7227	7	/api/financial?status=vencido	GET	200	2026-03-19 16:05:34.337734
7257	7	/api/summary	GET	200	2026-03-19 16:11:10.641491
7258	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:11:10.647175
7260	7	/api/summary	GET	200	2026-03-19 16:11:10.657688
7261	7	/api/auth/me	GET	200	2026-03-19 16:11:19.138357
7263	7	/api/financial?status=vencido	GET	200	2026-03-19 16:11:19.164439
7307	7	/api/summary	GET	200	2026-03-19 16:17:02.0576
7309	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:17:02.078798
7319	7	/api/clients	GET	200	2026-03-19 16:17:07.995765
7327	7	/api/orders?	GET	200	2026-03-19 16:17:09.703034
7367	7	/api/products	GET	200	2026-03-19 16:17:19.304276
7370	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:17:19.308473
7371	7	/api/financial?	GET	200	2026-03-19 16:17:20.025779
7379	7	/api/suppliers	GET	200	2026-03-19 16:17:21.484657
7388	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:22.042307
7391	7	/api/summary	GET	200	2026-03-19 16:21:22.059734
7392	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:22.06427
7402	7	/api/clients	GET	200	2026-03-19 16:21:24.338505
7405	7	/api/orders	GET	200	2026-03-19 16:21:24.343664
7406	7	/api/users	GET	200	2026-03-19 16:21:24.706113
7409	7	/api/products	GET	200	2026-03-19 16:21:25.160042
7413	7	/api/orders?	GET	200	2026-03-19 16:21:25.174055
7421	7	/api/financial?	GET	200	2026-03-19 16:21:25.508629
7423	7	/api/suppliers	GET	200	2026-03-19 16:21:25.854056
7424	7	/api/suppliers	GET	200	2026-03-19 16:21:26.268248
7443	7	/api/clients	GET	200	2026-03-19 16:21:41.9793
7454	7	/api/summary	GET	200	2026-03-19 16:21:44.009475
7457	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:44.024484
7458	7	/api/clients	GET	200	2026-03-19 16:21:44.032239
7461	7	/api/products	GET	200	2026-03-19 16:21:45.759341
7465	7	/api/orders	GET	200	2026-03-19 16:21:45.76501
7466	7	/api/products	GET	200	2026-03-19 16:21:46.115241
7469	7	/api/auth/me	GET	200	2026-03-19 16:21:47.553537
7472	7	/api/summary	GET	200	2026-03-19 16:21:47.580973
3389	\N	/api/orders	GET	401	2025-11-07 20:02:07.628009
3390	\N	/api/products	GET	401	2025-11-07 20:02:09.530765
3393	\N	/api/clients	GET	401	2025-11-07 20:02:10.683787
3394	\N	/api/auth/login	POST	200	2025-11-07 20:02:23.786559
3395	7	/api/clients	GET	200	2025-11-07 20:02:30.614463
3396	7	/api/clients	GET	304	2025-11-07 20:02:30.649678
3397	7	/api/products	GET	200	2025-11-07 20:02:32.150217
3398	7	/api/products	GET	304	2025-11-07 20:02:32.154589
3399	7	/api/clients	GET	304	2025-11-07 20:02:34.291803
3400	7	/api/products	GET	304	2025-11-07 20:02:34.294899
3401	7	/api/orders	GET	200	2025-11-07 20:02:34.337047
3402	7	/api/clients	GET	304	2025-11-07 20:02:34.340276
3403	7	/api/products	GET	304	2025-11-07 20:02:34.340792
3404	7	/api/orders	GET	304	2025-11-07 20:02:34.341723
3405	7	/api/orders/18	PUT	500	2025-11-07 20:02:38.892879
3406	7	/api/clients	GET	200	2025-11-07 20:05:05.878754
3407	7	/api/clients	GET	200	2025-11-07 20:05:05.921889
3408	7	/api/orders	GET	200	2025-11-07 20:05:05.924544
3409	7	/api/products	GET	200	2025-11-07 20:05:05.9262
3410	7	/api/orders	GET	200	2025-11-07 20:05:05.927353
3411	7	/api/products	GET	200	2025-11-07 20:05:06.016638
3412	7	/api/products	GET	304	2025-11-07 20:05:07.17072
3413	7	/api/products	GET	304	2025-11-07 20:05:07.176339
3414	7	/api/clients	GET	304	2025-11-07 20:05:09.98673
3415	7	/api/products	GET	304	2025-11-07 20:05:09.987467
3416	7	/api/orders	GET	304	2025-11-07 20:05:09.997921
3417	7	/api/clients	GET	304	2025-11-07 20:05:09.999033
3418	7	/api/products	GET	304	2025-11-07 20:05:10.003189
3419	7	/api/orders	GET	304	2025-11-07 20:05:10.007182
3420	7	/api/orders/18	PUT	500	2025-11-07 20:05:14.243678
3421	7	/api/clients	GET	200	2025-11-07 20:06:09.67811
3422	7	/api/clients	GET	200	2025-11-07 20:06:09.733525
3423	7	/api/products	GET	200	2025-11-07 20:06:09.734861
3424	7	/api/orders	GET	200	2025-11-07 20:06:09.736089
3425	7	/api/orders	GET	200	2025-11-07 20:06:09.738107
3426	7	/api/products	GET	200	2025-11-07 20:06:09.831382
3427	7	/api/products	GET	304	2025-11-07 20:06:12.942757
3428	7	/api/products	GET	304	2025-11-07 20:06:12.947639
3429	7	/api/clients	GET	304	2025-11-07 20:06:14.197387
3430	7	/api/products	GET	304	2025-11-07 20:06:14.198571
3431	7	/api/orders	GET	304	2025-11-07 20:06:14.199485
3432	7	/api/clients	GET	304	2025-11-07 20:06:14.206727
3433	7	/api/products	GET	304	2025-11-07 20:06:14.207555
3434	7	/api/orders	GET	304	2025-11-07 20:06:14.209533
3435	7	/api/orders/18	PUT	500	2025-11-07 20:06:17.465448
3436	7	/api/clients	GET	200	2025-11-07 20:07:23.283347
3437	7	/api/products	GET	200	2025-11-07 20:07:23.341323
3438	7	/api/clients	GET	200	2025-11-07 20:07:23.344166
3439	7	/api/orders	GET	200	2025-11-07 20:07:23.345681
3440	7	/api/products	GET	200	2025-11-07 20:07:23.346661
3441	7	/api/orders	GET	200	2025-11-07 20:07:23.350555
3442	7	/api/orders/18	PUT	200	2025-11-07 20:07:28.932478
3443	7	/api/orders	GET	200	2025-11-07 20:07:28.938881
3444	7	/api/products	GET	200	2025-11-07 20:07:33.154616
3445	7	/api/products	GET	304	2025-11-07 20:07:33.161177
3446	7	/api/products	GET	304	2025-11-07 20:07:35.802164
3447	7	/api/clients	GET	304	2025-11-07 20:07:35.804068
3448	7	/api/orders	GET	304	2025-11-07 20:07:35.843068
3449	7	/api/orders	GET	304	2025-11-07 20:07:35.846495
3450	7	/api/clients	GET	304	2025-11-07 20:07:35.851175
3451	7	/api/products	GET	304	2025-11-07 20:07:35.852191
3452	7	/api/orders/18	PUT	200	2025-11-07 20:07:44.581022
3453	7	/api/orders	GET	200	2025-11-07 20:07:44.588654
3454	7	/api/products	GET	200	2025-11-07 20:07:47.254029
3455	7	/api/products	GET	304	2025-11-07 20:07:47.288878
3456	7	/api/products	GET	304	2025-11-07 20:07:49.401409
3457	7	/api/orders	GET	304	2025-11-07 20:07:49.403126
3458	7	/api/clients	GET	304	2025-11-07 20:07:49.440359
3459	7	/api/clients	GET	304	2025-11-07 20:07:49.443114
3460	7	/api/products	GET	304	2025-11-07 20:07:49.449661
3461	7	/api/orders	GET	304	2025-11-07 20:07:49.451398
3462	7	/api/orders/18	PUT	200	2025-11-07 20:07:54.530357
3463	7	/api/orders	GET	200	2025-11-07 20:07:54.536767
3464	7	/api/products	GET	200	2025-11-07 20:07:56.864327
3465	7	/api/products	GET	304	2025-11-07 20:07:56.868531
3466	7	/api/products	GET	304	2025-11-07 20:07:59.317842
3467	7	/api/clients	GET	304	2025-11-07 20:07:59.319075
3468	7	/api/orders	GET	304	2025-11-07 20:07:59.324867
3469	7	/api/products	GET	304	2025-11-07 20:07:59.325602
3470	7	/api/clients	GET	304	2025-11-07 20:07:59.328372
3471	7	/api/orders	GET	304	2025-11-07 20:07:59.36214
3472	7	/api/orders/18	PUT	200	2025-11-07 20:08:07.154254
3473	7	/api/orders	GET	200	2025-11-07 20:08:07.159971
3474	7	/api/products	GET	200	2025-11-07 20:08:12.921078
3475	7	/api/products	GET	304	2025-11-07 20:08:12.956401
3476	7	/api/products	GET	304	2025-11-07 20:08:17.537044
3477	7	/api/clients	GET	304	2025-11-07 20:08:17.53753
3478	7	/api/clients	GET	304	2025-11-07 20:08:17.545342
3479	7	/api/orders	GET	304	2025-11-07 20:08:17.575389
3480	7	/api/orders	GET	304	2025-11-07 20:08:17.578581
3481	7	/api/products	GET	304	2025-11-07 20:08:17.580133
3482	7	/api/orders/18	PUT	200	2025-11-07 20:08:28.780426
3483	7	/api/orders	GET	200	2025-11-07 20:08:28.788337
3484	7	/api/products	GET	200	2025-11-07 20:08:29.767202
3485	7	/api/products	GET	304	2025-11-07 20:08:29.802647
3486	7	/api/products	GET	304	2025-11-07 20:08:32.812197
3487	7	/api/orders	GET	304	2025-11-07 20:08:32.81291
3488	7	/api/clients	GET	304	2025-11-07 20:08:32.851483
3489	7	/api/clients	GET	304	2025-11-07 20:08:32.854769
3490	7	/api/products	GET	304	2025-11-07 20:08:32.860019
3491	7	/api/orders	GET	304	2025-11-07 20:08:32.86179
3492	7	/api/orders/18	PUT	200	2025-11-07 20:08:39.661173
3493	7	/api/orders	GET	200	2025-11-07 20:08:39.666964
3494	7	/api/products	GET	200	2025-11-07 20:08:44.617835
3495	7	/api/products	GET	304	2025-11-07 20:08:44.653284
3496	7	/api/products	GET	304	2025-11-07 20:08:49.371182
3497	7	/api/clients	GET	304	2025-11-07 20:08:49.372756
3498	7	/api/orders	GET	304	2025-11-07 20:08:49.412869
3499	7	/api/orders	GET	304	2025-11-07 20:08:49.415611
3500	7	/api/clients	GET	304	2025-11-07 20:08:49.419491
3501	7	/api/products	GET	304	2025-11-07 20:08:49.420674
3502	7	/api/orders/18	PUT	200	2025-11-07 20:10:56.877958
3503	7	/api/orders	GET	304	2025-11-07 20:10:56.885294
3504	\N	/api/clients	GET	401	2025-11-09 21:13:26.147573
3505	\N	/api/orders	GET	401	2025-11-09 21:13:26.1542
3506	\N	/api/clients	GET	401	2025-11-09 21:13:26.154812
3507	\N	/api/products	GET	401	2025-11-09 21:13:26.156388
3508	\N	/api/orders	GET	401	2025-11-09 21:13:26.157096
3509	\N	/api/products	GET	401	2025-11-09 21:13:26.24081
3510	\N	/api/auth/login	POST	200	2025-11-09 21:13:44.776216
3511	7	/api/clients	GET	304	2025-11-09 21:13:57.911943
3512	7	/api/clients	GET	304	2025-11-09 21:13:58.004872
3513	7	/api/products	GET	304	2025-11-09 21:13:59.587478
3514	7	/api/products	GET	304	2025-11-09 21:13:59.593008
3515	7	/api/users	GET	304	2025-11-09 21:14:02.782562
3516	7	/api/users	GET	304	2025-11-09 21:14:02.78924
3517	7	/api/clients	GET	304	2025-11-09 21:14:17.761719
3518	7	/api/products	GET	304	2025-11-09 21:14:17.766547
3519	7	/api/orders	GET	304	2025-11-09 21:14:17.771279
3520	7	/api/products	GET	304	2025-11-09 21:14:17.77393
3521	7	/api/orders	GET	304	2025-11-09 21:14:17.777369
3522	7	/api/clients	GET	304	2025-11-09 21:14:17.799573
3523	7	/api/products	GET	304	2025-11-09 21:14:31.6545
3524	7	/api/products	GET	304	2025-11-09 21:14:31.687605
3525	7	/api/clients	GET	304	2025-11-09 21:14:39.447885
3526	7	/api/products	GET	304	2025-11-09 21:14:39.448553
3527	7	/api/orders	GET	304	2025-11-09 21:14:39.487127
3528	7	/api/orders	GET	304	2025-11-09 21:14:39.4922
3529	7	/api/clients	GET	304	2025-11-09 21:14:39.497001
3530	7	/api/products	GET	304	2025-11-09 21:14:39.497595
3531	\N	/api/auth/login	POST	200	2025-11-10 16:56:31.274488
3532	\N	/api/auth/me	GET	404	2025-11-10 16:58:38.167719
3533	\N	/api/auth/me	GET	404	2025-11-10 16:58:38.168011
3534	\N	/api/auth/login	POST	200	2025-11-10 16:58:49.873889
3535	\N	/api/auth/me	GET	404	2025-11-10 16:58:59.523195
3536	\N	/api/auth/me	GET	404	2025-11-10 16:58:59.559907
3537	\N	/api/auth/login	POST	200	2025-11-10 16:59:49.408977
3539	\N	/api/auth/me	GET	404	2025-11-10 17:00:48.028144
3538	\N	/api/auth/me	GET	404	2025-11-10 17:00:48.028327
3540	\N	/api/auth/login	POST	200	2025-11-10 17:01:03.07055
3541	7	/api/clients	GET	304	2025-11-10 17:01:09.890412
3542	7	/api/clients	GET	304	2025-11-10 17:01:09.924485
3543	\N	/api/auth/me	GET	404	2025-11-10 17:01:11.369835
3544	\N	/api/auth/me	GET	404	2025-11-10 17:01:11.370722
3545	\N	/api/auth/login	POST	200	2025-11-10 17:06:16.352119
3546	7	/api/clients	GET	304	2025-11-10 17:06:19.418984
3547	7	/api/clients	GET	304	2025-11-10 17:06:19.453724
3548	7	/api/products	GET	304	2025-11-10 17:06:20.052745
3549	7	/api/products	GET	304	2025-11-10 17:06:20.057936
3550	7	/api/clients	GET	304	2025-11-10 17:06:20.476035
3551	7	/api/products	GET	304	2025-11-10 17:06:20.476535
3552	7	/api/products	GET	304	2025-11-10 17:06:20.519838
3553	7	/api/orders	GET	304	2025-11-10 17:06:20.522411
3554	7	/api/orders	GET	304	2025-11-10 17:06:20.527496
3555	7	/api/clients	GET	304	2025-11-10 17:06:20.631991
3556	7	/api/users	GET	304	2025-11-10 17:06:20.846825
3557	7	/api/users	GET	304	2025-11-10 17:06:20.853059
3558	\N	/api/auth/me	GET	404	2025-11-10 17:06:21.742093
3559	\N	/api/auth/me	GET	404	2025-11-10 17:06:21.74308
3560	\N	/api/auth/login	POST	200	2025-11-10 17:19:33.497824
3561	7	/api/auth/me	GET	200	2025-11-10 17:19:36.254134
3562	7	/api/auth/me	GET	304	2025-11-10 17:19:36.256621
3563	7	/api/auth/me	GET	304	2025-11-10 17:19:36.963107
3564	7	/api/auth/me	GET	304	2025-11-10 17:19:36.96676
3565	7	/api/auth/me	GET	304	2025-11-10 17:19:37.244512
3566	7	/api/auth/me	GET	304	2025-11-10 17:19:37.247195
3567	7	/api/auth/me	GET	200	2025-11-10 17:19:38.258769
3568	7	/api/auth/me	GET	200	2025-11-10 17:19:38.262474
3569	7	/api/auth/me	GET	200	2025-11-10 17:19:39.686918
3570	7	/api/auth/me	GET	200	2025-11-10 17:19:39.689444
3571	7	/api/auth/me	GET	304	2025-11-10 17:20:02.035625
3572	7	/api/auth/me	GET	304	2025-11-10 17:20:02.035476
3573	7	/api/auth/me	GET	200	2025-11-10 17:20:07.977285
3574	7	/api/auth/me	GET	200	2025-11-10 17:20:07.980018
3575	7	/api/auth/me	GET	200	2025-11-10 17:20:08.842655
3576	7	/api/auth/me	GET	200	2025-11-10 17:20:08.845656
3577	7	/api/auth/me	GET	304	2025-11-10 17:20:21.418384
3578	7	/api/auth/me	GET	304	2025-11-10 17:20:21.418583
3579	7	/api/products	GET	304	2025-11-10 17:20:38.480854
3580	7	/api/products	GET	304	2025-11-10 17:20:38.514826
3581	7	/api/products	GET	304	2025-11-10 17:20:40.98196
3582	7	/api/clients	GET	304	2025-11-10 17:20:40.982933
3583	7	/api/products	GET	304	2025-11-10 17:20:41.024669
3584	7	/api/clients	GET	304	2025-11-10 17:20:41.028429
3585	7	/api/orders	GET	304	2025-11-10 17:20:41.030607
3586	7	/api/orders	GET	304	2025-11-10 17:20:41.035145
3587	7	/api/auth/me	GET	200	2025-11-10 17:25:47.503766
3588	7	/api/clients	GET	304	2025-11-10 17:25:47.53192
3589	7	/api/products	GET	304	2025-11-10 17:25:47.535167
3590	7	/api/clients	GET	304	2025-11-10 17:25:47.536602
3591	7	/api/orders	GET	304	2025-11-10 17:25:47.540838
3592	7	/api/products	GET	304	2025-11-10 17:25:47.543517
3593	7	/api/orders	GET	304	2025-11-10 17:25:47.5468
3594	7	/api/auth/me	GET	200	2025-11-10 17:25:47.613058
3595	7	/api/auth/me	GET	200	2025-11-10 17:25:48.431042
3596	7	/api/auth/me	GET	200	2025-11-10 17:25:48.434442
3597	7	/api/clients	GET	304	2025-11-10 17:25:48.452482
3598	7	/api/products	GET	304	2025-11-10 17:25:48.453018
3599	7	/api/orders	GET	304	2025-11-10 17:25:48.458387
3600	7	/api/clients	GET	304	2025-11-10 17:25:48.45923
3601	7	/api/products	GET	304	2025-11-10 17:25:48.461804
3602	7	/api/orders	GET	304	2025-11-10 17:25:48.464436
3603	7	/api/auth/me	GET	304	2025-11-10 17:33:16.051634
3604	7	/api/auth/me	GET	304	2025-11-10 17:33:16.051827
3605	7	/api/clients	GET	304	2025-11-10 17:33:16.081189
3606	7	/api/clients	GET	304	2025-11-10 17:33:16.084432
3607	7	/api/products	GET	304	2025-11-10 17:33:16.087953
3609	7	/api/products	GET	304	2025-11-10 17:33:16.092941
3608	7	/api/orders	GET	304	2025-11-10 17:33:16.092437
3610	7	/api/orders	GET	304	2025-11-10 17:33:16.098068
3611	7	/api/auth/me	GET	304	2025-11-10 17:33:21.656689
3612	7	/api/auth/me	GET	304	2025-11-10 17:33:21.659124
3613	7	/api/clients	GET	304	2025-11-10 17:33:21.683334
3614	7	/api/products	GET	304	2025-11-10 17:33:21.683772
3615	7	/api/orders	GET	304	2025-11-10 17:33:21.689176
3616	7	/api/clients	GET	304	2025-11-10 17:33:21.689685
3617	7	/api/products	GET	304	2025-11-10 17:33:21.690184
3618	7	/api/orders	GET	304	2025-11-10 17:33:21.693075
3619	7	/api/auth/me	GET	304	2025-11-10 17:33:22.691912
3620	7	/api/auth/me	GET	304	2025-11-10 17:33:22.693947
3621	7	/api/clients	GET	304	2025-11-10 17:33:22.711063
3622	7	/api/products	GET	304	2025-11-10 17:33:22.711967
3623	7	/api/orders	GET	304	2025-11-10 17:33:22.716911
3624	7	/api/clients	GET	304	2025-11-10 17:33:22.717414
3625	7	/api/products	GET	304	2025-11-10 17:33:22.71791
3626	7	/api/orders	GET	304	2025-11-10 17:33:22.720518
3627	7	/api/products	GET	304	2025-11-10 17:33:52.731994
3628	7	/api/products	GET	304	2025-11-10 17:33:52.766045
3629	7	/api/products	GET	304	2025-11-10 17:33:53.586493
3630	7	/api/orders	GET	304	2025-11-10 17:33:53.587888
3631	7	/api/clients	GET	304	2025-11-10 17:33:53.625566
4114	7	/api/orders/2/status	PUT	200	2025-11-10 18:22:26.042158
4115	7	/api/orders	GET	200	2025-11-10 18:22:26.049733
4116	7	/api/orders/2/status	PUT	200	2025-11-10 18:22:36.037256
4224	7	/api/products	GET	304	2025-11-10 18:31:04.739511
4227	7	/api/products	GET	304	2025-11-10 18:31:10.557668
4316	7	/api/products	GET	304	2025-11-10 18:35:46.759337
4319	7	/api/auth/me	GET	304	2025-11-10 18:35:50.700307
4320	7	/api/clients	GET	304	2025-11-10 18:35:50.722418
4324	7	/api/products	GET	304	2025-11-10 18:35:50.72882
4327	7	/api/auth/me	GET	304	2025-11-10 18:35:53.725072
4328	7	/api/clients	GET	304	2025-11-10 18:35:53.743636
4332	7	/api/products	GET	304	2025-11-10 18:35:53.752325
4335	7	/api/auth/me	GET	304	2025-11-10 18:35:59.751202
4336	7	/api/clients	GET	304	2025-11-10 18:35:59.774509
4340	7	/api/products	GET	304	2025-11-10 18:35:59.783243
4343	7	/api/auth/me	GET	304	2025-11-10 18:36:00.72587
4344	7	/api/clients	GET	304	2025-11-10 18:36:00.744162
4348	7	/api/products	GET	304	2025-11-10 18:36:00.752303
4351	7	/api/auth/me	GET	304	2025-11-10 18:36:04.732126
4352	7	/api/clients	GET	304	2025-11-10 18:36:04.750921
4356	7	/api/products	GET	304	2025-11-10 18:36:04.758861
4359	7	/api/auth/me	GET	304	2025-11-10 18:36:07.349883
4360	7	/api/clients	GET	304	2025-11-10 18:36:07.370095
4364	7	/api/products	GET	304	2025-11-10 18:36:07.381252
4367	7	/api/auth/me	GET	200	2025-11-10 18:36:08.519437
4368	7	/api/clients	GET	304	2025-11-10 18:36:08.536865
4372	7	/api/products	GET	304	2025-11-10 18:36:08.545194
4376	7	/api/auth/me	GET	304	2025-11-10 18:36:15.761329
4377	7	/api/clients	GET	304	2025-11-10 18:36:15.786874
4381	7	/api/products	GET	304	2025-11-10 18:36:15.796206
4488	7	/api/orders	GET	304	2025-11-10 18:43:42.259201
4501	7	/api/products	GET	304	2025-11-10 18:43:50.237824
4637	7	/api/clients	GET	304	2025-11-11 16:08:59.905805
4640	7	/api/users	GET	304	2025-11-11 16:09:07.04524
4695	7	/api/auth/me	GET	304	2025-11-11 16:42:52.660959
4697	7	/api/auth/me	GET	304	2025-11-11 16:42:53.377291
4699	7	/api/auth/me	GET	200	2025-11-11 16:42:55.377836
4701	7	/api/auth/me	GET	200	2025-11-11 16:42:56.067088
4758	7	/api/products	GET	200	2025-11-11 17:09:47.679721
4834	7	/api/auth/me	GET	304	2026-03-12 17:01:58.499115
4951	7	/api/auth/me	GET	304	2026-03-12 17:29:17.333607
5018	7	/api/auth/me	GET	304	2026-03-12 18:57:50.35071
5121	7	/api/auth/me	GET	304	2026-03-12 20:57:10.135121
5171	7	/api/users	GET	304	2026-03-12 21:00:53.824059
5172	7	/api/clients	GET	304	2026-03-12 21:00:56.297747
5288	7	/api/clients	GET	304	2026-03-12 21:19:44.833034
5408	7	/api/products	GET	304	2026-03-12 21:37:15.326264
5410	7	/api/orders	GET	304	2026-03-12 21:37:15.333593
5411	7	/api/users	GET	304	2026-03-12 21:37:15.777891
5414	7	/api/products	GET	304	2026-03-12 21:37:16.731659
5424	7	/api/clients	GET	304	2026-03-12 21:37:18.652934
5510	7	/api/clients	GET	304	2026-03-13 13:53:04.301278
5511	7	/api/products	GET	304	2026-03-13 13:53:05.90832
5514	7	/api/products	GET	304	2026-03-13 13:53:06.373077
5518	7	/api/orders	GET	304	2026-03-13 13:53:06.419255
5519	7	/api/users	GET	304	2026-03-13 13:53:07.708558
5602	7	/api/auth/me	GET	304	2026-03-13 14:01:33.569302
5641	7	/api/orders	GET	200	2026-03-13 14:24:22.360263
5722	7	/api/clients	GET	200	2026-03-13 14:35:11.831529
5723	7	/api/products	GET	200	2026-03-13 14:35:12.481666
5726	7	/api/products	GET	200	2026-03-13 14:35:13.138877
5735	7	/api/clients	GET	200	2026-03-13 14:35:15.133651
5747	7	/api/products	GET	200	2026-03-13 14:35:21.464612
5831	7	/api/users	GET	200	2026-03-17 20:58:52.484035
5832	7	/api/users	GET	200	2026-03-17 20:58:53.29821
5934	7	/api/summary	GET	200	2026-03-17 21:37:43.935064
6021	7	/api/orders	GET	200	2026-03-17 21:52:14.035406
6024	7	/api/users	GET	200	2026-03-17 21:52:14.507432
6025	7	/api/clients	GET	200	2026-03-17 21:52:15.226773
6133	7	/api/auth/me	GET	200	2026-03-18 15:49:03.029131
6197	7	/api/products	POST	201	2026-03-18 16:03:06.407099
6198	7	/api/products	GET	200	2026-03-18 16:03:06.411791
6261	7	/api/clients	POST	201	2026-03-18 16:20:10.388259
6264	7	/api/summary	GET	200	2026-03-18 16:20:11.467758
6345	7	/api/clients	GET	200	2026-03-18 16:24:17.068162
6406	7	/api/products	GET	200	2026-03-18 16:39:52.070541
6408	7	/api/orders	GET	200	2026-03-18 16:39:52.170617
6494	7	/api/financial/categories	GET	200	2026-03-18 17:30:35.882048
6502	7	/api/financial?	GET	200	2026-03-18 17:30:42.180183
6511	7	/api/products	GET	200	2026-03-18 17:30:49.099112
6581	7	/api/financial/categories	GET	200	2026-03-18 17:42:32.384528
6660	7	/api/financial?status=vencido	GET	200	2026-03-18 18:06:53.992275
6662	7	/api/summary	GET	200	2026-03-18 18:06:54.04083
6670	7	/api/summary	GET	200	2026-03-18 18:07:02.970676
6674	7	/api/clients	GET	200	2026-03-18 18:07:02.992347
6729	\N	/api/financial?status=vencido	GET	401	2026-03-18 21:14:24.622927
6799	7	/api/summary	GET	200	2026-03-18 21:29:59.967188
6882	7	/api/financial?status=vencido	GET	200	2026-03-18 21:40:38.218665
6981	7	/api/purchase-orders	POST	201	2026-03-18 21:46:46.552431
6982	7	/api/purchase-orders	GET	200	2026-03-18 21:46:46.558191
6983	7	/api/purchase-orders/4/status	PATCH	200	2026-03-18 21:46:48.576997
6984	7	/api/purchase-orders	GET	200	2026-03-18 21:46:48.580482
6985	7	/api/purchase-orders/4/status	PATCH	200	2026-03-18 21:46:49.440002
6986	7	/api/purchase-orders	GET	200	2026-03-18 21:46:49.444556
6987	7	/api/financial?	GET	200	2026-03-18 21:46:51.468376
6988	7	/api/financial?	GET	200	2026-03-18 21:46:51.472579
6990	7	/api/financial/categories	GET	200	2026-03-18 21:46:51.598556
7059	7	/api/orders?	GET	200	2026-03-18 21:50:07.328546
7061	7	/api/financial?	GET	200	2026-03-18 21:50:07.714906
7064	7	/api/suppliers	GET	200	2026-03-18 21:50:08.215796
7067	7	/api/products	GET	200	2026-03-18 21:50:08.749269
7123	7	/api/financial?status=vencido	GET	200	2026-03-19 15:42:49.761386
7129	7	/api/summary	GET	200	2026-03-19 15:42:49.8284
7228	7	/api/summary	GET	200	2026-03-19 16:05:34.34665
7272	7	/api/financial?status=vencido	GET	200	2026-03-19 16:11:41.680894
7312	7	/api/auth/me	GET	200	2026-03-19 16:17:02.115425
7313	7	/api/clients	GET	200	2026-03-19 16:17:06.538246
7316	7	/api/products	GET	200	2026-03-19 16:17:07.453065
7317	7	/api/clients	GET	200	2026-03-19 16:17:07.991026
7320	7	/api/products	GET	200	2026-03-19 16:17:07.996395
7322	7	/api/orders	GET	200	2026-03-19 16:17:08.020772
7323	7	/api/users	GET	200	2026-03-19 16:17:08.690626
7326	7	/api/products	GET	200	2026-03-19 16:17:09.6954
7330	7	/api/products	GET	200	2026-03-19 16:17:09.705879
7343	7	/api/suppliers	GET	200	2026-03-19 16:17:10.998819
7389	7	/api/summary	GET	200	2026-03-19 16:21:22.050986
3632	7	/api/clients	GET	304	2025-11-10 17:33:53.628263
3633	7	/api/products	GET	304	2025-11-10 17:33:53.635257
3634	7	/api/orders	GET	304	2025-11-10 17:33:53.637
3635	7	/api/auth/me	GET	200	2025-11-10 17:38:25.099496
3636	7	/api/auth/me	GET	200	2025-11-10 17:38:25.104291
3637	7	/api/clients	GET	304	2025-11-10 17:38:25.129266
3638	7	/api/products	GET	304	2025-11-10 17:38:25.168636
3639	7	/api/clients	GET	304	2025-11-10 17:38:25.173184
3640	7	/api/products	GET	304	2025-11-10 17:38:25.175047
3641	7	/api/orders	GET	200	2025-11-10 17:38:25.295098
3642	7	/api/orders	GET	304	2025-11-10 17:38:25.299485
3643	7	/api/auth/me	GET	304	2025-11-10 17:40:37.761719
3644	7	/api/auth/me	GET	304	2025-11-10 17:40:37.76198
3645	7	/api/clients	GET	304	2025-11-10 17:40:37.791804
3646	7	/api/products	GET	304	2025-11-10 17:40:37.794941
3647	7	/api/clients	GET	304	2025-11-10 17:40:37.79567
3648	7	/api/orders	GET	304	2025-11-10 17:40:37.798958
3649	7	/api/products	GET	304	2025-11-10 17:40:37.801117
3650	7	/api/orders	GET	304	2025-11-10 17:40:37.803709
3651	7	/api/auth/me	GET	304	2025-11-10 17:40:42.649732
3652	7	/api/auth/me	GET	304	2025-11-10 17:40:42.651918
3653	7	/api/clients	GET	304	2025-11-10 17:40:42.670476
3654	7	/api/products	GET	304	2025-11-10 17:40:42.671025
3655	7	/api/orders	GET	304	2025-11-10 17:40:42.67168
3656	7	/api/clients	GET	304	2025-11-10 17:40:42.67844
3657	7	/api/products	GET	304	2025-11-10 17:40:42.679031
3658	7	/api/orders	GET	304	2025-11-10 17:40:42.679976
3659	7	/api/auth/me	GET	304	2025-11-10 17:40:45.734233
3660	7	/api/auth/me	GET	304	2025-11-10 17:40:45.736562
3661	7	/api/clients	GET	304	2025-11-10 17:40:45.756261
3662	7	/api/products	GET	304	2025-11-10 17:40:45.756926
3663	7	/api/orders	GET	304	2025-11-10 17:40:45.762119
3664	7	/api/clients	GET	304	2025-11-10 17:40:45.762583
3665	7	/api/products	GET	304	2025-11-10 17:40:45.763174
3666	7	/api/orders	GET	304	2025-11-10 17:40:45.766616
3667	7	/api/auth/me	GET	304	2025-11-10 17:40:46.721151
3668	7	/api/auth/me	GET	304	2025-11-10 17:40:46.723353
3669	7	/api/clients	GET	304	2025-11-10 17:40:46.740839
3670	7	/api/products	GET	304	2025-11-10 17:40:46.741345
3671	7	/api/orders	GET	304	2025-11-10 17:40:46.741995
3672	7	/api/clients	GET	304	2025-11-10 17:40:46.748446
3673	7	/api/products	GET	304	2025-11-10 17:40:46.748927
3674	7	/api/orders	GET	304	2025-11-10 17:40:46.749497
3675	7	/api/auth/me	GET	304	2025-11-10 17:40:55.708347
3676	7	/api/auth/me	GET	304	2025-11-10 17:40:55.710514
3677	7	/api/clients	GET	304	2025-11-10 17:40:55.730423
3678	7	/api/products	GET	304	2025-11-10 17:40:55.731499
3679	7	/api/orders	GET	304	2025-11-10 17:40:55.732212
3680	7	/api/clients	GET	304	2025-11-10 17:40:55.738147
3681	7	/api/products	GET	304	2025-11-10 17:40:55.738653
3682	7	/api/orders	GET	304	2025-11-10 17:40:55.739275
3683	7	/api/auth/me	GET	304	2025-11-10 17:41:03.68462
3684	7	/api/auth/me	GET	304	2025-11-10 17:41:03.686855
3685	7	/api/clients	GET	304	2025-11-10 17:41:03.705839
3686	7	/api/products	GET	304	2025-11-10 17:41:03.706473
3687	7	/api/orders	GET	304	2025-11-10 17:41:03.707099
3688	7	/api/clients	GET	304	2025-11-10 17:41:03.713919
3689	7	/api/products	GET	304	2025-11-10 17:41:03.71468
3690	7	/api/orders	GET	304	2025-11-10 17:41:03.715233
3691	7	/api/auth/me	GET	304	2025-11-10 17:41:15.75213
3692	7	/api/auth/me	GET	304	2025-11-10 17:41:15.752247
3693	7	/api/clients	GET	304	2025-11-10 17:41:15.777521
3694	7	/api/products	GET	304	2025-11-10 17:41:15.778303
3696	7	/api/clients	GET	304	2025-11-10 17:41:15.784016
3695	7	/api/orders	GET	304	2025-11-10 17:41:15.783274
3697	7	/api/products	GET	304	2025-11-10 17:41:15.786523
3698	7	/api/orders	GET	304	2025-11-10 17:41:15.789336
3699	7	/api/auth/me	GET	200	2025-11-10 17:41:27.891394
3700	7	/api/auth/me	GET	200	2025-11-10 17:41:27.896453
3701	7	/api/clients	GET	304	2025-11-10 17:41:27.917368
3702	7	/api/clients	GET	304	2025-11-10 17:41:27.920972
3703	7	/api/products	GET	304	2025-11-10 17:41:27.923814
3704	7	/api/orders	GET	304	2025-11-10 17:41:27.927781
3705	7	/api/products	GET	304	2025-11-10 17:41:27.929981
3706	7	/api/orders	GET	304	2025-11-10 17:41:27.93254
3707	7	/api/orders/16	PUT	200	2025-11-10 17:41:38.906426
3708	7	/api/orders	GET	200	2025-11-10 17:41:38.913616
3709	7	/api/orders/7	PUT	200	2025-11-10 17:41:43.939325
3710	7	/api/orders	GET	200	2025-11-10 17:41:43.945517
3711	7	/api/orders/6	PUT	200	2025-11-10 17:41:50.150194
3712	7	/api/orders	GET	200	2025-11-10 17:41:50.157085
3713	7	/api/auth/me	GET	304	2025-11-10 17:47:52.370316
3714	7	/api/auth/me	GET	304	2025-11-10 17:47:52.370676
3715	7	/api/clients	GET	304	2025-11-10 17:47:52.401627
3716	7	/api/products	GET	304	2025-11-10 17:47:52.403061
3717	7	/api/orders	GET	304	2025-11-10 17:47:52.409073
3718	7	/api/clients	GET	304	2025-11-10 17:47:52.410293
3719	7	/api/products	GET	304	2025-11-10 17:47:52.412589
3720	7	/api/orders	GET	304	2025-11-10 17:47:52.415589
3721	7	/api/auth/me	GET	304	2025-11-10 17:48:09.673024
3722	7	/api/auth/me	GET	304	2025-11-10 17:48:09.673167
3723	7	/api/products	GET	304	2025-11-10 17:48:09.698189
3724	7	/api/orders	GET	304	2025-11-10 17:48:09.701555
3725	7	/api/products	GET	304	2025-11-10 17:48:09.739031
3726	7	/api/orders	GET	304	2025-11-10 17:48:09.740461
3727	7	/api/clients	GET	304	2025-11-10 17:48:09.798279
3728	7	/api/clients	GET	304	2025-11-10 17:48:09.801233
3729	7	/api/auth/me	GET	304	2025-11-10 17:48:20.716206
3730	7	/api/auth/me	GET	304	2025-11-10 17:48:20.717169
3731	7	/api/clients	GET	304	2025-11-10 17:48:20.74084
3732	7	/api/products	GET	304	2025-11-10 17:48:20.741366
3733	7	/api/clients	GET	304	2025-11-10 17:48:20.746662
3734	7	/api/orders	GET	304	2025-11-10 17:48:20.747472
3735	7	/api/products	GET	304	2025-11-10 17:48:20.748364
3736	7	/api/orders	GET	304	2025-11-10 17:48:20.752778
3737	7	/api/auth/me	GET	304	2025-11-10 17:48:26.730038
3738	7	/api/auth/me	GET	304	2025-11-10 17:48:26.732473
3739	7	/api/clients	GET	304	2025-11-10 17:48:26.753107
3740	7	/api/products	GET	304	2025-11-10 17:48:26.753512
3741	7	/api/orders	GET	304	2025-11-10 17:48:26.754111
3742	7	/api/clients	GET	304	2025-11-10 17:48:26.760847
3743	7	/api/products	GET	304	2025-11-10 17:48:26.76231
3744	7	/api/orders	GET	304	2025-11-10 17:48:26.763155
3745	7	/api/auth/me	GET	304	2025-11-10 17:48:46.706146
3746	7	/api/auth/me	GET	304	2025-11-10 17:48:46.706625
3747	7	/api/clients	GET	304	2025-11-10 17:48:46.731651
3748	7	/api/clients	GET	304	2025-11-10 17:48:46.73582
3749	7	/api/products	GET	304	2025-11-10 17:48:46.737685
3750	7	/api/orders	GET	304	2025-11-10 17:48:46.74365
3751	7	/api/products	GET	304	2025-11-10 17:48:46.747913
3752	7	/api/orders	GET	304	2025-11-10 17:48:46.751153
3753	7	/api/auth/me	GET	304	2025-11-10 17:48:49.397305
3756	7	/api/products	GET	304	2025-11-10 17:48:49.420273
3760	7	/api/orders	GET	304	2025-11-10 17:48:49.429422
3761	7	/api/auth/me	GET	200	2025-11-10 17:48:50.96175
3764	7	/api/products	GET	304	2025-11-10 17:48:50.982576
4117	7	/api/orders	GET	200	2025-11-10 18:22:36.074498
4225	7	/api/products	GET	304	2025-11-10 18:31:04.772802
4226	7	/api/clients	GET	304	2025-11-10 18:31:10.550918
4317	7	/api/orders	GET	304	2025-11-10 18:35:46.761436
4318	7	/api/auth/me	GET	304	2025-11-10 18:35:50.697201
4321	7	/api/products	GET	304	2025-11-10 18:35:50.722882
4325	7	/api/orders	GET	304	2025-11-10 18:35:50.731353
4326	7	/api/auth/me	GET	304	2025-11-10 18:35:53.722751
4329	7	/api/products	GET	304	2025-11-10 18:35:53.744109
4333	7	/api/orders	GET	304	2025-11-10 18:35:53.7529
4334	7	/api/auth/me	GET	304	2025-11-10 18:35:59.748494
4337	7	/api/products	GET	304	2025-11-10 18:35:59.775059
4341	7	/api/orders	GET	304	2025-11-10 18:35:59.783896
4342	7	/api/auth/me	GET	304	2025-11-10 18:36:00.723541
4345	7	/api/products	GET	304	2025-11-10 18:36:00.744708
4349	7	/api/orders	GET	304	2025-11-10 18:36:00.752976
4350	7	/api/auth/me	GET	304	2025-11-10 18:36:04.729467
4353	7	/api/products	GET	304	2025-11-10 18:36:04.751597
4357	7	/api/orders	GET	304	2025-11-10 18:36:04.759511
4358	7	/api/auth/me	GET	304	2025-11-10 18:36:07.347433
4361	7	/api/products	GET	304	2025-11-10 18:36:07.371233
4365	7	/api/orders	GET	304	2025-11-10 18:36:07.381898
4366	7	/api/auth/me	GET	200	2025-11-10 18:36:08.515646
4369	7	/api/products	GET	304	2025-11-10 18:36:08.537488
4373	7	/api/orders	GET	304	2025-11-10 18:36:08.545774
4374	7	/api/orders/21/status	PUT	400	2025-11-10 18:36:12.799853
4375	7	/api/auth/me	GET	304	2025-11-10 18:36:15.758397
4378	7	/api/products	GET	304	2025-11-10 18:36:15.78741
4491	7	/api/auth/me	GET	200	2025-11-10 18:43:42.352925
4492	7	/api/orders/22	DELETE	200	2025-11-10 18:43:44.866112
4493	7	/api/orders	GET	200	2025-11-10 18:43:44.874065
4494	7	/api/orders/21	DELETE	200	2025-11-10 18:43:47.048818
4495	7	/api/orders	GET	200	2025-11-10 18:43:47.053259
4496	7	/api/products	GET	304	2025-11-10 18:43:48.324268
4499	7	/api/clients	GET	304	2025-11-10 18:43:50.231849
4503	7	/api/orders	GET	304	2025-11-10 18:43:50.240942
4507	7	/api/products	GET	304	2025-11-10 18:43:58.948939
4508	7	/api/products	GET	304	2025-11-10 18:44:01.678216
4522	7	/api/orders	GET	304	2025-11-10 18:44:08.208939
4527	7	/api/products	GET	304	2025-11-10 18:44:11.191681
4528	7	/api/clients	GET	304	2025-11-10 18:44:15.456761
4638	7	/api/products	GET	304	2025-11-11 16:08:59.906471
4639	7	/api/users	GET	304	2025-11-11 16:09:07.03951
4696	7	/api/auth/me	GET	304	2025-11-11 16:42:53.375099
4700	7	/api/auth/me	GET	200	2025-11-11 16:42:56.06442
4759	7	/api/orders	GET	200	2025-11-11 17:09:47.682234
4835	7	/api/auth/me	GET	304	2026-03-12 17:01:58.499383
4952	7	/api/auth/me	GET	304	2026-03-12 17:29:17.339231
5019	7	/api/clients	GET	304	2026-03-12 18:57:50.373773
5122	7	/api/clients	GET	304	2026-03-12 20:57:10.165646
5125	7	/api/orders	GET	304	2026-03-12 20:57:10.708142
5174	7	/api/clients	GET	304	2026-03-12 21:00:56.342119
5177	7	/api/orders	GET	304	2026-03-12 21:00:56.350357
5178	7	/api/products	GET	304	2026-03-12 21:00:57.536478
5181	7	/api/clients	GET	304	2026-03-12 21:00:59.58089
5182	7	/api/products	GET	304	2026-03-12 21:01:04.559884
5185	7	/api/clients	GET	304	2026-03-12 21:01:05.168966
5189	7	/api/orders	GET	304	2026-03-12 21:01:05.176959
5289	7	/api/clients	GET	304	2026-03-12 21:19:44.876539
5291	7	/api/orders	GET	304	2026-03-12 21:19:44.883339
5293	7	/api/products	GET	304	2026-03-12 21:19:44.977694
5409	7	/api/orders	GET	304	2026-03-12 21:37:15.328346
5412	7	/api/users	GET	304	2026-03-12 21:37:15.783079
5413	7	/api/clients	GET	304	2026-03-12 21:37:16.731022
5426	7	/api/orders	GET	304	2026-03-12 21:37:18.655116
5515	7	/api/clients	GET	304	2026-03-13 13:53:06.412625
5603	7	/api/auth/me	GET	304	2026-03-13 14:04:47.234582
5644	7	/api/auth/me	GET	200	2026-03-13 14:24:22.372446
5727	7	/api/clients	GET	200	2026-03-13 14:35:13.181263
5736	7	/api/orders	GET	200	2026-03-13 14:35:15.134395
5740	7	/api/products	GET	200	2026-03-13 14:35:16.582746
5741	7	/api/clients	GET	200	2026-03-13 14:35:17.500043
5744	7	/api/users	GET	200	2026-03-13 14:35:21.055392
5745	7	/api/clients	GET	200	2026-03-13 14:35:21.454545
5834	7	/api/users	GET	200	2026-03-17 20:59:05.33046
5837	7	/api/auth/me	GET	200	2026-03-17 20:59:10.197176
5838	7	/api/users	GET	200	2026-03-17 20:59:10.236009
5841	7	/api/products	GET	200	2026-03-17 20:59:11.586432
5842	7	/api/clients	GET	200	2026-03-17 20:59:11.603125
5935	7	/api/auth/me	GET	200	2026-03-17 21:37:43.979414
6029	7	/api/products	GET	200	2026-03-17 21:52:15.271791
6032	7	/api/products	GET	200	2026-03-17 21:52:16.336915
6033	7	/api/clients	GET	200	2026-03-17 21:52:16.844798
6036	7	/api/summary	GET	200	2026-03-17 21:52:17.884858
6134	7	/api/suppliers	GET	200	2026-03-18 15:49:03.063736
6199	7	/api/products	POST	201	2026-03-18 16:03:17.686879
6200	7	/api/products	GET	200	2026-03-18 16:03:17.691507
6262	7	/api/clients	GET	200	2026-03-18 16:20:10.421481
6263	7	/api/summary	GET	200	2026-03-18 16:20:11.460732
6346	7	/api/products	GET	200	2026-03-18 16:24:17.068758
6407	7	/api/orders	GET	200	2026-03-18 16:39:52.166313
6495	7	/api/financial/categories	GET	200	2026-03-18 17:30:35.917056
6497	7	/api/financial?	GET	200	2026-03-18 17:30:36.004237
6498	7	/api/summary	GET	200	2026-03-18 17:30:39.55851
6501	7	/api/financial/categories	GET	200	2026-03-18 17:30:42.172121
6510	7	/api/orders	GET	200	2026-03-18 17:30:49.09833
6582	7	/api/financial?	GET	200	2026-03-18 17:42:32.38791
6661	7	/api/summary	GET	200	2026-03-18 18:06:54.026074
6669	7	/api/financial?status=vencido	GET	200	2026-03-18 18:07:02.966622
6675	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:07:02.99356
6730	\N	/api/auth/login	POST	200	2026-03-18 21:15:56.178931
6731	7	/api/summary	GET	200	2026-03-18 21:15:56.232317
6733	7	/api/financial?status=vencido	GET	200	2026-03-18 21:15:56.259297
6734	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:15:56.267345
6736	7	/api/summary	GET	200	2026-03-18 21:15:56.278312
6741	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:16:05.908099
6742	7	/api/financial?status=vencido	GET	200	2026-03-18 21:16:06.527033
6800	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:30:00.029011
6886	7	/api/financial?status=vencido	GET	200	2026-03-18 21:40:38.242229
3754	7	/api/auth/me	GET	304	2025-11-10 17:48:49.399534
3755	7	/api/clients	GET	304	2025-11-10 17:48:49.419016
3759	7	/api/products	GET	304	2025-11-10 17:48:49.428848
3762	7	/api/auth/me	GET	200	2025-11-10 17:48:50.964545
3763	7	/api/clients	GET	304	2025-11-10 17:48:50.982009
3767	7	/api/products	GET	304	2025-11-10 17:48:50.988892
4118	7	/api/orders	POST	201	2025-11-10 18:23:46.608206
4121	7	/api/products	GET	304	2025-11-10 18:23:51.11195
4228	7	/api/products	GET	304	2025-11-10 18:31:10.593352
4231	7	/api/orders	GET	304	2025-11-10 18:31:10.711361
4384	7	/api/auth/me	GET	200	2025-11-10 18:39:09.974557
4385	7	/api/auth/me	GET	200	2025-11-10 18:39:09.979101
4386	7	/api/clients	GET	304	2025-11-10 18:39:10.005683
4390	7	/api/products	GET	304	2025-11-10 18:39:10.05347
4395	7	/api/products	GET	304	2025-11-10 18:39:18.915435
4396	7	/api/products	GET	304	2025-11-10 18:39:20.936569
4510	7	/api/clients	GET	304	2025-11-10 18:44:01.716502
4521	7	/api/products	GET	304	2025-11-10 18:44:08.208259
4530	7	/api/orders	GET	304	2025-11-10 18:44:15.461815
4641	7	/api/auth/me	GET	304	2025-11-11 16:22:01.049878
4702	7	/api/products	GET	304	2025-11-11 16:43:30.25702
4705	7	/api/clients	GET	304	2025-11-11 16:43:32.630287
4706	7	/api/clients	GET	304	2025-11-11 16:43:38.539711
4709	7	/api/products	GET	304	2025-11-11 16:43:39.816053
4710	7	/api/clients	GET	304	2025-11-11 16:43:42.577343
4760	7	/api/clients	GET	200	2025-11-11 17:09:47.685075
4836	\N	/api/auth/login	POST	200	2026-03-12 17:02:13.993157
4953	7	/api/auth/me	GET	304	2026-03-12 17:38:02.195248
5020	7	/api/clients	GET	304	2026-03-12 18:57:50.404605
5123	7	/api/products	GET	304	2026-03-12 20:57:10.175701
5175	7	/api/orders	GET	304	2026-03-12 21:00:56.344649
5186	7	/api/orders	GET	304	2026-03-12 21:01:05.169618
5290	7	/api/orders	GET	304	2026-03-12 21:19:44.87852
5418	7	/api/orders	GET	304	2026-03-12 21:37:16.772018
5419	7	/api/products	GET	304	2026-03-12 21:37:17.570448
5422	7	/api/products	GET	304	2026-03-12 21:37:18.634899
5516	7	/api/orders	GET	304	2026-03-13 13:53:06.413896
5604	7	/api/auth/me	GET	304	2026-03-13 14:04:47.235773
5606	7	/api/auth/me	GET	200	2026-03-13 14:04:50.745462
5645	7	/api/products	GET	200	2026-03-13 14:24:41.109814
5648	7	/api/clients	GET	200	2026-03-13 14:24:42.135167
5728	7	/api/products	GET	200	2026-03-13 14:35:13.181981
5730	7	/api/orders	GET	200	2026-03-13 14:35:13.18902
5731	7	/api/users	GET	200	2026-03-13 14:35:14.399585
5734	7	/api/products	GET	200	2026-03-13 14:35:15.1304
5749	7	/api/products	GET	200	2026-03-13 14:35:21.467664
5835	7	/api/users	GET	200	2026-03-17 20:59:05.360721
5836	7	/api/auth/me	GET	200	2026-03-17 20:59:10.195145
5839	7	/api/users	GET	200	2026-03-17 20:59:10.238563
5840	7	/api/clients	GET	200	2026-03-17 20:59:11.584011
5843	7	/api/products	GET	200	2026-03-17 20:59:11.605479
5845	7	/api/orders	GET	200	2026-03-17 20:59:11.72448
5846	7	/api/products	GET	200	2026-03-17 20:59:18.117129
5849	7	/api/clients	GET	200	2026-03-17 20:59:20.303078
5850	7	/api/summary	GET	200	2026-03-17 20:59:20.797246
5936	7	/api/clients	GET	200	2026-03-17 21:38:01.498946
5939	7	/api/products	GET	200	2026-03-17 21:38:07.021928
5940	7	/api/auth/me	GET	200	2026-03-17 21:38:10.803761
5943	7	/api/products	GET	200	2026-03-17 21:38:10.849862
5944	7	/api/summary	GET	200	2026-03-17 21:38:11.981824
6030	7	/api/orders	GET	200	2026-03-17 21:52:15.27429
6031	7	/api/products	GET	200	2026-03-17 21:52:16.335034
6034	7	/api/clients	GET	200	2026-03-17 21:52:16.846415
6035	7	/api/summary	GET	200	2026-03-17 21:52:17.879295
6135	7	/api/suppliers	GET	200	2026-03-18 15:49:03.064458
6201	7	/api/products	POST	201	2026-03-18 16:03:31.262234
6202	7	/api/products	GET	200	2026-03-18 16:03:31.266456
6203	7	/api/clients	GET	200	2026-03-18 16:03:34.406325
6265	7	/api/products	GET	200	2026-03-18 16:20:33.47252
6268	7	/api/clients	GET	200	2026-03-18 16:20:34.482957
6270	7	/api/orders	GET	200	2026-03-18 16:20:34.494147
6347	7	/api/products	GET	200	2026-03-18 16:24:17.101662
6349	7	/api/orders	GET	200	2026-03-18 16:24:17.174436
6409	7	/api/orders	POST	201	2026-03-18 16:40:34.917461
6410	7	/api/orders	GET	200	2026-03-18 16:40:34.923144
6411	7	/api/products	GET	200	2026-03-18 16:40:36.966852
6414	7	/api/summary	GET	200	2026-03-18 16:40:42.008795
6496	7	/api/financial?	GET	200	2026-03-18 17:30:35.998084
6499	7	/api/summary	GET	200	2026-03-18 17:30:39.569156
6500	7	/api/financial?	GET	200	2026-03-18 17:30:42.170643
6512	7	/api/clients	GET	200	2026-03-18 17:30:49.104599
6583	7	/api/financial/categories	GET	200	2026-03-18 17:42:32.417796
6588	7	/api/summary	GET	200	2026-03-18 17:42:41.385197
6663	7	/api/financial?status=vencido	GET	200	2026-03-18 18:06:54.063892
6665	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:06:54.185471
6666	7	/api/auth/me	GET	200	2026-03-18 18:07:02.931039
6668	7	/api/financial?status=vencido	GET	200	2026-03-18 18:07:02.963718
6732	7	/api/financial?status=vencido	GET	200	2026-03-18 21:15:56.254771
6738	7	/api/summary	GET	200	2026-03-18 21:15:56.289286
6740	7	/api/summary	GET	200	2026-03-18 21:16:05.903531
6743	7	/api/summary	GET	200	2026-03-18 21:16:06.529011
6801	7	/api/financial?status=vencido	GET	200	2026-03-18 21:34:59.979019
6887	7	/api/summary	GET	200	2026-03-18 21:40:38.245794
6889	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:40:38.273432
6891	7	/api/suppliers	GET	200	2026-03-18 21:40:40.803065
6895	7	/api/purchase-orders	GET	200	2026-03-18 21:40:40.813351
6989	7	/api/financial/categories	GET	200	2026-03-18 21:46:51.596006
7072	7	/api/financial?status=vencido	GET	200	2026-03-18 21:51:27.758735
7074	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:51:27.77004
7126	7	/api/summary	GET	200	2026-03-19 15:42:49.796673
7128	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:42:49.813021
7229	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:05:34.388579
7271	7	/api/financial?status=vencido	GET	200	2026-03-19 16:11:41.678919
7315	7	/api/products	GET	200	2026-03-19 16:17:07.44965
7318	7	/api/products	GET	200	2026-03-19 16:17:07.991701
7328	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:17:09.704306
7357	7	/api/orders	GET	200	2026-03-19 16:17:15.501341
7360	7	/api/users	GET	200	2026-03-19 16:17:18.469903
7361	7	/api/orders?	GET	200	2026-03-19 16:17:19.28883
7366	7	/api/clients	GET	200	2026-03-19 16:17:19.303806
7374	7	/api/financial/categories	GET	200	2026-03-19 16:17:20.030496
7375	7	/api/suppliers	GET	200	2026-03-19 16:17:20.635359
7378	7	/api/products	GET	200	2026-03-19 16:17:21.48207
3757	7	/api/orders	GET	304	2025-11-10 17:48:49.420952
3766	7	/api/clients	GET	304	2025-11-10 17:48:50.98802
4119	7	/api/orders	GET	200	2025-11-10 18:23:46.616089
4120	7	/api/products	GET	200	2025-11-10 18:23:51.106658
4229	7	/api/clients	GET	304	2025-11-10 18:31:10.703649
4387	7	/api/clients	GET	304	2025-11-10 18:39:10.044993
4512	7	/api/products	GET	304	2025-11-10 18:44:01.727294
4517	7	/api/products	GET	304	2025-11-10 18:44:06.885574
4518	7	/api/products	GET	304	2025-11-10 18:44:08.198036
4533	7	/api/orders	GET	304	2025-11-10 18:44:15.468556
4534	7	/api/orders/23/status	PUT	200	2025-11-10 18:44:19.703873
4535	7	/api/orders	GET	200	2025-11-10 18:44:19.714369
4536	7	/api/products	GET	304	2025-11-10 18:44:27.099963
4539	7	/api/auth/me	GET	304	2025-11-10 18:44:32.313472
4540	7	/api/products	GET	304	2025-11-10 18:44:32.336969
4543	7	/api/clients	GET	304	2025-11-10 18:44:33.227302
4545	7	/api/orders	GET	304	2025-11-10 18:44:33.267899
4642	7	/api/auth/me	GET	304	2025-11-11 16:22:01.182424
4703	7	/api/products	GET	304	2025-11-11 16:43:30.426448
4704	7	/api/clients	GET	304	2025-11-11 16:43:32.626705
4707	7	/api/clients	GET	304	2025-11-11 16:43:38.542512
4708	7	/api/products	GET	304	2025-11-11 16:43:39.812449
4711	7	/api/products	GET	304	2025-11-11 16:43:42.577911
4761	7	/api/products	GET	200	2025-11-11 17:09:47.688529
4837	7	/api/auth/me	GET	304	2026-03-12 17:05:25.747282
4840	7	/api/auth/me	GET	304	2026-03-12 17:05:35.472127
4841	7	/api/auth/me	GET	304	2026-03-12 17:05:38.47784
4844	7	/api/auth/me	GET	304	2026-03-12 17:05:39.54018
4845	7	/api/auth/me	GET	304	2026-03-12 17:05:40.105155
4848	7	/api/auth/me	GET	304	2026-03-12 17:05:40.357975
4849	7	/api/auth/me	GET	304	2026-03-12 17:05:40.545319
4852	7	/api/auth/me	GET	304	2026-03-12 17:05:40.693625
4853	7	/api/auth/me	GET	304	2026-03-12 17:05:40.848862
4856	7	/api/auth/me	GET	304	2026-03-12 17:05:40.973489
4857	7	/api/auth/me	GET	304	2026-03-12 17:05:41.359056
4860	7	/api/auth/me	GET	304	2026-03-12 17:05:41.562943
4861	7	/api/auth/me	GET	304	2026-03-12 17:05:41.753378
4864	7	/api/auth/me	GET	304	2026-03-12 17:05:42.014131
4865	7	/api/auth/me	GET	304	2026-03-12 17:05:42.208993
4868	7	/api/auth/me	GET	304	2026-03-12 17:05:42.371405
4954	7	/api/auth/me	GET	304	2026-03-12 17:38:02.197285
5021	7	/api/clients	GET	304	2026-03-12 18:58:48.488721
5024	7	/api/products	GET	304	2026-03-12 18:58:49.221085
5025	7	/api/clients	GET	304	2026-03-12 18:58:49.932129
5037	7	/api/products	GET	304	2026-03-12 18:58:51.950282
5045	7	/api/products	GET	304	2026-03-12 18:58:55.184046
5048	7	/api/users	GET	304	2026-03-12 18:58:55.982118
5049	7	/api/clients	GET	304	2026-03-12 18:58:56.670988
5124	7	/api/orders	GET	304	2026-03-12 20:57:10.700465
5176	7	/api/products	GET	304	2026-03-12 21:00:56.347355
5179	7	/api/products	GET	304	2026-03-12 21:00:57.54022
5180	7	/api/clients	GET	304	2026-03-12 21:00:59.578106
5183	7	/api/products	GET	304	2026-03-12 21:01:04.564042
5184	7	/api/products	GET	304	2026-03-12 21:01:05.168355
5188	7	/api/clients	GET	304	2026-03-12 21:01:05.176211
5292	7	/api/products	GET	304	2026-03-12 21:19:44.973386
5427	7	/api/products	GET	304	2026-03-12 21:37:29.581837
5430	7	/api/users	GET	304	2026-03-12 21:37:30.471936
5431	7	/api/clients	GET	304	2026-03-12 21:37:33.36653
5517	7	/api/products	GET	304	2026-03-13 13:53:06.414652
5520	7	/api/users	GET	304	2026-03-13 13:53:07.713991
5605	7	/api/auth/me	GET	200	2026-03-13 14:04:50.741967
5646	7	/api/products	GET	200	2026-03-13 14:24:41.1426
5647	7	/api/products	GET	200	2026-03-13 14:24:42.133673
5649	7	/api/clients	GET	200	2026-03-13 14:24:42.148096
5651	7	/api/orders	GET	200	2026-03-13 14:24:42.178124
5729	7	/api/orders	GET	200	2026-03-13 14:35:13.183745
5732	7	/api/users	GET	200	2026-03-13 14:35:14.4035
5733	7	/api/clients	GET	200	2026-03-13 14:35:15.129416
5750	7	/api/orders	GET	200	2026-03-13 14:35:21.470212
5844	7	/api/orders	GET	200	2026-03-17 20:59:11.720444
5847	7	/api/products	GET	200	2026-03-17 20:59:18.120923
5848	7	/api/clients	GET	200	2026-03-17 20:59:20.300743
5851	7	/api/summary	GET	200	2026-03-17 20:59:20.801965
5937	7	/api/clients	GET	200	2026-03-17 21:38:01.608843
5938	7	/api/products	GET	200	2026-03-17 21:38:07.02024
5941	7	/api/auth/me	GET	200	2026-03-17 21:38:10.805715
5942	7	/api/products	GET	200	2026-03-17 21:38:10.84792
5945	7	/api/summary	GET	200	2026-03-17 21:38:11.990162
6037	7	/api/clients	GET	200	2026-03-17 21:56:25.737902
6040	7	/api/products	GET	200	2026-03-17 21:56:26.355641
6041	7	/api/users	GET	200	2026-03-17 21:56:26.832665
6044	7	/api/products	GET	200	2026-03-17 21:56:27.910707
6061	7	/api/orders	GET	200	2026-03-17 21:56:35.283456
6064	7	/api/users	GET	200	2026-03-17 21:56:35.965239
6065	7	/api/auth/me	GET	200	2026-03-17 21:56:37.226832
6068	7	/api/users	GET	200	2026-03-17 21:56:37.279226
6136	7	/api/suppliers	POST	500	2026-03-18 15:51:12.41306
6204	7	/api/clients	GET	200	2026-03-18 16:03:34.443285
6266	7	/api/products	GET	200	2026-03-18 16:20:33.553421
6267	7	/api/products	GET	200	2026-03-18 16:20:34.475347
6269	7	/api/orders	GET	200	2026-03-18 16:20:34.487461
6348	7	/api/orders	GET	200	2026-03-18 16:24:17.169789
6412	7	/api/products	GET	200	2026-03-18 16:40:37.002008
6413	7	/api/summary	GET	200	2026-03-18 16:40:42.003647
6503	7	/api/financial/categories	GET	200	2026-03-18 17:30:42.207358
6504	7	/api/financial?	GET	200	2026-03-18 17:30:45.997606
6505	7	/api/financial?	GET	200	2026-03-18 17:30:46.432019
6506	7	/api/financial?	GET	200	2026-03-18 17:30:46.592106
6507	7	/api/financial?	GET	200	2026-03-18 17:30:46.742292
6508	7	/api/financial?	GET	200	2026-03-18 17:30:46.876056
6509	7	/api/clients	GET	200	2026-03-18 17:30:49.097287
6513	7	/api/products	GET	200	2026-03-18 17:30:49.106402
6584	7	/api/financial?	GET	200	2026-03-18 17:42:32.424843
6585	7	/api/financial/17	PUT	200	2026-03-18 17:42:40.227976
6586	7	/api/financial?	GET	200	2026-03-18 17:42:40.233618
6587	7	/api/summary	GET	200	2026-03-18 17:42:41.374544
6664	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:06:54.181218
6667	7	/api/auth/me	GET	200	2026-03-18 18:07:02.93412
6671	7	/api/summary	GET	200	2026-03-18 18:07:02.975564
6672	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:07:02.982279
6673	7	/api/clients	GET	200	2026-03-18 18:07:02.991322
6735	7	/api/summary	GET	200	2026-03-18 21:15:56.272216
6737	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:15:56.28068
6739	7	/api/financial?status=vencido	GET	200	2026-03-18 21:16:05.901266
6744	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:16:06.532316
3758	7	/api/clients	GET	304	2025-11-10 17:48:49.428352
3765	7	/api/orders	GET	304	2025-11-10 17:48:50.987371
3768	7	/api/orders	GET	304	2025-11-10 17:48:50.991729
3769	7	/api/orders	GET	304	2025-11-10 17:48:54.0403
3770	7	/api/orders	GET	304	2025-11-10 17:48:55.549345
3771	7	/api/auth/me	GET	200	2025-11-10 17:49:03.430911
3772	7	/api/clients	GET	304	2025-11-10 17:49:03.464065
3773	7	/api/auth/me	GET	200	2025-11-10 17:49:03.47011
3774	7	/api/products	GET	304	2025-11-10 17:49:03.502658
3775	7	/api/clients	GET	304	2025-11-10 17:49:03.50678
3776	7	/api/orders	GET	304	2025-11-10 17:49:03.507634
3777	7	/api/products	GET	304	2025-11-10 17:49:03.510427
3778	7	/api/orders	GET	304	2025-11-10 17:49:03.513005
3779	7	/api/orders	GET	304	2025-11-10 17:49:29.180097
3780	7	/api/auth/me	GET	200	2025-11-10 17:51:02.634656
3781	7	/api/auth/me	GET	200	2025-11-10 17:51:02.635222
3782	7	/api/clients	GET	200	2025-11-10 17:51:02.676654
3783	7	/api/clients	GET	200	2025-11-10 17:51:02.67788
3784	7	/api/products	GET	200	2025-11-10 17:51:02.681609
3785	7	/api/orders	GET	200	2025-11-10 17:51:02.687648
3786	7	/api/orders	GET	200	2025-11-10 17:51:02.688812
3787	7	/api/products	GET	200	2025-11-10 17:51:02.690133
3788	7	/api/auth/me	GET	200	2025-11-10 17:51:06.933937
3789	7	/api/auth/me	GET	200	2025-11-10 17:51:06.936316
3790	7	/api/clients	GET	304	2025-11-10 17:51:06.962074
3791	7	/api/products	GET	304	2025-11-10 17:51:06.9626
3792	7	/api/orders	GET	304	2025-11-10 17:51:06.963361
3793	7	/api/clients	GET	304	2025-11-10 17:51:06.970294
3794	7	/api/products	GET	304	2025-11-10 17:51:06.970879
3795	7	/api/orders	GET	304	2025-11-10 17:51:06.971793
3796	7	/api/auth/me	GET	200	2025-11-10 17:52:30.615557
3797	7	/api/auth/me	GET	200	2025-11-10 17:52:30.61581
3798	7	/api/auth/me	GET	200	2025-11-10 17:52:31.163286
3799	7	/api/auth/me	GET	200	2025-11-10 17:52:31.166204
3800	7	/api/clients	GET	200	2025-11-10 17:52:31.204524
3801	7	/api/products	GET	200	2025-11-10 17:52:31.205071
3802	7	/api/clients	GET	200	2025-11-10 17:52:31.205604
3803	7	/api/orders	GET	200	2025-11-10 17:52:31.206497
3804	7	/api/products	GET	200	2025-11-10 17:52:31.20769
3805	7	/api/orders	GET	200	2025-11-10 17:52:31.209575
3806	7	/api/auth/me	GET	200	2025-11-10 17:52:35.39147
3807	7	/api/auth/me	GET	200	2025-11-10 17:52:35.394108
3808	7	/api/clients	GET	304	2025-11-10 17:52:35.420514
3809	7	/api/products	GET	304	2025-11-10 17:52:35.420955
3810	7	/api/orders	GET	304	2025-11-10 17:52:35.421528
3811	7	/api/clients	GET	304	2025-11-10 17:52:35.428453
3812	7	/api/products	GET	304	2025-11-10 17:52:35.429153
3813	7	/api/orders	GET	304	2025-11-10 17:52:35.430661
3814	7	/api/orders/2/status	PUT	500	2025-11-10 17:52:36.74147
3815	7	/api/orders/2	PUT	200	2025-11-10 17:54:08.700418
3816	7	/api/orders	GET	200	2025-11-10 17:54:08.729143
3817	7	/api/auth/me	GET	200	2025-11-10 17:57:36.371998
3818	7	/api/clients	GET	304	2025-11-10 17:57:36.400916
3819	7	/api/auth/me	GET	200	2025-11-10 17:57:36.410753
3820	7	/api/products	GET	304	2025-11-10 17:57:36.441077
3821	7	/api/clients	GET	304	2025-11-10 17:57:36.442076
3822	7	/api/orders	GET	304	2025-11-10 17:57:36.446448
3823	7	/api/products	GET	304	2025-11-10 17:57:36.449054
3824	7	/api/orders	GET	304	2025-11-10 17:57:36.451876
3825	7	/api/orders/2/status	PUT	200	2025-11-10 17:57:37.935534
3826	7	/api/orders	GET	200	2025-11-10 17:57:37.940495
3827	7	/api/orders/2/status	PUT	200	2025-11-10 17:57:40.775001
3828	7	/api/orders	GET	200	2025-11-10 17:57:40.780019
3829	7	/api/orders/2/status	PUT	200	2025-11-10 17:57:42.615315
3830	7	/api/orders	GET	200	2025-11-10 17:57:42.62713
3831	7	/api/clients	GET	304	2025-11-10 17:57:46.513421
3832	7	/api/clients	GET	304	2025-11-10 17:57:46.5479
3833	7	/api/products	GET	304	2025-11-10 17:57:48.538529
3834	7	/api/products	GET	304	2025-11-10 17:57:48.543174
3835	7	/api/clients	GET	304	2025-11-10 17:57:50.148273
3836	7	/api/products	GET	304	2025-11-10 17:57:50.150487
3837	7	/api/orders	GET	304	2025-11-10 17:57:50.189679
3838	7	/api/products	GET	304	2025-11-10 17:57:50.192322
3839	7	/api/orders	GET	304	2025-11-10 17:57:50.19387
3840	7	/api/clients	GET	304	2025-11-10 17:57:50.294382
3841	7	/api/users	GET	304	2025-11-10 17:57:53.100732
3842	7	/api/users	GET	304	2025-11-10 17:57:53.105859
3843	7	/api/products	GET	304	2025-11-10 17:58:41.789074
3844	7	/api/products	GET	304	2025-11-10 17:58:41.822571
3845	7	/api/products	GET	304	2025-11-10 17:58:42.376092
3846	7	/api/clients	GET	304	2025-11-10 17:58:42.376691
3847	7	/api/orders	GET	304	2025-11-10 17:58:42.410658
3848	7	/api/orders	GET	304	2025-11-10 17:58:42.414903
3849	7	/api/clients	GET	304	2025-11-10 17:58:42.437434
3850	7	/api/products	GET	304	2025-11-10 17:58:42.564526
3851	7	/api/products	GET	304	2025-11-10 18:02:45.871593
3852	7	/api/products	GET	304	2025-11-10 18:02:45.906044
3853	7	/api/products	GET	304	2025-11-10 18:02:50.464296
3854	7	/api/clients	GET	304	2025-11-10 18:02:50.465375
3855	7	/api/clients	GET	304	2025-11-10 18:02:50.511839
3856	7	/api/products	GET	304	2025-11-10 18:02:50.512447
3857	7	/api/orders	GET	304	2025-11-10 18:02:50.513947
3858	7	/api/orders	GET	304	2025-11-10 18:02:50.519303
3859	7	/api/orders/6/status	PUT	200	2025-11-10 18:02:54.358219
3860	7	/api/orders	GET	200	2025-11-10 18:02:54.363222
3861	7	/api/products	GET	200	2025-11-10 18:02:55.445574
3862	7	/api/products	GET	304	2025-11-10 18:02:55.450951
3863	7	/api/products	GET	304	2025-11-10 18:02:59.432991
3864	7	/api/clients	GET	304	2025-11-10 18:02:59.434105
3865	7	/api/orders	GET	304	2025-11-10 18:02:59.439125
3866	7	/api/products	GET	304	2025-11-10 18:02:59.439559
3867	7	/api/clients	GET	304	2025-11-10 18:02:59.441985
3868	7	/api/orders	GET	304	2025-11-10 18:02:59.476038
3869	7	/api/orders/6/status	PUT	200	2025-11-10 18:03:01.936783
3870	7	/api/orders	GET	200	2025-11-10 18:03:01.94169
3871	7	/api/products	GET	304	2025-11-10 18:03:02.965293
3872	7	/api/products	GET	304	2025-11-10 18:03:02.969963
3873	7	/api/clients	GET	304	2025-11-10 18:03:04.307186
3874	7	/api/products	GET	304	2025-11-10 18:03:04.307826
3875	7	/api/orders	GET	304	2025-11-10 18:03:04.312941
3876	7	/api/clients	GET	304	2025-11-10 18:03:04.313665
3877	7	/api/products	GET	304	2025-11-10 18:03:04.314745
3878	7	/api/orders	GET	304	2025-11-10 18:03:04.317664
3879	7	/api/orders/6/status	PUT	200	2025-11-10 18:03:09.502102
3880	7	/api/orders	GET	200	2025-11-10 18:03:09.509816
3881	7	/api/products	GET	304	2025-11-10 18:03:12.111145
3882	7	/api/products	GET	304	2025-11-10 18:03:12.115139
3883	7	/api/products	GET	304	2025-11-10 18:03:13.096583
3884	7	/api/orders	GET	304	2025-11-10 18:03:13.097918
3885	7	/api/clients	GET	304	2025-11-10 18:03:13.098481
3900	7	/api/products	GET	304	2025-11-10 18:03:21.429583
3906	7	/api/products	GET	304	2025-11-10 18:03:24.546687
3907	7	/api/clients	GET	304	2025-11-10 18:03:25.985228
3922	7	/api/clients	GET	304	2025-11-10 18:03:32.614735
4122	7	/api/clients	GET	304	2025-11-10 18:24:02.027992
4230	7	/api/orders	GET	304	2025-11-10 18:31:10.70641
4388	7	/api/products	GET	304	2025-11-10 18:39:10.046139
4391	7	/api/orders	GET	304	2025-11-10 18:39:10.056456
4392	7	/api/orders/21/status	PUT	200	2025-11-10 18:39:12.281017
4393	7	/api/orders	GET	200	2025-11-10 18:39:12.285974
4394	7	/api/products	GET	304	2025-11-10 18:39:18.910751
4397	7	/api/clients	GET	304	2025-11-10 18:39:20.937319
4513	7	/api/orders	GET	304	2025-11-10 18:44:01.728786
4514	7	/api/orders/23/status	PUT	200	2025-11-10 18:44:04.90856
4515	7	/api/orders	GET	200	2025-11-10 18:44:04.91479
4516	7	/api/products	GET	200	2025-11-10 18:44:06.88225
4519	7	/api/orders	GET	304	2025-11-10 18:44:08.199089
4531	7	/api/clients	GET	304	2025-11-10 18:44:15.462349
4643	7	/api/auth/me	GET	200	2025-11-11 16:26:33.183998
4712	7	/api/clients	GET	304	2025-11-11 16:43:42.616895
4762	7	/api/orders	GET	200	2025-11-11 17:09:47.690472
4838	7	/api/auth/me	GET	304	2026-03-12 17:05:25.747571
4839	7	/api/auth/me	GET	304	2026-03-12 17:05:35.469607
4842	7	/api/auth/me	GET	304	2026-03-12 17:05:38.479824
4843	7	/api/auth/me	GET	304	2026-03-12 17:05:39.537718
4846	7	/api/auth/me	GET	304	2026-03-12 17:05:40.108277
4847	7	/api/auth/me	GET	304	2026-03-12 17:05:40.355006
4850	7	/api/auth/me	GET	304	2026-03-12 17:05:40.548155
4851	7	/api/auth/me	GET	304	2026-03-12 17:05:40.691503
4854	7	/api/auth/me	GET	304	2026-03-12 17:05:40.851546
4855	7	/api/auth/me	GET	304	2026-03-12 17:05:40.971258
4858	7	/api/auth/me	GET	304	2026-03-12 17:05:41.36125
4859	7	/api/auth/me	GET	304	2026-03-12 17:05:41.560539
4862	7	/api/auth/me	GET	304	2026-03-12 17:05:41.756349
4863	7	/api/auth/me	GET	304	2026-03-12 17:05:42.01169
4866	7	/api/auth/me	GET	304	2026-03-12 17:05:42.211051
4867	7	/api/auth/me	GET	304	2026-03-12 17:05:42.368923
4955	7	/api/auth/me	GET	304	2026-03-12 17:40:12.053704
4958	7	/api/auth/me	GET	304	2026-03-12 17:40:21.681108
5022	7	/api/clients	GET	304	2026-03-12 18:58:48.529599
5023	7	/api/products	GET	304	2026-03-12 18:58:49.216881
5026	7	/api/products	GET	304	2026-03-12 18:58:49.9338
5035	7	/api/clients	GET	304	2026-03-12 18:58:51.94844
5040	7	/api/users	GET	304	2026-03-12 18:58:53.35508
5041	7	/api/clients	GET	304	2026-03-12 18:58:55.175158
5053	7	/api/products	GET	304	2026-03-12 18:58:56.681465
5126	7	/api/clients	GET	304	2026-03-12 20:57:10.713369
5129	7	/api/products	GET	304	2026-03-12 20:57:13.616666
5190	7	/api/orders	POST	201	2026-03-12 21:01:24.244453
5191	7	/api/orders	GET	200	2026-03-12 21:01:24.250039
5294	7	/api/clients	GET	304	2026-03-12 21:23:14.14601
5297	7	/api/products	GET	304	2026-03-12 21:23:14.785389
5298	7	/api/clients	GET	304	2026-03-12 21:23:15.334174
5428	7	/api/products	GET	304	2026-03-12 21:37:29.613078
5429	7	/api/users	GET	304	2026-03-12 21:37:30.46573
5432	7	/api/clients	GET	304	2026-03-12 21:37:33.371001
5521	7	/api/clients	GET	304	2026-03-13 13:54:32.401838
5524	7	/api/products	GET	304	2026-03-13 13:54:33.208136
5525	7	/api/clients	GET	304	2026-03-13 13:54:33.873658
5607	7	/api/auth/me	GET	200	2026-03-13 14:09:24.74751
5650	7	/api/orders	GET	200	2026-03-13 14:24:42.173938
5738	7	/api/orders	GET	200	2026-03-13 14:35:15.169753
5739	7	/api/products	GET	200	2026-03-13 14:35:16.578246
5742	7	/api/clients	GET	200	2026-03-13 14:35:17.501754
5743	7	/api/users	GET	200	2026-03-13 14:35:21.051546
5746	7	/api/clients	GET	200	2026-03-13 14:35:21.46113
5852	7	/api/auth/me	GET	200	2026-03-17 21:02:03.757709
5855	7	/api/summary	GET	200	2026-03-17 21:02:03.794164
5946	7	/api/summary	GET	200	2026-03-17 21:39:08.343982
6038	7	/api/clients	GET	200	2026-03-17 21:56:25.771
6039	7	/api/products	GET	200	2026-03-17 21:56:26.352058
6042	7	/api/users	GET	200	2026-03-17 21:56:26.837021
6043	7	/api/clients	GET	200	2026-03-17 21:56:27.909953
6060	7	/api/products	GET	200	2026-03-17 21:56:35.282082
6062	7	/api/orders	GET	200	2026-03-17 21:56:35.288918
6063	7	/api/users	GET	200	2026-03-17 21:56:35.961517
6066	7	/api/auth/me	GET	200	2026-03-17 21:56:37.22847
6067	7	/api/users	GET	200	2026-03-17 21:56:37.276804
6137	7	/api/suppliers	POST	500	2026-03-18 15:55:33.116572
6138	7	/api/auth/me	GET	200	2026-03-18 15:55:36.673432
6141	7	/api/suppliers	GET	200	2026-03-18 15:55:36.723121
6205	7	/api/clients	GET	200	2026-03-18 16:14:26.685497
6208	7	/api/auth/me	GET	200	2026-03-18 16:14:30.882528
6209	7	/api/clients	GET	200	2026-03-18 16:14:30.917875
6271	7	/api/products	GET	200	2026-03-18 16:20:34.518188
6350	7	/api/clients	GET	200	2026-03-18 16:24:17.217301
6415	\N	/api/clients	GET	401	2026-03-18 16:56:44.000901
6419	7	/api/summary	GET	200	2026-03-18 16:56:52.225455
6420	7	/api/clients	GET	200	2026-03-18 16:56:54.769822
6423	7	/api/summary	GET	200	2026-03-18 16:56:56.229074
6424	7	/api/clients	GET	200	2026-03-18 16:56:56.971021
6427	7	/api/products	GET	200	2026-03-18 16:56:58.248685
6428	7	/api/clients	GET	200	2026-03-18 16:56:58.956167
6430	7	/api/products	GET	200	2026-03-18 16:56:58.961206
6432	7	/api/orders	GET	200	2026-03-18 16:56:58.99717
6435	7	/api/users	GET	200	2026-03-18 16:56:59.393837
6436	7	/api/suppliers	GET	200	2026-03-18 16:56:59.840085
6514	7	/api/orders	GET	200	2026-03-18 17:30:49.138447
6515	7	/api/orders	POST	201	2026-03-18 17:30:58.182782
6516	7	/api/orders	GET	200	2026-03-18 17:30:58.187362
6517	7	/api/financial?	GET	200	2026-03-18 17:30:59.563105
6519	7	/api/financial/categories	GET	200	2026-03-18 17:30:59.598936
6522	7	/api/summary	GET	200	2026-03-18 17:31:04.609267
6589	7	/api/financial?	GET	200	2026-03-18 17:48:20.536548
6591	7	/api/financial/categories	GET	200	2026-03-18 17:48:20.577799
6676	7	/api/summary	GET	200	2026-03-18 18:07:16.33537
6679	7	/api/clients	GET	200	2026-03-18 18:07:17.012594
6680	7	/api/summary	GET	200	2026-03-18 18:07:18.105116
6745	7	/api/suppliers	GET	200	2026-03-18 21:16:24.248958
6747	7	/api/products	GET	200	2026-03-18 21:16:24.257085
6802	7	/api/summary	GET	200	2026-03-18 21:34:59.985807
6803	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:34:59.993324
6888	7	/api/financial/categories	GET	200	2026-03-18 21:40:38.264236
6893	7	/api/products	GET	200	2026-03-18 21:40:40.80675
6991	7	/api/purchase-orders	GET	200	2026-03-18 21:47:42.060616
6993	7	/api/suppliers	GET	200	2026-03-18 21:47:42.108498
6996	7	/api/products	GET	200	2026-03-18 21:47:42.11577
3886	7	/api/products	GET	304	2025-11-10 18:03:13.105544
3899	7	/api/orders	GET	304	2025-11-10 18:03:21.422759
3910	7	/api/clients	GET	304	2025-11-10 18:03:25.993664
3919	7	/api/clients	GET	304	2025-11-10 18:03:32.606656
4123	7	/api/products	GET	304	2025-11-10 18:24:02.030527
4232	7	/api/orders	POST	201	2025-11-10 18:31:31.826794
4233	7	/api/orders	GET	200	2025-11-10 18:31:31.832256
4234	7	/api/products	GET	304	2025-11-10 18:31:33.774927
4237	7	/api/orders	GET	304	2025-11-10 18:31:35.708752
4239	7	/api/clients	GET	304	2025-11-10 18:31:35.751252
4248	7	/api/clients	GET	304	2025-11-10 18:31:44.455187
4259	7	/api/products	GET	304	2025-11-10 18:31:51.20184
4262	7	/api/orders/20	DELETE	200	2025-11-10 18:31:58.0563
4263	7	/api/orders	GET	200	2025-11-10 18:31:58.061886
4264	7	/api/orders	POST	201	2025-11-10 18:32:06.436886
4265	7	/api/orders	GET	200	2025-11-10 18:32:06.441554
4266	7	/api/orders/21/status	PUT	200	2025-11-10 18:32:09.156988
4267	7	/api/orders	GET	200	2025-11-10 18:32:09.161354
4268	7	/api/products	GET	200	2025-11-10 18:32:12.041313
4271	7	/api/clients	GET	304	2025-11-10 18:32:13.200016
4273	7	/api/orders	GET	304	2025-11-10 18:32:13.242048
4276	7	/api/orders/21/status	PUT	200	2025-11-10 18:32:15.234029
4389	7	/api/orders	GET	304	2025-11-10 18:39:10.050618
4523	7	/api/clients	GET	304	2025-11-10 18:44:08.239962
4524	7	/api/orders/23/status	PUT	200	2025-11-10 18:44:09.685047
4525	7	/api/orders	GET	200	2025-11-10 18:44:09.69603
4526	7	/api/products	GET	304	2025-11-10 18:44:11.18801
4529	7	/api/products	GET	304	2025-11-10 18:44:15.457355
4644	7	/api/auth/me	GET	200	2025-11-11 16:26:33.21861
4713	7	/api/products	GET	304	2025-11-11 16:43:42.641237
4715	7	/api/orders	GET	304	2025-11-11 16:43:42.648189
4716	7	/api/orders	POST	201	2025-11-11 16:43:49.54566
4717	7	/api/orders	GET	200	2025-11-11 16:43:49.550589
4718	7	/api/auth/me	GET	304	2025-11-11 16:43:53.222055
4763	7	/api/orders	POST	500	2025-11-11 17:10:02.861263
4869	7	/api/auth/me	GET	304	2026-03-12 17:14:20.126425
4872	7	/api/clients	GET	304	2026-03-12 17:14:22.554068
4873	7	/api/products	GET	304	2026-03-12 17:14:24.641247
4876	7	/api/products	GET	304	2026-03-12 17:14:25.973971
4878	7	/api/orders	GET	304	2026-03-12 17:14:26.016823
4956	7	/api/auth/me	GET	304	2026-03-12 17:40:12.146301
4957	7	/api/auth/me	GET	304	2026-03-12 17:40:21.678942
5027	7	/api/clients	GET	304	2026-03-12 18:58:49.977943
5036	7	/api/orders	GET	304	2026-03-12 18:58:51.949048
5043	7	/api/orders	GET	304	2026-03-12 18:58:55.176759
5052	7	/api/clients	GET	304	2026-03-12 18:58:56.680982
5127	7	/api/products	GET	304	2026-03-12 20:57:10.746062
5128	7	/api/clients	GET	304	2026-03-12 20:57:13.614616
5192	7	/api/auth/me	GET	304	2026-03-12 21:05:08.950189
5295	7	/api/clients	GET	304	2026-03-12 21:23:14.188621
5296	7	/api/products	GET	304	2026-03-12 21:23:14.778907
5299	7	/api/products	GET	304	2026-03-12 21:23:15.335397
5313	7	/api/clients	GET	304	2026-03-12 21:23:25.176322
5322	7	/api/orders	GET	304	2026-03-12 21:23:27.761768
5433	7	/api/auth/me	GET	304	2026-03-12 21:44:26.980524
5436	7	/api/auth/me	GET	304	2026-03-12 21:44:27.383105
5437	7	/api/clients	GET	304	2026-03-12 21:44:28.752762
5440	7	/api/products	GET	304	2026-03-12 21:44:29.226209
5441	7	/api/clients	GET	304	2026-03-12 21:44:29.745594
5522	7	/api/clients	GET	304	2026-03-13 13:54:32.434419
5523	7	/api/products	GET	304	2026-03-13 13:54:33.201287
5526	7	/api/products	GET	304	2026-03-13 13:54:33.875772
5608	7	/api/auth/me	GET	200	2026-03-13 14:09:24.843239
5652	7	/api/products	GET	200	2026-03-13 14:24:42.181538
5751	\N	/api/auth/me	GET	401	2026-03-16 17:12:53.788435
5755	7	/api/clients	GET	200	2026-03-16 17:13:06.846268
5756	7	/api/products	GET	200	2026-03-16 17:13:08.168523
5759	7	/api/products	GET	200	2026-03-16 17:13:09.34124
5761	7	/api/orders	GET	200	2026-03-16 17:13:09.358144
5853	7	/api/auth/me	GET	200	2026-03-17 21:02:03.757868
5854	7	/api/summary	GET	200	2026-03-17 21:02:03.786912
5947	7	/api/summary	GET	200	2026-03-17 21:39:08.379259
6045	7	/api/clients	GET	200	2026-03-17 21:56:27.954152
6059	7	/api/clients	GET	200	2026-03-17 21:56:35.280768
6139	7	/api/auth/me	GET	200	2026-03-18 15:55:36.706006
6140	7	/api/suppliers	GET	200	2026-03-18 15:55:36.722462
6206	7	/api/clients	GET	200	2026-03-18 16:14:26.733318
6207	7	/api/auth/me	GET	200	2026-03-18 16:14:30.880506
6210	7	/api/clients	GET	200	2026-03-18 16:14:30.920277
6272	7	/api/clients	GET	200	2026-03-18 16:20:34.629974
6351	7	/api/orders	POST	201	2026-03-18 16:24:37.945253
6352	7	/api/orders	GET	200	2026-03-18 16:24:37.950596
6416	\N	/api/clients	GET	401	2026-03-18 16:56:44.001091
6417	\N	/api/auth/login	POST	200	2026-03-18 16:56:52.140043
6418	7	/api/summary	GET	200	2026-03-18 16:56:52.212568
6421	7	/api/clients	GET	200	2026-03-18 16:56:54.771715
6422	7	/api/summary	GET	200	2026-03-18 16:56:56.224056
6425	7	/api/clients	GET	200	2026-03-18 16:56:56.973783
6426	7	/api/products	GET	200	2026-03-18 16:56:58.246695
6429	7	/api/products	GET	200	2026-03-18 16:56:58.956731
6518	7	/api/financial/categories	GET	200	2026-03-18 17:30:59.596826
6590	7	/api/financial/categories	GET	200	2026-03-18 17:48:20.574743
6677	7	/api/summary	GET	200	2026-03-18 18:07:16.375185
6678	7	/api/clients	GET	200	2026-03-18 18:07:17.010465
6681	7	/api/summary	GET	200	2026-03-18 18:07:18.109953
6746	7	/api/products	GET	200	2026-03-18 21:16:24.250839
6804	7	/api/summary	GET	200	2026-03-18 21:35:40.684535
6807	7	/api/suppliers	GET	200	2026-03-18 21:35:42.594866
6808	7	/api/suppliers	GET	200	2026-03-18 21:35:43.140533
6810	7	/api/purchase-orders	GET	200	2026-03-18 21:35:43.153638
6812	7	/api/products	GET	200	2026-03-18 21:35:43.184697
6815	7	/api/auth/me	GET	200	2026-03-18 21:35:44.788341
6818	7	/api/summary	GET	200	2026-03-18 21:35:44.819453
6819	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:35:44.82806
6821	7	/api/suppliers	GET	200	2026-03-18 21:35:44.848884
6825	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:35:44.857083
6830	7	/api/orders	GET	200	2026-03-18 21:35:49.681753
6838	7	/api/purchase-orders	GET	200	2026-03-18 21:35:57.621341
6842	7	/api/purchase-orders/1	DELETE	200	2026-03-18 21:36:01.132198
6843	7	/api/purchase-orders	GET	200	2026-03-18 21:36:01.136004
6890	7	/api/financial?	GET	200	2026-03-18 21:40:38.280032
6892	7	/api/purchase-orders	GET	200	2026-03-18 21:40:40.804182
6896	7	/api/products	GET	200	2026-03-18 21:40:40.814345
6992	7	/api/suppliers	GET	200	2026-03-18 21:47:42.103729
7002	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-18 21:47:45.166063
7073	7	/api/summary	GET	200	2026-03-18 21:51:27.764845
3887	7	/api/orders	GET	304	2025-11-10 18:03:13.106303
3888	7	/api/clients	GET	304	2025-11-10 18:03:13.137143
3889	7	/api/orders/6/status	PUT	200	2025-11-10 18:03:15.543192
3890	7	/api/orders	GET	200	2025-11-10 18:03:15.549906
3891	7	/api/products	GET	304	2025-11-10 18:03:17.35043
3894	7	/api/auth/me	GET	304	2025-11-10 18:03:19.570794
3895	7	/api/products	GET	304	2025-11-10 18:03:19.592595
3898	7	/api/clients	GET	304	2025-11-10 18:03:21.421896
3901	7	/api/clients	GET	304	2025-11-10 18:03:21.430307
3903	7	/api/orders/6/status	PUT	200	2025-11-10 18:03:23.394659
3904	7	/api/orders	GET	200	2025-11-10 18:03:23.399608
3905	7	/api/products	GET	304	2025-11-10 18:03:24.542809
3908	7	/api/products	GET	304	2025-11-10 18:03:25.986124
3909	7	/api/orders	GET	304	2025-11-10 18:03:25.986709
3913	7	/api/orders/7/status	PUT	200	2025-11-10 18:03:30.331052
3914	7	/api/orders	GET	200	2025-11-10 18:03:30.336602
3915	7	/api/products	GET	200	2025-11-10 18:03:31.12007
3918	7	/api/orders	GET	304	2025-11-10 18:03:32.606084
3920	7	/api/products	GET	304	2025-11-10 18:03:32.61357
4124	7	/api/orders	GET	304	2025-11-10 18:24:02.034486
4235	7	/api/products	GET	304	2025-11-10 18:31:33.780703
4236	7	/api/products	GET	304	2025-11-10 18:31:35.707836
4250	7	/api/orders	GET	304	2025-11-10 18:31:44.463717
4260	7	/api/clients	GET	304	2025-11-10 18:31:51.202332
4398	7	/api/clients	GET	304	2025-11-10 18:39:20.982341
4537	7	/api/products	GET	304	2025-11-10 18:44:27.135069
4538	7	/api/auth/me	GET	304	2025-11-10 18:44:32.310842
4541	7	/api/products	GET	304	2025-11-10 18:44:32.340068
4542	7	/api/products	GET	304	2025-11-10 18:44:33.226613
4645	7	/api/products	GET	304	2025-11-11 16:26:44.502047
4648	7	/api/clients	GET	304	2025-11-11 16:26:45.694753
4650	7	/api/orders	GET	304	2025-11-11 16:26:45.738459
4714	7	/api/orders	GET	304	2025-11-11 16:43:42.643547
4719	7	/api/auth/me	GET	304	2025-11-11 16:43:53.224323
4764	7	/api/auth/me	GET	200	2025-11-11 17:15:03.845683
4765	7	/api/clients	GET	200	2025-11-11 17:15:03.890025
4870	7	/api/auth/me	GET	304	2026-03-12 17:14:20.223951
4871	7	/api/clients	GET	304	2026-03-12 17:14:22.551705
4874	7	/api/products	GET	304	2026-03-12 17:14:24.646976
4875	7	/api/clients	GET	304	2026-03-12 17:14:25.97338
4959	7	/api/auth/me	GET	304	2026-03-12 17:47:59.481919
4962	7	/api/auth/me	GET	304	2026-03-12 17:47:59.792839
5028	7	/api/products	GET	304	2026-03-12 18:58:49.979568
5030	7	/api/orders	GET	304	2026-03-12 18:58:49.989291
5031	7	/api/users	GET	304	2026-03-12 18:58:51.099346
5034	7	/api/products	GET	304	2026-03-12 18:58:51.943224
5044	7	/api/clients	GET	304	2026-03-12 18:58:55.183513
5051	7	/api/orders	GET	304	2026-03-12 18:58:56.67275
5130	7	/api/products	GET	304	2026-03-12 20:57:36.372985
5133	7	/api/clients	GET	304	2026-03-12 20:57:36.929665
5134	7	/api/users	GET	304	2026-03-12 20:57:38.111287
5137	7	/api/products	GET	304	2026-03-12 20:57:38.615553
5193	7	/api/auth/me	GET	304	2026-03-12 21:05:08.950243
5199	7	/api/orders	GET	304	2026-03-12 21:05:09.113433
5300	7	/api/clients	GET	304	2026-03-12 21:23:15.384457
5302	7	/api/orders	GET	304	2026-03-12 21:23:15.395163
5305	7	/api/users	GET	304	2026-03-12 21:23:16.088955
5306	7	/api/auth/me	GET	200	2026-03-12 21:23:22.184108
5309	7	/api/users	GET	304	2026-03-12 21:23:22.234279
5310	7	/api/clients	GET	304	2026-03-12 21:23:25.167288
5314	7	/api/products	GET	304	2026-03-12 21:23:25.176848
5317	7	/api/products	GET	304	2026-03-12 21:23:25.834479
5318	7	/api/clients	GET	304	2026-03-12 21:23:26.1928
5321	7	/api/products	GET	304	2026-03-12 21:23:27.755502
5434	7	/api/auth/me	GET	304	2026-03-12 21:44:26.98339
5435	7	/api/auth/me	GET	304	2026-03-12 21:44:27.378677
5438	7	/api/clients	GET	304	2026-03-12 21:44:28.755348
5439	7	/api/products	GET	304	2026-03-12 21:44:29.219702
5442	7	/api/products	GET	304	2026-03-12 21:44:29.746534
5527	7	/api/clients	GET	304	2026-03-13 13:54:33.926952
5609	7	/api/auth/me	GET	200	2026-03-13 14:12:36.72051
5653	7	/api/auth/me	GET	200	2026-03-13 14:26:09.166344
5752	\N	/api/auth/me	GET	401	2026-03-16 17:12:53.836482
5753	\N	/api/auth/login	POST	200	2026-03-16 17:13:02.648786
5754	7	/api/clients	GET	200	2026-03-16 17:13:06.842848
5757	7	/api/products	GET	200	2026-03-16 17:13:08.1732
5758	7	/api/clients	GET	200	2026-03-16 17:13:09.340611
5760	7	/api/products	GET	200	2026-03-16 17:13:09.347721
5762	7	/api/orders	GET	200	2026-03-16 17:13:09.361319
5765	7	/api/users	GET	200	2026-03-16 17:13:10.909572
5856	7	/api/auth/me	GET	200	2026-03-17 21:02:15.535308
5859	7	/api/summary	GET	200	2026-03-17 21:02:15.562011
5948	7	/api/clients	GET	200	2026-03-17 21:39:25.012469
5951	7	/api/products	GET	200	2026-03-17 21:39:27.990777
5952	7	/api/products	GET	200	2026-03-17 21:39:31.941688
6046	7	/api/products	GET	200	2026-03-17 21:56:27.957655
6048	7	/api/orders	GET	200	2026-03-17 21:56:27.966546
6049	7	/api/products	GET	200	2026-03-17 21:56:28.489504
6052	7	/api/summary	GET	200	2026-03-17 21:56:32.249903
6053	7	/api/clients	GET	200	2026-03-17 21:56:33.677619
6056	7	/api/products	GET	200	2026-03-17 21:56:34.43734
6057	7	/api/clients	GET	200	2026-03-17 21:56:35.274059
6142	7	/api/suppliers	POST	500	2026-03-18 15:56:23.85761
6211	7	/api/clients/8	DELETE	200	2026-03-18 16:14:46.74526
6212	7	/api/clients	GET	200	2026-03-18 16:14:46.751355
6273	7	/api/orders	POST	201	2026-03-18 16:20:59.827414
6274	7	/api/orders	GET	200	2026-03-18 16:20:59.832282
6275	7	/api/products	GET	200	2026-03-18 16:21:02.281238
6353	7	/api/orders	POST	201	2026-03-18 16:24:48.704676
6354	7	/api/orders	GET	200	2026-03-18 16:24:48.709851
6355	7	/api/summary	GET	200	2026-03-18 16:24:50.080052
6431	7	/api/orders	GET	200	2026-03-18 16:56:58.994047
6520	7	/api/financial?	GET	200	2026-03-18 17:30:59.705606
6521	7	/api/summary	GET	200	2026-03-18 17:31:04.60388
6592	7	/api/financial?	GET	200	2026-03-18 17:48:20.68322
6593	7	/api/financial?type=receita	GET	200	2026-03-18 17:48:24.751591
6594	7	/api/financial?	GET	200	2026-03-18 17:48:26.375766
6595	7	/api/financial?type=receita	GET	200	2026-03-18 17:48:27.74345
6596	7	/api/financial?	GET	200	2026-03-18 17:48:30.91556
6597	7	/api/financial?type=despesa	GET	200	2026-03-18 17:48:32.863335
6598	7	/api/financial?	GET	200	2026-03-18 17:48:34.746123
6599	7	/api/summary	GET	200	2026-03-18 17:48:44.498686
6682	7	/api/financial/categories	GET	200	2026-03-18 18:08:24.405252
6748	7	/api/purchase-orders	GET	500	2026-03-18 21:16:24.300123
6749	7	/api/purchase-orders	GET	500	2026-03-18 21:16:24.303059
6805	7	/api/summary	GET	200	2026-03-18 21:35:40.725852
6806	7	/api/suppliers	GET	200	2026-03-18 21:35:42.5919
6809	7	/api/purchase-orders	GET	200	2026-03-18 21:35:43.147407
3892	7	/api/products	GET	304	2025-11-10 18:03:17.354636
3893	7	/api/auth/me	GET	304	2025-11-10 18:03:19.568562
3896	7	/api/products	GET	304	2025-11-10 18:03:19.59608
3897	7	/api/products	GET	304	2025-11-10 18:03:21.421311
3912	7	/api/orders	GET	304	2025-11-10 18:03:25.994934
3921	7	/api/orders	GET	304	2025-11-10 18:03:32.614187
4125	7	/api/clients	GET	304	2025-11-10 18:24:02.06703
4238	7	/api/clients	GET	304	2025-11-10 18:31:35.748362
4249	7	/api/products	GET	304	2025-11-10 18:31:44.462347
4258	7	/api/orders	GET	304	2025-11-10 18:31:51.201291
4399	7	/api/products	GET	304	2025-11-10 18:39:20.982791
4401	7	/api/orders	GET	304	2025-11-10 18:39:20.989915
4402	7	/api/orders/21/status	PUT	200	2025-11-10 18:39:23.446583
4403	7	/api/orders	GET	200	2025-11-10 18:39:23.451172
4404	7	/api/products	GET	200	2025-11-10 18:39:27.632233
4544	7	/api/orders	GET	304	2025-11-10 18:44:33.264399
4646	7	/api/products	GET	304	2025-11-11 16:26:44.53783
4647	7	/api/products	GET	304	2025-11-11 16:26:45.693796
4721	7	/api/auth/me	GET	304	2025-11-11 16:47:42.886464
4766	7	/api/auth/me	GET	200	2025-11-11 17:15:03.897714
4877	7	/api/orders	GET	304	2026-03-12 17:14:26.01367
4960	7	/api/auth/me	GET	304	2026-03-12 17:47:59.593931
4961	7	/api/auth/me	GET	304	2026-03-12 17:47:59.789773
5029	7	/api/orders	GET	304	2026-03-12 18:58:49.983013
5032	7	/api/users	GET	304	2026-03-12 18:58:51.104933
5033	7	/api/clients	GET	304	2026-03-12 18:58:51.942495
5131	7	/api/products	GET	304	2026-03-12 20:57:36.505892
5132	7	/api/clients	GET	304	2026-03-12 20:57:36.925934
5135	7	/api/users	GET	304	2026-03-12 20:57:38.116569
5136	7	/api/clients	GET	304	2026-03-12 20:57:38.615046
5194	7	/api/products	GET	304	2026-03-12 21:05:08.967604
5301	7	/api/orders	GET	304	2026-03-12 21:23:15.38819
5312	7	/api/orders	GET	304	2026-03-12 21:23:25.169323
5323	7	/api/clients	GET	304	2026-03-12 21:23:27.762226
5443	7	/api/clients	GET	304	2026-03-12 21:44:29.790749
5528	7	/api/products	GET	304	2026-03-13 13:54:33.927453
5530	7	/api/orders	GET	304	2026-03-13 13:54:33.934476
5531	7	/api/users	GET	304	2026-03-13 13:54:34.981096
5610	7	/api/auth/me	GET	200	2026-03-13 14:12:36.761895
5654	7	/api/auth/me	GET	200	2026-03-13 14:26:09.180966
5763	7	/api/clients	GET	200	2026-03-16 17:13:09.376388
5764	7	/api/users	GET	200	2026-03-16 17:13:10.905353
5857	7	/api/auth/me	GET	200	2026-03-17 21:02:15.535755
5858	7	/api/summary	GET	200	2026-03-17 21:02:15.5556
5949	7	/api/clients	GET	200	2026-03-17 21:39:25.047265
5950	7	/api/products	GET	200	2026-03-17 21:39:27.986804
5953	7	/api/clients	GET	200	2026-03-17 21:39:31.944762
6047	7	/api/orders	GET	200	2026-03-17 21:56:27.959789
6050	7	/api/products	GET	200	2026-03-17 21:56:28.492777
6051	7	/api/summary	GET	200	2026-03-17 21:56:32.245884
6054	7	/api/clients	GET	200	2026-03-17 21:56:33.679876
6055	7	/api/products	GET	200	2026-03-17 21:56:34.435127
6058	7	/api/products	GET	200	2026-03-17 21:56:35.275538
6143	7	/api/suppliers	POST	201	2026-03-18 15:57:18.256654
6144	7	/api/suppliers	GET	200	2026-03-18 15:57:18.260993
6213	7	/api/auth/me	GET	200	2026-03-18 16:15:22.248791
6276	7	/api/products	GET	200	2026-03-18 16:21:02.312766
6356	7	/api/summary	GET	200	2026-03-18 16:24:50.115523
6433	7	/api/clients	GET	200	2026-03-18 16:56:59.10075
6434	7	/api/users	GET	200	2026-03-18 16:56:59.389996
6437	7	/api/suppliers	GET	200	2026-03-18 16:56:59.843451
6523	7	/api/financial?	GET	200	2026-03-18 17:31:18.759423
6600	7	/api/summary	GET	200	2026-03-18 17:48:44.540188
6683	7	/api/financial?	GET	200	2026-03-18 18:08:24.409458
6750	7	/api/suppliers	GET	200	2026-03-18 21:16:24.304033
6811	7	/api/products	GET	200	2026-03-18 21:35:43.182153
6817	7	/api/financial?status=vencido	GET	200	2026-03-18 21:35:44.818488
6822	7	/api/products	GET	200	2026-03-18 21:35:44.851037
6833	7	/api/orders	GET	200	2026-03-18 21:35:49.688705
6834	7	/api/products	GET	200	2026-03-18 21:35:52.328232
6837	7	/api/suppliers	GET	200	2026-03-18 21:35:57.61621
6894	7	/api/suppliers	GET	200	2026-03-18 21:40:40.809928
6994	7	/api/products	GET	200	2026-03-18 21:47:42.110593
7000	7	/api/clients	GET	200	2026-03-18 21:47:45.159205
7004	7	/api/orders?	GET	200	2026-03-18 21:47:45.17308
7012	7	/api/financial?	GET	200	2026-03-18 21:47:45.750208
7015	7	/api/products	GET	200	2026-03-18 21:47:46.912947
7075	7	/api/auth/me	GET	200	2026-03-18 21:51:41.892223
7076	7	/api/purchase-orders	GET	200	2026-03-18 21:51:41.926433
7078	7	/api/financial?status=vencido	GET	200	2026-03-18 21:51:41.95301
7081	7	/api/summary	GET	200	2026-03-18 21:51:41.9669
7083	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:51:41.973442
7086	7	/api/products	GET	200	2026-03-18 21:51:41.980077
7130	7	/api/financial/categories	GET	200	2026-03-19 15:43:00.88935
7230	7	/api/suppliers	GET	200	2026-03-19 16:05:55.139155
7273	7	/api/summary	GET	200	2026-03-19 16:11:41.685902
7274	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:11:41.693565
7334	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:17:09.747921
7335	7	/api/financial?	GET	200	2026-03-19 16:17:10.243537
7337	7	/api/financial/categories	GET	200	2026-03-19 16:17:10.247957
7340	7	/api/suppliers	GET	200	2026-03-19 16:17:10.645474
7341	7	/api/suppliers	GET	200	2026-03-19 16:17:10.995042
7345	7	/api/products	GET	200	2026-03-19 16:17:11.000789
7348	7	/api/summary	GET	200	2026-03-19 16:17:11.561256
7349	7	/api/clients	GET	200	2026-03-19 16:17:13.275766
7352	7	/api/products	GET	200	2026-03-19 16:17:13.97214
7353	7	/api/clients	GET	200	2026-03-19 16:17:15.492229
7365	7	/api/orders?	GET	200	2026-03-19 16:17:19.299695
7381	7	/api/products	GET	200	2026-03-19 16:17:21.486273
7393	7	/api/auth/me	GET	200	2026-03-19 16:21:22.103716
7397	7	/api/clients	GET	200	2026-03-19 16:21:23.112785
7398	7	/api/products	GET	200	2026-03-19 16:21:23.90204
7401	7	/api/products	GET	200	2026-03-19 16:21:24.333069
7412	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:21:25.172186
7429	7	/api/purchase-orders	GET	200	2026-03-19 16:21:26.278133
7444	7	/api/summary	GET	200	2026-03-19 16:21:41.99598
7452	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:44.004099
7477	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:47.599178
7478	7	/api/clients	GET	200	2026-03-19 16:21:48.514463
7482	7	/api/products	GET	200	2026-03-19 16:21:48.520897
7485	7	/api/auth/me	GET	200	2026-03-19 16:21:49.45428
7488	7	/api/summary	GET	200	2026-03-19 16:21:49.481537
7491	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:49.49185
7492	7	/api/clients	GET	200	2026-03-19 16:21:49.506361
3902	7	/api/orders	GET	304	2025-11-10 18:03:21.432047
3911	7	/api/products	GET	304	2025-11-10 18:03:25.994191
3916	7	/api/products	GET	304	2025-11-10 18:03:31.123752
3917	7	/api/products	GET	304	2025-11-10 18:03:32.605155
3923	7	/api/auth/me	GET	200	2025-11-10 18:05:17.632194
3924	7	/api/clients	GET	304	2025-11-10 18:05:17.66052
3925	7	/api/auth/me	GET	200	2025-11-10 18:05:17.670902
3926	7	/api/products	GET	304	2025-11-10 18:05:17.699316
3927	7	/api/clients	GET	304	2025-11-10 18:05:17.703344
3928	7	/api/orders	GET	304	2025-11-10 18:05:17.704669
3929	7	/api/products	GET	304	2025-11-10 18:05:17.705952
3930	7	/api/orders	GET	304	2025-11-10 18:05:17.710995
3931	7	/api/products	GET	304	2025-11-10 18:05:20.458279
3932	7	/api/products	GET	304	2025-11-10 18:05:20.462111
3933	7	/api/clients	GET	304	2025-11-10 18:05:23.668082
3934	7	/api/products	GET	304	2025-11-10 18:05:23.668765
3935	7	/api/orders	GET	304	2025-11-10 18:05:23.669398
3936	7	/api/clients	GET	304	2025-11-10 18:05:23.675926
3937	7	/api/products	GET	304	2025-11-10 18:05:23.677741
3938	7	/api/orders	GET	304	2025-11-10 18:05:23.71006
3939	7	/api/orders/6/status	PUT	200	2025-11-10 18:05:28.552117
3940	7	/api/orders	GET	200	2025-11-10 18:05:28.557175
3941	7	/api/products	GET	304	2025-11-10 18:05:29.439447
3942	7	/api/products	GET	304	2025-11-10 18:05:29.444977
3943	7	/api/auth/me	GET	200	2025-11-10 18:05:31.289895
3944	7	/api/auth/me	GET	200	2025-11-10 18:05:31.293385
3945	7	/api/products	GET	304	2025-11-10 18:05:31.305421
3946	7	/api/products	GET	304	2025-11-10 18:05:31.308817
3947	7	/api/products	GET	304	2025-11-10 18:05:32.954117
3948	7	/api/clients	GET	304	2025-11-10 18:05:32.954638
3949	7	/api/orders	GET	304	2025-11-10 18:05:32.955309
3950	7	/api/products	GET	304	2025-11-10 18:05:32.962907
3951	7	/api/clients	GET	304	2025-11-10 18:05:32.963494
3952	7	/api/orders	GET	304	2025-11-10 18:05:32.964271
3953	7	/api/orders/6/status	PUT	200	2025-11-10 18:05:34.883271
3954	7	/api/orders	GET	200	2025-11-10 18:05:34.888057
3955	7	/api/products	GET	200	2025-11-10 18:05:35.96561
3956	7	/api/products	GET	304	2025-11-10 18:05:35.970151
3957	7	/api/clients	GET	304	2025-11-10 18:05:37.672239
3958	7	/api/products	GET	304	2025-11-10 18:05:37.672808
3959	7	/api/orders	GET	304	2025-11-10 18:05:37.67389
3960	7	/api/clients	GET	304	2025-11-10 18:05:37.680181
3961	7	/api/orders	GET	304	2025-11-10 18:05:37.714327
3962	7	/api/products	GET	304	2025-11-10 18:05:37.836706
3963	7	/api/orders/6/status	PUT	200	2025-11-10 18:05:43.174536
3964	7	/api/orders	GET	200	2025-11-10 18:05:43.181887
3965	7	/api/products	GET	200	2025-11-10 18:05:44.195372
3966	7	/api/products	GET	304	2025-11-10 18:05:44.200689
3967	7	/api/auth/me	GET	200	2025-11-10 18:08:40.636953
3968	7	/api/auth/me	GET	200	2025-11-10 18:08:40.641311
3969	7	/api/products	GET	304	2025-11-10 18:08:40.658548
3970	7	/api/products	GET	304	2025-11-10 18:08:40.692203
3971	7	/api/products	GET	304	2025-11-10 18:08:41.782924
3972	7	/api/clients	GET	304	2025-11-10 18:08:41.784823
3973	7	/api/clients	GET	304	2025-11-10 18:08:41.792085
3974	7	/api/orders	GET	200	2025-11-10 18:08:41.821395
3975	7	/api/products	GET	304	2025-11-10 18:08:41.824312
3976	7	/api/orders	GET	304	2025-11-10 18:08:41.825689
3977	7	/api/auth/me	GET	200	2025-11-10 18:08:44.325532
3978	7	/api/auth/me	GET	200	2025-11-10 18:08:44.328036
3979	7	/api/clients	GET	304	2025-11-10 18:08:44.34429
3980	7	/api/products	GET	304	2025-11-10 18:08:44.344727
3981	7	/api/orders	GET	304	2025-11-10 18:08:44.345391
3982	7	/api/clients	GET	304	2025-11-10 18:08:44.351994
3983	7	/api/products	GET	304	2025-11-10 18:08:44.352653
3984	7	/api/orders	GET	304	2025-11-10 18:08:44.353231
3985	7	/api/auth/me	GET	200	2025-11-10 18:08:45.035731
3986	7	/api/auth/me	GET	200	2025-11-10 18:08:45.039166
3987	7	/api/clients	GET	304	2025-11-10 18:08:45.055669
3988	7	/api/products	GET	304	2025-11-10 18:08:45.056284
3989	7	/api/orders	GET	304	2025-11-10 18:08:45.061442
3990	7	/api/clients	GET	304	2025-11-10 18:08:45.062106
3991	7	/api/products	GET	304	2025-11-10 18:08:45.062697
3992	7	/api/orders	GET	304	2025-11-10 18:08:45.06553
3993	7	/api/auth/me	GET	200	2025-11-10 18:08:54.851765
3994	7	/api/auth/me	GET	200	2025-11-10 18:08:54.854706
3995	7	/api/clients	GET	304	2025-11-10 18:08:54.874144
3996	7	/api/products	GET	304	2025-11-10 18:08:54.874988
3997	7	/api/orders	GET	304	2025-11-10 18:08:54.875957
3998	7	/api/clients	GET	304	2025-11-10 18:08:54.882318
3999	7	/api/products	GET	304	2025-11-10 18:08:54.883016
4000	7	/api/orders	GET	304	2025-11-10 18:08:54.883684
4001	7	/api/auth/me	GET	200	2025-11-10 18:09:56.493914
4002	7	/api/clients	GET	304	2025-11-10 18:09:56.51812
4003	7	/api/auth/me	GET	200	2025-11-10 18:09:56.529639
4004	7	/api/products	GET	304	2025-11-10 18:09:56.557361
4005	7	/api/clients	GET	304	2025-11-10 18:09:56.56163
4006	7	/api/orders	GET	200	2025-11-10 18:09:56.562869
4007	7	/api/products	GET	304	2025-11-10 18:09:56.563636
4008	7	/api/orders	GET	304	2025-11-10 18:09:56.568474
4009	7	/api/products	GET	304	2025-11-10 18:09:58.508813
4010	7	/api/products	GET	304	2025-11-10 18:09:58.514199
4011	7	/api/clients	GET	304	2025-11-10 18:09:59.71313
4012	7	/api/products	GET	304	2025-11-10 18:09:59.713952
4013	7	/api/orders	GET	304	2025-11-10 18:09:59.719306
4014	7	/api/clients	GET	304	2025-11-10 18:09:59.720152
4015	7	/api/products	GET	304	2025-11-10 18:09:59.72253
4016	7	/api/orders	GET	304	2025-11-10 18:09:59.754665
4017	7	/api/orders/7/status	PUT	200	2025-11-10 18:10:02.831813
4018	7	/api/orders	GET	200	2025-11-10 18:10:02.837947
4019	7	/api/products	GET	200	2025-11-10 18:10:03.85788
4020	7	/api/products	GET	304	2025-11-10 18:10:03.862013
4021	7	/api/products	GET	304	2025-11-10 18:10:05.680315
4022	7	/api/clients	GET	304	2025-11-10 18:10:05.68298
4023	7	/api/orders	GET	304	2025-11-10 18:10:05.688294
4024	7	/api/products	GET	304	2025-11-10 18:10:05.689089
4025	7	/api/clients	GET	304	2025-11-10 18:10:05.689917
4026	7	/api/orders	GET	304	2025-11-10 18:10:05.692732
4027	7	/api/orders/16/status	PUT	200	2025-11-10 18:10:07.671051
4028	7	/api/orders	GET	200	2025-11-10 18:10:07.676102
4029	7	/api/products	GET	304	2025-11-10 18:10:08.477936
4030	7	/api/products	GET	304	2025-11-10 18:10:08.483232
4031	7	/api/clients	GET	304	2025-11-10 18:10:09.860701
4032	7	/api/clients	GET	304	2025-11-10 18:10:09.868417
4033	7	/api/products	GET	304	2025-11-10 18:10:09.869133
4034	7	/api/orders	GET	304	2025-11-10 18:10:09.869948
4035	7	/api/products	GET	304	2025-11-10 18:10:09.874859
4036	7	/api/orders	GET	304	2025-11-10 18:10:09.876939
4037	7	/api/orders/16/status	PUT	200	2025-11-10 18:10:11.763459
4038	7	/api/orders	GET	200	2025-11-10 18:10:11.771246
4039	7	/api/products	GET	304	2025-11-10 18:10:12.575633
4042	7	/api/orders	GET	304	2025-11-10 18:10:13.452224
4053	7	/api/clients	GET	304	2025-11-10 18:10:18.761793
4126	7	/api/products	GET	304	2025-11-10 18:24:02.073332
4240	7	/api/products	GET	304	2025-11-10 18:31:35.756328
4245	7	/api/products	GET	304	2025-11-10 18:31:41.986421
4246	7	/api/products	GET	304	2025-11-10 18:31:44.453831
4261	7	/api/orders	GET	304	2025-11-10 18:31:51.207924
4400	7	/api/orders	GET	304	2025-11-10 18:39:20.984673
4405	7	/api/products	GET	304	2025-11-10 18:39:27.637386
4546	7	/api/clients	GET	304	2025-11-10 18:44:33.269031
4549	7	/api/products	GET	304	2025-11-10 18:44:35.689984
4550	7	/api/products/3	PUT	200	2025-11-10 18:44:41.001036
4551	7	/api/products	GET	200	2025-11-10 18:44:41.007436
4552	7	/api/products	GET	304	2025-11-10 18:44:44.575764
4554	7	/api/clients	GET	304	2025-11-10 18:44:44.583228
4557	7	/api/orders	GET	304	2025-11-10 18:44:44.618748
4649	7	/api/orders	GET	304	2025-11-11 16:26:45.735041
4720	7	/api/auth/me	GET	304	2025-11-11 16:47:42.886274
4723	7	/api/auth/me	GET	304	2025-11-11 16:47:43.549996
4724	7	/api/auth/me	GET	200	2025-11-11 16:47:47.574788
4727	7	/api/auth/me	GET	200	2025-11-11 16:47:57.072186
4767	7	/api/clients	GET	200	2025-11-11 17:15:03.935798
4879	7	/api/clients	GET	304	2026-03-12 17:14:26.01928
4882	7	/api/users	GET	304	2026-03-12 17:14:27.654748
4963	7	/api/auth/me	GET	304	2026-03-12 17:49:42.345594
4966	7	/api/auth/me	GET	200	2026-03-12 17:49:44.113915
5038	7	/api/orders	GET	304	2026-03-12 18:58:51.98423
5039	7	/api/users	GET	304	2026-03-12 18:58:53.349161
5042	7	/api/products	GET	304	2026-03-12 18:58:55.175732
5046	7	/api/orders	GET	304	2026-03-12 18:58:55.184707
5047	7	/api/users	GET	304	2026-03-12 18:58:55.9755
5050	7	/api/products	GET	304	2026-03-12 18:58:56.671604
5054	7	/api/orders	GET	304	2026-03-12 18:58:56.682048
5138	7	/api/clients	GET	304	2026-03-12 20:57:38.658521
5195	7	/api/products	GET	304	2026-03-12 21:05:08.99989
5198	7	/api/clients	GET	304	2026-03-12 21:05:09.107181
5303	7	/api/products	GET	304	2026-03-12 21:23:15.483527
5304	7	/api/users	GET	304	2026-03-12 21:23:16.081999
5307	7	/api/auth/me	GET	200	2026-03-12 21:23:22.187077
5308	7	/api/users	GET	304	2026-03-12 21:23:22.229288
5311	7	/api/products	GET	304	2026-03-12 21:23:25.168049
5315	7	/api/orders	GET	304	2026-03-12 21:23:25.179534
5316	7	/api/products	GET	304	2026-03-12 21:23:25.831002
5319	7	/api/clients	GET	304	2026-03-12 21:23:26.195499
5320	7	/api/clients	GET	304	2026-03-12 21:23:27.754686
5444	7	/api/products	GET	304	2026-03-12 21:44:29.791733
5446	7	/api/orders	GET	304	2026-03-12 21:44:29.800638
5447	7	/api/users	GET	304	2026-03-12 21:44:30.13465
5529	7	/api/orders	GET	304	2026-03-13 13:54:33.928906
5532	7	/api/users	GET	304	2026-03-13 13:54:34.98804
5533	7	/api/clients	GET	304	2026-03-13 13:54:46.650424
5536	7	/api/products	GET	304	2026-03-13 13:54:48.425059
5537	7	/api/clients	GET	304	2026-03-13 13:54:49.601111
5611	\N	/api/debug	GET	404	2026-03-13 14:13:35.061362
5656	7	/api/auth/me	GET	200	2026-03-13 14:26:25.830513
5766	\N	/api/auth/me	GET	401	2026-03-17 17:50:58.797896
5860	7	/api/auth/me	GET	200	2026-03-17 21:03:07.592827
5861	7	/api/summary	GET	200	2026-03-17 21:03:07.661062
5954	7	/api/products	GET	200	2026-03-17 21:39:31.983611
5956	7	/api/orders	GET	200	2026-03-17 21:39:31.990105
5959	7	/api/users	GET	200	2026-03-17 21:39:32.687676
5960	7	/api/summary	GET	200	2026-03-17 21:39:33.704568
6069	7	/api/clients	GET	200	2026-03-17 22:07:58.111184
6145	7	/api/clients	GET	200	2026-03-18 15:57:32.059727
6214	7	/api/auth/me	GET	200	2026-03-18 16:15:22.249099
6216	7	/api/clients	GET	200	2026-03-18 16:15:22.287801
6277	7	/api/clients	GET	200	2026-03-18 16:21:16.589504
6357	7	/api/summary	GET	200	2026-03-18 16:33:01.269398
6438	7	/api/clients	GET	200	2026-03-18 17:00:44.744447
6440	7	/api/orders	GET	200	2026-03-18 17:00:44.802052
6443	7	/api/products	GET	200	2026-03-18 17:00:44.91027
6524	7	/api/financial?	GET	200	2026-03-18 17:31:18.793375
6526	7	/api/financial/categories	GET	200	2026-03-18 17:31:18.861015
6601	7	/api/clients	GET	200	2026-03-18 17:54:13.660862
6604	7	/api/products	GET	200	2026-03-18 17:54:13.669879
6607	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-18	GET	200	2026-03-18 17:54:13.676315
6684	7	/api/financial/categories	GET	200	2026-03-18 18:08:24.46109
6751	7	/api/products	GET	200	2026-03-18 21:16:52.707408
6813	7	/api/suppliers	GET	200	2026-03-18 21:35:43.289437
6814	7	/api/auth/me	GET	200	2026-03-18 21:35:44.786805
6820	7	/api/summary	GET	200	2026-03-18 21:35:44.828881
6823	7	/api/purchase-orders	GET	200	2026-03-18 21:35:44.851568
6832	7	/api/clients	GET	200	2026-03-18 21:35:49.684807
6839	7	/api/suppliers	GET	200	2026-03-18 21:35:57.622159
6897	7	/api/products	GET	200	2026-03-18 21:41:25.33897
6899	7	/api/suppliers	GET	200	2026-03-18 21:41:31.951257
6901	7	/api/purchase-orders	GET	200	2026-03-18 21:41:31.960866
6903	7	/api/products	GET	200	2026-03-18 21:41:31.989896
6995	7	/api/purchase-orders	GET	200	2026-03-18 21:47:42.113047
6998	7	/api/suppliers	GET	200	2026-03-18 21:47:44.559525
6999	7	/api/products	GET	200	2026-03-18 21:47:45.147663
7003	7	/api/clients	GET	200	2026-03-18 21:47:45.168753
7077	7	/api/financial?status=vencido	GET	200	2026-03-18 21:51:41.944624
7131	7	/api/financial?	GET	200	2026-03-19 15:43:00.893538
7231	7	/api/products	GET	200	2026-03-19 16:05:55.139994
7241	7	/api/financial?	GET	200	2026-03-19 16:05:57.345031
7242	7	/api/summary	GET	200	2026-03-19 16:06:03.81386
7275	7	/api/summary	GET	200	2026-03-19 16:11:41.782298
7276	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:11:41.791569
7346	7	/api/purchase-orders	GET	200	2026-03-19 16:17:11.005215
7347	7	/api/summary	GET	200	2026-03-19 16:17:11.552815
7350	7	/api/clients	GET	200	2026-03-19 16:17:13.277942
7351	7	/api/products	GET	200	2026-03-19 16:17:13.969659
7354	7	/api/products	GET	200	2026-03-19 16:17:15.493265
7359	7	/api/users	GET	200	2026-03-19 16:17:18.464996
7362	7	/api/clients	GET	200	2026-03-19 16:17:19.296661
7394	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:22.123898
7395	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:22.131378
7396	7	/api/clients	GET	200	2026-03-19 16:21:23.109852
7399	7	/api/products	GET	200	2026-03-19 16:21:23.905439
7400	7	/api/clients	GET	200	2026-03-19 16:21:24.331988
7404	7	/api/products	GET	200	2026-03-19 16:21:24.340285
7407	7	/api/users	GET	200	2026-03-19 16:21:24.709704
7408	7	/api/clients	GET	200	2026-03-19 16:21:25.158984
4040	7	/api/products	GET	304	2025-11-10 18:10:12.579836
4041	7	/api/products	GET	304	2025-11-10 18:10:13.451687
4056	7	/api/clients	GET	304	2025-11-10 18:10:18.770923
4127	7	/api/orders	GET	304	2025-11-10 18:24:02.075939
4128	7	/api/orders/19/status	PUT	500	2025-11-10 18:24:08.169883
4241	7	/api/orders	GET	304	2025-11-10 18:31:35.759289
4242	7	/api/orders/20/status	PUT	200	2025-11-10 18:31:40.126948
4243	7	/api/orders	GET	200	2025-11-10 18:31:40.13315
4244	7	/api/products	GET	200	2025-11-10 18:31:41.982003
4247	7	/api/orders	GET	304	2025-11-10 18:31:44.454536
4255	7	/api/products	GET	304	2025-11-10 18:31:49.073048
4256	7	/api/products	GET	304	2025-11-10 18:31:51.195572
4406	7	/api/clients	GET	304	2025-11-10 18:40:00.244376
4409	7	/api/products	GET	304	2025-11-10 18:40:00.254334
4547	7	/api/products	GET	304	2025-11-10 18:44:33.383952
4548	7	/api/products	GET	304	2025-11-10 18:44:35.684009
4553	7	/api/clients	GET	304	2025-11-10 18:44:44.57652
4651	7	/api/clients	GET	304	2025-11-11 16:26:45.739355
4722	7	/api/auth/me	GET	304	2025-11-11 16:47:43.547616
4725	7	/api/auth/me	GET	200	2025-11-11 16:47:47.577248
4726	7	/api/auth/me	GET	200	2025-11-11 16:47:57.069224
4768	7	/api/products	GET	200	2025-11-11 17:15:03.936657
4777	7	/api/clients	GET	304	2025-11-11 17:15:04.596021
4784	7	/api/orders	GET	304	2025-11-11 17:15:07.106598
4880	7	/api/products	GET	304	2026-03-12 17:14:26.019884
4881	7	/api/users	GET	304	2026-03-12 17:14:27.64852
4964	7	/api/auth/me	GET	304	2026-03-12 17:49:42.345922
4965	7	/api/auth/me	GET	200	2026-03-12 17:49:44.110976
5055	7	/api/products	GET	304	2026-03-12 19:01:01.254787
5058	7	/api/clients	GET	304	2026-03-12 19:01:02.951253
5068	7	/api/clients	GET	304	2026-03-12 19:01:07.94138
5139	7	/api/products	GET	304	2026-03-12 20:57:38.660603
5141	7	/api/orders	GET	304	2026-03-12 20:57:38.667955
5196	7	/api/clients	GET	304	2026-03-12 21:05:09.104094
5324	7	/api/products	GET	304	2026-03-12 21:23:27.797296
5445	7	/api/orders	GET	304	2026-03-12 21:44:29.794417
5448	7	/api/users	GET	304	2026-03-12 21:44:30.139707
5534	7	/api/clients	GET	304	2026-03-13 13:54:46.681979
5535	7	/api/products	GET	304	2026-03-13 13:54:48.41984
5538	7	/api/products	GET	304	2026-03-13 13:54:49.603412
5612	7	/api/auth/me	GET	200	2026-03-13 14:15:33.949296
5655	7	/api/auth/me	GET	200	2026-03-13 14:26:25.830434
5767	\N	/api/auth/me	GET	401	2026-03-17 17:50:58.851729
5862	7	/api/summary	GET	200	2026-03-17 21:03:07.702366
5955	7	/api/orders	GET	200	2026-03-17 21:39:31.985197
6070	7	/api/products	GET	200	2026-03-17 22:07:58.113644
6072	7	/api/orders	GET	200	2026-03-17 22:07:58.127805
6146	7	/api/products	GET	200	2026-03-18 15:57:32.060503
6148	7	/api/orders	GET	200	2026-03-18 15:57:32.071236
6215	7	/api/clients	GET	200	2026-03-18 16:15:22.283916
6278	7	/api/products	GET	200	2026-03-18 16:21:16.590541
6280	7	/api/orders	GET	200	2026-03-18 16:21:16.600275
6358	7	/api/products	GET	200	2026-03-18 16:33:13.972601
6439	7	/api/orders	GET	200	2026-03-18 17:00:44.79487
6525	7	/api/financial/categories	GET	200	2026-03-18 17:31:18.859207
6602	7	/api/products	GET	200	2026-03-18 17:54:13.664259
6606	7	/api/financial?from=2026-03-01&to=2026-03-18	GET	200	2026-03-18 17:54:13.674056
6685	7	/api/financial?	GET	200	2026-03-18 18:08:24.465104
6752	7	/api/products	GET	200	2026-03-18 21:16:52.838412
6753	7	/api/products	GET	200	2026-03-18 21:16:57.412896
6754	7	/api/purchase-orders	GET	500	2026-03-18 21:16:57.417443
6758	7	/api/suppliers	GET	200	2026-03-18 21:16:57.459104
6816	7	/api/financial?status=vencido	GET	200	2026-03-18 21:35:44.815447
6824	7	/api/purchase-orders	GET	200	2026-03-18 21:35:44.852209
6831	7	/api/products	GET	200	2026-03-18 21:35:49.682407
6835	7	/api/products	GET	200	2026-03-18 21:35:52.330063
6836	7	/api/purchase-orders	GET	200	2026-03-18 21:35:57.615492
6898	7	/api/products	GET	200	2026-03-18 21:41:25.370205
6900	7	/api/purchase-orders	GET	200	2026-03-18 21:41:31.954528
6997	7	/api/suppliers	GET	200	2026-03-18 21:47:44.556878
7001	7	/api/orders?	GET	200	2026-03-18 21:47:45.161903
7005	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-18 21:47:45.176215
7011	7	/api/financial/categories	GET	200	2026-03-18 21:47:45.744229
7013	7	/api/purchase-orders	GET	200	2026-03-18 21:47:46.911126
7016	7	/api/suppliers	GET	200	2026-03-18 21:47:46.918615
7079	7	/api/summary	GET	200	2026-03-18 21:51:41.95509
7080	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:51:41.965049
7085	7	/api/suppliers	GET	200	2026-03-18 21:51:41.977196
7132	7	/api/financial/categories	GET	200	2026-03-19 15:43:00.922442
7232	7	/api/purchase-orders	GET	200	2026-03-19 16:05:55.142709
7277	7	/api/auth/me	GET	200	2026-03-19 16:15:18.133541
7364	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:17:19.298584
7403	7	/api/orders	GET	200	2026-03-19 16:21:24.339511
7410	7	/api/orders?	GET	200	2026-03-19 16:21:25.166499
7445	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:41.998397
7455	7	/api/summary	GET	200	2026-03-19 16:21:44.013387
7456	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:44.02166
7459	7	/api/clients	GET	200	2026-03-19 16:21:44.033292
7460	7	/api/clients	GET	200	2026-03-19 16:21:45.75601
7464	7	/api/products	GET	200	2026-03-19 16:21:45.763939
7467	7	/api/products	GET	200	2026-03-19 16:21:46.116939
7468	7	/api/auth/me	GET	200	2026-03-19 16:21:47.551746
7470	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:47.575804
7481	7	/api/clients	GET	200	2026-03-19 16:21:48.518534
7483	7	/api/orders	GET	200	2026-03-19 16:21:48.521978
7484	7	/api/auth/me	GET	200	2026-03-19 16:21:49.451712
7486	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:49.475234
7489	7	/api/summary	GET	200	2026-03-19 16:21:49.483058
7490	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:49.491313
7493	7	/api/products	GET	200	2026-03-19 16:21:49.507205
7495	7	/api/clients	GET	200	2026-03-19 16:21:49.510154
7505	7	/api/summary	GET	200	2026-03-19 16:21:51.038091
7506	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:51.053402
7509	7	/api/users	GET	200	2026-03-19 16:21:51.067036
7510	7	/api/summary	GET	200	2026-03-19 16:21:52.440787
7512	7	/api/financial?status=vencido	GET	200	2026-03-19 16:26:51.074148
7516	7	/api/financial?status=vencido	GET	200	2026-03-19 16:27:13.62072
7518	7	/api/financial?status=vencido	GET	200	2026-03-19 16:27:13.623003
7521	7	/api/summary	GET	200	2026-03-19 16:27:13.638642
7523	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:27:13.642997
7524	7	/api/auth/me	GET	200	2026-03-19 16:27:13.680236
4043	7	/api/clients	GET	304	2025-11-10 18:10:13.45275
4054	7	/api/products	GET	304	2025-11-10 18:10:18.769154
4057	7	/api/products	GET	304	2025-11-10 18:10:22.519227
4129	7	/api/auth/me	GET	200	2025-11-10 18:24:27.04266
4143	7	/api/products	GET	304	2025-11-10 18:24:29.617947
4251	7	/api/clients	GET	304	2025-11-10 18:31:44.493993
4252	7	/api/orders/20/status	PUT	200	2025-11-10 18:31:47.936699
4253	7	/api/orders	GET	200	2025-11-10 18:31:47.944361
4254	7	/api/products	GET	200	2025-11-10 18:31:49.069617
4257	7	/api/clients	GET	304	2025-11-10 18:31:51.196211
4407	7	/api/products	GET	304	2025-11-10 18:40:00.24685
4410	7	/api/orders	GET	304	2025-11-10 18:40:00.257778
4555	7	/api/orders	GET	200	2025-11-10 18:44:44.613544
4652	7	/api/products	GET	304	2025-11-11 16:26:45.740083
4728	7	/api/auth/me	GET	200	2025-11-11 16:51:44.965384
4729	7	/api/auth/me	GET	200	2025-11-11 16:51:44.969982
4769	7	/api/orders	GET	200	2025-11-11 17:15:03.938813
4776	7	/api/orders	GET	304	2025-11-11 17:15:04.589199
4785	7	/api/clients	GET	304	2025-11-11 17:15:07.107321
4883	7	/api/clients	GET	304	2026-03-12 17:14:49.312409
4886	7	/api/products	GET	304	2026-03-12 17:14:50.655289
4887	7	/api/clients	GET	304	2026-03-12 17:14:56.23752
4903	7	/api/clients	GET	304	2026-03-12 17:15:01.888297
4906	7	/api/users	GET	304	2026-03-12 17:15:02.396951
4967	7	/api/auth/me	GET	304	2026-03-12 17:51:11.237856
4970	7	/api/auth/me	GET	304	2026-03-12 17:51:17.081971
4971	7	/api/auth/me	GET	304	2026-03-12 17:51:21.921386
5056	7	/api/products	GET	304	2026-03-12 19:01:01.289113
5057	7	/api/products	GET	304	2026-03-12 19:01:02.946034
5140	7	/api/orders	GET	304	2026-03-12 20:57:38.663261
5197	7	/api/orders	GET	304	2026-03-12 21:05:09.106622
5325	7	/api/orders	GET	304	2026-03-12 21:23:27.800683
5449	\N	/api/auth/me	GET	401	2026-03-13 13:44:33.002074
5539	7	/api/clients	GET	304	2026-03-13 13:54:49.646019
5613	7	/api/auth/me	GET	200	2026-03-13 14:15:33.949729
5657	7	/api/products	GET	200	2026-03-13 14:26:36.955714
5660	7	/api/clients	GET	200	2026-03-13 14:26:38.207875
5664	7	/api/orders	GET	200	2026-03-13 14:26:38.252837
5768	\N	/api/auth/login	POST	200	2026-03-17 17:51:13.443457
5769	7	/api/clients	GET	200	2026-03-17 17:51:16.65317
5772	7	/api/products	GET	200	2026-03-17 17:51:18.37424
5773	7	/api/clients	GET	200	2026-03-17 17:51:20.198689
5775	7	/api/products	GET	200	2026-03-17 17:51:20.204449
5863	7	/api/auth/me	GET	200	2026-03-17 21:03:07.702716
5957	7	/api/clients	GET	200	2026-03-17 21:39:32.078998
5958	7	/api/users	GET	200	2026-03-17 21:39:32.683119
5961	7	/api/summary	GET	200	2026-03-17 21:39:33.711229
6071	7	/api/orders	GET	200	2026-03-17 22:07:58.12087
6147	7	/api/orders	GET	200	2026-03-18 15:57:32.065246
6217	7	/api/clients	GET	200	2026-03-18 16:16:06.038905
6279	7	/api/orders	GET	200	2026-03-18 16:21:16.594177
6359	7	/api/products	GET	200	2026-03-18 16:33:14.004164
6441	7	/api/clients	GET	200	2026-03-18 17:00:44.904198
6527	7	/api/financial	POST	201	2026-03-18 17:32:00.137989
6528	7	/api/financial?	GET	200	2026-03-18 17:32:00.146051
6529	7	/api/summary	GET	200	2026-03-18 17:32:01.437243
6532	7	/api/auth/me	GET	200	2026-03-18 17:32:04.815202
6533	7	/api/summary	GET	200	2026-03-18 17:32:04.870716
6603	7	/api/financial?from=2026-03-01&to=2026-03-18	GET	200	2026-03-18 17:54:13.667431
6686	7	/api/financial?status=vencido	GET	200	2026-03-18 18:12:03.0108
6755	7	/api/suppliers	GET	200	2026-03-18 21:16:57.455686
6756	7	/api/purchase-orders	GET	500	2026-03-18 21:16:57.458041
6826	7	/api/suppliers	GET	200	2026-03-18 21:35:44.889598
6829	7	/api/clients	GET	200	2026-03-18 21:35:49.6804
6840	7	/api/products	GET	200	2026-03-18 21:35:57.622919
6902	7	/api/products	GET	200	2026-03-18 21:41:31.986851
7006	7	/api/products	GET	200	2026-03-18 21:47:45.198599
7008	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-18 21:47:45.31497
7010	7	/api/financial?	GET	200	2026-03-18 21:47:45.743497
7014	7	/api/suppliers	GET	200	2026-03-18 21:47:46.912127
7017	7	/api/products	GET	200	2026-03-18 21:47:46.9199
7082	7	/api/suppliers	GET	200	2026-03-18 21:51:41.972802
7133	7	/api/financial?	GET	200	2026-03-19 15:43:00.932531
7233	7	/api/suppliers	GET	200	2026-03-19 16:05:55.175205
7240	7	/api/financial/categories	GET	200	2026-03-19 16:05:57.336759
7278	7	/api/auth/me	GET	200	2026-03-19 16:15:18.136946
7291	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:15:20.851445
7294	7	/api/auth/me	GET	200	2026-03-19 16:15:29.386072
7298	7	/api/summary	GET	200	2026-03-19 16:15:29.422212
7302	7	/api/summary	GET	200	2026-03-19 16:15:29.482008
7376	7	/api/suppliers	GET	200	2026-03-19 16:17:20.637348
7377	7	/api/suppliers	GET	200	2026-03-19 16:17:21.481371
7382	7	/api/purchase-orders	GET	200	2026-03-19 16:17:21.488876
7414	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:21:25.178258
7416	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:21:25.183403
7418	7	/api/financial/categories	GET	200	2026-03-19 16:21:25.501687
7426	7	/api/suppliers	GET	200	2026-03-19 16:21:26.271707
7446	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:41.999325
7448	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:42.035779
7451	7	/api/auth/me	GET	200	2026-03-19 16:21:43.981399
7463	7	/api/clients	GET	200	2026-03-19 16:21:45.760801
7474	7	/api/summary	GET	200	2026-03-19 16:21:47.58858
7475	7	/api/products	GET	200	2026-03-19 16:21:47.598267
7480	7	/api/orders	GET	200	2026-03-19 16:21:48.516601
7487	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:49.476776
7494	7	/api/orders	GET	200	2026-03-19 16:21:49.50935
7496	7	/api/products	GET	200	2026-03-19 16:21:49.510784
7499	7	/api/users	GET	200	2026-03-19 16:21:50.29804
7500	7	/api/auth/me	GET	200	2026-03-19 16:21:51.009937
7502	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:51.032086
7503	7	/api/financial?status=vencido	GET	200	2026-03-19 16:21:51.033083
7514	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:26:51.117837
7517	7	/api/summary	GET	200	2026-03-19 16:27:13.622105
7519	7	/api/summary	GET	200	2026-03-19 16:27:13.630829
7520	7	/api/summary	GET	200	2026-03-19 16:27:13.631742
7522	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:27:13.640791
7525	7	/api/clients	GET	200	2026-03-19 16:27:16.620187
7526	7	/api/clients	GET	200	2026-03-19 16:27:16.62212
7527	7	/api/products	GET	200	2026-03-19 16:27:19.051314
7528	7	/api/products	GET	200	2026-03-19 16:27:19.054367
7529	7	/api/clients	GET	200	2026-03-19 16:27:19.742406
7530	7	/api/products	GET	200	2026-03-19 16:27:19.743017
7531	7	/api/clients	GET	200	2026-03-19 16:27:19.746786
4044	7	/api/products	GET	304	2025-11-10 18:10:13.459129
4050	7	/api/products	GET	304	2025-11-10 18:10:17.000301
4051	7	/api/products	GET	304	2025-11-10 18:10:18.7604
4130	7	/api/auth/me	GET	200	2025-11-10 18:24:27.042862
4133	7	/api/clients	GET	304	2025-11-10 18:24:27.079124
4136	7	/api/orders	GET	304	2025-11-10 18:24:27.086779
4137	7	/api/products	GET	304	2025-11-10 18:24:28.335474
4140	7	/api/products	GET	304	2025-11-10 18:24:29.609279
4269	7	/api/products	GET	304	2025-11-10 18:32:12.046773
4270	7	/api/products	GET	304	2025-11-10 18:32:13.199531
4408	7	/api/orders	GET	304	2025-11-10 18:40:00.251524
4556	7	/api/products	GET	304	2025-11-10 18:44:44.616438
4653	7	/api/auth/me	GET	304	2025-11-11 16:28:52.864837
4730	7	/api/auth/me	GET	200	2025-11-11 16:52:51.405578
4731	7	/api/auth/me	GET	200	2025-11-11 16:52:51.411183
4770	7	/api/products	GET	200	2025-11-11 17:15:03.9402
4773	7	/api/auth/me	GET	304	2025-11-11 17:15:04.567986
4774	7	/api/clients	GET	304	2025-11-11 17:15:04.587707
4778	7	/api/products	GET	304	2025-11-11 17:15:04.596528
4781	7	/api/auth/me	GET	200	2025-11-11 17:15:07.082903
4782	7	/api/clients	GET	304	2025-11-11 17:15:07.100231
4786	7	/api/products	GET	304	2025-11-11 17:15:07.108272
4789	7	/api/auth/me	GET	200	2025-11-11 17:15:12.047294
4884	7	/api/clients	GET	304	2026-03-12 17:14:49.344265
4885	7	/api/products	GET	304	2026-03-12 17:14:50.650129
4888	7	/api/products	GET	304	2026-03-12 17:14:56.238862
4890	7	/api/orders	GET	304	2026-03-12 17:14:56.282734
4901	7	/api/clients	GET	304	2026-03-12 17:15:01.881754
4968	7	/api/auth/me	GET	304	2026-03-12 17:51:11.238453
4969	7	/api/auth/me	GET	304	2026-03-12 17:51:17.079066
4972	7	/api/auth/me	GET	304	2026-03-12 17:51:21.923981
5059	7	/api/products	GET	304	2026-03-12 19:01:02.989419
5067	7	/api/products	GET	304	2026-03-12 19:01:07.938464
5142	7	/api/products	GET	304	2026-03-12 20:59:28.695927
5200	7	/api/clients	GET	304	2026-03-12 21:14:15.261284
5203	7	/api/clients	GET	304	2026-03-12 21:14:17.413214
5204	7	/api/products	GET	304	2026-03-12 21:14:17.900485
5207	7	/api/products	GET	304	2026-03-12 21:14:19.898564
5208	7	/api/orders	GET	304	2026-03-12 21:14:19.907169
5217	7	/api/orders	GET	304	2026-03-12 21:14:24.832547
5326	7	/api/orders/27	PUT	200	2026-03-12 21:25:37.074126
5327	7	/api/orders	GET	200	2026-03-12 21:25:37.082886
5450	\N	/api/auth/me	GET	401	2026-03-13 13:44:33.001488
5540	7	/api/products	GET	304	2026-03-13 13:54:49.650237
5542	7	/api/orders	GET	304	2026-03-13 13:54:49.657209
5543	7	/api/users	GET	304	2026-03-13 13:54:57.131406
5546	7	/api/products	GET	304	2026-03-13 13:55:00.18319
5548	7	/api/orders	GET	304	2026-03-13 13:55:00.228321
5614	7	/api/auth/me	GET	200	2026-03-13 14:15:57.543145
5615	7	/api/auth/me	GET	200	2026-03-13 14:15:57.549376
5658	7	/api/products	GET	200	2026-03-13 14:26:36.988232
5659	7	/api/products	GET	200	2026-03-13 14:26:38.202
5770	7	/api/clients	GET	200	2026-03-17 17:51:16.684782
5771	7	/api/products	GET	200	2026-03-17 17:51:18.370414
5774	7	/api/products	GET	200	2026-03-17 17:51:20.199276
5864	7	/api/auth/me	GET	200	2026-03-17 21:05:09.776822
5865	7	/api/summary	GET	200	2026-03-17 21:05:09.807897
5878	7	/api/orders	GET	200	2026-03-17 21:05:19.143431
5962	7	/api/auth/me	GET	200	2026-03-17 21:44:59.483416
5963	7	/api/summary	GET	200	2026-03-17 21:44:59.494014
6073	7	/api/clients	GET	200	2026-03-17 22:07:58.152545
6076	7	/api/products	GET	200	2026-03-17 22:07:58.97725
6077	7	/api/clients	GET	200	2026-03-17 22:07:59.686055
6080	7	/api/summary	GET	200	2026-03-17 22:08:00.173586
6149	7	/api/clients	GET	200	2026-03-18 15:57:32.09737
6152	7	/api/products	GET	200	2026-03-18 15:57:37.582419
6153	7	/api/suppliers	GET	200	2026-03-18 15:57:40.701353
6218	7	/api/products	GET	200	2026-03-18 16:16:06.042921
6281	7	/api/clients	GET	200	2026-03-18 16:21:16.629885
6284	7	/api/summary	GET	200	2026-03-18 16:21:17.703366
6360	7	/api/products/8	PUT	500	2026-03-18 16:34:14.056995
6442	7	/api/products	GET	200	2026-03-18 17:00:44.905984
6530	7	/api/summary	GET	200	2026-03-18 17:32:01.477424
6531	7	/api/auth/me	GET	200	2026-03-18 17:32:04.813595
6534	7	/api/summary	GET	200	2026-03-18 17:32:04.871349
6605	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-18	GET	200	2026-03-18 17:54:13.671458
6687	7	/api/summary	GET	200	2026-03-18 18:12:03.015486
6757	7	/api/products	GET	200	2026-03-18 21:16:57.458625
6827	7	/api/products	GET	200	2026-03-18 21:35:44.890205
6828	7	/api/products	GET	200	2026-03-18 21:35:49.677956
6841	7	/api/products	GET	200	2026-03-18 21:35:57.624788
6904	7	/api/suppliers	GET	200	2026-03-18 21:41:31.993511
7007	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-18 21:47:45.309103
7009	7	/api/financial/categories	GET	200	2026-03-18 21:47:45.74096
7018	7	/api/purchase-orders	GET	200	2026-03-18 21:47:46.921482
7019	7	/api/purchase-orders	POST	201	2026-03-18 21:47:55.460614
7020	7	/api/purchase-orders	GET	200	2026-03-18 21:47:55.465317
7021	7	/api/purchase-orders/5/status	PATCH	200	2026-03-18 21:47:57.056765
7025	7	/api/financial/categories	GET	200	2026-03-18 21:48:00.027713
7084	7	/api/products	GET	200	2026-03-18 21:51:41.975628
7134	7	/api/financial/17	PUT	200	2026-03-19 15:43:21.242528
7135	7	/api/financial?	GET	200	2026-03-19 15:43:21.253833
7234	7	/api/products	GET	200	2026-03-19 16:05:55.204508
7237	7	/api/suppliers	GET	200	2026-03-19 16:05:56.640428
7239	7	/api/financial?	GET	200	2026-03-19 16:05:57.336152
7243	7	/api/summary	GET	200	2026-03-19 16:06:03.82477
7279	7	/api/financial?status=vencido	GET	200	2026-03-19 16:15:18.183049
7288	7	/api/financial?status=vencido	GET	200	2026-03-19 16:15:20.83585
7296	7	/api/financial?status=vencido	GET	200	2026-03-19 16:15:29.411983
7383	7	/api/summary	GET	200	2026-03-19 16:17:50.831183
7417	7	/api/products	GET	200	2026-03-19 16:21:25.205265
7420	7	/api/financial?	GET	200	2026-03-19 16:21:25.506215
7427	7	/api/purchase-orders	GET	200	2026-03-19 16:21:26.273383
7447	7	/api/summary	GET	200	2026-03-19 16:21:42.00796
7449	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:42.037568
7450	7	/api/auth/me	GET	200	2026-03-19 16:21:43.979526
7497	7	/api/orders	GET	200	2026-03-19 16:21:49.512348
7498	7	/api/users	GET	200	2026-03-19 16:21:50.294828
7501	7	/api/auth/me	GET	200	2026-03-19 16:21:51.011529
7504	7	/api/summary	GET	200	2026-03-19 16:21:51.036504
7507	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:21:51.054071
7508	7	/api/users	GET	200	2026-03-19 16:21:51.065692
7511	7	/api/summary	GET	200	2026-03-19 16:21:52.44479
7513	7	/api/summary	GET	200	2026-03-19 16:26:51.080218
7515	7	/api/auth/me	GET	200	2026-03-19 16:27:13.605156
4045	7	/api/orders	GET	304	2025-11-10 18:10:13.459735
4047	7	/api/orders/16/status	PUT	200	2025-11-10 18:10:15.918332
4048	7	/api/orders	GET	200	2025-11-10 18:10:15.92443
4049	7	/api/products	GET	304	2025-11-10 18:10:16.996051
4052	7	/api/orders	GET	304	2025-11-10 18:10:18.761114
4131	7	/api/clients	GET	304	2025-11-10 18:24:27.073587
4135	7	/api/products	GET	304	2025-11-10 18:24:27.083395
4138	7	/api/products	GET	304	2025-11-10 18:24:28.339923
4139	7	/api/clients	GET	304	2025-11-10 18:24:29.608622
4272	7	/api/orders	GET	304	2025-11-10 18:32:13.239385
4411	7	/api/clients	GET	304	2025-11-10 18:40:00.278944
4558	7	/api/orders/23	DELETE	200	2025-11-10 18:44:46.898739
4559	7	/api/orders	GET	200	2025-11-10 18:44:46.9034
4560	7	/api/orders	POST	201	2025-11-10 18:44:55.331863
4561	7	/api/orders	GET	200	2025-11-10 18:44:55.336669
4562	7	/api/products	GET	304	2025-11-10 18:44:56.066047
4565	7	/api/orders	GET	304	2025-11-10 18:44:58.353249
4577	7	/api/products	GET	304	2025-11-10 18:45:03.356598
4579	7	/api/orders	GET	304	2025-11-10 18:45:03.360137
4580	7	/api/orders/24/status	PUT	200	2025-11-10 18:45:04.970777
4581	7	/api/orders	GET	200	2025-11-10 18:45:04.975333
4582	7	/api/products	GET	304	2025-11-10 18:45:06.850699
4585	7	/api/clients	GET	304	2025-11-10 18:45:09.399401
4588	7	/api/clients	GET	304	2025-11-10 18:45:09.409221
4654	7	/api/auth/me	GET	304	2025-11-11 16:28:52.86588
4656	7	/api/auth/me	GET	304	2025-11-11 16:28:53.566484
4657	7	/api/auth/me	GET	200	2025-11-11 16:28:55.331097
4660	7	/api/auth/me	GET	200	2025-11-11 16:28:56.465041
4661	7	/api/auth/me	GET	200	2025-11-11 16:28:57.023415
4732	7	/api/auth/me	GET	304	2025-11-11 16:54:42.710355
4735	7	/api/auth/me	GET	304	2025-11-11 16:54:43.600059
4736	7	/api/auth/me	GET	304	2025-11-11 16:54:44.533221
4739	7	/api/auth/me	GET	200	2025-11-11 16:54:50.578823
4771	7	/api/orders	GET	200	2025-11-11 17:15:03.941607
4772	7	/api/auth/me	GET	304	2025-11-11 17:15:04.565173
4775	7	/api/products	GET	304	2025-11-11 17:15:04.588374
4779	7	/api/orders	GET	304	2025-11-11 17:15:04.597283
4780	7	/api/auth/me	GET	200	2025-11-11 17:15:07.079705
4783	7	/api/products	GET	304	2025-11-11 17:15:07.1008
4787	7	/api/orders	GET	304	2025-11-11 17:15:07.113649
4788	7	/api/auth/me	GET	200	2025-11-11 17:15:12.044069
4889	7	/api/orders	GET	304	2026-03-12 17:14:56.278316
4902	7	/api/orders	GET	304	2026-03-12 17:15:01.883576
4974	7	/api/auth/me	GET	304	2026-03-12 17:51:35.608943
5060	7	/api/clients	GET	304	2026-03-12 19:01:02.991239
5062	7	/api/orders	GET	304	2026-03-12 19:01:02.997724
5063	7	/api/users	GET	304	2026-03-12 19:01:03.568428
5066	7	/api/orders	GET	304	2026-03-12 19:01:07.934821
5070	7	/api/products	GET	304	2026-03-12 19:01:07.946384
5143	7	/api/clients	GET	304	2026-03-12 20:59:28.698118
5201	7	/api/clients	GET	304	2026-03-12 21:14:15.295852
5202	7	/api/clients	GET	304	2026-03-12 21:14:17.410017
5205	7	/api/products	GET	304	2026-03-12 21:14:17.905385
5206	7	/api/clients	GET	304	2026-03-12 21:14:19.898027
5209	7	/api/orders	GET	304	2026-03-12 21:14:19.911325
5216	7	/api/products	GET	304	2026-03-12 21:14:24.825385
5328	7	/api/orders	POST	500	2026-03-12 21:26:03.658018
5329	7	/api/orders	POST	500	2026-03-12 21:26:06.420998
5330	7	/api/orders	POST	500	2026-03-12 21:26:06.892682
5331	7	/api/orders	POST	500	2026-03-12 21:26:07.171492
5332	7	/api/orders	POST	500	2026-03-12 21:26:07.437882
5333	7	/api/orders	POST	500	2026-03-12 21:26:07.799603
5334	7	/api/orders	POST	500	2026-03-12 21:26:08.125527
5335	7	/api/orders	POST	500	2026-03-12 21:26:08.418828
5336	7	/api/orders	POST	500	2026-03-12 21:26:08.592759
5337	7	/api/orders	POST	500	2026-03-12 21:26:08.755524
5338	7	/api/orders	POST	500	2026-03-12 21:26:08.91662
5339	7	/api/orders	POST	500	2026-03-12 21:26:09.070482
5340	7	/api/orders	POST	500	2026-03-12 21:26:09.218591
5341	7	/api/auth/me	GET	304	2026-03-12 21:26:10.314695
5342	7	/api/orders	GET	304	2026-03-12 21:26:10.372333
5345	7	/api/products	GET	304	2026-03-12 21:26:10.415783
5451	\N	/api/auth/login	POST	401	2026-03-13 13:44:53.060629
5541	7	/api/orders	GET	304	2026-03-13 13:54:49.652591
5544	7	/api/users	GET	304	2026-03-13 13:54:57.136683
5545	7	/api/clients	GET	304	2026-03-13 13:55:00.182463
5616	7	/api/auth/me	GET	200	2026-03-13 14:16:43.25034
5661	7	/api/clients	GET	200	2026-03-13 14:26:38.247032
5776	7	/api/clients	GET	200	2026-03-17 17:51:20.242249
5778	7	/api/orders	GET	200	2026-03-17 17:51:20.260925
5779	7	/api/users	GET	200	2026-03-17 17:51:21.844881
5866	7	/api/summary	GET	200	2026-03-17 21:05:09.854728
5869	7	/api/auth/me	GET	200	2026-03-17 21:05:13.7818
5870	7	/api/summary	GET	200	2026-03-17 21:05:13.828045
5873	7	/api/clients	GET	200	2026-03-17 21:05:17.711239
5874	7	/api/products	GET	200	2026-03-17 21:05:18.513592
5877	7	/api/products	GET	200	2026-03-17 21:05:19.138658
5880	7	/api/orders	GET	200	2026-03-17 21:05:19.148301
5883	7	/api/users	GET	200	2026-03-17 21:05:19.708185
5884	7	/api/summary	GET	200	2026-03-17 21:05:20.575643
5964	7	/api/auth/me	GET	200	2026-03-17 21:44:59.582299
5967	7	/api/clients	GET	200	2026-03-17 21:45:06.499624
5968	7	/api/products	GET	200	2026-03-17 21:45:10.932571
5971	7	/api/products	GET	200	2026-03-17 21:45:16.554988
5980	7	/api/clients	GET	200	2026-03-17 21:45:23.583425
5991	7	/api/clients	GET	200	2026-03-17 21:45:29.128534
6074	7	/api/products	GET	200	2026-03-17 22:07:58.15439
6075	7	/api/products	GET	200	2026-03-17 22:07:58.973551
6078	7	/api/clients	GET	200	2026-03-17 22:07:59.689559
6079	7	/api/summary	GET	200	2026-03-17 22:08:00.1682
6150	7	/api/products	GET	200	2026-03-18 15:57:32.233078
6151	7	/api/products	GET	200	2026-03-18 15:57:37.579054
6154	7	/api/suppliers	GET	200	2026-03-18 15:57:40.70556
6219	7	/api/clients	GET	200	2026-03-18 16:16:06.086927
6282	7	/api/products	GET	200	2026-03-18 16:21:16.630641
6283	7	/api/summary	GET	200	2026-03-18 16:21:17.697208
6361	7	/api/products/8	PUT	500	2026-03-18 16:34:22.849853
6444	7	/api/orders	POST	201	2026-03-18 17:01:00.719895
6445	7	/api/orders	GET	200	2026-03-18 17:01:00.725422
6446	7	/api/products	GET	200	2026-03-18 17:01:06.967698
6535	7	/api/auth/me	GET	200	2026-03-18 17:34:49.25295
6536	7	/api/auth/me	GET	200	2026-03-18 17:34:49.256898
6537	7	/api/summary	GET	200	2026-03-18 17:34:49.322659
6608	7	/api/clients	GET	200	2026-03-18 17:54:13.694142
6610	7	/api/orders?	GET	200	2026-03-18 17:54:13.776565
6688	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 18:12:03.050934
6759	7	/api/purchase-orders	POST	500	2026-03-18 21:17:10.336379
6844	7	/api/purchase-orders	POST	201	2026-03-18 21:36:16.675784
4046	7	/api/clients	GET	304	2025-11-10 18:10:13.460308
4055	7	/api/orders	GET	304	2025-11-10 18:10:18.770401
4058	7	/api/products	GET	304	2025-11-10 18:10:22.522999
4132	7	/api/products	GET	304	2025-11-10 18:24:27.075919
4142	7	/api/clients	GET	304	2025-11-10 18:24:29.616956
4274	7	/api/clients	GET	304	2025-11-10 18:32:13.2447
4277	7	/api/orders	GET	200	2025-11-10 18:32:15.241344
4412	7	/api/auth/me	GET	304	2025-11-10 18:41:15.583116
4415	7	/api/clients	GET	304	2025-11-10 18:41:15.623445
4418	7	/api/orders	GET	304	2025-11-10 18:41:15.630981
4421	7	/api/auth/me	GET	200	2025-11-10 18:41:16.80563
4422	7	/api/clients	GET	304	2025-11-10 18:41:16.823595
4426	7	/api/products	GET	304	2025-11-10 18:41:16.832406
4563	7	/api/products	GET	304	2025-11-10 18:44:56.071428
4564	7	/api/products	GET	304	2025-11-10 18:44:58.352336
4655	7	/api/auth/me	GET	304	2025-11-11 16:28:53.564144
4658	7	/api/auth/me	GET	200	2025-11-11 16:28:55.334884
4659	7	/api/auth/me	GET	200	2025-11-11 16:28:56.46166
4662	7	/api/auth/me	GET	200	2025-11-11 16:28:57.025742
4733	7	/api/auth/me	GET	304	2025-11-11 16:54:42.710649
4734	7	/api/auth/me	GET	304	2025-11-11 16:54:43.594812
4737	7	/api/auth/me	GET	304	2025-11-11 16:54:44.535702
4738	7	/api/auth/me	GET	200	2025-11-11 16:54:50.574989
4790	\N	/api/auth/me	GET	401	2025-11-12 15:29:50.632847
4891	7	/api/clients	GET	304	2026-03-12 17:14:56.284105
4893	7	/api/users	GET	304	2026-03-12 17:14:57.724974
4896	7	/api/clients	GET	304	2026-03-12 17:15:00.83196
4897	7	/api/products	GET	304	2026-03-12 17:15:01.422077
4900	7	/api/products	GET	304	2026-03-12 17:15:01.881124
4973	7	/api/auth/me	GET	304	2026-03-12 17:51:35.608657
5061	7	/api/orders	GET	304	2026-03-12 19:01:02.992922
5064	7	/api/users	GET	304	2026-03-12 19:01:03.573938
5065	7	/api/clients	GET	304	2026-03-12 19:01:07.930781
5069	7	/api/orders	GET	304	2026-03-12 19:01:07.945348
5144	7	/api/clients	GET	304	2026-03-12 20:59:44.399164
5210	7	/api/clients	GET	304	2026-03-12 21:14:19.938746
5213	7	/api/users	GET	304	2026-03-12 21:14:21.680064
5214	7	/api/orders	GET	304	2026-03-12 21:14:24.824397
5343	7	/api/products	GET	304	2026-03-12 21:26:10.408993
5346	7	/api/clients	GET	304	2026-03-12 21:26:10.416489
5452	\N	/api/auth/login	POST	200	2026-03-13 13:45:05.002087
5453	7	/api/clients	GET	304	2026-03-13 13:45:07.636215
5456	7	/api/clients	GET	304	2026-03-13 13:45:10.788376
5457	7	/api/products	GET	304	2026-03-13 13:45:13.492558
5460	7	/api/clients	GET	304	2026-03-13 13:45:15.610977
5470	7	/api/clients	GET	304	2026-03-13 13:45:18.326873
5547	7	/api/orders	GET	304	2026-03-13 13:55:00.225
5617	7	/api/auth/me	GET	200	2026-03-13 14:16:43.250524
5662	7	/api/orders	GET	200	2026-03-13 14:26:38.247688
5777	7	/api/orders	GET	200	2026-03-17 17:51:20.256493
5780	7	/api/users	GET	200	2026-03-17 17:51:21.848878
5867	7	/api/auth/me	GET	200	2026-03-17 21:05:09.877147
5868	7	/api/auth/me	GET	200	2026-03-17 21:05:13.779319
5871	7	/api/summary	GET	200	2026-03-17 21:05:13.836485
5872	7	/api/clients	GET	200	2026-03-17 21:05:17.708282
5875	7	/api/products	GET	200	2026-03-17 21:05:18.517066
5876	7	/api/clients	GET	200	2026-03-17 21:05:19.137952
5879	7	/api/products	GET	200	2026-03-17 21:05:19.144459
5965	7	/api/summary	GET	200	2026-03-17 21:44:59.632241
5966	7	/api/clients	GET	200	2026-03-17 21:45:06.495676
5969	7	/api/products	GET	200	2026-03-17 21:45:10.936269
5970	7	/api/clients	GET	200	2026-03-17 21:45:16.553822
5972	7	/api/products	GET	200	2026-03-17 21:45:16.560385
5975	7	/api/orders	GET	200	2026-03-17 21:45:16.620513
5976	7	/api/users	GET	200	2026-03-17 21:45:19.991365
5979	7	/api/products	GET	200	2026-03-17 21:45:23.580496
5992	7	/api/products	GET	200	2026-03-17 21:45:29.129532
5995	7	/api/summary	GET	200	2026-03-17 21:45:31.423883
6081	\N	/api/auth/login	POST	200	2026-03-18 15:31:50.439815
6082	7	/api/summary	GET	200	2026-03-18 15:31:50.539087
6085	7	/api/clients	GET	200	2026-03-18 15:31:57.978275
6086	7	/api/products	GET	200	2026-03-18 15:31:58.541182
6089	7	/api/products	GET	200	2026-03-18 15:31:59.275795
6155	7	/api/users	GET	200	2026-03-18 15:57:51.787662
6158	7	/api/suppliers	GET	200	2026-03-18 15:57:53.325658
6220	7	/api/products	GET	200	2026-03-18 16:16:06.095342
6222	7	/api/orders	GET	200	2026-03-18 16:16:06.158449
6223	7	/api/summary	GET	200	2026-03-18 16:16:12.949507
6226	7	/api/clients	GET	200	2026-03-18 16:16:19.582597
6285	7	/api/products	GET	200	2026-03-18 16:21:36.764793
6362	7	/api/products/8	PUT	500	2026-03-18 16:35:25.266882
6447	7	/api/products	GET	200	2026-03-18 17:01:07.001132
6538	7	/api/summary	GET	200	2026-03-18 17:34:49.45902
6609	7	/api/orders?	GET	200	2026-03-18 17:54:13.771594
6689	7	/api/financial?status=vencido	GET	200	2026-03-18 18:17:03.005248
6760	7	/api/financial?status=vencido	GET	200	2026-03-18 21:20:56.259259
6845	7	/api/purchase-orders	GET	200	2026-03-18 21:36:16.680751
6846	7	/api/purchase-orders/2/status	PATCH	404	2026-03-18 21:36:18.431808
6905	7	/api/purchase-orders	POST	201	2026-03-18 21:41:44.81905
6906	7	/api/purchase-orders	GET	200	2026-03-18 21:41:44.824155
6907	7	/api/purchase-orders/3/status	PATCH	200	2026-03-18 21:41:47.084426
6908	7	/api/purchase-orders	GET	200	2026-03-18 21:41:47.088579
6909	7	/api/financial?	GET	200	2026-03-18 21:41:51.454823
6916	7	/api/suppliers	GET	200	2026-03-18 21:41:53.239758
6922	7	/api/financial/categories	GET	200	2026-03-18 21:41:55.512379
6930	7	/api/summary	GET	200	2026-03-18 21:41:58.047473
6931	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:41:58.051593
6932	7	/api/financial?status=pendente&from=2026-03-18&to=2026-03-25	GET	200	2026-03-18 21:41:58.054255
6933	7	/api/financial?	GET	200	2026-03-18 21:41:58.08621
7022	7	/api/purchase-orders	GET	200	2026-03-18 21:47:57.092526
7023	7	/api/purchase-orders/5/status	PATCH	200	2026-03-18 21:47:57.648364
7024	7	/api/purchase-orders	GET	200	2026-03-18 21:47:57.65274
7026	7	/api/financial?	GET	200	2026-03-18 21:48:00.030285
7087	7	/api/purchase-orders	GET	200	2026-03-18 21:51:41.986153
7136	7	/api/financial/17	PUT	200	2026-03-19 15:44:23.389295
7138	7	/api/financial?status=vencido	GET	200	2026-03-19 15:44:31.899807
7140	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 15:44:31.913516
7141	7	/api/summary	GET	200	2026-03-19 15:44:38.65746
7235	7	/api/purchase-orders	GET	200	2026-03-19 16:05:55.207121
7236	7	/api/suppliers	GET	200	2026-03-19 16:05:56.635874
7238	7	/api/financial/categories	GET	200	2026-03-19 16:05:57.332545
7280	7	/api/financial?status=vencido	GET	200	2026-03-19 16:15:18.193319
7290	7	/api/summary	GET	200	2026-03-19 16:15:20.845868
7297	7	/api/summary	GET	200	2026-03-19 16:15:29.416479
7532	7	/api/products	GET	200	2026-03-19 16:27:19.747531
7538	7	/api/clients	GET	200	2026-03-19 16:27:20.291169
7551	7	/api/products	GET	200	2026-03-19 16:27:21.883775
7556	7	/api/financial?	GET	200	2026-03-19 16:27:22.384602
7557	7	/api/orders?	GET	200	2026-03-19 16:27:22.723577
7533	7	/api/orders	GET	200	2026-03-19 16:27:19.765947
7536	7	/api/products	GET	200	2026-03-19 16:27:20.283538
7565	7	/api/clients	GET	200	2026-03-19 16:27:22.738792
7534	7	/api/orders	GET	200	2026-03-19 16:27:19.769778
7535	7	/api/clients	GET	200	2026-03-19 16:27:20.28166
7541	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:27:20.296849
7563	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:27:22.735978
7537	7	/api/orders?	GET	200	2026-03-19 16:27:20.290326
7552	7	/api/purchase-orders	GET	200	2026-03-19 16:27:21.888781
7555	7	/api/financial/categories	GET	200	2026-03-19 16:27:22.383579
7558	7	/api/products	GET	200	2026-03-19 16:27:22.724861
7539	7	/api/products	GET	200	2026-03-19 16:27:20.293403
7561	7	/api/products	GET	200	2026-03-19 16:27:22.733478
7540	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:27:20.294592
7542	7	/api/orders?	GET	200	2026-03-19 16:27:20.334552
7543	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:27:20.337303
7544	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:27:20.339311
7545	7	/api/suppliers	GET	200	2026-03-19 16:27:21.558608
7546	7	/api/suppliers	GET	200	2026-03-19 16:27:21.560892
7547	7	/api/suppliers	GET	200	2026-03-19 16:27:21.87736
7548	7	/api/products	GET	200	2026-03-19 16:27:21.879852
7549	7	/api/suppliers	GET	200	2026-03-19 16:27:21.880812
7550	7	/api/purchase-orders	GET	200	2026-03-19 16:27:21.883103
7553	7	/api/financial?	GET	200	2026-03-19 16:27:22.379699
7554	7	/api/financial/categories	GET	200	2026-03-19 16:27:22.381093
7559	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:27:22.727853
7560	7	/api/clients	GET	200	2026-03-19 16:27:22.730982
7562	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:27:22.734372
7564	7	/api/orders?	GET	200	2026-03-19 16:27:22.736719
7566	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:27:22.771448
7567	7	/api/summary	GET	200	2026-03-19 16:27:23.318479
7568	7	/api/summary	GET	200	2026-03-19 16:27:23.326855
7569	7	/api/clients	GET	200	2026-03-19 16:27:25.108573
7570	7	/api/clients	GET	200	2026-03-19 16:27:25.11143
7571	7	/api/summary	GET	200	2026-03-19 16:27:27.610119
7572	7	/api/summary	GET	200	2026-03-19 16:27:27.614706
7573	7	/api/clients	GET	200	2026-03-19 16:27:31.961428
7574	7	/api/clients	GET	200	2026-03-19 16:27:31.963447
7575	7	/api/auth/me	GET	200	2026-03-19 16:27:32.994082
7576	7	/api/auth/me	GET	200	2026-03-19 16:27:32.996041
7577	7	/api/financial?status=vencido	GET	200	2026-03-19 16:27:33.019967
7578	7	/api/summary	GET	200	2026-03-19 16:27:33.024854
7579	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:27:33.037667
7580	7	/api/clients	GET	200	2026-03-19 16:27:33.044985
7581	7	/api/clients	GET	200	2026-03-19 16:27:33.045798
7582	7	/api/financial?status=vencido	GET	200	2026-03-19 16:27:33.061495
7583	7	/api/summary	GET	200	2026-03-19 16:27:33.066485
7584	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:27:33.083027
7585	7	/api/summary	GET	200	2026-03-19 16:31:12.136887
7586	7	/api/financial?status=vencido	GET	200	2026-03-19 16:31:12.247111
7587	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:31:12.254778
7588	7	/api/auth/me	GET	200	2026-03-19 16:31:39.082632
7589	7	/api/auth/me	GET	200	2026-03-19 16:31:39.086088
7590	7	/api/clients	GET	200	2026-03-19 16:31:39.100791
7591	7	/api/clients	GET	200	2026-03-19 16:31:39.1018
7592	7	/api/financial?status=vencido	GET	200	2026-03-19 16:31:39.117073
7593	7	/api/financial?status=vencido	GET	200	2026-03-19 16:31:39.118793
7594	7	/api/summary	GET	200	2026-03-19 16:31:39.124268
7595	7	/api/summary	GET	200	2026-03-19 16:31:39.125299
7596	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:31:39.13558
7597	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:31:39.138134
7598	7	/api/products	GET	200	2026-03-19 16:31:39.998079
7599	7	/api/products	GET	200	2026-03-19 16:31:39.999761
7600	7	/api/clients	GET	200	2026-03-19 16:31:40.675162
7601	7	/api/products	GET	200	2026-03-19 16:31:40.675775
7602	7	/api/clients	GET	200	2026-03-19 16:31:40.679825
7603	7	/api/products	GET	200	2026-03-19 16:31:40.681452
7604	7	/api/orders	GET	200	2026-03-19 16:31:40.684443
7605	7	/api/orders	GET	200	2026-03-19 16:31:40.690594
7606	7	/api/users	GET	200	2026-03-19 16:31:41.467942
7607	7	/api/users	GET	200	2026-03-19 16:31:41.471324
7608	7	/api/clients	GET	200	2026-03-19 16:31:41.86327
7609	7	/api/products	GET	200	2026-03-19 16:31:41.865387
7610	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:31:41.871614
7611	7	/api/clients	GET	200	2026-03-19 16:31:41.872263
7612	7	/api/orders?	GET	200	2026-03-19 16:31:41.873384
7613	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:31:41.878074
7614	7	/api/products	GET	200	2026-03-19 16:31:41.913592
7615	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:31:41.920616
7616	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:31:41.921983
7617	7	/api/orders?	GET	200	2026-03-19 16:31:41.923615
7618	7	/api/financial/categories	GET	200	2026-03-19 16:31:42.507428
7619	7	/api/financial/categories	GET	200	2026-03-19 16:31:42.51007
7620	7	/api/financial?	GET	200	2026-03-19 16:31:42.511216
7621	7	/api/financial?	GET	200	2026-03-19 16:31:42.518793
7622	7	/api/suppliers	GET	200	2026-03-19 16:31:43.301212
7623	7	/api/suppliers	GET	200	2026-03-19 16:31:43.303268
7624	7	/api/suppliers	GET	200	2026-03-19 16:31:43.848518
7625	7	/api/products	GET	200	2026-03-19 16:31:43.850475
7626	7	/api/purchase-orders	GET	200	2026-03-19 16:31:43.85129
7627	7	/api/suppliers	GET	200	2026-03-19 16:31:43.853328
7628	7	/api/products	GET	200	2026-03-19 16:31:43.855415
7629	7	/api/purchase-orders	GET	200	2026-03-19 16:31:43.85889
7630	7	/api/suppliers	GET	200	2026-03-19 16:31:44.191251
7631	7	/api/suppliers	GET	200	2026-03-19 16:31:44.193109
7632	7	/api/financial?	GET	200	2026-03-19 16:31:45.23968
7633	7	/api/financial/categories	GET	200	2026-03-19 16:31:45.240239
7634	7	/api/financial/categories	GET	200	2026-03-19 16:31:45.24425
7635	7	/api/financial?	GET	200	2026-03-19 16:31:45.245663
7636	7	/api/auth/me	GET	200	2026-03-19 16:31:46.306609
7637	7	/api/auth/me	GET	200	2026-03-19 16:31:46.308247
7638	7	/api/financial?status=vencido	GET	200	2026-03-19 16:31:46.330084
7639	7	/api/financial?status=vencido	GET	200	2026-03-19 16:31:46.331006
7640	7	/api/summary	GET	200	2026-03-19 16:31:46.338394
7641	7	/api/summary	GET	200	2026-03-19 16:31:46.340175
7642	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:31:46.347332
7643	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:31:46.348059
7644	7	/api/financial?	GET	200	2026-03-19 16:31:46.377297
7645	7	/api/financial/categories	GET	200	2026-03-19 16:31:46.377793
7646	7	/api/financial?	GET	200	2026-03-19 16:31:46.378552
7647	7	/api/financial/categories	GET	200	2026-03-19 16:31:46.379069
7648	7	/api/suppliers	GET	200	2026-03-19 16:31:51.366882
7649	7	/api/suppliers	GET	200	2026-03-19 16:31:51.368339
7650	7	/api/financial?	GET	200	2026-03-19 16:31:53.81282
7651	7	/api/financial/categories	GET	200	2026-03-19 16:31:53.813468
7652	7	/api/financial?	GET	200	2026-03-19 16:31:53.816192
7653	7	/api/financial/categories	GET	200	2026-03-19 16:31:53.816743
7654	7	/api/suppliers	GET	200	2026-03-19 16:31:55.829425
7655	7	/api/purchase-orders	GET	200	2026-03-19 16:31:55.834355
7665	7	/api/purchase-orders	GET	200	2026-03-19 16:32:01.514424
7656	7	/api/suppliers	GET	200	2026-03-19 16:31:55.835575
7659	7	/api/products	GET	200	2026-03-19 16:31:55.841212
7660	7	/api/summary	GET	200	2026-03-19 16:31:59.886835
7663	7	/api/suppliers	GET	200	2026-03-19 16:32:01.510508
7657	7	/api/products	GET	200	2026-03-19 16:31:55.836629
7664	7	/api/products	GET	200	2026-03-19 16:32:01.511071
7658	7	/api/purchase-orders	GET	200	2026-03-19 16:31:55.840435
7661	7	/api/summary	GET	200	2026-03-19 16:31:59.891724
7662	7	/api/purchase-orders	GET	200	2026-03-19 16:32:01.509925
7666	7	/api/suppliers	GET	200	2026-03-19 16:32:01.55168
7667	7	/api/products	GET	200	2026-03-19 16:32:01.552718
7668	7	/api/summary	GET	200	2026-03-19 16:32:06.677713
7669	7	/api/summary	GET	200	2026-03-19 16:32:06.691359
7670	7	/api/clients	GET	200	2026-03-19 16:32:07.520725
7671	7	/api/clients	GET	200	2026-03-19 16:32:07.522341
7672	7	/api/products	GET	200	2026-03-19 16:32:11.843967
7673	7	/api/products	GET	200	2026-03-19 16:32:11.84582
7674	7	/api/products	GET	200	2026-03-19 16:32:13.949776
7675	7	/api/clients	GET	200	2026-03-19 16:32:13.95342
7676	7	/api/products	GET	200	2026-03-19 16:32:13.994168
7677	7	/api/clients	GET	200	2026-03-19 16:32:13.994975
7678	7	/api/orders	GET	200	2026-03-19 16:32:13.997352
7679	7	/api/orders	GET	200	2026-03-19 16:32:14.003379
7680	7	/api/users	GET	200	2026-03-19 16:32:17.958632
7681	7	/api/users	GET	200	2026-03-19 16:32:17.96279
7682	7	/api/clients	GET	200	2026-03-19 16:32:18.752678
7683	7	/api/orders?	GET	200	2026-03-19 16:32:18.760862
7684	7	/api/products	GET	200	2026-03-19 16:32:18.761774
7685	7	/api/clients	GET	200	2026-03-19 16:32:18.762627
7686	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:32:18.763905
7687	7	/api/orders?	GET	200	2026-03-19 16:32:18.769121
7688	7	/api/products	GET	200	2026-03-19 16:32:18.769912
7689	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:32:18.773955
7690	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:32:18.796774
7691	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:32:18.802932
7692	7	/api/financial/categories	GET	200	2026-03-19 16:32:19.425908
7693	7	/api/financial?	GET	200	2026-03-19 16:32:19.427836
7694	7	/api/financial/categories	GET	200	2026-03-19 16:32:19.429189
7695	7	/api/financial?	GET	200	2026-03-19 16:32:19.434144
7696	7	/api/suppliers	GET	200	2026-03-19 16:32:20.088833
7697	7	/api/suppliers	GET	200	2026-03-19 16:32:20.090749
7698	7	/api/suppliers	GET	200	2026-03-19 16:32:20.734361
7699	7	/api/products	GET	200	2026-03-19 16:32:20.735337
7700	7	/api/purchase-orders	GET	200	2026-03-19 16:32:20.738971
7701	7	/api/suppliers	GET	200	2026-03-19 16:32:20.739806
7702	7	/api/products	GET	200	2026-03-19 16:32:20.740512
7703	7	/api/purchase-orders	GET	200	2026-03-19 16:32:20.746439
7704	7	/api/summary	GET	200	2026-03-19 16:32:23.446181
7705	7	/api/summary	GET	200	2026-03-19 16:32:23.450357
7706	7	/api/clients	GET	200	2026-03-19 16:32:25.291757
7707	7	/api/clients	GET	200	2026-03-19 16:32:25.293704
7708	7	/api/summary	GET	200	2026-03-19 16:32:27.373332
7709	7	/api/summary	GET	200	2026-03-19 16:32:27.377662
7711	7	/api/summary	GET	200	2026-03-19 16:36:46.389647
7710	7	/api/financial?status=vencido	GET	200	2026-03-19 16:36:46.383882
7712	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:36:46.42734
7713	7	/api/clients	GET	200	2026-03-19 16:40:47.970708
7714	7	/api/clients	GET	200	2026-03-19 16:40:48.003566
7715	7	/api/products	GET	200	2026-03-19 16:40:50.248989
7716	7	/api/products	GET	200	2026-03-19 16:40:50.252847
7717	7	/api/clients	GET	200	2026-03-19 16:40:50.761403
7718	7	/api/products	GET	200	2026-03-19 16:40:50.761984
7719	7	/api/orders	GET	200	2026-03-19 16:40:50.799328
7720	7	/api/orders	GET	200	2026-03-19 16:40:50.804315
7721	7	/api/clients	GET	200	2026-03-19 16:40:50.899098
7722	7	/api/products	GET	200	2026-03-19 16:40:50.899543
7723	7	/api/users	GET	200	2026-03-19 16:40:51.166801
7724	7	/api/users	GET	200	2026-03-19 16:40:51.171131
7725	7	/api/clients	GET	200	2026-03-19 16:40:51.857297
7726	7	/api/products	GET	200	2026-03-19 16:40:51.857918
7727	7	/api/orders	GET	200	2026-03-19 16:40:51.858621
7728	7	/api/clients	GET	200	2026-03-19 16:40:51.862346
7729	7	/api/products	GET	200	2026-03-19 16:40:51.863054
7730	7	/api/orders	GET	200	2026-03-19 16:40:52.001636
7731	7	/api/users	GET	200	2026-03-19 16:40:52.24226
7732	7	/api/users	GET	200	2026-03-19 16:40:52.245698
7733	7	/api/clients	GET	200	2026-03-19 16:40:52.766412
7734	7	/api/products	GET	200	2026-03-19 16:40:52.767105
7735	7	/api/orders?	GET	200	2026-03-19 16:40:52.772707
7736	7	/api/products	GET	200	2026-03-19 16:40:52.774551
7737	7	/api/clients	GET	200	2026-03-19 16:40:52.775482
7738	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:40:52.780552
7739	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:40:52.819376
7740	7	/api/orders?	GET	200	2026-03-19 16:40:52.822512
7741	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:40:52.823251
7742	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:40:52.825965
7743	7	/api/financial/categories	GET	200	2026-03-19 16:40:53.198954
7744	7	/api/financial?	GET	200	2026-03-19 16:40:53.201003
7745	7	/api/financial/categories	GET	200	2026-03-19 16:40:53.202781
7746	7	/api/financial?	GET	200	2026-03-19 16:40:53.206744
7747	7	/api/suppliers	GET	200	2026-03-19 16:40:53.768428
7748	7	/api/suppliers	GET	200	2026-03-19 16:40:53.770202
7749	7	/api/suppliers	GET	200	2026-03-19 16:40:54.179817
7750	7	/api/products	GET	200	2026-03-19 16:40:54.180306
7751	7	/api/suppliers	GET	200	2026-03-19 16:40:54.183211
7752	7	/api/purchase-orders	GET	200	2026-03-19 16:40:54.183725
7753	7	/api/products	GET	200	2026-03-19 16:40:54.185456
7754	7	/api/purchase-orders	GET	200	2026-03-19 16:40:54.188721
7755	7	/api/suppliers	GET	200	2026-03-19 16:40:57.006447
7756	7	/api/suppliers	GET	200	2026-03-19 16:40:57.008248
7757	7	/api/financial?	GET	200	2026-03-19 16:40:57.399037
7758	7	/api/financial/categories	GET	200	2026-03-19 16:40:57.399683
7759	7	/api/financial?	GET	200	2026-03-19 16:40:57.402316
7760	7	/api/financial/categories	GET	200	2026-03-19 16:40:57.403245
7761	7	/api/users	GET	200	2026-03-19 16:40:57.906992
7762	7	/api/users	GET	200	2026-03-19 16:40:57.909939
7763	7	/api/orders?	GET	200	2026-03-19 16:40:58.392444
7764	7	/api/clients	GET	200	2026-03-19 16:40:58.398803
7765	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:40:58.400038
7766	7	/api/products	GET	200	2026-03-19 16:40:58.400859
7767	7	/api/orders?	GET	200	2026-03-19 16:40:58.401598
7768	7	/api/clients	GET	200	2026-03-19 16:40:58.406016
7769	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:40:58.407572
7770	7	/api/products	GET	200	2026-03-19 16:40:58.408285
7771	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:40:58.409121
7772	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:40:58.413045
7773	7	/api/users	GET	200	2026-03-19 16:41:02.390483
7776	7	/api/products	GET	200	2026-03-19 16:41:02.817649
7774	7	/api/users	GET	200	2026-03-19 16:41:02.393176
7775	7	/api/clients	GET	200	2026-03-19 16:41:02.813447
7777	7	/api/clients	GET	200	2026-03-19 16:41:02.819065
7780	7	/api/orders	GET	200	2026-03-19 16:41:02.828009
7781	7	/api/products	GET	200	2026-03-19 16:41:03.174986
7784	7	/api/clients	GET	200	2026-03-19 16:41:03.533473
7785	7	/api/summary	GET	200	2026-03-19 16:41:03.810431
7778	7	/api/orders	GET	200	2026-03-19 16:41:02.823233
7779	7	/api/products	GET	200	2026-03-19 16:41:02.824448
7782	7	/api/products	GET	200	2026-03-19 16:41:03.177153
7783	7	/api/clients	GET	200	2026-03-19 16:41:03.531723
7786	7	/api/summary	GET	200	2026-03-19 16:41:03.818674
7787	7	/api/financial?status=vencido	GET	200	2026-03-19 16:41:46.373333
7788	7	/api/summary	GET	200	2026-03-19 16:41:46.379517
7789	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:41:46.416654
7790	7	/api/financial?status=vencido	GET	200	2026-03-19 16:46:46.369537
7791	7	/api/summary	GET	200	2026-03-19 16:46:46.3751
7792	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:46:46.382361
7793	7	/api/summary	GET	200	2026-03-19 16:51:46.375735
7794	7	/api/financial?status=vencido	GET	200	2026-03-19 16:51:46.485839
7795	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:51:46.490813
7796	7	/api/clients	GET	200	2026-03-19 16:55:30.178783
7797	7	/api/clients	GET	200	2026-03-19 16:55:30.213134
7798	7	/api/products	GET	200	2026-03-19 16:55:30.735272
7799	7	/api/products	GET	200	2026-03-19 16:55:30.740089
7800	7	/api/clients	GET	200	2026-03-19 16:55:31.804472
7801	7	/api/products	GET	200	2026-03-19 16:55:31.805317
7802	7	/api/products	GET	200	2026-03-19 16:55:31.811195
7803	7	/api/orders	GET	200	2026-03-19 16:55:31.816059
7804	7	/api/orders	GET	200	2026-03-19 16:55:31.823275
7805	7	/api/clients	GET	200	2026-03-19 16:55:31.946865
7806	7	/api/users	GET	200	2026-03-19 16:55:32.27697
7807	7	/api/users	GET	200	2026-03-19 16:55:32.28078
7808	7	/api/clients	GET	200	2026-03-19 16:55:32.63509
7809	7	/api/products	GET	200	2026-03-19 16:55:32.637398
7810	7	/api/clients	GET	200	2026-03-19 16:55:32.643332
7811	7	/api/products	GET	200	2026-03-19 16:55:32.645607
7812	7	/api/orders?	GET	200	2026-03-19 16:55:32.648964
7813	7	/api/orders?	GET	200	2026-03-19 16:55:32.652722
7814	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:55:32.682083
7815	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 16:55:32.688849
7816	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:55:32.784253
7817	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 16:55:32.787933
7818	7	/api/financial?	GET	200	2026-03-19 16:55:33.060657
7819	7	/api/financial/categories	GET	200	2026-03-19 16:55:33.062508
7820	7	/api/financial?	GET	200	2026-03-19 16:55:33.063219
7821	7	/api/financial/categories	GET	200	2026-03-19 16:55:33.066431
7822	7	/api/suppliers	GET	200	2026-03-19 16:55:33.616887
7823	7	/api/suppliers	GET	200	2026-03-19 16:55:33.620079
7824	7	/api/suppliers	GET	200	2026-03-19 16:55:34.078345
7825	7	/api/products	GET	200	2026-03-19 16:55:34.079154
7826	7	/api/suppliers	GET	200	2026-03-19 16:55:34.083396
7827	7	/api/purchase-orders	GET	200	2026-03-19 16:55:34.084144
7828	7	/api/products	GET	200	2026-03-19 16:55:34.084901
7829	7	/api/purchase-orders	GET	200	2026-03-19 16:55:34.118579
7830	7	/api/financial?status=vencido	GET	200	2026-03-19 16:56:46.38308
7831	7	/api/summary	GET	200	2026-03-19 16:56:46.388688
7832	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 16:56:46.426318
7833	\N	/api/summary	GET	401	2026-03-19 17:01:46.377057
7834	\N	/api/financial?status=vencido	GET	401	2026-03-19 17:01:46.377118
7835	\N	/api/auth/login	POST	200	2026-03-19 17:22:49.839014
7836	7	/api/summary	GET	200	2026-03-19 17:22:49.898144
7837	7	/api/financial?status=vencido	GET	200	2026-03-19 17:22:49.918645
7838	7	/api/financial?status=vencido	GET	200	2026-03-19 17:22:49.924144
7839	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:22:49.947386
7840	7	/api/summary	GET	200	2026-03-19 17:22:49.948409
7841	7	/api/summary	GET	200	2026-03-19 17:22:49.956108
7842	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:22:49.957791
7843	7	/api/summary	GET	200	2026-03-19 17:22:49.970936
7844	7	/api/auth/me	GET	200	2026-03-19 17:22:55.932361
7845	7	/api/auth/me	GET	200	2026-03-19 17:22:55.934326
7846	7	/api/summary	GET	200	2026-03-19 17:22:55.961622
7847	7	/api/financial?status=vencido	GET	200	2026-03-19 17:22:56.002285
7848	7	/api/financial?status=vencido	GET	200	2026-03-19 17:22:56.003343
7849	7	/api/summary	GET	200	2026-03-19 17:22:56.010751
7850	7	/api/summary	GET	200	2026-03-19 17:22:56.020571
7851	7	/api/summary	GET	200	2026-03-19 17:22:56.022556
7852	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:22:56.045351
7853	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:22:56.051067
7854	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:03.068451
7855	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:03.071528
7856	7	/api/summary	GET	200	2026-03-19 17:23:03.072759
7857	7	/api/summary	GET	200	2026-03-19 17:23:03.073442
7858	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:03.080078
7859	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:03.080699
7860	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:10.801023
7861	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:10.801861
7862	7	/api/summary	GET	200	2026-03-19 17:23:10.805149
7863	7	/api/summary	GET	200	2026-03-19 17:23:10.805758
7864	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:10.848479
7865	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:10.849093
7866	7	/api/clients	GET	200	2026-03-19 17:23:11.653575
7867	7	/api/clients	GET	200	2026-03-19 17:23:11.654872
7868	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:18.368253
7869	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:18.369107
7870	7	/api/summary	GET	200	2026-03-19 17:23:18.372109
7871	7	/api/summary	GET	200	2026-03-19 17:23:18.373235
7872	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:18.37866
7873	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:18.379235
7874	7	/api/products	GET	200	2026-03-19 17:23:19.631561
7875	7	/api/products	GET	200	2026-03-19 17:23:19.632316
7876	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:26.612558
7877	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:26.614376
7878	7	/api/summary	GET	200	2026-03-19 17:23:26.618124
7879	7	/api/summary	GET	200	2026-03-19 17:23:26.61881
7880	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:26.624022
7881	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:26.624645
7882	7	/api/clients	GET	200	2026-03-19 17:23:27.609834
7883	7	/api/products	GET	200	2026-03-19 17:23:27.610903
7884	7	/api/clients	GET	200	2026-03-19 17:23:27.612306
7885	7	/api/orders	GET	200	2026-03-19 17:23:27.616314
7886	7	/api/products	GET	200	2026-03-19 17:23:27.650898
7887	7	/api/orders	GET	200	2026-03-19 17:23:27.653917
7888	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:39.117883
7889	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:39.118511
7890	7	/api/summary	GET	200	2026-03-19 17:23:39.124369
7891	7	/api/summary	GET	200	2026-03-19 17:23:39.124925
7892	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:39.131502
7893	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:39.132091
7894	7	/api/users	GET	200	2026-03-19 17:23:40.125181
7895	7	/api/users	GET	200	2026-03-19 17:23:40.126132
7896	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:52.089482
7897	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:52.091952
7898	7	/api/summary	GET	200	2026-03-19 17:23:52.095096
7899	7	/api/summary	GET	200	2026-03-19 17:23:52.09691
7900	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:52.101321
7901	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:52.103956
7902	7	/api/orders?	GET	200	2026-03-19 17:23:53.316376
7903	7	/api/clients	GET	200	2026-03-19 17:23:53.317292
7904	7	/api/products	GET	200	2026-03-19 17:23:53.317909
7905	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:23:53.319068
7906	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 17:23:53.362305
7907	7	/api/clients	GET	200	2026-03-19 17:23:53.369444
7908	7	/api/products	GET	200	2026-03-19 17:23:53.371435
7909	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:23:53.374447
7910	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 17:23:53.374934
7911	7	/api/orders?	GET	200	2026-03-19 17:23:53.462056
7912	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:55.67297
7913	7	/api/financial?status=vencido	GET	200	2026-03-19 17:23:55.677687
7914	7	/api/summary	GET	200	2026-03-19 17:23:55.682504
7915	7	/api/summary	GET	200	2026-03-19 17:23:55.683397
7916	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:55.689091
7917	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:23:55.690673
7918	7	/api/financial?	GET	200	2026-03-19 17:23:56.676806
7919	7	/api/financial/categories	GET	200	2026-03-19 17:23:56.677379
7920	7	/api/financial?	GET	200	2026-03-19 17:23:56.678299
7921	7	/api/financial/categories	GET	200	2026-03-19 17:23:56.679002
7922	7	/api/financial?status=vencido	GET	200	2026-03-19 17:24:05.071558
7923	7	/api/financial?status=vencido	GET	200	2026-03-19 17:24:05.072212
7924	7	/api/summary	GET	200	2026-03-19 17:24:05.075205
7925	7	/api/summary	GET	200	2026-03-19 17:24:05.080444
7926	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:24:05.082864
7927	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:24:05.085491
7928	7	/api/suppliers	GET	200	2026-03-19 17:24:06.090878
7929	7	/api/suppliers	GET	200	2026-03-19 17:24:06.091414
7930	7	/api/financial?status=vencido	GET	200	2026-03-19 17:24:10.81326
7931	7	/api/financial?status=vencido	GET	200	2026-03-19 17:24:10.814138
7932	7	/api/summary	GET	200	2026-03-19 17:24:10.817354
7933	7	/api/summary	GET	200	2026-03-19 17:24:10.817813
7934	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:24:10.859853
7935	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:24:10.860647
7936	7	/api/suppliers	GET	200	2026-03-19 17:24:11.856075
7937	7	/api/products	GET	200	2026-03-19 17:24:11.856716
7938	7	/api/suppliers	GET	200	2026-03-19 17:24:11.857608
7939	7	/api/purchase-orders	GET	200	2026-03-19 17:24:11.858388
7940	7	/api/products	GET	200	2026-03-19 17:24:11.858989
7941	7	/api/purchase-orders	GET	200	2026-03-19 17:24:11.859589
7942	7	/api/auth/me	GET	200	2026-03-19 17:24:39.153876
7943	7	/api/auth/me	GET	200	2026-03-19 17:24:39.156004
7944	7	/api/suppliers	GET	200	2026-03-19 17:24:39.17838
7945	7	/api/purchase-orders	GET	200	2026-03-19 17:24:39.182168
7946	7	/api/purchase-orders	GET	200	2026-03-19 17:24:39.189841
7947	7	/api/financial?status=vencido	GET	200	2026-03-19 17:24:39.197749
7948	7	/api/financial?status=vencido	GET	200	2026-03-19 17:24:39.204786
7949	7	/api/summary	GET	200	2026-03-19 17:24:39.206493
7950	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:24:39.215719
7951	7	/api/suppliers	GET	200	2026-03-19 17:24:39.216451
7952	7	/api/summary	GET	200	2026-03-19 17:24:39.218577
7953	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:24:39.223156
7954	7	/api/products	GET	200	2026-03-19 17:24:39.316489
7955	7	/api/products	GET	200	2026-03-19 17:24:39.318249
7956	7	/api/auth/me	GET	200	2026-03-19 17:25:37.967058
7957	7	/api/auth/me	GET	200	2026-03-19 17:25:37.971248
7958	7	/api/suppliers	GET	200	2026-03-19 17:25:37.991146
7959	7	/api/purchase-orders	GET	200	2026-03-19 17:25:37.996389
7960	7	/api/purchase-orders	GET	200	2026-03-19 17:25:38.001824
7961	7	/api/suppliers	GET	200	2026-03-19 17:25:38.007891
7962	7	/api/products	GET	200	2026-03-19 17:25:38.014062
7963	7	/api/financial?status=vencido	GET	200	2026-03-19 17:25:38.022045
7964	7	/api/summary	GET	200	2026-03-19 17:25:38.032118
7965	7	/api/summary	GET	200	2026-03-19 17:25:38.035512
7966	7	/api/products	GET	200	2026-03-19 17:25:38.043032
7967	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:25:38.054128
7968	7	/api/financial?status=vencido	GET	200	2026-03-19 17:25:38.101118
7969	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:25:38.105806
7970	7	/api/financial?status=vencido	GET	200	2026-03-19 17:25:46.407055
7971	7	/api/financial?status=vencido	GET	200	2026-03-19 17:25:46.409474
7972	7	/api/summary	GET	200	2026-03-19 17:25:46.411514
7973	7	/api/summary	GET	200	2026-03-19 17:25:46.416369
7974	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:25:46.416874
7975	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:25:46.424025
7976	7	/api/suppliers	GET	200	2026-03-19 17:25:48.100406
7977	7	/api/suppliers	GET	200	2026-03-19 17:25:48.101108
7978	7	/api/financial?status=vencido	GET	200	2026-03-19 17:25:50.886163
7979	7	/api/financial?status=vencido	GET	200	2026-03-19 17:25:50.888858
7980	7	/api/summary	GET	200	2026-03-19 17:25:50.889604
7981	7	/api/summary	GET	200	2026-03-19 17:25:50.890694
7982	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:25:50.894452
7983	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:25:50.894939
7984	7	/api/financial?	GET	200	2026-03-19 17:25:51.941886
7985	7	/api/financial/categories	GET	200	2026-03-19 17:25:51.942593
7986	7	/api/financial?	GET	200	2026-03-19 17:25:51.94367
7987	7	/api/financial/categories	GET	200	2026-03-19 17:25:51.944297
7988	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:02.692289
7989	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:02.693894
7990	7	/api/summary	GET	200	2026-03-19 17:26:02.699762
7991	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:02.735276
7992	7	/api/summary	GET	200	2026-03-19 17:26:02.812275
7993	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:02.818295
7994	7	/api/orders?	GET	200	2026-03-19 17:26:03.834776
7995	7	/api/clients	GET	200	2026-03-19 17:26:03.840052
7996	7	/api/products	GET	200	2026-03-19 17:26:03.841735
7997	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:26:03.842706
7998	7	/api/clients	GET	200	2026-03-19 17:26:03.844895
7999	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 17:26:03.849045
8000	7	/api/orders?	GET	200	2026-03-19 17:26:03.885873
8001	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 17:26:03.889169
8002	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:26:03.889886
8003	7	/api/products	GET	200	2026-03-19 17:26:04.010177
8004	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:05.713106
8005	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:05.716929
8006	7	/api/summary	GET	200	2026-03-19 17:26:05.721342
8007	7	/api/summary	GET	200	2026-03-19 17:26:05.723866
8008	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:05.72756
8009	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:05.730065
8010	7	/api/users	GET	200	2026-03-19 17:26:06.438832
8011	7	/api/users	GET	200	2026-03-19 17:26:06.44072
8012	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:07.249706
8013	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:07.251517
8014	7	/api/summary	GET	200	2026-03-19 17:26:07.253763
8015	7	/api/summary	GET	200	2026-03-19 17:26:07.255559
8016	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:07.259265
8017	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:07.25967
8018	7	/api/clients	GET	200	2026-03-19 17:26:08.293093
8019	7	/api/products	GET	200	2026-03-19 17:26:08.293762
8020	7	/api/clients	GET	200	2026-03-19 17:26:08.295608
8021	7	/api/products	GET	200	2026-03-19 17:26:08.296368
8022	7	/api/orders	GET	200	2026-03-19 17:26:08.298362
8023	7	/api/orders	GET	200	2026-03-19 17:26:08.29935
8024	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:14.227481
8025	7	/api/financial?status=vencido	GET	200	2026-03-19 17:26:14.228128
8026	7	/api/summary	GET	200	2026-03-19 17:26:14.231504
8027	7	/api/summary	GET	200	2026-03-19 17:26:14.234597
8028	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:14.236624
8029	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:26:14.239233
8030	7	/api/products	GET	200	2026-03-19 17:26:15.133648
8031	7	/api/products	GET	200	2026-03-19 17:26:15.134521
8033	7	/api/financial?status=vencido	GET	200	2026-03-19 17:27:56.603234
8032	7	/api/financial?status=vencido	GET	200	2026-03-19 17:27:56.600574
8034	7	/api/summary	GET	200	2026-03-19 17:27:56.611303
8035	7	/api/summary	GET	200	2026-03-19 17:27:56.612198
8036	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:27:56.652765
8037	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:27:56.762392
8038	7	/api/financial?status=vencido	GET	200	2026-03-19 17:28:01.169493
8039	7	/api/financial?status=vencido	GET	200	2026-03-19 17:28:01.170052
8040	7	/api/summary	GET	200	2026-03-19 17:28:01.172935
8041	7	/api/summary	GET	200	2026-03-19 17:28:01.178074
8042	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:28:01.178641
8043	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:28:01.182057
8044	7	/api/summary	GET	200	2026-03-19 17:28:01.847706
8045	7	/api/summary	GET	200	2026-03-19 17:28:01.85366
8046	7	/api/financial?status=vencido	GET	200	2026-03-19 17:29:39.202389
8047	7	/api/summary	GET	200	2026-03-19 17:29:39.207737
8048	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:29:39.214716
8049	7	/api/financial?status=vencido	GET	200	2026-03-19 17:30:38.005061
8050	7	/api/summary	GET	200	2026-03-19 17:30:38.012587
8051	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:30:38.062703
8052	7	/api/summary	GET	200	2026-03-19 17:32:23.761559
8053	7	/api/suppliers	GET	200	2026-03-19 17:32:41.781541
8054	7	/api/products	GET	200	2026-03-19 17:32:41.78347
8055	7	/api/purchase-orders	GET	200	2026-03-19 17:32:41.784283
8056	7	/api/auth/me	GET	200	2026-03-19 17:33:29.055352
8057	7	/api/auth/me	GET	200	2026-03-19 17:33:29.057896
8058	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:29.086624
8059	7	/api/summary	GET	200	2026-03-19 17:33:29.092929
8060	7	/api/summary	GET	200	2026-03-19 17:33:29.094189
8061	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:29.101974
8062	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:29.18953
8063	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:29.193397
8064	7	/api/auth/me	GET	200	2026-03-19 17:33:40.490075
8065	7	/api/auth/me	GET	200	2026-03-19 17:33:40.490142
8066	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:40.52214
8067	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:40.525592
8068	7	/api/summary	GET	200	2026-03-19 17:33:40.527383
8069	7	/api/summary	GET	200	2026-03-19 17:33:40.531967
8070	7	/api/summary	GET	200	2026-03-19 17:33:40.534244
8071	7	/api/summary	GET	200	2026-03-19 17:33:40.535731
8072	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:40.536463
8073	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:40.540455
8074	7	/api/auth/me	GET	200	2026-03-19 17:33:48.867483
8075	7	/api/auth/me	GET	200	2026-03-19 17:33:48.869234
8076	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:48.901484
8077	7	/api/summary	GET	200	2026-03-19 17:33:48.906455
8078	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:48.907217
8079	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:48.914991
8080	7	/api/summary	GET	200	2026-03-19 17:33:48.91724
8081	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:48.925345
8082	7	/api/summary	GET	200	2026-03-19 17:33:48.953565
8083	7	/api/summary	GET	200	2026-03-19 17:33:48.957854
8084	7	/api/auth/me	GET	200	2026-03-19 17:33:50.567444
8085	7	/api/auth/me	GET	200	2026-03-19 17:33:50.569554
8087	7	/api/summary	GET	200	2026-03-19 17:33:50.599805
8097	7	/api/summary	GET	200	2026-03-19 17:33:59.746673
8098	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:59.756187
8100	7	/api/summary	GET	200	2026-03-19 17:33:59.786762
8086	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:50.595326
8096	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:59.741893
8088	7	/api/summary	GET	200	2026-03-19 17:33:50.600906
8089	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:50.610466
8090	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:50.632015
8091	7	/api/summary	GET	200	2026-03-19 17:33:50.638867
8092	7	/api/summary	GET	200	2026-03-19 17:33:50.644744
8093	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:50.647366
8094	7	/api/auth/me	GET	200	2026-03-19 17:33:59.715974
8095	7	/api/auth/me	GET	200	2026-03-19 17:33:59.717627
8099	7	/api/financial?status=vencido	GET	200	2026-03-19 17:33:59.784464
8101	7	/api/summary	GET	200	2026-03-19 17:33:59.787343
8102	7	/api/summary	GET	200	2026-03-19 17:33:59.794083
8103	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:33:59.807965
8104	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:20.611445
8105	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:20.612098
8106	7	/api/summary	GET	200	2026-03-19 17:34:20.618462
8107	7	/api/summary	GET	200	2026-03-19 17:34:20.618887
8108	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:20.656051
8109	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:20.759849
8110	7	/api/clients	GET	200	2026-03-19 17:34:21.50302
8111	7	/api/clients	GET	200	2026-03-19 17:34:21.50364
8112	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:24.80926
8113	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:24.811855
8114	7	/api/summary	GET	200	2026-03-19 17:34:24.817089
8115	7	/api/summary	GET	200	2026-03-19 17:34:24.817825
8116	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:24.821805
8117	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:24.822218
8118	7	/api/summary	GET	200	2026-03-19 17:34:25.642162
8119	7	/api/summary	GET	200	2026-03-19 17:34:25.642724
8120	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:30.432414
8121	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:30.433248
8122	7	/api/summary	GET	200	2026-03-19 17:34:30.435168
8123	7	/api/summary	GET	200	2026-03-19 17:34:30.435678
8124	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:30.441325
8125	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:30.442249
8126	7	/api/products	GET	200	2026-03-19 17:34:32.453758
8127	7	/api/products	GET	200	2026-03-19 17:34:32.454296
8128	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:33.142602
8129	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:33.143045
8130	7	/api/summary	GET	200	2026-03-19 17:34:33.145871
8131	7	/api/summary	GET	200	2026-03-19 17:34:33.146486
8132	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:33.150337
8133	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:33.150777
8134	7	/api/products	GET	200	2026-03-19 17:34:34.069398
8135	7	/api/products	GET	200	2026-03-19 17:34:34.072935
8136	7	/api/clients	GET	200	2026-03-19 17:34:34.074503
8137	7	/api/orders	GET	200	2026-03-19 17:34:34.075531
8138	7	/api/clients	GET	200	2026-03-19 17:34:34.076516
8139	7	/api/orders	GET	200	2026-03-19 17:34:34.078864
8140	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:41.186592
8141	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:41.187339
8142	7	/api/summary	GET	200	2026-03-19 17:34:41.190482
8143	7	/api/summary	GET	200	2026-03-19 17:34:41.191518
8144	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:41.196658
8145	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:41.197224
8146	7	/api/users	GET	200	2026-03-19 17:34:42.072759
8147	7	/api/users	GET	200	2026-03-19 17:34:42.07407
8148	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:44.059045
8149	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:44.059593
8150	7	/api/summary	GET	200	2026-03-19 17:34:44.061704
8151	7	/api/summary	GET	200	2026-03-19 17:34:44.062141
8152	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:44.06627
8153	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:44.066782
8154	7	/api/clients	GET	200	2026-03-19 17:34:45.298522
8155	7	/api/products	GET	200	2026-03-19 17:34:45.298917
8156	7	/api/orders?	GET	200	2026-03-19 17:34:45.29958
8157	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:34:45.300322
8158	7	/api/clients	GET	200	2026-03-19 17:34:45.301368
8159	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 17:34:45.308056
8160	7	/api/products	GET	200	2026-03-19 17:34:45.346922
8161	7	/api/orders?	GET	200	2026-03-19 17:34:45.349155
8162	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-19	GET	200	2026-03-19 17:34:45.351867
8163	7	/api/financial?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:34:45.352611
8164	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:46.603981
8165	7	/api/financial?status=vencido	GET	200	2026-03-19 17:34:46.607915
8166	7	/api/summary	GET	200	2026-03-19 17:34:46.610448
8167	7	/api/summary	GET	200	2026-03-19 17:34:46.610942
8168	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:46.616085
8169	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:34:46.618618
8170	7	/api/financial?	GET	200	2026-03-19 17:34:47.698166
8171	7	/api/financial/categories	GET	200	2026-03-19 17:34:47.698719
8172	7	/api/financial?	GET	200	2026-03-19 17:34:47.699875
8173	7	/api/financial/categories	GET	200	2026-03-19 17:34:47.70044
8174	7	/api/financial/cash-flow?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:34:49.753929
8175	7	/api/financial/cash-flow?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:34:49.754567
8176	7	/api/financial?	GET	200	2026-03-19 17:34:51.286161
8177	7	/api/financial?	GET	200	2026-03-19 17:34:51.286911
8178	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:00.280865
8179	7	/api/summary	GET	200	2026-03-19 17:35:00.288906
8180	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:00.294696
8181	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:00.321394
8182	7	/api/summary	GET	200	2026-03-19 17:35:00.327447
8183	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:00.333261
8184	7	/api/suppliers	GET	200	2026-03-19 17:35:01.393286
8185	7	/api/suppliers	GET	200	2026-03-19 17:35:01.393813
8186	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:05.676771
8187	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:05.677596
8188	7	/api/summary	GET	200	2026-03-19 17:35:05.680759
8190	7	/api/summary	GET	200	2026-03-19 17:35:05.686231
8189	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:05.685854
8192	7	/api/products	GET	200	2026-03-19 17:35:06.88609
8191	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:05.690524
8194	7	/api/purchase-orders	GET	200	2026-03-19 17:35:06.888548
8193	7	/api/suppliers	GET	200	2026-03-19 17:35:06.887908
8195	7	/api/purchase-orders	GET	200	2026-03-19 17:35:06.890051
8196	7	/api/suppliers	GET	200	2026-03-19 17:35:06.917713
8197	7	/api/products	GET	200	2026-03-19 17:35:07.021666
8198	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:20.239405
8199	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:20.240694
8200	7	/api/summary	GET	200	2026-03-19 17:35:20.243604
8201	7	/api/summary	GET	200	2026-03-19 17:35:20.245522
8202	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:20.249792
8203	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:20.250275
8204	7	/api/summary	GET	200	2026-03-19 17:35:21.124381
8205	7	/api/summary	GET	200	2026-03-19 17:35:21.130455
8206	7	/api/auth/me	GET	200	2026-03-19 17:35:22.442275
8207	7	/api/auth/me	GET	200	2026-03-19 17:35:22.443731
8208	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:22.47789
8209	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:22.481227
8210	7	/api/summary	GET	200	2026-03-19 17:35:22.484535
8211	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:22.49247
8212	7	/api/summary	GET	200	2026-03-19 17:35:22.497534
8213	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:22.502375
8214	7	/api/summary	GET	200	2026-03-19 17:35:22.531774
8215	7	/api/summary	GET	200	2026-03-19 17:35:22.534987
8216	7	/api/financial/categories	GET	200	2026-03-19 17:35:33.683172
8217	7	/api/financial?	GET	200	2026-03-19 17:35:33.685935
8218	7	/api/financial?	GET	200	2026-03-19 17:35:33.692696
8219	7	/api/financial/categories	GET	200	2026-03-19 17:35:33.715212
8220	7	/api/financial/cash-flow?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:35:36.535916
8221	7	/api/financial/cash-flow?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:35:36.539521
8222	7	/api/financial?	GET	200	2026-03-19 17:35:40.733611
8223	7	/api/financial?	GET	200	2026-03-19 17:35:40.738182
8224	7	/api/financial/cash-flow?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:35:41.565382
8225	7	/api/financial/cash-flow?from=2026-03-01&to=2026-03-19	GET	200	2026-03-19 17:35:41.567688
8226	7	/api/financial?	GET	200	2026-03-19 17:35:43.184139
8227	7	/api/financial?	GET	200	2026-03-19 17:35:43.186501
8228	\N	/api/auth/login	POST	200	2026-03-19 17:35:54.113887
8229	7	/api/summary	GET	200	2026-03-19 17:35:54.1488
8230	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:54.17077
8231	7	/api/financial?status=vencido	GET	200	2026-03-19 17:35:54.175793
8232	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:54.176624
8233	7	/api/summary	GET	200	2026-03-19 17:35:54.190559
8234	7	/api/summary	GET	200	2026-03-19 17:35:54.200198
8235	7	/api/summary	GET	200	2026-03-19 17:35:54.204301
8236	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:35:54.210776
8237	7	/api/financial?status=vencido	GET	200	2026-03-19 17:40:54.1842
8238	7	/api/summary	GET	200	2026-03-19 17:40:54.188667
8239	7	/api/financial?status=pendente&from=2026-03-19&to=2026-03-26	GET	200	2026-03-19 17:40:54.226039
8241	\N	/api/summary	GET	401	2026-03-22 19:45:55.40538
8240	\N	/api/financial?status=vencido	GET	401	2026-03-22 19:45:55.406222
8242	\N	/api/auth/login	POST	200	2026-03-22 19:48:37.00559
8243	7	/api/summary	GET	200	2026-03-22 19:48:37.100875
8244	7	/api/summary	GET	200	2026-03-22 19:48:37.105556
8245	7	/api/financial?status=vencido	GET	200	2026-03-22 19:48:37.206134
8246	7	/api/financial?status=vencido	GET	200	2026-03-22 19:48:37.211641
8247	7	/api/financial?status=pendente&from=2026-03-22&to=2026-03-29	GET	200	2026-03-22 19:48:37.2148
8248	7	/api/financial?status=pendente&from=2026-03-22&to=2026-03-29	GET	200	2026-03-22 19:48:37.217665
8249	7	/api/summary	GET	200	2026-03-22 19:48:37.25574
8250	7	/api/summary	GET	200	2026-03-22 19:48:37.265276
8251	7	/api/clients	GET	200	2026-03-22 19:48:50.016181
8252	7	/api/clients	GET	200	2026-03-22 19:48:50.047781
8253	7	/api/products	GET	200	2026-03-22 19:48:50.864
8254	7	/api/products	GET	200	2026-03-22 19:48:50.868413
8255	7	/api/clients	GET	200	2026-03-22 19:48:51.593418
8256	7	/api/products	GET	200	2026-03-22 19:48:51.593858
8257	7	/api/clients	GET	200	2026-03-22 19:48:51.633682
8258	7	/api/products	GET	200	2026-03-22 19:48:51.63678
8259	7	/api/orders	GET	200	2026-03-22 19:48:51.654508
8260	7	/api/orders	GET	200	2026-03-22 19:48:51.660836
8261	7	/api/users	GET	200	2026-03-22 19:48:52.151392
8262	7	/api/users	GET	200	2026-03-22 19:48:52.158508
8263	7	/api/clients	GET	200	2026-03-22 19:48:52.651461
8264	7	/api/products	GET	200	2026-03-22 19:48:52.652801
8265	7	/api/clients	GET	200	2026-03-22 19:48:52.661272
8266	7	/api/orders?	GET	200	2026-03-22 19:48:52.662214
8267	7	/api/financial?from=2026-03-01&to=2026-03-22	GET	200	2026-03-22 19:48:52.663757
8268	7	/api/products	GET	200	2026-03-22 19:48:52.665045
8269	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-22	GET	200	2026-03-22 19:48:52.669911
8270	7	/api/orders?	GET	200	2026-03-22 19:48:52.672347
8271	7	/api/financial?from=2026-03-01&to=2026-03-22	GET	200	2026-03-22 19:48:52.673729
8272	7	/api/financial/cash-flow?from=2026-01-01&to=2026-03-22	GET	200	2026-03-22 19:48:52.677256
8273	7	/api/financial/categories	GET	200	2026-03-22 19:48:53.035516
8274	7	/api/financial?	GET	200	2026-03-22 19:48:53.037614
8275	7	/api/financial/categories	GET	200	2026-03-22 19:48:53.039918
8276	7	/api/financial?	GET	200	2026-03-22 19:48:53.043671
8277	7	/api/suppliers	GET	200	2026-03-22 19:48:54.696832
8278	7	/api/suppliers	GET	200	2026-03-22 19:48:54.700655
8279	7	/api/suppliers	GET	200	2026-03-22 19:48:55.186839
8280	7	/api/products	GET	200	2026-03-22 19:48:55.187421
8281	7	/api/suppliers	GET	200	2026-03-22 19:48:55.190187
8282	7	/api/products	GET	200	2026-03-22 19:48:55.192177
8283	7	/api/purchase-orders	GET	200	2026-03-22 19:48:55.200713
8284	7	/api/purchase-orders	GET	200	2026-03-22 19:48:55.206216
8285	7	/api/financial?status=vencido	GET	200	2026-03-22 19:53:37.113195
8286	7	/api/summary	GET	200	2026-03-22 19:53:37.119666
8287	7	/api/financial?status=pendente&from=2026-03-22&to=2026-03-29	GET	200	2026-03-22 19:53:37.156866
8288	7	/api/clients	GET	200	2026-03-22 19:55:16.918136
8289	7	/api/clients	GET	200	2026-03-22 19:55:17.057248
8290	7	/api/summary	GET	200	2026-03-22 19:55:17.727392
8291	7	/api/summary	GET	200	2026-03-22 19:55:17.744982
8292	7	/api/suppliers	GET	200	2026-03-22 19:55:18.56508
8293	7	/api/purchase-orders	GET	200	2026-03-22 19:55:18.568441
8294	7	/api/products	GET	200	2026-03-22 19:55:18.604562
8295	7	/api/products	GET	200	2026-03-22 19:55:18.607301
8296	7	/api/suppliers	GET	200	2026-03-22 19:55:18.60782
8297	7	/api/purchase-orders	GET	200	2026-03-22 19:55:18.611383
8298	7	/api/suppliers	GET	200	2026-03-22 19:55:20.56405
8299	7	/api/suppliers	GET	200	2026-03-22 19:55:20.566297
8301	7	/api/financial?	GET	200	2026-03-22 19:55:21.234838
8305	7	/api/suppliers	GET	200	2026-03-22 19:55:22.009812
8306	7	/api/users	GET	200	2026-03-22 19:55:23.618967
8300	7	/api/financial/categories	GET	200	2026-03-22 19:55:21.232264
8302	7	/api/financial/categories	GET	200	2026-03-22 19:55:21.235369
8304	7	/api/suppliers	GET	200	2026-03-22 19:55:22.007451
8307	7	/api/users	GET	200	2026-03-22 19:55:23.623262
8303	7	/api/financial?	GET	200	2026-03-22 19:55:21.242357
8308	\N	/api/auth/me	GET	401	2026-03-23 15:27:19.285883
8309	\N	/api/auth/me	GET	401	2026-03-23 15:27:19.295938
8310	\N	/api/auth/login	POST	200	2026-03-23 15:28:02.521721
8311	7	/api/summary	GET	200	2026-03-23 15:28:02.609833
8312	7	/api/financial?status=vencido	GET	200	2026-03-23 15:28:02.61083
8313	7	/api/financial?status=vencido	GET	200	2026-03-23 15:28:02.619809
8314	7	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:28:02.621371
8315	7	/api/summary	GET	200	2026-03-23 15:28:02.662228
8316	7	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:28:02.66867
8317	7	/api/summary	GET	200	2026-03-23 15:28:02.697307
8318	7	/api/summary	GET	200	2026-03-23 15:28:02.709085
8319	7	/api/users	GET	200	2026-03-23 15:28:12.882708
8320	7	/api/users	GET	200	2026-03-23 15:28:12.912767
8321	7	/api/users/5	DELETE	200	2026-03-23 15:28:24.791308
8322	7	/api/users	GET	200	2026-03-23 15:28:24.796573
8323	7	/api/users	POST	201	2026-03-23 15:28:53.651726
8324	7	/api/users	GET	200	2026-03-23 15:28:53.656776
8325	\N	/api/auth/login	POST	200	2026-03-23 15:29:25.31565
8326	9	/api/summary	GET	200	2026-03-23 15:29:25.368176
8327	9	/api/financial?status=vencido	GET	200	2026-03-23 15:29:25.393129
8328	9	/api/financial?status=vencido	GET	200	2026-03-23 15:29:25.398921
8329	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:29:25.400484
8330	9	/api/summary	GET	200	2026-03-23 15:29:25.41807
8331	9	/api/summary	GET	200	2026-03-23 15:29:25.429238
8332	9	/api/summary	GET	200	2026-03-23 15:29:25.434442
8333	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:29:25.461417
8334	\N	/api/auth/login	POST	200	2026-03-23 15:30:50.401445
8335	9	/api/summary	GET	200	2026-03-23 15:30:50.446924
8336	9	/api/financial?status=vencido	GET	200	2026-03-23 15:30:50.470016
8337	9	/api/financial?status=vencido	GET	200	2026-03-23 15:30:50.474633
8338	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:30:50.483822
8339	9	/api/summary	GET	200	2026-03-23 15:30:50.586683
8340	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:30:50.590858
8341	9	/api/summary	GET	200	2026-03-23 15:30:50.593406
8342	9	/api/summary	GET	200	2026-03-23 15:30:50.635985
8343	9	/api/financial?status=vencido	GET	200	2026-03-23 15:31:13.733412
8344	9	/api/summary	GET	200	2026-03-23 15:31:13.739263
8345	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:31:13.745945
8346	9	/api/clients	GET	200	2026-03-23 15:31:16.47465
8347	9	/api/clients	GET	200	2026-03-23 15:31:16.476849
8348	9	/api/products	GET	200	2026-03-23 15:31:19.939967
8349	9	/api/products	GET	200	2026-03-23 15:31:19.943038
8350	9	/api/clients	GET	200	2026-03-23 15:31:25.37473
8351	9	/api/products	GET	200	2026-03-23 15:31:25.375712
8352	9	/api/products	GET	200	2026-03-23 15:31:25.379563
8353	9	/api/clients	GET	200	2026-03-23 15:31:25.415686
8354	9	/api/orders	GET	200	2026-03-23 15:31:25.423306
8355	9	/api/orders	GET	200	2026-03-23 15:31:25.430288
8356	9	/api/orders?	GET	200	2026-03-23 15:31:40.57486
8357	9	/api/products	GET	200	2026-03-23 15:31:40.576727
8358	9	/api/financial?from=2026-03-01&to=2026-03-23	GET	200	2026-03-23 15:31:40.580665
8359	9	/api/products	GET	200	2026-03-23 15:31:40.584027
8360	9	/api/financial/cash-flow?from=2026-01-01&to=2026-03-23	GET	200	2026-03-23 15:31:40.585029
8361	9	/api/financial?from=2026-03-01&to=2026-03-23	GET	200	2026-03-23 15:31:40.590308
8362	9	/api/financial/cash-flow?from=2026-01-01&to=2026-03-23	GET	200	2026-03-23 15:31:40.592528
8363	9	/api/orders?	GET	200	2026-03-23 15:31:40.612318
8364	9	/api/clients	GET	200	2026-03-23 15:31:40.667186
8365	9	/api/clients	GET	200	2026-03-23 15:31:40.669511
8366	\N	/api/auth/login	POST	200	2026-03-23 15:32:03.412674
8367	7	/api/summary	GET	200	2026-03-23 15:32:03.459854
8368	7	/api/financial?status=vencido	GET	200	2026-03-23 15:32:03.482256
8369	7	/api/financial?status=vencido	GET	200	2026-03-23 15:32:03.487767
8370	7	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:32:03.488631
8371	7	/api/summary	GET	200	2026-03-23 15:32:03.503562
8372	7	/api/summary	GET	200	2026-03-23 15:32:03.514032
8373	7	/api/summary	GET	200	2026-03-23 15:32:03.519064
8374	7	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:32:03.52459
8375	7	/api/users	GET	200	2026-03-23 15:32:06.877632
8376	7	/api/users	GET	200	2026-03-23 15:32:06.881835
8377	7	/api/users/9	PUT	200	2026-03-23 15:32:12.917067
8378	7	/api/users	GET	200	2026-03-23 15:32:12.923417
8379	\N	/api/auth/login	POST	200	2026-03-23 15:33:33.864904
8380	9	/api/summary	GET	200	2026-03-23 15:33:33.91523
8381	9	/api/financial?status=vencido	GET	200	2026-03-23 15:33:33.941565
8382	9	/api/financial?status=vencido	GET	200	2026-03-23 15:33:33.946049
8383	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:33:33.955056
8384	9	/api/summary	GET	200	2026-03-23 15:33:33.962531
8385	9	/api/summary	GET	200	2026-03-23 15:33:33.969229
8386	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:33:33.970184
8387	9	/api/summary	GET	200	2026-03-23 15:33:33.981733
8388	9	/api/financial?status=vencido	GET	200	2026-03-23 15:33:49.013174
8389	9	/api/summary	GET	200	2026-03-23 15:33:49.019308
8390	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:33:49.025801
8391	9	/api/clients	GET	200	2026-03-23 15:33:51.581722
8392	9	/api/clients	GET	200	2026-03-23 15:33:51.583547
8393	9	/api/products	GET	200	2026-03-23 15:33:57.978325
8394	9	/api/products	GET	200	2026-03-23 15:33:57.981378
8395	9	/api/products	GET	200	2026-03-23 15:34:02.053826
8396	9	/api/clients	GET	200	2026-03-23 15:34:02.05718
8397	9	/api/clients	GET	200	2026-03-23 15:34:02.102293
8398	9	/api/products	GET	200	2026-03-23 15:34:02.103471
8399	9	/api/orders	GET	200	2026-03-23 15:34:02.105502
8400	9	/api/orders	GET	200	2026-03-23 15:34:02.112332
8401	9	/api/users	GET	200	2026-03-23 15:34:10.712962
8402	9	/api/users	GET	200	2026-03-23 15:34:10.71797
8403	9	/api/orders?	GET	200	2026-03-23 15:34:15.553672
8404	9	/api/clients	GET	200	2026-03-23 15:34:15.555441
8405	9	/api/clients	GET	200	2026-03-23 15:34:15.56129
8406	9	/api/products	GET	200	2026-03-23 15:34:15.596291
8407	9	/api/products	GET	200	2026-03-23 15:34:15.59953
8408	9	/api/financial?from=2026-03-01&to=2026-03-23	GET	200	2026-03-23 15:34:15.601891
8409	9	/api/financial/cash-flow?from=2026-01-01&to=2026-03-23	GET	200	2026-03-23 15:34:15.603949
8410	9	/api/financial?from=2026-03-01&to=2026-03-23	GET	200	2026-03-23 15:34:15.608068
8411	9	/api/orders?	GET	200	2026-03-23 15:34:15.608786
8412	9	/api/financial/cash-flow?from=2026-01-01&to=2026-03-23	GET	200	2026-03-23 15:34:15.611069
8414	9	/api/financial?	GET	200	2026-03-23 15:34:23.068458
8420	9	/api/products	GET	200	2026-03-23 15:34:32.179627
8423	9	/api/purchase-orders	GET	200	2026-03-23 15:34:32.187476
8426	9	/api/summary	GET	200	2026-03-23 15:34:36.580503
8413	9	/api/financial/categories	GET	200	2026-03-23 15:34:23.066065
8416	9	/api/financial?	GET	200	2026-03-23 15:34:23.074654
8417	9	/api/suppliers	GET	200	2026-03-23 15:34:29.764276
8421	9	/api/purchase-orders	GET	200	2026-03-23 15:34:32.180866
8415	9	/api/financial/categories	GET	200	2026-03-23 15:34:23.070727
8418	9	/api/suppliers	GET	200	2026-03-23 15:34:29.768922
8419	9	/api/suppliers	GET	200	2026-03-23 15:34:32.175677
8422	9	/api/products	GET	200	2026-03-23 15:34:32.185234
8424	9	/api/suppliers	GET	200	2026-03-23 15:34:32.212125
8425	9	/api/summary	GET	200	2026-03-23 15:34:36.571209
8427	9	/api/financial?status=vencido	GET	200	2026-03-23 15:38:33.940986
8428	9	/api/summary	GET	200	2026-03-23 15:38:33.947264
8429	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:38:33.984603
8430	9	/api/financial?status=vencido	GET	200	2026-03-23 15:43:33.934855
8431	9	/api/summary	GET	200	2026-03-23 15:43:33.940029
8432	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:43:34.087025
8433	9	/api/summary	GET	200	2026-03-23 15:48:34.797534
8434	9	/api/financial?status=vencido	GET	200	2026-03-23 15:48:34.90789
8435	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:48:34.944536
8436	9	/api/financial?status=vencido	GET	200	2026-03-23 15:53:34.794961
8437	9	/api/summary	GET	200	2026-03-23 15:53:34.801385
8438	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:53:34.836754
8439	9	/api/financial?status=vencido	GET	200	2026-03-23 15:58:34.790981
8440	9	/api/summary	GET	200	2026-03-23 15:58:34.796706
8441	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 15:58:34.803686
8442	9	/api/financial?status=vencido	GET	200	2026-03-23 16:03:34.792542
8443	9	/api/summary	GET	200	2026-03-23 16:03:34.909844
8444	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 16:03:34.916487
8445	9	/api/financial?status=vencido	GET	200	2026-03-23 16:08:41.79481
8446	9	/api/summary	GET	200	2026-03-23 16:08:41.90621
8447	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 16:08:41.944825
8448	9	/api/financial?status=vencido	GET	200	2026-03-23 16:13:41.798348
8449	9	/api/summary	GET	200	2026-03-23 16:13:41.805035
8450	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 16:13:41.811695
8451	9	/api/financial?status=vencido	GET	200	2026-03-23 16:18:41.794862
8452	9	/api/summary	GET	200	2026-03-23 16:18:41.801051
8453	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 16:18:41.84066
8454	9	/api/financial?status=vencido	GET	200	2026-03-23 16:23:41.802529
8455	9	/api/summary	GET	200	2026-03-23 16:23:41.80831
8456	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 16:23:41.845242
8457	9	/api/financial?status=vencido	GET	200	2026-03-23 16:28:41.790619
8458	9	/api/summary	GET	200	2026-03-23 16:28:41.797188
8459	9	/api/financial?status=pendente&from=2026-03-23&to=2026-03-30	GET	200	2026-03-23 16:28:41.80388
8460	\N	/api/summary	GET	401	2026-03-23 16:33:41.796129
8461	\N	/api/financial?status=vencido	GET	401	2026-03-23 16:33:41.79777
\.


--
-- TOC entry 5020 (class 0 OID 16576)
-- Dependencies: 237
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.migrations (id, name, applied_at) FROM stdin;
1	001_initial_schema	2026-03-18 21:24:02.637639-03
2	002_suppliers	2026-03-18 21:24:02.883639-03
3	004_financial	2026-03-18 21:34:26.14056-03
4	003_clients_address	2026-03-18 21:35:24.190894-03
5	005_business_rules	2026-03-19 17:09:28.911643-03
\.


--
-- TOC entry 5008 (class 0 OID 16468)
-- Dependencies: 225
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.order_items (id, order_id, product_id, quantity, price) FROM stdin;
125	31	17	5	650.00
126	31	15	3	5200.00
127	32	16	3	2800.00
128	33	5	6	199.90
129	34	17	1	650.00
130	35	20	1	950.00
104	29	18	4	3900.00
105	29	17	5	650.00
106	30	19	5	4700.00
107	30	15	7	5200.00
111	2	3	1	200.00
112	2	2	2	4200.99
113	3	2	2	4200.99
114	3	3	1	399.99
115	6	2	1	4500.00
116	7	2	1	4500.00
117	16	12	3	10.00
118	16	6	2	399.99
119	19	6	1	399.99
120	24	3	1	200.00
121	25	5	1	199.90
122	26	5	2	199.90
123	27	5	2	199.90
124	28	3	1	200.00
\.


--
-- TOC entry 5006 (class 0 OID 16449)
-- Dependencies: 223
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.orders (id, client_id, user_id, total, status, created_at, updated_at) FROM stdin;
29	20	7	18850.00	pago	2026-03-18 16:20:59.787585	2026-03-18 16:20:59.787585
30	15	7	59900.00	concluído	2026-03-18 16:21:54.964674	2026-03-18 16:21:54.964674
2	22	1	8601.98	enviado	2025-09-17 15:34:54.543202	2026-03-18 16:22:40.397458
3	10	1	8801.97	entregue	2025-09-17 16:09:29.160327	2026-03-18 16:22:47.301851
6	20	7	4500.00	concluído	2025-10-22 16:30:49.247418	2026-03-18 16:22:53.522117
7	23	7	4500.00	cancelado	2025-10-22 17:02:45.999976	2026-03-18 16:22:58.481439
16	17	7	829.98	concluído	2025-11-07 18:39:31.385222	2026-03-18 16:23:16.175078
19	17	7	399.99	concluído	2025-11-10 18:23:46.551723	2026-03-18 16:23:21.427327
24	20	7	200.00	estornado	2025-11-10 18:44:55.293469	2026-03-18 16:23:26.087092
25	15	7	199.90	pendente	2025-11-11 16:43:49.506667	2026-03-18 16:23:30.561426
26	20	7	399.80	pendente	2026-03-12 21:01:24.170533	2026-03-18 16:23:35.257137
27	9	7	399.80	pago	2026-03-12 21:18:55.490134	2026-03-18 16:23:41.238365
28	21	7	200.00	pendente	2026-03-12 21:30:15.65721	2026-03-18 16:23:50.621427
31	18	7	18850.00	concluído	2026-03-18 16:24:37.934972	2026-03-18 16:24:37.934972
32	21	7	8400.00	concluído	2026-03-18 16:24:48.694715	2026-03-18 16:24:48.694715
33	10	7	1199.40	concluído	2026-03-18 16:40:34.894605	2026-03-18 16:40:34.894605
34	20	7	650.00	concluído	2026-03-18 17:01:00.665005	2026-03-18 17:01:00.665005
35	15	7	950.00	pago	2026-03-18 17:30:58.1738	2026-03-18 17:30:58.1738
\.


--
-- TOC entry 5002 (class 0 OID 16426)
-- Dependencies: 219
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.products (id, name, description, price, stock, created_at) FROM stdin;
5	Mouse Gamer		199.90	0	2025-09-17 16:04:51.465192
6	Teclado Mecânico		399.99	0	2025-09-17 16:04:57.370666
12	teste		10.00	0	2025-10-28 16:36:58.866388
3	Mouse s/ Fio		200.00	5	2025-09-17 15:31:48.084128
2	Notebook Gamer		4500.00	8	2025-09-17 15:28:00.456509
15	Smartphone Galaxy S24	Samsung Galaxy S24 com 256GB de armazenamento	5200.00	0	2026-03-18 16:02:21.999117
16	Monitor UltraWide LG 34"	Monitor LG UltraWide 34 polegadas, resolução 3440x1440	2800.00	0	2026-03-18 16:02:37.339444
17	Headset Gamer HyperX Cloud II	Headset com som surround 7.1 e microfone removível	650.00	0	2026-03-18 16:02:50.89946
18	Smartwatch Apple Watch Series 9	Apple Watch com GPS, monitor cardíaco e tela OLED	3900.00	0	2026-03-18 16:03:06.402625
20	Caixa de Som JBL Charge 5	Caixa de som portátil JBL Charge 5 com Bluetooth e bateria de longa duração	950.00	0	2026-03-18 16:03:31.224152
8	Smartphone Galaxy S25+	Samsung Galaxy S24 com 512GB de armazenamento	6700.00	0	2025-10-22 15:44:47.478802
19	Console PlayStation 5 Slim	Sony PlayStation 5 Slim, 1TB SSD, suporte a jogos 4K	4700.00	0	2026-03-18 16:03:17.64494
\.


--
-- TOC entry 5026 (class 0 OID 16668)
-- Dependencies: 243
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.purchase_order_items (id, purchase_order_id, product_id, quantity, unit_cost) FROM stdin;
5	5	20	1	3300.00
\.


--
-- TOC entry 5024 (class 0 OID 16644)
-- Dependencies: 241
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.purchase_orders (id, supplier_id, user_id, total, status, notes, created_at, updated_at) FROM stdin;
5	6	7	3300.00	recebido	\N	2026-03-18 21:47:55.438706-03	2026-03-18 21:47:57.623415-03
\.


--
-- TOC entry 5010 (class 0 OID 16485)
-- Dependencies: 227
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.stock (id, product_id, quantity, last_updated) FROM stdin;
5	12	13	2025-11-10 17:41:38.887295
2	2	15	2026-03-13 14:29:13.144517
9	15	30	2026-03-18 16:02:22.029642
10	16	12	2026-03-18 16:02:37.341489
12	18	20	2026-03-18 16:03:06.405459
7	5	8	2026-03-18 16:23:41.238365
13	19	3	2026-03-18 16:39:40.215354
11	17	49	2026-03-18 17:01:00.665005
8	6	19	2026-03-18 21:38:46.430363
3	3	16	2026-03-18 21:41:54.150955
6	8	1	2026-03-18 21:46:49.437256
14	20	40	2026-03-18 21:47:57.623415
\.


--
-- TOC entry 5022 (class 0 OID 16623)
-- Dependencies: 239
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.stock_movements (id, product_id, quantity, type, reference_id, created_at) FROM stdin;
\.


--
-- TOC entry 5014 (class 0 OID 16511)
-- Dependencies: 231
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.suppliers (id, name, email, phone, document, contact_name, notes, created_at) FROM stdin;
1	Distribuidora Alpha Ltda	carlos@alpha.com.br	(11) 98765-4321	12.345.678/0001-99	Carlos Mendes	Fornecedor principal de eletrônicos	2026-03-18 15:57:18.225248-03
2	Eletrônica Global Ltda	andre@eletronicaglobal.com.br	(11) 3344-7788	14.567.890/0001-33	André Souza	Distribuidora de componentes eletrônicos importados	2026-03-18 15:59:50.939396-03
3	Digital Tech Comércio S.A.	luciana@digitaltech.com.br	(21) 99876-2233	22.345.678/0001-55	Luciana Torres	Fornecedor de notebooks e acessórios	2026-03-18 16:00:09.101038-03
4	Alpha Chips Indústria Ltda	roberto@alphachips.com.br	(31) 4455-6677	33.456.789/0001-77	Roberto Lima	Fabricante de semicondutores e placas eletrônicas	2026-03-18 16:00:27.178264-03
5	Smart Devices Brasil Ltda	carla@smartdevices.com.br	(41) 91234-5566	44.567.890/0001-99	Carla Menezes	Distribuidora de smartphones e tablets	2026-03-18 16:00:45.764382-03
6	AudioVision Equipamentos Eletrônicos Ltda	felipe@audiovision.com.br	(51) 3344-8899	55.678.901/0001-11	Felipe Andrade	Fornecedor de sistemas de som e vídeo	2026-03-18 16:01:10.452704-03
\.


--
-- TOC entry 5016 (class 0 OID 16525)
-- Dependencies: 233
-- Data for Name: transaction_categories; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.transaction_categories (id, name, type, created_at) FROM stdin;
1	Venda de produto	receita	2026-03-18 17:09:44.461619-03
2	Serviço prestado	receita	2026-03-18 17:09:44.461619-03
3	Outros (receita)	receita	2026-03-18 17:09:44.461619-03
4	Fornecedor	despesa	2026-03-18 17:09:44.461619-03
5	Aluguel	despesa	2026-03-18 17:09:44.461619-03
6	Salários	despesa	2026-03-18 17:09:44.461619-03
7	Marketing	despesa	2026-03-18 17:09:44.461619-03
8	Logística	despesa	2026-03-18 17:09:44.461619-03
9	Impostos	despesa	2026-03-18 17:09:44.461619-03
10	Manutenção	despesa	2026-03-18 17:09:44.461619-03
11	Outros (despesa)	despesa	2026-03-18 17:09:44.461619-03
\.


--
-- TOC entry 5018 (class 0 OID 16536)
-- Dependencies: 235
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.transactions (id, type, description, amount, due_date, paid_date, status, category_id, order_id, client_id, supplier_id, user_id, notes, created_at, updated_at) FROM stdin;
1	despesa	Aluguel de março	1500.00	2026-03-18	2026-03-18	pago	5	\N	\N	\N	7	Aluguel	2026-03-18 17:14:40.747802-03	\N
2	despesa	Pagamento manutenção balcão	882.82	2026-03-18	2026-03-18	pago	10	\N	\N	\N	7	Manutenção Balcão	2026-03-18 17:15:36.226167-03	\N
3	receita	Pedido #35 — Eletrônicos Nova Era	950.00	2026-03-18	2026-03-18	pago	1	35	15	\N	7	\N	2026-03-18 17:30:58.181363-03	\N
4	despesa	Pagamento funcionário	1800.00	2026-03-18	2026-03-18	pago	6	\N	\N	\N	7	Folha de pagamento	2026-03-18 17:32:00.134243-03	\N
5	receita	Pedido #2 — Prime Eletrônicos S.A.	8601.98	2025-09-17	2025-09-17	pago	1	2	22	\N	1	\N	2026-03-18 17:36:46.176022-03	\N
6	receita	Pedido #3 — Distribuidora Digital Max	8801.97	2025-09-17	2025-09-17	pago	1	3	10	\N	1	\N	2026-03-18 17:36:46.176022-03	\N
7	receita	Pedido #6 — Conecta Digital Ltda	4500.00	2025-10-22	2025-10-22	pago	1	6	20	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
8	receita	Pedido #16 — Digital House Distribuidora	829.98	2025-11-07	2025-11-07	pago	1	16	17	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
9	receita	Pedido #19 — Digital House Distribuidora	399.99	2025-11-10	2025-11-10	pago	1	19	17	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
10	receita	Pedido #27 — Loja Tech Center	399.80	2026-03-13	2026-03-13	pago	1	27	9	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
11	receita	Pedido #29 — Conecta Digital Ltda	18850.00	2026-03-18	2026-03-18	pago	1	29	20	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
12	receita	Pedido #30 — Eletrônicos Nova Era	59900.00	2026-03-18	2026-03-18	pago	1	30	15	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
13	receita	Pedido #31 — MegaTech Solutions	18850.00	2026-03-18	2026-03-18	pago	1	31	18	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
14	receita	Pedido #32 — Infinity Tech Comércio	8400.00	2026-03-18	2026-03-18	pago	1	32	21	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
15	receita	Pedido #33 — Distribuidora Digital Max	1199.40	2026-03-18	2026-03-18	pago	1	33	10	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
16	receita	Pedido #34 — Conecta Digital Ltda	650.00	2026-03-18	2026-03-18	pago	1	34	20	\N	7	\N	2026-03-18 17:36:46.176022-03	\N
18	despesa	Compra #5 — AudioVision Equipamentos Eletrônicos Ltda	3300.00	2026-03-18	2026-03-19	pago	4	\N	\N	6	\N	\N	2026-03-18 21:47:57.623415-03	2026-03-18 21:48:11.197265-03
17	despesa	DARF	3759.45	2026-03-25	\N	pendente	9	\N	\N	\N	7		2026-03-18 17:37:41.238271-03	2026-03-19 15:59:50.80818-03
\.


--
-- TOC entry 5000 (class 0 OID 16414)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: saas_user
--

COPY public.users (id, name, email, password, created_at, role) FROM stdin;
4	José Pereira	jose@email.com	$2b$10$vWrO5ZPCFMjGggVGqlpyl.a/5qZcPTabZpK9mHXJyQ/N.Ha1L34ie	2025-09-17 16:49:47.921127	user
1	Notebook Gamer Atualizado	joao.atualizado@email.com	$2b$10$k6mac8TjW5ewSwLEeEsUheID.kOwFcwYWJk2wwaA4OIYNlU1eXF0a	2025-09-16 22:07:34.299973	admin
7	Admin1	admin@seuapp.com	$2b$10$kpgjRUwnr1OMQl9zTbI6Neo3HXwgOOtAIObCNmIYbALlgGgDMlNky	2025-10-17 22:16:22.023912	admin
2	Maria Silva Atualizado	maria@email.com	$2b$10$ZZfmYEB.hPep4d/wqAbhUOMqz4TsuL9MHGwqNWWekcbiY8vTbzhA.	2025-09-16 22:11:46.159647	user
8	teste atualizado	teste@mail.com	$2b$10$p/r8WFsBC/3fOqL6loxaM.r2ZmMAKiFIp48RyYh1Yb6KOi6nOnP0S	2025-10-22 15:29:50.650123	user
9	Admin	admin@managesaas.com	$2b$12$G1PMX.RHF1GUuj5ZH//S0ONEkvJWDlOl6nS89UkBNLTUu3K6.FDOe	2026-03-23 15:28:53.648501	admin
\.


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 220
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.clients_id_seq', 24, true);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 228
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.logs_id_seq', 8461, true);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 236
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.migrations_id_seq', 5, true);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 224
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.order_items_id_seq', 130, true);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 222
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.orders_id_seq', 35, true);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.products_id_seq', 20, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 242
-- Name: purchase_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.purchase_order_items_id_seq', 5, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 240
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 5, true);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 226
-- Name: stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.stock_id_seq', 15, true);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 238
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.stock_movements_id_seq', 1, false);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 230
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 6, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 232
-- Name: transaction_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.transaction_categories_id_seq', 55, true);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 234
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.transactions_id_seq', 18, true);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saas_user
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- TOC entry 4792 (class 2606 OID 16447)
-- Name: clients clients_email_key; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_key UNIQUE (email);


--
-- TOC entry 4794 (class 2606 OID 16445)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4811 (class 2606 OID 16508)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 16584)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4830 (class 2606 OID 16582)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4803 (class 2606 OID 16473)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 16456)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4790 (class 2606 OID 16435)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4840 (class 2606 OID 16675)
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 16656)
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 16629)
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- TOC entry 4805 (class 2606 OID 16492)
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id);


--
-- TOC entry 4807 (class 2606 OID 16523)
-- Name: stock stock_product_id_unique; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_product_id_unique UNIQUE (product_id);


--
-- TOC entry 4813 (class 2606 OID 16521)
-- Name: suppliers suppliers_email_key; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_email_key UNIQUE (email);


--
-- TOC entry 4815 (class 2606 OID 16519)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 16534)
-- Name: transaction_categories transaction_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transaction_categories
    ADD CONSTRAINT transaction_categories_name_key UNIQUE (name);


--
-- TOC entry 4819 (class 2606 OID 16532)
-- Name: transaction_categories transaction_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transaction_categories
    ADD CONSTRAINT transaction_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 16548)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 16422)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4787 (class 2606 OID 16420)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4808 (class 1259 OID 16642)
-- Name: idx_logs_created_at; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_logs_created_at ON public.logs USING btree (created_at);


--
-- TOC entry 4809 (class 1259 OID 16641)
-- Name: idx_logs_user_id; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_logs_user_id ON public.logs USING btree (user_id);


--
-- TOC entry 4800 (class 1259 OID 16638)
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);


--
-- TOC entry 4801 (class 1259 OID 16639)
-- Name: idx_order_items_product_id; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_order_items_product_id ON public.order_items USING btree (product_id);


--
-- TOC entry 4795 (class 1259 OID 16635)
-- Name: idx_orders_client_id; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_orders_client_id ON public.orders USING btree (client_id);


--
-- TOC entry 4796 (class 1259 OID 16637)
-- Name: idx_orders_created_at; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_orders_created_at ON public.orders USING btree (created_at);


--
-- TOC entry 4797 (class 1259 OID 16636)
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- TOC entry 4838 (class 1259 OID 16688)
-- Name: idx_poi_order; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_poi_order ON public.purchase_order_items USING btree (purchase_order_id);


--
-- TOC entry 4788 (class 1259 OID 16696)
-- Name: idx_products_name_lower; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE UNIQUE INDEX idx_products_name_lower ON public.products USING btree (lower((name)::text));


--
-- TOC entry 4834 (class 1259 OID 16687)
-- Name: idx_purchase_orders_status; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_purchase_orders_status ON public.purchase_orders USING btree (status);


--
-- TOC entry 4835 (class 1259 OID 16686)
-- Name: idx_purchase_orders_supplier; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_purchase_orders_supplier ON public.purchase_orders USING btree (supplier_id);


--
-- TOC entry 4831 (class 1259 OID 16640)
-- Name: idx_stock_movements_product; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_stock_movements_product ON public.stock_movements USING btree (product_id);


--
-- TOC entry 4820 (class 1259 OID 16574)
-- Name: idx_transactions_category; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_transactions_category ON public.transactions USING btree (category_id);


--
-- TOC entry 4821 (class 1259 OID 16691)
-- Name: idx_transactions_due_date; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_transactions_due_date ON public.transactions USING btree (due_date);


--
-- TOC entry 4822 (class 1259 OID 16692)
-- Name: idx_transactions_order_id; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_transactions_order_id ON public.transactions USING btree (order_id);


--
-- TOC entry 4823 (class 1259 OID 16690)
-- Name: idx_transactions_status; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_transactions_status ON public.transactions USING btree (status);


--
-- TOC entry 4824 (class 1259 OID 16689)
-- Name: idx_transactions_type; Type: INDEX; Schema: public; Owner: saas_user
--

CREATE INDEX idx_transactions_type ON public.transactions USING btree (type);


--
-- TOC entry 4843 (class 2606 OID 16474)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 16479)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 4841 (class 2606 OID 16457)
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 4842 (class 2606 OID 16462)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4854 (class 2606 OID 16681)
-- Name: purchase_order_items purchase_order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- TOC entry 4855 (class 2606 OID 16676)
-- Name: purchase_order_items purchase_order_items_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- TOC entry 4852 (class 2606 OID 16657)
-- Name: purchase_orders purchase_orders_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE RESTRICT;


--
-- TOC entry 4853 (class 2606 OID 16662)
-- Name: purchase_orders purchase_orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4851 (class 2606 OID 16630)
-- Name: stock_movements stock_movements_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4845 (class 2606 OID 16493)
-- Name: stock stock_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4846 (class 2606 OID 16549)
-- Name: transactions transactions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.transaction_categories(id) ON DELETE SET NULL;


--
-- TOC entry 4847 (class 2606 OID 16559)
-- Name: transactions transactions_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE SET NULL;


--
-- TOC entry 4848 (class 2606 OID 16554)
-- Name: transactions transactions_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL;


--
-- TOC entry 4849 (class 2606 OID 16564)
-- Name: transactions transactions_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE SET NULL;


--
-- TOC entry 4850 (class 2606 OID 16569)
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: saas_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 5032
-- Name: DATABASE management_saas; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE management_saas TO saas_user;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT CREATE ON SCHEMA public TO saas_user;


--
-- TOC entry 2140 (class 826 OID 16424)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO saas_user;


-- Completed on 2026-03-24 16:11:00

--
-- PostgreSQL database dump complete
--

\unrestrict De1dZAp3oGA5KtnTnInpt97z5YcjPb9XxuDlmRE1axOegvSGzj6XT9ZIaB3m3LV

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict jprnHTW1AAaPqn6d9m3nG2uyA4iwdyODW2nsdEINztPHDYtfyuH2xXPf2cyOhUW

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.6

-- Started on 2026-03-24 16:11:00

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
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16401)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16400)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4636 (class 2604 OID 16404)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4786 (class 0 OID 16401)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, created_at) FROM stdin;
\.


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 4639 (class 2606 OID 16409)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4641 (class 2606 OID 16407)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.users TO saas_user;


--
-- TOC entry 2039 (class 826 OID 16423)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO saas_user;


-- Completed on 2026-03-24 16:11:00

--
-- PostgreSQL database dump complete
--

\unrestrict jprnHTW1AAaPqn6d9m3nG2uyA4iwdyODW2nsdEINztPHDYtfyuH2xXPf2cyOhUW

-- Completed on 2026-03-24 16:11:00

--
-- PostgreSQL database cluster dump complete
--

