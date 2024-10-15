# Julio Quinones StudentID: 010973743



#Begin the while loop
while ($true) {
    try {
        #Prompts user for input
        $userinput = Read-Host "Enter a number (1 through 5)."
        
        switch ($userinput) {
            1 {
                #grab the date and place it into the log file prior to appending the files added
                $date = Get-Date -Format "MM-DD-YYYY"
                $date | Out-File -FilePath .\Requirements1\DailyLog.txt -Append
                Get-ChildItem -Path .\*.log -Recurse -Force | Out-File -FilePath .\Requirements1\DailyLog.txt -Append
            }
            2 {
                #grab the items from within the Requirements1 folder, order them, then output to the file
                Get-ChildItem -Path .\Requirements1 | Sort-Object Name -Descending | Format-Table Name, LastAccessTime, LastWriteTime |
                Out-File -FilePath .\Requirements1\C916contents.txt
            }
            3 {
                #Acquire the CPU and RAM stats from the system then publish them to the terminal 
                $cpu = Get-WmiObject win32_processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average
                $ram = Get-WmiObject Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
                
                Write-Host "CPU Usage is currently: $cpu" 
                Write-Host "RAM Usage is currently: $ram"
            }
            4 {
                #list all active processes and sort them in an external grid
                Get-Process | Sort-Object VirtualMemorySize | Out-GridView
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