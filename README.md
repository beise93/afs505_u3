# AFS 505 Unit 3 Project

This project utilizes a nextflow pipeline and the NCBI similarity tool BLAST to generate a simple text file from any given FASTA file that lists the number of gene sequences in descending order. 

## Get Started 
You will need to install Nextflow and Blast. Java 8 or later is also required to run the pipeline.

### Tools
-[Nextflow](https://www.nextflow.io/)
-[BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) 
-[JAVA](https://www.java.com/en/download/) Version 8 or later

## Project Instructions
### First Steps: 
#### creating the config file
In creating this pipeline you will need to create a ```nextflow.config``` file to store parameters for which our pipeline will use. In creating this config file you are storing parameters for inputs, output and so forth that our workflow script will reference. We will also place our nextflow directives in this file. This is an important step in allowing nextflow to launch jobs on our exectuor or any other workload manager like Slurm. Placing directives and params in a config file also allows us to simply change these features without having to edit our script.
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
#### Nextflow script
After creating a nextflow config file you can get started on creating the actual nextflow script to create the workflow sript. Although Nextflow scripting utilizes the Groovy programming language you can create scripts mixing by using any other scripting language that is supported by Linux. Essentially a Nextflow script is made up of different processes that communicate through *channels*: sending outputs and receiving inputs. These processes can be written in the programming language you are most familiar with. Aside from the Groovy syntax that Nextflow uses this project utilizes only basic Linux commands such as ```grep``` and ```sed``` to create the processes necessary to get the results.

## Author
**Brian Eisenbarth**
