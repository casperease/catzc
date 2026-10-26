# pwsh/Base.Languages/tests/Get-FileLanguage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-FileLanguage — the real repository'`, written with `#`.

```text
The real repository against both registries: the tracks (Catzc.Base.Variants, variants.yml) and the file languages
(configs/languages.yml). The tracked files come from the git index, read in-process (Get-GitTrackedPath, no git
process). The stack check ([DDR-TRACK-ONETECHSTACK](/docs/drs/design/tracks.md#rule-ddr-track-onetechstack)) reads the live aspect
only: a track's tests aspect (Get-Aspect), a
vendored .vendor/ folder, and a verification track ship nothing, so they are never a second tech-stack.
```

## comment:2

Above `$script:globRegex = {`, written with `#`.

```text
A glob of the aspects variant as an anchored regex: '**/' is any folder prefix, '**' anything, '*' and '?'
stay inside one segment.
```

## comment:3

Above `$script:isLive = {`, written with `#`.

```text
Is a tracked file of a track in its live aspect? Its unit is the track root's first folder (a module, a
template folder); a file directly under the track root is its own unit. A track without an aspects entry is
live throughout.
```

## comment:4

Above `$folders = @($script:tracked | Where-Object { $_.Contains('/') } |...`, written with `#`.

```text
A track's places may sit below its root folder (infrastructure/templates), so the folders are checked, not the
root folders.
```
