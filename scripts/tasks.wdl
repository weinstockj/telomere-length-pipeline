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

    command {
        ln -s ${input_bam} ${basename}.bam

        # run telseq 
        telseq -o ${basename}.telseq.out ${basename}.bam
    }

    runtime {
        docker: "jweinstk/telseq@sha256:c45a65227b782b7f05846afb926d890476129132baf787f12b4c1cf1ab6650fc"
        cpu: "1"
        memory: "7 GB"
        disks: "local-disk " + disk_size + " HDD" 
        preemptible: preemptible_tries
    }

    output {
        File output_telseq = "${basename}.telseq.out"
    }

}
