<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/private/Get-EngineContract.ps1
    folder: private
    name: get-engine-contract
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md
    test: automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE
      - ADR-AUTO-GO#3
      - ADR-AUTO-PY#3
---
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
