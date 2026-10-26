# pwsh/Tooling.Node/Uninstall-TypeScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls TypeScript and the declarations Install-TypeScript put in place.

### description

Node.js must be installed at its locked version; npm ships with it. The compiler is removed from npm's global root, and the node and vscode
declarations from the repository-relative folder javascript.yml declares as `types_folder`. A tool that is not installed is skipped.

### example 1

```powershell
Uninstall-TypeScript
```
