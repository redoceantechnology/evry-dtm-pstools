##
# Tarjei Utnes januar 2020
##

. .\config.ps1

$hosts = Invoke-RestMethod -uri $hostsuri -Headers $headers

$hostlookup=New-Object "System.Collections.Generic.Dictionary[[String],[String]]"


# To create a lookup for the host ids and hostnames
$hosts | foreach {
    $hostlookup.add($_.entityId,$_.displayName)
}

$output = New-Object System.Collections.Generic.List[System.Object]

for ($i=0; $i -lt $hosts.length; $i++)  {
    
    

    foreach ($hclient in $hosts[$i].fromRelationships.isNetworkClientOfHost) {
    if ($hostlookup.ContainsKey($hclient)) {
          $tmp = $hosts[$i].PsObject.Copy()
          $tmp | add-member -notepropertyname "fromRelationships.isNetworkClientOfHost" -notepropertyvalue $hostlookup[$hclient]
          $tmp | add-member -notepropertyname "toRelationships.isNetworkClientOfHost" -notepropertyvalue ""
          $output.add($tmp)
        }
    
    }
    foreach ($hclient in $hosts[$i].toRelationships.isNetworkClientOfHost) {
    if ($hostlookup.ContainsKey($hclient)) {
          $tmp = $hosts[$i].PsObject.Copy()
          $tmp | add-member -notepropertyname "toRelationships.isNetworkClientOfHost" -notepropertyvalue $hostlookup[$hclient]
          $tmp | add-member -notepropertyname "fromRelationships.isNetworkClientOfHost" -notepropertyvalue ""
          $output.add($tmp)
        }
    
    }
}


$output | format-table

$output | export-csv test2.csv -NoTypeInformation

