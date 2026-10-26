# pwsh/Base.VSCode/configs/vscode-extensions.yml

The VS Code extension registry: the one authored file that `.vscode/extensions.json` is rendered from and for the repository's own editor
extensions, the track lamps and the file icon theme. Edit this file, never `extensions.json`.

## The recommendation list

The file the editor reads is a managed, gitignored copy rendered from this registry by `New-VsCodeExtensions` (wired through
`Build-RootConfig`; see `rootconfig.yml` and [ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). Explanations live in
the registry as comments; the rendered JSON carries only a generated-file header, which is legal since VS Code reads JSONC.

`Get-Config -Config vscode-extensions` loads it and the `VscodeExtensionsConfig` type validates it: each entry is a `publisher.name`
extension id, non-empty and unique.

The extensions that run the formatter engines (PowerShell, Go, Ruff, Prettier) are not listed: the generator adds each engine's extension
from `languages.yml` (`formatters:`), the one place it is named
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)). They
also carry the language services: the PowerShell extension's debugging, and gopls, which reads the repository-root `go.work`. The Python
extension serves the Python tests under `python/tests/`: the settings generator points it at the generated test project's environment
(`python/.venv`), so imports and the test explorer resolve with no setting.

C# Dev Kit is the language service for the native C# type files: it loads `catzc.sln`, whose project compiles and analyzes the types the
importer builds with `Add-Type` (the `.editorconfig` rules apply in the editor).

## The repository's own extensions

Each extension renders to `out/vscode-extensions/<name>/` from its js track module, `js/<name>/extension.js` and its `assets/`.

### The track lamps

- A lamp is two commands, its on icon and its off icon, shown by the context key `catzc.lamps.out.<lamp>`. Each lamp declares the conditions
  beyond committed, and the folder generator expands it into one command per condition, shown by the context key `catzc.lamps.state.<lamp>`,
  with the icon `<icon>-<condition>.svg`. The icons are the extension's own SVGs, in `assets/extensions/catzc-track-lamps/`, shipped as
  `media/`: a file copied in over one of them replaces that icon.
- The orchestrator stands leftmost and is always shown. Its colour sums the whole repository (red a failure, blue work in progress, green
  neither; red until the first check), and a click while red lights every red lamp so every failing file is visible.
- There is one lamp per filter of `filters.yml`: each entry naming the repeat is written once per lamp. The open lamp is no switch; it
  stands before them, always lit, and its one command focuses the next editor.
- There is one lamp per tagged language of the languages config, named `lang-<name>` and labelled with its tag; the languages button ticks
  which of them stand in the row, after the filters.
- The colours are the lamps' one mapping
  ([DDR-FILTER-STATEALWAYSSHOWN](../../../../drs/design/repository-filters.md#rule-ddr-filter-statealwaysshown)): local work in progress is
  blue-grey, staged dark, unstaged lighter.
