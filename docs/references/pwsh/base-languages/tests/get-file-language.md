# pwsh/Base.Languages/tests/Get-FileLanguage.Tests.ps1

The tests of `Get-FileLanguage`, including a run against the real repository and both registries: the tracks (`Catzc.Base.Variants`,
`variants.yml`) and the file languages (`configs/languages.yml`). The tracked files come from the git index, read in-process
(`Get-GitTrackedPath`, no git process).

## The tech-stack check

The stack check ([DDR-TRACK-ONETECHSTACK](../../../../drs/design/tracks.md#rule-ddr-track-onetechstack)) reads the live aspect only: a
track's tests aspect (`Get-Aspect`), a vendored `.vendor/` folder and a verification track ship nothing, so they are never a second
tech-stack.

- A glob of the aspects variant is turned into an anchored regular expression: `**/` is any folder prefix, `**` anything, and `*` and `?`
  stay inside one segment.
- A tracked file is live when its track's live aspect holds it. Its unit is the track root's first folder (a module, a template folder); a
  file directly under the track root is its own unit. A track without an aspects entry is live throughout.
- A track's places may sit below its root folder (`infrastructure/templates`), so the folders are checked, not the root folders.
