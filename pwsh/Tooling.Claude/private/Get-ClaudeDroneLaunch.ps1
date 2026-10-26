function Get-ClaudeDroneLaunch {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Agent,

        [string] $Model,

        [string] $Prompt,

        [Parameter(Mandatory)]
        [ValidateSet('windows-terminal', 'pwsh')]
        [string] $Launcher,

        [Parameter(Mandatory)]
        [string] $WorkingDirectory,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Index = 1
    )

    # The claude call as pwsh reads it: every value single-quoted, so a prompt keeps its spaces and quotes.
    $quote = { param([string] $Text) "'" + $Text.Replace("'", "''") + "'" }
    $call = "& claude --agent $(& $quote $Agent)"
    if ($Model) {
        $call += " --model $(& $quote $Model)"
    }
    if ($Prompt) {
        $call += " $(& $quote $Prompt)"
    }

    # One argument for the outer command line: double-quoted, with its own double quotes escaped.
    $command = '"' + $call.Replace('"', '\"') + '"'

    if ($Launcher -eq 'windows-terminal') {
        $filePath = 'wt.exe'
        # wt reads an unescaped semicolon as the start of its next command.
        $argumentList = "-d `"$WorkingDirectory`" new-tab --title claude-drone-$Index pwsh -NoExit -Command $($command.Replace(';', '\;'))"
    }
    else {
        $filePath = 'pwsh'
        $argumentList = "-NoExit -Command $command"
    }

    [pscustomobject]@{
        Index            = $Index
        Agent            = $Agent
        Model            = $Model
        Launcher         = $Launcher
        FilePath         = $filePath
        ArgumentList     = $argumentList
        WorkingDirectory = $WorkingDirectory
        CommandLine      = "$filePath $argumentList"
    }
}
