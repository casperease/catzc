# Generated root configs — every managed root file from one in-repo source of truth

## Rules: ADR-ROOTCFG

### Rule ADR-ROOTCFG:1

An opted-in repository-root config file is **fully managed by the source-of-truth automation**: it is reproduced from exactly one in-repo
source of truth — a `source` file (an authored config copied out) or a `generator` function (e.g. `New-Importer`) — and is never
hand-edited. Corrections go to the source; the root file is its rendering.

- [Decision](#decision)

### Rule ADR-ROOTCFG:2

The registry is `automation/Catzc.Base.RootConfig/configs/rootconfig.yml` — validated by the `RootConfigFiles` type, materialised by
`Build-RootConfig`, the single writer. **Opt-out is the default**: an entry (or a root file) not opted in stays hand-authored and committed;
`optIn: true` is the explicit takeover switch. The target-to-source pairing is not restated anywhere else.

- [Decision](#decision)

### Rule ADR-ROOTCFG:3

Per entry, the `committed` boolean (default false) decides git membership and nothing else. `committed: false` → the target is a derived,
gitignored artifact, reproduced on import like the generated READMEs. `committed: true` → the target stays tracked because git or the
bootstrap reads it **before the importer runs** (`importer.ps1`), while the automation still owns its content — a source change surfaces as
a reviewable diff. The difference between the two is one boolean, not two systems.

- [One system, one boolean](#one-system-one-boolean)

### Rule ADR-ROOTCFG:4

Generation is idempotent and runs on every import (the importer tail). All writes go through the one shared primitive `Write-FileIfChanged`
(`Catzc.Base.Files`): canonical output (UTF-8 no BOM, LF, one trailing newline), an EOL-insensitive compare, write only on a real content
change — so a clean tree is a fast no-op and a CRLF/LF flip never forces a rewrite.

- [Always current, at no steady-state cost](#always-current-at-no-steady-state-cost)

### Rule ADR-ROOTCFG:5

A `source` copy-in carries a leading generated-file header in the target's comment style (`comment: hash` for `#`-trivia formats; `none` for
formats with no comment syntax, e.g. JSON) naming the source. A `generator` owns its whole output — header included — and takes no
`comment`. The header is strictly a leading block: config formats have no portable in-body anchor.

- [Decision](#decision)

### Rule ADR-ROOTCFG:6

The registry, `.gitignore`, and git's tracked set must agree, and an integrity test asserts it: every opted-in `committed: false` target is
matched by an ignore rule and untracked; every `committed: true` target is tracked and not ignored; a generator target matches its
generator's output (the drift check).

- [The integrity gate](#the-integrity-gate)

## Context

The repository root carries configuration files for git, editors, and quality-gate tools. Kept by hand, each is its own little source of
truth with its own drift risk, and the tool-specific quirks (a `.psd1` that must be a literal hashtable, a JSON manifest with no comment
syntax) get re-solved ad hoc. The repository already treats other per-folder derived files as generated, gitignored artifacts — the module
manifests and the README copy-ins ([generated-readmes](generated-readmes.md)) — and already generated one root file each in two one-off
ways: the root analyzer settings (a bespoke builder) and `importer.ps1` (`New-Importer` plus a drift test). A root config file is the same
pattern; what was missing was one registry and one writer.

## Decision

Every opted-in root config file is materialised by `Build-RootConfig` (module `Catzc.Base.RootConfig`) from the single source of truth its
`rootconfig.yml` entry names: a `source` file copied out with a generated-file header, or a `generator` function whose rendered output is
the whole file. The registry entry carries two booleans — `optIn` (is the file managed at all; opt-out is the default) and `committed` (is
the managed target tracked in git) — and the importer tail keeps every opted-in target current on every load.

### One system, one boolean

Some root files are read before the importer can possibly have produced them: `importer.ps1` is the load entry point itself, and git reads
`.gitignore`/`.gitattributes` at checkout. Those files cannot be gitignored copy-ins — but they can still be fully managed, because
"managed" means "reproduced from one in-repo source of truth", not "absent from git". `committed: true` expresses exactly that: same
registry, same writer, same drift guarantee; the only difference is that the target stays tracked and a regeneration shows up as a normal
diff to review and commit. This keeps the model honest — a copy-in and `importer.ps1` differ by one boolean, not by which system owns them.

### Always current, at no steady-state cost

Because the targets are cheap to reproduce and must never go stale, the importer regenerates them on every load, exactly like the README
copy-ins. This is safe only because generation is idempotent: `Write-FileIfChanged` canonicalises, compares ignoring line endings, and
writes only on a real change. The same primitive is the write tail for every generated-artifact builder — one living copy of that logic (see
[one-living-version](../principles/one-living-version.md)) instead of a per-builder reimplementation.

### The integrity gate

Three parties must stay consistent: the registry (what is managed and how), `.gitignore` (what git ignores), and the index (what git
tracks). Any pairwise drift is a defect — a managed copy that is tracked, a committed bootstrap file that an ignore rule swallows, an
opted-in target with no ignore rule. The integrity test (`Test-RootConfigIntegrity.Tests.ps1`) asserts all of it from the registry outward,
so adding an entry without its `.gitignore` line, or opting in a file without `git rm --cached`, fails the gate with the exact remediation.

## Consequences

- A root config is authored once — in its source under `automation/` (or rendered by its generator) — and cannot drift from a second
  hand-kept root copy.
- Taking over a root file is one registry entry plus its source; opting out is the default, so an unregistered file is simply not touched.
- The bespoke `Build-ScriptAnalyzerSettings` is deleted; the root analyzer settings are the first migrated `source` entry, and
  `importer.ps1` the first `generator` entry (its existing `New-Importer` drift guard now also backs `ADR-ROOTCFG:6`).
- A reader never mistakes a managed root file for a source of truth: gitignored copies carry the generated-file header; committed targets
  are named in the registry and drift-tested.
