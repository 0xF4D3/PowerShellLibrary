Function Crack-Zip{
    param(
        [parameter (Mandatory=$true,
        HelpMessage = "Fichier Zip A cracker")]
        [ValidateNotNullOrEmpty()]
        [string] $c,
        [parameter (Mandatory=$true,
        HelpMessage = "Chemin vers la wordlist")]
        [ValidateNotNullOrEmpty()]
        [string] $w
    )
    ## Get Path of 7z
    $PathOf7z = (Get-command 7z.exe).path
    Write-host "Test if pathof7z exist: "$PathOf7z -ForegroundColor Red
    if($pathof7z -eq ""){Write-Host "Path of 7z not found, donwload 7z`n`n" -ForegroundColor Red;return}
    ### Check if path exists
    if(-not(Get-Item -Path $c -ErrorAction Ignore)){Write-Host "File $c Not Found`n`n" -ForegroundColor Red;return}
    if(-not(Get-Item -Path $w -ErrorAction Ignore)){Write-Host "File $w Not Found`n`n" -ForegroundColor Red;return}

    $ListOfPasswd = get-content -path $w
    foreach($password in $ListOfPasswd){
        $attempt = & "$PathOf7z" e $c -p"$password" -y 
        if($attempt -contains "Everything is ok"){
            write-host "Success"-ForegroundColor green "the password is $password" 
        }else{
            write-host "Failed"-ForegroundColor red "the password isn't $password"
        }
    }



}