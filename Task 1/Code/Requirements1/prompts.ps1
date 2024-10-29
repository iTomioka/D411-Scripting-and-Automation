# Julio Quinones StudentID: 010973743



#Begin the while loop
while ($true) {
    try {
        #Prompts user for input
        $userinput = Read-Host "Enter a number (1 through 5)."
        
        switch ($userinput) {
            1 {
                #grab the date and place it into the log file prior to appending the files added
                $date = Get-Date -Format "MM-dd-yyyy"
                $date | Out-File -FilePath "$PSScriptRoot\DailyLog.txt" -Append
                Get-ChildItem -Path "$PSScriptRoot\*.log" -Recurse -Force | Out-File -FilePath "$PSScriptRoot\DailyLog.txt" -Append
            }
            2 {
                #grab the items from within the Requirements1 folder, order them, then output to the file
                Get-ChildItem -Path $PSScriptRoot | Sort-Object Name -Descending | Format-Table Name, LastAccessTime, LastWriteTime |
                Out-File -FilePath "$PSScriptRoot\C916contents.txt"
            }
            3 {
                try {
                    #Acquire the cpu and ram stats from the system then publish to terminal
                    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

                    # Get total and free physical memory
                    $totalMemory = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue + (Get-Counter '\Memory\Committed Bytes').CounterSamples.CookedValue / 1MB
                    $freeMemory = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
                    $usedMemory = $totalMemory - $freeMemory

                    Write-Host "CPU Load: $cpuLoad%"
                    Write-Host "Memory Usage: $usedMemory MB / $totalMemory MB"
                } catch [System.OutOfMemoryException] {
                    Write-Host "System ran out of memory while processing"
                    }
            }
            4 {
                #list all active processes and sort them in an external grid
                Get-Process | Sort-Object ID, Name, VM | Sort-Object VM | Out-GridView
            }
            5 {
                #exit the loop
                Write-Host "Exiting..."
                exit
            }
            #error catch if something other than 1 through 5 is entered
            default {Write-Host "Please select a number 1 through 5."}

        }

    } catch {
        Write-Host "Error $_"
    }
}