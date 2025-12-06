FROM node:18-bullseye-slim

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copier le package.json et installer les dépendances
COPY openvscode-server-main/package*.json ./openvscode-server-main/
RUN cd openvscode-server-main && npm ci

# Copier tout le code source
COPY . .

# Compiler OpenVSCode Server
RUN cd openvscode-server-main && npm run compile

# Exposer le port
EXPOSE 3000

# Commande de démarrage
CMD ["node", "openvscode-server-main/out/server-main.js", "--port", "3000", "--host", "0.0.0.0"]
