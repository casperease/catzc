# pwsh/Base.QualityGates/tests/Build-CommentView.Tests.ps1

The tests of `Build-CommentView`, the inverse of `Export-Comments`. It writes the annotated copy of every file that has a comment page
under the view folder in `out/` ([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction)),
and each copy equals the file before its comments moved ([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)).
The cases run in isolation on a widget and gadget fixture repository in `$TestDrive`.
