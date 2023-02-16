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


# import drivers 
Get-ChildItem "$scriptpath\Drivers" -Recurse -Filter "*.inf" | ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }


Write-host "Drivers Imported from the folder Drivers"
pause