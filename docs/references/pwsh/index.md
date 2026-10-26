# Module reference

One article per catzc module. Each is written **responsibilities-first**: it does not walk through individual functions — it declares the
_responsibilities_ the module owns, explains the module in terms of those responsibilities, and only at the end sorts the module's functions
and configuration into them.

## How to read these articles

Every article has the same three parts, mirroring the rule registry of an [ADR](../../drs/index.md):

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
[native-csharp-types](../../drs/automation/BCL/native-csharp-types.md) and
[open-closed-architecture](../../drs/automation/open-closed-architecture.md)). They are listed here foundation-first.

- **[Catzc.Base.Asserts](catzc-base-asserts.md)**: The assertion library — fail-fast precondition and shape checks
- **[Catzc.Base.Engines](catzc-base-engines.md)**: The execution engine model — the three engines, pwsh, bash and zsh, declared once: start, quoting, strict mode, importer entry
- **[Catzc.Base.Repository](catzc-base-repository.md)**: Repository & output path anchors — root, repo-relative paths, pipeline detection
- **[Catzc.Base.Environment](catzc-base-environment.md)**: The host environment and the persistent PATH
- **[Catzc.Base.Objects](catzc-base-objects.md)**: Object shaping & serialization, and the shared `DictionaryRecord` base
- **[Catzc.Base.Writers](catzc-base-writers.md)**: Console output and diagnostics — the colour-aware writer family
- **[Catzc.Base.MarkdownMeta](catzc-base-markdown-meta.md)**: The pure reader and writer of a Markdown file's `catzc` meta block — derived facts, authored config, front matter left out of a copy
- **[Catzc.Base.CodeMeta](catzc-base-code-meta.md)**: The pure reader and writer of a code file's meta head — derived facts in a leading comment run, in the file's own comment syntax
- **[Catzc.Base.Config](catzc-base-config.md)**: The single config reader (`Get-Config`) and the `configs.yml` registry
- **[Catzc.Base.ConfigExtensions](catzc-base-config-extensions.md)**: The PowerShell config-validator extension point, for owners without a C# config type
- **[Catzc.Base.Flow](catzc-base-flow.md)**: The promotion ladder — the rungs a commit climbs, each with its gate and configuration environment
- **[Catzc.Base.FileLimits](catzc-base-file-limits.md)**: File length and width limits per file class — one config with bounds, a one-pass measure, and the checks that read them
- **[Catzc.Base.Folders](catzc-base-folders.md)**: Bounded folder listing — a compiled walker with a shallow default depth, and its defaults in the registry
- **[Catzc.Base.Reports](catzc-base-reports.md)**: The shared quality-gate report — one report, one printed summary, one verdict
- **[Catzc.Base.Variants](catzc-base-variants.md)**: Repo-wide variants fixed per importer session — naming order, enabled-customer set
- **[Catzc.Base.Timeouts](catzc-base-timeouts.md)**: Time safeguards — the configured limits and the stop-at-the-limit assertions
- **[Catzc.Base.Languages](catzc-base-languages.md)**: Go and Python test artifacts — go.yml and python.yml, the generated go.work/go.mod workspace and python/pyproject.toml, Invoke-PythonTest, and Invoke-GoTest
- **[Catzc.Base.Execution](catzc-base-execution.md)**: The external-process boundary — `Invoke-Executable`, `CliResult`/`CliRunner`
- **[Catzc.Base.Files](catzc-base-files.md)**: Filesystem and source-control facts — tree copy, file locks, git branch/commit
- **[Catzc.Base.Overlay](catzc-base-overlay.md)**: The consumer overlay — a consumer's function overrides applied to a built bundle, checked as a whole first
- **[Catzc.Base.Globs](catzc-base-globs.md)**: Globsets, durable-SHA identities, trigger files, and protected scans
- **[Catzc.Base.TypesSystem](catzc-base-types-system.md)**: The native C# type system — compiled-assembly cache and cross-module type-ref scanning
- **[Catzc.Base.Modules](catzc-base-modules.md)**: The one module resolver: every module of the deployable tracks, resolved through its track, and the aspect convention of a track
- **[Catzc.Base.ModuleSystem](catzc-base-module-system.md)**: The module/function dependency graph, integrity, and vendoring
- **[Catzc.Base.QualityGates](catzc-base-quality-gates.md)**: The repository's quality gates — tests, spelling, markdownlint, formatting
- **[Catzc.Base.Exporter](catzc-base-exporter.md)**: The installable-bundle exporter — bundle version and content-addressed identity
- **[Catzc.Base.Docs](catzc-base-docs.md)**: Generated module READMEs, copy-in from a docs source, gitignored
- **[Catzc.Base.Drs](catzc-base-drs.md)**: The ADR registry — `drs.yml`, the generated index, the citation map, `Test-DrsRegistry`, and citation rewriting
- **[Catzc.Base.Contracts](catzc-base-contracts.md)**: The repository's contracts made binding — asset listing, checking, the release freeze, and the contract reference
- **[Catzc.Base.Slides](catzc-base-slides.md)**: A deck rendered from one markdown file per slide through the kit's patterns, fail-forward, and the gate that checks every slide against the rules it quotes
- **[Catzc.Base.Maps](catzc-base-maps.md)**: The world map — every tracked file placed by track and file language, lit cells, the quality gate, and the PDFs
- **[Catzc.Base.Git](catzc-base-git.md)**: The declarative gitignore — explained sections in `gitignore.yml`, rendered by `New-GitIgnore`
- **[Catzc.Base.VSCode](catzc-base-vs-code.md)**: The declarative editor settings — `vscode-settings.yml` rendered into `.vscode/settings.json`
- **[Catzc.Base.RootConfig](catzc-base-root-config.md)**: Managed root config files — each reproduced on import from one in-repo source of truth
- **[Catzc.Base.Vendor](catzc-base-vendor.md)**: Vendored third-party modules — add, remove, and validate restorability from the source
- **[Catzc.Tooling.Core](catzc-tooling-core.md)**: Tool config and mapping, version/presence control, and the generic install engine
- **[Catzc.Tooling.Python](catzc-tooling-python.md)**: Python and pip, plus the pip-installed tools (Poetry, PySpark)
- **[Catzc.Tooling.Node](catzc-tooling-node.md)**: Node.js and npm, plus the npm-installed quality tools (cSpell, markdownlint, Prettier)
- **[Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md)**: Build tools (.NET, Java, Terraform) and the Azure CLI binary
- **[Catzc.Tooling.Provisioning](catzc-tooling-provisioning.md)**: Workstation provisioning, status, hygiene, and the Git/Postman installers
- **[Catzc.Tooling.Environment](catzc-tooling-environment.md)**: Environment-variable hand-off — secrets and config values into `$env:` for external tools
- **[Catzc.Tooling.Github](catzc-tooling-github.md)**: The repository's GitHub integration — the GitHub-facing contracts, and provable erasure of a token from a GitHub repo's history and remote objects
- **[Catzc.Tooling.KeyHandler](catzc-tooling-key-handler.md)**: Replicate the Windows PSReadLine key bindings on Linux so shell editing keys match everywhere
- **[Catzc.Tooling.Claude](catzc-tooling-claude.md)**: Start Claude Code worker sessions on this machine, each on its agent file's model, in its own terminal window
- **[Catzc.Tooling.Inspiration](catzc-tooling-inspiration.md)**: Declare the sibling repositories read for ideas, and report where each lives and whether it is available here
- **[Catzc.Tooling.Listen](catzc-tooling-listen.md)**: Note every change the editor makes to the docs, and hand the notes to the listen mode's processor
- **[Catzc.Azure](catzc-azure.md)**: Azure identity and topology — the model behind every deployment
- **[Catzc.Azure.Cli](catzc-azure-cli.md)**: The Azure CLI surface — invocation, session, verification, context
- **[Catzc.Azure.DevOps](catzc-azure-dev-ops.md)**: Azure DevOps REST, pipeline inventory, and the runtime bridge
- **[Catzc.Azure.DevOps.BuildValidation](catzc-azure-dev-ops-build-validation.md)**: Build-validation branch policies tied to globsets — the server-side pre-commit gate
- **[Catzc.Azure.Firewall](catzc-azure-firewall.md)**: Firewall-rule ingestion and rendering
- **[Catzc.Azure.Templates](catzc-azure-templates.md)**: Bicep template discovery, naming, build, and deploy

## Beyond the modules

One reference area covers the part of `pwsh/` that is not itself a module:

- [Internal (`.psm1` shared infrastructure)](internal/index.md) — the loader and shared libraries under `pwsh/.internal/` that run the
  import sequence and load every module above.

The `types/*.cs` sources those loaders compile and load are written in [BCL](../BCL/index.md), a language of its own that pwsh hosts.

New here for a task rather than a survey? Start with the [getting-started guide](../../how-to/getting-started/automation/index.md).
