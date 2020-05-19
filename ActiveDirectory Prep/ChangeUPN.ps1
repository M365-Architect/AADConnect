# tiny script to adjust the UPNs under a certain OU in an AD

$SearchOU = "" #distinguishedName of the root OU that will be _recursively_ searched for AD user objects
$oldUPNSuffix = "olddomain.tld" #the name of the old UPN suffix that should be replaced. Without "@"!
$newUPNSuffix = "newSuffix.tld" #the name of the new UPN suffix - should match your primary SMTP domain. Without "@"!


if(-not (Get-Module ActiveDirectory)) {Import-Module ActiveDirectory}

$allUsers = Get-ADUser -Filter * -SearchBase $SearchOU
Write-Host ($allUsers.Count.ToString() + " accounts found!")
foreach($user in $allUsers)
{
    if($user.UserPrincipalName -like ("*" + $oldUPNSuffix))
    {
        $newUPN = $user.UserPrincipalName.Split("@")[0]
        $newUPN += "@"
        $newUPN += $newUPNSuffix
        Write-Host ("Changing UPN '" + $user.UserPrincipalName + "' to '" + $newUPN + "'")
        Set-ADUser -Identity $user.distinguishedName -UserPrincipalName $newUPN
    }
}