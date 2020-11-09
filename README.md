# metashot/prok-classify

## Introduction
metashot/gtdbtk is a workflow for assigning objective taxonomic classifications
to bacterial and archaeal genomes using
[GTDB-TK](https://github.com/Ecogenomics/GTDBTk) and the Genome Database
Taxonomy GTDB.

## Main features

- Input: prokaryotic genomes in FASTA format;
- Taxonomic classification using
  [GTDB-TK](https://github.com/Ecogenomics/GTDBTk);
- Filter genomes by domain (Bacteria and Achaea).

## Quick start
1. Install [Nextflow](https://www.nextflow.io/) and
   [Docker](https://www.docker.com/);
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

See the file [`nextflow.config`](nextflow.config) for the complete list of
parameters.

## Output
Several files and directories will be created in the `results` folder.

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
Each step in the pipeline has a default set of requirements for number of CPUs,
memory and time. For some of the steps in the pipeline, if the job exits with an
error it will automatically resubmit with higher requests (see
[`process.config`](process.config)).

You can customize the compute resources that the pipeline requests by either:
- setting the global parameters `--max_cpus`, `--max_memory` and
  `--max_time`, or
- creating a [custom config
  file](https://www.nextflow.io/docs/latest/config.html#configuration-file)
  (`-c` or `-C` parameters), or
- modifying the [`process.config`](process.config) file.

## Reproducibility
We recommend to specify a pipeline version when running the pipeline on your
data with the `-r` parameter:

```bash
  nextflow run metashot/kraken2 -r 1.0.0
    ...
```

Moreover, this workflow uses the docker images available at
https://hub.docker.com/u/metashot/ for reproducibility. You can check the
version of the software used in the workflow by opening the file
[`process.config`](process.config). For example `container =
metashot/kraken2:2.0.9-beta-6` means that the version of kraken2 is the
`2.0.9-beta` (the last number, 6, is the metashot release of this container).

## Singularity
If you want to use [Singularity](https://singularity.lbl.gov/) instead of Docker,
comment the Docker lines in [`nextflow.config`](nextflow.config) and add the following:

```nextflow
singularity.enabled = true
singularity.autoMounts = true
```

## Credits
This workflow is maintained by Davide Albanese and Claudio Donati at the [FEM's
Unit of Computational
Biology](https://www.fmach.it/eng/CRI/general-info/organisation/Chief-scientific-office/Computational-biology).
