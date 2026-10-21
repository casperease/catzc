# pwsh/Catzc.Azure.DevOps/types/EnvironmentApprovalsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string[] environments { get; }`, written with `//`.

```text
The ADO environments that need an approval before a run deploys to them, in file order: each unit's release-uat (RC) and pre-prod
(RBC), and the prod-tier environments. The apply creates one that does not exist yet.
```

## comment:2

Above `public string[] Environments(Catzc.Base.Flow.RungsConfig rungs)`, written with `//`.

```text
The ADO environments that carry the approval check: `<unit>-<rung>` for every unit and every rung behind a release gate (RC, RBC),
then the prod-tier environments. The rung names come from the rungs registry, so the environment names follow it.
```
