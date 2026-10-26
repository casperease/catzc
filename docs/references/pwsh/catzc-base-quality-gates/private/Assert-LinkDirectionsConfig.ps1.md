# pwsh/Base.QualityGates/private/Assert-LinkDirectionsConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Validates link-directions.yml against the registries its rows name.

### description

The PowerShell validator of the link-directions config, found by convention and run by Invoke-ConfigValidator in this module's scope. The
config type already refuses a malformed row; this checks what the type cannot, because each check needs another registry: every class is a
role or role/subkind of file-kinds.yml (a star matching at least one), every track type is in track-types.yml, every track is declared in
the variants, every aspect is in the aspect model, every module is a loaded module, and every `because` is a code of the citation map. It
throws once, listing every problem by row and side.

### parameter `Config`

The link-directions config as read, before its type maps it.

## comment:1

Above `$typed = [Catzc.Base.QualityGates.LinkDirectionsConfig]::new($Config)`, written with `#`.

```text
Every value a row names is declared where its facet comes from, and every because is a registered rule code
(ADR-CONF-LOADING-POWERSHELLVALIDATOR, ADR-REPO-LINKS-DIRECTIONSAREROWS).
```
