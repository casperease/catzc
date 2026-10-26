# pwsh/Tooling.Inspiration/types/InspirationRoot.cs

The stored form of an inspiration's root and its resolution to binding form. A root is stored portable and resolved to absolute only where
it binds, so the same file works from any checkout and either shell.

## Stored form

A root is stored in communication form
([ADR-AUTO-PATH-STOREDCOMMUNICATIONFORM](../../../../drs/automation/path-representation.md#rule-adr-auto-path-storedcommunicationform)):
repository-relative, or anchored on `{workspace}`, the parent folder of the repository root, where sibling checkouts live
([ADR-AUTO-PATH-WORKSPACEANCHOR](../../../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)). `Resolve` turns
either into a `/`-separated absolute path, the binding form
([ADR-AUTO-PATH-BINDINGFORMONLYATBINDING](../../../../drs/automation/path-representation.md#rule-adr-auto-path-bindingformonlyatbinding)).

## Two shells, one result

The repository root reaches the resolver in the view of the shell that set it: `C:\projects\catzc` under pwsh, `/c/projects/catzc` under Git
Bash. `ToNative` maps both to one form, so the two shells resolve a root identically. The platform is a parameter, not a probe, so every
branch is deterministic and testable on any OS.

## Violations

`Violations` lists every way a stored path breaks communication form, as messages naming the label, and is empty when the path is valid. A
root may carry the `{workspace}` anchor as its first segment; a path inside a root never does, so it can never climb out of it.

## ToNative

`ToNative` maps a path in either shell's view to the platform's own `/`-separated form: backslashes become `/`, and on Windows a Git Bash
drive path (`/c/projects`) becomes a drive path (`C:/projects`). Elsewhere a `/c/...` path is a real path and is left as it is.
