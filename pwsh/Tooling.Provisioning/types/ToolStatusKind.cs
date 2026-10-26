namespace Catzc.Tooling.Provisioning;

// Verdict of a tool against its tools.yml lock: Missing and WrongVersion are hard failures, Usable is only a migrate-me hint.
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
    Unwanted,

    // The managed copy is fine in this session, but an unmanaged one comes first on the Machine;User PATH every GUI app builds.
    Shadowed
}
