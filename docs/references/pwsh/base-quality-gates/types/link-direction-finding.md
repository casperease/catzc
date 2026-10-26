# pwsh/Base.QualityGates/types/LinkDirectionFinding.cs

A relation that points a way the rows do not allow. The first matching row denies it (`Row` counts from 1), no row allows it (`Row` is 0),
or an end has no endpoint, which is reported, never skipped.
