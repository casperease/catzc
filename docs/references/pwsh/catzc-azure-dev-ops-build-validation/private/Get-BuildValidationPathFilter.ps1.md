# pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The ADO branch-policy path filters for a globset — its native trigger projection, anchored with '/'.

### description

The single place the build-validation policy's `filenamePatterns` is derived (used by both Register- and Unregister-AdoBuildValidation), so
the create side and the match-to-remove side always agree. Projects the globset to its GitHub-ordered native path list (Get-GlobSetTrigger,
[FDR-CD-GLOBS](../../../../adr/flow/durable-sha-globs.md)) — '!' negation and last-match-wins, which ADO branch-policy path filters
honour — and anchors each pattern with a leading '/', mapping '!p' to '!/p'. This is the same set of globs the pipeline triggers on; the
policy is the server-side pre-commit half of that binding
([FDR-CD-TYPE-PRECOMMITBUDGET](../../../../adr/flow/pipeline-types.md#rule-fdr-cd-type-precommitbudget)), never a committed
marker.

### parameter `GlobSet`

The globset to project.

### outputs

`[string[]]` The '/'-anchored path filters, in projection order.
