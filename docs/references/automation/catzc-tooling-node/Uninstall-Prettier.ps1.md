# automation/Catzc.Tooling.Node/Uninstall-Prettier.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls Prettier (the global npm package).

### description

Idempotent — skips if Prettier or npm is not present (nothing to uninstall).

### example 1

```powershell
Uninstall-Prettier
```
