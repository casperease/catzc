# pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `approver_group:`, written with `#`.

```text
Approval checks, applied by Sync-AdoEnvironmentApprovals (docs/how-to/automation/apply-environment-approvals.md): each unit's
release-uat (RC) and pre-prod (RBC) gate, then the prod-tier environments. The apply creates an environment that does not exist yet.
```
