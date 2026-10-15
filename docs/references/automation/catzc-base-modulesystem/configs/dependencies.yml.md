---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/configs/dependencies.yml.md
    kind: comment-page
    body_sha: "39e5c5fd29ac"
---

# automation/Catzc.Base.ModuleSystem/configs/dependencies.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `groups:`.

```text
Declared (ALLOWED) module dependency graph, validated at load (the DependenciesConfig type) and enforced
against the real code (Get-ModuleDependency + Get-CSharpTypeDependency) by Test-ModuleDependency.

Two sections:
  groups:  a named set of on-disk modules WITH its own internal member->member DAG. A group is a concept,
           not a disk module. Pinning a group in a module's deps permits an edge to ANY member; the internal
           map is the layering contract among the members (each member's actual edges must stay within it).
  modules: per consumer module, the names it may depend on — each a GROUP (loose: any member) or a specific
           MODULE (tight). A module NOT listed here is unconstrained.

Rules checked at load (DependenciesConfig): targets resolve to a declared module or group; each group is
closed over its members; the module graph and each group's internal graph are acyclic. Test-ModuleDependency
reports a declared module or group member that does not exist on disk. No back-compat — one source
of truth (the infra system is pre-production).
```

## comment:2

Above `Base:`.

```text
The Catzc.Base cluster — small focused libraries held together as one concept. Foundation-first:
each member lists the members it may depend on (its internal DAG layer).
```

## comment:3

Above `AzureExt:`.

```text
The Azure-extension cluster — all the Azure modules except the root `Catzc.Azure`. Its internal
member->member DAG captures their layering; cross-group edges (to Base, to the `Catzc.Azure` root, and
to the `Tooling` group) are declared per-member in `modules:` below.
```

## comment:4

Above `Tooling:`.

```text
The Tooling cluster — manages the non-vendored external CLI tools. Core is the foundation (config +
mapping, version/presence control, and the generic install/uninstall engine); Python (pip) and Node
(npm) carry their runtime ecosystems, Toolchain the generic-engine tools (dotnet/java/terraform/az),
and Provisioning orchestrates the whole devbox (and ships git/postman). Provisioning reaches the
per-tool installers by dynamic dispatch (no static edge), but is allowed to depend on them here.
```
