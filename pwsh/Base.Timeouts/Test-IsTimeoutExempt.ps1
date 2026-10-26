function Test-IsTimeoutExempt {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    )

    $null -ne (Get-TimeoutExemption $Budget -Shell $Shell)
}
