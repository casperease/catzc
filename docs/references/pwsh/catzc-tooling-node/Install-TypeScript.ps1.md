# pwsh/Catzc.Tooling.Node/Install-TypeScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$folder = Join-Path (Get-RepositoryRoot) (Get-Config -Config...`, written with `#`.

```text
The compiler is a tool on PATH, in npm's global root; the declarations it checks against go into the repository-relative,
gitignored folder javascript.yml declares (types_folder), which the generated jsconfig.json names relatively, so no machine path
reaches a generated file. Each at its tools.yml pin.
```
