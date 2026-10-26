# pwsh/Catzc.Base.Languages/New-JsConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$config = if ($Target -eq 'jsconfig.strict.json') {`, written with `#`.

```text
The strict project extends the lenient one and checks only the raised modules; the lenient one leaves them out, so each file is
checked once, in its module's mode (tsc has no per-folder strict).
```

## comment:2

Above `module           = 'node16'`, written with `#`.

```text
node16 is node's own resolution: a .js file outside a "type": "module" package is CommonJS, so require resolves as node
does, and no deprecated resolution mode is implied.
```
