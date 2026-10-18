# automation/Catzc.Base.QualityGates/types/LinkEngineResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
The outcome of one link-engine run (LinkEngine.Run): every finding in file/line order, the aligned text of each
file the aligner would change (repository-relative path -> new text), and how many files were read. The engine
does no writing — Format-Links writes Changed, Test-Links reports Findings.
```
