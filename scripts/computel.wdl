import "tasks.wdl" as T

workflow computel {
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

        call T.run_computel {
            input:
                input_cram = aligned_cram,
                basename = basename,
                ref_cache = ref_cache,
                ref_fasta = ref_fasta,
                ref_fasta_index = ref_fasta_index,
                disk_size = disk_size,
                preemptible_tries = preemptible_tries
        }

    }

    output {
        run_computel.output_computel
    }
}
