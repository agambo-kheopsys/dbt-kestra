# Kestra Installation Guide

## Local Database Installation

To install Kestra with a local database, run the following commands:

```sh
curl -o docker-compose.yml https://raw.githubusercontent.com/kestra-io/kestra/develop/docker-compose.yml
docker-compose up -d
```

Access the server via localhost:8080 or localhost:8081.

For detailed installation guidance, refer to the installation guide: https://kestra.io/docs/installation/docker-compose

## External Database Configuration (OVH)
If you want to connect Kestra to an external database (OVH), refer to our configuration file available in our GitHub repository: External DB Configuration.

To start the Kestra server with an external database configuration:

Download the main.tf file: [main.tf.](https://github.com/kheopsys/dbt-airflow/blob/main/airflow/kestra/main.tf)

Run the following Terraform commands:
```sh
terraform init
terraform plan
terraform apply
```
Access the interface via externaladdress:8080 

**Note**: If you want to modify the main.tf to load the docker-compose.yaml that contains the local database, replace the following lines:

Clone the repository containing the docker-compose.yml for Kestra:

```sh
git clone https://github.com/IkramKheopsys/dbt.git /opt/kestra
```
Start the Kestra service:
```sh
cd /opt/kestra/kestra
curl -o docker-compose.yml https://raw.githubusercontent.com/kestra-io/kestra/develop/docker-compose.yml
```

Once you are in the Kestra UI, navigate to Flows and then Editor. Copy the contents of **run_docker_container.yml**, save it, and then execute it.

![image](https://github.com/agambo-kheopsys/dbt-kestra/assets/113558455/8a5c075b-2706-4b0f-bb53-a9dfa4b18793)




