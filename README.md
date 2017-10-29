# psserver(PowerShell Server)

psserver is a Server script for running commands from PowerShell B)

## psserver.ps1 - Server script for running commands from PowerShell
```
Usage: psserver.ps1 PORT ALLOWED_IP

  PORT       port number to wait command from
  ALLOWED_IP allowed client ip-address in regex
```

## psclient.ps1 - Client script for sending commands to psserver
```
Usage: psclient.ps1 PSSERVER_IP PORT "COMMAND"

  PSSERVER_IP ip-address which psserver running on
  PORT        port number which psserver waiting
  "COMMAND"   command which can be run from PowerShell
```

## misc
```
schtasks /create /s PSSERVER_IP /u administrator /p _ADMIN_PASSWORD_ /ru administrator /rp _ADMIN_PASSWORD_ /sc onstart /tn "_TITLE_" /tr "'powershell' '-NoProfile' '-ExecutionPolicy' 'Unrestricted' '-File' 'C:\temp\psserver.ps1' 'PORT' '^ALLOWED_IP$'" /rl HIGHEST /f


