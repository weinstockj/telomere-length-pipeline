import "tasks.wdl" as T

workflow telseq {
    File ref_fasta
    File ref_fasta_index
    File ref_cache
    Int disk_size
    Int preemptible_tries

    File aligned_crams_file
    Array[File] aligned_crams = read_lines(aligned_crams_file)
    String aligned_cram_suffix

    scatter (aligned_cram in aligned_crams) {

        String basename = sub(sub(aligned_cram, "^.*/", ""), aligned_cram_suffix + "$", "")

        call T.convert_to_bam as convert_to_bam {
            input:
                input_cram = aligned_cram,
                basename = basename,
                ref_cache = ref_cache,
                ref_fasta = ref_fasta,
                ref_fasta_index = ref_fasta_index,
                disk_size = disk_size,
                preemptible_tries = preemptible_tries
        }

        call T.run_telseq {
            input:
                basename = basename,
                disk_size = disk_size,
                preemptible_tries = preemptible_tries,
                input_bam = convert_to_bam.output_bam
        }

    }

    output {
        run_telseq.output_telseq
    }
}
