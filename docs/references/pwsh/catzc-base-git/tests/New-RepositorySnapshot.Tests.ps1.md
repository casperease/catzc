# pwsh/Base.Git/tests/New-RepositorySnapshot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'New-RepositorySnapshot'`, written with `#`.

```text
L2: drives real git against a throwaway repository that holds every working-tree state a snapshot must
reproduce — staged, unstaged, staged-then-edited, untracked, deleted, ignored — plus LF bytes under
core.autocrlf=true (a checkout would rewrite them as CRLF; the snapshot must not).
```
