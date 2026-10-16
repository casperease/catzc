---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Build-EnglishDictionary.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5ecbae575048"
    adrs:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$nodeRoot = (& npm root -g).Trim()`, written with `#`.

```text
Locate cspell's bundled tries under the global node_modules. They sit under the cspell package's own
nested @cspell/dict-* (cspell bundles them), so resolve npm's global root then the known relative path,
falling back to a recursive search if the layout differs.
```

## comment:2

Above `$triePaths = foreach ($trieName in 'en_US.trie.gz', 'en_GB.trie.gz') {`, written with `#`.

```text
cspell bundles the tries under its own nested @cspell/dict-* folders, and the exact folder casing
(dict-en_us vs dict-en-GB) is not worth guessing — search the global node_modules for each trie by name.
```

## comment:3

Above `$cspellVersion = (Invoke-Executable 'cspell --version' -PassThru...`, written with `#`.

```text
Record what the committed dictionary is flattened from, so a drift check can detect staleness WITHOUT
re-running node (Build-EnglishDictionary.Tests.ps1): the installed cspell version — compared against the
tools.yml pin — plus the exact dict package versions, read from each trie's sibling package.json.
```

## comment:4

Above `Write-Message 'Flattening cspell English dictionaries (en_US, en_GB) via...`, written with `#`.

```text
cspell-trie reads a trie and prints its words. Pin to the cspell 10 line to match the installed tries.
This shells out to npx (a cold run downloads cspell-trie) and reads ~440k words — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:5

Above `foreach ($line in [System.IO.File]::ReadLines($tmp)) {`, written with `#`.

```text
Keep only lower-cased, pure-alpha words of length >= 2. This drops cspell's apostrophe forms
('cause), digits, and single characters — none of which is an identifier fragment — and collapses
proper-noun casing (Nicaea -> nicaea) so the set is a clean lower-case word oracle.
```

## comment:6

Above `$stamp = [ordered]@{`, written with `#`.

```text
The stamp locks the artifact to its source versions. word_count also ties the stamp to THIS gz, so the
drift check can catch a stamp/gz mismatch by decompressing and counting — no node needed.
```

## comment:7

Above `$existing = $null`, written with `#`.

```text
Idempotency is decided on the DECOMPRESSED content (gzip container bytes are not the contract), so a
re-run with an unchanged dictionary is a no-op and the drift test compares like with like.
```
