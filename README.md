## Estimate telomere lengths on WGS data

This is a simple pipeline for taking in a list of CRAM files, converting them to BAM files, and then using 
[telseq](https://github.com/zd1/telseq) for telomere length estimation. The pipeline uses [cromwell](https://github.com/broadinstitute/cromwell) as the workflow tool. The computational backend is intended to be google compute, which uses the google pipelines / job-execution-as-service API to launch jobs in docker containers. Docker containers for this pipeline can be found here 
[docker hub](https://hub.docker.com/u/jweinstk/). This pipeline is under heavy development and is not recommended for
production use. Alternative methods for telomere length estimation will be added in the future.  

The hall-lab [sv-pipeline](https://github.com/hall-lab/sv-pipeline) was a valuable reference to consult. 

