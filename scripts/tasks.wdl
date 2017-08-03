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
        set -e pipefail

        ln -s ${input_cram} ${basename}.cram

        # build reference cache
        tar -zxf ${ref_cache}
        export REF_CACHE=./md5/%2s/%2s/%s

        # convert cram to bam
        echo "now converting cram->bam"
        date
        samtools view -T ${ref_fasta} -b -o ${basename}.bam ${basename}.cram
        date

        # convert bam to fastq 
        echo "now converting to bam->fastq"
        date
        samtools fastq -1 ${basename}.first.fastq -2 ${basename}.second.fastq -0 ${basename}.unpaired.fastq ${basename}.bam 
        date

        # run computel
        echo "now running computel"
        date
        computel.sh -1 ${basename}.first.fastq -2 ${basename}.second.fastq -proc 2
        date

        ln -s computel_out/tel.length.xls ${basename}.computel.tsv

    >>>

    runtime {
        docker: "jweinstk/computel@sha256:adda0198a4a8d155b83c1500c7ed9b9713459e0e2461dcbaf4a9e5726e71dda8"
        cpu: "2"
        memory: "7.5 GB"
        disks: "local-disk " + disk_size + " HDD" 
        preemptible: preemptible_tries
    }

    output {
        File output_computel = "${basename}.computel.tsv"
    }
}

task run_count_telomeres_short {
    File input_cram
    String basename
    File ref_cache
    File ref_fasta
    File ref_fasta_index
    Int disk_size
    Int preemptible_tries

    command <<< 
        set -e pipefail

        ln -s ${input_cram} ${basename}.cram

        # build reference cache
        tar -zxf ${ref_cache}
        export REF_CACHE=./md5/%2s/%2s/%s

        date
        samtools view -T ${ref_fasta} ${input_cram} | 
            awk '{print $10}' |
            ./opt/count-telomeres-short > ${basename}.tcount
    >>>

    runtime {
        docker: "jweinstk/count-telomeres-short:latest"
        cpu: "1"
        memory: "6.5 GB"
        disks: "local-disk " + disk_size + " HDD" 
        preemptible: preemptible_tries
    }

    output {
        File output_count_telomeres_short = "${basename}.tcount"
    }
}
