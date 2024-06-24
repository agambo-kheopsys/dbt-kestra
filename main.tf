# Fichier main.tf

# Définition du fournisseur GCP
provider "google" {
  project = "kheopsys-lab"
  region  = "us-central1"  # Remplacez par la région souhaitée
}

# Définition de la VM
resource "google_compute_instance" "kestra_vm" {
  name         = "kestra-vm"
  machine_type = "n1-standard-2"  # Remplacez par la taille de la machine souhaitée
  zone         = "us-central1-a"  # Remplacez par la zone souhaitée
  tags         = ["http-server", "https-server", "ssh-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Laisser l'adresse IP à la charge de GCP
    }
  }

  # Script de démarrage pour installer Docker et Docker Compose et démarrer le service Kestra
  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    # sudo apt-get install -y docker.io docker-compose
	
    apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common

    # Ajout de la clé GPG de Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Ajout du dépôt Docker
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Mise à jour et installation de Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    systemctl start docker
    systemctl enable docker

    # Installation de Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # Configuration de Docker pour gcloud
    gcloud auth configure-docker gcr.io

    # Ajout de l'utilisateur courant au groupe docker
    usermod -aG docker $USER


    # Cloner le repository contenant le docker-compose.yml de Kestra
    git clone https://github.com/IkramKheopsys/dbt.git  /opt/kestra

    # Démarrer le service Kestra
    cd /opt/kestra/kestra
    sudo docker-compose up -d
  EOF
}

# Définition de la règle de pare-feu pour autoriser le trafic SSH et les ports 8080 et 8081
resource "google_compute_firewall" "kestra_fw" {
  name    = "allow-kestra-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "8081"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-server", "http-server", "https-server"]
}
