# pwsh/Base.QualityGates/private/Get-LanguageTestFolders.ps1

Finds the repository's test folders in every test language beside PowerShell and maps each to the module it tests. It throws on a test
folder that matches no module, because an unmapped folder would never run.

## help

### synopsis

Lists the repository's test folders in every test language beside PowerShell, each mapped to the catzc module it tests.

### description

The test languages are test artifacts only, each in a root verification track of its own
([DDR-TRACK-ONETRACKTYPE](../../../../drs/design/tracks.md#rule-ddr-track-onetracktype)):

```text
go      <goRoot>/tests/<folder>/ holding at least one .go file (the folders New-GoWorkspace renders a go.mod
        for); the Go root is go.yml's, through GoConfig.ResolveRoot: the declared root, else go/ when the
        repository has one, else .go/ ([ADR-AUTO-GO-ONEGOROOT](/docs/drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-onegoroot));
python  <pythonRoot>/tests/<folder>/ holding at least one test_*.py file; the Python root is python.yml's,
        through PythonConfig.ResolveRoot, by the same convention: python/ when present, else .python/
        ([ADR-AUTO-PY-ONEPYTHONROOT](/docs/drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonroot));
bash    <bashRoot>/tests/<folder>/ holding at least one .bats file; the Bash root is bash.yml's, through
        BashConfig.ResolveRoot: bash/ when present, else .bash/
        ([ADR-AUTO-BASH-ONEBASHROOT](/docs/drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-onebashroot)).
```

A folder whose name starts with '.' is never a test folder. Each folder is named for its catzc module in kebab case — the module name
lowercased, with dots replaced by hyphens (Catzc.Base.Repository -> catzc-base-repository) — and maps back to the module folder under
`<repository>/automation/` of that kebab name. The harness runs a mapped folder's tests as part of that module's tests
(Get-TestAutomationTestPaths, the language bridge).

Throws, naming every such folder, when a test folder matches no catzc module: an unmapped folder would otherwise never run.

### outputs

`[pscustomobject]` One record per test folder ({ Language; Module; Folder; Name }), by language (go, python, then bash) and ordinal by
folder name within it: Language is go, python or bash, Module the catzc module name, Folder the absolute folder path, Name the folder name.
Nothing when the repository has no such folder.

### example 1

```powershell
Get-LanguageTestFolders | Where-Object Module -EQ 'Catzc.Base.Repository'
```

## modules by test folder

A test folder is named for its module's folder, which drops the track's namespace
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)). For each language with a test runner the
function builds a map from the folder name that `TestFolderOf` of `languages.yml` gives to the module it names, over the modules of the
engine track, so a folder maps back to the module it tests. The language's root comes from its own config, its test-file pattern from the
registry, and the folder name is in the language's folder case.

## the test holder

The track's own test holder is a folder of the language root named by the languages registry. It holds one folder per module, testing the
module from outside. A folder whose name starts with a dot is skipped. A folder with no test file is skipped too.

## where test files sit

A module folder holds its test files directly or in a package one level down. The search goes three levels deep, so the third level is
headroom.

## a module's own tests

A module of the language's own track that is a folder and has its own `tests/` folder with a matching test file runs that folder too. This
is the shared layout row every module has.
