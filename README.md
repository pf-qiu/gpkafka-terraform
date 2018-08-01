## Scripts to create gpdb cluster in gcloud using terraform
0. Download Google Cloud SDK and Terraform, add to PATH

https://cloud.google.com/sdk/

https://www.terraform.io/downloads.html

Run
```
gcloud init
```
Login with google account, select the same zone in variable.tf.
Default is us-west1-a.


1. Download GCP service account credential

Console Home -> IAM & admin -> Service accounts

Create your on account, select owner as role.
Download key through "action -> create key"

2. Generate ssh key, add to project wide meta
```
ssh-keygen -f id_rsa -N ''
```
Console Home -> Compute Engine -> Metadata -> SSH Keys

3. Run gen_seg_config.sh with segment number, default is 1
```
NUM_SEGHOSTS=3 ./gen_seg_config.sh
```

4. Setup GCP resources via terraform
```
export GOOGLE_CLOUD_KEYFILE_JSON=secret.json
#export HTTP_PROXY=127.0.0.1
terraform init
terraform apply
```

5. Test GPDB master
```
gcloud compute ssh gpadmin@mdw --ssh-key-file id_rsa
```

6. Run gpdb_setup.sh with segment per host, default is 2
```
SEGMENT_PER_HOST=3 ./gpdb_setup.sh
```

7. Delete all resources after work is done
```
terraform destroy
```

## TODOs

1. Add prefix to resource names to prevent conflict.

2. Add tf definition to setup kafka cluster and etl server.

3. Add storage disk to segment hosts, modify init_config dir locations.
