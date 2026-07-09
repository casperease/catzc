<#
.SYNOPSIS
    Generates the committed English word list the spell-out-names analyzer rule checks identifiers against —
    flattened from cspell's own bundled dictionaries so the two gates agree on "what is a word".
.DESCRIPTION
    Reads cspell's bundled en_US and en_GB tries (the same dictionaries cspell.yml's `language: en,en-GB`
    resolves), flattens each to a word list with `cspell-trie reader`, unions them, keeps only lower-cased
    pure-alpha words of length >= 2, and writes the sorted, de-duplicated result gzip-compressed to
    automation/Catzc.Base.QualityGates/assets/english.txt.gz.

    Unlike the .cspell/*.txt term lists (regenerated cheaply from terminology.yml on every import), this list
    is EXPENSIVE to regenerate — it needs node, npx, and cspell's bundled tries — and it is needed on a fresh
    checkout by the L2 analyzer gate (Measure-SpellOutIdentifiers). So it is COMMITTED, the same call the
    compiled-type prebuild makes (docs/adr/repository/dedicated-output-directory.md, ADR-REPO-OUTDIR:5): a deterministic,
    expensive-to-regenerate artifact kept in the tree, not regenerated at import. Alongside the gz it writes a
    committed stamp (`assets/english.stamp`) recording the cspell + dict package versions it was flattened
    from and the word count. The drift gate (Build-EnglishDictionary.Tests.ps1) compares that stamp's cspell
    version against the tools.yml pin — cheaply, with no node round-trip — and fails when they diverge, so a
    cspell bump that leaves this artifact stale is caught in CI. Re-run this (and commit the gz + stamp) when
    bumping cspell; `-DryRun` reports whether either would change.

    SpellingOracle (Catzc.Base.QualityGates/types) loads this list plus every .cspell/*.txt term list into one
    set. English recognizes the spelled-out words (rule, collection, group); the term lists carry the domain
    vocabulary and the conventional-abbreviation allow-list. See docs/adr/automation/spell-out-names.md.
.PARAMETER DryRun
    Report whether the committed list would change without writing it. The returned content is the same in
    either mode; -DryRun skips the write. See docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER PassThru
    Return a result object ({ Path, WordCount, Changed, DryRun }) instead of the path string.
.OUTPUTS
    [string] The path to the generated english.txt.gz (with -PassThru, the result object instead).
.EXAMPLE
    Build-EnglishDictionary
    Regenerates the committed English word list from cspell's bundled dictionaries.
#>
function Build-EnglishDictionary {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-Command npx
    Assert-Command npm
    Assert-Command cspell

    # Locate cspell's bundled tries under the global node_modules. They sit under the cspell package's own
    # nested @cspell/dict-* (cspell bundles them), so resolve npm's global root then the known relative path,
    # falling back to a recursive search if the layout differs.
    $nodeRoot = (& npm root -g).Trim()
    Assert-NotNullOrWhitespace $nodeRoot

    # cspell bundles the tries under its own nested @cspell/dict-* folders, and the exact folder casing
    # (dict-en_us vs dict-en-GB) is not worth guessing — search the global node_modules for each trie by name.
    $triePaths = foreach ($trieName in 'en_US.trie.gz', 'en_GB.trie.gz') {
        $found = [System.IO.Directory]::EnumerateFiles($nodeRoot, $trieName, [System.IO.SearchOption]::AllDirectories) |
            Select-Object -First 1
        if (-not $found) {
            throw "Could not find cspell's $trieName under '$nodeRoot'. Install cspell (Install-Cspell)."
        }
        $found
    }

    # Record what the committed dictionary is flattened from, so a drift gate can detect staleness WITHOUT
    # re-running node (Build-EnglishDictionary.Tests.ps1): the installed cspell version — compared against the
    # tools.yml pin — plus the exact dict package versions, read from each trie's sibling package.json.
    $cspellVersion = (Invoke-Executable 'cspell --version' -PassThru -Silent).Output.Trim()
    $dictVersions = [ordered]@{}
    foreach ($trie in $triePaths) {
        $package = Get-Content (Join-Path (Split-Path $trie -Parent) 'package.json') -Raw | ConvertFrom-Json
        $dictVersions[$package.name] = $package.version
    }

    # cspell-trie reads a trie and prints its words. Pin to the cspell 10 line to match the installed tries.
    # This shells out to npx (a cold run downloads cspell-trie) and reads ~440k words — announce it (ADR-AUTO-CONSOLE:10).
    Write-Message 'Flattening cspell English dictionaries (en_US, en_GB) via cspell-trie — this can take a while...'

    $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $tempFiles = [System.Collections.Generic.List[string]]::new()
    try {
        foreach ($trie in $triePaths) {
            $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N') + '.txt')
            $tempFiles.Add($tmp)
            Invoke-Executable "npx --yes cspell-trie@10 reader '$trie' -o '$tmp'" | Out-Null
            Assert-PathExist $tmp

            # Keep only lower-cased, pure-alpha words of length >= 2. This drops cspell's apostrophe forms
            # ('cause), digits, and single characters — none of which is an identifier fragment — and collapses
            # proper-noun casing (Nicaea -> nicaea) so the set is a clean lower-case word oracle.
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

    $assetsDir = Join-Path $PSScriptRoot 'assets'
    $outPath = Join-Path $assetsDir 'english.txt.gz'
    $stampPath = Join-Path $assetsDir 'english.stamp'

    # The stamp locks the artifact to its source versions. word_count also ties the stamp to THIS gz, so the
    # drift gate can catch a stamp/gz mismatch by decompressing and counting — no node needed.
    $stamp = [ordered]@{
        cspell     = $cspellVersion
        dicts      = $dictVersions
        word_count = $words.Count
    }
    $stampContent = ($stamp | ConvertTo-Json -Depth 5) + "`n"

    # Idempotency is decided on the DECOMPRESSED content (gzip container bytes are not the contract), so a
    # re-run with an unchanged dictionary is a no-op and the drift test compares like with like.
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
            [System.IO.File]::WriteAllBytes($outPath, [Catzc.Base.QualityGates.GzipText]::Compress($utf8NoBom.GetBytes($content)))
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
