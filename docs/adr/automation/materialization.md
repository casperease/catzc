# ADR: Materialization — when a knowledge resource comes into being and how long it holds

## Rules: ADR-AUTO-MATERIAL

### Rule ADR-AUTO-MATERIAL-MATERIALIZATION

**Materialization** names when a knowledge resource comes into being and how long it holds, and it takes one of two values. An on-demand
resource is made when asked, a scan, a computation or a resolved config, and holds until the call ends or the session cache entry that holds
it is gone. A commit resource is made at commit, keyed by the scoped sha of its inputs, and never changes: the key is its identity.

- [The axis](#the-axis)

### Rule ADR-AUTO-MATERIAL-RESOLVEDFROMCONTEXT

A resource whose kind declares no explicit value resolves its materialization from context into one of the two values, the way every setting
resolves ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): a clean tree at a known
scoped sha with a commit copy present uses the copy; anything else computes on-demand. The resolved value is never stored and never
displayed; a display shows an explicitly declared value only.

- [How the default resolves](#how-the-default-resolves)

### Rule ADR-AUTO-MATERIAL-SCOPEDSHACOMMITKEY

The commit key of a resource is the scoped sha of its own globset, the patterns of `globs.yml` that select its inputs
([ADR-DSGN-TRACK-DEPLOYABLEUNIT](../design/tracks.md#rule-adr-dsgn-track-deployableunit)), never the sha of the whole repository. A config
variant of the globset is a different resource with its own key.

- [The commit key](#the-commit-key)

### Rule ADR-AUTO-MATERIAL-DECLAREDPERKIND

Materialization is declared per resource kind, in a config entry with one default declared once on its config type
([PDR-CONFIG-DEFAULTDECLAREDONCE](../principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)). An instance of the
kind changes it only by an explicit value of its own, and a resource that costs milliseconds to compute declares on-demand and never earns a
commit copy.

- [Declared per kind](#declared-per-kind)

### Rule ADR-AUTO-MATERIAL-DIRTYTREECOMPUTES

A commit resource read on a dirty tree, or at a sha that has no commit copy, computes on-demand and announces that once, on the information
stream, naming the resource and the reason. It never serves a copy whose key does not match the tree, and it never falls back in silence.

- [The loud fallback](#the-loud-fallback)

### Rule ADR-AUTO-MATERIAL-GUARDSDECLAREONDEMAND

A guard declares on-demand explicitly. Its verdict is a control, decided from the state in front of it on every call, so the default never
resolves a guard to commit and no guard kind declares commit.

- [Guards are controls](#guards-are-controls)

### Rule ADR-AUTO-MATERIAL-GENERATEDFILESARECOMMITRESOURCES

A generated tracked file and the analyzer's result cache are commit resources, each keyed by its globset, and `body_sha` in a generated
file's head is that key's visible form. Every other resource is on-demand unless its kind declares otherwise.

- [The kinds that are commit resources](#the-kinds-that-are-commit-resources)

## Context

Most information in catzc exists only when someone asks for it: a repository scan, a derived listing, a resolved config. Tools cache some of
it inside a session ([caching](caching.md)). Some information can instead be frozen with a commit and never change, because its inputs are
tracked files whose content the commit fixes. A reader who meets a resource needs to know which of the two it is: whether it is probably
there already, warm, or has to be made, cold, and whether a change to the tree invalidates it or leaves it untouched. Materialization is the
one word for that property, so no resource kind has to invent its own cache story.

The word is the database term: a plain view is computed per query, and the other kind of view is stored. It is chosen over existence, which
says whether a resource is there and not when or for how long; over residency, which says where it sits and not when; and over persistence,
which says whether a value survives a session and not how it is keyed.

### The axis

`Two values, and a default that resolves to one of them`

| Value     | Comes into being                                 | Holds until                               | Cache expectation               |
| --------- | ------------------------------------------------ | ----------------------------------------- | ------------------------------- |
| on-demand | when asked: a scan, a computation                | the call ends, or the session cache entry | cold; a tool may have cached it |
| commit    | at commit, keyed by the scoped sha of its inputs | never changes: the key is its identity    | warm; invalidation is free      |

There is no third value. "Not declared" is not a peer of the two but the instruction to resolve, the same shape as the one resolution order
of a setting and as a guard that determines its subject from the ambient context and takes an explicit value only as an override.

### How the default resolves

`Resolved from the tree in front of the call, never written down`

A clean tree at a known scoped sha with a commit copy present uses the copy. A dirty tree, or a sha with no copy, computes on-demand. A
resource that is cheap to compute never earns a commit copy, because a copy's only value is the compute it saves. The resolved value is a
fact about one call and one tree, so storing it would record a decision that the next commit makes wrong, and displaying it would show a
default the way no other default is shown.

### The commit key

`The resource's own inputs, not the whole repository`

A key over the whole repository's commit sha would invalidate every commit resource on every commit, which makes the copy worth nothing in a
repository where most commits touch one unit. The scoped sha of the resource's globset changes only when one of its inputs changes, so an
unrelated commit leaves the copy valid and the saving stands. The globset is the same selection the deployable-units and the pipelines are
built from, which keeps one notion of "the files of this thing" in the repository, and a config variant of a globset keys a resource of its
own.

### Declared per kind

`One config entry per kind, one default, an instance deviates only explicitly`

Each kind of work has one mechanism in code and each instance of it is a registry entry
([configure-not-program](../principles/configure-not-program.md)), and materialization follows: the kind declares it, with its default
declared once on the config type, and a call never decides it in code. An instance that needs another value says so in its own entry, so the
deviation is visible as a line in a config rather than a branch in a function.

### The loud fallback

`A copy that does not match the tree is never served, and the fallback is said once`

A commit copy is correct exactly for the sha it is keyed by. On a dirty tree the tree in front of the call is not that sha, so the copy may
be stale, and serving it would make a check pass on content that is not there. Computing on-demand keeps the answer honest; announcing it
once keeps the person informed that the call was slower and why, without repeating the line on every read of the same session.

### Guards are controls

`A verdict is decided from the state in front of it, every time`

The devbox is also a regulated operations machine: a guard is a control, and a control whose verdict is remembered across a session or a
commit is a control that can be wrong about the present. A guard therefore declares on-demand as a property of its kind, and the default
never resolves a guard to commit, however cheap its copy would be. Materialization is partly a property of the kind, not only of the cost.

### The kinds that are commit resources

`Generated tracked files and the analyzer cache; everything else on-demand`

A generated tracked file is composed whole from tracked inputs and committed beside them, so its content is fixed by the commit, and
`body_sha` in its head is the visible form of its key: the check that compares the stamp with the body is the check that the copy matches
the tree. The analyzer's result cache is keyed the same way, by the stamp of its inputs. Every other resource is on-demand, and a kind joins
the commit set by declaring it, with its key and its check, never by a tool deciding to keep a copy.

### Fit with caching

The session cache of [caching](caching.md) and a commit copy are the same idea at two durations. A cached value is read-only to its callers
([ADR-AUTO-CACHE-READONLYVALUES](caching.md#rule-adr-auto-cache-readonlyvalues)), and so is a commit copy. The importer is the only
invalidation of a session cache ([ADR-AUTO-CACHE-IMPORTERINVALIDATES](caching.md#rule-adr-auto-cache-importerinvalidates)), and git state
that changes inside a session is keyed on its own content
([ADR-AUTO-CACHE-SESSIONCHANGEDGITSTATE](caching.md#rule-adr-auto-cache-sessionchangedgitstate)); a commit resource is that content key made
durable, so nothing ever invalidates it. One living version ([one-living-version](../principles/one-living-version.md)) holds per key: there
is one shape of each resource, never an on-demand shape and a commit shape of the same data side by side.

## Decision

Name the axis once, resolve the default from the tree, key a commit copy by the resource's own globset, declare it per kind, fall back
loudly, hold guards on-demand, and make generated tracked files and the analyzer cache the commit resources.

### How this is enforced

- **`Test-GeneratedFiles`** (`pwsh/Catzc.Base.QualityGates`) — compares every generated tracked file's `body_sha` with its body, the check
  that a commit copy matches the tree (ADR-AUTO-MATERIAL-GENERATEDFILESARECOMMITRESOURCES).
- **`Test-Formatting`'s cache stamp tests** (`pwsh/Catzc.Base.QualityGates/tests`) — prove that every declared input of the analyzer's
  result cache invalidates it (ADR-AUTO-MATERIAL-SCOPEDSHACOMMITKEY, ADR-AUTO-MATERIAL-GENERATEDFILESARECOMMITRESOURCES).
- **Code review** — a kind that keeps a copy across sessions without declaring commit, a stored or displayed resolved value, a silent
  fallback, or a guard that remembers a verdict is a finding against the rule it breaks.

## Consequences

- Every kind that keeps a copy says so in one place, and a reader learns from the kind whether a resource is warm or cold.
- A commit copy survives unrelated commits, so the saving of the copy is real in a repository of many units.
- A dirty tree costs the compute and says so; nobody reads a stale copy without being told.
- Guards stay honest at the cost of never being cached.

## Alternatives considered

1. **Three peer values with `auto` stored** — rejected: a stored resolved value is a default written down, which the next commit makes wrong
   and which every display would then show.
2. **The whole-repository commit sha as the key** — rejected: it invalidates every copy on every commit, so a copy saves nothing in a mono
   repository.
3. **A per-call parameter deciding materialization** — rejected: it programs per instance what one config entry per kind declares, and it
   scatters the decision across call sites.
4. **A silent fallback on a dirty tree** — rejected: a check that got slower without saying why is indistinguishable from a check that read
   a stale copy.
