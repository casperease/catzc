# pwsh/Catzc.Base.Git/Save-Topic.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Commits every change of the working tree to the topic branch, at the user's hand.

### description

The commit step of the git topic flow ([git-topic-flow](../../../drs/flow/git-topic-flow.md)): it stages every change and commits it with
the message, `...` when none is given. It runs git that changes the repository, so only the user invokes it
([FDR-GIT-USERRUNSGIT](../../../drs/flow/git-topic-flow.md#rule-fdr-git-userrunsgit)). It refuses a detached HEAD, and in a
main-via-pr workspace a main branch, since a change reaches main through a pull request there. A clean tree is left as it is.

### parameter `Message`

The commit message. Default: `...`, the one place the empty-message default lives.

### parameter `Config`

The git flow config. Default: Get-Config -Config git.

### parameter `RepositoryRoot`

The clone to commit in. Default: the loaded repository root.

### outputs

`[pscustomobject]` Branch, Saved (whether a commit was made) and Message.

### example 1

```powershell
Save-Topic -Message 'Spin the widget'
```
