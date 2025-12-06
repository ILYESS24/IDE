# ⚠️ AVERTISSEMENT : Configuration n8n

## ❌ Problème Principal

La configuration `workflow-automation` (n8n) dans `render.yaml` référence :
```yaml
rootDir: Downloads/n8n-master/n8n-master
```

**Ce dossier n'existe PAS dans votre repo Git** car :
1. Le dossier `Downloads/` est ignoré par `.gitignore`
2. Le dossier `Downloads/` est ignoré par `.dockerignore`
3. Render ne pourra pas cloner ce dossier depuis GitHub

## ✅ Solutions

### Option 1 : Copier n8n dans le repo (RECOMMANDÉ)

1. **Copiez n8n dans le repo** :
   ```bash
   # Depuis la racine du repo zed-main
   cp -r Downloads/n8n-master/n8n-master ./n8n
   ```

2. **Mettez à jour `render.yaml`** :
   ```yaml
   rootDir: n8n
   ```

3. **Mettez à jour `.gitignore`** pour ne pas ignorer `n8n/` :
   ```bash
   # Ajoutez dans .gitignore (si n8n/ est ignoré)
   # !n8n/
   ```

4. **Ajoutez au Git** :
   ```bash
   git add n8n/
   git add render.yaml
   git commit -m "Ajout n8n au repo"
   git push origin main
   ```

### Option 2 : Utiliser un repo Git séparé

1. **Créez un repo Git séparé** pour n8n
2. **Dans Render**, créez un service séparé qui clone ce repo
3. **Ne l'ajoutez pas** dans le `render.yaml` de zed-main

### Option 3 : Retirer n8n du render.yaml

Si vous ne voulez pas déployer n8n maintenant, supprimez la section `workflow-automation` du `render.yaml`.

## 🔧 Corrections Apportées

J'ai corrigé :
- ✅ Supprimé la référence circulaire `N8N_PORT` (Render injecte `PORT` automatiquement)
- ✅ Ajouté des commentaires explicatifs
- ⚠️ **Vous devez corriger `rootDir`** selon l'option choisie ci-dessus

## 📝 Note Importante

**Sans correction du `rootDir`, le déploiement n8n échouera** car Render ne trouvera pas le dossier `Downloads/n8n-master/n8n-master` dans le repo Git.

