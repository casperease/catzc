# pwsh/Base.Languages/configs/languages.yml

The file-language registry: every file language the repository's tracked files are written in, each named by its extensions
([DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)). A track's tech-stack is the set of file languages
it declares in `variants.yml` (`tracks:`); this registry makes that set checkable. Every extension belongs to exactly one file language, and
an extension no entry lists has no file language.

Formatting is configured here, not programmed
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)): an
entry names the formatter engine for its files, and `Format-Code` runs it; `Test-Formatting` checks the same entries. Supporting a language
on an existing engine is one line here, and a language with nothing to format says why. The editor reads the same entries: the root-config
generator sets each language's VS Code default formatter to its engine's extension and recommends that extension, so Format Document and
`Format-Code` run the same engine
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)).

## Per formatter (`formatters:`)

- **`vscode_extension`** — the VS Code extension that runs the engine in the editor; omitted means the editor has none.
- **`settings`** — the repository files whose content decides what the engine writes: its configuration and the tool registry whose pin
  names its version. A change to one invalidates the `Format-Code` result cache for that engine; omitted means none.

PSScriptAnalyzer's formatter runs through the PowerShell extension, whose `codeFormatting` settings (`vscode-settings.yml`) mirror the
analyzer settings file. The vendored module's manifest names its version.

## Per language (`languages:`)

- **`extensions`** — the extensions that name the language, lowercase, each with its leading dot.
- **`formatter`** — the formatter engine: `prettier`, `gofmt`, `ruff`, `psscriptanalyzer`, `dotnet-format` or `bicep`.
- **`no_formatter`** — instead of `formatter`: why the language has none. Exactly one of the two.
- **`vscode_language`** — the VS Code language id of its files; omitted means the language's own name.
- **`drs_folder`** — its decision-record folder under `docs/drs/`; omitted means none.
- **`checks`** — the quality gates `Test-Change` runs over a changed file of the language, in this order. A gate with a `-Path` parameter is
  given the changed files; any other runs whole, and its issues are kept when they name a changed file. Omitted means none.
- **`check_scopes`** — for a gate that governs one folder, the global config address of that folder (`Test-Plans`: `global.plans.folder`),
  so `Test-Change` gives the gate only the changed files under it. A gate with no entry governs every file of the language; omitted means
  none.

YAML is two file languages: executable pipeline YAML is `.yaml`, configuration data is `.yml`
([FDR-PIPELINE-EXECUTABLEYAMLEXTENSION](../../../../drs/flow/pipeline-concept.md#rule-fdr-pipeline-executableyamlextension)).

## Other sections

- **`layout`** — the folders of a module this language owns. `assets/` and `tests/` are on `LayoutRow`, since no one language owns them.
  `shipped` means a build copies the folder verbatim; the functions are merged into one file instead, so their rows are not shipped.
- **`accosted`** — a flat list of harmless contracted calls, run under every engine
  ([ADR-AUTO-ACCOSTED](../../../../drs/automation/accosted-language.md)). Its compound extension wins over `.yml`.
- **`tag`** — what a diagram prints on a glyph whose label is a snippet of the language: the tag, and the shapes that name a label as one (a
  command `Verb-Noun`, a `$variable`, a `-Flag`, a module name `Catzc.X.Y`). A label that matches no shape prints no tag.

## How it is read

The defaults and the engine list are declared once on `Catzc.Base.Languages.LanguagesConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). The file
is loaded by `Get-Config -Config languages` and read through `Get-FileLanguage`.
