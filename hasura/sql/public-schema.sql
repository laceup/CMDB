--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ensembl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensembl (
    name text NOT NULL,
    ensembl_id text NOT NULL,
    start_bp numeric NOT NULL,
    end_bp numeric NOT NULL,
    chromosome_scaffold_name text NOT NULL,
    transcript_count numeric NOT NULL,
    percentage_gc_content numeric NOT NULL
);


ALTER TABLE public.ensembl OWNER TO postgres;

--
-- Name: exac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exac (
    id integer NOT NULL,
    ensembl_id text NOT NULL,
    allele_count numeric,
    pos numeric,
    quality_metrics jsonb,
    variant_id text,
    alt text,
    pop_homs jsonb,
    pop_acs jsonb,
    category text,
    allele_freq numeric,
    major_consequence text,
    "HGVSc" text,
    rsid text,
    "HGVSp" text,
    hom_count numeric,
    chrom text,
    allele_num numeric,
    pop_ans jsonb,
    filter text,
    flags jsonb,
    "HGVS" text,
    "CANONICAL" text,
    pop_hemis jsonb,
    hemi_count numeric,
    ref text
);


ALTER TABLE public.exac OWNER TO postgres;

--
-- Name: exac_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exac_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exac_id_seq OWNER TO postgres;

--
-- Name: exac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exac_id_seq OWNED BY public.exac.id;


--
-- Name: gene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gene (
    name text NOT NULL,
    uniprot_id text NOT NULL,
    ncbi_id integer NOT NULL,
    ensembl_id text NOT NULL,
    mgi_id text,
    protein_name text
);


ALTER TABLE public.gene OWNER TO postgres;

--
-- Name: gene_ontology; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gene_ontology (
    id text NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.gene_ontology OWNER TO postgres;

--
-- Name: go_biological_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.go_biological_process (
    name text NOT NULL,
    go_id text NOT NULL
);


ALTER TABLE public.go_biological_process OWNER TO postgres;

--
-- Name: go_cellular_component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.go_cellular_component (
    name text NOT NULL,
    go_id text NOT NULL
);


ALTER TABLE public.go_cellular_component OWNER TO postgres;

--
-- Name: go_molecular_function; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.go_molecular_function (
    name text NOT NULL,
    go_id text NOT NULL
);


ALTER TABLE public.go_molecular_function OWNER TO postgres;

--
-- Name: pathway; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pathway (
    id integer NOT NULL,
    name text NOT NULL,
    data text NOT NULL,
    external_id text NOT NULL,
    source text NOT NULL
);


ALTER TABLE public.pathway OWNER TO postgres;

--
-- Name: pathway_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pathway_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pathway_id_seq OWNER TO postgres;

--
-- Name: pathway_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pathway_id_seq OWNED BY public.pathway.id;


--
-- Name: phenotype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phenotype (
    id integer NOT NULL,
    name text NOT NULL,
    marker_symbol text NOT NULL,
    mgi_accession_id text NOT NULL,
    phenotype text NOT NULL,
    term text NOT NULL,
    definition text
);


ALTER TABLE public.phenotype OWNER TO postgres;

--
-- Name: phenotype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phenotype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phenotype_id_seq OWNER TO postgres;

--
-- Name: phenotype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phenotype_id_seq OWNED BY public.phenotype.id;


--
-- Name: exac id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exac ALTER COLUMN id SET DEFAULT nextval('public.exac_id_seq'::regclass);


--
-- Name: pathway id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pathway ALTER COLUMN id SET DEFAULT nextval('public.pathway_id_seq'::regclass);


--
-- Name: phenotype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype ALTER COLUMN id SET DEFAULT nextval('public.phenotype_id_seq'::regclass);


--
-- Name: ensembl ensembl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensembl
    ADD CONSTRAINT ensembl_pkey PRIMARY KEY (name);


--
-- Name: exac exac_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exac
    ADD CONSTRAINT exac_pkey PRIMARY KEY (id);


--
-- Name: gene_ontology gene_ontology_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gene_ontology
    ADD CONSTRAINT gene_ontology_pkey PRIMARY KEY (id);


--
-- Name: gene gene_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gene
    ADD CONSTRAINT gene_pkey PRIMARY KEY (name);


--
-- Name: go_biological_process go_biological_process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_pkey PRIMARY KEY (name, go_id);


--
-- Name: go_cellular_component go_cellular_component_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_pkey PRIMARY KEY (name, go_id);


--
-- Name: go_molecular_function go_molecular_function_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_pkey PRIMARY KEY (name, go_id);


--
-- Name: pathway pathway_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pathway
    ADD CONSTRAINT pathway_pkey PRIMARY KEY (id);


--
-- Name: phenotype phenotype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype
    ADD CONSTRAINT phenotype_pkey PRIMARY KEY (id);


--
-- Name: go_biological_process go_biological_process_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_biological_process go_biological_process_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: go_cellular_component go_cellular_component_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_cellular_component go_cellular_component_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: go_molecular_function go_molecular_function_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_molecular_function go_molecular_function_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: pathway pathway_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pathway
    ADD CONSTRAINT pathway_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: phenotype phenotype_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype
    ADD CONSTRAINT phenotype_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- PostgreSQL database dump complete
--

