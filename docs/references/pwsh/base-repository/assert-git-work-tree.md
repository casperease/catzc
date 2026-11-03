# pwsh/Base.Repository/Assert-GitWorkTree.ps1

The guard for commands that ask git: silent in a git checkout, a named error in a working root with no repository.

## help

### synopsis

Throws when the working root is not a git work tree.

### description

A guard for the commands that run git against the working root, such as the status and changed-path listers. A working root with no
repository is legal, and the tracked-file lister answers it with nothing; a command that cannot answer without git asserts the work tree
instead, so the error names the command and the root rather than a failed git call
([ADR-REPO-REPOKIND-NOREPO](../../../drs/repository/repository-kinds.md#rule-adr-repo-repokind-norepo)).

The root is a work tree when `.git` is a folder, or a pointer file for a linked work tree or a submodule.

### parameter `Command`

The name of the guarded command, used in the error message. Defaults to the calling command's name.

### example 1

```powershell
Assert-GitWorkTree
```

### example 2

```powershell
Assert-GitWorkTree -Command 'Get-RepoStatus'
```

## comment:1

Above `# A checkout holds .git as a folder, a linked work tree or a submodule as a...`, written with `#`.

```text
A checkout holds .git as a folder, a linked work tree or a submodule as a 'gitdir:' pointer file.
```
