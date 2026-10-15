<#
.SYNOPSIS
    Returns the full path of an execution engine's executable on this machine.
.DESCRIPTION
    Locates the engine's executable the way its model says (ExecutionEngine.Locate, ): ps-home pwsh, beside the...
    [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)
    [comment:1](/docs/references/automation/catzc-base-execution/Resolve-EngineExecutable.ps1.md#comment1)
.PARAMETER Engine
    The engine's name (pwsh, bash or zsh).
.OUTPUTS
    [string] The executable's full path.
.EXAMPLE
    & (Resolve-EngineExecutable -Engine pwsh) @((Get-ExecutionEngine -Name pwsh).StartArguments($entry, 'Get-RepositoryRoot'))
#>
function Resolve-EngineExecutable {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine
    )

    $model = [Catzc.Base.Engines.ExecutionEngines]::Get($Engine)
    if ($model.Locate -eq [Catzc.Base.Engines.ExecutionEngine]::LocateByPsHome) {
        $path = Join-Path $PSHOME $model.ExecutableFileName($IsWindows)
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "The $Engine engine's executable is not beside the running PowerShell: $path does not exist."
        }
        return $path
    }

    $probe = Resolve-ToolExecutable -Tool $model.ToolKey
    if (-not $probe.Found) {
        throw "The $Engine engine's executable was not found (tools.yml entry '$($model.ToolKey)'); see Test-Tool $($model.ToolKey) -PassThru | Write-ToolProbeReport."
    }
    if (-not $probe.VersionOk) {
        throw "The $Engine engine at $($probe.Path) reports version '$($probe.Version)', but tools.yml pins '$($probe.Required)'."
    }
    $probe.Path
}
