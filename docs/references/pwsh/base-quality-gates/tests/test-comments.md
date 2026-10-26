# pwsh/Base.QualityGates/tests/Test-Comments.Tests.ps1

The test of `Test-Comments`, the gate that every long comment lives in its file's comment page and every section still names a code line of
the file ([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). It runs in isolation on a
widget and gadget fixture repository in `$TestDrive`, and each case breaks the page or the file one way.
