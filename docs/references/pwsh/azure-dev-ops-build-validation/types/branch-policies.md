# pwsh/Azure.DevOps.BuildValidation/types/BranchPolicies.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class BranchPolicies : Catzc.Base.Objects.DictionaryRecord`, written with `//`.

```text
The pull-request policies of the guarded branch: who must approve and how a pull request merges. Every key is optional and takes the
default declared here, so a team raises the floor in its own config.
```
