$userwins = 0
$compwins = 0

while($true) {
    Write-Host("1 - Rock, 2 - Paper, 3 -Scissors")
    $user = Read-Host("Enter a choice: ")
    $comp = Get-Random -Minimum 1 -Maximum 4

    if($user -eq $comp) {
        Write-Host("Its a tie.")
        Write-Host("User: $user  Computer: $comp")
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    if(($user -eq 1) -and ($comp -eq 2)) {
        Write-Host("Computer wins!")
        Write-Host("User: $user  Computer: $comp")
        $compwins = $compwins + 1
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    if(($user -eq 2) -and ($comp -eq 1)) {
        Write-Host("User wins!")
        Write-Host("User: $user  Computer: $comp")
        $userwins = $userwins + 1
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    if(($user -eq 3) -and ($comp -eq 1)) {
        Write-Host("Computer wins!")
        Write-Host("User: $user  Computer: $comp")
        $compwins = $compwins + 1
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    if(($user -eq 2) -and ($comp -eq 3)) {
        Write-Host("Computer wins!")
        Write-Host("User: $user  Computer: $comp")
        $compwins = $compwins + 1
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    if(($user -eq 3) -and ($comp -eq 2)) {
        Write-Host("User wins!")
        Write-Host("User: $user  Computer: $comp")
        $userwins = $userwins + 1
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    if(($user -eq 1) -and ($comp -eq 3)) {
        Write-Host("User wins!")
        Write-Host("User: $user  Computer: $comp")
        $userwins = $userwins + 1
        Write-Host("User Wins: $userwins  Computer Wins: $compwins")
    }

    Write-Host("")
    Write-Host("")
    Write-Host("")

}