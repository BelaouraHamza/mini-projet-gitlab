# Variables personnalisables
IMAGE_NAME = mini-projet-gitlab
IMAGE_TAG = v1
DOCKER_USERNAME = hamzablr
CONTAINER_NAME = mini-projet
SERVER_IP = 192.168.56.10
SSH_USER = vagrant
HOST_PORT = 80
CONTAINER_PORT = 80

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
	ssh $(SSH_USER)@$(SERVER_IP) "\
		docker pull $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) && \
		docker stop $(CONTAINER_NAME) || true && \
		docker rm $(CONTAINER_NAME) || true && \
		docker run -d -p $(HOST_PORT):$(CONTAINER_PORT) --name $(CONTAINER_NAME) $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
	"
	@$(MAKE) healthcheck

# -------------------
# 🔎 HEALTHCHECK avec retry
# -------------------
healthcheck:
	@echo "🔎 Vérification de la disponibilité de l'application..."
	@for i in {1..5}; do \
		status=$$(ssh $(SSH_USER)@$(SERVER_IP) "curl -s -o /dev/null -w '%{http_code}' http://localhost:$(HOST_PORT)"); \
		if [ "$$status" = "200" ]; then \
			echo "✅ Application OK sur http://$(SERVER_IP):$(HOST_PORT)"; \
			exit 0; \
		else \
			echo "⏳ Tentative $$i : Application non disponible, retry..."; \
			sleep 3; \
		fi; \
	done; \
	echo "❌ Application non disponible après plusieurs essais"; exit 1

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
# 🧹 CLEAN local images/containers
# -------------------
clean:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true
	docker rmi $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) || true

# -------------------
# 🔁 BUILD + PUSH + DEPLOY + HEALTHCHECK
# -------------------
all: build push deploy