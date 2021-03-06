#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { identify; align; classify } from './modules/gtdbtk'
include { genome_filter } from './modules/utils'

workflow {
    
    Channel
        .fromPath( params.genomes )
        .set { genomes_ch }

    gtdbtk_db = file(params.gtdbtk_db, type: 'dir', checkIfExists: true)

    // gtdb-tk pipeline (classify_wf)
    identify(genomes_ch.collect(), gtdbtk_db)
    align(identify.out.dir, gtdbtk_db)
    classify(genomes_ch.collect(), align.out.dir, gtdbtk_db)

    genome_filter(classify.out.gtdb_bac_summary, 
        classify.out.gtdb_ar_summary, genomes_ch.collect())

}
