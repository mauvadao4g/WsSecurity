#!/bin/bash

# Formata a data para YYYY-MM-DD HH:MM:SS
DATA_ATUAL=$(date "+%Y-%m-%d %H:%M:%S")

echo "--- Iniciando Git Push Automatizado ---"

# Adiciona todas as mudanças
git add .

# Realiza o commit com a data formatada
git commit -m "Update $DATA_ATUAL"

# Realiza o push para o repositório remoto
# Nota: Assume que o branch atual está configurado corretamente
git push

echo "--- Processo concluído em $DATA_ATUAL ---"
