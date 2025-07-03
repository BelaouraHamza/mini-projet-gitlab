# 1️⃣ Déclaration d'un argument de version, utilisable dynamiquement
ARG VERSION=latest

# 2️⃣ Image de base légère avec nginx
FROM nginx:${VERSION}

# 3️⃣ Métadonnées utiles
LABEL maintainer="Hamza BLR" \
      org.opencontainers.image.title="Mini Projet GitLab" \
      org.opencontainers.image.description="Image Docker NGINX servant le contenu d’un dépôt GitHub cloné"

# 4️⃣ Installation minimale de git (nécessaire uniquement pour builder l'image)
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# 5️⃣ Déploiement du contenu HTML via git clone
RUN rm -rf /usr/share/nginx/html/* && \
    git clone --depth=1 https://github.com/BelaouraHamza/mini-projet-gitlab.git /usr/share/nginx/html && \
    rm -rf /usr/share/nginx/html/.git

# 6️⃣ Exposition du port HTTP standard
EXPOSE 80

# 7️⃣ Lancement de NGINX en premier plan
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
