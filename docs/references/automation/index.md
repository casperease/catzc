---
catzc:
  derived:
    path: docs/references/automation/index.md
    kind: reference
    language: markdown
    track: docs
    body_sha: e08fa0b56b3f
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/automation/open-closed-architecture.md
      - docs/adr/index.md
      - docs/how-to/getting-started/automation/index.md
      - docs/references/automation/BCL/index.md
      - docs/references/automation/catzc-azure-cli.md
      - docs/references/automation/catzc-azure-devops-buildvalidation.md
      - docs/references/automation/catzc-azure-devops.md
      - docs/references/automation/catzc-azure-firewall.md
      - docs/references/automation/catzc-azure-templates.md
      - docs/references/automation/catzc-azure.md
      - docs/references/automation/catzc-base-asserts.md
      - docs/references/automation/catzc-base-codemeta.md
      - docs/references/automation/catzc-base-config.md
      - docs/references/automation/catzc-base-configextensions.md
      - docs/references/automation/catzc-base-contracts.md
      - docs/references/automation/catzc-base-docs.md
      - docs/references/automation/catzc-base-engines.md
      - docs/references/automation/catzc-base-environment.md
      - docs/references/automation/catzc-base-execution.md
      - docs/references/automation/catzc-base-exporter.md
      - docs/references/automation/catzc-base-files.md
      - docs/references/automation/catzc-base-folders.md
      - docs/references/automation/catzc-base-git.md
      - docs/references/automation/catzc-base-globs.md
      - docs/references/automation/catzc-base-languages.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-markdownmeta.md
      - docs/references/automation/catzc-base-modulesystem.md
      - docs/references/automation/catzc-base-objects.md
      - docs/references/automation/catzc-base-overlay.md
      - docs/references/automation/catzc-base-qualitygates.md
      - docs/references/automation/catzc-base-reports.md
      - docs/references/automation/catzc-base-repository.md
      - docs/references/automation/catzc-base-rootconfig.md
      - docs/references/automation/catzc-base-timeouts.md
      - docs/references/automation/catzc-base-typessystem.md
      - docs/references/automation/catzc-base-variants.md
      - docs/references/automation/catzc-base-vendor.md
      - docs/references/automation/catzc-base-vscode.md
      - docs/references/automation/catzc-base-writers.md
      - docs/references/automation/catzc-tooling-core.md
      - docs/references/automation/catzc-tooling-environment.md
      - docs/references/automation/catzc-tooling-github.md
      - docs/references/automation/catzc-tooling-inspiration.md
      - docs/references/automation/catzc-tooling-keyhandler.md
      - docs/references/automation/catzc-tooling-node.md
      - docs/references/automation/catzc-tooling-provisioning.md
      - docs/references/automation/catzc-tooling-python.md
      - docs/references/automation/catzc-tooling-toolchain.md
      - docs/references/automation/internal/index.md
---

# Module reference

One article per automation module. Each is written **responsibilities-first**: it does not walk through individual functions — it declares
the _responsibilities_ the module owns, explains the module in terms of those responsibilities, and only at the end sorts the module's
functions and configuration into them.

## How to read these articles

Every article has the same three parts, mirroring the rule registry of an [ADR](../../adr/index.md):

1. **Responsibilities** — an ordered, named registry. Each entry is a `responsibility:<n>` heading with a definition of one area of
   responsibility the module owns. This is the vocabulary the rest of the article uses.
2. **The prose** — a human description of what the module does and how its responsibilities relate to each other and to the rest of the
   system. It talks about capabilities and responsibilities, not function names.
3. **Division** — the module's public functions and configuration files, bucketed under the responsibilities declared at the top. This is
   the only section that names concrete functions; it is the index from "what the module _is_" to "what the module _exposes_."

So the responsibilities are the stable contract; the function list is an appendix indexed by them. To understand a module, read the
responsibilities and the prose. To find the function for a job, scan the division.

## The modules

Modules are layered — a module may only call into the modules it declares in `dependencies.yml` (an acyclic graph; see
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md) and
[open-closed-architecture](../../adr/automation/open-closed-architecture.md)). They are listed here foundation-first.

| Module                                                                      | In one line                                                                                                                                                  |
| --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Catzc.Base.Asserts](catzc-base-asserts.md)                                 | The assertion library — fail-fast precondition and shape checks                                                                                              |
| [Catzc.Base.Engines](catzc-base-engines.md)                                 | The execution engine model — the three engines, pwsh, bash and zsh, declared once: start, quoting, strict mode, importer entry                               |
| [Catzc.Base.Repository](catzc-base-repository.md)                           | Repository & output path anchors — root, repo-relative paths, pipeline detection                                                                             |
| [Catzc.Base.Environment](catzc-base-environment.md)                         | The host environment and the persistent PATH                                                                                                                 |
| [Catzc.Base.Objects](catzc-base-objects.md)                                 | Object shaping & serialization, and the shared `DictionaryRecord` base                                                                                       |
| [Catzc.Base.Writers](catzc-base-writers.md)                                 | Console output and diagnostics — the colour-aware writer family                                                                                              |
| [Catzc.Base.MarkdownMeta](catzc-base-markdownmeta.md)                       | The pure reader and writer of a Markdown file's `catzc` meta block — derived facts, authored config, front matter left out of a copy                         |
| [Catzc.Base.CodeMeta](catzc-base-codemeta.md)                               | The pure reader and writer of a code file's meta head — derived facts in a leading comment run, in the file's own comment syntax                             |
| [Catzc.Base.Config](catzc-base-config.md)                                   | The single config reader (`Get-Config`) and the `configs.yml` registry                                                                                       |
| [Catzc.Base.ConfigExtensions](catzc-base-configextensions.md)               | The PowerShell config-validator extension point, for owners without a C# config type                                                                         |
| [Catzc.Base.Folders](catzc-base-folders.md)                                 | Bounded folder listing — a compiled walker with a shallow default depth, and its defaults in the registry                                                    |
| [Catzc.Base.Reports](catzc-base-reports.md)                                 | The shared quality-gate report — one report, one printed summary, one verdict                                                                                |
| [Catzc.Base.Variants](catzc-base-variants.md)                               | Repo-wide variants fixed per importer session — naming order, enabled-customer set                                                                           |
| [Catzc.Base.Timeouts](catzc-base-timeouts.md)                               | Time safeguards — the configured limits and the stop-at-the-limit assertions                                                                                 |
| [Catzc.Base.Languages](catzc-base-languages.md)                             | Go and Python test artifacts — go.yml and python.yml, the generated go.work/go.mod workspace and python/pyproject.toml, Invoke-PythonTest, and Invoke-GoTest |
| [Catzc.Base.Execution](catzc-base-execution.md)                             | The external-process boundary — `Invoke-Executable`, `CliResult`/`CliRunner`                                                                                 |
| [Catzc.Base.Files](catzc-base-files.md)                                     | Filesystem and source-control facts — tree copy, file locks, git branch/commit                                                                               |
| [Catzc.Base.Overlay](catzc-base-overlay.md)                                 | The consumer overlay — a consumer's function overrides applied to a built bundle, checked as a whole first                                                   |
| [Catzc.Base.Globs](catzc-base-globs.md)                                     | Globsets, durable-SHA identities, trigger files, and protected scans                                                                                         |
| [Catzc.Base.TypesSystem](catzc-base-typessystem.md)                         | The native C# type system — compiled-assembly cache and cross-module type-ref scanning                                                                       |
| [Catzc.Base.ModuleSystem](catzc-base-modulesystem.md)                       | The module/function dependency graph, integrity, and vendoring                                                                                               |
| [Catzc.Base.QualityGates](catzc-base-qualitygates.md)                       | The repository's quality gates — tests, spelling, markdownlint, formatting                                                                                   |
| [Catzc.Base.Exporter](catzc-base-exporter.md)                               | The installable-bundle exporter — bundle version and content-addressed identity                                                                              |
| [Catzc.Base.Docs](catzc-base-docs.md)                                       | Generated module READMEs, copy-in from a docs source, gitignored                                                                                             |
| [Catzc.Base.Contracts](catzc-base-contracts.md)                             | The repository's contracts made binding — asset listing, checking, the release freeze, and the contract reference                                            |
| [Catzc.Base.Maps](catzc-base-maps.md)                                       | The world map — every tracked file placed by track and file language, lit cells, the quality gate, and the PDFs                                              |
| [Catzc.Base.Git](catzc-base-git.md)                                         | The declarative gitignore — explained sections in `gitignore.yml`, rendered by `New-GitIgnore`                                                               |
| [Catzc.Base.VSCode](catzc-base-vscode.md)                                   | The declarative editor settings — `vscode-settings.yml` rendered into `.vscode/settings.json`                                                                |
| [Catzc.Base.RootConfig](catzc-base-rootconfig.md)                           | Managed root config files — each reproduced on import from one in-repo source of truth                                                                       |
| [Catzc.Base.Vendor](catzc-base-vendor.md)                                   | Vendored third-party modules — add, remove, and validate restorability from the source                                                                       |
| [Catzc.Tooling.Core](catzc-tooling-core.md)                                 | Tool config and mapping, version/presence control, and the generic install engine                                                                            |
| [Catzc.Tooling.Python](catzc-tooling-python.md)                             | Python and pip, plus the pip-installed tools (Poetry, PySpark)                                                                                               |
| [Catzc.Tooling.Node](catzc-tooling-node.md)                                 | Node.js and npm, plus the npm-installed quality tools (cSpell, markdownlint, Prettier)                                                                       |
| [Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md)                       | Build tools (.NET, Java, Terraform) and the Azure CLI binary                                                                                                 |
| [Catzc.Tooling.Provisioning](catzc-tooling-provisioning.md)                 | Workstation provisioning, status, hygiene, and the Git/Postman installers                                                                                    |
| [Catzc.Tooling.Environment](catzc-tooling-environment.md)                   | Environment-variable hand-off — secrets and config values into `$env:` for external tools                                                                    |
| [Catzc.Tooling.Github](catzc-tooling-github.md)                             | The repository's GitHub integration — the GitHub-facing contracts, and provable erasure of a token from a GitHub repo's history and remote objects           |
| [Catzc.Tooling.KeyHandler](catzc-tooling-keyhandler.md)                     | Replicate the Windows PSReadLine key bindings on Linux so shell editing keys match everywhere                                                                |
| [Catzc.Tooling.Inspiration](catzc-tooling-inspiration.md)                   | Declare the sibling repositories read for ideas, and report where each lives and whether it is available here                                                |
| [Catzc.Azure](catzc-azure.md)                                               | Azure identity and topology — the model behind every deployment                                                                                              |
| [Catzc.Azure.Cli](catzc-azure-cli.md)                                       | The Azure CLI surface — invocation, session, verification, context                                                                                           |
| [Catzc.Azure.DevOps](catzc-azure-devops.md)                                 | Azure DevOps REST, pipeline inventory, and the runtime bridge                                                                                                |
| [Catzc.Azure.DevOps.BuildValidation](catzc-azure-devops-buildvalidation.md) | Build-validation branch policies tied to globsets — the server-side pre-commit gate                                                                          |
| [Catzc.Azure.Firewall](catzc-azure-firewall.md)                             | Firewall-rule ingestion and rendering                                                                                                                        |
| [Catzc.Azure.Templates](catzc-azure-templates.md)                           | Bicep template discovery, naming, build, and deploy                                                                                                          |

## Beyond the modules

Two reference areas cover the parts of `automation/` that are not themselves `automation/*` modules:

- [Internal (`.psm1` shared infrastructure)](internal/index.md) — the loader and shared libraries under `automation/.internal/` that run the
  import sequence and load every module above.
- [BCL (C# / .NET types)](BCL/index.md) — the native C# type system those loaders compile and load.

New here for a task rather than a survey? Start with the [getting-started guide](../../how-to/getting-started/automation/index.md).
