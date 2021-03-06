#------------------------------------------------------------
# Argument
#------------------------------------------------------------
$port = $args[0]
$allowip = $args[1]

#------------------------------------------------------------
# Function
#------------------------------------------------------------
#
# return: line data for success
#         $null for failure
#
Function readLine($rd){
        try {
                $line = $rd.readLine()
        }catch{
                $line = $null
        }
        return $line
}
#
# return: $true for success
#         $false for failure
#
Function writeLine($wd, $line){
        $stat = $true
        try {
                $wd.writeLine($line)
                $wd.Flush()
        }catch{
                $stat = $false
        }
        return $stat
}
#
# return: $true for success
#         $false for failure
#
Function runAndReturnResalt($wd, $cmd){
        $stat = $true
        try {
                Invoke-Expression $cmd |
                Out-String -stream |
                Foreach-Object {
                        $res = $_ -replace " *$", ""
                        if ((writeLine $wd (":"+ $res)) -eq $false){
                                $stat = $false
                                break
                        }
                }
        }catch{
                $stat = $false
        }
        return $stat
}
#------------------------------------------------------------
# Main procedure
#------------------------------------------------------------
$endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, $port)
$server = New-Object System.Net.Sockets.TcpListener $endpoint
$server.start()

$shutdown = $false
while (-not $shutdown){
        $client = $server.AcceptTcpClient()
        if ($client.Client.RemoteEndPoint.Address.IPAddressToString -match $allowip){
                $stream = $client.GetStream()
                $reader = New-Object IO.StreamReader($stream,[Text.Encoding]::Default)
                $writer = New-Object IO.StreamWriter($stream,[Text.Encoding]::Default)
                while (($line = readLine $reader) -ne $null -and (-not $shutdown)){
                        if ($line -match "^@shutdown$"){
                                $shutdown = $true
                        }else{
                                if ((runAndReturnResalt $writer $line) -ne $true){
                                        $stat = writeLine $writer ("Failed : " + $line)
                                }
                        }
                        $stat = writeLine $writer "__END__"
                }
                $writer.Close()
                $reader.Close()
                $stream.Close()
                $client.Close()
                $writer = $null
                $reader = $null
                $stream = $null
                $client = $null
        }else{
                $client.Close()
                $client = $null
        }
}

$server.stop()
