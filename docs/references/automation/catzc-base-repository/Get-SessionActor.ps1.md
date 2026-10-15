# docs/references/automation/catzc-base-repository/Get-SessionActor.ps1.md

`automation/Catzc.Base.Repository/Get-SessionActor.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one answer every actor-dependent behaviour reads, so the policy lives in one place
([ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)). A CI/CD pipeline
(Test-IsRunningInPipeline) wins over an agent, because an agent's run inside a pipeline is still a pipeline run;
otherwise an AI coding agent (Test-IsRunningAsAgent); otherwise a person at a devbox. A person may change the
machine and the repository on their own behalf — stop their stale sessions, commit generated files — while an
agent leaves both to the person, and a pipeline only asserts.
```

## comment:2

Section `.PARAMETER ActorAssertIs` of the comment-based help.

```text
Pins the expected actor: the detected actor is still returned, and a different one throws. The guard verifies,
it never selects.
```
