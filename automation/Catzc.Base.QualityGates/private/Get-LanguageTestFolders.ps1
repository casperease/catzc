<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
    folder: private
    name: get-language-test-folders
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
    cites:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-DSGN-TRACK#2
  config:
    synopsis: |-
      Lists the repository's test folders in every test language beside PowerShell, each mapped to the catzc module
      it tests.
    description: |-
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
    outputs: |-
      [pscustomobject] One record per test folder ({ Language; Module; Folder; Name }), by language (go, python, then
      bash) and ordinal by folder name within it: Language is go, python or bash, Module the catzc module name, Folder the
      absolute folder path, Name the folder name. Nothing when the repository has no such folder.
    examples:
      - Get-LanguageTestFolders | Where-Object Module -EQ 'Catzc.Base.Repository'
---
#>

function Get-LanguageTestFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $repositoryRoot = Get-RepositoryRoot
    # Each language's root and the file pattern that makes a folder under its tests/ a test folder.
    $languages = @(
        [pscustomobject]@{ Language = 'go'; Root = (Get-Config -Config go).ResolveRoot($repositoryRoot); Pattern = '*.go' }
        [pscustomobject]@{ Language = 'python'; Root = (Get-Config -Config python).ResolveRoot($repositoryRoot); Pattern = 'test_*.py' }
        [pscustomobject]@{ Language = 'bash'; Root = (Get-Config -Config bash).ResolveRoot($repositoryRoot); Pattern = '*.bats' }
    )

    $modulesByKebab = @{}
    foreach ($module in (Get-CatzcModule -TrackType modules).name) {
        $modulesByKebab[$module.ToLowerInvariant().Replace('.', '-')] = $module
    }

    $unmatched = [System.Collections.Generic.List[string]]::new()
    $records = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($language in $languages) {
        $testsRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $language.Root, 'tests'))
        if (-not [System.IO.Directory]::Exists($testsRoot)) {
            continue
        }
        $folders = @([System.IO.Directory]::GetDirectories($testsRoot))
        [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
        foreach ($folder in $folders) {
            $name = [System.IO.Path]::GetFileName($folder)
            if ($name.StartsWith('.')) {
                continue
            }
            # A module folder holds its test files directly or in a package one level down; the third level is headroom.
            if (-not @(Get-ChildPath $folder -File -Filter $language.Pattern -Depth 3).Count) {
                continue
            }
            if (-not $modulesByKebab.ContainsKey($name)) {
                $unmatched.Add("$($language.Root)/tests/$name/")
                continue
            }
            $records.Add([pscustomobject]@{
                    Language = $language.Language
                    Module   = $modulesByKebab[$name]
                    Folder   = $folder
                    Name     = $name
                })
        }
    }

    if ($unmatched.Count -gt 0) {
        throw "Test folder(s) matching no catzc module: $($unmatched -join ', '). A test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository for Catzc.Base.Repository)."
    }
    $records
}
