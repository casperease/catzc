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
    $executables = @{ go = ''; python = '' }
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
    if ('go' -in $languages) {
        $go = Resolve-ToolExecutable -Tool go
        if ($go.Found -and $go.VersionOk) {
            $executables['go'] = $go.Path
        }
    }
    if ('python' -in $languages) {
        $uv = Resolve-ToolExecutable -Tool uv
        $python = Resolve-ToolExecutable -Tool python
        if ($uv.Found -and $uv.VersionOk -and $python.Found -and $python.VersionOk) {
            $executables['python'] = $uv.Path
        }
    }
    $executables
}
