---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md
    kind: comment-page
    body_sha: ec8d32493f81
    adrs:
      - ADR-AUTO-CONSOLE#10
      - ADR-REPO-OUTDIR#5
    links: []
---

# automation/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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
```

## comment:2

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report whether the committed list would change without writing it. The returned content is the same in
either mode; -DryRun skips the write. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:3

Above `$nodeRoot = (& npm root -g).Trim()`.

```text
Locate cspell's bundled tries under the global node_modules. They sit under the cspell package's own
nested @cspell/dict-* (cspell bundles them), so resolve npm's global root then the known relative path,
falling back to a recursive search if the layout differs.
```

## comment:4

Above `$triePaths = foreach ($trieName in 'en_US.trie.gz', 'en_GB.trie.gz') {`.

```text
cspell bundles the tries under its own nested @cspell/dict-* folders, and the exact folder casing
(dict-en_us vs dict-en-GB) is not worth guessing — search the global node_modules for each trie by name.
```

## comment:5

Above `$cspellVersion = (Invoke-Executable 'cspell --version' -PassThru...`.

```text
Record what the committed dictionary is flattened from, so a drift check can detect staleness WITHOUT
re-running node (Build-EnglishDictionary.Tests.ps1): the installed cspell version — compared against the
tools.yml pin — plus the exact dict package versions, read from each trie's sibling package.json.
```

## comment:6

Above `Write-Message 'Flattening cspell English dictionaries (en_US, en_GB) via...`.

```text
cspell-trie reads a trie and prints its words. Pin to the cspell 10 line to match the installed tries.
This shells out to npx (a cold run downloads cspell-trie) and reads ~440k words — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:7

Above `foreach ($line in [System.IO.File]::ReadLines($tmp)) {`.

```text
Keep only lower-cased, pure-alpha words of length >= 2. This drops cspell's apostrophe forms
('cause), digits, and single characters — none of which is an identifier fragment — and collapses
proper-noun casing (Nicaea -> nicaea) so the set is a clean lower-case word oracle.
```

## comment:8

Above `$stamp = [ordered]@{`.

```text
The stamp locks the artifact to its source versions. word_count also ties the stamp to THIS gz, so the
drift check can catch a stamp/gz mismatch by decompressing and counting — no node needed.
```

## comment:9

Above `$existing = $null`.

```text
Idempotency is decided on the DECOMPRESSED content (gzip container bytes are not the contract), so a
re-run with an unchanged dictionary is a no-op and the drift test compares like with like.
```
