## Scripts to create gpdb cluster in gcloud using terraform
0. Download Google Cloud SDK and Terraform, add to PATH

https://cloud.google.com/sdk/

https://www.terraform.io/downloads.html

Run
```
gcloud init
```
1. Download GCP service account credential(json)

Console Home -> IAM & admin -> Service accounts

Create your on account, select owner as role.
Download key through "action -> create key"

2. Generate ssh key, add to project wide meta
```
ssh-keygen -f id_rsa -N ''
```
Console Home -> Compute Engine -> Metadata -> SSH Keys

3. Config gpdb setup, enter following values
```
./configure.sh
```
Environment variables will be saved in env.sh

4. Setup GCP resources via terraform 
```
source env.sh
terraform init
terraform apply
```

5. Setup gpdb cluster, etl, and kafka environment
```
source env.sh
./setup.sh
```

6. Connect to GPDB master, etl and kafka environment
```
./login_gpdb.sh
./login_etl.sh
./login_kafka.sh
```

7. Delete all resources after work is done
```
terraform destroy
```
