# pwsh/Catzc.Base.Asserts/Assert-PathExist.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a filesystem path exists.

### parameter `Path`

The path to test.

### parameter `PathType`

The kind of path to require: Any (default), Container, or Leaf.

### parameter `ErrorText`

Optional message to throw instead of the default.

### example 1

```powershell
Assert-PathExist './config.json'
```

### example 2

```powershell
Assert-PathExist './src' -PathType Container
```

## comment:1

Above `$message = if ($ErrorText) {`, written with `#`.

```text
Not $ErrorText ?? ... : a [string] param coerces $null to '', and ?? only coalesces $null, so the
default would never apply (the throw would be blank). See ADR: automatic-variable-pitfalls.
```

## comment:2

Above `$message = if ($ErrorText) {`, written with `#`.

```text
A [string] parameter turns $null into '', which ?? never coalesces, so only a truth test lets the default
message through.
```
