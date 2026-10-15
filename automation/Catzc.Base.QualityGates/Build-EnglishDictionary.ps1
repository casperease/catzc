<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1
    kind: writer-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-CONSOLE#10
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-SPELL
      - ADR-REPO-OUTDIR#5
  config:
    synopsis: |-
      Generates the committed English word list the spell-out-names analyzer rule checks identifiers against —
      flattened from cspell's own bundled dictionaries so the two checks agree on "what is a word".
    description: |-
      Reads cspell's bundled en_US and en_GB tries (the same dictionaries cspell.yml's `language: en,en-GB`
      resolves), flattens each to a word list with `cspell-trie reader`, unions them, keeps only lower-cased
      pure-alpha words of length >= 2, and writes the sorted, de-duplicated result gzip-compressed to
      automation/Catzc.Base.QualityGates/assets/english.txt.gz.

      Unlike the .cspell/*.txt term lists (regenerated cheaply from terminology.yml on every import), this list
      is EXPENSIVE to regenerate — it needs node, npx, and cspell's bundled tries — and it is needed on a fresh
      checkout by the L2 analyzer rule (Measure-SpellOutIdentifiers). So it is COMMITTED, the same call the
      compiled-type prebuild makes
      ([ADR-REPO-OUTDIR#5](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir5)): a deterministic,
      expensive-to-regenerate artifact kept in the tree, not regenerated at import. Alongside the gz it writes a
      committed stamp (`assets/english.stamp`) recording the cspell + dict package versions it was flattened
      from and the word count. The drift check (Build-EnglishDictionary.Tests.ps1) compares that stamp's cspell
      version against the tools.yml pin — cheaply, with no node round-trip — and fails when they diverge, so a
      cspell bump that leaves this artifact stale is caught in CI. Re-run this (and commit the gz + stamp) when
      bumping cspell; `-DryRun` reports whether either would change. It writes the source module in the
      repository, so it needs the source mode and throws in build mode (Assert-SourceTree).

      SpellingOracle (Catzc.Base.QualityGates/types) loads this list plus every .cspell/*.txt term list into one
      set. English recognizes the spelled-out words (rule, collection, group); the term lists carry the product
      vocabulary and the conventional-abbreviation allow-list. See
      [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md).
    parameters:
      DryRun: |-
        Report whether the committed list would change without writing it. The returned content is the same in
        either mode; -DryRun skips the write. See
        [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
      PassThru: Return a result object ({ Path, WordCount, Changed, DryRun }) instead of the path string.
    outputs: '[string] The path to the generated english.txt.gz (with -PassThru, the result object instead).'
    examples:
      - |-
        Build-EnglishDictionary
        Regenerates the committed English word list from cspell's bundled dictionaries.
---
#>

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

    # Locate cspell's bundled tries under the global node_modules.
    # [comment:10](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment10)
    $nodeRoot = (& npm root -g).Trim()
    Assert-NotNullOrWhitespace $nodeRoot

    # cspell bundles the tries under its own nested @cspell/dict-* folders, and the exact folder casing (dict-en_us...
    # [comment:11](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment11)
    $triePaths = foreach ($trieName in 'en_US.trie.gz', 'en_GB.trie.gz') {
        # The trie sits five levels down (cspell, node_modules, @cspell, package, file); the walk must enter node_modules.
        $found = Get-ChildPath $nodeRoot -File -Filter $trieName -Depth 5 -Exclude @() -PruneVendor $false |
            Select-Object -First 1
        if (-not $found) {
            throw "Could not find cspell's $trieName under '$nodeRoot'. Install cspell (Install-Cspell)."
        }
        $found
    }

    # Record what the committed dictionary is flattened from, so a drift check can detect staleness WITHOUT...
    # [comment:12](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment12)
    $cspellVersion = (Invoke-Executable 'cspell --version' -PassThru -Silent).Output.Trim()
    $dictVersions = [ordered]@{}
    foreach ($trie in $triePaths) {
        $package = Get-Content (Join-Path (Split-Path $trie -Parent) 'package.json') -Raw | ConvertFrom-Json
        $dictVersions[$package.name] = $package.version
    }

    # cspell-trie reads a trie and prints its words.
    # [comment:13](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment13)
    Write-Message 'Flattening cspell English dictionaries (en_US, en_GB) via cspell-trie — this can take a while...'

    $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $tempFiles = [System.Collections.Generic.List[string]]::new()
    try {
        foreach ($trie in $triePaths) {
            $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N') + '.txt')
            $tempFiles.Add($tmp)
            Invoke-Executable "npx --yes cspell-trie@10 reader '$trie' -o '$tmp'" | Out-Null
            Assert-PathExist $tmp

            # Keep only lower-cased, pure-alpha words of length >= 2.
            # [comment:14](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment14)
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
    $assetsDir = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets'
    $outPath = Join-Path $assetsDir 'english.txt.gz'
    $stampPath = Join-Path $assetsDir 'english.stamp'

    # The stamp locks the artifact to its source versions.
    # [comment:15](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment15)
    $stamp = [ordered]@{
        cspell     = $cspellVersion
        dicts      = $dictVersions
        word_count = $words.Count
    }
    $stampContent = ($stamp | ConvertTo-Json -Depth 5) + "`n"

    # Idempotency is decided on the DECOMPRESSED content (gzip container bytes are not the contract), so a re-run...
    # [comment:16](/docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md#comment16)
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
