# ADR: Path representation — relative across boundaries, absolute only at the bind

## Rules: ADR-PATH

### Rule ADR-PATH:1

A path value is in one of two forms, never a third. **Communication form** is repository-root-relative (or output-root-relative),
`/`-separated, and fully normalized — no `.` or `..` segments, no leading `./`, no backslashes, no duplicate separators. **Binding form** is
a normalized absolute path that exists only transiently at the point of use. A hybrid such as `{root}/./sub` is neither and is always a bug.

- [The two forms](#the-two-forms)

### Rule ADR-PATH:2

A path that is stored or transported is in communication form: returned to a caller, held on a record, or written into an artifact or
source-controlled config. The canonical representation a type holds and a record serializes is relative. `ConvertTo-RepoRelativePath`
produces this form. How a path is _rendered_ to a log or console is a separate, per-channel decision (ADR-PATH:8), not a property of how it
is stored.

- [The two forms](#the-two-forms)
- [The boundary, concretely](#the-boundary-concretely)

### Rule ADR-PATH:3

A path is in binding form only at the point of binding — the line that performs a filesystem read or write, or hands the path to an external
tool. Resolve to absolute immediately before that side effect with `Resolve-RepoPath`; never store, return, or log the absolute result.

- [The point of binding](#the-point-of-binding)

### Rule ADR-PATH:4

Normalization is mandatory and centralized. Cross the boundary through `ConvertTo-RepoRelativePath` and `Resolve-RepoPath` — the only
sanctioned crossers. Do not hand-build a communicated path with `Join-Path $env:RepositoryRoot …`, and do not normalize separators ad hoc
with `-replace '\\','/'`; both skip the normalization the converters guarantee and let a `.\` or a backslash leak downstream.

- [Why centralize on two functions](#why-centralize-on-two-functions)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PATH:5

A path under neither the output root nor the repository root — the system temp directory, an unrelated absolute path, a foreign drive —
degrades to a normalized absolute path, never to a hybrid. `ConvertTo-RepoRelativePath` does exactly this: a path under the output root
comes back `out/`-anchored (ADR-PATH:9), a path under the repo root comes back repo-relative, a path under neither comes back absolute.

- [Degradation](#degradation)

### Rule ADR-PATH:6

Source-controlled config and long-lived records store communication-form paths only. A generated production artifact may embed absolute
paths, because it is consumed at binding time on the machine that runs it — but the source that generates it holds relative paths.

- [Source is relative; the bound artifact may be absolute](#source-is-relative-the-bound-artifact-may-be-absolute)

### Rule ADR-PATH:7

Name a path by its form. `ConvertTo-RepoRelativePath` and `Resolve-RepoPath` are the boundary crossers; `Get-RepositoryFile` /
`Get-RepositoryFolder` are binding helpers (relative in, normalized absolute out). A record property that carries a path is named for the
form it holds (`RelativePath`, `*_file`) and the type documents that form, so a consumer knows whether to bind it before use.

- [The point of binding](#the-point-of-binding)

### Rule ADR-PATH:8

Logging, console, and other output channels are output _formats_: the path form rendered to each is a deliberate choice, not a fixed rule. A
path-bearing type converts once in its constructor and exposes both forms, so a channel renders the relative form (the default — portable
across machines, greppable, and correlatable for tracking) or the absolute form (only when that channel's consumer binds the path) without
re-deriving it. The stored field stays relative regardless of what a channel renders.

- [Logging is an output format](#logging-is-an-output-format)

### Rule ADR-PATH:9

`out/` is a reserved anchor, not an ordinary segment. A path under the output root (`Get-OutputRoot`) takes the form `out/<remainder>`, and
`Resolve-RepoPath` re-anchors that `out/` sentinel against `Get-OutputRoot` — not the repository root. Because the output root is
context-dependent (`{root}/out` on a devbox, the external staging directory in a pipeline), the same stored `out/...` string resolves to the
right place in either context, so an output artifact stays portable across the build→deploy boundary instead of degrading to a
machine-specific absolute.

- [The output anchor](#the-output-anchor)

### Rule ADR-PATH:10

A published artifact that crosses a stage boundary — a build stage produces it, a later deploy stage (often a different agent) downloads and
consumes it — is an immutable object that serializes **both** forms and is **created by the controlled type** (`ArtifactRef`). Its relative
form is **artifact-relative** (e.g. `main.json`), anchored on the **artifact root**, not `out/`: the publish step renames the artifact and
strips the output-root prefix, so the artifact root — the producer's `output_folder`, the consumer's downloaded folder — is the only anchor
that survives the boundary. It also carries an absolute (resolved in the producing context, for audit). The type's factory takes the raw
path plus the artifact root, converts once, and materializes both; the consumer at the other end re-resolves the relative against **its
own** artifact root and verifies existence (`ResolveAt` / `ExistsAt`) before binding — that check is a method on the type, not scattered
call-site code. (The `out/` sentinel of `Resolve-RepoPath` remains the within-stage output anchor; it is simply not the cross-stage anchor.)

- [The output anchor](#the-output-anchor)

## Context

A path moves through automation code in two very different roles, and conflating them is a recurring source of bugs. In one role a path is
_data_ — a value a function returns, stores in a record, writes into a config a human reads, or prints in a log line. In the other it is an
_address_ — the argument to `Get-Content`, `Import-Module`, or an `az` invocation that is about to touch the filesystem.

As data, an absolute path is wrong in three ways: it is machine-specific (it embeds `C:\Users\someone\…` or `/home/vsts/work/1/s/…`, so it
cannot be compared, committed, or moved between a workstation and a CI agent), it is noisy in logs, and it is fragile — built by `Join-Path`
from a raw caller argument, it carries whatever `.\`, `..`, or backslash the caller passed straight through. As an address, a relative path
is wrong the moment resolution depends on `$PWD` (see [never-depend-on-pwd](never-depend-on-pwd.md)), so binding must resolve against a
known anchor, not the current directory.

The fix is to fix the _form_ a path takes at each boundary, rather than leaving it to each function author. This ADR complements
[never-depend-on-pwd](never-depend-on-pwd.md) (resolve against `$env:RepositoryRoot`, never `$PWD`),
[cross-platform](cross-platform.md#rule-adr-xplat1) (`Join-Path` and `[IO.Path]::GetFullPath`, forward slashes), and
[dedicated-output-directory](../repository/dedicated-output-directory.md) (the `out/` root, whose paths take the same relative form).

### The two forms

**Communication form** — repository-root-relative or output-root-relative, `/`-separated, normalized. This is the form a path takes whenever
it is _data_: a return value, a stored field, a logged string. It is portable (identical on every machine), comparable (two relative paths
compare with `-eq` without `GetFullPath` gymnastics), and committable (it can live in a checked-in config or a golden file). It is produced
by `ConvertTo-RepoRelativePath`, which runs `[IO.Path]::GetFullPath` to collapse `.`/`..`, relativizes against the repository root, and
replaces backslashes with forward slashes.

**Binding form** — a normalized absolute path, resolved against the repository root, that exists only on the line that uses it. It is
produced by `Resolve-RepoPath` (or the `Get-RepositoryFile` / `Get-RepositoryFolder` binding helpers), which join onto `Get-RepositoryRoot`
— not `$PWD` — and `GetFullPath` the result. It is never assigned to a field, returned across a boundary, or logged; the moment it would be,
the value belongs in communication form instead.

### The boundary, concretely

A path crosses a boundary when it leaves the function that produced it as anything other than a direct argument to a side effect. The three
crossings, all requiring communication form:

- **Return value.** A function that returns a path returns it relative. A caller that needs to bind it calls `Resolve-RepoPath` at the point
  of use.
- **Stored field.** A path written into a `DictionaryRecord`, a deployment-context artifact, or a checked-in config is relative.
  `BicepArtifacts` stores its `folder` / `template_file` / `parameters_file` / `prepost_module` this way.
- **Output rendering.** A `Write-*` message, a `throw` string, or a returned summary is an output channel — see
  [logging is an output format](#logging-is-an-output-format). It renders the relative form by default (portable, quiet, correlatable),
  drawing it from a value that also holds the absolute form for the channels that bind. This is a per-channel choice, not a storage
  property.

### The point of binding

Binding is the one place an absolute path is correct, and it is always local and transient:

```powershell
# stored relative (communication form) on the record …
Import-Module (Resolve-RepoPath $ctx.artifacts.prepost_module) -Force   # … resolved to absolute only here
```

A path handed to an external tool through `Invoke-Executable` does not even need the resolve step: those tools run from the repository root
(the default working directory), so a repo-relative path resolves there on its own. `Resolve-RepoPath` is for the PowerShell-side consumers
— `Import-Module`, `Get-Content`, `Test-Path` — that resolve against `$PWD` unless given an absolute path.

### Why centralize on two functions

Every path that crosses a boundary going out goes through `ConvertTo-RepoRelativePath`, and every path that binds coming back goes through
`Resolve-RepoPath`. The pair round-trips: relativizing a path under the root and resolving it again yields the original absolute path.
Centralizing on the two functions is what makes normalization a guarantee rather than a hope — a hand-built
`Join-Path $env:RepositoryRoot $Path` preserves a caller's `.\` and produces `{root}/./sub`, and a hand-rolled `-replace '\\','/'` fixes
separators but not `..` segments. The converters fix both, in one place, so the rule cannot be half-applied.

### Degradation

Not every path has a repository- or output-relative form. A scratch file in the system temp directory, or any path on an unrelated root,
lives under neither anchor. For these `ConvertTo-RepoRelativePath` returns a normalized absolute path — the honest answer, since no relative
form exists — and `Resolve-RepoPath` passes an already-absolute path through unchanged. The degraded value is still normalized; it is never
a hybrid.

### The output anchor

`out` is the reserved output anchor, and it is the one segment that does **not** mean "a folder under the repository root." `Get-OutputRoot`
is `{root}/out` on a devbox but the external `BUILD_ARTIFACTSTAGINGDIRECTORY` in a pipeline, so a path under the output root has a
context-dependent location. Anchoring it as the `out/` sentinel — and resolving that sentinel through `Get-OutputRoot` rather than the
repository root — is what keeps an output artifact portable: `out/template/sample/main.json` resolves to
`{root}/out/template/sample/main.json` locally and `{staging}/template/sample/main.json` in a pipeline, from the one stored string.
Anchoring it as a plain repo-relative path would resolve to `{root}/out/...` everywhere and point at nothing in the pipeline.

That is the **within-stage** story — the `out/` sentinel keeps an output path portable between a devbox and a pipeline. When an artifact
crosses a **stage boundary** the anchor changes again: the build stage produces it and a later deploy stage — often a different agent —
downloads and consumes it, and the publish step renames the artifact, stripping the `out/template/` prefix. So the producer's output root
does not survive the boundary and the `out/` sentinel is no longer the shared anchor; the **artifact root** is (the producer's
`output_folder`, the consumer's downloaded folder). The cross-stage descriptor is therefore an immutable `ArtifactRef` carrying **both**
forms: an **artifact-relative** relative (e.g. `main.json`, which the consumer re-resolves against **its own** artifact root) and the
producing-context absolute (for audit). The type is the factory — it takes the raw path and the artifact root, converts once, and
materializes both — and it exposes the consumer's verification (`ResolveAt`, then `ExistsAt` to assert the file exists) as a method, so the
"check at the other end" lives on the type rather than in every consumer. `RepoRelativePath` stays repo-root-pure (source paths,
relative-only); the cross-stage artifact is the separate, dual-form case.

### Source-is-relative, the bound artifact may be absolute

The rule governs _source_ and _long-lived data_. A generated production artifact is different: a bound bicep parameter JSON is produced for,
and consumed by, the deployment on a specific machine, so it may contain absolute paths. The distinction is provenance — the checked-in
template, its `options.yml`, and the deployment-context record that drives generation hold relative paths; the one-shot artifact those
produce at bind time may not. Relative is the rule for everything a human commits or a record carries.

### Logging is an output format

A log line, a console write, a thrown message, and a returned summary are output channels, not storage. Treating them as a format makes the
rendered path form a deliberate decision rather than an accident. The value being rendered is a path that knows both its forms, so the
channel picks: tracking and correlation want the relative form — it is identical across machines, so log lines from a workstation and a CI
agent line up, and it greps cleanly — so relative is the default; a channel whose consumer binds the path (a command a human will copy and
run locally) may render absolute. A path-bearing type carries this by converting once in its constructor and exposing both forms, so the
rendering choice never costs a re-derivation and the stored field stays relative either way. This is why the rule is _not_ "wrap every log
call in `ConvertTo-RepoRelativePath`": the path is a typed value with both forms, and each channel renders the one it needs.

## Decision

Paths are communicated relative and bound absolute. `ConvertTo-RepoRelativePath` and `Resolve-RepoPath` (both in `Catzc.Base.Repository`)
are the only sanctioned boundary crossers; `Get-RepositoryFile` and `Get-RepositoryFolder` are binding helpers that normalize. No function
hand-builds a communicated path from `$env:RepositoryRoot` or normalizes separators by hand.

### How this is enforced

- **`ConvertTo-RepoRelativePath` / `Resolve-RepoPath`** carry the normalization centrally, so any code that crosses the boundary through
  them cannot leak a `.\`, a `..`, or a backslash.

- **`Get-RepositoryFile` / `Get-RepositoryFolder`** delegate to `Resolve-RepoPath`, so a binding helper returns a normalized absolute path
  even when the caller passes `.\sub` or `a/../b`.

- **`RepoRelativePath` and `ArtifactRef`** (`Catzc.Base.Objects`) make the form a construction-time property: a record that holds one of
  these cannot carry a mis-formed or wrong-anchor path, and the cross-stage artifact's two forms and its consumer-side check are produced
  and owned by the type. This is the primary, poka-yoke enforcement — correctness by construction, not by a linter pass.

- **Code review** against this ADR covers what a linter cannot. A custom PSScriptAnalyzer rule is _not_ used here: the only
  statically-decidable signatures — a raw `$env:RepositoryRoot` read, a `Join-Path $env:RepositoryRoot …`, an ad-hoc `\`→`/` replace — are
  each used legitimately in scores of binding sites, parameter defaults, and tests, so a blanket rule is overwhelmingly false-positive; and
  the property that actually distinguishes a leak (a path _communicated_ rather than _bound_) is not expressible as an AST pattern.
  Enforcement therefore lives in the types above and in review, not in a noisy rule.

## Consequences

- Stored and logged paths are portable: identical on a workstation and a CI agent, committable into a config or golden file, comparable
  without `GetFullPath`.
- The `{root}/./sub` class of bug disappears, because the binding helpers and converters normalize and nothing hand-builds a communicated
  path.
- Resolution is deterministic: binding resolves against the repository root, never `$PWD`, so a function composes the same wherever the
  shell is standing.
- There is one obvious place to look when a path is wrong — the boundary crosser that produced it — and one pair of functions to reason
  about instead of every author's bespoke `Join-Path`.
- The cost is a small, explicit conversion at each boundary: relativize on the way out, resolve on the way in. The pair round-trips, so the
  cost is mechanical, not a source of new error.
