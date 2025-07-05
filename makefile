# Variables personnalisables
IMAGE_NAME = mini-projet-gitlab
IMAGE_TAG = v1
DOCKER_USERNAME = hamzablr
CONTAINER_NAME = mini-projet
SERVER_IP = 192.168.56.10
SSH_USER = vagrant

# -------------------
# 🚧 BUILD
# -------------------
build:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) .

# -------------------
# ☁️ PUSH
# -------------------
push:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

# -------------------
# 🚀 DEPLOY (via SSH)
# -------------------
deploy:
	vagrant ssh -c "\
		docker pull hamzablr/mini-projet-gitlab:v1 && \
		docker stop mini-projet || true && \
		docker rm mini-projet || true && \
		docker run -d -p 80:80 --name mini-projet hamzablr/mini-projet-gitlab:v1 \
	"
	@$(MAKE) healthcheck

healthcheck:
	@echo "🔎 Vérification de la disponibilité de l'application..."
	vagrant ssh -c "\
		sleep 2 && \
		curl -s -o /dev/null -w '%{http_code}' http://localhost | grep 200 && \
		echo '✅ Application OK sur http://localhost' || \
		(echo '❌ Application non disponible'; exit 1) \
	"
# -------------------
# ✅ TEST (curl sur IP VM)
# -------------------
#test:
#curl -I http://$(SERVER_IP) | grep HTTP

# -------------------
# 📜 LOGS
# -------------------
logs:
	ssh $(SSH_USER)@$(SERVER_IP) "docker logs -f $(CONTAINER_NAME)"

# -------------------
# 🔐 COPY SSH KEY
# -------------------
setup-ssh:
	ssh-copy-id -i ~/.ssh/id_rsa.pub $(SSH_USER)@$(SERVER_IP)

# -------------------
# 🔁 BUILD + PUSH + DEPLOY + TEST
# -------------------
all: build push deploy