# pwsh/.scriptanalyzer/tests/Test-AnalyzedFileIsTest.Tests.ps1

The tests of `Test-AnalyzedFileIsTest`, the one test-file check the custom analyzer rules share. It answers by file name when the analyzer
reads a file (the quality gate) and by Pester structure when it reads an editor buffer with no file name (VS Code).
