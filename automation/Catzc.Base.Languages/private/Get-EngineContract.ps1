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
  config:
    synopsis: |-
      Returns the engine start environment a test language's tests start the engine by: the environment variables a runner sets
      for its tool's commands.
    description: |-
      A Go or Python test starts the engine as a process and asserts on its output
      ([ADR-AUTO-GO#3](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go3),
      [ADR-AUTO-PY#3](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py3)). How to start it comes from
      the execution engine model, never from the test ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)), so
      the same test runs under every engine:

        CATZC_ENGINE             the engine's name (ExecutionEngines.Names);
        CATZC_ENGINE_EXECUTABLE  the engine's executable;
        CATZC_ENGINE_ENTRY       the script that loads catzc into the engine: the PowerShell entry for pwsh, the
                                 repository's importer.sh (forward-slashed) for the POSIX engines — what a Bash test
                                 loads;
        CATZC_ENGINE_START       the arguments after it, as a JSON array (ExecutionEngine.StartArguments): they start the
                                 engine non-interactively, load its importer with the output discarded, and end in the
                                 command text, where the test puts its catzc command in place of {command};
        CATZC_IMPORTER           the POSIX engines only: the PowerShell entry the cats dispatcher loads (importer.sh reads
                                 it);
        CATZC_REPOSITORY_ROOT    the repository root.

      The PowerShell entry is the repository's importer.ps1 for a source run, or -EntryScript (the build's
      Import-Catzc.ps1) for a build run. pwsh loads it directly. The POSIX engines load the repository's importer.sh,
      whose cats dispatcher loads it through CATZC_IMPORTER, so a POSIX engine's session drives the build too.
    parameters:
      Engine: 'The execution engine: pwsh (default), or any other of ExecutionEngines.Names.'
      EngineExecutable: |-
        The engine's executable, already located by the caller (a test run's source session hands it down, since a build
        run's engine does not carry the tools.yml entry a POSIX engine is located through). Default:
        Resolve-EngineExecutable.
      EntryScript: 'The PowerShell entry for a build run. Default: the repository''s importer.ps1 (the source run).'
    outputs: '[System.Collections.Specialized.OrderedDictionary] The variables, by name.'
    examples:
      - '$contract = Get-EngineContract -Engine bash -EntryScript $buildEntry'
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
