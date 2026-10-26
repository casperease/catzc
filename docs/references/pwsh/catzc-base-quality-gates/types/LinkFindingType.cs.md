# pwsh/Base.QualityGates/types/LinkFindingType.cs

What the link engine found at one place in a file ([ADR-REPO-LINK](../../../../drs/repository/markdown-links.md)). The fixable types are
rewritten by `Format-Links` and reported by `Test-Links` until they are. The rest cannot be fixed mechanically and need a person. `Overlong`
is informational: a line that stays over its limit after the aligner did what it can.
