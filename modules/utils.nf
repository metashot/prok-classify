nextflow.enable.dsl=2


process genome_filter {
    publishDir "${params.outdir}" , mode: 'copy'

    input:
    path(gtdb_bac_summary)
    path(gtdb_ar_summary)
    path(genomes)

    output:
    path 'bacteria_genomes'
    path 'archaea_genomes'
    
    script:   
    """
    mkdir genomes_dir
    mv $genomes genomes_dir
    genome_filter.py \
        genomes_dir \
        ./ \
        $gtdb_bac_summary \
        $gtdb_ar_summary
    """
}
