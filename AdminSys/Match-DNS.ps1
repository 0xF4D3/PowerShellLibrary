<#
 .Synopsis
  Ce module sert à croiser les informations DNS avec les adresses IP dans 2 fichiers differents.
  Cela est utile lorsque nous faire un check de nos DNS avec des IP pour voir si il y'a correspondance ou pas.
 .Description
  C'est outil utilise 2 entrées 1. L'export DNS 2. Une liste d'adresse IP. L'objectif est de matcher ces IP avec les noms de domaines
 .LINK
 https://github.com/0xF4D3
 https://www.root-me.org/St0n14
 https://ecole2600.com
 .Parameter IPExtract
  Le chemin de notre fichier contenant les adresses IP
 .Parameter DNSExtract
  Le chemin de notre fichier contenant les adresses DNS
 .Example
   match-DNS -DnsExtract .\DNSRecord.txt -IpExtract .\IpFile.csv
#>
Function Match-DNS{
    param(
        [parameter (Mandatory=$true,
        HelpMessage = "Entrez le chemin du fichier contenant les extracts DNS")]
        [ValidateNotNullOrEmpty()]
        [string] $DnsExtract,
        [parameter (Mandatory=$true,
        HelpMessage = "Entrez le chemin du fichier contenant les extracts IP")]
        [ValidateNotNullOrEmpty()]
        [string] $IpExtract
    )
    if(-not(Get-Item -Path $DnsExtract -ErrorAction Ignore)){Write-Host "File $DnsExtract Not Found`n`n" -ForegroundColor Red;return}
    if(-not(Get-Item -Path $IpExtract -ErrorAction Ignore)){Write-Host "File $IpExtract Not Found`n`n" -ForegroundColor Red;return}
    
    
    ### isFile CSV
    $DnsTypeOfFileIsCSV = 0
    $IpTypeOfFileIsCSV = 0
    
    ##return Value
    $Matching = @{};
    $Match = @();
    
    ### Get extension
    $DnsTypeOfFile = $DnsExtract.LastIndexOf('.');
    $DnsTypeOfFile = $DnsExtract.Substring($DnsTypeOfFile +1);
    $IpTypeOfFile = $IpExtract.LastIndexOf('.');
    $IpTypeOfFile = $IpExtract.Substring($IpTypeOfFile +1);
    
    #### CODE ####
    if($DnsTypeOfFile -eq "csv"){
        $DnsTypeOfFileIsCSV = 1 ;
        $importDnsExtract = import-csv -Path $DnsExtract -Delimiter ",";
    }else{
        $importDnsExtract = get-content -path $DnsExtract;
    }
    
    if($IpTypeOfFile -eq "csv"){
        $IpTypeOfFileIsCSV = 1
        $importIPextract = import-csv -Path $IpExtract -Delimiter ",";
    }else{
        $importIPextract = get-content -path $IpExtract;
    }
    
    if(($DnsTypeOfFileIsCSV -eq 1)-and ($IpTypeOfFileIsCSV -eq 1)){
        foreach($IP in $importIPextract){
            foreach($DNS in $importDnsExtract){
                if($DNS.'IP' -eq $IP.'IP'){
                    #$Matching.Add($IP.'IP',$DNS.'DNS');
                    $Match += $IP.'IP'
                    $Match += $DNS.'DNS'
                }
            }
    
        }
    }elseif($DnsTypeOfFileIsCSV -eq 1 -and $IpTypeOfFileIsCSV -eq 0){
        foreach($lineOfIpFile in $importIPextract){
            $lineOfIpFile = (Write-Output $lineOfIpFile | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value;
            foreach($lineOfDNSFile in $importDnsExtract){
                if($lineOfIpFile -eq $lineOfDNSFile.'IP'){
                    #$Matching.Add($lineOfIpFile,$lineOfDNSFile.'DNS');
                    $Match += $lineOfIpFile
                    $Match += $lineOfDNSFile.'DNS'
                }
            }
        }
    }elseif(($DnsTypeOfFileIsCSV -eq 0) -and ($IpTypeOfFileIsCSV -eq 1)){
        foreach($lineOfIpFile in $importIPextract){
            foreach($lineOfDNSFile in $importDnsExtract){
                $iponthisline = (Write-Output $lineOfDNSFile | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value;
                $dnsonthisline = (Write-Output $lineOfDNSFile | Select-String -Pattern "^\D+?\S*\.\D+\." -AllMatches).Matches.Value;
                if($lineOfIpFile.'IP' -eq $iponthisline){
                    #write-host "IP:" $iponthisline "`nDNS:" $dnsonthisline
                    $Match +=$iponthisline
                    $Match += $dnsonthisline
                    #Write-Host "Foreach IP $i Foreach Dns $t"
                }
    
            }
        }
    }else{
        foreach($lineOfIpFile in $importIPextract){
            $lineOfIpFile = (Write-Output $lineOfIpFile | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value;
            foreach($lineOfDNSFile in $importDnsExtract){
                $iponthisline = (Write-Output $lineOfDNSFile | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value;
                $dnsonthisline = (Write-Output $lineOfDNSFile | Select-String -Pattern "^\D+?\S*\.\D+\." -AllMatches).Matches.Value;
                if($lineOfIpFile -eq $iponthisline){
                    $Match +=$iponthisline
                    $Match += $dnsonthisline
                }
            }
        }
    }
    
    #### Print Content #####
    
    For($i =0;$i -lt $Match.Length;$i+=2){
        Write-Host "IP = " $Match[$i] "    DNS = " $Match[$i+1];
    }
    
    }