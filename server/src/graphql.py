# Query basic details for a gene
QUERY_GENE_BASIC = '''
query geneBasic($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        protein_name
        ensembl_id
        uniprot_id
        mgi_id
        ncbi_id
        tags{
            tags
        }
        proteins {
            gene_synonyms
        }
        
        ensembl {
            chromosome_scaffold_name
            start_bp
            end_bp
            transcript_count
            percentage_gc_content
        }
        compartment {
                derived_location   
            }
        function{
            function
        }
    }
}    
'''

# Query gene ontolog details for a gene
QUERY_GENE_GO = '''
query geneGO($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        go_cellular_component {
                    go {
                        id
                        text
                    }
                }
                go_molecular_function {
                    go {
                        id
                        text
                    }
                }
                go_biological_process {
                    go {
                        id
                        text
                    }
                }
    }
}    
'''
# Query exac details for a gene
QUERY_GENE_EXAC = '''
query geneExac($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        exac {
            variant_id
            allele_freq
            allele_num
            allele_count
            major_consequence
            rsid
            HGVSc
            pop_ans
            pop_acs
            hom_count           
        }

    }
}
'''
# Query NHLBI details for a gene
QUERY_GENE_NHLBI = '''
query geneNhlbi($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        nhlbi {
            base_ncbi_37
            rsid
            function_gvs
            hgvs_protein_variant
            hgvs_cdna_variant
            african_american_genotype_count
            european_american_genotype_count
            all_genotype_count
            maf_in_percent_ea_aa_all
            polyphen2_class_score
        }
        
    }
}
'''
# Query phenotype details for a gene
QUERY_GENE_PHENOTYPE = '''
query genePhenotype($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        phenotype {
            mp_id
            mp_def{
                term
                definition
            }
        }      
    }
}
'''
# Query pathways details for a gene
QUERY_GENE_PATHWWAYS = '''
query genePathways($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        pathways {
            data
            external_id
            source
        }
        
    }
}
'''
# Query ppi details for a gene
QUERY_GENE_PPI = '''
query genePpi($name: String!) {
    all_genes: is_cardiomyopathy {
        gene{
            uniprot_id
        }
    }
    gene (where: {name: {_eq: $name}}) {
        name
        ppi_a {
            interactor_b
            interactor_b_full
            taxid_b
            gene_name_b{
                gene_name
            }
        }
        ppi_b {
            interactor_a
            interactor_a_full
            taxid_a
            gene_name_a{
                gene_name
            }
        }
    }
}
'''
# Query drug details for a gene
QUERY_GENE_DRUG = '''
query geneDrug($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        drug_target {
            drug_id
            gene_name
            drug_name {
                common_name
            }
        }
    }
}
'''
# Query CLINVAR details for a gene
QUERY_GENE_CLINVAR = '''
query geneClinvar($name: String!) {
    gene (where: {name: {_eq: $name}}) {
        name
        clinvar {
            hgvsc
            hgvsp
            type
            phenotypelist
            clinical_significance
            phenotypeids
            rs_dbsnp    
        }
    }
}
'''