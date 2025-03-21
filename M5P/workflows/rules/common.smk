#!/usr/bin/python3

#----------------------------------------------------------------------------#
#
# Microbiome Insights | Snakemake pipeline for microbial characterization
#
#----------------------------------------------------------------------------#

def COLLECT_ALL_INPUT():
    INPUTS = []
    if config["experiment_type"] == "metagenomics":
        #Config outputs for metagenomics
        INPUTS.append(os.path.join(working_dir, "samples.tsv")) #rule atlas_init
        if merged_reads:
            INPUTS.append(os.path.join(working_dir, "logs/concatReads.log"))
        INPUTS.append(os.path.join(working_dir, "logs/formatSamples.log"))
        INPUTS.append(os.path.join(working_dir, "finished_genecatalog"))
        INPUTS.append(os.path.join(working_dir, "finished_genomes"))
        INPUTS.append(os.path.join(working_dir, "finished_DRAM")) # DRAM
        INPUTS.append(os.path.join(working_dir, "finished_bakta")) # bakta
        INPUTS.append(os.path.join(working_dir, "finished_referenceseeker")) # referenceseeker
        INPUTS.append(os.path.join(working_dir, "finished_metagenomics_cleanup")) #cleanup
    if config["experiment_type"] == "metatranscriptomics":
        #Config outputs for metatranscriptomics
        INPUTS.append(os.path.join(working_dir, "logs/create_grist_config_file.log"))
        INPUTS.append(os.path.join(working_dir, "finished_grist")) #grist
        INPUTS.append(os.path.join(working_dir, "cleaned_after_grist")) # clean after grist
        INPUTS.append(os.path.join(working_dir, "finished_DRAM_annotate_reference_genomes")) # Annotate grist reference genomes
        INPUTS.append(os.path.join(working_dir, "finished_salmon_index"))
        INPUTS.append(os.path.join(working_dir, "finished_salmon_quant"))
        INPUTS.append(os.path.join(working_dir, "salmon/counts.tsv")) # All mapping to salmon
        INPUTS.append(os.path.join(working_dir, "logs/Praxis_cleanup.log"))

    return INPUTS

def COLLECT_INIT_INPUT():
    INPUTS = []
    INPUTS.append(fastq_metagenomics)
    if merged_reads:
        INPUTS.append(os.path.join(working_dir, "logs/concatReads.log"))
    return INPUTS

def COLLECT_FORMAT_ARGS():
    if bin_all:
        binarg = "--all"
    else:
        binarg = ""
    if metadata_path:
        return f"-s {os.path.join(working_dir, 'samples.tsv')} -m {metadata_path} {binarg}"
    else:
        return f"-s {os.path.join(working_dir, 'samples.tsv')} {binarg}"

def COLLECT_SALMON_REFERENCE():
    INPUTS=[]
    if "metagenomics" in config["experiment_type"]:
        #Config outputs for metagenomics
        INPUTS.append(os.path.join(working_dir, "Genecatalog/gene_catalog.fna")) #rule atlas_genecatalog
    elif config["experiment_type"] == "metatranscriptomics":
        #Config outputs for metatranscriptomics
        INPUTS.append(os.path.join(working_dir, "reference_genomes/annotations/genes.fna")) #grist
