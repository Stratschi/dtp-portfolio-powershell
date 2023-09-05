param (
    [string]$csvFilePath = "C:\Yannic Fahrenkrog\6 Portfolio\CSV_neue_Mitglieder\Yannic.csv"
)

Import-Module MSOnline
Connect-MsolService


$Outputpath = $PSScriptRoot + "\Tempfile.csv"
$users = Get-MsolUser -All
$users | Export-Csv -Path $Outputpath -NoTypeInformation

$eeContent = Get-Content -Path $Outputpath

$EmailAddress = @()
foreach ($line in $eeContent) {
     $values = $line -split ","
     $existingEmails = $values[56]
        $EmailAddress += $existingEmails.Replace('"', '') 
}
$EmailAddress

# Inhalt aus CSV-Datei wird ausgelesen
$csvContent = Get-Content -Path $csvFilePath

# E-Mails und andere Informationen werden generiert
foreach ($line in $csvContent) {
    if ($line -notmatch "^Vorname") {
        $values = $line -split ";"
        $Vorname = $values[0]
        $Nachname = $values[1]
        $Passwort = $values[2]
        $Anzeigename = $Vorname + " " + $Nachname
        $email = $Vorname.Substring(0, 1) + $Nachname.Substring(0, 1) + "@avatexschool.onmicrosoft.com"
        $email2 =  $Vorname.Substring(0, 1) + $Nachname.Substring(1, 1) + "@avatexschool.onmicrosoft.com"
        if ($EmailAddress -notcontains $email) {
            New-MsolUser -FirstName "$Vorname" -LastName "$Nachname" -DisplayName "$Anzeigename" -UserPrincipalName "$email" -Password "$Passwort"
        }
        elseif ($EmailAddress -notcontains $email2) {
            New-MsolUser -FirstName "$Vorname" -LastName "$Nachname" -DisplayName "$Anzeigename" -UserPrincipalName "$email2" -Password "$Passwort"
        }
        else {
            Write-Host "Die Email fuer $Anzeigename ist bereits besetzt"
        }
        }
    }



Remove-Item -Path $Outputpath
Write-Host "Benutzer wurden erstellt."