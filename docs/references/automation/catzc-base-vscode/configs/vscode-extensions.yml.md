---
catzc:
  immutable:
    with_body_sha: "7ac511f16380"
    repo_status: locked
    path: docs/references/automation/catzc-base-vscode/configs/vscode-extensions.yml.md
    folder: docs/references/automation/catzc-base-vscode/configs
    name: vscode-extensions-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-FORMAT#8
      - ADR-REPO-LINK#3
---

# automation/Catzc.Base.VSCode/configs/vscode-extensions.yml

<!-- cspell:ignore azuretools azureresourcegroups streetsidesoftware rosshamish kuskus kusto shd101wyy esbenp tomoki redhat Anson Levett -->
<!-- cspell:ignore iliazeus gopls -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `recommendations:`, written with `#`.

```text
VS Code extension-recommendation registry — the single authored source for .vscode/extensions.json. The
file the editor reads is a managed, gitignored copy rendered from this registry by New-VSCodeExtensions
(wired through Build-RootConfig; see rootconfig.yml and [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)) —
edit THIS file, never extensions.json. Explanations live here as comments; the rendered JSON carries only a
generated-file header (VS Code reads JSONC, so the header is legal).

Loaded via Get-Config -Config vscode-extensions and validated by the VscodeExtensionsConfig type:
each entry is a publisher.name extension id, non-empty and unique.

```

## comment:2

Above `- ibm.output-colorizer`, written with `#`.

```text
Pattern-based coloring of the Output panel and .log files (keywords, paths, numbers) — it does not interpret
ANSI escape codes.
```

## comment:3

Above `- iliazeus.vscode-ansi`, written with `#`.

```text
ANSI Colors — renders the escape codes the writers emit (console-output-matters) in a captured log, hiding the
codes themselves; the vscode-settings registry associates **/out/**/*.log with its `ansi` language.
```

## comment:4

Above `- ms-python.python`, written with `#`.

```text
The extensions that run the formatter engines — PowerShell, Go, Ruff, Prettier — are not listed here: the generator
adds each engine's extension from languages.yml (`formatters:`), the one place it is named
([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)). They also carry the
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

## comment:6

Above `- DanLevett.regex-robin`, written with `#`.

```text
Regex Robin — makes code links in comments Ctrl+clickable. Core VS Code links only http/https/file URLs
outside markdown, so the regexrobin.rules entry in vscode-settings.yml turns each repository-rooted
code link into a file link ([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)).
```
