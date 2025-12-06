# 🔍 Diagnostic et Résolution des Problèmes Render

## Problème Principal : Render utilise le mauvais Dockerfile

### Symptômes
- Les logs montrent `FROM python:3.11-slim` au lieu de `FROM rust:1.91.1-bookworm`
- Erreur : `ERROR: requirements.txt not found` avec `*aurora_ai*`
- Le build échoue avant même de compiler Rust

### Cause
Render utilise une configuration manuelle incorrecte au lieu de lire le `render.yaml` ou le `Dockerfile` à la racine.

## ✅ Solution Étape par Étape

### Étape 1 : Vérifier la Configuration dans Render Dashboard

1. Allez sur [dashboard.render.com](https://dashboard.render.com)
2. Cliquez sur votre service `zed-collab`
3. Allez dans **Settings** (en haut à droite)

### Étape 2 : Corriger la Section "Build & Deploy"

Dans **Build & Deploy**, vérifiez **EXACTEMENT** :

| Paramètre | Valeur Correcte | ❌ Valeur Incorrecte |
|-----------|----------------|---------------------|
| **Dockerfile Path** | `./Dockerfile` ou **vide** | `./Dockerfile-collab-render` ou autre |
| **Docker Context** | `.` (point) | Autre valeur |
| **Runtime** | `Docker` | `Node`, `Python`, etc. |
| **Build Command** | **VIDE** (géré par Dockerfile) | `pip install` ou autre |
| **Start Command** | **VIDE** (géré par Dockerfile) | `python` ou autre |

### Étape 3 : Supprimer les Configurations Incorrectes

**Supprimez complètement** :
- Toute ligne "Build Command" qui contient `pip`, `python`, `npm`, etc.
- Toute ligne "Start Command" qui contient `python`, `node`, etc.
- Toute référence à `requirements.txt`

### Étape 4 : Sauvegarder et Redéployer

1. Cliquez sur **"Save Changes"** en bas de la page
2. Allez dans l'onglet **"Manual Deploy"**
3. Cliquez sur **"Clear build cache & deploy"**

### Étape 5 : Vérifier les Logs

Après le redéploiement, les **premières lignes** des logs doivent montrer :

```
✅ FROM rust:1.91.1-bookworm as builder
✅ WORKDIR /app
✅ COPY . .
✅ RUN apt-get update && apt-get install -y --no-install-recommends cmake
✅ cargo build --release --package collab
```

**Si vous voyez encore** :
```
❌ FROM python:3.11-slim
❌ pip install -r requirements.txt
❌ ERROR: requirements.txt not found
```

→ Le problème persiste, passez à la solution alternative ci-dessous.

## 🔄 Solution Alternative : Recréer le Service

Si la correction manuelle ne fonctionne pas :

### Option A : Supprimer et Recréer via Blueprint

1. **Supprimez complètement** le service `zed-collab` actuel
   - Settings → Danger Zone → Delete Service

2. **Recréez via Blueprint** :
   - Dashboard → "New +" → "Blueprint"
   - Connectez votre dépôt : `ILYESS24/ZEDAURION`
   - Render détectera automatiquement `render.yaml`
   - Cliquez sur "Apply"

3. **Configurez les variables d'environnement** :
   - `DATABASE_URL` : Copiez l'Internal Database URL de `zed-postgres`
   - `API_TOKEN` : Générez un token (voir ci-dessous)

### Option B : Créer Manuellement avec les Bonnes Configurations

1. Dashboard → "New +" → "Web Service"
2. Connectez votre dépôt Git
3. **Configuration EXACTE** :
   ```
   Name: zed-collab
   Region: oregon
   Branch: main
   Root Directory: / (vide)
   Runtime: Docker
   Dockerfile Path: ./Dockerfile
   Docker Context: .
   Plan: starter (ou standard)
   ```
4. **NE PAS** ajouter de Build Command ou Start Command
5. Configurez les variables d'environnement (voir ci-dessous)

## 🔑 Configuration des Variables d'Environnement

### Variables Obligatoires

1. **DATABASE_URL**
   - Allez dans votre base de données `zed-postgres`
   - Copiez l'**Internal Database URL**
   - Format : `postgresql://user:password@host:port/dbname`
   - Collez dans `DATABASE_URL`

2. **API_TOKEN**
   - Générez un token sécurisé :
   ```powershell
   $chars = '0123456789abcdef'; $token = ''; for ($i=0; $i -lt 64; $i++) { $token += $chars[(Get-Random -Maximum $chars.Length)] }; Write-Host $token
   ```
   - Collez le token dans `API_TOKEN`

### Variables Déjà Configurées (dans render.yaml)

Ces variables sont automatiquement définies si vous utilisez Blueprint :
- `HTTP_PORT=10000`
- `DATABASE_MAX_CONNECTIONS=20`
- `INVITE_LINK_PREFIX=https://zed.dev/invite/`
- `ZED_ENVIRONMENT=production`
- `RUST_LOG=info`
- `LOG_JSON=true`

## 🐛 Autres Problèmes Possibles

### Problème : Build échoue avec "Out of Memory"

**Solution** :
- Passez au plan **Standard** (1 GB) au lieu de Starter (512 MB)
- Dans Settings → Plan → Changez à "Standard"

### Problème : Erreur "Failed to bind TCP listener"

**Solution** :
- Vérifiez que `HTTP_PORT=10000` est défini
- Render injecte automatiquement `PORT`, mais le serveur utilise `HTTP_PORT`

### Problème : Erreur de connexion à la base de données

**Vérifications** :
- `DATABASE_URL` utilise l'**Internal Database URL** (pas External)
- La base de données est dans la même région (oregon)
- La base de données est "Available" (pas "Paused")

### Problème : Service démarre mais ne répond pas

**Vérifications** :
- Health check : `https://votre-service.onrender.com/healthz`
- Devrait retourner : `{"status":"ok"}`
- Vérifiez les logs pour les erreurs

## 📋 Checklist de Vérification

Avant de déployer, vérifiez :

- [ ] Le service utilise `Runtime: Docker`
- [ ] `Dockerfile Path` est `./Dockerfile` ou vide
- [ ] `Docker Context` est `.`
- [ ] Pas de Build Command ou Start Command
- [ ] `DATABASE_URL` est défini (Internal Database URL)
- [ ] `API_TOKEN` est défini (token de 64 caractères)
- [ ] La base de données est dans la même région
- [ ] Le plan est au moins Starter (512 MB)

## 🆘 Si Rien Ne Fonctionne

1. **Vérifiez que le Dockerfile existe** :
   ```bash
   git ls-files | grep Dockerfile
   ```
   Devrait montrer : `Dockerfile`

2. **Vérifiez le contenu du Dockerfile** :
   - Première ligne doit être : `FROM rust:1.91.1-bookworm`
   - Pas de référence à Python

3. **Contactez le support Render** :
   - Avec les logs de build
   - Expliquez que Render utilise un Dockerfile Python qui n'existe pas

## 📞 Support

Si le problème persiste après avoir suivi toutes ces étapes, le problème vient probablement d'une configuration Render qui n'est pas visible dans l'interface. Dans ce cas, supprimez complètement le service et recréez-le via Blueprint.

