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

task run_computel {
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

        # convert cram to fastq 
        samtools fastq -1 ${basename}.first.fastq -2 ${basename}.second.fastq -0 ${basename}.unpaired.fastq ${basename}.cram 

        # run computel
        computel.sh -1 ${basename}.first.fastq -2 {basename}.second.fastq -proc 2

        ln -s computel_out/tel.length.xls ${basename}.computel.tsv

    >>>

    runtime {
        docker: "jweinstk/computel@sha256:68439728d544779068a64b9b706f5354d7d794f2ec11115f9522a004c9d8a237"
        cpu: "2"
        memory: "7.5 GB"
        disks: "local-disk " + disk_size + " HDD" 
        preemptible: preemptible_tries
    }

    output {
        File output_computel = "${basename}.computel.tsv"
    }
}
