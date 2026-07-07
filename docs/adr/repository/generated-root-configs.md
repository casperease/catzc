# Generated root configs — every managed root file from one in-repo source of truth

## Rules: ADR-ROOTCFG

### Rule ADR-ROOTCFG:1

An opted-in repository-root config file is **fully managed by the source-of-truth automation**: it is materialised from exactly one in-repo
source of truth — a `source` file (an authored config copied out, or linked out under `copyAsLink` — ADR-ROOTCFG:7) or a `generator`
function (e.g. `New-Importer`). Corrections go to the source: a reproduced copy is a rendering and is never hand-edited; a link target IS
the source, so an edit through either path lands in the one authored file.

- [Decision](#decision)

### Rule ADR-ROOTCFG:2

The registry is `automation/Catzc.Base.RootConfig/configs/rootconfig.yml` — validated by the `RootConfigFiles` type, materialised by
`Build-RootConfig`, the single writer. **Opt-out is the default**: an entry (or a root file) not opted in stays hand-authored and committed;
`optIn: true` is the explicit takeover switch. The target-to-source pairing is not restated anywhere else.

- [Decision](#decision)

### Rule ADR-ROOTCFG:3

Per entry, the `committed` boolean (default false) decides git membership and nothing else. `committed: false` → the target is a derived,
gitignored artifact, materialised on import like the generated module manifests. `committed: true` → the target stays tracked because git or
the bootstrap reads it **before the importer runs** (`importer.ps1`), while the automation still owns its content — a source change surfaces
as a reviewable diff. The difference between the two is one boolean, not two systems.

- [One system, one boolean](#one-system-one-boolean)

### Rule ADR-ROOTCFG:4

Generation is idempotent and runs on every import (the importer tail). All content writes go through the one shared primitive
`Write-FileIfChanged` (`Catzc.Base.Files`): canonical output (UTF-8 no BOM, LF, one trailing newline), an EOL-insensitive compare, write
only on a real content change — so a clean tree is a fast no-op and a CRLF/LF flip never forces a rewrite. A changed write is
delete-then-write, never in-place, so it can never write through a linked target into a source of truth. Link targets are materialised by
`Set-FileLink` (ADR-ROOTCFG:7) instead of a content write.

- [Always current, at no steady-state cost](#always-current-at-no-steady-state-cost)

### Rule ADR-ROOTCFG:5

A non-link `source` copy-in carries a leading generated-file header in the target's comment style (`comment: hash` for `#`-trivia formats;
`none` for formats with no comment syntax, e.g. JSON) naming the source. A `generator` owns its whole output — header included — and takes
no `comment`. The header is strictly a leading block: config formats have no portable in-body anchor. A `copyAsLink` entry carries no header
at all — nothing is generated, and where a format wants a managed-file marker it is authored inside the source itself.

- [Decision](#decision)

### Rule ADR-ROOTCFG:6

The registry, `.gitignore`, and git's tracked set must agree, and an integrity test asserts it: every opted-in `committed: false` target is
matched by an ignore rule and untracked; every `committed: true` target is tracked and not ignored; a generator target matches its
generator's output (the drift check). The same gate covers the link mechanism both ways: every `copyAsLink` target is an effective link to
its source from the running OS, and no other managed target is a link.

- [The integrity gate](#the-integrity-gate)

### Rule ADR-ROOTCFG:7

A `copyAsLink: true` entry is materialised as a **filesystem link** to its source instead of a reproduced copy: the root file IS the
authored source, so drift is impossible by construction and no generated content exists to compose or compare. Three constraints, validated
by the `RootConfigFile` type: it requires `source` (a generator renders content and has no single file to link to), requires
`committed: false` (a tracked target must be a real file — git would commit a link object, which Windows checkouts materialise unreliably,
and committed targets are read before the importer can heal anything), and forbids a declared `comment` (a link carries no generated content
to head). `Set-FileLink` (`Catzc.Base.Files`) is the single mechanism owner: a relative symbolic link where the OS permits it, a hard link
on Windows without the symlink privilege — and a throw when neither works, never a silent content copy, which would reintroduce exactly the
drift the link removes. The link is verified from the running OS and healed at the importer boundary on every load; a hard-link target
orphaned by a git rewrite of its source holds stale bytes until the next import re-links it — the standing "re-run the importer after
changing files on disk" contract.

- [Copy-as-link: the target is the source](#copy-as-link-the-target-is-the-source)

## Context

The repository root carries configuration files for git, editors, and quality-gate tools. Kept by hand, each is its own little source of
truth with its own drift risk, and the tool-specific quirks (a `.psd1` that must be a literal hashtable, a JSON manifest with no comment
syntax) get re-solved ad hoc. "Root" names the ownership — one source of truth under `automation/`, one writer — not a path constraint: the
managed set covers the repository root and the `.vscode/` editor files (settings, extension recommendations, launch profiles, and the
preview CSS), all `committed: false`, so the editor greys them and a fresh clone materialises them on its first import — the same contract
as the generated cspell dictionaries ([dedicated-output-directory](dedicated-output-directory.md#rule-adr-outdir8)). The repository already
treats other per-folder derived files as generated, gitignored artifacts — the module manifests and the README links
([generated-readmes](generated-readmes.md)) — and already generated one root file each in two one-off ways: the root analyzer settings (a
bespoke builder) and `importer.ps1` (`New-Importer` plus a drift test). A root config file is the same pattern; what was missing was one
registry and one writer.

## Decision

Every opted-in root config file is materialised by `Build-RootConfig` (module `Catzc.Base.RootConfig`) from the single source of truth its
`rootconfig.yml` entry names: a `source` file copied out with a generated-file header — or linked out under `copyAsLink` — or a `generator`
function whose rendered output is the whole file. The registry entry carries two booleans — `optIn` (is the file managed at all; opt-out is
the default) and `committed` (is the managed target tracked in git) — plus the `copyAsLink` mechanism flag for source-backed, gitignored
targets, and the importer tail keeps every opted-in target current on every load.

### One system, one boolean

Some root files are read before the importer can possibly have produced them: `importer.ps1` is the load entry point itself, and git reads
`.gitignore`/`.gitattributes` at checkout. Those files cannot be gitignored copy-ins — but they can still be fully managed, because
"managed" means "reproduced from one in-repo source of truth", not "absent from git". `committed: true` expresses exactly that: same
registry, same writer, same drift guarantee; the only difference is that the target stays tracked and a regeneration shows up as a normal
diff to review and commit. This keeps the model honest — a copy-in and `importer.ps1` differ by one boolean, not by which system owns them.

### Copy-as-link: the target is the source

Reproducing content is the honest form for a generator (there is no single file to point at) and for a target that must be a real tracked
file. For a source-backed, gitignored target, a link is the stronger form: the root path and the authored source are **one file**, so there
is no copy to drift, no injected header to explain, and an edit through the root path lands in the source of truth — which is the intent,
not a hazard. `Set-FileLink` owns the mechanism (ADR-ROOTCFG:7): it verifies an existing artifact as a symbolic link resolving to the source
or a hard link with identical bytes, and deletes-and-recreates anything else — including a plain file whose content happens to match,
because content equality is not the contract; being the same file is.

Two properties keep the link form honest across environments:

- **Per-OS healing at the importer boundary.** The artifact a Windows session creates (typically a hard link — no privilege needed) and the
  one a Linux session creates (a relative symbolic link) are both verified _from the running OS_ by the importer tail on every load, and an
  artifact the current OS cannot follow is recreated with that OS's best mechanism. This is the same session-boundary contract as the caches
  ([caching](../automation/caching.md#rule-adr-cache6)): each session heals its own view when it starts.
- **No silent degradation.** When neither link mechanism works, `Set-FileLink` throws. A content-copy fallback would quietly reintroduce the
  drift the link exists to remove, behind a registry entry that claims otherwise.

The accepted caveat is the hard-link orphan: a git checkout or pull replaces a source file with a new one, and a hard-linked root target
keeps the old bytes until the next import re-links it. That window is bounded by the standing devbox contract — re-run the importer after
changing files on disk — and CI always starts from a fresh import.

The reverse transition is guarded twice. `Write-FileIfChanged`'s delete-then-write means a content write can never tunnel through a link
into a source (ADR-ROOTCFG:4), and `Build-RootConfig`'s copy branch treats a target that is currently a link as stale regardless of content
equality — a `comment: none` entry composes bytes identical to its source, which a content compare alone would read through the link and
call current, leaving the mechanism disagreeing with the registry. The inverse integrity assertion (ADR-ROOTCFG:6) is the backstop.

### Always current, at no steady-state cost

Because the targets are cheap to reproduce and must never go stale, the importer regenerates them on every load, exactly like the README
links ([generated-readmes](generated-readmes.md)). This is safe only because generation is idempotent: `Write-FileIfChanged` canonicalises,
compares ignoring line endings, and writes only on a real change (delete-then-write, so the changed write always yields a fresh, independent
file); `Set-FileLink` answers "already the right link" with no write at all. The same primitives are the write tail for every
generated-artifact builder — one living copy of that logic (see [one-living-version](../principles/one-living-version.md)) instead of a
per-builder reimplementation.

### The integrity gate

Three parties must stay consistent: the registry (what is managed and how), `.gitignore` (what git ignores), and the index (what git
tracks). Any pairwise drift is a defect — a managed copy that is tracked, a committed bootstrap file that an ignore rule swallows, an
opted-in target with no ignore rule. The integrity test (`Test-RootConfigIntegrity.Tests.ps1`) asserts all of it from the registry outward,
so adding an entry without its `.gitignore` line, or opting in a file without `git rm --cached`, fails the gate with the exact remediation.
The mechanism dimension is asserted both ways: every `copyAsLink` target is an effective link to its source from the running OS (the failure
names the remediation — re-run the importer), and no other managed target is a link (the flipped-back `comment: none` case a content compare
cannot see).

## Consequences

- A root config is authored once — in its source under `automation/` (or rendered by its generator) — and cannot drift from a second
  hand-kept root copy.
- Taking over a root file is one registry entry plus its source; opting out is the default, so an unregistered file is simply not touched.
- The bespoke `Build-ScriptAnalyzerSettings` is deleted; the root analyzer settings are the first migrated `source` entry, and
  `importer.ps1` the first `generator` entry (its existing `New-Importer` drift guard now also backs `ADR-ROOTCFG:6`).
- A reader never mistakes a managed root file for a source of truth: gitignored copies carry the generated-file header; committed targets
  are named in the registry and drift-tested; a link target needs no disclaimer, because it IS the source of truth.
- A `copyAsLink` target has zero drift surface and zero generated content — the honest cost is the hard-link orphan window after a git
  rewrite of the source (healed on the next import) and the per-consumer proof that the tool reads the root path through a link, which is
  why the flip is a per-entry, one-line decision rather than a mode.

## Dora explains:

DORA's research on continuous delivery and code maintainability emphasizes reproducible, drift-free automation; centralizing root config
generation into one registry and one writer ensures every build produces byte-identical artifacts and config changes stay reviewable.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — idempotent generation with content-only comparison produces
  reproducible, byte-identical artifacts across builds.
- [Version control](https://dora.dev/capabilities/version-control/) — managed-file headers and the registry keep the source of truth
  explicit and drifts reviewable.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — one registry and one writer eliminate per-file drift logic
  and per-format special cases.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
