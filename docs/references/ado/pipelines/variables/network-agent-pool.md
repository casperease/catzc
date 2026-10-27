# .ado/pipelines/variables/network-agent-pool.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `variables:`, written with `#`.

```text
The agent pool inside the hub virtual network (a Managed DevOps Pool or self-hosted agents): every job that writes a foundation vault,
whose public network access is off, runs on it and never on a Microsoft-hosted image. Declared once; each vault job reads it.
```
