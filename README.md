# IntuneApps
This repo contains Intune Apps to deploy to the Company Portal


## Create .intunewin files

to create .intunewin files you need https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool

## Scripts

### Temporary admin rights

This prevents users to get full admin rights on their account and creates a temporary local admin account.

The password for the local admin account will be usable for 3 hours. After that the password expires.

After installing the app from the Company Portal there will be a textfile on C:\intune called localadm.txt with the username and password.

This script is usable on AD environments.

Detection script: LocalAdmin/Detection/passwordDetection.ps1

install: LocalAdmin/Source/Install.ps1

> make sure you have both Install.ps1 and request_temp_password.ps1 in the same location when creating the .intunewin