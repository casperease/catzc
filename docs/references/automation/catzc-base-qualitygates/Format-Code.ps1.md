---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md
    kind: comment-page
    body_sha: "492e0789209d"
    adrs:
      - ADR-AUTO-CONSOLE#10
      - ADR-REPO-FORMAT#4
---

# automation/Catzc.Base.QualityGates/Format-Code.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Formatting is configured, not programmed ([ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)): the
file-language registry (Catzc.Base.Languages configs/languages.yml) names each language's formatter engine —
prettier, gofmt, ruff, psscriptanalyzer, dotnet-format, bicep — and this one command runs it. Supporting a
language on an existing engine is one line in that file; a new engine is one adapter (Invoke-FormatterEngine).

The files are every file git tracks, fixtures included, or the given -Path; vendored third-party code and contract
assets (`catzc-contract`, byte-frozen) are never formatted (Get-FormatScope). Each file belongs to the language its
extension names (Get-FileLanguage); a language without a formatter (`no_formatter:`) is left as it is. Each engine
reads the repository's layout settings — .editorconfig, .prettierrc.yml, the analyzer settings, the pinned ruff
configuration ([ADR-REPO-FORMAT#4](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format4)).

Each engine runs once over the files of every selected language it formats, so a tool that starts slowly starts
once. A result cache under out/ remembers, per file, that the engine last found it formatted, keyed on the file's
SHA-256 and a stamp of the engine's settings files and the tool pins (Get-FormatEngineStamp): a file whose key still
matches is not handed to the engine again, so a run after a small change checks only what changed
([ADR-AUTO-CACHE](/docs/adr/automation/caching.md)). A pipeline starts without the cache and checks everything;
-NoCache does the same on a devbox.

For each language it announces how many files it checked and changed, and names every changed file. With
-PassThru it returns one FormatResult per language; Test-Formatting runs it with -DryRun -PassThru.

Without -Path it formats the source tree, so it throws in build mode (Assert-SourceTree); with -Path it formats
the given files wherever they are (a built module manifest, for one; files outside the repository are never
cached).
```

## comment:2

Section `.PARAMETER Language` of the comment-based help.

```text
The file languages to format. Defaults to every language with a formatter. A language that is not declared, or
has no formatter, throws.
```

## comment:3

Above `$verb = $DryRun ? 'Checking' : 'Formatting'`.

```text
Announce before the engine runs: a whole-repository pass takes seconds and prints nothing until it ends
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:4

Above `if ($DryRun) {`.

```text
A file the engine left formatted is recorded; under -DryRun a file it would still change is not. Writing,
the engine has just formatted every file, so each is recorded under the key of its bytes now.
```

## comment:5

Above `$inScope = if ($Language) {`.

```text
Imprint steps run after every formatter, so a step never works on text a formatter is about to rewrite: a global step runs over
every language in scope, a language's own step over that language only.
```

## comment:6

Above `Write-Message "$verb $($pending.Count) $(@($engineGroup.Group |...`.

```text
Announce before the engine runs: a whole-repository pass takes seconds and prints nothing until it ends
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:7

Above `if ($DryRun) {`.

```text
A file the engine left formatted is recorded; under -DryRun a file it would still change is not. Writing,
the engine has just formatted every file, so each is recorded under the key of its bytes now.
```

## comment:8

Above `$inScope = if ($Language) {`.

```text
Imprint steps run after every formatter, so a step never works on text a formatter is about to rewrite: a global step runs over
every language in scope, a language's own step over that language only.
```
