<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1
    folder: private
    name: get-language-test-executable
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE#{1,4}
      - ADR-AUTO-GO#7
      - ADR-AUTO-PY#7
  config:
    synopsis: 'Returns the managed tool a test run hands to each test language''s tests: a path per language, or an empty string.'
    description: |-
      A test run's source session locates each test language's tool once (Resolve-ToolExecutable, the tools.yml entry)
      and hands the paths down to every worker through the shard script and the language bridge container, beside the
      engine entry. The worker never locates a tool itself: a build run's engine carries only the modules under test,
      not the tools.yml entries, and the tools belong to the harness, not to what ships
      ([ADR-AUTO-GO#7](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go7),
      [ADR-AUTO-PY#7](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py7)):

        go      the managed go at the pin;
        python  the managed uv at the pin, handed down only when the uv-managed python at the tools.yml pin is there
                too, since uv never downloads an interpreter in a test run;
        <engine>  every execution engine other than the running pwsh, by its name (Resolve-EngineExecutable): each
                language's tests also run under each of them
                ([ADR-AUTO-ENGINE#4](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine4)), and the bash
                engine runs the Bash tests.

      An entry is empty when the repository has no test folder (nothing is probed), or when its tool or engine is
      missing or misses the pin; the bridge then skips those tests with tool_go_missing, tool_uv_missing or
      tool_<engine>_missing.
    outputs: '[hashtable] @{ go = <path or ''''>; python = <path or ''''>; <engine> = <path or ''''> per engine other than pwsh }.'
    examples:
      - '$executables = Get-LanguageTestExecutable'
---
#>

function Get-LanguageTestExecutable {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $languages = @(Get-LanguageTestFolders | ForEach-Object Language | Select-Object -Unique)
    # The languages whose tests need tools come from the registry; a language that is an engine resolves with the engines below.
    $toolLanguages = @((Get-Config -Config languages).languages | Where-Object { $_.tests -and -not $_.tests.engine })
    $executables = @{}
    foreach ($language in $toolLanguages) {
        $executables[$language.name] = ''
    }
    $pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
        if ($engine.Name -eq $pwsh) {
            continue
        }
        $executables[$engine.Name] = ''
        if ($languages.Count -gt 0) {
            try {
                $executables[$engine.Name] = "$(Resolve-EngineExecutable -Engine $engine.Name)"
            }
            catch {
                Write-Verbose "The $($engine.Name) engine is not available, so the tests' $($engine.Name) runs skip: $($_.Exception.Message)"
            }
        }
    }
    foreach ($language in $toolLanguages) {
        if ($language.name -notin $languages) {
            continue
        }
        # Every tool the entry names must resolve at its locked version; the first one's path is the one the runner takes.
        $resolved = @(foreach ($tool in $language.tests.tools) {
                Resolve-ToolExecutable -Tool $tool
            })
        if (@($resolved | Where-Object { -not ($_.Found -and $_.VersionOk) }).Count -eq 0) {
            $executables[$language.name] = $resolved[0].Path
        }
    }
    $executables
}
