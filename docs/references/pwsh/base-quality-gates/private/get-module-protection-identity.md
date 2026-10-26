# pwsh/Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1

Composes a module's protection identity: the durable SHA of everything its test results depend on. A unit whose identity is unchanged since
its last green run is skipped.

## help

### synopsis

Composes a module's protection identity — the durable SHA of everything its test results depend on.

### description

The composite ([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)): a hash-of-hashes fold over (1) the module's own derived
globset, (2) the derived sets of its declared dependency closure from dependencies.yml (transitive; a group reference permits any member, so
it expands to all members), (3) the four reserved infra scopes (internal, vendor, compiled, scriptanalyzer), and (4) the runner's own set
(catzc-base-quality-gates — an edit to the harness re-keys every module). Two fail-safe cases widen the fold with the declared
whole-repository 'repository' set (every tracked file under every named root): a module that is UNCONSTRAINED in dependencies.yml (its true
dependency set is unknown), and a module whose tests include the 'integrity' category (by definition they read the real repository beyond
the module). The dot-prefixed infra test units ('.internal', '.scriptanalyzer') key on the scope reserved for them and are always widened.
Per-set hashes are memoized in the caller-owned -HashCache, so one run hashes each named set at most once.

### parameter `Module`

The unit's folder name under pwsh/ — a module ('Catzc.Base.Globs') or the infra test units '.internal' / '.scriptanalyzer'.

### parameter `HasIntegrityTests`

Whether the unit's test files contain any 'integrity'-tagged test (from the run's discovery pass) — folds in the repository-wide set.

### parameter `OutsideModulesFolder`

Whether the unit is a module of another language track running its own tests: it has no derived globset of its own, so its read set is the
repository and the fold widens to the repository-wide set.

### parameter `HashCache`

A caller-owned hashtable memoizing set-name -> durable SHA across one Test-Automation run.

## Fold

The identity is a hash-of-hashes. The constituent sets are listed as `name|hash` lines, ordinal by name, and folded by the durable-sha
recipe over set hashes ([FDR-GLOBS-DURABLESHAIDENTITY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity)).

## Sets and the universe

The tracked-file universe is fetched once per call, on the first set that is not memoized yet, and shared by every set the call hashes. It
lives in a holder because the closure that hashes a set runs in its own scope.

A module name resolves to its live and tests aspect sets ([DDR-ASPECT](../../../../drs/design/module-aspects.md)), and a reserved set
resolves to one. The aspect hashes are folded as `name|hash` lines, ordinal by name, so the constituent hash covers the module's whole
content.

## Dependency closure

The declared closure comes from dependencies.yml. A group holds members, each with its dependencies, and a module lists groups or modules. A
group reference permits any member, so it expands to all members.

## Widening

Two cases widen the fold with the whole-repository set, so a check skips less and never wrongly.

- A module that dependencies.yml does not list is unconstrained. Its true dependency set is unknown.
- A module of another language track that runs its own tests has no derived globset of its own, so its read set is the repository.
