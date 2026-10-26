# pwsh/.scriptanalyzer/Test-AnalyzedFileIsTest.ps1

The shared test for whether the file under analysis is a Pester test file. It is dot-sourced into the check modules that exempt test files,
and answers by file name for the quality gate and by Pester structure for an editor buffer.

## help

### synopsis

Whether the code under analysis is a Pester test file — the one scope test the custom checks share.

### description

Several checks exempt test files, which change state, read raw variables, and use short names on purpose. The Test-ScriptAnalyzer quality
gate runs on files, so the file name decides: a `*.Tests.ps1` file, or (for a check that asks) a file under a tests/ folder. VS Code's
PowerShell extension analyzes the open editor buffer instead, as a script definition with no file name, so the name cannot decide there.
Then the content does: a Pester test file calls Describe, and no automation code does. Every check asks this one function, so the quality
gate and the editor agree.

Dot-sourced into each check module, so it runs in that module's scope and changes no session state.

### parameter `ScriptBlockAst`

Any block of the code under analysis; the whole buffer is searched from its root.

### parameter `IncludeTestsFolder`

Also count a file under a tests/ folder (a fixture or helper beside the tests).

### outputs

`[bool]`
