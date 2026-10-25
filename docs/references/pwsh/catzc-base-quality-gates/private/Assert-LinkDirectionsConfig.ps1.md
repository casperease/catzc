# pwsh/Catzc.Base.QualityGates/private/Assert-LinkDirectionsConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$typed = [Catzc.Base.QualityGates.LinkDirectionsConfig]::new($Config)`, written with `#`.

```text
Every value a row names is declared where its facet comes from, and every because is a registered rule code
(ADR-CONF-LOADING-POWERSHELLVALIDATOR, ADR-REPO-LINKS-DIRECTIONSAREROWS).
```
