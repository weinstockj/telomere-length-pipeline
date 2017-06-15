from google.cloud import storage
import json
import io

BUCKET_NAME = "topmed-test-crams"
BUCKET_URL = "gs://topmed-test-crams/"

storage_client = storage.Client()
test_crams = storage_client.get_bucket(BUCKET_NAME)
# not running on all crams...
NUMBER_OF_TEST_CRAMS = 3

crams = [BUCKET_URL + cram.name for cram in test_crams.list_blobs()]
crams = crams[:NUMBER_OF_TEST_CRAMS]

inputs = {
    "telseq.aligned_crams" : crams,
    "telseq.aligned_cram_suffix" : ".recab.cram",
    "telseq.ref_fasta": "gs://topmed-reference/hs38DH.fa",
    "telseq.ref_fasta_index": "gs://topmed-reference/hs38DH.fa.fai",
    "telseq.ref_cache": "gs://topmed-reference/hs38DH.cache.tar.gz",

     "##_COMMENT3": "SYSTEM PARAMETERS",
    "telseq.disk_size": 200,
    "telseq.preemptible_tries": 2
}

inputs_json = json.dumps(inputs, ensure_ascii = False)

with io.open("inputs_generated.json", "w", encoding = "utf-8") as f:
    f.write(unicode(inputs_json))
