#!/bin/bash

# Проверка наличия необходимых утилит, установка если отсутствует
if ! command -v figlet &> /dev/null; then
    echo "figlet не найден. Устанавливаем..."
    sudo apt update && sudo apt install -y figlet
fi

if ! command -v whiptail &> /dev/null; then
    echo "whiptail не найден. Устанавливаем..."
    sudo apt update && sudo apt install -y whiptail
fi

# Определяем цвета для удобства
YELLOW="\e[33m"
CYAN="\e[36m"
BLUE="\e[34m"
GREEN="\e[32m"
RED="\e[31m"
PINK="\e[35m"
NC="\e[0m"

# Вывод приветственного текста с помощью figlet
echo -e "${PINK}$(figlet -w 150 -f standard "Softs by Gentleman")${NC}"
echo -e "${PINK}$(figlet -w 150 -f standard "x WESNA")${NC}"

echo "===================================================================================================================================="
echo "Добро пожаловать! Начинаем установку необходимых библиотек, пока подпишись на наши Telegram-каналы для обновлений и поддержки: "
echo ""
echo "Gentleman - https://t.me/GentleChron"
echo "Wesna - https://t.me/softs_by_wesna"
echo "===================================================================================================================================="

echo ""

# Определение функции анимации
animate_loading() {
    for ((i = 1; i <= 5; i++)); do
        printf "\r${GREEN}Подгружаем меню${NC}."
        sleep 0.3
        printf "\r${GREEN}Подгружаем меню${NC}.."
        sleep 0.3
        printf "\r${GREEN}Подгружаем меню${NC}..."
        sleep 0.3
        printf "\r${GREEN}Подгружаем меню${NC}"
        sleep 0.3
    done
    echo ""
}

# Вызов функции анимации
animate_loading
echo ""

# Функция для установки ноды
install_node() {
    echo -e "${BLUE}Начинаем установку ноды...${NC}"

    # Обновление и установка зависимостей
    sudo apt update -y && sudo apt upgrade -y

    # Проверка архитектуры системы
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
    elif [[ "$ARCH" == "aarch64" ]]; then
        CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
    else
        echo -e "${RED}Неподдерживаемая архитектура системы: $ARCH${NC}"
        exit 1
    fi

    # Скачиваем и распаковываем клиент
    wget $CLIENT_URL -O multipleforlinux.tar
    tar -xvf multipleforlinux.tar
    cd multipleforlinux

    # Устанавливаем разрешения на выполнение
    chmod +x ./multiple-cli
    chmod +x ./multiple-node

    # Добавляем клиент в системный PATH
    echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
    source ~/.bash_profile

    # Запуск ноды
    nohup ./multiple-node > output.log 2>&1 &

    # Ввод данных аккаунта
    echo -e "${YELLOW}Введите ваш Account ID:${NC}"
    read IDENTIFIER
    echo -e "${YELLOW}Установите ваш PIN:${NC}"
    read PIN

    # Привязка аккаунта
    ./multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFIER --pin $PIN --storage 200 --bandwidth-upload 100

    # Проверка статуса
    cd ~/multipleforlinux && ./multiple-cli status
}

# Функция для проверки статуса ноды
check_status() {
    echo -e "${BLUE}Проверка статуса ноды...${NC}"
    cd ~/multipleforlinux && ./multiple-cli status
}

# Функция для удаления ноды
remove_node() {
    echo -e "${BLUE}Удаляем ноду...${NC}"

    # Остановка процесса
    pkill -f multiple-node

    # Удаление файлов ноды
    sudo rm -rf ~/multipleforlinux

    echo -e "${GREEN}Нода успешно удалена!${NC}"
}

#!/bin/bash

# Вывод меню действий
CHOICE=$(whiptail --title "Меню действий" \
    --menu "Выберите действие:" 15 50 4 \
    "1" "Установка ноды" \
    "2" "Проверка статуса ноды" \
    "3" "Удаление ноды" \
    "4" "Выход" \
    3>&1 1>&2 2>&3)

case $CHOICE in
    1) 
        install_node
        ;;
    2) 
        check_status
        ;;
    3) 
        remove_node
        ;;
    4)
        echo -e "${CYAN}Выход из программы.${NC}"
        ;;
    *)
        echo -e "${RED}Неверный выбор. Завершение программы.${NC}"
        ;;
esac
