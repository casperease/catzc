# pwsh/Base.QualityGates/tests/Split-CommandLineBatch.Tests.ps1

The L0 logic test of `Split-CommandLineBatch`. In its batching case, `widget` and `gadget` cost 9 each (18). `sprocket` (11) would pass the
limit of 20, so it opens the next batch, which `gizmo` (8) joins.
