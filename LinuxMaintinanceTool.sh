#!/bin/bash

full_update() {
    sudo apt update
    sudo apt full-upgrade -y
    sudo apt autoremove --purge -y
    sudo snap refresh
}

docker_update() {
    docker run --name wathtower_docker-updater --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower:latest --run-once --cleanup --stop-timeout 60s --include-restarting --include-stopped
}

disk_usage() {
    df -h
}

docker_status() {
    docker ps -a
}

memory_free_average() {
    free -m | awk 'NR==2{printf "Average Memory Usage: %.2f%%\n", $3*100/$2 }'
}

top_processes_average() {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

UPDATE_CHOICES=$(whiptail --title "Select Update Options" --separate-output --checklist \
"Choose the update operations you want to perform:" 15 60 2 \
"1" "Full System Update" OFF \
"2" "Docker Update (Watchtower)" OFF \
3>&1 1>&2 2>&3)

INFO_CHOICES=$(whiptail --title "Select Information Options" --separate-output --checklist \
"Choose the information operations you want to perform:" 20 60 4 \
"1" "Disk Usage Check" OFF \
"2" "Docker Container Status" OFF \
"3" "Memory Free Average" OFF \
"4" "Top Processes Average" OFF \
3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then
    whiptail --title "Cancelled" --msgbox "Operation cancelled." 10 60
    exit 1
fi

for choice in $UPDATE_CHOICES; do
    case $choice in
        "1")
            output=$(full_update 2>&1)
            whiptail --title "Full System Update" --scrolltext --msgbox "$output" 20 80
            ;;
        "2")
            output=$(docker_update 2>&1)
            whiptail --title "Docker Update (Watchtower)" --scrolltext --msgbox "$output" 20 80
            ;;
    esac
done

for choice in $INFO_CHOICES; do
    case $choice in
        "1")
            output=$(disk_usage 2>&1)
            whiptail --title "Disk Usage Check" --scrolltext --msgbox "$output" 20 80
            ;;
        "2")
            output=$(docker_status 2>&1)
            whiptail --title "Docker Container Status" --scrolltext --msgbox "$output" 20 80
            ;;
        "3")
            output=$(memory_free_average 2>&1)
            whiptail --title "Memory Free Average" --scrolltext --msgbox "$output" 20 80
            ;;
        "4")
            output=$(top_processes_average 2>&1)
            whiptail --title "Top Processes Average" --scrolltext --msgbox "$output" 20 80
            ;;
    esac
done

exit 0
