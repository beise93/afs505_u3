#!/usr/bin/env nextflow

db_name = file(params.db).name
db_dir = file(params.db).parent

Channel
	.fromPath(params.query)
	.splitFasta(by: params.chunkSize, file:true) 
	.set { fasta_ch }

process blast_job {
   
    input:
    path 'query.fa' from fasta_ch
    path db from db_dir

    output:
    file 'blast_result' into blast_ch
 
    """

    blastp -db $db/$db_name -query query.fa -outfmt 6 -evalue 1e-6 -num_threads ${task.cpus}  > blast_result
    """
}

blast_ch
   .collectFile(name: "blastresults.txt")
   .set { blastresult_ch }

process count {

    publishDir "gene_counts"
	
    input:
    path "blastresults.txt" from blastresult_ch
    path db from db_dir

    output:
    file "gene_counts.txt" into sequences_ch
    
    shell:
    $/
    cat "blastresults.txt" | perl -p -e 's/\.\d+\t/\t/g' | awk '{print $1}' | sort | uniq -c| sort -rn | awk '{print $2"\t"$1}' > gene_counts.txt
    /$ 

}


