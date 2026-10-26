# pwsh/Catzc.Base.VSCode/tests/catzc-track-lamps.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `It 'answers every shared vector of the lamp language: the files shown, the...`, written with `#`.

```text
The engine-core cases run in node: js/catzc-track-lamps/tests/ (Invoke-JavaScriptTest); the shared vectors stay
here, read from yml.
```

## comment:2

Above `$modules = Get-CatzcModulesFolder`, written with `#`.

```text
Aspects belong to units, so only a unit's tests are in scope; vendored code is no unit, its test folders are
tools.
```

## comment:3

Above `$tagged = @((Get-Config -Config languages).languages | Where-Object tag |...`, written with `#`.

```text
Every tagged language of the languages config is a lamp of its own, lang-<name>, with a lamp's commands,
rendered icons and menu items.
```
