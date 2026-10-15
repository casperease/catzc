# docs/references/automation/catzc-base-repository/Get-RunEnvironment.ps1.md

`automation/Catzc.Base.Repository/Get-RunEnvironment.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The environment axis of devbox/pipeline parity
([ADR-AUTO-PARITY](/docs/adr/automation/devbox-pipeline-parity.md)), read off the one seam,
Test-IsRunningInPipeline. It answers where the run happens; who drives it (a person or an agent) is
Get-SessionActor's question. Environment-dependent settings, such as the time-safeguard limits, key on this.
```

## comment:2

Section `.PARAMETER EnvironmentAssertIs` of the comment-based help.

```text
Pins the expected environment: the detected one is still returned, and a different one throws. The guard
verifies, it never selects.
```
