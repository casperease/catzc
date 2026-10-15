---
catzc:
  derived:
    path: docs/references/automation/catzc-base-folders.md
    kind: reference
    body_sha: a2fc2bb2cdea
    links:
      - docs/references/automation/catzc-base-files.md
      - docs/references/automation/catzc-base-git.md
---

# Catzc.Base.Folders

The folder-listing module. It owns the one way to list the files and folders below a folder, to a bounded depth, without loading the tree: a
compiled walker, the config that holds its defaults, and the function that reads them. It deliberately does **not** own copying a tree (that
is [Catzc.Base.Files](catzc-base-files.md)) or reading git's view of the tree (that is [Catzc.Base.Git](catzc-base-git.md)).

## Responsibilities

| Responsibility   | Area     | Name                                                                             |
| ---------------- | -------- | -------------------------------------------------------------------------------- |
| responsibility:1 | walk     | [Bounded folder listing](#responsibility1--bounded-folder-listing)               |
| responsibility:2 | defaults | [Walk defaults in the registry](#responsibility2--walk-defaults-in-the-registry) |

### responsibility:1 — Bounded folder listing

Listing the children of a folder and, up to a depth, the children below them. The walk is lazy and stops at the depth: a level below it is
never read. A named folder is pruned while the walk runs, so it and everything under it are never entered, and a link is listed but never
followed, so a link back to an ancestor cannot loop. The result is full paths in ordinal order, so it reads the same on every machine. A
missing folder or a depth below one fails at once.

### responsibility:2 — Walk defaults in the registry

The three settings a walk takes from configuration: the default depth, the folder names pruned by default, and whether the vendor folder is
pruned from searches. They are one registered config, `folder-walk`, so any code reads one as a global address such as
`global.folder-walk.prune_vendor_in_searches`. The default of each setting is declared once, on the config type; a caller's explicit value
wins over the config, and the config wins over the default.

## What the module does

Enumerating a folder with a cmdlet loads provider objects for every level and is unbounded by default. This module replaces that with a
compiled walker that does the same job in .NET, to a depth the caller can name and a default that stays shallow, so nothing is deeply loaded
unless a call says so on purpose.

The walker is a type, and the listing function is a thin wrapper that binds the registry defaults and calls it. Callers that sit below this
module in the dependency graph, such as the config reader itself, list one level inline with the .NET directory calls, since a single level
needs no walk.

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                   | Function          |
| ------------------------------------------------ | ----------------- |
| responsibility:1 — Bounded folder listing        | `Get-ChildPath`   |
| responsibility:2 — Walk defaults in the registry | `folder-walk.yml` |
