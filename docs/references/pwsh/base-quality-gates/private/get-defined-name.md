# pwsh/Base.QualityGates/private/Get-DefinedName.ps1

The one parse of a file's definitions for every name check: it returns the functions and types each given file defines, by name, as the
file's language defines them. A name check never reads definitions by hand.

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
Get-DefinedName -Path 'pwsh/Base.Files/Get-CodeCaller.ps1'
```

## one reader per language

How a language defines a function or a type is mechanism, so each language has one reader. PowerShell is read by its parser. Python and Go
are read by their definition keywords at the start of a line: `def` and `class` for Python, `func` and `type` for Go.

## scope qualifiers

A PowerShell function name loses its scope qualifier. The qualifier sits outside the case, as a hidden folder's dot does, so
`script:New-Widget` is judged as the verb-noun name `New-Widget`.
