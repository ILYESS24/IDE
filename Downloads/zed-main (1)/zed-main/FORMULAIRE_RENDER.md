# 📝 Formulaire Render - Configuration Exacte

Guide pour remplir le formulaire de création du service web sur Render.

## 🔧 Configuration du Formulaire

### Informations de Base

| Champ | Valeur à Remplir | Notes |
|-------|------------------|-------|
| **Name** | `zed-collab` | Nom unique du service |
| **Project** | (Laissez vide ou créez un projet) | Optionnel |
| **Environment** | (Laissez vide) | Optionnel |
| **Language** | `Docker` | ✅ Déjà sélectionné |
| **Branch** | `main` | ✅ Déjà sélectionné |
| **Region** | `Oregon (US West)` | ✅ Déjà sélectionné |
| **Root Directory** | (Laissez vide) | Pas nécessaire |

### Instance Type

**Recommandation** : Choisissez **Starter** ($9/mois) pour commencer
- 512 MB RAM
- 0.5 CPU
- Suffisant pour tester

**Pour la production** : Choisissez **Standard** ($25/mois)
- 2 GB RAM
- 1 CPU
- Meilleures performances

### Environment Variables

Cliquez sur **"Add Environment Variable"** et ajoutez **EXACTEMENT** ces variables :

#### Variables Obligatoires

1. **HTTP_PORT**
   ```
   Key: HTTP_PORT
   Value: 10000
   ```

2. **DATABASE_URL**
   ```
   Key: DATABASE_URL
   Value: [À copier depuis votre base de données zed-postgres]
   ```
   - Allez dans votre base de données `zed-postgres`
   - Copiez l'**Internal Database URL**
   - Collez ici

3. **API_TOKEN**
   ```
   Key: API_TOKEN
   Value: [Générez un token de 64 caractères]
   ```
   - Générez avec PowerShell :
   ```powershell
   $chars = '0123456789abcdef'; $token = ''; for ($i=0; $i -lt 64; $i++) { $token += $chars[(Get-Random -Maximum $chars.Length)] }; Write-Host $token
   ```

#### Variables Optionnelles (Recommandées)

4. **DATABASE_MAX_CONNECTIONS**
   ```
   Key: DATABASE_MAX_CONNECTIONS
   Value: 20
   ```

5. **INVITE_LINK_PREFIX**
   ```
   Key: INVITE_LINK_PREFIX
   Value: https://zed.dev/invite/
   ```

6. **ZED_ENVIRONMENT**
   ```
   Key: ZED_ENVIRONMENT
   Value: production
   ```

7. **RUST_LOG**
   ```
   Key: RUST_LOG
   Value: info
   ```

8. **LOG_JSON**
   ```
   Key: LOG_JSON
   Value: true
   ```

### Configuration Docker (Section Advanced)

Si vous voyez une section **"Advanced"** ou **"Docker Settings"** :

| Champ | Valeur |
|-------|--------|
| **Dockerfile Path** | `./Dockerfile` |
| **Docker Context** | `.` (point) |
| **Build Command** | (Laissez VIDE) |
| **Start Command** | (Laissez VIDE) |

⚠️ **IMPORTANT** : Ne mettez **RIEN** dans Build Command ou Start Command. Le Dockerfile gère tout automatiquement.

## ✅ Checklist Avant de Cliquer sur "Create Web Service"

- [ ] Name : `zed-collab`
- [ ] Language : `Docker`
- [ ] Branch : `main`
- [ ] Region : `Oregon`
- [ ] Root Directory : **VIDE**
- [ ] Instance Type : `Starter` ou `Standard`
- [ ] HTTP_PORT : `10000`
- [ ] DATABASE_URL : (Internal Database URL de zed-postgres)
- [ ] API_TOKEN : (Token de 64 caractères généré)
- [ ] DATABASE_MAX_CONNECTIONS : `20`
- [ ] INVITE_LINK_PREFIX : `https://zed.dev/invite/`
- [ ] ZED_ENVIRONMENT : `production`
- [ ] RUST_LOG : `info`
- [ ] LOG_JSON : `true`
- [ ] Dockerfile Path : `./Dockerfile` (si visible)
- [ ] Docker Context : `.` (si visible)
- [ ] Build Command : **VIDE**
- [ ] Start Command : **VIDE**

## 🚀 Après la Création

1. Render va automatiquement :
   - Cloner votre dépôt
   - Construire l'image Docker
   - Démarrer le service

2. Le build prendra **15-20 minutes** (compilation Rust)

3. Vérifiez les logs pour confirmer :
   - ✅ `FROM rust:1.91.1-bookworm`
   - ✅ `cargo build --release --package collab`
   - ✅ Pas d'erreur Python

4. Testez le service :
   - Health check : `https://zed-collab.onrender.com/healthz`
   - Devrait retourner : `{"status":"ok"}`

## 🆘 Si le Build Échoue

1. Vérifiez les logs de build
2. Assurez-vous que `Dockerfile Path` est `./Dockerfile`
3. Assurez-vous qu'il n'y a **PAS** de Build Command ou Start Command
4. Vérifiez que `DATABASE_URL` est correcte (Internal Database URL)

## 📋 Résumé Rapide

```
Name: zed-collab
Language: Docker
Branch: main
Region: Oregon
Root Directory: (vide)
Instance: Starter ($9/mois) ou Standard ($25/mois)

Variables:
- HTTP_PORT=10000
- DATABASE_URL=<Internal Database URL>
- API_TOKEN=<token généré>
- DATABASE_MAX_CONNECTIONS=20
- INVITE_LINK_PREFIX=https://zed.dev/invite/
- ZED_ENVIRONMENT=production
- RUST_LOG=info
- LOG_JSON=true

Docker:
- Dockerfile Path: ./Dockerfile
- Docker Context: .
- Build Command: (vide)
- Start Command: (vide)
```

