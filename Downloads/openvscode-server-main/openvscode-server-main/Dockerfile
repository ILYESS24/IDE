# Dockerfile pour OpenVSCode Server sur Render
FROM node:18-bullseye-slim

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire de l'application
WORKDIR /app

# Copier les fichiers de configuration
COPY package*.json ./
COPY render-start.sh ./

# Installer les dépendances
RUN npm ci

# Copier le code source
COPY . .

# Compiler l'application
RUN npm run build

# Exposer le port
EXPOSE 3000

# Commande de démarrage
CMD ["npm", "run", "render-start"]


