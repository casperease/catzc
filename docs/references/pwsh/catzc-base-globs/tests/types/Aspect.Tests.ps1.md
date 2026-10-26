# pwsh/Base.Globs/tests/types/Aspect.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Aspect / AspectPartition'`, written with `#`.

```text
Aspects ([DDR-ASPECT](/docs/drs/design/module-aspects.md)): the ordered first-match partition of a unit's tracked
files. Compile encodes each
aspect as a leaf scan program (own patterns as include, earlier aspects' patterns as exclude); the last
aspect ('**') becomes the non-live catch-all remainder. Validate re-checks disjoint + exhaustive.
```
