<#
.SYNOPSIS
    Returns the managed tool a test run hands to each test language's tests: a path per language, or an empty string.
.DESCRIPTION
    A test run's source session locates each test language's tool once (Resolve-ToolExecutable, the tools.yml entry)
    and hands the paths down to every worker through the shard script and the language bridge container, beside the
    engine entry. The worker never locates a tool itself: a build run's engine carries only the modules under test,
    not the tools.yml entries, and the tools belong to the harness, not to what ships
    ([ADR-AUTO-GO#7](/docs/adr/automation/go/test-artifacts.md#rule-adr-auto-go7),
    [ADR-AUTO-PY#7](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py7)):

      go      the managed go at the pin;
      python  the managed uv at the pin, handed down only when the uv-managed python at the tools.yml pin is there
              too, since uv never downloads an interpreter in a test run.

    A language's entry is empty when the repository has no test folder in it (nothing is probed), or when its tool
    is missing or misses the pin; the bridge then skips that language's tests with tool_go_missing or
    tool_uv_missing.
.OUTPUTS
    [hashtable] @{ go = <path or ''>; python = <path or ''> }.
.EXAMPLE
    $executables = Get-LanguageTestExecutable
#>
function Get-LanguageTestExecutable {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $languages = @(Get-LanguageTestFolders | ForEach-Object Language | Select-Object -Unique)
    $executables = @{ go = ''; python = '' }
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
