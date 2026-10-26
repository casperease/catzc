function Build-EnglishDictionary {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $PassThru
    )

    # An authoring step: it writes the committed artifact into the SOURCE module, never into an installed build.
    Assert-SourceTree

    Assert-Command npx
    Assert-Command npm
    Assert-Command cspell

    # cspell bundles its English tries in the global node_modules.
    $nodeRoot = (& npm root -g).Trim()
    Assert-NotNullOrWhitespace $nodeRoot

    # Each trie is found by name; the dict folder's casing (dict-en_us, dict-en-GB) is not guessed.
    $triePaths = foreach ($trieName in 'en_US.trie.gz', 'en_GB.trie.gz') {
        # Five levels down (cspell, node_modules, @cspell, package, file), so the walk enters node_modules.
        $found = Get-ChildPath $nodeRoot -File -Filter $trieName -Depth 5 -Exclude @() -PruneVendor $false |
            Select-Object -First 1
        if (-not $found) {
            throw "Could not find cspell's $trieName under '$nodeRoot'. Install cspell (Install-Cspell)."
        }
        $found
    }

    # The source versions go into the stamp, so the drift check needs no node.
    $cspellVersion = (Invoke-Executable 'cspell --version' -PassThru -Silent).Output.Trim()
    $dictVersions = [ordered]@{}
    foreach ($trie in $triePaths) {
        $package = Get-Content (Join-Path (Split-Path $trie -Parent) 'package.json') -Raw | ConvertFrom-Json
        $dictVersions[$package.name] = $package.version
    }

    # cspell-trie@10 matches the installed tries; ~440k words through npx, so it is announced first.
    Write-Message 'Flattening cspell English dictionaries (en_US, en_GB) via cspell-trie — this can take a while...'

    $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $tempFiles = [System.Collections.Generic.List[string]]::new()
    try {
        foreach ($trie in $triePaths) {
            $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),
                [System.Guid]::NewGuid().ToString('N') + '.txt')
            $tempFiles.Add($tmp)
            Invoke-Executable "npx --yes cspell-trie@10 reader '$trie' -o '$tmp'" | Out-Null
            Assert-PathExist $tmp

            # Lower-cased pure-alpha words of two letters or more: no apostrophe forms, digits or proper-noun casing.
            foreach ($line in [System.IO.File]::ReadLines($tmp)) {
                $word = $line.ToLowerInvariant()
                if ($word.Length -ge 2 -and $word -cmatch '^[a-z]+$') {
                    [void] $set.Add($word)
                }
            }
        }
    }
    finally {
        foreach ($tmp in $tempFiles) {
            if (Test-Path $tmp) {
                [System.IO.File]::Delete($tmp)
            }
        }
    }

    $words = [string[]] $set
    [System.Array]::Sort($words, [System.StringComparer]::Ordinal)
    $content = ($words -join "`n") + "`n"

    # The source module's assets/ in the repository — the committed copy the build later ships.
    $assetsDir = [Catzc.Base.QualityGates.SpellingOracle]::AssetsFolder((Get-CatzcModuleRoot -Module Catzc.Base.QualityGates))
    $outPath = [Catzc.Base.QualityGates.SpellingOracle]::DictionaryPath($assetsDir)
    $stampPath = [Catzc.Base.QualityGates.SpellingOracle]::DictionaryStampPath($assetsDir)

    # word_count ties the stamp to this gz, so a mismatch shows without node.
    $stamp = [ordered]@{
        cspell     = $cspellVersion
        dicts      = $dictVersions
        word_count = $words.Count
    }
    $stampContent = ($stamp | ConvertTo-Json -Depth 5) + "`n"

    # Unchanged is judged on the decompressed words, never on gzip bytes.
    $existing = $null
    if (Test-Path $outPath) {
        $existing = [System.Text.Encoding]::UTF8.GetString([Catzc.Base.QualityGates.GzipText]::Decompress([System.IO.File]::ReadAllBytes($outPath)))
    }
    $existingStamp = if (Test-Path $stampPath) {
        [System.IO.File]::ReadAllText($stampPath)
    }
    else {
        $null
    }
    $changed = ($content -cne $existing) -or ($stampContent -cne $existingStamp)

    if (-not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory($assetsDir)
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        if ($content -cne $existing) {
            [System.IO.File]::WriteAllBytes($outPath,
                [Catzc.Base.QualityGates.GzipText]::Compress($utf8NoBom.GetBytes($content)))
        }
        if ($stampContent -cne $existingStamp) {
            [System.IO.File]::WriteAllText($stampPath, $stampContent, $utf8NoBom)
        }
    }

    $verb = if ($DryRun) {
        if ($changed) {
            'would regenerate'
        }
        else {
            'already current'
        }
    }
    else {
        if ($changed) {
            'regenerated'
        }
        else {
            'unchanged'
        }
    }
    Write-Message "assets/english.txt.gz $verb — $($words.Count) word(s)."

    if ($PassThru) {
        return [pscustomobject]@{
            Path      = $outPath
            WordCount = $words.Count
            Changed   = [bool] $changed
            DryRun    = [bool] $DryRun
        }
    }

    $outPath
}
