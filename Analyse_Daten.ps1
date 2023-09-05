#Analysieren und sortieren der grössten 100 Daten und sie anschliessend in einer TXT-Datei speichern.

# Verzeichnis, in dem nach Dateien gesuchen wird
$verzeichnis = "C:\Users"

# Pfad der Ausgabedatei
$ausgabedatei =  $PSScriptRoot + "\Analyse_Daten.txt"

# Liste der Dateien holen
$files = Get-ChildItem $verzeichnis -File -Recurse | Sort-Object Length -Descending | Select-Object -First 100

# Öffne oder erstelle der Ausgabedatei
$files | ForEach-Object {
    $dateiendung = $_.Extension
    $erstelldatum = $_.CreationTime
    $bearbeitungsdatum = $_.LastWriteTime
    $groesseInMB = [math]::Round(($_.Length / 1MB), 2)

    $output = @"
Dateiname: $($_.Name)
Dateipfad: $($_.FullName)
Groesse in MB: $groesseInMB MB
Dateiendung: $dateiendung
Erstelldatum: $erstelldatum
Letztes Bearbeitungsdatum: $bearbeitungsdatum
------------------------
"@

    # Informationen in die Ausgabedatei schreiben (neue Datei erstellen, wenn nicht vorhanden)
    $output | Out-File -FilePath $ausgabedatei -Append
}

#Speicherort auf Konsole Anzeigen
Write-Host "Die Informationen wurden in $ausgabedatei gespeichert."

