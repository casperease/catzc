# pwsh/Base.QualityGates/tests/Test-Links.Repository.Tests.ps1

The integrity checks that the real repository keeps its links aligned and resolving
([ADR-REPO-LINK](../../../../drs/repository/markdown-links.md)). They run over the shipped tree in two tiers. L1 is the fast structural pass
over the automation code's comments. L2 is the full pass over every git-tracked file, covering every markdown target and `#fragment`, plus
the formatter-stable check and the editor rule that makes code links clickable. Rule-tag citations and analyzer mappings are validated
elsewhere, in `Get-TestTagViolations` and `Get-AnalyzerDrsCoverage`.
