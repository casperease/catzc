# docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The test languages are test artifacts only, each in a root verification track of its own
([ADR-DSGN-TRACK#2](/docs/adr/design/tracks.md#rule-adr-dsgn-track2)):

  go      <goRoot>/tests/<folder>/ holding at least one .go file (the folders New-GoWorkspace renders a go.mod
          for); the Go root is go.yml's, through GoConfig.ResolveRoot: the declared root, else go/ when the
          repository has one, else .go/ ([ADR-AUTO-GO#2](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2));
  python  <pythonRoot>/tests/<folder>/ holding at least one test_*.py file; the Python root is python.yml's,
          through PythonConfig.ResolveRoot, by the same convention: python/ when present, else .python/
          ([ADR-AUTO-PY#2](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py2));
  bash    <bashRoot>/tests/<folder>/ holding at least one .bats file; the Bash root is bash.yml's, through
          BashConfig.ResolveRoot: bash/ when present, else .bash/
          ([ADR-AUTO-BASH#2](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)).

A folder whose name starts with '.' is never a test folder. Each folder is named for its catzc module in kebab
case — the module name lowercased, with dots replaced by hyphens (Catzc.Base.Repository ->
catzc-base-repository) — and maps back to the module folder under <repository>/automation/ of that kebab name.
The harness runs a mapped folder's tests as part of that module's tests (Get-TestAutomationTestPaths, the
language bridge).

Throws, naming every such folder, when a test folder matches no catzc module: an unmapped folder would
otherwise never run.
```

## comment:2

Above `$modulesByKebab = @{}`.

```text
The catzc modules of the source tree, by kebab name: the folders under <repository>/automation/, read from the
repository (never the code root), so a build run maps a test folder the same way a source run does.
```
