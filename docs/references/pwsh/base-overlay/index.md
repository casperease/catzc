# Catzc.Base.Overlay

The consumer overlay module. It **applies a consumer's changes to a built bundle** — the overlay, the `.catzc/` folder in the consumer's own
working root, where every file sits at the path of what it changes in the bundle — and checks them as a whole first, so nothing applies
unless all of it is valid. It owns the function overrides and the one check of a function file's shape; it deliberately does **not** own
config fragments or asset overrides, which `Get-Config` and `Get-CatzcModuleRoot` read on demand. The rules are in
[consumer-overlay](../../../drs/automation/consumer-overlay.md); the bundle it changes is
[platform-bundle](../../../drs/automation/platform-bundle.md).

## Responsibilities

| Responsibility   | Area    | Name                                                           |
| ---------------- | ------- | -------------------------------------------------------------- |
| responsibility:1 | apply   | [Applying the overlay](#responsibility1--applying-the-overlay) |
| responsibility:2 | verify  | [Overlay checks](#responsibility2--overlay-checks)             |
| responsibility:3 | inspect | [Overlay inventory](#responsibility3--overlay-inventory)       |
| responsibility:4 | shape   | [Function file shape](#responsibility4--function-file-shape)   |

### responsibility:1 — Applying the overlay

Replacing a bundled module's function with the consumer's file of the same name, and loading the consumer's local modules, at the end of a
bundle load. An override file is loaded inside the module's own scope, so the module's callers, its script state and a test's module mock
reach it; a public override is also published to the session, where the import had put the original, so every other module reaches it too. A
local module loads after the overrides, built in the session from its function files, and calls the bundle as overridden.

### responsibility:2 — Overlay checks

Checking the overlay against its rules and failing once with every violation: every entry is an override point; a function override is one
function named for its file, replaces a function the module has with the same visibility, and keeps the original's contract; a config
fragment merges onto a config the module ships and never a sealed one; an asset override replaces an asset the module ships; a local module
follows catzc's module conventions, never takes the reserved `Catzc.` prefix, and never takes a loaded command's name.

### responsibility:3 — Overlay inventory

Listing everything in the overlay, each entry classified by where it sits — a function override, a config fragment, an asset override, a
local test, a local module, or something that is no override point — so a reader can see what a session changed.

### responsibility:4 — Function file shape

The one check that a `.ps1` file is a single function named for the file that can be loaded away from its folder. The build uses it before
it merges a module's function files, and the overlay before it loads an override.

## What the module does

A consumer of a built bundle runs catzc in its own working root and never edits the bundle. Its changes live in the overlay, and the path of
a file there is its meaning, so there is no list of overrides to keep in step with the files. The module turns that layout into a checked,
applied change: it inventories the overlay, checks it as a whole, and only then applies the function overrides. Config fragments and asset
overrides take effect where they are read, so this module only checks them.

The overlay applies in build mode only; in source mode the catzc tree is changed directly. The overlay root itself is derived in
[Catzc.Base.Repository](../base-repository/index.md), below this module, because [Catzc.Base.Config](../base-config/index.md) merges config
fragments and must find the overlay without depending on it.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                          | Function                    |
| --------------------------------------- | --------------------------- |
| responsibility:1 — Applying the overlay | `Import-CatzcOverlay`       |
| responsibility:2 — Overlay checks       | `Assert-CatzcOverlay`       |
| responsibility:3 — Overlay inventory    | `Get-CatzcOverlay`          |
| responsibility:4 — Function file shape  | `Get-FunctionFileViolation` |
