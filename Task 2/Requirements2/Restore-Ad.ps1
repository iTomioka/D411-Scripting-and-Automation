# Julio Quinones StudentID: 010973743



#creating variables
$oupath = "ou=Finance,dc=consultingfirm,dc=com"
$ouchecker = Get-ADOrganizationalUnit -Identity $oupath -ErrorAction SilentlyContinue

if ($ouchecker) {
    Write-Output "Found OU Finance, deleting"
    Remove-ADOrganizationalUnit -Identity $oupath -Confirm:$false
    Write-Output "Deleted"
} else {
    Write-Output "OU Finance Not Found"
}

#Add the OU Finance
New-ADOrganizationalUnit -Name "Finance" -Path "dc=consultingfirm, dc=com"
$oucreator = Get-ADOrganizationalUnit -Identity $oupath -ErrorAction SilentlyContinue

#Checks if the OU was created
if ($oucreator) {
    Write-Output "OU Finance created successfully"
} else {
    Write-Output "OU Finance failed to create"
}

#Adding in the CSV
$csv = ".\financePersonnel.csv"
$oupath = "ou=Finance,dc=consultingfirm,dc=com"

if ($csv) {
    $financeusers = Import-Csv -Path $csv
    $defaultpassword = "DefaultAcct.Pass123*"
    $securepassword = ConvertTo-SecureString $defaultpassword -AsPlainText -Force


    #begin the loop for importing the users from the CSV
    foreach ($user in $financeusers) {
        $displayname = "$($user.First_Name) $($user.Last_Name)"

        #Links the users to values we create from values pre-existing in the CSV
        New-AdUser `
        -Pathh $oupath`
        -Samaccountname $user.samAccount `
        -GivenName $user.First_Name `
        -Surname $user.Last_Name `
        -Name $displayname `
        -DisplayName $displayname `
        -PostalCode $user.PostalCode `
        -OfficePhone $user.OfficePhone `
        -MobilePhone $user.MobilePhone `
        -AccountPassword $securepassword`
        -Enabled $true`
    }
    Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt
}