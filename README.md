# ALEXANDRE SA — Gestion du parc de démo

Site web partagé pour la concession **ALEXANDRE SA**, avec données centralisées dans Supabase et hébergement possible sur Vercel ou Netlify.

## Personnalisation intégrée
- Logo ALEXANDRE fourni par l'entreprise.
- Nom : **ALEXANDRE SA**
- Activité : **concession / gestion du parc de démo**
- Administrateurs prévus : **Baptiste** et **Judicael**
- Base de données : **Supabase**
- Hébergement : **Vercel ou Netlify**

## Mise en ligne

### 1. Supabase
1. Créez un projet Supabase.
2. Ouvrez **SQL Editor**.
3. Exécutez `supabase-schema.sql`.
4. Dans **Authentication > Users**, créez les comptes de Baptiste et Judicael.
5. Récupérez leurs UUID et ajoutez leurs profils `admin` avec les requêtes indiquées dans `supabase-schema.sql`.
6. Pour chaque collaborateur, créez ensuite son utilisateur Supabase et son profil `commercial`.

### 2. Configuration du site
1. Copiez `config.example.js` vers `config.js`.
2. Renseignez :
   - l'URL du projet Supabase ;
   - la clé publique `anon`.
3. Ne mettez **jamais** la clé `service_role` dans le navigateur.

### 3. Vercel
- Importez le dossier du site dans Vercel.
- Aucun build complexe n'est nécessaire : c'est un site statique.
- Le fichier `config.js` doit être présent dans le dossier publié.

### 4. Netlify
- Déposez le dossier dans Netlify ou connectez un dépôt Git.
- Aucun build complexe n'est nécessaire.
- Vérifiez que `config.js` est publié avec `index.html`.

### 5. URL Supabase
Dans **Authentication > URL Configuration**, ajoutez l'URL finale du site dans les URLs autorisées.

## Important
Cette archive est **prête à être déployée**, mais elle n'est pas encore une URL publique : il faut connecter votre propre projet Supabase et votre compte Vercel/Netlify.

Les comptes utilisateurs et mots de passe restent gérés par Supabase Auth.
