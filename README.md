# prok-classify

metashot/prok-classify is a workflow for assigning objective taxonomic
classifications to bacterial and archaeal genomes using
[GTDB-Tk](https://github.com/Ecogenomics/GTDBTk) and the Genome Database
Taxonomy GTDB.

- [MetaShot Home](https://metashot.github.io/)

## Main features

- Input: prokaryotic genomes in FASTA format;
- Taxonomic classification using
  [GTDB-TK](https://github.com/Ecogenomics/GTDBTk);
- Filter genomes by domain (Bacteria and Achaea).

## Quick start

1. Install Docker (or Singulariry) and Nextflow (see
   [Dependences](https://metashot.github.io/#dependencies));
1. Download and extract/unzip the GTDB-TK reference data (see
   https://ecogenomics.github.io/GTDBTk/installing/index.html#gtdb-tk-reference-data):

   ```bash
   wget https://data.ace.uq.edu.au/public/gtdb/data/releases/release95/95.0/auxillary_files/gtdbtk_r95_data.tar.gz
   tar xvzf gtdbtk_r95_data.tar.gz
   ```
1. Start running the analysis:

   ```bash
   nextflow run metashot/prok-classify \
     --genomes "data/*.fa" \
     --gtdbtk_db ./release95 \
     --outdir results
   ```

## Parameters
See the file [`nextflow.config`](nextflow.config) for the complete list of
parameters.

## Output
The files and directories listed below will be created in the `results` directory
after the pipeline has finished.

### Main outputs
- `bacteria_summary.tsv`: the GTDB-Tk summary for bacterial genomes
  ([documentation](https://ecogenomics.github.io/GTDBTk/files/summary.tsv.html));
- `archaea_summary.tsv`: the GTDB-Tk summary for archaeal genomes
  ([documentation](https://ecogenomics.github.io/GTDBTk/files/summary.tsv.html));
- `bacteria_genomes`: genomes classified as bacteria by GTDB-Tk;
- `archaea_genomes`: genomes classified as archaea by GTDB-Tk.

### Secondary outputs
- `gtdbtk`: main gtdb output files
  ([documentation](https://ecogenomics.github.io/GTDBTk/files/index.html)).

## System requirements
Please refer to [System
requirements](https://metashot.github.io/#system-requirements) for the complete
list of system requirements options.
