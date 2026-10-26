# pwsh/Base.QualityGates/types/LinkDirectionsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class LinkDirectionsConfig`, written with `//`.

```text
The direction rows in order, and the files exempt from them, each with its reason (ADR-REPO-LINKS-DIRECTIONSAREROWS,
ADR-REPO-LINKS-EXCEPTIONSAREENTRIES). With no rows every relation is denied, the default declared here once.
```
