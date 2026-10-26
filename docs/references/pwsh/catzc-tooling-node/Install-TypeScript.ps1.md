# pwsh/Tooling.Node/Install-TypeScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs TypeScript and the declarations it type-checks the js track with, each at the version the tools config locks.

### description

Node.js must be installed at its locked version first; npm ships with it. The compiler goes into npm's global root, so `tsc` is on PATH.
Every tool the tools config says TypeScript installs alongside itself (the node and vscode declarations) goes into the repository-relative
folder javascript.yml declares as `types_folder`, which the type-check projects name as their type roots. A tool already at its locked
version is skipped. The call throws when `tsc` is not on PATH afterwards.

### parameter `Force`

Installs every tool again, even one already at its locked version.

### example 1

```powershell
Install-TypeScript
```

## comment:1

Above `$folder = Join-Path (Get-RepositoryRoot) (Get-Config -Config...`, written with `#`.

```text
The compiler is a tool on PATH, in npm's global root; the declarations it checks against go into the repository-relative,
gitignored folder javascript.yml declares (types_folder), which the generated jsconfig.json names relatively, so no machine path
reaches a generated file. Each at its tools.yml pin.
```
