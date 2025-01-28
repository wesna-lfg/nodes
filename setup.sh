#!/bin/bash

echo " ____         __ _         _              ____            _   _                                   __        _______ ____  _   _    _    "
echo "/ ___|  ___  / _| |_ ___  | |__  _   _   / ___| ___ _ __ | |_| | ___ _ __ ___   ___ _ __   __  __ \ \      / / ____/ ___|| \ | |  / \   "
echo "\___ \ / _ \| |_| __/ __| | '_ \| | | | | |  _ / _ \ '_ \| __| |/ _ \ '_ \` _ \ / _ \ '_ \  \ \/ /  \ \ /\ / /|  _| \___ \|  \| | / _ \  "
echo " ___) | (_) |  _| |_\__ \ | |_) | |_| | | |_| |  __/ | | | |_| |  __/ | | | | |  __/ | | |  >  <    \ V  V / | |___ ___) | |\  |/ ___ \ "
echo "|____/ \___/|_|  \__|___/ |_.__/ \__, |  \____|\___|_| |_|\__|_|\___|_| |_| |_|\___|_| |_| /_/\_\    \_/\_/  |_____|____/|_| \_/_/   \_\\"
echo "                                 |___/                                                                                               "
echo ""
echo ""
echo "===================================================================================================================================="
echo "Добро пожаловать! Начинаем установку необходимых библиотек, пока подпишись на наши Telegram-каналы для обновлений и поддержки: "
echo ""
echo "Gentleman - https://t.me/GentleChron"
echo "Wesna - https://t.me/softs_by_wesna"
echo "===================================================================================================================================="
sleep 10

# Обновление системы
echo "Обновляем систему..."
sudo apt update && sudo apt upgrade -y

# Установка графического интерфейса
echo "Устанавливаем графический интерфейс Ubuntu..."
sudo apt install ubuntu-desktop -y
sudo apt update

# Запуск дисплейного менеджера
echo "Запускаем дисплейный менеджер..."
sudo systemctl start gdm

# Установка XRDP
echo "Устанавливаем XRDP..."
sudo apt install xrdp -y
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp

# Установка Docker
echo "Устанавливаем Docker..."
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Загрузка и установка OpenLedger Node
echo "Скачиваем и устанавливаем OpenLedger Node..."
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb
sudo apt update

# Запуск OpenLedger Node
echo "Запускаем OpenLedger Node..."
openledger-node --no-sandbox

echo "======================================="
echo "Установка завершена! Все готово."
echo "======================================="
