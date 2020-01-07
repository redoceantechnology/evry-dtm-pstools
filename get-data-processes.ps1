##
# Tarjei Utnes januar 2020
##

. .\config.ps1

$hosts = Invoke-RestMethod -uri $hostsuri -Headers $headers
$processes = Invoke-RestMethod -uri $processessuri -Headers $headers
$hostlookup=New-Object "System.Collections.Generic.Dictionary[[String],[String]]"


# To create a lookup for the host ids and hostnames
$hosts | foreach {
    $hostlookup.add($_.entityId,$_.displayName)
}

$output = New-Object System.Collections.Generic.List[System.Object]

for ($i=0; $i -lt $processes.length; $i++)  {
    
    $hclient = $processes[$i].fromRelationships.isProcessOf[0]
    if ($processes[$i].listenPorts.length -gt 0) {
        $listeningports = $processes[$i].listenPorts
        foreach ($port in $listeningports) {
            $tmp = $processes[$i].PsObject.Copy()
            $tmp | add-member -notepropertyname "fromRelationships.isProcessOf" -notepropertyvalue $hostlookup[$hclient]
            $tmp | add-member -notepropertyname "listenport" -notepropertyvalue $port
            $output.add($tmp)
        }
    }
}


#$output | format-table

#$processes.length

$output | export-csv test2.csv -NoTypeInformation

