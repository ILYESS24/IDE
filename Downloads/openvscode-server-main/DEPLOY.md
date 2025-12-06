# 🚀 Guide de Déploiement

## ✅ Option 1 : Railway (RECOMMANDÉ - Le plus simple !)

### Étapes :
1. **Allez sur** https://railway.app
2. **Connectez-vous** avec GitHub
3. **Cliquez** "New Project" → "Deploy from GitHub repo"
4. **Sélectionnez** le repo `ILYESS24/IDE`
5. **Railway détectera automatiquement** le Dockerfile
6. **C'est tout !** Railway déploie automatiquement

### Avantages :
- ✅ **Aucune configuration** nécessaire
- ✅ **Détection automatique** du Dockerfile
- ✅ **URL publique** instantanée
- ✅ **Parfait pour les apps serveur**

---

## ⚠️ Option 2 : Vercel (Limité)

### Via l'interface web :
1. **Allez sur** https://vercel.com
2. **Connectez-vous** avec GitHub
3. **Cliquez** "Add New..." → "Project"
4. **Importez** le repo `ILYESS24/IDE`
5. **Configuration** :
   - Framework Preset: `Other`
   - Root Directory: `./` (racine)
   - Build Command: `npm run build`
   - Output Directory: `./openvscode-server-main/out`
   - Install Command: `npm install`
6. **Cliquez** "Deploy"

### Via CLI :
```bash
npm i -g vercel
vercel login
vercel --prod
```

### ⚠️ Limitations Vercel :
- Timeout maximum: 30 secondes
- Pas idéal pour un IDE complet
- **Recommandation : Utilisez Railway !**

