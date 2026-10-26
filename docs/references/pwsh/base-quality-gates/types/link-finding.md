# pwsh/Base.QualityGates/types/LinkFinding.cs

One finding of the link engine: where (repository-relative file, 1-based line and column), which link kind, what was found, a human message,
and the replacement text the aligner writes (empty when it cannot fix it).
