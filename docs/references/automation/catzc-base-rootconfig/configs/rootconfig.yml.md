---
catzc:
  immutable:
    with_body_sha: bd2d0d8211b0
    path: docs/references/automation/catzc-base-rootconfig/configs/rootconfig.yml.md
    folder: docs/references/automation/catzc-base-rootconfig/configs
    name: rootconfig-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.RootConfig/configs/rootconfig.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `files:`, written with `#`.

```text
Root config registry — repository-root files fully managed by the source-of-truth automation. Each entry
names ONE in-repo source of truth (`source`: an authored file copied out, or `generator`: a function that
renders the content) and Build-RootConfig reproduces the target from it on every import.

Two booleans, both defaulting to FALSE:
  optIn      — is this file managed at all? Opt-out is the default: an entry with optIn false (or a root
               file with no entry) stays hand-authored and committed.
  committed  — is the managed target tracked in git? false = gitignored (reproduced on import, invisible
               churn); true = committed (for files git or the bootstrap reads BEFORE the importer runs —
               importer.ps1, the git files), where a source change surfaces as a reviewable diff.
  copyAsLink — materialise the target as a filesystem LINK to the source (Set-FileLink: a symbolic link, or
               a hard link on Windows without the symlink privilege) instead of a generated copy: the root
               file IS the source, so drift is impossible and no head is written. Requires `source`,
               requires committed false, forbids a declared `carrier`. Healed per-OS at the importer tail.

`carrier` names the file-carriers entry for the generated-file head of a composed file (default: the entry of the
target's file language); `sources` lists the authored files a generator renders from. All paths are repository-root-
relative and forward-slashed (communication form; see [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Loaded
via Get-Config -Config rootconfig; the shape is validated by Catzc.Base.RootConfig.RootConfigFiles. See
[ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```

## comment:2

Above `- target: importer.ps1`, written with `#`.

```text
importer.ps1 has TWO valid source-of-truth forms, swapped by editing this entry alone:
  generator: New-Importer  — the live form: the full shim, rendered from the Invoke-Importer overlay's
                             param block on every import (the drift guard in New-Importer.Tests.ps1).
  source: automation/Catzc.Base.RootConfig/assets/root/importer.ps1 (comment: none)
                           — the SEED form for a first check-in: a minimal bootstrap that just performs
                             one full import; the importer tail's Build-RootConfig then materialises
                             whatever THIS entry names, so switching back to the generator self-heals
                             the seed into the full shim on the very next load.
```

## comment:3

Above `- target: importer.sh`, written with `#`.

```text
importer.sh — the bash (and zsh) entry: sourced, it defines the `cats` dispatcher that runs catzc commands through
pwsh ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). Committed for the same reason as importer.ps1: a fresh clone needs
it before any import.
```

## comment:4

Above `- target: .vscode/settings.json`, written with `#`.

```text
The three generated .vscode/ files are gitignored generated copies (committed: false) — the editor greys
them and a fresh clone materialises them on the first import. Sources of truth: the Catzc.Base.VSCode
registries (settings/extensions/launch).
```

## comment:5

Above `- target: .vscode/azure-pipelines-schema.json`, written with `#`.

```text
The Azure Pipelines schema the extension validates our .yaml against (wired via
azure-pipelines.customSchemaFile in vscode-settings.yml). Gitignored generated copy like the others.
```

## comment:6

Above `- target: go.work`, written with `#`.

```text
The Go test workspace (Catzc.Base.Languages, New-GoWorkspace): go.work at the repository root, and one go.mod
per Go test module under the Go root (go.yml `root`: go/ when present, else .go/). Gitignored generated copies.
```

## comment:7

Above `- target: "*/pyproject.toml"`, written with `#`.

```text
The Python test workspace (Catzc.Base.Languages, New-PythonProject): the uv workspace root pyproject.toml in the Python
root (python.yml `root`: python/ when present, else .python/), and one member pyproject.toml per Python test folder.
Gitignored generated copies; uv makes the one .venv and uv.lock beside the workspace root.
```

## comment:8

Above `- target: .markdownlintignore`, written with `#`.

```text
The ignore files and cspell.yml stay generated COPIES until the symlink path is verified on Linux (the
tools may resolve relative references against a symlinked config's real path — cspell's .cspell/
references are the suspect case). Flip each to copyAsLink only after the gates run green through a
symbolic link; see the plan's step 12 and the generated-root-configs ADR.
```

## comment:9

Above `- target: .cspell/.gitignore`, written with `#`.

```text
The nested ignore for the generated .cspell/ dictionaries. A generated COPY forever, never copyAsLink:
git itself refuses to honour a symlinked .gitignore, so the Linux-verification caveat above does not
apply — there is nothing to flip to.
```

## comment:10

Above `- target: dotnet-tools.json`, written with `#`.

```text
JSON has no comment syntax (and the dotnet manifest parser rejects // line comments), so the managed-file
marker travels IN the authored source as an ignored "//" property.
```

## comment:11

Above `- target: catzc.sln`, written with `#`.

```text
MSBuild's solution parser requires the 'Format Version' line at the top, so the managed-file note lives
inside the source's own '#' comment block (which the format allows only after that line).
```
