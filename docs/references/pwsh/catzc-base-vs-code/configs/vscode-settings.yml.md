# pwsh/Base.VSCode/configs/vscode-settings.yml

The VS Code workspace-settings registry: the single authored source for `.vscode/settings.json`. Edit this file, never `settings.json`.

## Rendering and validation

The settings file the editor reads is a managed, gitignored copy rendered from this registry by `New-VsCodeSettings` (wired through
`Build-RootConfig`; see `rootconfig.yml` and [ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). Explanations live in
the registry as comments; the rendered JSON carries only a generated-file header, which is legal since VS Code reads JSONC.

`Get-Config -Config vscode-settings` loads it as `Catzc.Base.VSCode.VscodeSettingsConfig`. The settings stay a free-form, ordered passthrough
map of VS Code keys; the type checks the shape: only `settings`, non-empty; a `[language]` override is a map; `search.exclude` maps each glob
to true or false.

The `search.exclude` map is completed at render time. Every managed root-config target (`rootconfig.yml`, opted in) is added automatically,
so find-all always hits the source of truth, never a generated copy, and the editor stays glued to the tooling with no second list to
maintain. Authored entries win over an injected key of the same name.

## Markdown

Link validation runs while editing, as early feedback for what `Test-Links` gates
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)): dangling files and bad
heading fragments are flagged as warnings in the Problems pane, and http(s) links are never checked. Reference-link validation is off: VS
Code reads every footnote use (`[^1]`) as an undefined reference link, and markdownlint MD052 already gates real reference links.

## PowerShell formatting

"Format Document" uses the `powershell.codeFormatting` settings, not the `psd1`, so they are kept in step with
`PSScriptAnalyzerSettings.psd1`, or the formatter and the analyzer disagree:

- Pipeline indentation matches the psd1's `PSUseConsistentIndentation` `PipelineIndentation`, otherwise the formatter leaves a piped line
  under-indented and the analyzer flags it.
- Hashtable key and value pairs are aligned on format. This matches the psd1's `PSUseConsistentWhitespace`
  `IgnoreAssignmentOperatorInsideHashTable = $true`, so the analyzer accepts the aligned `=`.
- One-line blocks (`if ($x) { ... }`) are broken across lines on format, so no block keeps its braces on a single line. This matches the
  psd1's `PSPlaceOpenBrace` and `PSPlaceCloseBrace` `IgnoreOneLineBlock = $false`.

The formatter of `[markdown]`, and of every language `languages.yml` gives a formatter engine, is injected by the generator from that registry
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)), so
Format Document runs the engine `Format-Code` runs. Format-on-save stays off: formatting is on demand and enforced by `Test-Formatting`. XML
is never reformatted: no engine formats it (`languages.yml`), and the editor's XML formatter rewraps element text.

## What the editor hides, searches and watches

- **`search.exclude`** leaves out vendored modules and generated module manifests. The manifests (`pwsh/**/*.psd1`) are gitignored build
  output, canonical by their generator (Bootstrap), so they are not authored here and should not clutter search. The authored analyzer
  config lives under `pwsh/.internal/assets` and would fall under that glob, so it is explicitly un-excluded (a more specific `false` wins)
  to keep it searchable and visible.
- **`files.watcherExclude`** does not watch or reformat generated manifests, which the importer regenerates. The authored analyzer config is
  hand-edited, so it stays watched. The installed tool trees (the Python test environment, node packages) hold thousands of files nobody
  edits, so they are not watched. `out/` stays watched: the explorer shows each new run's report as it lands.
- **`files.exclude`** hides ignored paths that have no `!` exception, everywhere (explorer, search, quick open). The globs with exceptions
  (`README.md`, `*.psd1`, `*.pdf`) stay visible, because `files.exclude` would hide the tracked files too. `explorer.excludeGitIgnore` is not
  set: it would hide the generated settings folders (`.vscode` and the root config copies), which are ignored on purpose and still wanted in
  the explorer.
- **`hidden_actions`** lists the editor actions kept off its menus, by menu id: the Explorer's title row shows only the track lamps. VS Code
  keeps this in its own state store, never in `settings.json`; `Set-VsCodeHiddenAction` writes it there while VS Code is closed.

## File associations and editors

`files.associations` treats LICENSE files as plain text so markdownlint ignores them, maps `.yml` to generic YAML and `.yaml` to Azure
Pipelines YAML, maps `.markdownlintignore` to the built-in `ignore` (`.gitignore`) language so it is treated as a gitignore-syntax ignore file
and not as Markdown, and maps captured console output under `out/` to `ansi` (`iliazeus.vscode-ansi`), so the writers' colours render and the
escape codes are hidden.

`workbench.editorAssociations` routes `*.drawio.png` to VS Code's built-in image preview editor (viewType `imagePreview.previewEditor`, from
the bundled media-preview extension) instead of the Draw.io extension's binary custom editor. That is what makes git Compare show a real
raw-pixel image diff (side by side or slider), which the Draw.io editor cannot give. The value must be the image-preview viewType, not
`default`: `default` is the built-in text editor and yields "file is binary or uses an unsupported encoding" on a PNG. VS Code has no way to
pick an editor by diff versus open, so the association also applies to a plain open: double-clicking a `.drawio.png` shows the image, and
editing the diagram is right-click, Reopen Editor With, "Draw.io (Binary)". Pixels first was the deliberate call: these diagrams are compared
far more than edited.

## Languages and tools

- **Go** (the golang.go extension and gopls): the tools run with `GOTOOLCHAIN=local`, so the editor never downloads the toolchain `go.work`
  asks for; it runs the managed go, which the generator injects as `go.goroot` on a machine where `Install-Go` has run
  ([ADR-AUTO-GO-MANAGEDTOOLCHAIN](../../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-managedtoolchain)).
- **Python** (the ms-python extension): the generator injects `python.defaultInterpreterPath`, the Python test project's environment
  ([ADR-AUTO-PY-GENERATEDWORKSPACE](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-generatedworkspace)), so the
  editor resolves and runs the tests in it. A terminal is never activated into it: the integrated terminal stays the catzc pwsh session, and
  the tests run through `Test-Automation`, not an activated venv. Both activation keys are set: the Python extension reads the first, the
  Python Environments extension the second. Python writes its bytecode cache to `out/pycache` in every terminal of the editor, as
  `Invoke-PythonTest` has it, never beside the sources.
- **Schemas**: no extension fetches a schema. The YAML extension never asks SchemaStore and JSON never downloads one; every schema the editor
  checks against is a local file named in the settings.
- **Spell checking**: the single repository dictionary lives in `/cspell.yml`, auto-discovered by Code Spell Checker; the extension is
  recommended in `.vscode/extensions.json`.

## Terminals

`terminal.integrated.environmentChangesRelaunch` is false. Extensions (git, python, debugpy, go, copilot) contribute environment variables
after a terminal has started, and by default VS Code then relaunches every terminal not yet typed into, killing its pwsh and the import it
holds. A terminal keeps the environment it started with: the contributions are PATH entries and helper variables no cats command reads. The
stale-environment indicator stays on.

## Git state

The Git decorations on the open file take the lamps' one mapping (DDR-FILTER), with the shades named from the lamp palette, in the explorer and
the tab title. The gutter, right-hand ruler and minimap show the working tree's changes, so unstaged.

## editorconfig

The `editorconfig` map lists the `.editorconfig` sections `New-VsCodeSettings` renders into per-language settings, each glob to its VS Code
language ids. `[*]` renders into the top-level settings, and a section without a row here (the C# analyzer rules) stays for the tools that
read `.editorconfig`.

## carried

`carried` names the map settings another writer adds rows to: the map setting key, to the setting key that lists the rows that writer owns.
The track lamps add `files.exclude` rows at workspace scope this way, and the render keeps both sets as they are.
