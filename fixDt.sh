#!/bin/bash
# ProxyDT Auto Installer
# Mauvadao

[[ $EUID -ne 0 ]] && {
    echo "Use como root!"
    exit 1
}

_PROXY="/etc/SSHPlus/proxydt"

install_proxy() {
    echo "[+] Baixando ProxyDT..."
    
    mkdir -p /etc/SSHPlus
    
    wget -O $_PROXY https://raw.githubusercontent.com/mauvadao4g/WsSecurity/refs/heads/main/FX/proxydt
    
    chmod 777 $_PROXY
    
    [[ -f "$_PROXY" ]] && {
        echo "[OK] ProxyDT instalado!"
    } || {
        echo "[ERRO] Falha ao baixar!"
        exit 1
    }
}

stop_port() {
    local porta="$1"
    
    echo "[+] Matando processos na porta $porta..."
    
    kill -9 $(lsof -t -i:$porta) 2>/dev/null
    
    fuser -k ${porta}/tcp 2>/dev/null
    
    echo "[OK] Porta liberada!"
}

start_proxy() {
    local porta="$1"
    local resposta="$2"

    screen -wipe >/dev/null 2>&1

    screen -S proxydt -X quit 2>/dev/null

    screen -dmS proxydt $_PROXY \
        --port $porta \
        --http \
        --openvpn-port \
        --response $resposta

    sleep 2

    if lsof -i:$porta >/dev/null 2>&1; then
        echo
        echo "[OK] ProxyDT iniciado!"
        echo
        echo "PORTA    : $porta"
        echo "RESPOSTA : $resposta"
        echo
    else
        echo "[ERRO] Falha ao iniciar!"
    fi
}

status_proxy() {
    echo
    echo "========== STATUS =========="
    echo

    screen -ls | grep proxydt

    echo

    lsof -i -P -n | grep LISTEN | grep proxydt

    echo
}

remove_proxy() {
    screen -S proxydt -X quit 2>/dev/null
    
    rm -f $_PROXY
    
    echo "[OK] Proxy removido!"
}

update_bot() {
    echo "[+] Atualizando BOT..."
    
    cd /etc/SSHPlus/ || return

    rm -f bot

    wget https://raw.githubusercontent.com/mauvadao4g/WsSecurity/refs/heads/main/FX/bot

    chmod 777 bot

    echo "[OK] BOT atualizado!"
}

menu() {
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        PROXYDT MANAGER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "[1] Instalar ProxyDT"
echo "[2] Iniciar ProxyDT"
echo "[3] Parar ProxyDT"
echo "[4] Status ProxyDT"
echo "[5] Remover ProxyDT"
echo "[6] Atualizar BOT"
echo "[0] Sair"
echo
read -p "Escolha: " op

case $op in

1)
    install_proxy
    ;;

2)
    read -p "Porta [80/8080/8888]: " porta
    read -p "Mensagem Response: " resposta

    [[ -z "$porta" ]] && porta="80"
    [[ -z "$resposta" ]] && resposta="PROXYDT"

    stop_port "$porta"
    start_proxy "$porta" "$resposta"
    ;;

3)
    read -p "Porta para parar: " porta

    stop_port "$porta"

    screen -S proxydt -X quit 2>/dev/null

    echo "[OK] Proxy parado!"
    ;;

4)
    status_proxy
    ;;

5)
    remove_proxy
    ;;

6)
    update_bot
    ;;

0)
    exit
    ;;

*)
    echo "Opção inválida!"
    ;;
esac

echo
read -p "ENTER para continuar..."
menu
}

menu