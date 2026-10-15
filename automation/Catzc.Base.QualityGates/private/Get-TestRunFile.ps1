<#
.SYNOPSIS
    Names the run file a discovered or executed Pester test belongs to: its test file, or its language test folder.
.DESCRIPTION
    The harness schedules, scopes, protects, and reports by run file — the unit a shard runs.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRunFile.ps1.md#comment1)
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
            if ($data -is [System.Collections.IDictionary] -and $data.Contains('TestFolder')) {
                return [string]$data['TestFolder']
            }
        }
    }
    if ($Test.PSObject.Properties['ScriptBlock'] -and $Test.ScriptBlock) {
        return [string]$Test.ScriptBlock.File
    }
    ''
}
