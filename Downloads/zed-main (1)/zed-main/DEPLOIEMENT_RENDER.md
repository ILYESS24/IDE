# 🚀 Guide de Déploiement Zed Collab sur Render

Guide complet pour déployer le serveur de collaboration Zed sur Render.

## 📋 Prérequis

- Compte Render ([render.com](https://render.com))
- Dépôt Git (GitHub/GitLab/Bitbucket) avec ce code
- Compréhension de base de Docker et PostgreSQL

## 🎯 Déploiement Rapide (5 minutes)

### Option 1 : Via Blueprint (Recommandé)

1. **Connecter le dépôt**
   - [dashboard.render.com](https://dashboard.render.com) → "New +" → "Blueprint"
   - Connectez votre dépôt `ILYESS24/ZEDAURION`
   - Render détectera automatiquement `render.yaml`

2. **Configurer les variables d'environnement**
   - Dans le service `zed-collab` → Settings → Environment Variables
   - Ajoutez :
     ```
     DATABASE_URL=<Internal Database URL de zed-postgres>
     API_TOKEN=<générez un token avec: openssl rand -hex 32>
     ```
   - Les autres variables sont déjà définies dans `render.yaml`

3. **Déployer**
   - Render créera automatiquement le service et la base de données
   - Le build prendra 15-20 minutes (compilation Rust)

### Option 2 : Déploiement Manuel

1. **Créer la base de données PostgreSQL**
   - Dashboard → "New +" → "PostgreSQL"
   - Name: `zed-postgres`
   - Plan: Starter (256 MB) ou Standard (1 GB)
   - Region: oregon (ou votre région)
   - Notez l'**Internal Database URL**

2. **Créer le service web**
   - Dashboard → "New +" → "Web Service"
   - Connectez votre dépôt Git
   - Configuration :
     - **Name**: `zed-collab`
     - **Runtime**: `Docker`
     - **Dockerfile Path**: `./Dockerfile`
     - **Docker Context**: `.`
     - **Plan**: Starter (512 MB) ou Standard (1 GB)
     - **Region**: Même région que la base de données

3. **Variables d'environnement**
   ```
   HTTP_PORT=10000
   DATABASE_URL=<Internal Database URL de zed-postgres>
   API_TOKEN=<générez un token>
   DATABASE_MAX_CONNECTIONS=20
   INVITE_LINK_PREFIX=https://zed.dev/invite/
   ZED_ENVIRONMENT=production
   RUST_LOG=info
   LOG_JSON=true
   ```

4. **Générer API_TOKEN**
   ```bash
   # PowerShell
   $chars = '0123456789abcdef'; $token = ''; for ($i=0; $i -lt 64; $i++) { $token += $chars[(Get-Random -Maximum $chars.Length)] }; Write-Host $token
   
   # Ou en ligne: https://www.random.org/strings/
   ```

## 🔧 Configuration des Variables d'Environnement

### Variables Obligatoires

| Variable | Description | Exemple |
|----------|-------------|---------|
| `DATABASE_URL` | URL de connexion PostgreSQL | `postgresql://user:pass@host:port/dbname` |
| `API_TOKEN` | Token d'authentification API | `cf58186cc42dc488989479cc4219ce56...` |

### Variables Optionnelles

| Variable | Valeur par défaut | Description |
|----------|-------------------|-------------|
| `HTTP_PORT` | `10000` | Port HTTP du serveur |
| `DATABASE_MAX_CONNECTIONS` | `20` | Nombre max de connexions DB |
| `INVITE_LINK_PREFIX` | `https://zed.dev/invite/` | Préfixe pour les liens d'invitation |
| `ZED_ENVIRONMENT` | `production` | Environnement de déploiement |
| `RUST_LOG` | `info` | Niveau de log (error, warn, info, debug) |
| `LOG_JSON` | `true` | Format JSON pour les logs |

## 🚨 Résolution de Problèmes

### Problème : Render utilise un Dockerfile Python au lieu de Rust

**Symptômes** : Les logs montrent `FROM python:3.11-slim` et cherchent `requirements.txt` avec `*aurora_ai*`

**Cause** : Render utilise un Dockerfile Python qui n'existe pas dans votre dépôt. Votre Dockerfile à la racine est correct (Rust), mais Render ne l'utilise pas.

**Solution** :
1. Service `zed-collab` → Settings → Build & Deploy
2. Vérifiez et corrigez :
   - **Dockerfile Path** : `./Dockerfile` (ou laissez vide)
   - **Docker Context** : `.`
   - **Runtime** : `Docker`
3. Supprimez toute configuration Python :
   - Build Command avec `pip install`
   - Start Command avec Python
   - Autres références à Python ou `requirements.txt`
4. Save Changes → Manual Deploy → Clear build cache & deploy

**Vérification** : Après redéploiement, les logs doivent montrer :
- ✅ `FROM rust:1.91.1-bookworm` (pas Python)
- ✅ `cargo build --release --package collab`
- ✅ Pas de recherche de `requirements.txt` ou `aurora_ai`

**Si ça ne fonctionne pas** :
1. Supprimez complètement le service `zed-collab`
2. Recréez-le via Blueprint (`render.yaml`) :
   - Dashboard → "New +" → "Blueprint"
   - Connectez votre dépôt `ILYESS24/ZEDAURION`
   - Render créera automatiquement le service avec la bonne configuration

### Problème : Build échoue (Out of Memory)

**Solution** :
- Passez au plan **Standard** (1 GB) au lieu de Starter (512 MB)
- Réduisez `DATABASE_MAX_CONNECTIONS` à `10`

### Problème : Erreur de connexion à la base de données

**Vérifications** :
- `DATABASE_URL` est correcte (Internal Database URL)
- La base de données est "Available" (pas "Paused")
- Même région pour le service et la base de données

### Problème : Service ne démarre pas

**Vérifications** :
- Les logs montrent des erreurs
- `API_TOKEN` est défini
- `DATABASE_URL` est correcte
- Health check : `https://votre-service.onrender.com/healthz`

## ✅ Vérification du Déploiement

```bash
# Health check
curl https://votre-service.onrender.com/healthz

# Devrait retourner: {"status":"ok"}
```

## 📊 Ressources Recommandées

| Composant | Plan Starter | Plan Standard |
|-----------|--------------|---------------|
| Service Web | 512 MB RAM | 1 GB RAM |
| Base de données | 256 MB | 1 GB |

**Recommandation** : Utilisez Standard (1 GB) pour la production.

## 📁 Fichiers de Configuration

- `render.yaml` : Configuration Blueprint Render
- `Dockerfile` : Image Docker pour le build Rust
- `env.example` : Exemple de variables d'environnement
- `.dockerignore` : Fichiers ignorés lors du build

## 🔗 Liens Utiles

- [Dashboard Render](https://dashboard.render.com)
- [Documentation Render](https://render.com/docs)
- [Documentation Zed](https://zed.dev/docs)

## 📝 Notes

- Le build Rust prend 15-20 minutes
- Les migrations de base de données s'exécutent automatiquement au démarrage
- Le service redémarre automatiquement après chaque push Git (si auto-deploy est activé)
