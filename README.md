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

### Code Explanation (run_docker_container.yml)

This YAML configuration defines a Kestra flow named `run_docker_container` within the `my_namespace` namespace. Here's what each section does:

#### Tasks:

##### 1. Run Docker Container
- **ID:** `run`
- **Type:** Docker plugin task (`io.kestra.plugin.docker.Run`)
- **Description:** This task runs a Docker container using the image `gcr.io/kheopsys-lab/dbt-snapshot:alpha.1.4`. It sets the environment variable `DBT_PROJECT_DIR` to `/app`.
- **Pull Policy:** `ALWAYS` to ensure the latest version of the image is used.

##### 2.Data Ingestion (Airbyte)

ID: data-ingestion
Type: Airbyte connection sync task (io.kestra.plugin.airbyte.connections.Sync)
Description: Cette tâche exécute une synchronisation de données à l'aide d'Airbyte. Elle utilise l'ID de connexion fourni (52d1dbdf-3b3a-4956-b681-d8f617935509) pour se connecter à l'instance Airbyte spécifiée par l'URL (http://34.70.229.77:8000). Les informations d'identification nécessaires (nom d'utilisateur et mot de passe) sont également fournies 

##### 3. Outputs Metrics
- **ID:** `outputs_metrics`
- **Type:** Python script (`io.kestra.plugin.scripts.python.Commands`)
- **Description:** This task executes a Python script (`outputs.py`) inside a Docker container (`python:slim` image). Before executing the script, it installs the `requests` library using `pip`. This script is responsible for generating outputs metrics.
- **Namespace Files:** Enabled to allow access to files within the namespace.
- **Warning on StdErr:** Disabled (`false`).
- **Commands:** Executes the Python script (`outputs.py`).

#### Triggers:
###### Hourly Trigger
- **ID:** `hourly`
- **Type:** Schedule trigger (`io.kestra.plugin.core.trigger.Schedule`)
- **Schedule:** Runs the flow hourly (`@hourly`).
  
![image](https://github.com/agambo-kheopsys/dbt-kestra/assets/113558455/6e3edb14-b64f-40c3-854e-929cfa225c30)
![image](https://github.com/agambo-kheopsys/dbt-kestra/assets/113558455/dc2d0749-3063-4154-8e34-7ef33bef31e9)


**Note** : You can find this implementation on : http://34.173.202.213:8080/ui/flows




