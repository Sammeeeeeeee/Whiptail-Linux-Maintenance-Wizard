#!/bin/bash

full_update() {
    timeout 300 sudo apt update
    timeout 300 sudo apt full-upgrade -y
    timeout 300sudo apt autoremove --purge -y
    timeout 300sudo snap refresh
}

docker_update() {
    timeout 3000 docker run --name wathtower_docker-updater --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower:latest --run-once --cleanup --stop-timeout 60s --include-restarting --include-stopped
}

disk_usage() {
    timeout 30 df -h
}

docker_status() {
    timeout 30 docker ps -a
}

memory_free_average() {
    timeout 30 free -m | awk 'NR==2{printf "Average Memory Usage: %.2f%%\n", $3*100/$2 }'
}

top_processes_average() {
    timeout 30 ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
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
            whiptail --title "Full System Update"  --msgbox "$output" 20 80
            ;;
        "2")
            output=$(docker_update 2>&1)
            whiptail --title "Docker Update (Watchtower)" --msgbox "$output" 20 80
            ;;
    esac
done

for choice in $INFO_CHOICES; do
    case $choice in
        "1")
            output=$(disk_usage 2>&1)
            whiptail --title "Disk Usage Check" --msgbox "$output" 20 80
            ;;
        "2")
            output=$(docker_status 2>&1)
            whiptail --title "Docker Container Status" --msgbox "$output" 20 80
            ;;
        "3")
            output=$(memory_free_average 2>&1)
            whiptail --title "Memory Free Average" --msgbox "$output" 20 80
            ;;
        "4")
            output=$(top_processes_average 2>&1)
            whiptail --title "Top Processes Average" --msgbox "$output" 20 80
            ;;
    esac
done

exit 0
