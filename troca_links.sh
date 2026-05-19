#!/bin/bash

antigo="modderajuda/websocketsecurity"
novo="mauvadao4g/WsSecurity"

# Busca arquivos que contenham a string antiga e realiza a substituição
grep -rl "$antigo" . --exclude="troca_links.sh" --exclude-dir=".git" | xargs sed -i "s|$antigo|$novo|g"

echo "Links atualizados de '$antigo' para '$novo'."
