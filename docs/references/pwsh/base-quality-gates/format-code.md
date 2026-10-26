# pwsh/Base.QualityGates/Format-Code.ps1

The repository's formatter entry point: it formats the files in scope, each with the engine `languages.yml` names for its file language, and
then runs the imprint steps that write derived heads and pages.

## help

### synopsis

Formats the repository's files, each with the formatter engine languages.yml names for its file language.

### description

Formatting is configured, not programmed ([PDR-CONFIG](../../../drs/principles/configure-not-program.md)): the file-language registry
(Catzc.Base.Languages configs/languages.yml) names each language's formatter engine — prettier, gofmt, ruff, psscriptanalyzer,
dotnet-format, bicep — and this one command runs it. Supporting a language on an existing engine is one line in that file; a new engine is
one adapter (Invoke-FormatterEngine).

The files are every file git tracks, fixtures included, or the given -Path; vendored third-party code and contract assets (`catzc-contract`,
byte-frozen) are never formatted (Get-FormatScope). Each file belongs to the language its extension names (Get-FileLanguage); a language
without a formatter (`no_formatter:`) is left as it is. A run also imprints (Invoke-ImprintStep) the file-meta heads of every file in its
scope, so a folder run can write heads into files nobody named. Each engine reads the repository's layout settings — .editorconfig,
.prettierrc.yml, the analyzer settings, the pinned ruff configuration
([ADR-REPO-FORMAT-BASELINEISFLOOR](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-baselineisfloor)).

Each engine runs once over the files of every selected language it formats, so a tool that starts slowly starts once. A result cache under
out/ remembers, per file, that the engine last found it formatted, keyed on the file's SHA-256 and a stamp of the engine's settings files
and the tool pins (Get-FormatEngineStamp): a file whose key still matches is not handed to the engine again, so a run after a small change
checks only what changed ([ADR-AUTO-CACHE](../../../drs/automation/caching.md)). A pipeline starts without the cache and checks everything;
-NoCache does the same on a devbox.

For each language it announces how many files it checked and changed, and names every changed file. With -PassThru it returns one
FormatResult per language; Test-Formatting runs it with -DryRun -PassThru.

Without -Path it formats the source tree, so it throws in build mode (Assert-SourceTree); with -Path it formats the given files wherever
they are (a built module manifest, for one; files outside the repository are never cached).

### parameter `Language`

The file languages to format. Defaults to every language with a formatter. A language that is not declared, or has no formatter, throws.

### parameter `Path`

Files or folders to format (a folder: its tracked files). Defaults to every tracked file.

### parameter `DryRun`

Report which files would change without writing them.

### parameter `NoCache`

Check every file, ignoring the result cache (which is still refreshed).

### parameter `PassThru`

Return one Catzc.Base.QualityGates.FormatResult per language.

### outputs

`[Catzc.Base.QualityGates.FormatResult]` With -PassThru only.

### example 1

```powershell
Format-Code
```

### example 2

```powershell
Format-Code -Language markdown -Path docs/drs/principles
```

### example 3

```powershell
(Format-Code -DryRun -PassThru).ChangedFiles
```

## Announcing

A whole-repository pass is silent for seconds, so the command announces what it is about to format before the engine runs
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).

## What is recorded

A file the engine left formatted is recorded as done. Under `-DryRun` a file the engine would still change is not recorded. When it writes,
the engine has just formatted every file, so each is recorded under the key of its bytes now. A file a person must still repair is never
recorded, so the next run reports it again.

## Imprint steps

Imprint steps run after every formatter, so a step never works on text a formatter is about to rewrite. A global step runs over every
language in scope, and a language's own step runs over that language only. Each step has its own cache file, `cache/format-code-<step>.json`
under the output root, because one file passes through an engine and several steps and a cache keeps one slot per file. Some steps read more
than the file: the plan-counts step's verdict reads the open steps of the plans beside each overlay, so those counts join its key.
