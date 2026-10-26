# pwsh/Tooling.Provisioning/types/ToolStatusKind.cs

A tool's status relative to its `tools.yml` lock: the verdict of comparing what is installed against what is required. It is load-bearing:
`Missing` and `WrongVersion` are hard failures, and `Usable` is only a hint to migrate.

## Members

- **`OK`** — installed at the locked version, through the expected manager; nothing to do.
- **`Usable`** — a usable version is installed, but not the way the lock wants it.
- **`WrongVersion`** — installed at a version that does not satisfy the lock; a failure.
- **`Missing`** — not installed at all; a failure.
- **`Unwanted`** — installed but not wanted by the lock.
