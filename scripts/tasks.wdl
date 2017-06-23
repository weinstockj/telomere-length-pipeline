task convert_to_bam {
    File input_cram
    String basename
    File ref_cache
    File ref_fasta
    File ref_fasta_index
    Int disk_size
    Int preemptible_tries

    command {
        ln -s ${input_cram} ${basename}.cram

        # build reference cache
        tar -zxf ${ref_cache}
        export REF_CACHE=./md5/%2s/%2s/%s

        # convert cram to bam
        samtools view -T ${ref_fasta} -b -o ${basename}.bam ${basename}.cram
    }

    runtime {
        docker: "jweinstk/samtools@sha256:8b804951435fc321b9bc178e555b63ec022392ebdbb31df2a98385e6335d77cf"
        cpu: "1"
        memory: "5 GB"
        disks: "local-disk " + disk_size + " HDD" 
        preemptible: preemptible_tries
    }

    output {
        File output_bam = "${basename}.bam"
    }

}

task run_telseq {
    File input_bam 
    String basename
    Int disk_size
    Int preemptible_tries

    command <<< 
        ln -s ${input_bam} ${basename}.bam
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
