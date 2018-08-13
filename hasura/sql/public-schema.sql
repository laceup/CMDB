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
-- Name: drug; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug (
    drug_type text NOT NULL,
    drug_name text NOT NULL,
    drug_product text NOT NULL,
    drugbank_id text NOT NULL
);


--
-- Name: drug_target; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drug_target (
    uniprot_id text NOT NULL,
    protein_name text NOT NULL,
    gene_name text,
    genebank_protein_id text,
    genebank_gene_id text,
    uniprot_title text NOT NULL,
    pbd_id text,
    geneatlas_id text,
    hgnc_id text,
    drug_id text NOT NULL,
    id integer NOT NULL
);


--
-- Name: drug_target_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drug_target_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_target_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drug_target_id_seq OWNED BY public.drug_target.id;


--
-- Name: ensembl; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: exac; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: exac_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exac_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exac_id_seq OWNED BY public.exac.id;


--
-- Name: gene; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene (
    name text NOT NULL,
    uniprot_id text NOT NULL,
    ncbi_id integer,
    ensembl_id text NOT NULL,
    mgi_id text,
    protein_name text,
    hgnc_id text
);


--
-- Name: phenotype_impc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phenotype_impc (
    mgi_accession_id text NOT NULL,
    marker_symbol text NOT NULL,
    human_gene_symbol text NOT NULL,
    marker_synonym text NOT NULL,
    marker_name text NOT NULL,
    mp_id text NOT NULL,
    no integer NOT NULL
);


--
-- Name: phenotype_mgi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phenotype_mgi (
    human_marker_symbol text NOT NULL,
    human_entrenz_gene_id text NOT NULL,
    homologene_id text,
    hgnc_association text NOT NULL,
    mouse_marker_symbol text NOT NULL,
    mgi_marker_accession_id text NOT NULL,
    mp_id text,
    no integer NOT NULL
);


--
-- Name: gene_mp_id; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.gene_mp_id AS
 SELECT DISTINCT gene_mp_id.gene,
    gene_mp_id.mp_id
   FROM ( SELECT phenotype_impc.human_gene_symbol AS gene,
            phenotype_impc.mp_id
           FROM public.phenotype_impc
          WHERE ((phenotype_impc.mp_id IS NOT NULL) AND (phenotype_impc.mp_id <> ''::text))
        UNION
         SELECT phenotype_mgi.human_marker_symbol AS gene,
            phenotype_mgi.mp_id
           FROM public.phenotype_mgi
          WHERE ((phenotype_mgi.mp_id IS NOT NULL) AND (phenotype_mgi.mp_id <> ''::text))) gene_mp_id;


--
-- Name: gene_ontology; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gene_ontology (
    id text NOT NULL,
    text text NOT NULL
);


--
-- Name: go_biological_process; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.go_biological_process (
    name text NOT NULL,
    go_id text NOT NULL
);


--
-- Name: go_cellular_component; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.go_cellular_component (
    name text NOT NULL,
    go_id text NOT NULL
);


--
-- Name: go_molecular_function; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.go_molecular_function (
    name text NOT NULL,
    go_id text NOT NULL
);


--
-- Name: pathway; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pathway (
    name text NOT NULL,
    data text NOT NULL,
    external_id text NOT NULL,
    source text NOT NULL
);


--
-- Name: phenotype; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: phenotype_def; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phenotype_def (
    mp_id text NOT NULL,
    term text NOT NULL,
    definition text NOT NULL
);


--
-- Name: phenotype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phenotype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phenotype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phenotype_id_seq OWNED BY public.phenotype.id;


--
-- Name: phenotype_impc_no_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phenotype_impc_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phenotype_impc_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phenotype_impc_no_seq OWNED BY public.phenotype_impc.no;


--
-- Name: phenotype_mgi_no_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phenotype_mgi_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phenotype_mgi_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phenotype_mgi_no_seq OWNED BY public.phenotype_mgi.no;


--
-- Name: ppi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ppi (
    interactor_a text NOT NULL,
    a_extra text,
    interactor_b text NOT NULL,
    b_extra text,
    interaction_detection_method text NOT NULL,
    idm_definition text NOT NULL,
    publication_1st_author text NOT NULL,
    publication_id text NOT NULL,
    ppi_id integer NOT NULL
);


--
-- Name: ppi_ppi_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ppi_ppi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ppi_ppi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ppi_ppi_id_seq OWNED BY public.ppi.ppi_id;


--
-- Name: ppi_raw; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ppi_raw (
    id_interactor_a text NOT NULL,
    id_interactor_b text,
    alt_id_interactor_a text,
    alt_id_interactor_b text,
    alias_interactor_a text,
    alias_interactor_b text,
    interaction_detection_method text,
    publication_1st_author text,
    publication_identifier text,
    taxid_interactor_a text,
    taxid_interactor_b text,
    interaction_type text,
    source_database text,
    interaction_identifier text,
    confidence_value text,
    expansion_method text,
    biological_role_interactor_a text,
    biological_role_interactor_b text,
    experimental_role_interactor_a text,
    experimental_role_interactor_b text,
    type_interactor_a text,
    type_interactor_b text,
    xref_interactor_a text,
    xref_interactor_b text,
    interaction_xref text,
    annotation_interactor_a text,
    annotation_interactor_b text,
    interaction_annotation text,
    host_organism text,
    interaction_parameter text,
    creation_date text,
    update_date text,
    checksum_interactor_a text,
    checksum_interactor_b text,
    interaction_checksum text,
    negative text,
    feature_interactor_a text,
    feature_interactor_b text,
    stoichiometry_interactor_a text,
    stoichiometry_interactor_b text,
    identification_method_participant_a text,
    identification_method_participant_b text,
    id integer NOT NULL
);


--
-- Name: ppi_raw_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ppi_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ppi_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ppi_raw_id_seq OWNED BY public.ppi_raw.id;


--
-- Name: protein; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protein (
    ensemble_id text NOT NULL,
    uniprot_id text NOT NULL,
    entry_name text NOT NULL,
    protein text NOT NULL,
    gene_synonyms text NOT NULL,
    no integer NOT NULL
);


--
-- Name: protein_no_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protein_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protein_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protein_no_seq OWNED BY public.protein.no;


--
-- Name: drug_target id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_target ALTER COLUMN id SET DEFAULT nextval('public.drug_target_id_seq'::regclass);


--
-- Name: exac id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exac ALTER COLUMN id SET DEFAULT nextval('public.exac_id_seq'::regclass);


--
-- Name: phenotype id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype ALTER COLUMN id SET DEFAULT nextval('public.phenotype_id_seq'::regclass);


--
-- Name: phenotype_impc no; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype_impc ALTER COLUMN no SET DEFAULT nextval('public.phenotype_impc_no_seq'::regclass);


--
-- Name: phenotype_mgi no; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype_mgi ALTER COLUMN no SET DEFAULT nextval('public.phenotype_mgi_no_seq'::regclass);


--
-- Name: ppi ppi_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ppi ALTER COLUMN ppi_id SET DEFAULT nextval('public.ppi_ppi_id_seq'::regclass);


--
-- Name: ppi_raw id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ppi_raw ALTER COLUMN id SET DEFAULT nextval('public.ppi_raw_id_seq'::regclass);


--
-- Name: protein no; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protein ALTER COLUMN no SET DEFAULT nextval('public.protein_no_seq'::regclass);


--
-- Name: drug drug_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_pkey PRIMARY KEY (drugbank_id);


--
-- Name: drug_target drug_target_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drug_target
    ADD CONSTRAINT drug_target_pkey PRIMARY KEY (id);


--
-- Name: ensembl ensembl_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ensembl
    ADD CONSTRAINT ensembl_pkey PRIMARY KEY (name);


--
-- Name: exac exac_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exac
    ADD CONSTRAINT exac_pkey PRIMARY KEY (id);


--
-- Name: gene_ontology gene_ontology_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene_ontology
    ADD CONSTRAINT gene_ontology_pkey PRIMARY KEY (id);


--
-- Name: gene gene_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gene
    ADD CONSTRAINT gene_pkey PRIMARY KEY (name);


--
-- Name: go_biological_process go_biological_process_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_pkey PRIMARY KEY (name, go_id);


--
-- Name: go_cellular_component go_cellular_component_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_pkey PRIMARY KEY (name, go_id);


--
-- Name: go_molecular_function go_molecular_function_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_pkey PRIMARY KEY (name, go_id);


--
-- Name: pathway pathway_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pathway
    ADD CONSTRAINT pathway_pkey PRIMARY KEY (name, data, external_id);


--
-- Name: phenotype_def phenotype_def_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype_def
    ADD CONSTRAINT phenotype_def_pkey PRIMARY KEY (mp_id);


--
-- Name: phenotype_impc phenotype_impc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype_impc
    ADD CONSTRAINT phenotype_impc_pkey PRIMARY KEY (no);


--
-- Name: phenotype_mgi phenotype_mgi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype_mgi
    ADD CONSTRAINT phenotype_mgi_pkey PRIMARY KEY (no);


--
-- Name: phenotype phenotype_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype
    ADD CONSTRAINT phenotype_pkey PRIMARY KEY (id);


--
-- Name: ppi ppi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ppi
    ADD CONSTRAINT ppi_pkey PRIMARY KEY (ppi_id);


--
-- Name: ppi_raw ppi_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ppi_raw
    ADD CONSTRAINT ppi_raw_pkey PRIMARY KEY (id);


--
-- Name: protein protein_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protein
    ADD CONSTRAINT protein_pkey PRIMARY KEY (no);


--
-- Name: exac_ensembl_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exac_ensembl_id_index ON public.exac USING btree (ensembl_id);


--
-- Name: go_biological_process go_biological_process_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_biological_process go_biological_process_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: go_cellular_component go_cellular_component_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_cellular_component go_cellular_component_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: go_molecular_function go_molecular_function_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_molecular_function go_molecular_function_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- Name: phenotype phenotype_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phenotype
    ADD CONSTRAINT phenotype_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- PostgreSQL database dump complete
--

