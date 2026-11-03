function ConvertTo-TestDiscoveryRow {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Record,

        [Parameter(Mandatory)]
        [string] $File
    )

    $testFolder = $Record.Contains('testFolder') ? [string]$Record['testFolder'] : ''
    $scriptFile = $Record.Contains('file') ? [string]$Record['file'] : $File

    # A Go bridge test is told apart by the folder its container carries (Get-TestRunFile).
    $newBlock = {
        param([string[]] $Tag, [bool] $IsRoot, $Parent)
        $properties = [ordered]@{ Tag = $Tag; IsRoot = $IsRoot; Parent = $Parent }
        if ($testFolder) {
            $properties['BlockContainer'] = [pscustomobject]@{ Data = @{ TestFolder = $testFolder } }
        }
        [pscustomobject]$properties
    }

    $root = & $newBlock ([string[]]@()) $true $null
    $nodes = [System.Collections.Generic.List[object]]::new()
    foreach ($block in $Record['blocks']) {
        $parentIndex = [int]$block['parent']
        $nodes.Add((& $newBlock ([string[]]@($block['tag'])) $false ($parentIndex -ge 0 ? $nodes[$parentIndex] : $root)))
    }

    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($test in $Record['tests']) {
        $blockIndex = [int]$test['block']
        $rows.Add([pscustomobject]@{
                Tag          = [string[]]@($test['tag'])
                Block        = $blockIndex -ge 0 ? $nodes[$blockIndex] : $root
                ScriptBlock  = [pscustomobject]@{
                    File          = $scriptFile
                    StartPosition = [pscustomobject]@{ StartLine = [int]$test['line'] }
                }
                ExpandedName = [string]$test['name']
                ExpandedPath = [string]$test['path']
                Result       = 'NotRun'
                Duration     = [timespan]::Zero
                ErrorRecord  = @()
            })
    }
    $rows.ToArray()
}
