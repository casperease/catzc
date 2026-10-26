# pwsh/Base.QualityGates/private/Invoke-PsScriptAnalyzerFormat.ps1

The psscriptanalyzer formatter engine: it formats the given PowerShell files with the vendored analyzer's Invoke-Formatter and returns the
files it changed. It is one Format-Code engine adapter.

## help

### synopsis

The psscriptanalyzer formatter engine: formats the given PowerShell files with the vendored analyzer's Invoke-Formatter and the
.editorconfig rules, and returns the files it changed.

### description

One Format-Code engine adapter
([PDR-CONFIG-NEWINSTANCEISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfig)). Two steps per
file, the same two VS Code's Format Document and save apply:

1. Invoke-Formatter with the repository's one analyzer settings file — brace placement, indentation, whitespace, and hashtable alignment
   (the codeFormatting settings in vscode-settings.yml mirror the same rules);
2. the .editorconfig rules Invoke-Formatter does not read — LF line endings, no trailing whitespace, one final newline
   ([ADR-REPO-FORMAT-CROSSLANGUAGEBASELINE](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-crosslanguagebaseline)).

A file is written back as UTF-8 without a BOM only when the result differs, compared case-sensitively so a casing-only change counts. The
vendored analyzer and its settings ship in the code tree, so both resolve from the code root
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency));
the first use in a session imports the analyzer, which takes seconds and is announced.

### parameter `File`

Absolute paths of the PowerShell files to format.

### parameter `DryRun`

List the files that would change without writing them.

### outputs

`[object[]]` Absolute paths of the files changed (or, under -DryRun, that would change), and a `{ Path, Problem }` for each file the
formatter throws on, so Format-Code names it as unfixable and the other files still run.

## Sharding

A cold pass spends about 40 ms a file resolving command names it has not seen, so a large batch is sharded across a few processes. The
analyzer's initialization is not thread-safe, which is why the shards are processes, as in Get-ScriptAnalyzerDiagnostics. A small batch, the
usual warm-cache one, stays in this session.

## First use

The first use in a session pays the vendored-module import, which takes several seconds, so the engine announces it first
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).
