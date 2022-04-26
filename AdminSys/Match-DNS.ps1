Function Match-DNS{
param(
    [string] $DnsExtract,
    [string] $IpExtract
)

### Il faut que je check si les elements sont correct


### Definition des variables pour la suite
$DnsTypeOfFileIsCSV = 0
$IpTypeOfFileIsCSV = 0

##Futur valeur de retour, une hashtable qui contiendra, DNS et IP
$Matching = @{};


### Get extension
$DnsTypeOfFile = $DnsExtract.LastIndexOf('.');
$DnsTypeOfFile = $DnsExtract.Substring($DnsTypeOfFile +1);
$IpTypeOfFile = $IpExtract.LastIndexOf('.');
$IpTypeOfFile = $IpExtract.Substring($IpTypeOfFile +1);

Write-host "Test 1 : ip Extract = $IpTypeOfFile `nDNS Extract = $DnsTypeOfFile" -ForegroundColor Red;

### Si l'extension de mes fichiers sont des csv
if($DnsTypeOfFile -eq "csv"){
### il faut que je check quel est le delimiter
    $DnsTypeOfFileIsCSV = 1 ;
    $importDnsExtract = import-csv -Path $DnsExtract -Delimiter ",";
}else{
    $importDnsExtract = get-content -path $DnsExtract;
}
Write-host "Test2 Mon fichier DNS Extract est lu `n" -ForegroundColor Red;
write-host $importDnsExtract;

if($IpTypeOfFile -eq "csv"){
### il faut que je check quel est le delimiter
    $IpTypeOfFileIsCSV = 1
    $importIPextract = import-csv -Path $IpExtract -Delimiter ",";
}else{
    $importIPextract = get-content -path $IpExtract;
}

Write-host "Test3 Mon fichier Ip Extract est lu `n" -ForegroundColor Red
write-host $importIPextract

if(($DnsTypeOfFileIsCSV -eq 1)-and ($IpTypeOfFileIsCSV -eq 1)){
    ###double foreach . Les 2 Fichiers sont des csv
}elseif($DnsTypeOfFileIsCSV -eq 1 -and $IpTypeOfFileIsCSV -eq 0){
    ###Foreach + recherche ligne par ligne le fichiers dns est un csv
}elseif(($DnsTypeOfFileIsCSV -eq 0) -and ($IpTypeOfFileIsCSV -eq 1)){
    ### Recherche ligne + Foreach le Fichier dns est un txt mais le fichier ip est un csv
    ###Extact Ip address from line
    $my_FileDns = Get-Content $DnsExtract
    foreach($lineOfIpFile in $importIPextract){
        write-host "test of ip" $lineOfIpFile;
        foreach($lineOfDNSFile in $my_FileDns){
            $iponthisline = (echo $lineOfDNSFile | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value;
            $dnsonthisline = (echo $lineOfDNSFile | Select-String -Pattern "^\D+?\S*\.\D+\." -AllMatches).Matches.Value;
            if($lineOfIpFile.IP -eq $iponthisline){
                $Matching.Add($iponthisline,$dnsonthisline)
                write-host "My Ip File" $lineOfIpFile.IP "match with" $iponthisline "and with this dns record" $dnsonthisline
            }

        }
    }
    $Matching

}else{
    ## Les Deux fichiers sont des TXT

}
}