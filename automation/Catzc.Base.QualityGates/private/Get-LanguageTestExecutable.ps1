# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Returns the managed tool a test run hands to each test language's tests: a path per language, or an empty string.
.DESCRIPTION
    Workers never locate tools, as a build run's engine has no tools.yml entries; paths come from the source session.
    [ADR-AUTO-ENGINE#4](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine4),
    [ADR-AUTO-GO#7](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go7),
    [ADR-AUTO-PY#7](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py7)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md#comment1)
.OUTPUTS
    [hashtable] @{ go = <path or ''>; python = <path or ''>; <engine> = <path or ''> per engine other than pwsh }.
.EXAMPLE
    $executables = Get-LanguageTestExecutable
#>
function Get-LanguageTestExecutable {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $languages = @(Get-LanguageTestFolders | ForEach-Object Language | Select-Object -Unique)
    $executables = @{ go = ''; python = '' }
    # Located once here because a build run's worker cannot: its tools.yml entry is not in the build.
    # [ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md#comment2)
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
