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
-- Name: clinvar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clinvar (
    allele_id text NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    gene_id text NOT NULL,
    gene_symbol text,
    hgnc_id text NOT NULL,
    clinical_significance text NOT NULL,
    clinsig_simple text NOT NULL,
    lastevaluated text NOT NULL,
    rs_dbsnp text NOT NULL,
    nsv_esv_dbvar text NOT NULL,
    rcvaccession text NOT NULL,
    phenotypeids text NOT NULL,
    phenotypelist text NOT NULL,
    origin text NOT NULL,
    originsimple text NOT NULL,
    assembly text NOT NULL,
    chromosome_accession text NOT NULL,
    chromosome text NOT NULL,
    start text NOT NULL,
    stop text NOT NULL,
    reference_allele text NOT NULL,
    alternate_allele text,
    cytogenetic text NOT NULL,
    review_status text NOT NULL,
    numbersubmitters text NOT NULL,
    guidelines text,
    testedingtr text NOT NULL,
    otherids text NOT NULL,
    submittercategories text NOT NULL,
    variation_id text NOT NULL
);


ALTER TABLE public.clinvar OWNER TO postgres;

--
-- Name: clinvar_mat; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.clinvar_mat AS
 SELECT DISTINCT clinvar.gene_symbol,
    clinvar.type,
    clinvar.rs_dbsnp,
    clinvar.phenotypelist,
    clinvar.phenotypeids,
    clinvar.clinical_significance,
    btrim("substring"("substring"(clinvar.name, '.*[c][.](.+).*'::text), '.*\((.+)\).*'::text)) AS hgvsp,
    btrim(split_part("substring"(clinvar.name, '.*([c][.].+).*'::text), '('::text, 1)) AS hgvsc
   FROM public.clinvar
  WITH NO DATA;


ALTER TABLE public.clinvar_mat OWNER TO postgres;

--
-- Name: clinvar_derived; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clinvar_derived AS
 SELECT clinvar_mat.gene_symbol,
    clinvar_mat.type,
    clinvar_mat.rs_dbsnp,
    clinvar_mat.phenotypelist,
    clinvar_mat.phenotypeids,
    clinvar_mat.clinical_significance,
    clinvar_mat.hgvsp,
    clinvar_mat.hgvsc
   FROM public.clinvar_mat;


ALTER TABLE public.clinvar_derived OWNER TO postgres;

--
-- Name: compartment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compartment (
    ensembl_id text,
    gene_name text,
    go_id text,
    location text,
    source text,
    acquired text,
    score integer,
    id integer NOT NULL,
    derived_location text
);


ALTER TABLE public.compartment OWNER TO postgres;

--
-- Name: compartment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compartment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.compartment_id_seq OWNER TO postgres;

--
-- Name: compartment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compartment_id_seq OWNED BY public.compartment.id;


--
-- Name: david; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.david (
    gene text NOT NULL,
    category text NOT NULL,
    term text NOT NULL,
    count integer NOT NULL,
    percent numeric NOT NULL,
    pvalue numeric NOT NULL,
    list_total integer NOT NULL,
    pop_hits integer NOT NULL,
    pop_tot integer NOT NULL,
    fold_enrichment numeric NOT NULL,
    bonferroni numeric NOT NULL,
    benjamini numeric NOT NULL,
    id integer NOT NULL,
    term_def text
);


ALTER TABLE public.david OWNER TO postgres;

--
-- Name: david_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.david_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.david_id_seq OWNER TO postgres;

--
-- Name: david_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.david_id_seq OWNED BY public.david.id;


--
-- Name: drug; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drug (
    drug_type text NOT NULL,
    drug_name text NOT NULL,
    drug_product text NOT NULL,
    drugbank_id text NOT NULL,
    drug_type_id integer
);


ALTER TABLE public.drug OWNER TO postgres;

--
-- Name: drug_target; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.drug_target OWNER TO postgres;

--
-- Name: drug_target_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.drug_target_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_target_id_seq OWNER TO postgres;

--
-- Name: drug_target_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.drug_target_id_seq OWNED BY public.drug_target.id;


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
    uniprot_id text,
    ncbi_id integer,
    ensembl_id text NOT NULL,
    mgi_id text,
    protein_name text,
    hgnc_id text
);


ALTER TABLE public.gene OWNER TO postgres;

--
-- Name: phenotype_impc; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.phenotype_impc OWNER TO postgres;

--
-- Name: phenotype_mgi; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.phenotype_mgi OWNER TO postgres;

--
-- Name: gene_mp_id; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE public.gene_mp_id OWNER TO postgres;

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
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    tags text,
    gene_name text NOT NULL,
    source text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: is_cardiomyopathy; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.is_cardiomyopathy AS
 SELECT DISTINCT tags.gene_name
   FROM public.tags
  WHERE (tags.tags IS NOT NULL);


ALTER TABLE public.is_cardiomyopathy OWNER TO postgres;

--
-- Name: nhlbi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nhlbi (
    base_ncbi_37 text NOT NULL,
    rsid text NOT NULL,
    dbsnp_version text,
    alleles text NOT NULL,
    european_american_allele_count text NOT NULL,
    african_american_allele_count text NOT NULL,
    allallele_count text NOT NULL,
    maf_in_percent_ea_aa_all text NOT NULL,
    european_american_genotype_count text NOT NULL,
    african_american_genotype_count text NOT NULL,
    all_genotype_count text NOT NULL,
    avg_sample_read_depth text NOT NULL,
    genes text NOT NULL,
    gene_accession text NOT NULL,
    function_gvs text NOT NULL,
    hgvs_protein_variant text,
    hgvs_cdna_variant text NOT NULL,
    coding_dna_size text NOT NULL,
    conservation_score_phastcons text NOT NULL,
    conservation_scoregerp text NOT NULL,
    grantham_score text,
    polyphen2_class_score text NOT NULL,
    ref_base_ncbi37 text NOT NULL,
    chimp_allele text NOT NULL,
    clinical_info text NOT NULL,
    filter_status text NOT NULL,
    onillumina_humanexomechip text NOT NULL,
    gwas_pubmedinfo text NOT NULL,
    "ea-estimated_age_kyrs" text,
    "aa-estimated_age_kyrs" text,
    grch38_position text NOT NULL,
    gene_name text NOT NULL
);


ALTER TABLE public.nhlbi OWNER TO postgres;

--
-- Name: nlhbi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nlhbi (
);


ALTER TABLE public.nlhbi OWNER TO postgres;

--
-- Name: pathway; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pathway (
    name text NOT NULL,
    data text NOT NULL,
    external_id text NOT NULL,
    source text NOT NULL
);


ALTER TABLE public.pathway OWNER TO postgres;

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
-- Name: phenotype_def; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phenotype_def (
    mp_id text NOT NULL,
    term text NOT NULL,
    definition text NOT NULL
);


ALTER TABLE public.phenotype_def OWNER TO postgres;

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
-- Name: phenotype_impc_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phenotype_impc_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phenotype_impc_no_seq OWNER TO postgres;

--
-- Name: phenotype_impc_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phenotype_impc_no_seq OWNED BY public.phenotype_impc.no;


--
-- Name: phenotype_mgi_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phenotype_mgi_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phenotype_mgi_no_seq OWNER TO postgres;

--
-- Name: phenotype_mgi_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phenotype_mgi_no_seq OWNED BY public.phenotype_mgi.no;


--
-- Name: ppi; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.ppi OWNER TO postgres;

--
-- Name: ppi_raw; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.ppi_raw OWNER TO postgres;

--
-- Name: ppi_derived; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ppi_derived AS
 SELECT "substring"(ppi_raw.id_interactor_a, 11, 6) AS interactor_a,
    "substring"(ppi_raw.id_interactor_b, 11, 6) AS interactor_b,
    "substring"(ppi_raw.id_interactor_a, 11, char_length(ppi_raw.id_interactor_a)) AS interactor_a_full,
    "substring"(ppi_raw.id_interactor_b, 11, char_length(ppi_raw.id_interactor_a)) AS interactor_b_full,
    ppi_raw.interaction_type,
    ppi_raw.publication_identifier,
    ppi_raw.taxid_interactor_a,
    "substring"(ppi_raw.taxid_interactor_a, '.*\((.+)\)\|.*\(.*\)'::text) AS taxid_a,
    "substring"(ppi_raw.taxid_interactor_b, '.*\((.+)\)\|.*\(.*\)'::text) AS taxid_b,
    ppi_raw.interaction_identifier
   FROM public.ppi_raw
  WHERE ((ppi_raw.id_interactor_a ~~ 'uniprotkb:%'::text) AND (ppi_raw.id_interactor_b ~~ 'uniprotkb:%'::text));


ALTER TABLE public.ppi_derived OWNER TO postgres;

--
-- Name: ppi_ppi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ppi_ppi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ppi_ppi_id_seq OWNER TO postgres;

--
-- Name: ppi_ppi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ppi_ppi_id_seq OWNED BY public.ppi.ppi_id;


--
-- Name: ppi_raw_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ppi_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ppi_raw_id_seq OWNER TO postgres;

--
-- Name: ppi_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ppi_raw_id_seq OWNED BY public.ppi_raw.id;


--
-- Name: protein; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protein (
    ensemble_id text NOT NULL,
    uniprot_id text NOT NULL,
    entry_name text NOT NULL,
    protein text NOT NULL,
    gene_synonyms text NOT NULL,
    no integer NOT NULL
);


ALTER TABLE public.protein OWNER TO postgres;

--
-- Name: protein_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.protein_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.protein_no_seq OWNER TO postgres;

--
-- Name: protein_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.protein_no_seq OWNED BY public.protein.no;


--
-- Name: source; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.source AS
 SELECT DISTINCT t.gene_name,
    t.source
   FROM public.tags t;


ALTER TABLE public.source OWNER TO postgres;

--
-- Name: tags_derived; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.tags_derived AS
 SELECT DISTINCT tags.tags,
    tags.gene_name
   FROM public.tags
  WHERE (tags.tags IS NOT NULL);


ALTER TABLE public.tags_derived OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: compartment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compartment ALTER COLUMN id SET DEFAULT nextval('public.compartment_id_seq'::regclass);


--
-- Name: david id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.david ALTER COLUMN id SET DEFAULT nextval('public.david_id_seq'::regclass);


--
-- Name: drug_target id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug_target ALTER COLUMN id SET DEFAULT nextval('public.drug_target_id_seq'::regclass);


--
-- Name: exac id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exac ALTER COLUMN id SET DEFAULT nextval('public.exac_id_seq'::regclass);


--
-- Name: phenotype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype ALTER COLUMN id SET DEFAULT nextval('public.phenotype_id_seq'::regclass);


--
-- Name: phenotype_impc no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype_impc ALTER COLUMN no SET DEFAULT nextval('public.phenotype_impc_no_seq'::regclass);


--
-- Name: phenotype_mgi no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype_mgi ALTER COLUMN no SET DEFAULT nextval('public.phenotype_mgi_no_seq'::regclass);


--
-- Name: ppi ppi_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ppi ALTER COLUMN ppi_id SET DEFAULT nextval('public.ppi_ppi_id_seq'::regclass);


--
-- Name: ppi_raw id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ppi_raw ALTER COLUMN id SET DEFAULT nextval('public.ppi_raw_id_seq'::regclass);


--
-- Name: protein no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protein ALTER COLUMN no SET DEFAULT nextval('public.protein_no_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: clinvar clinvar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinvar
    ADD CONSTRAINT clinvar_pkey PRIMARY KEY (name, assembly, rcvaccession, chromosome_accession);


--
-- Name: compartment compartment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compartment
    ADD CONSTRAINT compartment_pkey PRIMARY KEY (id);


--
-- Name: david david_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.david
    ADD CONSTRAINT david_pkey PRIMARY KEY (id);


--
-- Name: drug drug_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_pkey PRIMARY KEY (drugbank_id);


--
-- Name: drug_target drug_target_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug_target
    ADD CONSTRAINT drug_target_pkey PRIMARY KEY (id);


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
-- Name: nhlbi nhlbi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nhlbi
    ADD CONSTRAINT nhlbi_pkey PRIMARY KEY (base_ncbi_37, rsid, gene_accession, hgvs_cdna_variant);


--
-- Name: pathway pathway_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pathway
    ADD CONSTRAINT pathway_pkey PRIMARY KEY (name, data, external_id);


--
-- Name: phenotype_def phenotype_def_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype_def
    ADD CONSTRAINT phenotype_def_pkey PRIMARY KEY (mp_id);


--
-- Name: phenotype_impc phenotype_impc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype_impc
    ADD CONSTRAINT phenotype_impc_pkey PRIMARY KEY (no);


--
-- Name: phenotype_mgi phenotype_mgi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype_mgi
    ADD CONSTRAINT phenotype_mgi_pkey PRIMARY KEY (no);


--
-- Name: phenotype phenotype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype
    ADD CONSTRAINT phenotype_pkey PRIMARY KEY (id);


--
-- Name: ppi ppi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ppi
    ADD CONSTRAINT ppi_pkey PRIMARY KEY (ppi_id);


--
-- Name: ppi_raw ppi_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ppi_raw
    ADD CONSTRAINT ppi_raw_pkey PRIMARY KEY (id);


--
-- Name: protein protein_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protein
    ADD CONSTRAINT protein_pkey PRIMARY KEY (no);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tags tags_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_unique UNIQUE (tags, gene_name, source);


--
-- Name: gene unique_uniprot_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gene
    ADD CONSTRAINT unique_uniprot_id UNIQUE (uniprot_id);


--
-- Name: data_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX data_index ON public.pathway USING btree (data);


--
-- Name: drug_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX drug_name_index ON public.drug USING btree (drug_name);


--
-- Name: drug_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX drug_type_index ON public.drug USING btree (drug_type);


--
-- Name: drugbank_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX drugbank_id_index ON public.drug USING btree (drugbank_id);


--
-- Name: ensembl_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ensembl_index ON public.gene USING btree (ensembl_id);


--
-- Name: exac_ensembl_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX exac_ensembl_id_index ON public.exac USING btree (ensembl_id);


--
-- Name: gene_symbol_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gene_symbol_index ON public.clinvar USING btree (gene_symbol);


--
-- Name: gene_syn_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gene_syn_index ON public.protein USING btree (gene_synonyms);


--
-- Name: name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX name_index ON public.gene USING btree (name);


--
-- Name: uniprot_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX uniprot_index ON public.gene USING btree (uniprot_id);


--
-- Name: go_biological_process go_biological_process_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_biological_process
    ADD CONSTRAINT go_biological_process_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_cellular_component go_cellular_component_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_cellular_component
    ADD CONSTRAINT go_cellular_component_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: go_molecular_function go_molecular_function_go_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_molecular_function
    ADD CONSTRAINT go_molecular_function_go_id_fkey FOREIGN KEY (go_id) REFERENCES public.gene_ontology(id);


--
-- Name: phenotype phenotype_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenotype
    ADD CONSTRAINT phenotype_name_fkey FOREIGN KEY (name) REFERENCES public.gene(name);


--
-- PostgreSQL database dump complete
--

