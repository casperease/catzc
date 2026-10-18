# pwsh/Catzc.Base.RootConfig/private/Get-RootConfigInputStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Hashes everything that feeds the root configs and everything they write, so an unchanged tree is one short comparison.

### description

One stamp over the inputs and the outputs of Build-RootConfig
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../adr/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)): every
source an entry declares, the loaded modules whose code renders the targets (RootConfig with its registry, VSCode, Git, and the two
Languages generators), and every existing target, so a target edited or deleted by hand changes the stamp too. For a wildcard entry the
folders its pattern can match are listed through the bounded walker
([ADR-PWSH-ENUM-RAWDOTNETENUMERATION](../../../../adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-rawdotnetenumeration)) and salt the
stamp, so a new test folder that would gain a file changes it; a link entry salts it with whether its link exists. Tests and READMEs under
the modules are left out: they change nothing that is rendered.

### parameter `Entries`

The opted-in root-config entries (Get-RootConfigTargets).

### outputs

`[string]` The stamp, a 64-digit hash.

### example 1

```powershell
Get-RootConfigInputStamp -Entries (Get-RootConfigTargets -Config (Get-Config -Config rootconfig))
```
