# Checkmate – Déploiement Docker

Ce projet fournit des scripts de **déploiement automatisé de Checkmate (BlueWave Labs)** à l’aide de **Docker Compose**.
Il permet de déployer rapidement une instance fonctionnelle avec **MongoDB**, et optionnellement un **reverse proxy Nginx HTTPS** utilisant un certificat autosigné.

Ce dépôt est destiné à un **lab**, un **POC** ou un **environnement interne**.

---

## ⚠️ Avertissement

- Les images Docker utilisées sont officielles
- Les certificats HTTPS générés sont **autosignés**
- Les secrets fournis sont **par défaut**
- Ce projet **n’est pas prêt pour une exposition Internet** sans durcissement complémentaire

---

## Architecture

```
[ Client Web ]
      |
   HTTPS (443)
      |
[ Nginx Reverse Proxy ]
      |
[ Checkmate Backend ] ---- [ MongoDB ]
```

- Réseau Docker dédié : `checkmate_net`
- Données MongoDB persistées localement
- Backend exposé uniquement en HTTP interne (port `52345`)

---

## Contenu du projet

| Fichier / Script | Description |
|------------------|-------------|
| `checkmate.sh` | Déploiement de la stack Checkmate (Backend + MongoDB) |
| `install_checkmate_proxy.sh` | Déploiement d’un reverse proxy Nginx HTTPS |
| `docker-compose.yml` | Généré automatiquement par les scripts |
| `certs/` | Certificats autosignés pour HTTPS |
| `mongo/data/` | Données persistées MongoDB |

---

## Prérequis

- Docker
- Docker Compose
- Accès root ou sudo
- Accès réseau fonctionnel

---

## Déploiement de Checkmate

### Script : `checkmate.sh`

Ce script déploie la stack principale Checkmate.

### Actions réalisées

- Création du répertoire `/opt/checkmate`
- Création du réseau Docker `checkmate_net`
- Génération d’un fichier `docker-compose.yml`
- Déploiement des services :
  - MongoDB
  - Checkmate Backend
- Démarrage des conteneurs en arrière-plan

### Services

#### MongoDB
- Image : `ghcr.io/bluewave-labs/checkmate-mongo`
- Données persistées sur l’hôte
- Accessible uniquement sur le réseau Docker

#### Checkmate Backend
- Image : `ghcr.io/bluewave-labs/checkmate-backend-mono`
- Port interne : `52345`
- Variables d’environnement configurées dans le compose
- Dépendance directe à MongoDB

### Lancement

```bash
chmod +x checkmate.sh
./checkmate.sh
```

Accès HTTP direct :
```
http://<IP_HOTE>:52345
```

---

## Reverse Proxy HTTPS (optionnel)

### Script : `install_checkmate_proxy.sh`

Déploie un reverse proxy **Nginx** avec **certificat autosigné**.

### Actions réalisées

- Génération d’un certificat SSL autosigné (IP et DNS)
- Création d’un conteneur Nginx
- Publication HTTPS sur le port `443`
- Connexion au réseau Docker `checkmate_net`

### Lancement

```bash
chmod +x install_checkmate_proxy.sh
./install_checkmate_proxy.sh <IP_LAN> [DNS_OPTIONNEL]
```

Accès HTTPS :
```
https://<IP_LAN>
```

Une alerte de sécurité navigateur est normale (certificat autosigné).

---

## Sécurité – Points importants

- Modifier impérativement :
  - `JWT_SECRET`
- Ne pas exposer directement sur Internet
- Ajouter :
  - firewall
  - authentification proxy
  - certificats valides
  - durcissement Docker

---

## Cas d’usage

- Lab sécurité
- Proof of Concept
- Démonstration interne
- Environnement de test

---

## Statut

Projet fonctionnel mais **non durci**.
Fourni **en l’état**.

---

## Licence

Non définie.
