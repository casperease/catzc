---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
    kind: reference
    body_sha: "64c91c40f17f"
    adrs:
      - ADR-FLOW-CD-GLOBS#5
---

# automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The composite ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a hash-of-hashes fold over (1) the
module's own derived globset, (2) the
derived sets of its declared dependency closure from dependencies.yml (transitive; a group reference
permits any member, so it expands to all members), (3) the four reserved infra scopes (internal, vendor,
compiled, scriptanalyzer), and (4) the runner's own set (catzc-base-qualitygates — an edit to the harness
re-keys every module). Two fail-safe cases widen the fold with the declared whole-repository 'repository'
set (every tracked file under every named root): a module that is UNCONSTRAINED in dependencies.yml (its true dependency set is unknown), and a module
whose tests include the 'integrity' category (by definition they read the real repository beyond the
module). The dot-prefixed infra test units ('.internal', '.scriptanalyzer') key on the scope reserved for
them and are always widened. Per-set hashes are memoized in the caller-owned -HashCache, so one run hashes
each named set at most once.
```

## comment:2

Section `.PARAMETER Module` of the comment-based help.

```text
The unit's folder name under automation/ — a module ('Catzc.Base.Globs') or the infra test units
'.internal' / '.scriptanalyzer'.
```

## comment:3

Section `.PARAMETER HasIntegrityTests` of the comment-based help.

```text
Whether the unit's test files contain any 'integrity'-tagged test (from the run's discovery pass) — folds
in the repository-wide set.
```

## comment:4

Above `$universe = @{}`.

```text
The tracked-file universe, fetched once for this call on the first set that is not memoized yet (a holder,
because the closure below runs in its own scope), then shared by every set it hashes.
```

## comment:5

Above `$sets = @(Get-ModuleGlobSet -Name $setName) | Sort-Object Name`.

```text
A module name resolves to its live/tests aspect sets
([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)); a reserved/single set to
one. Fold the aspect hashes (name|hash, ordinal by name) so the constituent hash covers the
module's whole content — identical protection semantics to the pre-aspect whole-module set.
```

## comment:6

Above `$dependencies = Get-Config -Config dependencies`.

```text
declared dependency closure from dependencies.yml (DependenciesConfig: groups: <g> -> ModuleGroup
with members <member> -> [deps]; modules: <m> -> [group-or-module]). A group reference permits ANY
member, so it expands to all.
```

## comment:7

Above `$widen = $true`.

```text
unconstrained (dependencies.yml: "A module NOT listed here is unconstrained") — its true
dependency set is unknown, so widen to the repository-wide set: skip less, never wrongly.
```

## comment:8

Above `$names = [string[]]$constituents`.

```text
---- fold: name|hash lines, ordinal by name — the
[ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5) recipe over set hashes ----
```
