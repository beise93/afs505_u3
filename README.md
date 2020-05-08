# AFS 505 Unit 3 Project

This project utilizes a nextflow pipeline and the NCBI similarity tool BLAST to generate a simple text file from any given FASTA file that lists the number of gene sequences in descending order. 

## Get Started 
You will need to install Nextflow and Blast. Java 8 or later is also required to run the pipeline.

### Tools
* [Nextflow](https://www.nextflow.io/)
* [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) 
* [JAVA](https://www.java.com/en/download/) Version 8 or later

## Project Instructions
### 1: Setup the config file
In using this pipeline you will need to setup a ```nextflow.config``` file to store parameters for which our pipeline will use. In creating this config file you are storing parameters for inputs, output and so forth that our workflow script will reference. We will also place our nextflow directives in this file. This is an important step in allowing nextflow to launch jobs on our exectuor or any other workload manager like Slurm. Placing directives and params in a config file also allows us to simply change these features, such as the number of CPUS to run our script, without having to edit our script. Also, it is much simpler to place this file into the same directory as the Nextflow script. Currently, the config file is set up to split the fasta file into chunks of 5000.
##### Example .config file
``` groovy
params{
  sample_glob = "${params.base_dir}/*_{1,2}.fasta"
  db = "/data/ficklin_class/AFS505/course_material/data/swissprot"
  chunkSize = 5000
}
profiles {
  slurm {
    process {
      executor = "slurm"
     
      withName:blast_job {
        cpus = 5
	module = "blast/2.7.1"
      }
    }
  }
}

```
### 2: Nextflow script
After setting up the nextflow config file you can get started on creating the actual nextflow script to create the workflow sript. Although Nextflow scripting utilizes the Groovy programming language you can create also use scripts that are in other scripting languages that are supported by Linux. My script uses only BASH commands to create the summary file of gene matches from the blast results so that genes are in the first column and the number of matches are in the second.

### 3: SLURM script
This project uses Washington State University's Kamiak to launch the workflow script. The script tells Kamiak which modules (Nextflow and Java) it needs to load for our workflow script and then runs the Nextflow script with our profile configuration that we created in the config file. 
```
ml nextflow/20.01.0
ml java/1.8.0
nextflow run project3.nf -profile slurm
```

The ```#SBATCH``` script directives can be tailored to suit user preferences.

### 4: Launching the job
To run our workflow we submit our SLURM script to Kamiak using:
``` 
sbatch project_3.srun 
```
There's no other commands needed. Our Nextflow script will handle the execution of the other jobs using Kamiak on our behalf.

To launch the workflow without using using the job submission script, but still using Kamiak, a user would need to make sure they have both Nextflow and Java available, be on an idev session, and then use the command: 

```
nextflow run project3.nf -profile slurm
```
This alternative is not recommended however, as your idev session may run out before workflow is fully completed.
## Author
**Brian Eisenbarth**

## Acknowledgements 
Dr. Stephen Ficklin for helping figure out the code.
