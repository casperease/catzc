# pwsh/Base.ModuleSystem/configs/dependencies.yml

The declared, allowed module dependency graph ([ADR-AUTO-DEPM](../../../../drs/automation/controlling-module-dependencies.md)). The graph is
validated at load by the typed record ([DependenciesConfig](../types/dependencies-config.md)) and enforced against the real code, function
calls and C# type references alike, by `Test-ModuleDependency`.

## Two sections

`groups:` holds named sets of on-disk modules, each with its own internal member-to-member graph. A group is a concept, not a disk module.
Pinning a group in a module's list permits an edge to any member, and the internal map is the layering contract among the members: each
member's actual edges must stay within it
([ADR-AUTO-DEPM-TWOSECTIONS](../../../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-twosections)).

`modules:` lists, per consumer module, the names it may depend on. Each name is a group (loose: any member) or a specific module (tight). A
module that is neither listed here nor a group member is unconstrained.

## Load-time rules

The typed record checks that every target resolves to a declared module or group, that each group is closed over its members, and that the
module graph and each group's internal graph are acyclic. `Test-ModuleDependency` separately reports a declared module or group member that
does not exist on disk. There is one source of truth and no compatibility layer.

## The groups

- **`Base`** is the Catzc.Base cluster, small focused libraries held together as one concept. It is ordered foundation-first: each member
  lists the members it may depend on.
- **`AzureExt`** is the Azure-extension cluster, all the Azure modules except the root `Catzc.Azure`. Its internal graph captures their
  layering; edges across groups (to `Base`, to the `Catzc.Azure` root and to `Tooling`) are declared per member under `modules:`.
- **`Tooling`** manages the non-vendored external command-line tools. Core is the foundation: configuration and mapping, version and
  presence control, and the generic install and uninstall engine. Python (pip) and Node (npm) carry their runtime ecosystems, Toolchain
  holds the tools that use the generic engine (dotnet, java, terraform, az), and Provisioning orchestrates the whole devbox and ships git
  and postman. Provisioning reaches the per-tool installers by dynamic dispatch, so no static edge shows, but it is allowed to depend on
  them here.
