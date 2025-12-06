# 🚨 CORRECTION URGENTE : Render utilise le mauvais Dockerfile

## ❌ Problème Actuel

Render utilise un Dockerfile Python qui n'existe pas dans votre repo :
- `FROM python:3.11-slim` ❌
- Cherche `requirements.txt` avec `*aurora_ai*` ❌
- Ce Dockerfile n'existe PAS dans votre repo

## ✅ Solution IMMÉDIATE

### Option 1 : Corriger dans le Dashboard Render (RECOMMANDÉ)

1. **Allez sur** : https://dashboard.render.com
2. **Cliquez sur** votre service `zed-collab`
3. **Allez dans** : **Settings** (en haut à droite)
4. **Section "Build & Deploy"** :

   **SUPPRIMEZ COMPLÈTEMENT** :
   - ❌ Build Command (laissez VIDE)
   - ❌ Start Command (laissez VIDE)
   - ❌ Toute référence à Python, pip, requirements.txt

   **CONFIGUREZ EXACTEMENT** :
   ```
   Runtime: Docker
   Dockerfile Path: ./Dockerfile
   Docker Context: .
   ```

5. **Cliquez sur** : "Save Changes"
6. **Allez dans** : "Manual Deploy"
7. **Cliquez sur** : "Clear build cache & deploy"

### Option 2 : Supprimer et Recréer le Service

Si l'option 1 ne fonctionne pas :

1. **Supprimez** le service actuel :
   - Settings → Danger Zone → Delete Service

2. **Recréez via Blueprint** :
   - Dashboard → "New +" → "Blueprint"
   - Connectez : `ILYESS24/ZEDAURION`
   - Render détectera automatiquement `render.yaml`
   - Cliquez sur "Apply"

3. **Configurez les variables d'environnement** :
   - `DATABASE_URL` : Copiez depuis `zed-postgres` → Internal Database URL
   - `API_TOKEN` : `74295013a6bbc20cb73a74936f7e9ae9b13e0c7e65fc082ed5afc7527c74e99d`

## ✅ Vérification

Après correction, les **premières lignes** des logs doivent être :

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
```

→ La configuration n'est pas correcte, refaites l'Option 1 ou 2.

## 📝 Note Importante

Le Dockerfile Python que Render utilise **n'existe pas** dans votre repo. C'est une configuration incorrecte dans le dashboard Render qui doit être corrigée manuellement.

