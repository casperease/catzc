# pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml

<!-- cspell:ignore azuretools azureresourcegroups streetsidesoftware rosshamish kuskus kusto shd101wyy esbenp tomoki redhat Anson Levett -->
<!-- cspell:ignore iliazeus gopls hediet -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `recommendations:`, written with `#`.

```text
VS Code extension-recommendation registry — the single authored source for .vscode/extensions.json. The
file the editor reads is a managed, gitignored copy rendered from this registry by New-VsCodeExtensions
(wired through Build-RootConfig; see rootconfig.yml and [ADR-REPO-ROOTCFG](/docs/drs/repository/generated-root-configs.md)) —
edit THIS file, never extensions.json. Explanations live here as comments; the rendered JSON carries only a
generated-file header (VS Code reads JSONC, so the header is legal).

Loaded via Get-Config -Config vscode-extensions and validated by the VscodeExtensionsConfig type:
each entry is a publisher.name extension id, non-empty and unique.

```

## comment:4

Above `- ms-python.python`, written with `#`.

```text
The extensions that run the formatter engines — PowerShell, Go, Ruff, Prettier — are not listed here: the generator
adds each engine's extension from languages.yml (`formatters:`), the one place it is named
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)). They also carry the
language services: the PowerShell extension's debugging, and gopls, which reads the repository-root go.work.
The Python extension — for the Python tests under python/tests/: the settings generator points it at the generated
test project's environment (python/.venv), so imports and the test explorer resolve with no setting.
```

## comment:5

Above `- ms-dotnettools.csdevkit`, written with `#`.

```text
C# Dev Kit — the language service for the native C# type sources: it loads catzc.sln, whose project compiles
and analyzes the types the importer builds with Add-Type (the .editorconfig rules apply in the editor).
```

## comment:7

Above `commands:`, written with `#`.

```text
Each lamp is two commands, its on icon and its off icon, shown by the context key catzc.lamps.out.<lamp>; each declares the
conditions beyond committed, and the folder generator expands it into one command per condition, shown by the context key
catzc.lamps.state.<lamp>, its icon <icon>-<condition>.svg. The icons are the extension's own SVGs,
assets/extensions/catzc-track-lamps/, shipped as media/: a file copied in over one of them replaces that icon. Committed is green
(on a bright glyph; off, an active filter, a dark glyph pulsing in a turning ring), staged dark brown, unstaged yellowish, failed red.
```

## comment:8

Above `- command: catzc.lamps.orchestrate.red`, written with `#`.

```text
The orchestrator, leftmost and always shown: its colour sums the whole repository (red a failure, blue work in progress, green
neither; red until the first check), and a click while red lights every red lamp so every failing file is visible.
```

## comment:9

Above `repeat:`, written with `#`.

```text
One lamp per filter of filters.yml: each entry naming the repeat is written once per lamp. The open lamp is no switch: it stands
before them, always lit, and its one command focuses the next editor.
```
