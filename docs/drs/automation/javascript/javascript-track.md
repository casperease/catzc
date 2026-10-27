# ADR: The JavaScript track — the editor extensions as modules, node's own runner, a types check, no package in the repository

## Rules: ADR-AUTO-JS

### Rule ADR-AUTO-JS-EXTENSIONSAREMODULES

JavaScript in the repository is a module of the `js` track: one folder per editor extension, `<root>/<extension-name>/`, named in kebab
case, its entry `extension.js` exporting `activate` and `deactivate`, its sibling parts beside it, its own files in `assets/` and its tests
in `tests/` (ADR-AUTO-MODULE-EXISTSBYLAYOUT, ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE). Files, functions and types follow the language's
naming: file kebab, function camel, type pascal. The PowerShell side renders, packs and installs an extension from catzc configs and never
reaches inside it; an extension reads catzc's configs only through the settings the generator renders.

- [Extensions are modules](#extensions-are-modules)

### Rule ADR-AUTO-JS-ONEJSROOT

The JavaScript lives under one root, declared by `javascript.yml`'s `root` with a sensible default on its config type: `js` when the
repository has a `js/` folder (the `js` track), else the dot-prefixed `.js`.

- [One root](#one-root)

### Rule ADR-AUTO-JS-NODETESTRUNNER

A JavaScript test runs under node's built-in runner, `node --test`, with no test package: a module's tests are `tests/*.test.js` beside its
code, each a top-level `test()` call over the module's pure parts, which take no editor and so run under node as they are. A part that needs
the editor is driven through a recording stub of the editor API, in its own node process. `Invoke-JavaScriptTest` runs a module's tests with
the managed node and reads node's junit report, so a failure is placed in its file.

- [Node's own runner](#nodes-own-runner)

### Rule ADR-AUTO-JS-TYPESGATE

`Test-JavaScriptTypes` checks every module with the TypeScript compiler, `tsc --noEmit`, over a generated `jsconfig.json` (`checkJs`), the
role pyright plays for Python. The compiler and the type declarations of node and of the editor are tools of `tools.yml`, pinned and
installed by the tooling into its own folder, which `jsconfig.json` names as its type roots; the editor's declarations are pinned to the
editor version the extension manifests declare. Nothing is installed into the repository, and no lint tool beside the compiler and the
formatter is added.

- [The types check](#the-types-check)

### Rule ADR-AUTO-JS-JSBRIDGE

`Test-Automation` runs the JavaScript tests through a bridge, as it runs the Go and Python ones: discovery maps each module's tests to the
module, every top-level `test()` is one test of the run (ADR-AUTO-TEST-TEST), and a test whose name starts with `integrity:` is `integrity`,
every other test `logic`.

- [The bridge](#the-bridge)

### Rule ADR-AUTO-JS-LAMPSINTHEEDITOR

The lamp extension spells the repository filters (DDR-FILTER-TOTALUNION, DDR-FILTER-STATEALWAYSSHOWN) in the editor. The open lamp's sets
are the files open in an editor tab. The languages button adds a language lamp for each tagged language ticked there, standing after the
filters as `lang-<name>`; unticking it takes it out of the row. A lamp's icon is lit as a steady glyph and unlit as an active filter pulsing
in a turning ring, and the editor's own git colours follow the lamps' colour mapping. A remembered Error and a failed test marker are
published again as the extension's own diagnostics, marked as remembered, because the editor's problem decorations are the only ones heavier
than the git colours and the only ones that colour every folder above the file; the problems list and the error count show them too. A
closed tab and a quiet language server never release a remembered Error.

- [Lamps in the editor](#lamps-in-the-editor)

## Context

The editor extensions are programs in their own language, and the lamps among them are central to daily work. Parked as assets of a
PowerShell module they had no gates of their own: no type check, no runner of their language, and tests that drove node one function at a
time from Pester. A language track gives them what the other languages have, and keeps the boundary to the PowerShell side plain.

### Extensions are modules

An extension is a module of the `js` track, placed by the layout like a module of any language track
([module-model](../module-model.md#rule-adr-auto-module-everylanguagetrackalike)). Its folder name is the extension's name, kebab as the
editor's package names are, so the folder, the package and the test folder share one name. The PowerShell side owns what depends on catzc
only (the manifest rendered from configs, the palette, the icon theme, packing and installing) and reaches an extension through its rendered
manifest and settings, never through its code.

### One root

The default is declared once, on the config type ([sensible-defaults](../sensible-defaults.md)), and `javascript.yml` declares a `root` only
to place the root elsewhere. The dot-prefixed fallback keeps a repository without a `js/` folder from growing one for tooling alone.

### Node's own runner

node ships a test runner, so the tests take no package and no install beyond node itself. An extension's logic is written as pure parts
beside its entry, which the editor-facing entry wires up; the parts take paths, texts and facts and return values, so a test calls them
directly. What only the editor can show (activation, the queue of presses, the swap of a saved engine) runs against a recording stub of the
editor API in a node process of its own, one scenario per process. node's junit report names each case's file, which is how a failure is
placed and how a file that does not load is told from a failing test.

### The types check

The TypeScript compiler checks JavaScript through JSDoc and inference with no build step and no source change, the same role pyright plays
for Python. It needs the type declarations of node's modules and of the editor's API, which are packages; they are tools like the compiler,
installed by the tooling into its own folder and named by the generated `jsconfig.json`, so the repository holds no `node_modules` and no
package manifest. The editor's declarations follow the editor version the manifests declare, so the types match what the extensions run
against. A separate lint tool would bring a second configuration for what the compiler's checks and the formatter already cover.

### The bridge

The bridge is the same one every second language uses ([test-automation](../test-automation.md)), so ordering, `-Modules`, the tiers and
both runs apply to the JavaScript tests as to the module's own Pester tests.

### Lamps in the editor

[repository-filters](../../design/repository-filters.md) states what a lamp means and what its state shows, for any viewer. The editor names
belong here, with the extension that draws them: a tab, a button, a glyph, a diagnostic and a language server are what VS Code offers, and
another viewer would spell the same rules with its own.

## Decision

JavaScript is a language track: each editor extension is a module, `<root>/<extension-name>/`, tested by node's own runner over its pure
parts and a recording editor stub, type-checked by the TypeScript compiler over a generated `jsconfig.json` with tool-installed
declarations, and run by `Test-Automation` through the bridge.

### How this is enforced

- `Invoke-JavaScriptTest` runs a module's `tests/*.test.js` with the managed node and parses node's junit report.
- `Test-JavaScriptTypes` runs `tsc --noEmit` over the generated `jsconfig.json`.
- `Get-JavaScriptTestCases` lists each module's cases for the bridge.

## Consequences

- An extension's logic is testable without an editor only as far as it is written as pure parts; the editor-facing entry stays thin.
- The types check reaches what JSDoc and inference reach; a module raises its own strictness as its JSDoc grows.
- A new extension is a folder with `extension.js`, an entry in the extensions registry, and its `tests/`.
