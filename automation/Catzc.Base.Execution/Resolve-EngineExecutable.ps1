<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Execution/Resolve-EngineExecutable.ps1
    name: resolve-engine-executable
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE
---
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
