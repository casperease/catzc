<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
    folder: tests
    name: test-generated-files-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Test-GeneratedFiles.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-FILEMETA-COMPOSEDFILES
---
#>

Describe 'Test-GeneratedFiles' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Build-AdrIndex -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/index.md'; Changed = $false; DryRun = $true } }
        Mock Build-Glossary -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/glossary.md'; Changed = $false; DryRun = $true; ConceptCount = 2 } }
        Mock Build-Readme -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Folder = 'widget'; Source = 'docs/widget.md'; Readme = 'widget/README.md'; Changed = $false; DryRun = $true } }
        Mock Build-ContractReference -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/contracts/widget.md'; Changed = $false; DryRun = $true } }
        Mock Build-GitKeep -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'widget/.gitkeep'; Changed = $false; DryRun = $true } }
        Mock Build-TerminologyDictionary -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Category = 'widget'; Path = '.cspell/widget.txt'; WordCount = 3; Changed = $false; DryRun = $true } }
        Mock Get-ConfigValue -ModuleName Catzc.Base.QualityGates { '10' }
        Mock Get-EnglishDictionaryDrift -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Stamped = 2; Unstamped = [string[]] @('docs/widget/plain.md'); Issues = [string[]] @() } }
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $false; DryRun = $true }
            [pscustomobject]@{ Target = 'gadget.json'; Source = 'assets/gadget.json'; Generator = $null; Changed = $false; DryRun = $true }
        }
        $script:reportFolder = Join-Path $TestDrive 'generated-files'
    }

    It 'passes a tree where no generator would change a file' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-GeneratedFiles -OutputFolder $script:reportFolder } | Should -Not -Throw
        Should -Invoke Build-AdrIndex -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun -and $PassThru }
        Should -Invoke Build-RootConfig -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun -and $PassThru }
    }

    It 'throws once listing every stale file with its generator and regenerate command' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Build-GitKeep -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Path = 'widget/.gitkeep'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Path = 'gadget/.gitkeep'; Changed = $true; DryRun = $true }
        }
        Mock Build-AdrIndex -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/index.md'; Changed = $true; DryRun = $true } }

        $thrown = { Test-GeneratedFiles -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-GeneratedFiles failed: 3 issue(s)*'
        $thrown.Exception.Message | Should -BeLike '*docs/widget/index.md: stale — Build-AdrIndex would change it; regenerate with: Build-AdrIndex*'
        $thrown.Exception.Message | Should -BeLike '*widget/.gitkeep: stale — Build-GitKeep*'
        $thrown.Exception.Message | Should -BeLike '*gadget/.gitkeep: stale — Build-GitKeep*'
    }

    It 'returns the result with the generator count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Build-Readme -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Folder = 'widget'; Source = 'docs/widget.md'; Readme = 'widget/README.md'; Changed = $true; DryRun = $true } }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'generated-files'
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -Be 'widget/README.md: stale — Build-Readme would change it; regenerate with: Build-Readme'
        $known = InModuleScope Catzc.Base.QualityGates { @(Get-GeneratedFileGenerator).Count }
        $result.Facts['Generators'] | Should -Be $known -Because 'the count is every writer of generated-files.yml plus every root-file generator of rootconfig.yml'
    }

    It 'reports a generated file whose head stamp is not the hash of its body, and counts the stamped and unstamped files' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        Mock Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Stamped = 3; Unstamped = [string[]] @('docs/widget/plain.md'); Issues = [string[]] @('docs/widget/index.md: stale — the head''s with_body_sha 000000000000 is not the hash of the body, 111111111111; regenerate the file with its writer') }
        }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike 'docs/widget/index.md: stale — the head''s with_body_sha 000000000000*'
        $result.Facts['Stamped'] | Should -Be 3
        $result.Facts['Unstamped'] | Should -Be 1
        Should -Invoke Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates -Times 1
    }

    It 'lists the writers of generated-files.yml and the generators of rootconfig.yml, so no generator is left out' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $known = InModuleScope Catzc.Base.QualityGates { Get-GeneratedFileGenerator }
        $known | Should -Contain 'Build-AdrIndex'
        $known | Should -Contain 'Build-RootConfig'
        $known | Should -Contain 'New-PythonProject'
        @($known | Select-Object -Unique).Count | Should -Be $known.Count

        $rootGenerators = @((Get-Config -Config rootconfig).files | Where-Object { $_.optIn -and $_.generator } | ForEach-Object { "$($_.generator)" } | Select-Object -Unique)
        foreach ($name in $rootGenerators) {
            $known | Should -Contain $name
        }
    }

    It 'throws naming the known generators when a generator is unknown' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $thrown = { Test-GeneratedFiles -Generator Build-Widget -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike "Unknown generator 'Build-Widget'. The generators are: Build-AdrIndex*"
    }

    It 'attributes a rendered root file to its generator and a copied one to Build-RootConfig' {
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'gadget.json'; Source = 'assets/gadget.json'; Generator = $null; Changed = $true; DryRun = $true }
        }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Contain "widget.json: stale — New-VsCodeSettings would change it; regenerate with: Build-RootConfig 'widget.json'"
        $result.Issues | Should -Contain "gadget.json: stale — Build-RootConfig would change it; regenerate with: Build-RootConfig 'gadget.json'"
    }

    It 'checks only the selected generators, and a rendered generator selects only its own root files' {
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'gadget.json'; Source = 'assets/gadget.json'; Generator = $null; Changed = $true; DryRun = $true }
        }

        $result = Test-GeneratedFiles -Generator New-VsCodeSettings -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @("widget.json: stale — New-VsCodeSettings would change it; regenerate with: Build-RootConfig 'widget.json'")
        $result.Facts['Generators'] | Should -Be 1
        Should -Invoke Build-AdrIndex -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Get-EnglishDictionaryDrift -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'selects New-GoWorkspace by name and reports each stale file of a multi-file generator on its own' {
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'go.work'; Source = $null; Generator = 'New-GoWorkspace'; Changed = $false; DryRun = $true }
            [pscustomobject]@{ Target = 'go/tests/widget/go.mod'; Source = $null; Generator = 'New-GoWorkspace'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'go/tests/gadget/go.mod'; Source = $null; Generator = 'New-GoWorkspace'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $true; DryRun = $true }
        }

        $result = Test-GeneratedFiles -Generator New-GoWorkspace -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            "go/tests/widget/go.mod: stale — New-GoWorkspace would change it; regenerate with: Build-RootConfig 'go/tests/widget/go.mod'"
            "go/tests/gadget/go.mod: stale — New-GoWorkspace would change it; regenerate with: Build-RootConfig 'go/tests/gadget/go.mod'"
        )
        $result.Facts['Generators'] | Should -Be 1
    }

    It 'reports each English dictionary drift reason against the tools.yml cspell pin' {
        Mock Get-EnglishDictionaryDrift -ModuleName Catzc.Base.QualityGates { "flattened from cspell '9.1.0' but tools.yml pins '$PinnedCspell'" }

        $result = Test-GeneratedFiles -Generator Build-EnglishDictionary -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike "$(Get-CatzcModulesFolder)/Catzc.Base.QualityGates/assets/english.txt.gz: stale — flattened from cspell '9.1.0' but tools.yml pins '10'; regenerate with: Build-EnglishDictionary*"
        Should -Invoke Get-ConfigValue -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Address -eq 'global.tools.cspell.version' }
    }
}

Describe 'Get-EnglishDictionaryDrift' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:assets = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:assets) | Out-Null
        $words = [System.Text.Encoding]::UTF8.GetBytes((@('gadget', 'widget', '') -join "`n"))
        [System.IO.File]::WriteAllBytes((Join-Path $script:assets 'english.txt.gz'), [Catzc.Base.QualityGates.GzipText]::Compress($words))
        $script:writeStamp = {
            param([string] $Cspell, [int] $WordCount)
            [System.IO.File]::WriteAllText((Join-Path $script:assets 'english.stamp'), (@{ cspell = $Cspell; word_count = $WordCount } | ConvertTo-Json))
        }
    }

    It 'reports nothing when the stamp matches the pin and the gz' {
        & $script:writeStamp '10.0.1' 2
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Assets = $script:assets } {
            @(Get-EnglishDictionaryDrift -AssetsFolder $Assets -PinnedCspell '10') | Should -BeNullOrEmpty
        }
    }

    It 'reports a moved cspell pin and a word count that no longer matches the gz' {
        & $script:writeStamp '9.1.0' 5
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Assets = $script:assets } {
            $reasons = @(Get-EnglishDictionaryDrift -AssetsFolder $Assets -PinnedCspell '10')
            $reasons | Should -HaveCount 2
            $reasons[0] | Should -Be "flattened from cspell '9.1.0' but tools.yml pins '10'"
            $reasons[1] | Should -Be 'holds 2 word(s) but its stamp records 5'
        }
    }

    It 'reports a missing stamp' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Assets = $script:assets } {
            Get-EnglishDictionaryDrift -AssetsFolder $Assets -PinnedCspell '10' | Should -Be 'english.stamp is missing'
        }
    }
}
