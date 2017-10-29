#------------------------------------------------------------
# Argument
#------------------------------------------------------------
$addr = $args[0]
$port = $args[1]
$cmd = $args[2]

#------------------------------------------------------------
# Functions
#------------------------------------------------------------
#
# return: line data for success
#         $null for failure
#
Function readLine($rd){
        try {
                $line = $reader.readLine()
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

#------------------------------------------------------------
# Main procedure
#------------------------------------------------------------
$client = New-Object System.Net.Sockets.TcpClient ($addr, $port)
$stream = $client.GetStream()
$reader = New-Object IO.StreamReader($stream,[Text.Encoding]::Default)
$writer = New-Object IO.StreamWriter($stream,[Text.Encoding]::Default)

$stat = writeLine $writer $cmd
$line = readLine $reader
while ($line -ne $null -and $line -ne "__END__"){
        $line -replace "^:", ""
        $line = readLine $reader
}

$writer.Close()
$reader.Close()
$stream.Close()
$client.Close()
