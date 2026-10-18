# pwsh/Catzc.Base.Globs/configs/globs.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `globsets:`, written with `#`.

```text
The globset registry — THE single source of truth mapping every area-of-control onto its files under
version control (see [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)). Each set projects to native
vendor path filters (Get-GlobSetTrigger) that pipelines and workflows trigger on, and to a git-reflected
blast radius (Get-ChangedGlobSet); nothing is committed per set. Validated strictly on load by
Catzc.Base.Globs.GlobsConfig.

Every set declares its layer ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)): 'deployable-unit' (a
configurable unit that ships) or
'loose-fileset' (a cross-cutting check surface — a track's root concern, a scan scope, the whole repository
— that deliberately overlaps the boundaries it cuts across). The 'module' layer is derived from the folders
(and the internal .psm1 files), never declared, and carries its own 'module-leftovers' catch-all — derived
sets scope protection and blast radius
([ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7)). Within every layer but 'loose-fileset' no
two sets may select a common file on their OWN contribution — a unit never consumes another unit's files,
a module never another module's ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)); loose-filesets
overlap freely. 'compose' unions another declared set's effective members into this one (acyclic,
[ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)). 'pipeline' names the pipeline bound to this set's
marker — any layer may bind one.

Dialect: '/'-separated, repo-relative; '**' is the only cross-segment operator (zero or more whole
segments); within a segment, PowerShell wildcards ('*', '?', '[a-z]'), case-sensitive. Membership is
include minus exclude, evaluated against `git ls-files`.
```

## comment:2

Above `automation:`, written with `#`.

```text
The automation set (the pwsh track) — the module system under pwsh/. A loose-fileset
([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)):
a cross-cutting check surface with a demonstrated use (the ci-automation pipeline binds its marker). It
overlaps the derived module sets it spans, which is exactly what the loose-fileset layer is for.
```

## comment:3

Above `infrastructure:`, written with `#`.

```text
The infrastructure track — the Bicep IaC tree. A loose-fileset with a demonstrated use: ci-infrastructure
verifies it and the cd-* pipelines deploy from it; it overlaps the per-unit deployable sets below.
```

## comment:4

Above `templates:`, written with `#`.

```text
The all-templates shared surface: every deployable template EXCEPT its deployment configuration —
the configuration-root (shared-platform) files and the per-customer subfolders — so this marker says
"template code changed" without firing on an individual deployment's config edit (the per-unit sets
below carry those).
```

## comment:5

Above `template-azure-subscription-foundation:`, written with `#`.

```text
The base deployable unit ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)): the foundation template
plus the shared Bicep modules, WITHOUT
any deployment configuration (the root files and the customer subfolders). It binds no pipeline of its
own — it ships only through a configured unit that composes it (apex/nova/flux/shared) — but carries the
template's verify blast-radius scope, and a change here re-keys every unit that composes it.
```

## comment:6

Above `template-azure-subscription-discovery:`, written with `#`.

```text
The landing-zone base unit: the discovery template WITHOUT any deployment configuration. It composes
the foundation base, which owns the shared Bicep modules (a unit never owns another unit's files,
[ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)), and which discovery deploys onto. It
binds no pipeline; it ships only through the configured units that compose it.
```

## comment:7

Above `template-azure-workload-expedition:`, written with `#`.

```text
The workload base unit: the expedition template WITHOUT any deployment configuration. It composes the
discovery base, the landing zone it lands in (and through it the foundation base and the modules). It
binds no pipeline; it ships only through the configured units that compose it.
```

## comment:8

Above `nova:`, written with `#`.

```text
Per-customer deployable units
([ADR-DSGN-TRACK#5](/docs/adr/design/tracks.md#rule-adr-dsgn-track5)): the shared surface plus that customer's own
configuration subfolder — the folder IS the customer key, so the unit is the exact folder name.
Adding a customer is adding an entry here — config, never code.
```

## comment:9

Above `shared:`, written with `#`.

```text
The shared-platform unit — the configuration-ROOT files (the non-customer deployment), deployed by
cd-shared. The same shape as a customer unit, keyed by the root instead of a subfolder.
```

## comment:10

Above `markdown-scope:`, written with `#`.

```text
The markdown scan scope: exactly what Test-Markdownlint reads - every in-scope markdown file plus the
scan's own config (a scan's globset includes its configuration). The excludes mirror the scan's default
negation globs. Consumed by the protected-glob skip: a repeated local scan is skipped while this set's
durable SHA is unchanged since the last green run in the session.
```

## comment:11

Above `repository:`, written with `#`.

```text
The whole repository: every tracked file under every named root (pwsh/, infrastructure/, docs/,
pipelines/, .github/, contracts/, the root files, and any root added later). The protection identity for
anything whose read set spans the repository
([ADR-REPO-PROTGLOB#6](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob6)/8): the managed-GUID and spelling scans
(each reads a subset of it plus its own config, which it also contains), and the widened composite of a
module that is unconstrained, carries integrity tests, or is an infra test unit. A covering superset is
safe — it can only cause a redundant run, never a wrong skip — and integrity tests hold each scan's
subset relation. A repeated local run is skipped only while no tracked file anywhere has changed since
its last green run in the session.
```
