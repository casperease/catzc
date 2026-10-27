# pwsh/Base.QualityGates/Build-EnglishDictionary.ps1

The authoring step that flattens cspell's bundled English word lists (en_US and en_GB) into one committed, compressed word list, with a
stamp that records where it came from. The spell-out-names analyzer rule checks identifiers against that list, so the list is committed and
the check needs no node at run time.

## help

### synopsis

Generates the committed English word list the spell-out-names analyzer rule checks identifiers against, flattened from cspell's own bundled
dictionaries so the two checks agree on what a word is.

### description

Reads cspell's bundled en_US and en_GB tries (the same dictionaries cspell.yml's `language: en,en-GB` resolves), flattens each to a word
list with `cspell-trie reader`, unions them, keeps only lower-cased pure-alpha words of length >= 2, and writes the sorted, de-duplicated
result gzip-compressed to pwsh/Base.QualityGates/assets/english.txt.gz.

Unlike the `.cspell/*.txt` term lists (regenerated cheaply from terminology.yml on every import), this list is EXPENSIVE to regenerate — it
needs node and cspell's bundled tries — and it is needed on a fresh checkout by the L2 analyzer rule (Measure-SpellOutIdentifiers). So it is
COMMITTED, the same call the compiled-type prebuild makes
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

## Finding the word lists

cspell keeps its English tries under its own nested `@cspell/dict-*` folders, and the folder casing differs (`dict-en_us`, `dict-en-GB`), so
the command does not guess it. It asks npm for the global `node_modules` root and finds each trie by name, `en_US.trie.gz` and
`en_GB.trie.gz`. A trie sits five levels down (cspell, `node_modules`, `@cspell`, the package, the file), so the walk enters `node_modules`.

## Flattening

`cspell-trie-lib`, the trie library the installed cspell ships under its own `node_modules`, decodes each trie in a node script read from
stdin, so the reader is always at the cspell pin and nothing is fetched
([ADR-AUTO-NET-NODEFAULTPATH](../../../drs/automation/network-calls.md#rule-adr-auto-net-nodefaultpath)). About 440,000 words come back, so
the command announces the step first
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).
Only lower-cased, purely alphabetic words of two letters or more are kept. That drops apostrophe forms such as `'cause`, digits and single
characters, none of which is an identifier fragment, and it folds proper-noun casing (`Nicaea` becomes `nicaea`), so the set is a clean
lower-case word oracle.

## The stamp

The stamp locks the artifact to its sources: the installed cspell version, which is compared against the pin in `tools.yml`, and the exact
dictionary package versions, each read from the sibling `package.json` of its trie. The word count also ties the stamp to this gz file, so a
drift check can find a stamp and gz that no longer match by decompressing and counting, with no node.

## Idempotent

Whether anything changed is judged on the decompressed words, never on the gzip bytes, which are not the contract. A re-run with an
unchanged dictionary writes nothing, and the drift test compares like with like.
