function Get-AccostedFragment {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $RunNumber,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $CommandNumber,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-True ($PSBoundParameters.ContainsKey('RunNumber') -or -not $PSBoundParameters.ContainsKey('CommandNumber')) `
        -ErrorText 'Get-AccostedFragment: -CommandNumber names a command of one run, so it needs -RunNumber.'
    $file = Get-AccostedFile -Path $Path -RepositoryRoot $RepositoryRoot
    $contracts = Get-CommandContractMap -RepositoryRoot $RepositoryRoot

    $runs = @($file.runs)
    $selected = @(if ($PSBoundParameters.ContainsKey('RunNumber')) {
            Assert-True ($RunNumber -le $runs.Count) -ErrorText "Get-AccostedFragment: ${Path} holds $($runs.Count) run(s), so there is no run $RunNumber."
            $runs[$RunNumber - 1]
        }
        else {
            $runs
        })
    $engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh
    $blocks = foreach ($selectedRun in $selected) {
        $commands = @($selectedRun.commands)
        if ($PSBoundParameters.ContainsKey('CommandNumber')) {
            Assert-True ($CommandNumber -le $commands.Count) -ErrorText "Get-AccostedFragment: the run holds $($commands.Count) command(s), so there is no command $CommandNumber."
            $commands = @($commands[$CommandNumber - 1])
        }
        (@(foreach ($accosted in $commands) {
                ConvertTo-AccostedCallText -Command $accosted -Contract $contracts[$accosted.name] -Engine $engine
            })) -join "`n"
    }
    @($blocks) -join "`n`n"
}
