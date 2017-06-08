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
    "Pre_Merge_SV.aligned_crams" : crams,
    "Pre_Merge_SV.aligned_cram_suffix" : ".recab.cram",
    "Pre_Merge_SV.ref_fasta": "gs://topmed-reference/hs38DH.fa",
    "Pre_Merge_SV.ref_cache": "gs://topmed-reference/hs38DH.cache.tar.gz",

     "##_COMMENT3": "SYSTEM PARAMETERS",
    "Pre_Merge_SV.disk_size": 120,
    "Pre_Merge_SV.preemptible_tries": 3
}

inputs_json = json.dumps(inputs, ensure_ascii = False)

with io.open("inputs_generated.json", "w", encoding = "utf-8") as f:
    f.write(unicode(inputs_json))
