Set-Variable -Name "DiariesDirectory" -Value "~\Documents\Notes\Diaries"
Set-Variable -Name "DiaryEditor" -Value "code"
New-Item -ItemType Directory -Force -Path $DiariesDirectory | Out-Null
function Diary {
    function MakeNote {
        param (
            $Path
        )
        if (!(Test-Path $Path)) {
            New-Item $Path | Out-Null
        }
        Invoke-Expression "$DiaryEditor $Path"
    }

    function Add-Diary {
        param (
            $Year,
            $Month,
            $Name
        )

        $YPath = Join-Path -Path $DiariesDirectory -ChildPath $Year    
        New-Item -ItemType Directory -Force -Path $YPath | Out-Null
        
        $MPath = Join-Path -Path $YPath -ChildPath $Month
        New-Item -ItemType Directory -Force -Path $MPath | Out-Null
        
        $notePath = Join-Path -Path $MPath -ChildPath $Name
        MakeNote -Path $($notePath)
    }

    

    if ($args[0] -eq "today" -or $args[0] -eq "t") {
        $DateTime = $([DateTime]::Today)
    }
    elseif ($args[0] -eq "tomorrow" -or $args[0] -eq "to") {
        $DateTime = $([DateTime]::Today.AddDays(+1))
    }
    elseif ($args[0] -eq "yesterday" -or $args[0] -eq "y") {
        $DateTime = $([DateTime]::Today.AddDays(-1))
    }
    else {
        $Message = @'
Unsupported flag, use:
    Diary [t or today] for adding diary for today
    Diary [to or tomorrow] for adding diary for tomorrow
    Diary [y or yesterday] for adding diary for yesterday
'@
        Write-Output $Message
        return
    }

    $YearString = $DateTime.ToString("yyyy")
    $MonthString = $DateTime.ToString("MM")
    $FileName = "$($DateTime.ToString('D')).md"
    Add-Diary -Year $YearString -Month $MonthString -Name $FileName 


}