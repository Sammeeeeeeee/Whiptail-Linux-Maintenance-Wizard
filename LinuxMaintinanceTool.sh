#!/bin/bash

VERSION="4.0"
SCRIPT_URL="https://raw.githubusercontent.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/main/LinuxMaintinanceTool.sh"
SCRIPT_PATH="/usr/local/bin/lmt.sh"

if ! command -v whiptail &> /dev/null; then
    echo "Error: Whiptail is required but not installed."
    echo "Please install whiptail or visit the following link for instructions:"
    echo "https://github.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/tree/main#run"
    exit 1
fi


check_version() {
    local github_version=$(curl -s "$SCRIPT_URL" | grep '^VERSION=' | cut -d '"' -f 2)
    echo "Current version: $VERSION, GitHub version: $github_version"
    
    if [ -z "$github_version" ]; then
        whiptail --title "Update Check Failed" --msgbox "Failed to retrieve the latest version. Please check your internet connection and try again." 10 60
        return
    fi

    if [ "$github_version" != "$VERSION" ]; then
        update_choice=$(whiptail --title "Update Available" --menu "A new version ($github_version) is available. You are currently running version $VERSION. What would you like to do?" 15 60 2 \
        "1" "Continue without updating" \
        "2" "Update now" 3>&1 1>&2 2>&3)
        
        case $update_choice in
            1)
                return
                ;;
            2)
                update_script
                exit 0
                ;;
        esac
    fi
}


update_script() {
    echo "Updating..."
    if curl -s "$SCRIPT_URL" > "$SCRIPT_PATH"; then
        $SCRIPT_PATH
    else
        whiptail --title "Update Failed" --msgbox "Failed to update the script. Please check your internet connection and try again." 10 60
    fi
}

check_version

full_update() {
    timeout 300 apt update
    timeout 300 apt full-upgrade -y
    timeout 300 apt autoremove --purge -y
    timeout 300 snap refresh
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