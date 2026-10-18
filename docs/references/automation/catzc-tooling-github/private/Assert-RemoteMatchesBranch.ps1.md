# automation/Catzc.Tooling.Github/private/Assert-RemoteMatchesBranch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a freshly pushed remote holds exactly the local branch — every ref it advertises points at the branch's commit.

### description

The post-push verification behind Publish-CleanHistory and Reset-GitHubRepository. Git names every commit by the hash of its content and
history, so a remote ref at the same commit as the local branch carries the same history, object for object. Comparing the advertised refs
(`git ls-remote`, a few hundred bytes) against the local commit therefore proves what the server stored without downloading it, and the
token scan runs on the local branch instead of a mirror clone. A ref at any other commit is history the local scan never covered, so it
fails the check.

### parameter Url

The remote to read, as a clone URL.

### parameter Branch

The local branch that was pushed.

### parameter RepositoryPath

The local clone the branch lives in.

### parameter TimeoutSeconds

How long the network read may run; the caller passes its own limit.

### outputs

`[string]` The commit every remote ref points at.
