# Generated READMEs — one authored source, linked out per conventional folder

## Rules: ADR-README

### Rule ADR-README:1

A `README.md` in a mapped conventional folder is a **filesystem link** to an authored docs source, never a hand-kept copy: the README IS the
source, so there is no second copy to drift and an edit through either path lands in the one authored file.

- [Decision](#decision)

### Rule ADR-README:2

Generated READMEs are derived artifacts, gitignored globally (`**/README.md`) exactly like the generated `.psd1` manifests — re-linked on
import, never committed. History and the authored text live elsewhere (git; the source).

- [Derived, not committed](#derived-not-committed)

### Rule ADR-README:3

A folder keeps a hand-authored, committed README by opting out: omit it from the map and un-ignore it in `.gitignore` (`!path/README.md`). A
folder is therefore either generated (mapped, ignored) or committed (unmapped, opted-in) — never both.

- [Opt-out is explicit and located](#opt-out-is-explicit-and-located)

### Rule ADR-README:4

The map from a target folder to its source lives only in `automation/Catzc.Base.Docs/configs/readme.yml` — a glob `patterns` list whose
matched folders derive their source by convention, plus explicit `mappings` for the exceptions — validated by the `DocsConfig` type and
expanded by `Get-ReadmeMappings`; `Build-Readme` is the single writer. The mapping is not restated anywhere else.

- [Decision](#decision)

### Rule ADR-README:5

Materialisation is idempotent and runs on every import (the importer tail), through the one link mechanism owner `Set-FileLink`
(`Catzc.Base.Files`, [ADR-ROOTCFG:7](generated-root-configs.md#rule-adr-rootcfg7)): a README that is already an effective link to its source
is a no-op, and anything else — an old plain-file copy, a wrong or orphaned link — is recreated with the running OS's best mechanism (a
relative symbolic link where permitted, a hard link on privilege-less Windows), so a clean tree is a fast no-op and each OS heals its own
view at its session start.

- [Always current, at no steady-state cost](#always-current-at-no-steady-state-cost)

### Rule ADR-README:6

Relative links resolve at the source. An article authors its links relative to its own `docs/` location, and the docs tree is the reading
surface where they are guaranteed to resolve; the README path is a pointer into that surface, not a second rendering with its own link base.
A consumer that resolves a relative reference against the README's folder rather than the source's location reads the article from the wrong
base — the accepted cost of the link form, bounded by the fact that the links are gitignored and local-only (no hosted renderer ever serves
them).

- [The reading surface is the source](#the-reading-surface-is-the-source)

### Rule ADR-README:7

Authored sources live under `docs/references/` — automation modules as the domains-first reference articles in
`docs/references/automation/<kebab>.md`, and other folders (pipelines, infrastructure) under `docs/references/`. The source is the reviewed,
gate-checked artifact; the README link is out of markdown-gate scope.

- [Derived, not committed](#derived-not-committed)

## Context

A `README.md` is what a reader sees first in a folder in an editor. Kept by hand, each drifts from the documentation it duplicates, and the
same content is maintained in two places. The repository already treats other per-folder, convention-derived files as generated, gitignored
artifacts ([dynamic-module-manifests](../automation/powershell/dynamic-module-manifests.md), `ADR-MANIFEST:3`), and the managed root configs
materialise a source-backed, gitignored target as a filesystem link to its source of truth
([generated-root-configs](generated-root-configs.md), `ADR-ROOTCFG:7`). A README is the same shape: one authored source under `docs/`, one
derived artifact per folder — and the link form makes the artifact the source itself, so drift is impossible by construction and there is no
banner, rebasing, or composed content to maintain.

## Decision

Each mapped conventional folder's `README.md` is materialised by `Build-Readme` (module `Catzc.Base.Docs`) as a filesystem link to its
single authored source under `docs/references/`, declared in `configs/readme.yml` (glob `patterns` + explicit `mappings`) and validated by
`DocsConfig`. There is one authored copy of the content (the source) and one link per folder (the README) — the same file, reachable from
both paths.

### Derived, not committed

The README link is an artifact, not source. It is gitignored globally (`**/README.md`), the way the generated `.psd1` manifests are
([dedicated-output-directory](dedicated-output-directory.md) treats generated artifacts as out of the committed source set), and it is
excluded from the markdown gate — the authored source under `docs/references/` is the reviewed artifact. Committing a link would also be
committing a git link object, which Windows checkouts materialise unreliably — the same reason a `committed` root config is never a link
([ADR-ROOTCFG:7](generated-root-configs.md#rule-adr-rootcfg7)).

### Opt-out is explicit and located

Some READMEs are genuinely authored in place — a GitHub profile landing page, a third-party README, a fixture. Such a folder is simply not
mapped, and its README is un-ignored in `.gitignore` with a `!path/README.md` line. The two expressions stay consistent by construction: a
mapped folder's README is ignored and unmapped-opted-in READMEs are committed, and an integrity test asserts no mapped target is opted back
in.

### Always current, at no steady-state cost

Because the links are cheap to verify and must never go stale, the importer re-materialises them on every load. This is safe only because
`Set-FileLink` is idempotent: an effective link (a symbolic link resolving to the source, or a hard link with identical bytes) is a no-op,
and anything else is deleted and recreated — including a plain file whose content happens to match, because content equality is not the
contract; being the same file is. The per-OS healing contract is the mechanism owner's
([generated-root-configs](generated-root-configs.md#copy-as-link-the-target-is-the-source)): a Windows session typically holds hard links, a
Linux session symbolic links, and each session verifies and heals its own view at import.

### The reading surface is the source

An authored article links to its neighbours — sibling references, ADRs — relative to its own location, and those links are checked by the
markdown gate at that location. The README makes the article reachable from the folder it documents; reading it there shows the source
content, and editing it there edits the source. What the link form does not provide is a second link base: a renderer that resolves relative
references against the README's folder resolves them against the wrong base. That consumer does not exist in practice — the READMEs are
gitignored, so no hosted renderer ever serves them, and the in-repo navigation surface is the docs tree itself — which is why the trade is
accepted rather than compensated for with a rewritten copy.

## Consequences

- Per-folder README content is authored once, under `docs/references/`, and cannot drift — the README is the same file, not a copy kept in
  step.
- A reader never mistakes a generated README for a second source of truth: there is no second content at all, and an edit through the README
  path lands in the authored source, which is the intent.
- Adding a generated README is one mapping line plus its source file; opting a folder out is one `.gitignore` line and leaving it unmapped.
- The cost is the link base: relative links inside an article are guaranteed to resolve only at the source's own location, so the docs tree
  is the canonical reading surface and the README is the pointer to it.
