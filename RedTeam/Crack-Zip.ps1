<#
 .Synopsis
  Ce module permet de tester toutes les combinaisons possible de mot de passe d'un Dossier zippé au format 7z
 .Description
  Cet outil permet, avec en parametre notre fichier ainsi qu'une wordlist de cracker un dossier Zippé au format 7z 
  en testant toutes les combinaisons de mot de passe possible 
 .LINK
 https://github.com/0xF4D3
 https://www.root-me.org/St0n14
 https://ecole2600.com
 .Parameter p
  Le chemin de notre Dossier à cracker
 .Parameter w
  Le chemin de notre wordlist
 .Example
   Crack-Zip -c C:\Users\username\Desktop\Test7z.7z -w C:\Users\username\Desktop\wordlist.txt
#>
Function Crack-Zip{
    param(
        [parameter (Mandatory=$true,
        HelpMessage = "Fichier Zip A cracker")]
        [ValidateNotNullOrEmpty()]
        [string] $p,
        [parameter (Mandatory=$true,
        HelpMessage = "Chemin vers la wordlist")]
        [ValidateNotNullOrEmpty()]
        [string] $w,
        [parameter(Mandatory=$false)]
        $verbose
    )
    write-host $verbose
    ## Get Path of 7z
    if($verbose -eq ""){
        $parameter = "-bso0 -bsp0 -bse0"
    }
    $PathOf7z = (Get-command 7z.exe).path
    Write-host "Test if pathof7z exist: "$PathOf7z -ForegroundColor Red
    if($pathof7z -eq ""){Write-Host "Path of 7z not found, donwload 7z`n`n" -ForegroundColor Red;return}
    ### Check if path exists
    if(-not(Get-Item -Path $p -ErrorAction Ignore)){Write-Host "File $p Not Found`n`n" -ForegroundColor Red;return}
    if(-not(Get-Item -Path $w -ErrorAction Ignore)){Write-Host "File $w Not Found`n`n" -ForegroundColor Red;return}

    $ListOfPasswd = get-content -path $w
    foreach($password in $ListOfPasswd){
        $attempt = & "$PathOf7z" e $p -p"$password" "$parameter"-y 
        if($attempt -contains "Everything is ok"){
            write-host "Success"-ForegroundColor green "the password is $password" 
        }else{
            if($verbose -eq ""){write-host "Failed"-ForegroundColor red "the password isn't $password"}
        }
    }



}