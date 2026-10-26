# pwsh/Base.Git/Push-Topic.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lands the topic as one commit on the current server HEAD and pushes it, at the user's hand.

### description

The push step of the git topic flow ([FDR-GIT-SQUASHREBASESQUASH](../../../drs/flow/git-topic-flow.md#rule-fdr-git-squashrebasesquash)):
Save-Topic commits pending changes, the topic is squashed to one commit over its merge base with the current server HEAD, rebased onto that
HEAD, squashed again, and asserted to be exactly one commit ahead and none behind
([FDR-GIT-ONESQUASHEDCOMMIT](../../../drs/flow/git-topic-flow.md#rule-fdr-git-onesquashedcommit)). It then pushes by the workspace variant:
main-via-pr pushes the topic branch with --force-with-lease, its own history being the author's
([FDR-GIT-TOPICHISTORYISTHEAUTHORS](../../../drs/flow/git-topic-flow.md#rule-fdr-git-topichistoryistheauthors)); main-direct fast-pushes the
one commit to main, and a rejected push stops with the commit kept
([FDR-CD-LIFE-FASTPUSHLANDS](../../../drs/flow/commit-lifecycle.md#rule-fdr-cd-life-fastpushlands)). Main is never forced. It runs git that
changes the repository, so only the user invokes it ([FDR-GIT-USERRUNSGIT](../../../drs/flow/git-topic-flow.md#rule-fdr-git-userrunsgit)). A
conflict stops it like Sync-Topic.

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
