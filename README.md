# VMInit.d
Init script to start and keep vmware workstation VMs running

# Setup
On my system I store my Virtual Machines in D:\VirtualMachines.  In that directory I also created a folder named init.d.
For each of the vms I want to start/stop/suspend with the script I create shortcuts to the VM directory like:
```
S10.myfirstVM -> D:\VirtualMachines\myfirstVM
s20.anotherVM -> D:\VirtualMachines\anotherVM
S30.yetanother -> D:\VirtualMachines\yetanother
K10.myfirstVM -> D:\VirtualMachines\myfirstVM
K20.anotherVM -> D:\VirtualMachines\anotherVM
K30.yetanother -> D:\VirtualMachines\yetanother
```

Then in the Windows Task Scheduler I setup my script to run with -start on startup and on event Security/4647.
This keeps the VMs running when I log out, or restart the server.

# Task Scheduler
To use the script, I have it configured in the Windows Task Scheduler with the following triggers:
- At startup
- On disconnect from user session
- On event - Security Event Id: 4647
These events will execute the following command
```
powershell -File D:\VirtualMachines\init.d\VMInit.ps1 -start
```
This will ensure the VMs start on system startup and continue to run if the user interacts with them them Workstation and then logs out of their session.  Without the last two triggers, the session logout can cause the VMs to be suspended.

# Options
- start : starts the VMs listed with S## in order of the numbers.
- stop: stops the VMs listed with K## in *reverse* order of the numbers.
- suspend: suspends the VMs listed with K## in *reverse* order of the numbers.

NOTE: The K## entries work in reverse from what you would expect from normal init.d sort of behavior.  I did this because in my case I just want the servers to start in reverse order from how they started.  It was easier to just duplicate the ordering from the S## links and have the script process them in reverse.


