# pwsh/Base.QualityGates/private/Get-JavaScriptTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The test cases a JavaScript test folder declares, read from its `*.test.js` files without running node.

### description

The Language bridge discovers a language folder's cases with it, so each node test is a Pester case. A case is a top-level `test()` or
`test.skip()` call at the start of a line whose name is one string literal, what node reports as the case's name. The files are found up to
three levels below the folder and read in ordinal order. A case whose name starts with the JavaScript integrity prefix is in the `integrity`
category, every other one in `logic`. A test name is its title unless two files declare it; then every title carries its file.

### parameter `Folder`

The language test folder to read; it must exist.

### outputs

`[pscustomobject]` One per case: `Key` (the file and the name), `Package` (the file, relative to the folder), `Name`, `Category`
(`integrity` or `logic`) and `Title`.

## comment:1

Above `$declaration =...`, written with `#`.

```text
A case is a top-level test() call at the start of a line, its name one string literal: what node reports as the
case's name.
```
