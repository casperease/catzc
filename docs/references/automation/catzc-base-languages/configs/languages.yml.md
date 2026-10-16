---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/configs/languages.yml.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: bc55e83376ef
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-DSGN-TRACK#6
      - ADR-PIPE-NAME#6
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.Languages/configs/languages.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `engines:`, written with `#`.

```text
The file-language registry — every file language the repository's tracked files are written in, each named by its
extensions ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). A track's tech-stack is the set of
file languages it declares in variants.yml (`tracks:`); this registry makes that set checkable. Every extension
belongs to exactly one file language; an extension no entry lists has no file language.

Formatting is configured here, not programmed
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)): an entry names the
formatter engine for its files, and Format-Code (Catzc.Base.QualityGates) runs it; Test-Formatting checks the same
entries. Supporting a language on an existing engine is one line here. A language with nothing to format says why.
The editor reads the same entries: the root-config generator sets each language's VS Code default formatter to its
engine's extension and recommends that extension, so Format Document and Format-Code run the same engine
([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).

Per engine (engines:):
  vscode_extension  the VS Code extension that runs the engine in the editor; omitted = the editor has none
  settings          the repository files whose content decides what the engine writes — its configuration and the
                    tool registry whose pin names its version; a change to one invalidates Format-Code's result cache
                    for that engine; omitted = none

Per language (languages:):
  extensions       the extensions that name the language, lowercase, each with its leading dot
  formatter        the formatter engine: prettier | gofmt | ruff | psscriptanalyzer | dotnet-format | bicep
  no_formatter     instead of formatter: why the language has none (exactly one of the two)
  vscode_language  the VS Code language id of its files; omitted = the language's own name
  adr_folder       its ADR folder under docs/adr/; omitted = none
  checks           the quality gates Test-Change runs over a changed file of the language, in this order; a gate
                   with a -Path parameter is given the changed files, any other runs whole and its issues are kept
                   when they name a changed file; omitted = none

The defaults and the engine list are declared once on Catzc.Base.Languages.LanguagesConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). Loaded via
Get-Config -Config languages and read through Get-FileLanguage.

YAML is two file languages: executable pipeline YAML is `.yaml`, configuration data is `.yml`
([ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6)).
```

## comment:2

Above `psscriptanalyzer:`, written with `#`.

```text
PSScriptAnalyzer's formatter through the PowerShell extension, whose codeFormatting settings (vscode-settings.yml)
mirror the analyzer settings file. The vendored module's manifest names its version.
```
