--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Debian 14.4-1.pgdg110+1)
-- Dumped by pg_dump version 14.4 (Debian 14.4-1.pgdg110+1)

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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pessoas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoas (
    id uuid NOT NULL,
    apelido character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    nascimento date NOT NULL,
    stack character varying[],
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    busca_trgm text GENERATED ALWAYS AS ((lower((nome)::text) || lower((apelido)::text))) STORED
);


ALTER TABLE public.pessoas OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Data for Name: pessoas; Type: TABLE DATA; Schema: public; Owner: postgres
--

--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."schema_migrations" (version) VALUES (20230816171253);

--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: idx_pessoas_busca_tgrm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pessoas_busca_tgrm ON public.pessoas USING gist (busca_trgm public.gist_trgm_ops);


--
-- Name: pessoas_apelido_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pessoas_apelido_index ON public.pessoas USING btree (apelido);


--
-- PostgreSQL database dump complete
--