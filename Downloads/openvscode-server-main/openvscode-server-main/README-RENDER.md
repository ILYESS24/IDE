# Déploiement d'OpenVSCode Server sur Render

Ce guide explique comment déployer OpenVSCode Server sur Render.

## Méthodes de déploiement

### Méthode 1: Via render.yaml (Recommandée)

1. **Connectez votre dépôt GitHub à Render**
   - Allez sur [render.com](https://render.com)
   - Créez un nouveau service "Web Service"
   - Connectez votre dépôt GitHub

2. **Configuration automatique**
   - Render détectera automatiquement le fichier `render.yaml`
   - Les paramètres suivants seront appliqués :
     - Runtime: Node.js
     - Build Command: `echo 'Build handled by start script'`
     - Start Command: `chmod +x render-start.sh && ./render-start.sh`

3. **Variables d'environnement**
   Les variables suivantes sont automatiquement configurées :
   - `PORT`: Port assigné par Render
   - `VSCODE_SERVER_HOST`: `0.0.0.0`
   - `NODE_ENV`: `production`

### Méthode 2: Configuration manuelle

Si render.yaml n'est pas détecté, configurez manuellement :

- **Runtime**: Node.js
- **Build Command**: `npm ci && npm run build`
- **Start Command**: `npm start`
- **Port**: Automatique (variable $PORT)

## Configuration supplémentaire

### Variables d'environnement optionnelles

```bash
# Pour les fonctionnalités Git
GITHUB_TOKEN=votre_token_github

# Pour personnaliser l'URL du marketplace d'extensions
VSCODE_EXTENSIONS_GALLERY_SERVICE_URL=https://marketplace.visualstudio.com/_apis/public/gallery
```

### Ressources requises

- **RAM**: Minimum 1GB (recommandé 2GB+)
- **CPU**: 1 CPU minimum
- **Stockage**: 2GB minimum

## Accès à votre instance

Une fois déployé, votre OpenVSCode Server sera accessible via l'URL fournie par Render.

**URL par défaut**: `https://votreservice.onrender.com`

## Dépannage

### Problèmes courants

1. **Timeout lors du build**
   - Augmentez les ressources (RAM/CPU)
   - Le build peut prendre 10-15 minutes

2. **Erreur de compilation**
   - Vérifiez que toutes les dépendances sont installées
   - Assurez-vous d'avoir assez de RAM

3. **Extensions non chargées**
   - Le script télécharge automatiquement les extensions intégrées
   - Vérifiez les logs pour les erreurs

### Logs

Consultez les logs Render pour diagnostiquer les problèmes :
- Build logs
- Runtime logs
- Console errors

## Sécurité

- Le serveur démarre avec `--without-connection-token` pour un accès public
- Configurez une authentification appropriée si nécessaire
- Utilisez HTTPS (fourni automatiquement par Render)

## Support

Pour les problèmes spécifiques à Render :
- Documentation Render: https://docs.render.com/
- Issues GitHub: https://github.com/gitpod-io/openvscode-server/issues


