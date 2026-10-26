# pwsh/Tooling.Inspiration/private/Resolve-InspirationRoot.ps1

The private resolver that turns an inspiration's stored root into a normalized absolute path on this machine. It is the one place the stored
form meets the binding form; `Get-Inspiration` calls it for every entry.

## help

### synopsis

Resolves an inspiration's stored root to its binding form, a normalized absolute path.

### description

An inspiration's root is stored in communication form
([ADR-AUTO-PATH-STOREDCOMMUNICATIONFORM](../../../../drs/automation/path-representation.md#rule-adr-auto-path-storedcommunicationform)) and
resolved only at the point of use
([ADR-AUTO-PATH-BINDINGFORMONLYATBINDING](../../../../drs/automation/path-representation.md#rule-adr-auto-path-bindingformonlyatbinding)):

- '`{workspace}/<folder>`' resolves against the workspace, the parent folder of the repository root
  ([ADR-AUTO-PATH-WORKSPACEANCHOR](../../../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor));
- any other path goes through Resolve-RepoPath, so a repository-relative root resolves against the repository root and an absolute one
  passes through.

Both pwsh's and Git Bash's view of a path resolve the same: the repository root, or an absolute root, given as '/c/projects/...' on Windows
is read as 'C:/projects/...' (InspirationRoot.ToNative). The result is normalized with `[IO.Path]::GetFullPath`, so it is in the platform's
own form.

### parameter `Root`

The stored root: '`{workspace}/<folder>`', a repository-relative path, or an absolute path in either shell's view.

### example 1

```powershell
Resolve-InspirationRoot '{workspace}/eac'   # -> C:\projects\eac when the repository root is C:\projects\catzc
```
