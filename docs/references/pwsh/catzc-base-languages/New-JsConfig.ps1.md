# pwsh/Base.Languages/New-JsConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$config = if ($Target -eq 'jsconfig.lenient.json') {`, written with `#`.

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

## comment:3

Above `[ValidateSet('jsconfig.json', 'jsconfig.lenient.json')]`, written with `#`.

```text
jsconfig.json, the project the editor reads, or jsconfig.lenient.json, the modules javascript.yml's strict list does not
name yet.
```

## comment:4

Above `$config = if ($Target -eq 'jsconfig.lenient.json') {`, written with `#`.

```text
The editor reads only jsconfig.json, so it always covers files: the raised modules, strictly, or every module, leniently, while none
is raised. The lenient project extends it with whatever is left, which is nothing once every module is raised.
```

## comment:5

Above `$track = Get-Track -Path $root`, written with `#`.

```text
The strict list names extensions; each one's folder drops the js track's namespace
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)). When every extension
of the track is strict, the one glob of the whole track says so; the extensions are listed only while some stay lenient.
```
