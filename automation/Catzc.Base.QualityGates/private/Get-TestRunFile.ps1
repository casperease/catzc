<#
.SYNOPSIS
    Names the run file a discovered or executed Pester test belongs to: its test file, or its Go test folder.
.DESCRIPTION
    The harness schedules, scopes, protects, and reports by run file — the unit a shard runs. For a *.Tests.ps1 test
    that is its file. A Go bridge test (tests/Go.Bridge.ps1, run once per Go test folder as a Pester container
    whose data names the folder) belongs to its Go test folder instead, read from the container data's
    GoTestFolder, so a module's Go tests count as that module's, not the bridge file's.
.PARAMETER Test
    A Pester test object (an item of a run's .Tests).
.OUTPUTS
    [string] The run file's absolute path; empty when the test has neither a container folder nor a file.
.EXAMPLE
    $file = Get-TestRunFile -Test $test
#>
function Get-TestRunFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    if ($Test.PSObject.Properties['Block'] -and $Test.Block -and $Test.Block.PSObject.Properties['BlockContainer']) {
        $container = $Test.Block.BlockContainer
        if ($container -and $container.PSObject.Properties['Data']) {
            $data = $container.Data
            if ($data -is [System.Collections.IDictionary] -and $data.Contains('GoTestFolder')) {
                return [string]$data['GoTestFolder']
            }
        }
    }
    if ($Test.PSObject.Properties['ScriptBlock'] -and $Test.ScriptBlock) {
        return [string]$Test.ScriptBlock.File
    }
    ''
}
