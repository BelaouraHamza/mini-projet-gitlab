Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "deployer"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "GitHub-Deployment-VM"
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "[1/3] Mise à jour du système"
    apt-get update -y && apt-get upgrade -y

    echo "[2/3] Installation de Docker"
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io
    usermod -aG docker vagrant

    echo "[3/3] Docker installé. Récupération possible de ton image depuis Docker Hub"
    echo "→ Connecte-toi avec : vagrant ssh"
    echo "→ Puis fais : docker pull hamzablr/mini-projet-gitlab:v1"
    echo "→ Et lance : docker run -d -p 80:80 --name mini-projet hamzablr/mini-projet-gitlab:v1"
  SHELL
end