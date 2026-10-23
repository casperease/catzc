function Get-AccostedFragment {
    <#
    .SYNOPSIS
        Renders the commands of an accosted file as a PowerShell fragment for an article, through the one reader.
    .DESCRIPTION
        The file is read and checked by Get-AccostedFile, the one reader, and each command is written the way the pwsh engine runs it
        (ConvertTo-AccostedCallText), so the text in an article is a rendering of the contract form and never hand-written. One line per
        command, `Get-FileLanguage -Path 'README.md'`; the commands of a run stay together and a blank line separates runs. Without -Run
        every run is rendered, with -Run one run, with -Run and -Command one command.
    .PARAMETER Path
        The accosted file, repository-relative or rooted.
    .PARAMETER Run
        The 1-based run to render. Default: every run.
    .PARAMETER Command
        The 1-based command of that run to render. Needs -Run. Default: every command of the run.
    .PARAMETER RepositoryRoot
        The root a relative path and the command contracts resolve against. Default: the repository root.
    .OUTPUTS
        [string] The PowerShell fragment.
    .EXAMPLE
        Get-AccostedFragment -Path pwsh/Catzc.Base.Contracts/accosted/contracts.accosted.yml -Run 3
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Run,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Command,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-True ($PSBoundParameters.ContainsKey('Run') -or -not $PSBoundParameters.ContainsKey('Command')) `
        -ErrorText 'Get-AccostedFragment: -Command names a command of one run, so it needs -Run.'
    $file = Get-AccostedFile -Path $Path -RepositoryRoot $RepositoryRoot
    $contracts = @{}
    foreach ($contract in @(Get-CommandContract -RepositoryRoot $RepositoryRoot)) {
        $contracts[$contract.Name] = $contract
    }

    $runs = @($file.runs)
    $selected = @(if ($PSBoundParameters.ContainsKey('Run')) {
            Assert-True ($Run -le $runs.Count) -ErrorText "Get-AccostedFragment: ${Path} holds $($runs.Count) run(s), so there is no run $Run."
            $runs[$Run - 1]
        }
        else {
            $runs
        })
    $engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh
    $blocks = foreach ($selectedRun in $selected) {
        $commands = @($selectedRun.commands)
        if ($PSBoundParameters.ContainsKey('Command')) {
            Assert-True ($Command -le $commands.Count) -ErrorText "Get-AccostedFragment: the run holds $($commands.Count) command(s), so there is no command $Command."
            $commands = @($commands[$Command - 1])
        }
        (@(foreach ($accosted in $commands) {
                ConvertTo-AccostedCallText -Command $accosted -Contract $contracts[$accosted.name] -Engine $engine
            })) -join "`n"
    }
    @($blocks) -join "`n`n"
}
