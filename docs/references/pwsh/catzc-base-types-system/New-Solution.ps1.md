# pwsh/Base.TypesSystem/New-Solution.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders catzc.sln, the solution of every C# project in the tree.

### description

The solution lists the types project (the IDE-only mirror of the combined type assembly) and every agent hook under .claude/hooks/ that
holds a .csproj, each hook nested under the .claude and hooks solution folders. Because the hooks are found on disk, a new hook enters the
solution on the next import, and the C# Dev Kit never asks to add a project. Each project and folder id is minted by ConvertTo-Guid from a
sentence of its name ("catzc types project", "record agent write hook project", "claude hooks folder"), so the ids are stable and readable,
and only the two Visual Studio type ids are registered in guids.yml. The RootConfig janitor writes the result to the root catzc.sln
(gitignored) on every load; a hand edit there is lost.

### example 1

```powershell
New-Solution | Set-Content out/catzc.sln.new -NoNewline
```

## comment:1

Above `$csharpType = '9A19103F-16F7-4668-BE54-9A1E7A4F7556'`, written with `#`.

```text
Every project id is minted from a sentence of its path, so a new hook enters the solution with its id the moment
its folder exists.
```
