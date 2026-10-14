<#
.SYNOPSIS
    Returns the black-box contract a test language's tests start the engine by: the environment variables a runner sets
    for its tool's commands.
.DESCRIPTION
    A Go or Python test starts the engine as a process and asserts on its output
    ([ADR-AUTO-GO#3](/docs/adr/automation/go/test-artifacts.md#rule-adr-auto-go3),
    [ADR-AUTO-PY#3](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py3)). How to start it comes from
    the execution engine model, never from the test ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)):

      CATZC_ENGINE_EXECUTABLE  the engine's executable (Resolve-EngineExecutable);
      CATZC_ENGINE_START       the arguments after it, as a JSON array (ExecutionEngine.StartArguments): they start the
                               engine non-interactively, load the entry script with its output discarded, and end in
                               the command text, where the test puts its command in place of {command};
      CATZC_REPOSITORY_ROOT    the repository root.

    The entry is the repository's importer for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a build
    run. The engine is pwsh: the build's entry is a PowerShell script, and the second engine's importer arrives with it.
.PARAMETER EntryScript
    The engine entry for a build run. Default: the repository's importer.ps1 (the source run).
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] The variables, by name.
.EXAMPLE
    $contract = Get-EngineContract -EntryScript $buildEntry
#>
function Get-EngineContract {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [string] $EntryScript
    )

    $root = Get-RepositoryRoot
    $engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh
    $entry = if ($EntryScript) {
        Assert-PathExist $EntryScript -PathType Leaf
        (Resolve-Path -LiteralPath $EntryScript).ProviderPath
    }
    else {
        Join-Path $root $engine.ImporterEntry
    }

    [ordered]@{
        CATZC_ENGINE_EXECUTABLE = Resolve-EngineExecutable -Engine $engine.Name
        CATZC_ENGINE_START      = ConvertTo-Json -InputObject @($engine.StartArguments($entry, '{command}')) -Compress
        CATZC_REPOSITORY_ROOT   = $root
    }
}
