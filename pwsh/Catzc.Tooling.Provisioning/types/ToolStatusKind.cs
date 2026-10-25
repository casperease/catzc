/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-provisioning/types/ToolStatusKind.cs.md"
  warning: "Generated Header"
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
