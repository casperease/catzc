function Copy-BicepSourceTree {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Main,

        [Parameter(Mandatory)]
        [string] $OutputFolder
    )

    # Every local path a Bicep file names: a module, an import's from, a using or extends, and a load function's file argument.
    $reference = [regex]::new(
        "(?m)^\s*(?:module\s+\S+\s+|using\s+|extends\s+)'(?<path>[^']+)'|\bfrom\s+'(?<path>[^']+)'|\bload\w+\(\s*'(?<path>[^']+)'")
    $files = [System.Collections.Generic.List[string]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $queue = [System.Collections.Generic.Queue[string[]]]::new()
    $queue.Enqueue([string[]] @([System.IO.Path]::GetFullPath($Main), ''))
    while ($queue.Count -gt 0) {
        $file, $referrer = $queue.Dequeue()
        if (-not $seen.Add($file)) {
            continue
        }
        if (-not [System.IO.File]::Exists($file)) {
            throw "Build-Bicep: '$referrer' references '$file', which does not exist; the built template copies every file its main.bicep reaches."
        }
        $files.Add($file)
        if ([System.IO.Path]::GetExtension($file) -notin '.bicep', '.bicepparam') {
            continue
        }
        $folder = [System.IO.Path]::GetDirectoryName($file)
        foreach ($match in $reference.Matches([System.IO.File]::ReadAllText($file))) {
            $path = $match.Groups['path'].Value
            # A registry or template-spec reference (br:, br/<alias>:, ts:) names no local file.
            if ($path -match '^[A-Za-z][A-Za-z0-9/-]*:') {
                continue
            }
            $queue.Enqueue([string[]] @([System.IO.Path]::GetFullPath((Join-Path $folder $path)), $file))
        }
    }

    # The deepest folder holding every reached file, so the copy keeps each relative path as written and none leaves the output folder.
    $root = [System.IO.Path]::GetDirectoryName($files[0])
    foreach ($file in $files) {
        while (-not $file.StartsWith($root.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
            $root = [System.IO.Path]::GetDirectoryName($root)
        }
    }
    # The linter reads its rule levels from the nearest bicepconfig.json, so each one between a reached file and the root travels too.
    foreach ($folder in @($files | ForEach-Object { [System.IO.Path]::GetDirectoryName($_) } | Sort-Object -Unique)) {
        $current = $folder
        while ($current.Length -ge $root.Length) {
            $config = Join-Path $current 'bicepconfig.json'
            if ([System.IO.File]::Exists($config) -and $seen.Add($config)) {
                $files.Add($config)
            }
            $current = [System.IO.Path]::GetDirectoryName($current)
        }
    }

    $target = Join-Path $OutputFolder 'bicep'
    foreach ($file in $files) {
        $copy = Join-Path $target ([System.IO.Path]::GetRelativePath($root, $file))
        $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($copy))
        [System.IO.File]::Copy($file, $copy, $true)
    }
    Join-Path $target ([System.IO.Path]::GetRelativePath($root, $files[0]))
}
