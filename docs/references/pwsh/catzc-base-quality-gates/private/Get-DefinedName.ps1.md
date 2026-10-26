# pwsh/Catzc.Base.QualityGates/private/Get-DefinedName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the functions and types each given file defines, by name, as its language defines them.

### description

The one parse of a file's definitions for every name check. For each path whose language has a `naming:` entry with function or type cases
in the languages config, it returns one object per definition: PowerShell by its parser (`FunctionDefinitionAst`, `TypeDefinitionAst`),
Python and Go by their definition keywords at the start of a line. A missing file, or a language without a reader, yields nothing.

A PowerShell function name comes back without its scope qualifier: `FunctionDefinitionAst.Name` keeps the `script:`, `global:`, `local:` or
`private:` prefix (`script:New-Widget`), and this strips it, so the name is the verb-noun the case is judged on. A name check calls this
function and never strips a qualifier by hand.

### parameter `Path`

Repository-relative paths of the files to read.

### parameter `RepositoryRoot`

The root the paths resolve against. Defaults to Get-RepositoryRoot.

### outputs

`[pscustomobject]` Per definition, @{ Path; Kind; Name }, Kind being `function` or `type`.

### example 1

```powershell
Get-DefinedName -Path 'pwsh/Catzc.Base.Files/Get-CodeCaller.ps1'
```

## comment:1

Above `$patterns = @{`, written with `#`.

```text
How each language defines a function or a type is mechanism, one reader per language: PowerShell by its parser, Python and Go by
their definition keywords at the start of a line.
```

## comment:2

Above `[pscustomobject]@{ Path = $relative; Kind = 'function'; Name =...`, written with `#`.

```text
A scope qualifier sits outside the case, as a hidden folder's dot does: script:New-Widget is a
verb-noun name.
```
