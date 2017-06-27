task run_telseq {
    File input_cram
    String basename
    File ref_cache
    File ref_fasta
    File ref_fasta_index
    Int disk_size
    Int preemptible_tries

    command <<< 
        ln -s ${input_cram} ${basename}.cram

        # build reference cache
        tar -zxf ${ref_cache}
        export REF_CACHE=./md5/%2s/%2s/%s

        # convert cram to bam
        samtools view -T ${ref_fasta} -b -o ${basename}.bam ${basename}.cram

        read_length=$(samtools view ${basename}.bam | awk '{print length($10)}' | head -1000 | sort -u | sort -r | tail -n1)

        echo "read length is: $read_length"
        # run telseq 
        telseq -u -o ${basename}.telseq.out -r $read_length ${basename}.bam
    >>> 

    runtime {
        docker: "jweinstk/telseq@sha256:bd828851e83bf13f097591e5935989287b87ce8de1e75f117ac95f09e9967d76"
        cpu: "1"
        memory: "7 GB"
        disks: "local-disk " + disk_size + " HDD" 
        preemptible: preemptible_tries
    }

    output {
        File output_telseq = "${basename}.telseq.out"
    }

}
