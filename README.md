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

## example
```
My computer is 192.168.0.100
Target computer is 192.168.0.200

C:\>copy psserver.ps1 \\192.168.0.200\c$\temp\psserver.ps1
C:\>schtasks /create /s 192.168.0.200 /u administrator /p _ADMIN_PASSWORD_ /ru administrator /rp _ADMIN_PASSWORD_ /sc onstart /tn "This is a psserver" /tr "'powershell' '-NoProfile' '-ExecutionPolicy' 'Unrestricted' '-File' 'C:\temp\psserver.ps1' '12345' '^192\.168\.0\.100$'" /rl HIGHEST /f
C:\>schtasks /run /s 192.168.0.200 /u administrator /p _ADMIN_PASSWORD_ /tn "This is a psserver"
C:\>powershell -f psclient 192.168.0.200 12345 "dir foo.txt"
