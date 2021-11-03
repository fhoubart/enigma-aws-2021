# Initialisation d'un serveur EC2 via les user-data

## Cloud-init

Lien vers la doc cloud-init : <https://cloudinit.readthedocs.io/en/latest/index.html>

Lien vers la doc AWS : <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html>

## Utilisation d'un script shell

Le sheebang au début des user-data indique à Cloud-Init comment intérpréter le contenu => `#!/bin/bash` pour un script shell par exemple.

Voir [2-user-data-web-server](2-user-data-web-server) pour un exemple de création de site web.

## Utilisation d'un fichier cloud-config

Commencer le fichier user-data par `#cloud-config`. On décrit l'état attendu de la machine plutôt que des commandes shells. Voir <https://cloudinit.readthedocs.io/en/latest/topics/examples.html> pour des exemples de syntaxe.
