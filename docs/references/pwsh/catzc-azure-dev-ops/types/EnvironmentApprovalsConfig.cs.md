# pwsh/Azure.DevOps/types/EnvironmentApprovalsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:2

Above `public string[] Environments(Catzc.Base.Flow.RungsConfig rungs)`, written with `//`.

```text
The ADO environments that carry the approval check: `<unit>-<rung>` for every unit and every rung behind a release gate (RC, RBC),
then the prod-tier environments. The rung names come from the rungs registry, so the environment names follow it. The apply creates
one that does not exist yet.
```
