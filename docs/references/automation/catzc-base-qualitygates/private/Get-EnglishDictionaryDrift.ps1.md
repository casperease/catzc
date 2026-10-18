# automation/Catzc.Base.QualityGates/private/Get-EnglishDictionaryDrift.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reports why the committed English word list is stale, from its stamp alone — no node round-trip.

### description

Build-EnglishDictionary's -DryRun re-flattens cspell's bundled tries (node, npx, cspell), so the drift check
reads the committed artifact's stamp instead: the gz and its stamp both exist, the stamp's cspell version
matches the pinned cspell version, and the stamp's word count matches the gz's line count. Each failure is
one reason; none means the list is current. Test-GeneratedFiles turns each reason into one issue.

### parameter AssetsFolder

The folder holding english.txt.gz and english.stamp (the QualityGates module's assets/ in the repository).

### parameter PinnedCspell

The cspell version tools.yml pins (a prefix: '10' matches a stamp of '10.0.1').

### outputs

`[string[]]` One reason per drift found; nothing when the committed list is current.

### example 1

```powershell
Get-EnglishDictionaryDrift -AssetsFolder (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets') -PinnedCspell '10'
```
