# pwsh/Base.QualityGates/types/LinkDirectionEngine.cs

Judges each relation against the direction rows: the first matching row decides, and a relation no row allows is denied
(ADR-REPO-LINKS-DIRECTIONSAREROWS). It is pure: the edges, the endpoints and the config are passed in, and it reads no file and no config.
