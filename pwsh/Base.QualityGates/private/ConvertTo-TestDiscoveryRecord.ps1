function ConvertTo-TestDiscoveryRecord {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Test
    )

    # The blocks of the tests, each once: a block is told apart by its expanded path and tags, and points at its parent by index.
    $blocks = [System.Collections.Generic.List[object]]::new()
    $blockIndex = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
    $tests = [System.Collections.Generic.List[object]]::new()
    $file = ''
    $testFolder = ''

    foreach ($item in $Test) {
        # The chain from the test's own block up to the file's root block, then walked from the outermost down.
        $chain = [System.Collections.Generic.List[object]]::new()
        $block = $item.Block
        while ($block -and -not $block.IsRoot) {
            $chain.Add($block)
            $block = $block.Parent
        }
        $parent = -1
        for ($i = $chain.Count - 1; $i -ge 0; $i--) {
            $tag = [string[]]@($chain[$i].Tag)
            $key = "$($chain[$i].ExpandedPath)|$($tag -join ',')|$parent"
            if (-not $blockIndex.ContainsKey($key)) {
                $blockIndex[$key] = $blocks.Count
                $blocks.Add(@{ tag = $tag; parent = $parent })
            }
            $parent = $blockIndex[$key]
        }

        if (-not $file -and $item.ScriptBlock) {
            $file = [string]$item.ScriptBlock.File
            $runFile = Get-TestRunFile -Test $item
            if ($runFile -ne $file) {
                $testFolder = $runFile
            }
        }
        $line = $item.ScriptBlock ? [int]$item.ScriptBlock.StartPosition.StartLine : 0
        $tests.Add(@{
                name  = [string]$item.ExpandedName
                path  = [string]$item.ExpandedPath
                tag   = [string[]]@($item.Tag)
                line  = $line
                block = $parent
            })
    }

    $record = @{ blocks = $blocks.ToArray(); tests = $tests.ToArray() }
    if ($testFolder) {
        $record['file'] = $file
        $record['testFolder'] = $testFolder
    }
    $record
}
