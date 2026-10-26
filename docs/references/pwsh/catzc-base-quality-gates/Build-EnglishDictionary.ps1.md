# pwsh/Base.QualityGates/Build-EnglishDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Generates the committed English word list the spell-out-names analyzer rule checks identifiers against — flattened from cspell's own bundled
dictionaries so the two checks agree on "what is a word".

### description

Reads cspell's bundled en_US and en_GB tries (the same dictionaries cspell.yml's `language: en,en-GB` resolves), flattens each to a word
list with `cspell-trie reader`, unions them, keeps only lower-cased pure-alpha words of length >= 2, and writes the sorted, de-duplicated
result gzip-compressed to pwsh/Base.QualityGates/assets/english.txt.gz.

Unlike the `.cspell/*.txt` term lists (regenerated cheaply from terminology.yml on every import), this list is EXPENSIVE to regenerate — it
needs node, npx, and cspell's bundled tries — and it is needed on a fresh checkout by the L2 analyzer rule (Measure-SpellOutIdentifiers). So
it is COMMITTED, the same call the compiled-type prebuild makes
([ADR-REPO-OUTDIR-COMPILEDPREBUILD](../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-compiledprebuild)): a
deterministic, expensive-to-regenerate artifact kept in the tree, not regenerated at import. Alongside the gz it writes a committed stamp
(`assets/english.stamp`) recording the cspell + dict package versions it was flattened from and the word count. The drift check
(Build-EnglishDictionary.Tests.ps1) compares that stamp's cspell version against the tools.yml pin — cheaply, with no node round-trip — and
fails when they diverge, so a cspell bump that leaves this artifact stale is caught in CI. Re-run this (and commit the gz + stamp) when
bumping cspell; `-DryRun` reports whether either would change. It writes the source module in the repository, so it needs the source mode
and throws in build mode (Assert-SourceTree).

SpellingOracle (Catzc.Base.QualityGates/types) loads this list plus every `.cspell/*.txt` term list into one set. English recognizes the
spelled-out words (rule, collection, group); the term lists carry the product vocabulary and the conventional-abbreviation allow-list. See
[ADR-AUTO-SPELL](../../../drs/automation/spell-out-names.md).

### parameter `DryRun`

Report whether the committed list would change without writing it. The returned content is the same in either mode; -DryRun skips the write.
See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `PassThru`

Return a result object ({ Path, WordCount, Changed, DryRun }) instead of the path string.

### outputs

`[string]` The path to the generated english.txt.gz (with -PassThru, the result object instead).

### example 1

```powershell
Build-EnglishDictionary
Regenerates the committed English word list from cspell's bundled dictionaries.
```

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
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).
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

## comment:8

Above `$found = Get-ChildPath $nodeRoot -File -Filter $trieName -Depth 5 -Exclude...`, written with `#`.

```text
The trie sits five levels down (cspell, node_modules, @cspell, package, file); the walk must enter
node_modules.
```
