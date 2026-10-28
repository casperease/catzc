# Module reference

One article per catzc module. Each is written **responsibilities-first**: it does not walk through individual functions — it declares the
_responsibilities_ the module owns, explains the module in terms of those responsibilities, and only at the end sorts the module's functions
and configuration into them.

## How to read these articles

Every article has the same three parts, mirroring the rule registry of a [decision record](../../drs/index.md):

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

- **[Catzc.Base.Asserts](base-asserts/index.md)**: The assertion library — fail-fast precondition and shape checks
- **[Catzc.Base.Engines](base-engines/index.md)**: The execution engine model — the three engines, pwsh, bash and zsh, declared once: start,
  quoting, strict mode, importer entry
- **[Catzc.Base.Repository](base-repository/index.md)**: Repository & output path anchors — root, repo-relative paths, pipeline detection
- **[Catzc.Base.Environment](base-environment/index.md)**: The host environment and the persistent PATH
- **[Catzc.Base.Objects](base-objects/index.md)**: Object shaping & serialization, and the shared `DictionaryRecord` base
- **[Catzc.Base.Writers](base-writers/index.md)**: Console output and diagnostics — the colour-aware writer family
- **[Catzc.Base.MarkdownMeta](base-markdown-meta/index.md)**: The pure reader and writer of a Markdown file's `catzc` meta block — derived
  facts, authored config, front matter left out of a copy
- **[Catzc.Base.CodeMeta](base-code-meta/index.md)**: The pure reader and writer of a code file's meta head — derived facts in a leading
  comment run, in the file's own comment syntax
- **[Catzc.Base.Config](base-config/index.md)**: The single config reader (`Get-Config`) and the `configs.yml` registry
- **[Catzc.Base.ConfigExtensions](base-config-extensions/index.md)**: The PowerShell config-validator extension point, for owners without a
  C# config type
- **[Catzc.Base.Flow](base-flow/index.md)**: The promotion ladder — the rungs a commit climbs, each with its gate and configuration
  environment
- **[Catzc.Base.FileLimits](base-file-limits/index.md)**: File length and width limits per file class — one config with bounds, a one-pass
  measure, and the checks that read them
- **[Catzc.Base.GeneratedFiles](base-generated-files/index.md)**: The generated-file writer registry — what each writer reads and writes,
  and which writers are due
- **[Catzc.Base.Folders](base-folders/index.md)**: Bounded folder listing — a compiled walker with a shallow default depth, and its defaults
  in the registry
- **[Catzc.Base.Reports](base-reports/index.md)**: The shared quality-gate report — one report, one printed summary, one verdict
- **[Catzc.Base.Variants](base-variants/index.md)**: Repo-wide variants fixed per importer session — naming order, enabled-customer set
- **[Catzc.Base.Timeouts](base-timeouts/index.md)**: Time safeguards — the configured limits and the stop-at-the-limit assertions
- **[Catzc.Base.Languages](base-languages/index.md)**: Go and Python test artifacts — go.yml and python.yml, the generated go.work/go.mod
  workspace and python/pyproject.toml, Invoke-PythonTest, and Invoke-GoTest
- **[Catzc.Base.Execution](base-execution/index.md)**: The external-process boundary — `Invoke-Executable`, `CliResult`/`CliRunner`
- **[Catzc.Base.Files](base-files/index.md)**: Filesystem and source-control facts — tree copy, file locks, git branch/commit
- **[Catzc.Base.Overlay](base-overlay/index.md)**: The consumer overlay — a consumer's function overrides applied to a built bundle, checked
  as a whole first
- **[Catzc.Base.Globs](base-globs/index.md)**: Globsets, durable-SHA identities, trigger files, and protected scans
- **[Catzc.Base.TypesSystem](base-types-system/index.md)**: The native C# type system — compiled-assembly cache and cross-module type-ref
  scanning
- **[Catzc.Base.Modules](base-modules/index.md)**: The one module resolver: every module of the deployable tracks, resolved through its
  track, and the aspect convention of a track
- **[Catzc.Base.ModuleSystem](base-module-system/index.md)**: The module/function dependency graph, integrity, and vendoring
- **[Catzc.Base.QualityGates](base-quality-gates/index.md)**: The repository's quality gates — tests, spelling, markdownlint, formatting
- **[Catzc.Base.Exporter](base-exporter/index.md)**: The installable-bundle exporter — bundle version and content-addressed identity
- **[Catzc.Base.Docs](base-docs/index.md)**: Generated module READMEs, copy-in from a docs source, gitignored
- **[Catzc.Base.Drs](base-drs/index.md)**: The ADR registry — `drs.yml`, the generated index, the citation map, `Test-DrsRegistry`, and
  citation rewriting
- **[Catzc.Base.Contracts](base-contracts/index.md)**: The repository's contracts made binding — asset listing, checking, the release
  freeze, and the contract reference
- **[Catzc.Base.Slides](base-slides/index.md)**: A deck rendered from one markdown file per slide through the kit's patterns, fail-forward,
  and the gate that checks every slide against the rules it quotes
- **[Catzc.Base.Maps](base-maps/index.md)**: The world map — every tracked file placed by track and file language, lit cells, the quality
  gate, and the PDFs
- **[Catzc.Base.Git](base-git/index.md)**: The declarative gitignore — explained sections in `gitignore.yml`, rendered by `New-GitIgnore`
- **[Catzc.Base.VSCode](base-vs-code/index.md)**: The declarative editor settings — `vscode-settings.yml` rendered into
  `.vscode/settings.json`
- **[Catzc.Base.RootConfig](base-root-config/index.md)**: Managed root config files — each reproduced on import from one in-repo source of
  truth
- **[Catzc.Base.Vendor](base-vendor/index.md)**: Vendored third-party modules — add, remove, and validate restorability from the source
- **[Catzc.Tooling.Core](tooling-core/index.md)**: Tool config and mapping, version/presence control, and the generic install engine
- **[Catzc.Tooling.Python](tooling-python/index.md)**: Python and pip, plus the pip-installed tools (Poetry, PySpark)
- **[Catzc.Tooling.Node](tooling-node/index.md)**: Node.js and npm, plus the npm-installed quality tools (cSpell, markdownlint, Prettier)
- **[Catzc.Tooling.Toolchain](tooling-toolchain/index.md)**: Build tools (.NET, Java, Terraform) and the Azure CLI binary
- **[Catzc.Tooling.Provisioning](tooling-provisioning/index.md)**: Workstation provisioning, status, hygiene, and the Git/Postman installers
- **[Catzc.Tooling.Environment](tooling-environment/index.md)**: Environment-variable hand-off — secrets and config values into `$env:` for
  external tools
- **[Catzc.Tooling.Github](tooling-github/index.md)**: The repository's GitHub integration — the GitHub-facing contracts, and provable
  erasure of a token from a GitHub repo's history and remote objects
- **[Catzc.Tooling.KeyHandler](tooling-key-handler/index.md)**: Replicate the Windows PSReadLine key bindings on Linux so shell editing keys
  match everywhere
- **[Catzc.Tooling.Claude](tooling-claude/index.md)**: Start Claude Code worker sessions on this machine, each on its agent file's model, in
  its own terminal window
- **[Catzc.Tooling.Inspiration](tooling-inspiration/index.md)**: Declare the sibling repositories read for ideas, and report where each
  lives and whether it is available here
- **[Catzc.Tooling.Listen](tooling-listen/index.md)**: Note every change the editor makes to the docs, and hand the notes to the listen
  mode's processor
- **[Catzc.Azure](azure/index.md)**: Azure identity and topology — the model behind every deployment
- **[Catzc.Azure.Cli](azure-cli/index.md)**: The Azure CLI surface — invocation, session, verification, context
- **[Catzc.Azure.DevOps](azure-dev-ops/index.md)**: Azure DevOps REST, pipeline inventory, and the runtime bridge
- **[Catzc.Azure.DevOps.BuildValidation](azure-dev-ops-build-validation/index.md)**: Build-validation branch policies tied to globsets — the
  server-side pre-commit gate
- **[Catzc.Azure.Firewall](azure-firewall/index.md)**: Firewall-rule ingestion and rendering
- **[Catzc.Azure.Templates](azure-templates/index.md)**: Bicep template discovery, naming, build, and deploy

## Beyond the modules

One reference area covers the part of `pwsh/` that is not itself a module:

- [Internal (`.psm1` shared infrastructure)](internal/index.md) — the loader and shared libraries under `pwsh/.internal/` that run the
  import sequence and load every module above.

The `types/*.cs` sources those loaders compile and load are written in [BCL](../BCL/index.md), a language of its own that pwsh hosts.

New here for a task rather than a survey? Start with the [getting-started guide](../../how-to/getting-started/automation/index.md).
