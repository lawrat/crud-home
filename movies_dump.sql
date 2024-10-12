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
-- Name: Movies; Type: TABLE; Schema: public; Owner: lsall
--

CREATE TABLE public."Movies" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    genre character varying(255) NOT NULL,
    year integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Movies" OWNER TO lsall;

--
-- Name: Movies_id_seq; Type: SEQUENCE; Schema: public; Owner: lsall
--

CREATE SEQUENCE public."Movies_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Movies_id_seq" OWNER TO lsall;

--
-- Name: Movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsall
--

ALTER SEQUENCE public."Movies_id_seq" OWNED BY public."Movies".id;


--
-- Name: Orders; Type: TABLE; Schema: public; Owner: lsall
--

CREATE TABLE public."Orders" (
    id integer NOT NULL,
    product character varying(255) NOT NULL,
    quantity integer NOT NULL,
    total_price double precision NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Orders" OWNER TO lsall;

--
-- Name: Orders_id_seq; Type: SEQUENCE; Schema: public; Owner: lsall
--

CREATE SEQUENCE public."Orders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Orders_id_seq" OWNER TO lsall;

--
-- Name: Orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsall
--

ALTER SEQUENCE public."Orders_id_seq" OWNED BY public."Orders".id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: lsall
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    genre character varying(255) NOT NULL,
    year integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.movies OWNER TO lsall;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: lsall
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movies_id_seq OWNER TO lsall;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsall
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: Movies id; Type: DEFAULT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public."Movies" ALTER COLUMN id SET DEFAULT nextval('public."Movies_id_seq"'::regclass);


--
-- Name: Orders id; Type: DEFAULT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public."Orders" ALTER COLUMN id SET DEFAULT nextval('public."Orders_id_seq"'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Data for Name: Movies; Type: TABLE DATA; Schema: public; Owner: lsall
--

COPY public."Movies" (id, title, genre, year, "createdAt", "updatedAt") FROM stdin;
2	Inception	Science Fiction	2010	2024-09-27 18:50:30.447+00	2024-09-27 18:50:30.447+00
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: lsall
--

COPY public."Orders" (id, product, quantity, total_price, "createdAt", "updatedAt") FROM stdin;
1	Produit A	2	20	2024-09-28 10:49:23.594+00	2024-09-28 10:49:23.594+00
2	Produit B	5	30	2024-09-28 10:59:40.906+00	2024-09-28 10:59:40.906+00
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: lsall
--

COPY public.movies (id, title, genre, year, "createdAt", "updatedAt") FROM stdin;
1	Inception	Science Fiction	2010	2024-10-01 11:26:46.384+00	2024-10-01 11:26:46.384+00
\.


--
-- Name: Movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsall
--

SELECT pg_catalog.setval('public."Movies_id_seq"', 2, true);


--
-- Name: Orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsall
--

SELECT pg_catalog.setval('public."Orders_id_seq"', 2, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsall
--

SELECT pg_catalog.setval('public.movies_id_seq', 2, true);


--
-- Name: Movies Movies_pkey; Type: CONSTRAINT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public."Movies"
    ADD CONSTRAINT "Movies_pkey" PRIMARY KEY (id);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: lsall
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

