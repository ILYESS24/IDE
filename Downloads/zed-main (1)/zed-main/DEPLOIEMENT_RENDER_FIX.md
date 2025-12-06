# 🔧 Correction du Problème de Build sur Render

## Problème Identifié

Render utilise un Dockerfile Python au lieu de `Dockerfile-collab-render`. Les logs montrent :
```
ERROR: requirements.txt not found
find Downloads/ -name "requirements.txt" -path "*aurora_ai*"
```

## Solutions

### Solution 1 : Vérifier la Configuration dans Render Dashboard

1. Allez dans votre service sur [dashboard.render.com](https://dashboard.render.com)
2. Cliquez sur votre service `zed-collab`
3. Allez dans **Settings**
4. Vérifiez que :
   - **Dockerfile Path** : `./Dockerfile-collab-render`
   - **Docker Context** : `.`
   - **Runtime** : `Docker`

### Solution 2 : Recréer le Service avec Blueprint

Si le service a été créé manuellement, recréez-le avec le Blueprint :

1. Supprimez le service actuel
2. Dans Render Dashboard → "New +" → "Blueprint"
3. Connectez votre dépôt `ILYESS24/ZEDAURION`
4. Render détectera automatiquement `render.yaml`
5. Cliquez sur "Apply"

### Solution 3 : Forcer l'Utilisation du Bon Dockerfile

Si Render continue d'utiliser le mauvais Dockerfile :

1. Dans les **Settings** du service
2. Section **Build & Deploy**
3. **Dockerfile Path** : Changez en `./Dockerfile-collab-render`
4. **Docker Context** : `.`
5. Sauvegardez et redéployez

### Solution 4 : Vérifier qu'il n'y a pas d'autre Dockerfile

Assurez-vous qu'il n'y a pas de `Dockerfile` (sans suffixe) à la racine qui pourrait être détecté automatiquement.

## Fichiers Importants

- ✅ `Dockerfile-collab-render` - Le bon Dockerfile (Rust)
- ✅ `.dockerignore` - Pour éviter de copier des fichiers inutiles
- ✅ `render.yaml` - Configuration Blueprint

## Vérification

Après correction, le build devrait :
1. Utiliser `rust:1.91.1-bookworm` comme image de base
2. Compiler le serveur collab avec `cargo build`
3. Créer une image runtime avec `debian:bookworm-slim`
4. Démarrer avec `/app/collab serve all`

## Si le Problème Persiste

1. Vérifiez les logs de build dans Render
2. Assurez-vous que `render.yaml` est bien dans la branche `main`
3. Vérifiez que le service utilise bien le Blueprint (pas de création manuelle)

