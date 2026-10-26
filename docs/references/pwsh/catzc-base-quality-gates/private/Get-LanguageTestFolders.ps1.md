# pwsh/Base.QualityGates/private/Get-LanguageTestFolders.ps1

Finds the repository's test folders in every test language beside PowerShell and maps each to the module it tests. It throws on a test
folder that matches no module, because an unmapped folder would never run.

## help

### synopsis

Lists the repository's test folders in every test language the languages registry declares, each mapped to the catzc module it tests.

### description

The test languages are the languages the languages registry (`languages.yml`) gives a `tests` entry, each in a root verification track of
its own ([DDR-TRACK-ONETRACKTYPE](../../../../drs/design/tracks.md#rule-ddr-track-onetracktype)). A language's root comes from its own
config (`ResolveRoot`), and its test files are the ones its `tests.pattern` matches.

Each language root holds a test holder, the registry's test folder, with one folder per catzc module of the engine track. A folder is named
for its module's folder in the language's folder case, as the registry's `TestFolderOf` gives it (Catzc.Base.Repository, folder
Base.Repository, is base_repository in snake case, baserepository in flat, base-repository in kebab), and maps back to that module. A folder
whose name starts with '.' is never a test folder, and one holding no test file within three levels is skipped. A folder module of the
language's own track that has its own test folder with a test file is listed too. The harness runs a mapped folder's tests as part of that
module's tests (Get-TestAutomationTestPaths, the language bridge).

Throws, naming every such folder, when a test folder matches no catzc module: an unmapped folder would otherwise never run.

### outputs

`[pscustomobject]` One record per test folder ({ Language; Module; Folder; Name }), by language in registry order: Language is the
language's name, Module the catzc module name, Folder the absolute folder path, Name the folder name. Nothing when the repository has no
such folder.

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
