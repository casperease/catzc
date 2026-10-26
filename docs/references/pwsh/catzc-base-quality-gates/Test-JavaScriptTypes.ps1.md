# pwsh/Catzc.Base.QualityGates/Test-JavaScriptTypes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:2

Above `$projects = @('jsconfig.json', 'jsconfig.lenient.json')`, written with `#`.

```text
The editor's project and the lenient one beside it; the lenient one holds no file once every module is raised, which tsc reports
as no inputs and the loop below takes as nothing to check.
```

## comment:3

Above `$pattern = '^(?<file>.+?)\((?<line>\d+),(?<column>\d+)\): error...`, written with `#`.

```text
tsc prints one line per error, path(line,col): error TS<number>: message; exit 0 is clean, 1 or 2 is errors, anything
else is tsc failing.
```

## comment:4

Above `$lines = @($check.Output -split '\r?\n')`, written with `#`.

```text
A project left with no files (every module raised out of the lenient one) has nothing to check, which tsc
reports as TS18003.
```
