Function Test-CloudFlare {
<#
.SYNOPSIS
Remote conection test to 1.1.1.1.
.DESCRIPTION
On user input of computer name or address a remote session is created and issues ping test to one.one.one.one.
.PARAMETER location
A path string for the working directory. Changes directory to the users home directory.
.Parameter Computername
This is a Mandatory pram, and idtenitfys the couptuer for the test.
.Parameter ValidateSet
Determins what output you would prefer Text, CSV, or display.
.Parameter Output
Is what lets us change the output of Text, CSV, or Host
.Example
Use Output .\Test-CloudFlare.ps1 -computername (your IP) -output Text for the file to save all content to a txt and display.
.Example
Use Output .\Test-CloudFlare.ps1 -comutername (your IP) -output CSV Outs the file as a csv file.
.Example 
The Output .\Test-CloudFlare.ps1 -computername (your IP) -output Host will display the output on the screan.
.Notes
Author: Tristan Peterson
Last edit: 2021-11-04
Version 3 - Test-CloudFlare 
Changed Script to function named Test-CloudFlare
Changed Switch block
General clenleyness with indentation


#>
[CmdletBinding()]
# Enabling cmdlet binding.

    param ( 
    [Parameter(Mandatory=$true, Valuefrompipeline=$true)] 
    [Alias('CN','Name')][string[]]$Computername,
    [string] $location = $env:USERPROFILE,
    [ValidateSet("Host","Text","CSV")]
    [string]$Output = "Host")
    #Establishing Parameters for input and location.

    Foreach ($Eachvalue in $Computername) {
    $RemoteSession = New-PSSession -Computername $Eachvalue
    #Remote session as a verryable.
    Enter-PSSession $RemoteSession
    $DateTime = Get-Date
    #Defining Get-Date.
    $TestCF = Test-NetConnection -Computername 'one.one.one.one' -InformationLevel Detailed
    #New Detailed ping test.
    $Props = @{
        'ComputerName' = $Eachvalue
        'PingSuccess' = $TestCF.PingSucceeded
        'NameResolve' = $TestCF.NameResolutionSucceeded
        'ResolvedAddresses' = $TestCF.ResolvedAddresses
    }
    #Creating new Obj named Props.
    $OBJ = New-Object PSObject -Property $Props
    Exit-PSSession
    Remove-PSSession $RemoteSession
    #Creating new OBJ and exciting the session.
    } #Foreach block end.

    Switch -Exact ($Output) {
    "Text" {
        Write-Verbose "Generating Results"

        $OBJ | Out-File $env'./TestResults.txt'
        Add-Content -path "$location/Remnettest.txt" -Value "Computer: $Computername"
        Add-Content -path "$location/Remnettest.txt" -Value "Date Tested: $DateTime"
        Add-Content -path "$location/Remnettest.txt" -Value (Get-Content -path './TestResults.txt')
        Write-Verbose "Finished running test, Displaying"
        notepad.exe './Remnettest.txt'
        remove-item './TestResults.txt'}
        #Generates file and displays it, also removes old TestResults.txt file. Note* Changed order of computer name and date time.
    "CSV" { Write-Verbose "Exporting file as CSV" ; Export-Csv './TestResults.txt'}
    #Exporting file as CSV.
    "Host" {$OBJ}
    #Displays results to screne.
    } #End of Switch.
} #End of Function.

    





