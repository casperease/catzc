---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Invoke-InSubscription.ps1.md
    kind: reference
    body_sha: "27fef377ecb7"
    adrs: []
---

# automation/Catzc.Azure.Cli/Invoke-InSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Captures the active subscription (Get-CurrentAzSubscription), switches to the target
(Set-CurrentAzSubscription), invokes the script block, and restores the original subscription in a
finally so it is restored even if the block throws. The block's output streams through unchanged.

If the session is already on the target (matched by Id or Name) the switch is skipped entirely and the
block runs without touching — or restoring — context.

Restore semantics: a failure to restore is only downgraded to a warning when the block itself threw,
so the block's real error isn't masked by a cleanup failure. If the block succeeded and only the
restore failed, that restore error is thrown (fail-early — it's the only failure in flight).
```
