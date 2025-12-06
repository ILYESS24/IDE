#!/bin/bash

# Script de démarrage pour Render
echo "🚀 Démarrage d'OpenVSCode Server sur Render..."

# Installer les dépendances
echo "📦 Installation des dépendances..."
npm ci

# Compiler le projet
echo "🔨 Compilation du projet..."
npm run compile

# Télécharger les extensions intégrées
echo "📥 Téléchargement des extensions intégrées..."
npm run download-builtin-extensions

# Démarrer le serveur
echo "🌐 Démarrage du serveur..."
export VSCODE_SERVER_PORT=${PORT:-3000}
export VSCODE_SERVER_HOST=0.0.0.0

# Démarrer le serveur web
exec node out/server-main.js --host 0.0.0.0 --port ${PORT:-3000} --without-connection-token


