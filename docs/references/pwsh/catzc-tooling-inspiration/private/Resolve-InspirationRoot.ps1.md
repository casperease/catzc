# pwsh/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves an inspiration's stored root to its binding form, a normalized absolute path.

### description

An inspiration's root is stored in communication form
([ADR-AUTO-PATH-STOREDCOMMUNICATIONFORM](../../../../adr/automation/path-representation.md#rule-adr-auto-path-storedcommunicationform)) and resolved only at the point of use
([ADR-AUTO-PATH-BINDINGFORMONLYATBINDING](../../../../adr/automation/path-representation.md#rule-adr-auto-path-bindingformonlyatbinding)):

- '`{workspace}/<folder>`' resolves against the workspace, the parent folder of the repository root
  ([ADR-AUTO-PATH-WORKSPACEANCHOR](../../../../adr/automation/path-representation.md#rule-adr-auto-path-workspaceanchor));
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
