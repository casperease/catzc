# pwsh/Base.QualityGates/private/Get-JavaScriptTestCases.ps1

The language bridge's discovery for JavaScript: it lists the test cases a test folder declares by reading its `*.test.js` files, so each
node test becomes a Pester case without running node.

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

## what a case is

A case is a top-level `test()` or `test.skip()` call at the start of a line, with its name as one string literal. That literal is what node
reports as the case's name, so the result pairs with the case. A name that starts with the JavaScript integrity prefix is in the `integrity`
category and every other one is in `logic`.

## titles

A test's title is its name unless two files declare the same name. Then every title of that name carries its package, the file's path inside
the folder, so the titles stay distinct.
