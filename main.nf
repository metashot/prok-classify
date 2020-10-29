#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { gtdbtk } from './modules/gtdbtk'
include { genome_filter } from './modules/utils'

workflow {
    
    Channel
        .fromPath( params.genomes )
        .set { genomes_ch }

    gtdbtk_db = file(params.gtdbtk_db, type: 'dir')

    gtdbtk(genomes_ch.collect(), gtdbtk_db)
    
    genome_filter(gtdbtk.out.gtdb_bac_summary, 
        gtdbtk.out.gtdb_ar_summary, genomes_ch.collect())

}
