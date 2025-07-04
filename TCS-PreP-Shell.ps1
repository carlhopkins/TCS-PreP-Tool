# TCS (Machine) PreParation Tool - v25.07 - Copyright (c) 2025 Carl Hopkins

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'SilentlyContinue'
$wshell = New-Object -ComObject Wscript.Shell
$Button = [System.Windows.MessageBoxButton]::YesNoCancel # Not required?
$ErrorIco = [System.Windows.MessageBoxImage]::Error # Not required?
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

# Init
Write-Host "+===================================================+"
Write-Host ".              TCS PreP Shell - v25.07              ."
Write-Host "+===================================================+"
Write-Host ""
Write-Host "Loading, please wait..."
Write-Host ""

# Hack to load in required resources
Import-Module BitsTransfer
Start-BitsTransfer -Source "https://raw.githubusercontent.com/carlhopkins/TCS-PreP-Tool/main/bimage.jpg" -Destination bimage.jpg
Start-BitsTransfer -Source "https://raw.githubusercontent.com/carlhopkins/TCS-PreP-Tool/main/himage.jpg" -Destination himage.jpg
Add-Type -Assembly System.Drawing
$bimage = [System.Drawing.Image]::FromFile("./bimage.jpg")
Add-Type -Assembly System.Drawing
$himage = [System.Drawing.Image]::FromFile("./himage.jpg")

# Check if winget is installed
Write-Host "Checking for winget..."
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    'Winget Already Installed'
}  
else{
	Write-Host "Winget not found, installing it now."
    $ResultText.text = "`r`n" +"`r`n" + "Installing Winget... Please Wait"
	Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
	$nid = (Get-Process AppInstaller).Id
	Wait-Process -Id $nid
	Write-Host "Winget Installed"
    $ResultText.text = "`r`n" +"`r`n" + "Winget Installed - Ready for Next Task"
}

# GUI Specs
$Form                         = New-Object system.Windows.Forms.Form
$Form.ClientSize              = New-Object System.Drawing.Point(780,780)
$Form.text                    = "TCS (Machine) PreP Tool"
$Form.StartPosition           = "CenterScreen"
$Form.TopMost                 = $false
$Form.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#e9e9e9")
$Form.AutoScaleDimensions     = '192, 192'
$Form.AutoScaleMode           = "Dpi"
$Form.AutoSize                = $True
$Form.AutoScroll              = $True
$Form.ClientSize              = '700, 700'
$Form.FormBorderStyle         = 'FixedSingle'

# GUI Icon
$iconBase64                   = '/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAgACADASIAAhEBAxEB/8QAGAABAAMBAAAAAAAAAAAAAAAACQcICgP/xAArEAABBAEDAwQCAQUAAAAAAAACAQMEBQYHERIICSEAExQxFSIKIzI0QVL/xAAXAQEBAQEAAAAAAAAAAAAAAAAFBgME/8QAJhEAAQMDBAEEAwAAAAAAAAAAAQIDEQQhQQASEzFhBTJxsVGBof/aAAwDAQACEQMRAD8AIftadvXIO5x1l43pfSPFX17/ACsshtNuX4eqZIPkSETZeTn7g22K+CddaFVEVUkVTux9nbpX0H6akwzSvHa2t1SeciN0NxOzRCsLQkIVkuvtvzEB9tW+QezDhk97ytcARHUQol/j9dLDOSdLma5NgGqcii1eyt5ytt6KqajfmnscZQnEi15STBlqVMmsttrIdVWmWxEk4ueUtHpv0hysBnu2GsF5f6d2V8qvHpTp3fK7k89l5OCOZNlH+ZIdfBFQ2mjBokIvabb5mCcrz6wdrSZ8/f7HkjwZtpajoWFNl2pc2xjJnrBgHBAWclITBI662doHXzQ7TyVl0zBrS2xeBDCxl2FfFfQosUt0SScZ9tqSkfx5f9r2U8fv59Vk9bDejzt36OaC48zm1XpPhMHLrxPl/k3o62Vg0BqLgmU6abzxOEoi6rnJPKjsA7KPo4v5MHVjozhXT9d6Y1lDp/I1SyWYw40DGP1cuVTRUdRx6X8mO2BxH3eKCPMjNwHDXYBLdd29+0ckT40fUcXIeCduJif592+B1o0+lnXO+046Za9msqcaF6vsfkVmRNocO/oZTjj5/wBF1kh+QyYRDEgeQxFVT73BBYPpszKlmTcbyLJnZF7Gmz0tLUn+KyrNFdVH+SGXEjFxDbJOXFCbUd+O3rPnpzrW/h9IVTKbORAVV9sgVOcfflvsi+C8kq/afa+fO3qwrXc8XHqMo8GDbyJDpe86rNg/AZfd4oPuOA25sp7IiKSJuqJ6mFvepUlYSGS42qfaUgi8gmSBkgyZ6idVCW/TayiSkvBtxEe4Eg2ggRJ7AIgRc6Y7uVdxHJcxr7FWbayxHCW1QINRWH7V5kbg+difaUkbHluqttucUHZTJf7EAfq+yocs1NSQTsU5StkUhuOSE3GJTXi2ip/yKCnnz9KvlV9dNYetHONYJskn7A61mVuLiRnCV94F+hdfJVdc2Tx+xfXj1EpEpLuvlV8qq/79L06at10PPgISOkgyZOVGw6wJ+ToV9ylaaUxTysqiVEQIF4SLmJyYn8DX/9k='
$iconBytes                    = [Convert]::FromBase64String($iconBase64)
$stream                       = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)
$Form.Icon                    = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$Form.Width                   = $objImage.Width
$Form.Height                  = $objImage.Height

#Panel1 - L/H Spacer

$Panel1                          = New-Object system.Windows.Forms.Panel
$Panel1.height                   = 250
$Panel1.width                    = 250
$Panel1.location                 = New-Object System.Drawing.Point(5,75)

#Panel2 - Actions

$Panel2                          = New-Object system.Windows.Forms.Panel
$Panel2.height                   = 250
$Panel2.width                    = 250
$Panel2.location                 = New-Object System.Drawing.Point(265,75)

$warptweaks                      = New-Object system.Windows.Forms.Button
$warptweaks.Image                = $bimage
$warptweaks.width                = 205
$warptweaks.height               = 205
$warptweaks.location             = New-Object System.Drawing.Point(5,10)
$warptweaks.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

#Panel3 - R/H Spacer

$Panel3                          = New-Object system.Windows.Forms.Panel
$Panel3.height                   = 250
$Panel3.width                    = 250
$Panel3.location                 = New-Object System.Drawing.Point(525,75)

# Status Panel

$Panel4                          = New-Object system.Windows.Forms.Panel
$Panel4.height                   = 65
$Panel4.width                    = 730
$Panel4.location                 = New-Object System.Drawing.Point(20,410)

$Label10                         = New-Object system.Windows.Forms.Label
$Label10.text                    = "Current Status:"
$Label10.AutoSize                = $true
$Label10.width                   = 205
$Label10.height                  = 20
$Label10.location                = New-Object System.Drawing.Point(5,5)
$Label10.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ResultText                      = New-Object system.Windows.Forms.TextBox
$ResultText.width                = 725
$ResultText.height               = 40
$ResultText.location             = New-Object System.Drawing.Point(5,25)
$ResultText.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',8)

# Branding Panel

$Panel0                          = New-Object system.Windows.Forms.Panel
$Panel0.height                   = 70
$Panel0.width                    = 730
$Panel0.location                 = New-Object System.Drawing.Point(5,5)

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 398
$PictureBox1.height              = 38
$PictureBox1.location            = New-Object System.Drawing.Point(168,15)
$PictureBox1.image               = $himage
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$Form.controls.AddRange(@($Panel0,$Panel1,$Panel2,$Panel3,$Panel4))
$Panel0.controls.AddRange(@($PictureBox1))
$Panel2.controls.AddRange(@($warptweaks))
$Panel4.controls.AddRange(@($Label10,$ResultText))

# Beginning of functions

Write-Host "TCS PreP Tool Loaded & Ready..."
$ResultText.text = "TCS PreP Tool Loaded & Ready..."

$warptweaks.Add_Click({
Write-Host "Cleanup in Progress..."
    $ResultText.text = "Cleanup in Progress..."

Write-Host "Disabling Telemetry..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

Write-Host "Disabling Activity History..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0

Write-Host "Disabling Feedback..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null

Write-Host "Disabling Tailored Experiences..."
    If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

Write-Host "Disabling Advertising ID..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

Write-Host "Stopping and disabling Diagnostics Tracking Service..."
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue
    Set-Service "DiagTrack" -StartupType Disabled
    Write-Host "Stopping and disabling WAP Push Service..."
    Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
    Set-Service "dmwappushservice" -StartupType Disabled
    Write-Host "Enabling F8 boot menu options..."
    bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

Write-Host "Stopping and disabling Home Groups services..."
    Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
    Set-Service "HomeGroupListener" -StartupType Disabled
    Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
    Set-Service "HomeGroupProvider" -StartupType Disabled

Write-Host "Stopping and disabling Superfetch service..."
    Stop-Service "SysMain" -WarningAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled

Write-Host "Disabling Hibernation..."
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0
    If ((get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
    	Write-Host "Showing task manager details..."
    	$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
    	Do {
      		Start-Sleep -Milliseconds 100
        	$preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
    	} Until ($preferences)
    	Stop-Process $taskmgr
    	$preferences.Preferences[28] = 0
    	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
    } else {Write-Host "Task Manager patch not run in builds 22557+ due to bug"}

Write-Host "Showing file operations details..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

Write-Host "Hiding Task View button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

Write-Host "Hiding People icon..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

Write-Host "Hide tray icons..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 1

Write-Host "Changing default Explorer view to This PC..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

Write-Host "Hiding 3D Objects icon from This PC..."
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

Write-Host "Disable News and Interests"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
    Set-ItemProperty -Path  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

Write-Host "Disable Meet Now button"
    If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1

Write-Host "Stopping and disabling Diagnostics Tracking Service..."
    Stop-Service "DiagTrack"
    Set-Service "DiagTrack" -StartupType Disabled

Write-Host "Showing known file extensions..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0        

Write-Host "Removing Bloatware"

$Bloatware = @(
    #Sponsored Windows AppX Apps
    #Add sponsored/featured apps to remove in the "*AppName*" format
    "*EclipseManager*"
    "*ActiproSoftwareLLC*"
    "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
    "*Duolingo-LearnLanguagesforFree*"
    "*PandoraMediaInc*"
    "*CandyCrush*"
    "*BubbleWitch3Saga*"
    "*Wunderlist*"
    "*Flipboard*"
    "*Twitter*"
    "*Facebook*"
    "*Royal Revolt*"
    "*Sway*"
    "*Speed Test*"
    "*Dolby*"
    "*Viber*"
    "*ACGMediaPlayer*"
    "*Netflix*"
    "*OneCalendar*"
    "*LinkedInforWindows*"
    "*HiddenCityMysteryofShadows*"
    "*Hulu*"
    "*HiddenCity*"
    "*AdobePhotoshopExpress*"
    "*HotspotShieldFreeVPN*"
    "*TikTok*"
    "*Whatsapp*"
    "*WhatsApp*"
    "SpotifyAB.SpotifyMusic"
    "Disney.37853FC22B2CE"
    "*Spotify*"
    "*Minecraft*"
    "*Royal Revolt*"
    "*Sway*"
    "*Speed Test*"
    "*Dolby*"
    "*Disney*"
)
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Host "Trying to remove $Bloat."
        $ResultText.text = "Trying to remove $Bloat..."
    }

# Begin winget loop for base utils

#Write-Host "Installing 7-Zip Compression Tool"
#    $ResultText.text = "`r`n" +"`r`n" + "Installing 7-Zip Compression Tool... Please Wait" 
#    winget install -e 7zip.7zip | Out-Host
#    if($?) { Write-Host "Installed 7-Zip Compression Tool" }
#    $ResultText.text = "`r`n" + "Finished Installing 7-Zip Compression Tool" + "`r`n" + "`r`n" + "Ready for Next Task"

# End and exit script
Write-Host "TCS PreP Tool actions complete! Please reboot your system NOW!"
    $ResultText.text = "TCS PreP Tool actions complete! Please reboot your system NOW!"

})

[void]$Form.ShowDialog()