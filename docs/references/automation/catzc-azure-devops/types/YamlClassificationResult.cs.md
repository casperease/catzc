# docs/references/automation/catzc-azure-devops/types/YamlClassificationResult.cs.md

`automation/Catzc.Azure.DevOps/types/YamlClassificationResult.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `public YamlClassificationResult(string classification, string templateType)`.

```text
The constructor takes the two values as strings and parses them to the enums, so a caller that
computed string literals binds directly without first converting to enum values.
```
