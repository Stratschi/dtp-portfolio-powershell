[xml]$XAMLMain = @'
<Window x:Class="Portfolioarbeit.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Portfolioarbeit"
        mc:Ignorable="d"
        Title="Client Info" Height="444" Width="350">
    <Grid Margin="0,0,0,7">
        <TextBlock HorizontalAlignment="Left" Margin="23,21,0,0" TextWrapping="Wrap" Text="Computername:" VerticalAlignment="Top" Width="97" FontSize="11"/>
        <TextBox x:Name="EingabeComputername" HorizontalAlignment="Center" Margin="0,19,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="138"/>
        <Button x:Name="AnzeigeButton" Content="Anzeigen" HorizontalAlignment="Left" Margin="263,17,0,0" VerticalAlignment="Top" RenderTransformOrigin="-0.308,-0.098" Width="61"/>
        <ProgressBar x:Name="LadeAnzeige" HorizontalAlignment="Center" Height="10" Margin="0,42,0,0" VerticalAlignment="Top" Width="138" BorderBrush="#FFFCFCFC" Background="#FFFFFBFB" IsIndeterminate="True" OpacityMask="{DynamicResource {x:Static SystemColors.InfoBrushKey}}"/>
        <TextBlock x:Name="ComputerInfo" HorizontalAlignment="Left" Margin="23,77,0,0" TextWrapping="Wrap" Text="Computerinfo" VerticalAlignment="Top" Width="79" FontSize="9" TextDecorations="Underline" FontWeight="Bold"/>
        <TextBlock x:Name="Datum___Zeit" HorizontalAlignment="Left" Margin="23,94,0,0" TextWrapping="Wrap" Text="Datum / Zeit" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="ComputernameText" HorizontalAlignment="Left" Margin="23,115,0,0" TextWrapping="Wrap" Text="Computername" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="Startzeit" HorizontalAlignment="Left" Margin="23,136,0,0" TextWrapping="Wrap" Text="Startzeit" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="Modell" HorizontalAlignment="Left" Margin="23,157,0,0" TextWrapping="Wrap" Text="Modell" VerticalAlignment="Top" RenderTransformOrigin="0.529,0.605" FontSize="10"/>
        <TextBlock x:Name="Benutzername" HorizontalAlignment="Left" Margin="23,178,0,0" TextWrapping="Wrap" Text="Benutzername" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="OS_Info" HorizontalAlignment="Left" Margin="23,0,0,0" TextWrapping="Wrap" Text="OS Info" VerticalAlignment="Center" FontSize="10" TextDecorations="Underline" FontWeight="Bold"/>
        <TextBlock x:Name="Betriebsystem" HorizontalAlignment="Left" Margin="23,225,0,0" TextWrapping="Wrap" Text="Betriebsystem" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="Architektur" HorizontalAlignment="Left" Margin="23,246,0,0" TextWrapping="Wrap" Text="Architektur" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="Netzwerk" HorizontalAlignment="Left" Margin="23,274,0,0" TextWrapping="Wrap" Text="Netzwerk" VerticalAlignment="Top" FontSize="10" TextDecorations="Underline" FontWeight="Bold"/>
        <TextBlock x:Name="IPAdresse" HorizontalAlignment="Left" Margin="23,292,0,0" TextWrapping="Wrap" Text="IP-Adresse" VerticalAlignment="Top" FontSize="10"/>
        <TextBlock x:Name="MACAdresse" HorizontalAlignment="Left" Margin="23,310,0,0" TextWrapping="Wrap" Text="MAC-Adresse" VerticalAlignment="Top" FontSize="10"/>
        <TextBox x:Name="AnzeigeDatum_Zeit" HorizontalAlignment="Left" Margin="107,87,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="162" FontSize="10"/>
        <TextBox x:Name="AnzeigeComputername" HorizontalAlignment="Left" Margin="107,110,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="162" FontSize="10"/>
        <TextBox x:Name="AnzeigeStartzeit" HorizontalAlignment="Left" Margin="107,133,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="162" FontSize="10"/>
        <TextBox x:Name="AnzeigeModell" HorizontalAlignment="Left" Margin="107,156,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="162" FontSize="10"/>
        <TextBox x:Name="AnzeigeBenutzername" HorizontalAlignment="Left" Margin="106,179,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="163" FontSize="10"/>
        <TextBox x:Name="AnzeigeBetriebsystem" HorizontalAlignment="Left" Margin="106,220,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="163" FontSize="10"/>
        <TextBox x:Name="AnzeigeArchitektur" HorizontalAlignment="Left" Margin="106,243,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="163" FontSize="10"/>
        <TextBox x:Name="AnzeigeIPAdresse" HorizontalAlignment="Left" Margin="106,287,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="163" FontSize="10"/>
        <TextBox x:Name="AnzeigeMACAdresse" HorizontalAlignment="Left" Margin="106,310,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="163" FontSize="10"/>

    </Grid>
</Window>
'@

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
$reader = (New-Object System.Xml.XmlNodeReader $XAMLMain)
$windowMain = [Windows.Markup.XamlReader]::Load( $reader )

$XAMLMain.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $windowMain.FindName($_.Name) }

# Button-Click-Ereignis hinzufügen
$WPFAnzeigeButton.Add_Click({
    

    # Hole Computername aus der TextBox
    $computername = $WPFEingabeComputername.Text


   
        $computerInfo = Get-WmiObject Win32_ComputerSystem -ComputerName $computername
        $osInfo = Get-WmiObject Win32_OperatingSystem -ComputerName $computername
        $networkInfo = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $computername | Where-Object { $_.IPEnabled -eq $true }

        # Aktualisiere die UI mit den erhaltenen Informationen
        $WPFAnzeigeDatum_Zeit.Text = Get-Date
        $WPFAnzeigeComputername.Text = $computerInfo.Name
        $WPFAnzeigeStartzeit.Text = $osInfo.LastBootUpTime
        $WPFAnzeigeModell.Text = $computerInfo.Model
        $WPFAnzeigeBenutzername.Text = $computerInfo.UserName
        $WPFAnzeigeBetriebsystem.Text = $osInfo.Caption
        $WPFAnzeigeArchitektur.Text = $osInfo.OSArchitecture
        $WPFAnzeigeIPAdresse.Text = $networkInfo.IPAddress[0]
        $WPFAnzeigeMACAdresse.Text = $networkInfo.MACAddress
   
    
    
})

# Funktion zur Aktualisierung der GUI mit Remote-Systeminformationen
function Update-RemoteSystemInfo {
    $remoteComputerName = $WindowMain.FindName("Eingabe").Text

    # Starten Sie eine Remote-PowerShell-Sitzung
    $session = New-PSSession -ComputerName $remoteComputerName

    Enter-PSSession -Session $session

    # Erhalten Sie Systeminformationen
    $datumzeit = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    $computername = $env:COMPUTERNAME
    $os = Get-WmiObject -Class Win32_OperatingSystem
    $startzeit = [System.Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
    $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
    $benutzername = $env:USERNAME
    $betriebssystem = $os.Caption
    $architektur = $os.OSArchitecture
    $ipadresse = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq 'Ethernet' } | Select-Object -First 1).IPAddress
    $networkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
    $macaddresse = $networkAdapter.MacAddress

    # Remote-Sitzung verlassen
    Exit-PSSession

    # Aktualisieren Sie die Informationen als benutzerdefiniertes Objekt
    $info = @{
        DatumZeit = $datumzeit
        Computername = $computername
        Startzeit = $startzeit.ToString("dd.MM.yyyy HH:mm:ss")
        Modell = $model
        Benutzername = $benutzername
        Betriebssystem = $betriebssystem
        Architektur = $architektur
        IPAdresse = $ipadresse.IPAddressToString
        MACAdresse = $macaddresse
    }

    # GUI mit den Informationen aktualisieren
    $WindowMain.Dispatcher.Invoke({
        $WindowMain.FindName("lblDatumZeit").Content = $info.DatumZeit
        $WindowMain.FindName("lblComputername").Content = $info.Computername
        $WindowMain.FindName("lblStartzeit").Content = $info.Startzeit
        $WindowMain.FindName("lblModell").Content = $info.Modell
        $WindowMain.FindName("lblBenutzername").Content = $info.Benutzername
        $WindowMain.FindName("lblBetriebssystem").Content = $info.Betriebssystem
        $WindowMain.FindName("lblArchitektur").Content = $info.Architektur
        $WindowMain.FindName("lblIPAdresse").Content = $info.IPAdresse
        $WindowMain.FindName("lblMACAdresse").Content = $info.MACAdresse
    })
}
$WindowMain = [Windows.Markup.XamlReader]::Parse($xaml)

# Starte die GUI
$windowMain.ShowDialog() | Out-Null
