# Julio Quinones StudentID: 010973743

# Variable creation
$serverconnection = "SRV19-PRIMARY\SQLEXPRESS"
$dbname = "ClientDB"
$csv = "C:\Users\LabAdmin\Desktop\Requirements2\NewClientData.csv"

# Checking for DB named ClientDB
try {
    $dbchecker = Read-SQLTableData -ServerInstance $serverconnection -DatabaseName $dbname

    if ($dbchecker) {
        Write-Host "DB Found. Deleting..."
        Invoke-Sqlcmd -ServerInstance $serverconnection -Query "DROP DATABASE [$dbname]"
        Write-Host "DB Deleted."
    } else {
        Write-Host "DB Not Found"
    }
} catch {
    Write-Host "Error checking for database: $_"
}

# Create a new DB named ClientDB on the SQL Server Instance
try {
    Invoke-Sqlcmd -ServerInstance $serverconnection -Query "CREATE DATABASE [ClientDB]"
    Write-Host "DB Created Successfully"
} catch {
    Write-Host "Error creating database: $_"
}

# Create a new table and name it Client_A_Contacts
$tablecreation = @'
CREATE TABLE [Client_A_Contacts] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(50),
    County VARCHAR(50),
    Zip INT,
    OfficePhone VARCHAR(50),
    MobilePhone VARCHAR(50)
)
'@

try {
    Invoke-Sqlcmd -DatabaseName $dbname -ServerInstance $serverconnection -Query $tablecreation
    Write-Host "Table created successfully"
} catch {
    Write-Host "Error creating table: $_"
}

# Insert the data from the NewClientData.CSV
try {
    $data = Import-Csv -Path $csv

    foreach ($row in $data) {
        $insert = @"
        INSERT INTO [Client_A_Contacts] (FirstName, LastName, City, County, Zip, OfficePhone, MobilePhone)
        VALUES ('$($row.first_name)', '$($row.last_name)', '$($row.city)', '$($row.county)', '$($row.zip)', '$($row.officephone)', '$($row.mobilephone)')
"@
        Invoke-Sqlcmd -Database $dbname -ServerInstance $serverconnection -Query $insert
    }
    Write-Host "Data inserted into the table successfully."
} catch {
    Write-Host "Error inserting data: $_"
}

# Generate output file with query results
try {
    Invoke-Sqlcmd -Database $dbname -ServerInstance $serverconnection -Query 'SELECT * FROM dbo.Client_A_Contacts' > .\SqlResults.txt
    Write-Host "Results saved to SqlResults.txt."
} catch {
    Write-Host "Error generating query results: $_"
}