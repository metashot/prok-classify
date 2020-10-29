nextflow.enable.dsl=2

// Params:
//     - outdir
process gtdbtk {
    publishDir "${params.outdir}" , mode: 'copy'
    publishDir "${params.outdir}" , mode: 'copy' ,
        saveAs: { filename ->
            if (filename == "gtdbtk/gtdbtk.bac120.summary.tsv") "bacteria_summary.tsv"
            else if (filename == "gtdbtk/gtdbtk.ar122.summary.tsv") "archaea_summary.tsv"
        }

    input:
    path(genomes)
    path(gtdbtk_db)
   
    output:
    path "gtdbtk/gtdbtk.*"
    path "gtdbtk/gtdbtk.bac120.summary.tsv", optional: true, emit: gtdb_bac_summary
    path "gtdbtk/gtdbtk.ar122.summary.tsv", optional: true, emit: gtdb_ar_summary
   
    script:
    """
    mkdir -p genomes_dir
    for genome in $genomes
    do
        mv \$genome genomes_dir/\${genome}.fa
    done
   
    GTDBTK_DATA_PATH=${gtdbtk_db} gtdbtk classify_wf \
        --genome_dir genomes_dir \
        --out_dir gtdbtk \
        -x fa \
        --cpus ${task.cpus} \
        --pplacer_cpus ${task.cpus}
    """
}