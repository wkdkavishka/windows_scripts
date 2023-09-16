param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

"Elivated Privileges"

# ----------------------------------------



$scriptpath = Split-Path $MyInvocation.MyCommand.Path # get script path and split the script name
Write-host "My directory is $scriptpath"
New-Item -Path "$scriptpath" -Name "Drivers" -ItemType "directory" # make directory

# export drivers 
dism /online /export-driver /destination:"$scriptpath\Drivers"

Write-host "Exported to the folder Drivers"
pause