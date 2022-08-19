nextflow.enable.dsl=2

process identify {
    publishDir "${params.outdir}" , mode: 'copy' ,
        pattern: 'gtdbtk/gtdbtk.*'

    input:
    path(genomes)
    path(gtdbtk_db)

    output:
    path "gtdbtk", emit: dir
    path "gtdbtk/*"
       
    script:
    """
    mkdir -p genomes_dir
    mkdir -p tmp
    for genome in $genomes
    do
        mv \$genome genomes_dir/\${genome}.fa
    done
   
    GTDBTK_DATA_PATH=${gtdbtk_db} gtdbtk identify \
        --genome_dir genomes_dir \
        --out_dir gtdbtk \
        -x fa \
        --cpus ${task.cpus} \
        --tmpdir ./tmp
    
    rm -rf ./tmp
    """
}

process align {
    publishDir "${params.outdir}" , mode: 'copy' ,
        pattern: 'gtdbtk/gtdbtk.*'

    input:
    path "identify_dir"
    path(gtdbtk_db)

    output:
    path "gtdbtk", emit: dir
    path "gtdbtk/*"
       
    script:
    """ 
    mkdir -p tmp

    GTDBTK_DATA_PATH=${gtdbtk_db} gtdbtk align \
        --identify_dir identify_dir \
        --out_dir gtdbtk \
        --cpus ${task.cpus} \
        --rnd_seed 42 \
        --tmpdir ./tmp
    
    rm -rf ./tmp
    """
}

process classify {
    publishDir "${params.outdir}" , mode: 'copy' ,
        pattern: 'gtdbtk/gtdbtk.*'
    publishDir "${params.outdir}" , mode: 'copy' ,
        saveAs: { filename ->
            if (filename == "gtdbtk/gtdbtk.bac120.summary.tsv") "bacteria_summary.tsv"
            else if (filename == "gtdbtk/gtdbtk.ar122.summary.tsv") "archaea_summary.tsv"
        }

    input:
    path(genomes)
    path "align_dir"
    path(gtdbtk_db)

    output:
    path "gtdbtk"
    path "gtdbtk/gtdbtk.bac120.summary.tsv", emit: gtdb_bac_summary
    path "gtdbtk/gtdbtk.ar122.summary.tsv", emit: gtdb_ar_summary
       
    // see: https://github.com/Ecogenomics/GTDBTk/issues/124
    script:
    """
    mkdir -p genomes_dir
    mkdir -p tmp
    for genome in $genomes
    do
        mv \$genome genomes_dir/\${genome}.fa
    done

    GTDBTK_DATA_PATH=${gtdbtk_db} gtdbtk classify \
        --genome_dir genomes_dir \
        --align_dir align_dir \
        --out_dir gtdbtk \
        -x fa \
        --cpus ${task.cpus} \
        --pplacer_cpus 1 \
        --tmpdir ./tmp

    if [ ! -f gtdbtk/gtdbtk.bac120.summary.tsv ]; then
        touch gtdbtk/gtdbtk.bac120.summary.tsv
    fi

    if [ ! -f gtdbtk/gtdbtk.ar122.summary.tsv ]; then
        touch gtdbtk/gtdbtk.ar122.summary.tsv
    fi

    rm -rf ./tmp
    """
}
