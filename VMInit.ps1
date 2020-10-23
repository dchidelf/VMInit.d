param (
   [switch] $start,
   [switch] $stop,
   [switch] $suspend,
   [string] $delay = 0
)




function Start-VMs {
   $VMDELAY = $args[0]
   $sh = New-Object -ComObject WScript.Shell
   Get-ChildItem -Path D:\VirtualMachines\init.d\* -Include S* | Sort-Object -Property Name | ForEach-Object {
    
    $VMPATH = $sh.CreateShortcut($_.FullName).TargetPath
    $VMXFILE = Get-ChildItem -Path $VMPATH\* -Include *.vmx | Select-Object -First 1 | % { $_.FullName }
   
    Write-Host "Starting $VMPATH"

    vmrun -T ws start "$VMXFILE" nogui

    if ($VMDELAY -gt 0) {
       Start-Sleep -s $VMDELAY
    }

   }
}

function Stop-VMs {
   $VMDELAY = $args[0]
   $SUSPEND = $args[1]
   $sh = New-Object -ComObject WScript.Shell
   Get-ChildItem -Path D:\VirtualMachines\init.d\* -Include K* | Sort-Object -Descending -Property Name | ForEach-Object {
    
    $VMPATH = $sh.CreateShortcut($_.FullName).TargetPath
    $VMXFILE = Get-ChildItem -Path $VMPATH\* -Include *.vmx | Select-Object -First 1 | % { $_.FullName }
   
    

    if ($SUSPEND) {
       Write-Host "Suspending $VMPATH"
       vmrun -T ws suspend "$VMXFILE" 
    } else {
       Write-Host "Stopping $VMPATH"
       vmrun -T ws stop "$VMXFILE" 
    }

    if ($VMDELAY -gt 0) {
       Start-Sleep -s $VMDELAY
    }

   }
}

if ($start) {
  Start-VMs $delay
} elseif ($stop) {
  Stop-VMs $delay 0
} elseif ($suspend) {
  Stop-VMs $delay 1
} else {
   Write-Host "Specify either -start or -stop"
   exit
}
