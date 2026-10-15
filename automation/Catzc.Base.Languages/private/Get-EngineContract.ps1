<#
.SYNOPSIS
    Returns the black-box contract a test language's tests start the engine by: the environment variables a runner sets
    for its tool's commands.
.DESCRIPTION
    A Go or Python test starts the engine as a process and asserts on its output.
    [ADR-AUTO-GO#3](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go3),
    [ADR-AUTO-PY#3](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py3),
    [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)
    [comment:1](/docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md#comment1)
.PARAMETER Engine
    The execution engine: pwsh (default), or any other of ExecutionEngines.Names.
.PARAMETER EngineExecutable
    The engine's executable, already located by the caller (a test run's source session hands it down, since a build...
    [comment:2](/docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md#comment2)
.PARAMETER EntryScript
    The PowerShell entry for a build run. Default: the repository's importer.ps1 (the source run).
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] The variables, by name.
.EXAMPLE
    $contract = Get-EngineContract -Engine bash -EntryScript $buildEntry
#>
function Get-EngineContract {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,

        [string] $EngineExecutable,

        [string] $EntryScript
    )

    $root = Get-RepositoryRoot
    $model = [Catzc.Base.Engines.ExecutionEngines]::Get($Engine)
    $powerShellEntry = if ($EntryScript) {
        Assert-PathExist $EntryScript -PathType Leaf
        (Resolve-Path -LiteralPath $EntryScript).ProviderPath
    }
    else {
        Join-Path $root ([Catzc.Base.Engines.ExecutionEngines]::Pwsh.ImporterEntry)
    }
    $executable = if ($EngineExecutable) {
        Assert-PathExist $EngineExecutable -PathType Leaf
        $EngineExecutable
    }
    else {
        Resolve-EngineExecutable -Engine $model.Name
    }

    # The entry the engine itself loads: pwsh the PowerShell entry; any other engine its own importer in the...
    # [comment:3](/docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md#comment3)
    $entry = if ($model.Name -eq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {
        $powerShellEntry
    }
    else {
        $importer = Join-Path $root $model.ImporterEntry
        Assert-PathExist $importer -PathType Leaf
        $importer.Replace('\', '/')
    }

    $contract = [ordered]@{
        CATZC_ENGINE            = $model.Name
        CATZC_ENGINE_EXECUTABLE = $executable
        CATZC_ENGINE_ENTRY      = $entry
        CATZC_ENGINE_START      = ConvertTo-Json -InputObject @($model.StartArguments($entry, '{command}')) -Compress
    }
    if ($model.Name -ne [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {
        $contract['CATZC_IMPORTER'] = $powerShellEntry
    }
    $contract['CATZC_REPOSITORY_ROOT'] = $root
    $contract
}
