# Whiptail Linux Maintenance Wizard

A simple script that create a GUI using whiptail to help update and maintian linux servers. This works in the CLI, and should work over SSH.

## Run from the repo:
``` Bash
bash -c "$(wget -qLO - https://github.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/raw/main/LinuxMaintinanceTool.sh)"
```

## Run locally:
``` Bash
wget -qO LinuxMaintinanceTool.sh https://github.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/raw/main/LinuxMaintinanceTool.sh
```
```
./LinuxMaintinanceTool.sh
```

# Add to path dynamicaly updating tool
This tool adds an custom alias to your path (so you can run the script by typing `lmt`, or `LinuxMaintinanceTool`). Instead of downloading the script, it runs the script from the remote repo - meaning it will always run the latest update. 

Append Sudo if not running as root. 

``` bash 
bash -c "$(wget -qLO - https://raw.githubusercontent.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/main/AddToPathDeploymentTool)"
```