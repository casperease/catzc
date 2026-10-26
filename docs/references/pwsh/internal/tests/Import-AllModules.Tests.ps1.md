# pwsh/.internal/tests/Import-AllModules.Tests.ps1

The tests of the importer over a sandbox tree: discovery, the public and private boundary, the two import-failure guards, and the eviction
of one code root's modules by another's.

## The sandbox

The sandbox holds the importer, the `.internal` shared modules (loader, bootstrap and the rest) and the vendored modules, with no
application modules. Each test populates it and runs the importer in a fresh child pwsh process, a cold, fully isolated re-derive of module
state from the current files. The importer is a pure function of the file system, so one import per distinct tree shape is enough: each
test captures everything it needs from a single import, then asserts the facets in separate `It` blocks.

The `.internal` and vendor folders are copied with `Copy-Directory` (raw `System.IO`) rather than `Copy-Item -Recurse`: the vendored
modules, about 88 files, copy in about 190 ms against about 1.25 s with the cmdlet.

## The child import

One cold import runs in a child pwsh, and the capture expression is evaluated after the import and returned as parsed JSON. The import's
announcements are information records
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)),
so `6>$null` keeps them out of the JSON. The module-list expression lists the loaded application modules and their exported functions;
Bootstrap and the vendored modules are filtered out, and `$_` is escaped so it evaluates in the child.

## A populated tree

One import of a rich tree covers discovery, public export, the public and private boundary, a private being callable from a public function
and several independent modules. It also covers the collision guard giving no false positive on a private name shared across modules: the
import succeeds with two modules each defining a private `Get-Shared`, both modules load and neither exports it, which proves the guard
ignores module-scoped privates.

## Changing the tree

The populated tree is mutated every way an author can, then re-imported. One cold import must reflect a changed body, an added function, a
deleted function and a deleted module.

## Eviction across code roots

This case is greedy: one child pwsh dot-sources three importers in sequence (process-global module state), so it consumes the machine beyond
its own process and carries an L2-scale budget
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).

It builds two complete sandbox roots (importer, `.internal` and `.vendor`) as stand-ins for a source tree and a build. Each holds a module
only it ships and a same-named module that reports which root it came from. The importer waits on the run lock before any module loads, so
the sandbox carries the timeouts config too; it names no track, so both sit under their full-name folders.
