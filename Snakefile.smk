# Samples
configfile: "script_config.yaml"

# Final result
rule all:
    input:
        expand("rgi_results/raw_{sample}", sample=config["raw_samples"].keys()),
        expand("mmseqs_results/mags_result/result_{sample}.m8", sample=config["mags"].keys()),
        expand("mmseqs_results/contigs_result/result_{sample}.m8", sample=config["contigs"].keys())

# Rule 1: raw_data

# Sample reading function
def get_raw_data(wildcards):
    return script_config["raw_samples"][wildcards.sample]

rule raw_data_rgi:
    input:
        lambda wildcards: get_raw_data(wildcards)
    output:
        "rgi_results/raw_data/rgi_{sample}"
    log:
        "logs/rgi/raw_data/{sample}.log"
    threads: 32
    shell:
        "(rgi bwt --read_one {input[0]} --read_two {input[1]} "
        "--output_file {output} -n {threads} -a kma) 2> {log}"


# Rules 2: MAGS

# Sample reading function
def get_mags(wildcards):
    return script_config["mags"][wildcards.sample]

rule mags_prodigal:
    input:
        lambda wildcards: get_mags(wildcards)
    output:
        coords_gbk="prodigal_results/mags/prodigal_{sample}.coords.gbk"
        protein_faa="prodigal_results/mags/prot_{sample}.faa"
        nucleotid_faa="prodigal_results/mags/nucl_{sample}.faa"
    threads: 32
    shell:
        "prodigal -i {input} -o {output.coords_gbk} -a {output.protein_faa} -d {output.nucleotid_faa}"


rule card_DB:
    input:
        "card-data/protein_fasta_protein_homolog_model.fasta"
    output:
        "mmseqs_results/DB/card_DB"
    threads: 32
    shell:
        "mmseqs createdb {input} {output} --threads {threads}"

rule card_index:
    input:
        "mmseqs_results/DB/card_DB"
    output:
        "mmseqs_results/DB/card_DB.idx"
     params:
        tmpdir=config["tmpdir"]
    shell:
        "mmseqs createindex {input} {params.tmpdir}"


rule sample_mags_DB:
    input:
        "prodigal_results/mags/prot_{sample}.faa"
    output:
        "mmseqs_results/DB/mags/{sample}_DB"
    threads: 32
    shell:
        "mmseqs createdb {input} {output} --threads {threads}"

rule mags_mmseqs:
    input:
        smple_prod="mmseqs_results/DB/mags/{sample}_DB"
        db_index="mmseqs_results/DB/card_DB"
    output:
        "mmseqs_results/mags_res/result_{sample}"
    threads: 32
    params:
        tmpdir=config["tmpdir"]
    log:
        "logs/mmseqs_mags/mags_{sample}.log"
    shell:
        "(mmseqs search {input.smple_prod} {input.db_index} {output} --threads {threads} {params.tmpdir}) 2> {log}"

rule mags_conv:
    input:
        query="mmseqs_results/DB/mags/{sample}_DB"
        target="mmseqs_results/DB/card_DB"
        result="mmseqs_results/mags_res/result_{sample}.m8"
    output:
        "mmseqs_results/mags_result/result_{sample}.m8"
    threads: 32
    params:
        tmpdir=config["tmpdir"]
    shell:
        "mmseqs convertalis {input.query} {input.target} {input.result} {output} {params.tmpdir}"





# Rule 3: Contigs

# Sample reading function
def get_contigs(wildcards):
    return script_config["contigs"][wildcards.sample]

rule contigs_prodigal:
    input:
        lambda wildcards: get_contigs(wildcards)
    output:
        coords_gbk_2="prodigal_results/contigs/prodigal_{sample}.coords.gbk"
        protein_faa_2="prodigal_results/contigs/prot_{sample}.faa"
        nucleotid_faa_2="prodigal_results/contigs/nucl_{sample}.faa"
    threads: 32
    shell:
        "prodigal -i {input} -o {output.coords_gbk_2} -a {output.protein_faa_2} -d {output.nucleotid_faa_2}"

rule sample_contigs_DB:
    input:
        "prodigal_results/contigs/prot_{sample}.faa"
    output:
        "mmseqs_results/DB/contigs/{sample}_DB"
    threads: 32
    shell:
        "mmseqs createdb {input} {output} --threads {threads}"

rule contigs_mmseqs:
    input:
        smple_prod_2="mmseqs_results/DB/contigs/{sample}_DB"
        db_index_2="mmseqs_results/DB/card_DB"
    output:
        "mmseqs_results/contigs_res/result_{sample}"
    threads: 32
    params:
        tmpdir=config["tmpdir"]
    log:
        "logs/mmseqs_contigs/mags_{sample}.log"
    shell:
        "(mmseqs search {input.smple_prod_2} {input.db_index_2} {output} --threads {threads} {params.tmpdir}) 2> {log}"


rule contigs_conv:
    input:
        query_2="mmseqs_results/DB/contigs/{sample}_DB"
        target_2="mmseqs_results/DB/card_DB"
        result_2="mmseqs_results/contigs_res/result_{sample}.m8"
    output:
        "mmseqs_results/contigs_result/result_{sample}.m8"
    threads: 32
    params:
        tmpdir=config["tmpdir"]
    shell:
        "mmseqs convertalis {input.query_2} {input.target_2} {input.result_2} {output} {params.tmpdir}"
