<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Execution/Resolve-EngineExecutable.ps1
    name: resolve-engine-executable
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE
  config:
    synopsis: Returns the full path of an execution engine's executable on this machine.
    description: |-
      Locates the engine's executable the way its model says (ExecutionEngine.Locate,
      [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)):

        ps-home  pwsh, beside the PowerShell that is running ($PSHOME), so a started engine is the same PowerShell as
                 the caller, never another pwsh that comes first on PATH;
        tool     the POSIX engines, through their tools.yml entries and the existence check (Resolve-ToolExecutable): Git
                 Bash and the zsh installed into its tree on Windows, the system shell elsewhere, never the WSL launcher.

      Throws, naming the engine and the remedy, when the executable is missing or a tool-located one misses its pin.
    parameters:
      Engine: The engine's name (pwsh, bash or zsh).
    outputs: '[string] The executable''s full path.'
    examples:
      - '& (Resolve-EngineExecutable -Engine pwsh) @((Get-ExecutionEngine -Name pwsh).StartArguments($entry, ''Get-RepositoryRoot''))'
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
