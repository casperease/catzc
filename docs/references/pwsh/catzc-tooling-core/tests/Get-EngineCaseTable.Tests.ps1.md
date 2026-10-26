# pwsh/Tooling.Core/tests/Get-EngineCaseTable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:tables = @(Get-ChildPath $root -File -Filter '*.yml' -Depth 5 |`, written with `#`.

```text
A case table sits five levels below pwsh/ (module, tests, assets, engine-cases, file); vendored modules are
pruned by the walk.
```
