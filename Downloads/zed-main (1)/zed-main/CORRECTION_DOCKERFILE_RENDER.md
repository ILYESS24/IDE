# 🚨 CORRECTION URGENTE - Render utilise le mauvais Dockerfile

## Problème

Render utilise un Dockerfile Python (`FROM python:3.11-slim`) qui **n'existe pas dans votre dépôt**. Ce Dockerfile cherche `requirements.txt` avec `*aurora_ai*`, ce qui n'a rien à voir avec Zed.

**Votre Dockerfile à la racine est correct** (Rust), mais Render ne l'utilise pas.

## Solution : Corriger dans le Dashboard Render

### Étape 1 : Vérifier la configuration du service

1. Allez sur [dashboard.render.com](https://dashboard.render.com)
2. Cliquez sur votre service `zed-collab`
3. Allez dans **"Settings"** (en haut à droite)

### Étape 2 : Corriger la section "Build & Deploy"

Dans la section **"Build & Deploy"**, vérifiez et corrigez :

1. **Dockerfile Path** : 
   - ❌ Ne doit PAS être vide ou pointer vers un autre fichier
   - ✅ Doit être : `./Dockerfile` (ou laissez vide pour utiliser le Dockerfile à la racine)

2. **Docker Context** :
   - ✅ Doit être : `.` (point)

3. **Runtime** :
   - ✅ Doit être : `Docker`

### Étape 3 : Supprimer les configurations incorrectes

Si vous voyez des configurations comme :
- `Build Command` avec `pip install`
- `Start Command` avec Python
- Autres références à Python ou `requirements.txt`

**Supprimez-les** car le Dockerfile gère tout automatiquement.

### Étape 4 : Sauvegarder et redéployer

1. Cliquez sur **"Save Changes"** en bas de la page
2. Allez dans l'onglet **"Manual Deploy"**
3. Cliquez sur **"Clear build cache & deploy"**

## Vérification

Après le redéploiement, les logs doivent montrer :
- ✅ `FROM rust:1.91.1-bookworm` (pas Python)
- ✅ `cargo build --release --package collab`
- ✅ Pas de recherche de `requirements.txt` ou `aurora_ai`

## Si le problème persiste

Si Render continue d'utiliser le mauvais Dockerfile :

1. **Supprimez complètement le service** `zed-collab`
2. **Recréez-le** en utilisant le **Blueprint** (`render.yaml`) :
   - Dans Render Dashboard → "New +" → "Blueprint"
   - Connectez votre dépôt `ILYESS24/ZEDAURION`
   - Render créera automatiquement le service avec la bonne configuration

## Variables d'environnement à configurer

Une fois le build réussi, configurez ces variables dans le service :

```
DATABASE_URL=<Internal Database URL de zed-postgres>
API_TOKEN=<token généré>
HTTP_PORT=10000
DATABASE_MAX_CONNECTIONS=20
INVITE_LINK_PREFIX=https://zed.dev/invite/
ZED_ENVIRONMENT=production
RUST_LOG=info
LOG_JSON=true
```

