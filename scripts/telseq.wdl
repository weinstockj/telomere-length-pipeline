import "tasks.wdl" as T

workflow telseq {
    File ref_fasta
    File ref_cache
    Int disk_size
    Int preemptible_tries

    Array[File] aligned_crams
    String aligned_cram_suffix

    scatter (aligned_cram in aligned_crams) {

        String basename = sub(sub(aligned_cram, "^.*/", ""), aligned_cram_suffix + "$", "")

        call T.convert_to_bam {
            input:
                input_cram = aligned_cram,
                basename = basename,
                ref_cache = ref_cache,
                ref_fasta = ref_fasta,
                disk_size = disk_size,
                preemptible_tries = preemptible_tries
        }

    }

    output {
        convert_to_bam.output_bam
    }
}
