# pwsh/Tooling.Node/Install-TypeScript.ps1

The installer of the TypeScript compiler and of the declarations it type-checks the js track against, each at its `tools.yml` pin.

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

## Where things land

The compiler is a tool on PATH, in npm's global root. The declarations it checks against go into the repository-relative, gitignored folder
that `javascript.yml` declares as `types_folder`. The generated `jsconfig.json` names that folder relatively, so no machine path reaches a
generated file.
