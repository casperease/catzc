# pwsh/Base.QualityGates/configs/link-directions.yml

The direction rules for links: which way a relation between two files may point.

## Rows

Rows read top to bottom, and the first match decides. A relation that no row allows is denied
([ADR-REPO-LINKS-DIRECTIONSAREROWS](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-directionsarerows)).
Test-LinkDirections applies them.
