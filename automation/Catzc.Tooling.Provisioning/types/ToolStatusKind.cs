/*
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Provisioning/types/ToolStatusKind.cs
    folder: types
    name: tool-status-kind
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-provisioning/types/ToolStatusKind.cs.md
---
*/

namespace Catzc.Tooling.Provisioning;

public enum ToolStatusKind
{
    // Installed at the locked version, via the expected manager — nothing to do.
    OK,

    // A usable version is installed, but not the way the lock wants it (a migrate-me hint).
    Usable,

    // Installed, but at a version that does not satisfy the lock — a failure.
    WrongVersion,

    // Not installed at all — a failure.
    Missing,

    // Installed but not wanted by the lock.
    Unwanted
}
