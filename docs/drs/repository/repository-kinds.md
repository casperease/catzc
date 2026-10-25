# ADR: Repository kinds — the product mono-repository, a consumer repository, and no repository

## Rules: ADR-REPO-REPOKIND

### Rule ADR-REPO-REPOKIND-THREEKINDS

The catzc tooling runs in exactly one of three repository kinds: the product mono-repository that holds its source (the
[glossary's term](../glossary.md#product-mono-repository), one repository several teams build one product in), a consumer repository that
runs a built bundle against its own tree, or no repository, where a built bundle runs on a working root that is not a git repository. The
kind follows from where the code and the working root are; nothing is configured to choose it.

- [The three kinds](#the-three-kinds)

### Rule ADR-REPO-REPOKIND-CONSUMERREPO

A consumer repository is a git repository that runs an installed catzc bundle in build mode: its root is the working root and the bundle is
the code root ([ADR-AUTO-BUNDLE-TWOROOTS](../automation/platform-bundle.md#rule-adr-auto-bundle-tworoots)). It changes what the bundle does
only through its `.catzc/` overlay
([ADR-AUTO-OVERLAY-OVERLAYFOLDER](../automation/consumer-overlay.md#rule-adr-auto-overlay-overlayfolder)), and it places its own files by
declaring its own tracks, so no folder of the product mono-repository is assumed in it.

- [A consumer repository](#a-consumer-repository)

### Rule ADR-REPO-REPOKIND-NOREPO

With no repository, a built bundle runs on the working root the caller names, with no git history and no tracked files. A command that needs
either cannot answer there and stops with a message that names what it needs; every other command runs as it does in a repository.

- [No repository](#no-repository)

## Context

The catzc tooling is a CLI that maps to file artifacts through tracks. This repository is the product mono-repository it is developed in,
but the tooling is also built into a bundle that other repositories install, and a bundle can run where there is no repository at all.
Without a name for each case, every placement question is answered once per case and the answers drift: a path that holds in this repository
is written into code that a consumer runs elsewhere.

## Decision

### The three kinds

The product mono-repository runs in source mode, where the working root and the code root are the same folder
([DDR-RUNMODE-TWORUNMODES](../design/run-modes.md#rule-ddr-runmode-tworunmodes)); it is the only kind that edits catzc itself. A consumer
repository and no repository both run a built bundle in build mode and differ only in whether the working root is a git repository.
Whichever kind it is, a placement comes from a track, never from a path written in code
([DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED](../design/tracks.md#rule-ddr-track-subscribablenotpathcoupled)).

### A consumer repository

The bundle a consumer runs is read-only; the overlay is the consumer's source, committed and reviewed by the consumer. The consumer's own
tracks say where its modules, infrastructure and documents live, so the same bundle runs over a layout unlike this one. A version exists
only where the consumer pins the bundle, at its repository boundary.

### No repository

A bundle can run where nothing is under version control, for a one-off command or a build on a clean machine. It writes its output under the
working root as it does anywhere. What needs git — the tracked files, the history behind a globset, a commit to stamp — has no source there,
so those commands say so instead of guessing.

## Consequences

- Code never assumes this repository's folders; a consumer maps its own places, and the product mono-repository is one case of three.
- The words have one meaning each: "mono-repository" is the product mono-repository of the thesis, and "consumer repository" and "no
  repository" are the two kinds a built bundle runs in.
