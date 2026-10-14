<#
.SYNOPSIS
    Returns the path of the managed go a test run hands to its Go tests, or an empty string when there is none.
.DESCRIPTION
    A test run's source session locates go once (Resolve-ToolExecutable, the tools.yml `go` entry) and hands the path
    down to every worker through the shard script and the Go bridge container, beside the engine entry. The worker
    never locates go itself: a build run's engine carries only the modules under test, not the tools.yml entry, and
    go is a tool of the harness, not part of what ships
    ([ADR-AUTO-GO#7](/docs/adr/automation/go/test-artifacts.md#rule-adr-auto-go7)).

    Empty when the repository has no Go test folder (nothing is probed), when no go is found, or when the go found
    misses the pin; the bridge then skips every Go test with tool_go_missing.
.OUTPUTS
    [string] The go path, or ''.
.EXAMPLE
    $goExecutable = Get-GoTestExecutable
#>
function Get-GoTestExecutable {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (@(Get-GoTestFolders).Count -eq 0) {
        return ''
    }
    $go = Resolve-ToolExecutable -Tool go
    if ($go.Found -and $go.VersionOk) {
        return $go.Path
    }
    ''
}
