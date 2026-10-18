# automation/Catzc.Azure.DevOps/types/YamlClassificationResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public YamlClassificationResult(string classification, string templateType)`, written with `//`.

```text
The constructor takes the two values as strings and parses them to the enums, so a caller that
computed string literals binds directly without first converting to enum values.
```
