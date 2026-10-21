# pwsh/Catzc.Base.Git/Push-Topic.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lands the topic as one commit on the current server HEAD and pushes it, at the user's hand.

### description

The push step of the git topic flow
([ADR-FLOW-GIT-SQUASHREBASESQUASH](../../../adr/flow/git-topic-flow.md#rule-adr-flow-git-squashrebasesquash)): Save-Topic commits pending
changes, the topic is squashed to one commit over its merge base with the current server HEAD, rebased onto that HEAD, squashed again, and
asserted to be exactly one commit ahead and none behind
([ADR-FLOW-GIT-ONESQUASHEDCOMMIT](../../../adr/flow/git-topic-flow.md#rule-adr-flow-git-onesquashedcommit)). It then pushes by the workspace
variant: main-via-pr pushes the topic branch with --force-with-lease, its own history being the author's
([ADR-FLOW-GIT-TOPICHISTORYISTHEAUTHORS](../../../adr/flow/git-topic-flow.md#rule-adr-flow-git-topichistoryistheauthors)); main-direct
fast-pushes the one commit to main, and a rejected push stops with the commit kept
([ADR-FLOW-CD-LIFE-FASTPUSHLANDS](../../../adr/flow/commit-lifecycle.md#rule-adr-flow-cd-life-fastpushlands)). Main is never forced. It runs
git that changes the repository, so only the user invokes it
([ADR-FLOW-GIT-USERRUNSGIT](../../../adr/flow/git-topic-flow.md#rule-adr-flow-git-userrunsgit)). A conflict stops it like Sync-Topic.

### parameter `Message`

The message of the one commit. Default: `...`.

### parameter `Config`

The git flow config. Default: Get-Config -Config git.

### parameter `RepositoryRoot`

The clone to push from. Default: the loaded repository root.

### outputs

`[pscustomobject]` Branch, Target (the ref pushed to) and Commit (the one commit pushed).

### example 1

```powershell
Push-Topic -Message 'Spin the widget'
```
