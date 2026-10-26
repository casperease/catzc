# pwsh/Base.Globs/configs/globs/globs.yml

The globset registry: the single source of truth that maps every area-of-control onto its files under version control
([FDR-CD-GLOBS](../../../../../drs/flow/durable-sha-globs.md)). Each set projects to the native vendor path filters that pipelines and
workflows trigger on (`Get-GlobSetTrigger`) and to a git-reflected blast radius (`Get-ChangedGlobSet`); nothing is committed per set. The
file is validated strictly on load by `Catzc.Base.Globs.GlobsConfig` (`GlobsConfig.cs`).

## Layers

Every set declares its layer
([FDR-CD-GLOBS-EVERYSETHASLAYER](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-everysethaslayer)):

- `deployable-unit` is a configurable unit that ships.
- `loose-fileset` is a cross-cutting check surface, such as a track's root concern, a scan scope or the whole repository, that deliberately
  overlaps the boundaries it cuts across.

The `module` layer is derived from the folders and the internal `.psm1` files, never declared, and carries its own `module-leftovers`
catch-all. Derived sets scope protection and blast radius
([ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS](../../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-derivedmoduleglobsets)).

## Independence and composition

Within every layer but `loose-fileset`, no two sets may select a common file on their own contribution: a unit never consumes another unit's
files, and a module never another module's
([FDR-CD-GLOBS-NOOVERLAPWITHINLAYER](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nooverlapwithinlayer)). Loose filesets
overlap freely. `compose` unions another declared set's effective members into this one, and the references stay acyclic
([FDR-CD-GLOBS-COMPOSESETS](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-composesets)). `pipeline` names the pipeline
bound to the set's marker, and any layer may bind one.

## Pattern dialect

Patterns are `/`-separated and repository-relative. `**` is the only cross-segment operator (zero or more whole segments); within a segment
the PowerShell wildcards `*`, `?` and `[a-z]` apply, case-sensitively. Membership is include minus exclude, evaluated against
`git ls-files`.

## The shipped sets

- **The track sets.** A whole track's set (`pwsh`, `infrastructure`) names its track. Its include and exclude are derived from the track's
  members into `track-sets.yml` by `Build-TrackGlobSets`
  ([FDR-CD-GLOBS-TRACKSETDERIVED](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-tracksetderived)). The `pwsh` set is a
  loose fileset with a demonstrated use, since the `ci-pwsh` pipeline binds its marker, and it overlaps the derived module sets it spans,
  which is what the loose-fileset layer is for. The `infrastructure` set is the Bicep IaC tree, another loose fileset: `ci-infrastructure`
  verifies it and the `cd-*` pipelines deploy from it, and it overlaps the per-unit deployable sets.
- **`templates`.** The all-templates shared surface: every deployable template except its deployment configuration, meaning the
  configuration-root (shared-platform) files and the per-customer subfolders. The marker says that template code changed without firing on
  an individual deployment's configuration edit, which the per-unit sets carry.
- **The base units.** `template-azure-subscription-foundation` is the base deployable unit: the foundation template plus the shared Bicep
  modules, without any deployment configuration. It binds no pipeline and ships only through a configured unit that composes it, but it
  carries the template's verify blast-radius scope, and a change there re-keys every unit that composes it.
  `template-azure-subscription-discovery` is the landing-zone base unit, the discovery template without configuration. It composes the
  foundation base, which owns the shared Bicep modules, since a unit never owns another unit's files, and which discovery deploys onto.
  `template-azure-workload-expedition` is the workload base unit, composing the discovery base, the landing zone it lands in, and through it
  the foundation base and the modules. Neither binds a pipeline; both ship only through the configured units that compose them.
- **The configured units.** Per-customer deployable units
  ([DDR-TRACK-DEPLOYABLEUNIT](../../../../../drs/design/tracks.md#rule-ddr-track-deployableunit)) are the shared surface plus that
  customer's own configuration subfolder. The folder is the customer key, so the unit name is the exact folder name, and adding a customer
  is adding an entry here, never code. `shared` is the shared-platform unit: the configuration-root files (the non-customer deployment),
  deployed by `cd-shared`, with the same shape keyed by the root instead of a subfolder.
- **`markdown-scope`.** The markdown scan scope: exactly what `Test-Markdownlint` reads, every in-scope markdown file plus the scan's own
  config, since a scan's globset includes its configuration. The excludes mirror the scan's default negation globs. The protected-glob skip
  consumes it: a repeated local scan is skipped while this set's durable SHA is unchanged since the last green run in the session.
- **`repository`.** The whole repository: every tracked file under every named root (`pwsh/`, `infrastructure/`, `docs/`, `pipelines/`,
  `.github/`, `contracts/`, the root files, and any root added later). It is the protection identity for anything whose read set spans the
  repository
  ([ADR-REPO-PROTGLOB-INCLUDESOWNCONFIG](../../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-includesownconfig)): the
  managed-GUID and spelling scans, each of which reads a subset of it plus its own config, and the widened composite of a module that is
  unconstrained, carries integrity tests, or is an infra test unit. A covering superset is safe, since it can only cause a redundant run and
  never a wrong skip, and integrity tests hold each scan's subset relation. A repeated local run is skipped only while no tracked file
  anywhere has changed since its last green run in the session.
