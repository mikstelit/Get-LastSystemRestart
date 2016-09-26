<#
.Synopsis
   Outputs the time the systems were last restarted.
.DESCRIPTION
   Takes a string array of computer names and outputs 
   to the screen the computer's name and the last time 
   the system was restarted.
.EXAMPLE
   Get-LastSystemRestart $ComputerNames
.EXAMPLE
   $ComputerNames | Get-LastSystemRestart
#>
Function Get-LastSystemRestart
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$ComputerNames
    )

    Process
    {
        Foreach ($ComputerName in $ComputerNames)
        {
            Try
            {
                $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName -ErrorAction Stop
                $UpTime = [Management.ManagementDateTimeConverter]::ToDateTime($OperatingSystem.LastBootUpTime)
            }
            Catch
            {
                $UpTime = $Error[0].Exception.Message
            }

            [psobject]$System = @{
                'Name' = $ComputerName;
                'UpTime' = $UpTime
            }

            Write-Output ('{0}: {1}' -f $System.Name,$System.UpTime)
        }
    }
}