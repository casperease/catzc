# pwsh/Base.Languages/types/LanguagesConfig.cs

The typed record for `languages.yml`, the file-language registry: every file language the repository's tracked files are written in, each
named by its extensions ([DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)), with the formatter engine
that formats it and its ADR folder. It is registered in `Catzc.Base.Config/configs/configs.yml` (type
`Catzc.Base.Languages.LanguagesConfig`), so `Get-Config -Config languages` returns it; `Get-FileLanguage` and `Format-Code` read it. Its
property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Configured, not programmed

Formatting is configured, not programmed
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)): an
entry names the formatter engine that formats its files, one of the engines below, and `Format-Code` runs that engine. A language with
nothing to format states why in `no_formatter` instead
([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)), so every
language carries exactly one of the two and a gap is a visible, reviewed entry.

The formatter engines a language may name are one `Format-Code` adapter each. A new engine is new mechanism, so its adapter and its name
here land together
([PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfigchange)).

## Defaults

The sensible defaults are declared here, once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): an
omitted `languages` is no file language, an omitted `adr_folder` is none, and an omitted `checks` is no quality gate. The VS Code language
id defaults to the language's own name; an entry states it only where the editor's id differs (pipeline YAML is VS Code's `azure-pipelines`
language).

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- only `formatters` and `languages` at the top; only `extensions`, `formatter`, `no_formatter`, `vscode_language`, `adr_folder`, `checks`
  and `check_scopes` in a language entry; only `vscode_extension` and `settings` in an engine entry, so a typo fails at load;
- `checks` is a list of quality-gate command names (`Test-<Noun>`, for example `Test-ScriptAnalyzer`), each at most once: the gates
  `Test-Change` runs over a changed file of the language;
- `check_scopes` is a map from one of the language's own checks to a global config address (`global.<config>.<key>`, for example
  `global.plans.folder`) of the folder the gate governs; a gate with no entry governs every file of the language;
- an engine entry's key is one of the engines, its `vscode_extension` a `publisher.name` extension id, and its `settings` a list of
  `/`-separated repository-relative files (no `.` or `..` segment);
- `vscode_language` (default: the language's own name) is a VS Code language id;
- a language name is kebab-case;
- `extensions` is a non-empty list; each extension starts with its leading dot, is lowercase letters and digits after it (for example
  `.ps1`), and belongs to exactly one file language (an extension claimed twice is rejected);
- exactly one of `formatter` (an engine) and `no_formatter` (a non-empty reason);
- `adr_folder` is a `/`-separated folder under `docs/drs/`, no leading or trailing slash, no `.` or `..` segment.

## Members

- **`formatters`** — the engines' own settings, by engine name: the VS Code extension that runs the same engine in the editor. An engine the
  file does not list has no editor formatter.
- **`EditorFormatters()`** — the editor formatter of every language whose engine names a VS Code extension, keyed by the language's VS Code
  language id: what the editor's Format Document runs, the same engine `Format-Code` runs
  ([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)).
- **`ExtensionOf(path)`** — the extension of a file path, lowercase with its leading dot, or null when it has none. A dotfile whose only dot
  is its first character (`.gitkeep`, `.editorconfig`) has no extension.
- **`ForPath(path)`** — the file language of a file path, by the longest extension a language declares, so `x.widget.yml` takes the language
  that declares `.widget.yml` while `x.yml` keeps the one that declares `.yml`; null when no extension of the file names one.
- **`PlaceOf(relativePath)`** — the row of the layout that places a file, given its `/`-separated path relative to the module root, or null
  when no row does: a file at the root is placed by the root row of its extension, a file below a folder by the row that names the folder.
- **`IsLaidOut(trackLanguages)`** — a track is laid out when its primary language, the first it declares, owns a live layout row; its
  modules exist by that layout. A language whose only rows are never live (markdown's readme) lays out no module.
- **`FolderOf(role)`** — the module subfolder the layout gives a role (for example test, private-function): the one resolver of a
  folder-name setting
  ([ADR-REPO-FOLDERS-NAMESARESETTINGS](../../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-namesaresettings)).
- **`TestFolderOf(languageName, …)`** — the folder a module's tests have under a language's `tests/`, in that language's folder case: the
  module's folder, which drops the namespace of the track that prefixes it, so a caller passes the module's name and never strips it itself.
