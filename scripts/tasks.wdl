task convert_to_bam {
    File input_cram
    String basename
    File ref_cache
    File ref_fasta
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
        disks: "local-disk" + disk_size + " HDD"
        preemptible: preemptible_tries
    }

    output {
        File output_bam = "${basename}.bam"
    }

}
