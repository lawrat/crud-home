--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: lsall
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    number_of_items integer NOT NULL,
    total_amount numeric(10,2) NOT NULL
);


ALTER TABLE public.orders OWNER TO lsall;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: lsall
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO lsall;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsall
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: lsall
--

COPY public.orders (id, user_id, number_of_items, total_amount) FROM stdin;
1	1	2	29.99
2	3	5	180.00
3	4	3	150.99
4	6	2	140.00
5	6	2	140.00
6	8	3	130.00
7	9	2	120.99
8	3	2	160.00
9	19	2	80.99
10	2	2	200.99
11	5	2	280.99
12	1	2	70.99
13	1	2	70.99
14	123	2	50.00
15	1	2	70.99
16	7	2	170.99
17	17	2	182.99
18	4	2	184.90
19	3	5	140.99
20	11	2	99.00
21	13	2	990.00
22	5	1	50.99
23	6	2	174.90
24	3	4	340.99
25	24	2	210.80
26	25	2	200.99
28	52	2	170.75
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsall
--

SELECT pg_catalog.setval('public.orders_id_seq', 28, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

