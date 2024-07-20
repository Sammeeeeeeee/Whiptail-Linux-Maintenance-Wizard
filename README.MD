# Whiptail Linux Maintenance Wizard

A simple script that create a GUI using whiptail to help update and maintian linux servers. This works in the CLI, and should work over SSH.

# Run
## Use Deployment Tool (creates alias)
This tool adds an custom alias to your path (so you can run the script by typing `lmt`, or `LinuxMaintinanceTool`, or anything else you want). It gives you the option of downloading the script, or running fresh everytime from the repo. 

> [!TIP]
> Append `sudo` if not running as root or it cannot manage the alias. 

### Run
``` bash 
curl -s https://raw.githubusercontent.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/main/AddToPathDeploymentTool | bash -s
```

### Remove
``` bash 
curl -s https://raw.githubusercontent.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/main/AddToPathDeploymentTool | bash -s -- -remove
```

## Run from the repo:
``` Bash
bash -c "$(wget -qLO - https://github.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/raw/main/LinuxMaintinanceTool.sh)"
```

## Download locally:
``` Bash
wget -qO LinuxMaintinanceTool.sh https://github.com/Sammeeeeeeee/Whiptail-Linux-Maintenance-Wizard/raw/main/LinuxMaintinanceTool.sh
```
```
./LinuxMaintinanceTool.sh
```