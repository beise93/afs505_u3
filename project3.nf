#!/usr/bin/env nextflow
/*
 * Sets the default pipeline input parameters given the params in the config file.
 * Parameters can be changed in the config file.
 */
db_name = file(params.db).name
db_dir = file(params.db).parent
/*
 * From the given query parameter this process creates the channel 'fasta_ch' whose output
 * is the fasta file(s) split into chunksize specified in the config file.
 */
Channel
	.fromPath(params.query)
	.splitFasta(by: params.chunkSize, file:true)
	.set { fasta_ch }
/* This process takes as input the chunks from the fasta_ch channel and outputs each of the BLAST results into
 * a file "blast_result into the blast_ch.
 */
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
/* Collects all of the 'blast_result' files into a single file called 'blastresults.txt' and
 * assigns the file to the blastresult_ch channel
 */
blast_ch
   .collectFile(name: "blastresults.txt")
   .set { blastresult_ch }
/* Receives the "blastresults.txt" file and counts the number of gene sequences, sorting them in descending
 * order and placing them into the "gene_counts.txt' file using bash commmands, this is a tab-delimited summary file
 * of those results with two columns. The file is published into the "gene_counts" directory for simpler access.
 */
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
