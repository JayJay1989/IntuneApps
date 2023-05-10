function Get-RandomCharacters {
    [CmdletBinding()]
    param(
        [int] $length,
        [string] $characters
    )
    if ($length -ne 0 -and $characters -ne '') {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = "" # https://blogs.msdn.microsoft.com/powershell/2006/07/15/psmdtagfaq-what-is-ofs/
        return [String]$characters[$random]
    } else {
        return
    }
}

function Get-RandomPassword {
    [CmdletBinding()]
    param(
        [int] $LettersLowerCase = 2,
        [int] $LettersHigherCase = 2,
        [int] $Numbers = 2,
        [int] $SpecialChars = 2,
        [int] $SpecialCharsLimited = 0
    )
    $Password = @(
        Get-RandomCharacters -length $LettersLowerCase -characters 'abcdefghiklmnoprstuvwxyz'
        Get-RandomCharacters -length $LettersHigherCase -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
        Get-RandomCharacters -length $Numbers -characters '1234567890'
        Get-RandomCharacters -length $SpecialChars -characters '!$%?@#'
        Get-RandomCharacters -length $SpecialCharsLimited -characters '!$#'
    )
    $StringPassword = $Password -join ''
    $StringPassword = ($StringPassword.ToCharArray() | Get-Random -Count $StringPassword.Length) -join ''
    return $StringPassword
}

function Create-LocalWindowsAccount
{
    [CmdletBinding()]
    param(
        [string] $Username,
        [string] $Paswd,
        [datetime] $Expiration
    )

    $Password = ConvertTo-SecureString $Paswd –AsPlainText –Force
    $UserID = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
    $FileName = "C:\intune\localadm.txt"

    if($UserID){
        Set-LocalUser -Name $Username -AccountExpires $renewedExpireDate -Password $Password
    }else{
        New-LocalUser $Username -Password $Password -FullName "Local Admin" -Description "Local Administrator account."
        Add-LocalGroupMember -Group "Administrators" -Member $Username
        Set-LocalUser -Name $Username -AccountExpires $renewedExpireDate -Password $Password
    }

    Write-To-File -Username $Username -Passwd $Paswd -Expiration $Expiration -FileName $FileName
}

function Write-To-File{
    [CmdletBinding()]
    param(
        [string] $Username,
        [string] $Passwd,
        [datetime] $Expiration,
        [string] $FileName
    )
    
    $renewedExpireDateString = $Expiration.ToString("MM/dd/yyyy HH:mm:ss")

    if (Test-Path $FileName) {
      Remove-Item $FileName
    }

    $contentToAdd = @"
Your admin account will be vaild until $renewedExpireDateString
Use the following data to run software as administrator:

User:     .\$Username
Password: $Passwd

You're not allowed to use this account for your daily business! 
"@

    Add-Content $FileName $contentToAdd
}

$LocalUser = "localadm"
$Password = Get-RandomPassword
$renewedExpireDate = (Get-date).AddHours(3)

Create-LocalWindowsAccount -Username $LocalUser -Paswd $Password -Expiration $renewedExpireDate
exit 0