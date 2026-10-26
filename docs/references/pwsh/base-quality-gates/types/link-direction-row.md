# pwsh/Base.QualityGates/types/LinkDirectionRow.cs

One direction of the link-direction config: the relations it covers (none listed covers all three), `from`, `to`, its verdict, and the rule
code that decides it. The code is required, because a finding prints it (ADR-REPO-LINKS-DIRECTIONSAREROWS).
