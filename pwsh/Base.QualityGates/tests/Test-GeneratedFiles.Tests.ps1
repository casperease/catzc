Describe 'Test-GeneratedFiles' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Build-DrsIndex -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/index.md'; Changed = $false; DryRun = $true } }
        Mock Build-Glossary -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/glossary.md'; Changed = $false; DryRun = $true; ConceptCount = 2 } }
        Mock Build-Readme -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Folder = 'widget'; Source = 'docs/widget.md'; Readme = 'widget/README.md'; Changed = $false; DryRun = $true } }
        Mock Build-ContractReference -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/contracts/widget.md'; Changed = $false; DryRun = $true } }
        Mock Build-GitKeep -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'widget/.gitkeep'; Changed = $false; DryRun = $true } }
        Mock Build-FrontPage -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'widget/README.md'; Changed = $false; DryRun = $true; SectionCount = 1 } }
        Mock Build-TerminologyDictionary -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Category = 'widget'; Path = '.cspell/widget.txt'; WordCount = 3; Changed = $false; DryRun = $true } }
        Mock Get-ConfigValue -ModuleName Catzc.Base.QualityGates { '10' }
        Mock Get-EnglishDictionaryDrift -ModuleName Catzc.Base.QualityGates { }
        # The tracked generated paths and their stamp misses; each case that reads them names them here.
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GeneratedTrackedPath -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GeneratedGateDrift -ModuleName Catzc.Base.QualityGates { }
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $false; DryRun = $true }
            [pscustomobject]@{ Target = 'gadget.json'; Source = 'assets/gadget.json'; Generator = $null; Changed = $false; DryRun = $true }
        }
        $script:reportFolder = Join-Path $TestDrive 'generated-files'
    }

    It 'passes a tree where no generator would change a file' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Test-GeneratedFiles -OutputFolder $script:reportFolder } | Should -Not -Throw
        Should -Invoke Build-DrsIndex -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun -and $PassThru }
        Should -Invoke Build-RootConfig -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun -and $PassThru }
    }

    It 'throws once listing every stale file with its generator and regenerate command' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Build-GitKeep -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Path = 'widget/.gitkeep'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Path = 'gadget/.gitkeep'; Changed = $true; DryRun = $true }
        }
        Mock Build-DrsIndex -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/widget/index.md'; Changed = $true; DryRun = $true } }

        $thrown = { Test-GeneratedFiles -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-GeneratedFiles failed: 3 issue(s)*'
        $thrown.Exception.Message |
            Should -BeLike '*docs/widget/index.md: stale — Build-DrsIndex would change it; regenerate with: Build-DrsIndex*'
        $thrown.Exception.Message | Should -BeLike '*widget/.gitkeep: stale — Build-GitKeep*'
        $thrown.Exception.Message | Should -BeLike '*gadget/.gitkeep: stale — Build-GitKeep*'
    }

    It 'returns the result with the generator count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Build-Readme -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Folder = 'widget'; Source = 'docs/widget.md'; Readme = 'widget/README.md'; Changed = $true; DryRun = $true } }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'generated-files'
        $result.IssueCount | Should -Be 1
        $result.Issues[0] |
            Should -Be 'widget/README.md: stale — Build-Readme would change it; regenerate with: Build-Readme'
        $known = InModuleScope Catzc.Base.QualityGates { @(Get-GeneratedFileGenerator).Count }
        $result.Facts['Generators'] |
            Should -Be $known -Because 'the count is every writer row of the modules'' generated.yml plus every root-file generator of rootconfig.yml'
    }

    It 'lists the writer rows of every module''s generated.yml and the generators of rootconfig.yml, so no generator is left out' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $known = InModuleScope Catzc.Base.QualityGates { Get-GeneratedFileGenerator }
        $known | Should -Contain 'Build-DrsIndex'
        $known | Should -Contain 'Build-RootConfig'
        $known | Should -Contain 'New-PythonProject'
        foreach ($name in @(Get-GeneratedWriterOrder | ForEach-Object name)) {
            $known | Should -Contain $name
        }
        @($known | Select-Object -Unique).Count | Should -Be $known.Count

        $rootGenerators = @((Get-Config -Config rootconfig).files | Where-Object { $_.optIn -and $_.generator } |
                ForEach-Object { "$($_.generator)" } | Select-Object -Unique)
        foreach ($name in $rootGenerators) {
            $known | Should -Contain $name
        }
    }

    It 'throws naming the known generators when a generator is unknown' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $thrown = { Test-GeneratedFiles -Generator Build-Widget -OutputFolder $script:reportFolder } |
            Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike "Unknown generator 'Build-Widget'. The generators are: *"
        # The registry's order is no contract; the message names every known generator.
        foreach ($generator in 'Build-DrsIndex', 'Build-Glossary', 'Build-Readme') {
            $message | Should -BeLike "*$generator*"
        }
    }

    It 'attributes a rendered root file to its generator and a copied one to Build-RootConfig' {
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'gadget.json'; Source = 'assets/gadget.json'; Generator = $null; Changed = $true; DryRun = $true }
        }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Issues |
            Should -Contain "widget.json: stale — New-VsCodeSettings would change it; regenerate with: Build-RootConfig 'widget.json'"
        $result.Issues |
            Should -Contain "gadget.json: stale — Build-RootConfig would change it; regenerate with: Build-RootConfig 'gadget.json'"
    }

    It 'checks only the selected generators, and a rendered generator selects only its own root files' {
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'gadget.json'; Source = 'assets/gadget.json'; Generator = $null; Changed = $true; DryRun = $true }
        }

        $result = Test-GeneratedFiles -Generator New-VsCodeSettings -PassThru -OutputFolder $script:reportFolder
        $result.Issues |
            Should -Be @("widget.json: stale — New-VsCodeSettings would change it; regenerate with: Build-RootConfig 'widget.json'")
        $result.Facts['Generators'] | Should -Be 1
        Should -Invoke Build-DrsIndex -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Get-EnglishDictionaryDrift -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'checks a root generator whose own row expands rootconfig through Build-RootConfig, and names it once' {
        Mock Build-RootConfig -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Target = '.gitattributes'; Source = $null; Generator = 'New-GitAttributes'; Changed = $true; DryRun = $true }
            [pscustomobject]@{ Target = 'widget.json'; Source = $null; Generator = 'New-VsCodeSettings'; Changed = $true; DryRun = $true }
        }

        $result = Test-GeneratedFiles -Generator New-GitAttributes -PassThru -OutputFolder $script:reportFolder
        $result.Issues |
            Should -Be @(".gitattributes: stale — New-GitAttributes would change it; regenerate with: Build-RootConfig '.gitattributes'")
        $known = @(InModuleScope Catzc.Base.QualityGates { Get-GeneratedFileGenerator })
        @($known | Where-Object { $_ -ceq 'New-GitAttributes' }).Count | Should -Be 1
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
        $result.Issues[0] |
            Should -BeLike "$(Get-CatzcModulesFolder)/Base.QualityGates/assets/english.txt.gz: stale — flattened from cspell '9.1.0' but tools.yml pins '10'; regenerate with: Build-EnglishDictionary*"
        Should -Invoke Get-ConfigValue -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Address -eq 'global.tools.cspell.version' }
    }

    Context 'with -Changed' {
        BeforeEach {
            # Get-GeneratedWriterDue decides which writers are due; each case names them here.
            $script:due = @('Build-DrsIndex')
            Mock Get-GeneratedWriterDue -ModuleName Catzc.Base.QualityGates {
                foreach ($name in @(Get-GeneratedWriterOrder | ForEach-Object name)) {
                    [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new($name, $name -in $script:due)
                }
            }
        }

        It 'fails a hand edit: a changed output whose stamp misses renders its writer, not due, and the render finds it' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
            $script:due = @()
            Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md' }
            Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md'; 'docs/drs/other.md' }
            Mock Get-GeneratedTrackedPath -ModuleName Catzc.Base.QualityGates {
                [Catzc.Base.Variants.GeneratedTarget]::new('docs/drs/index.md', 'Build-DrsIndex', 'rollable')
            } -ParameterFilter { "$Path" -ceq 'docs/drs/index.md' }
            Mock Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md' }
            Mock Build-DrsIndex -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/drs/index.md'; Changed = $true; DryRun = $true } }

            $result = Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder
            $result.Issues |
                Should -Be @('docs/drs/index.md: stale — Build-DrsIndex would change it; regenerate with: Build-DrsIndex')
            $result.Facts['Tracked'] | Should -Be 1
            Should -Invoke Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { "$Path" -ceq 'docs/drs/index.md' }
            Should -Invoke Build-GitKeep -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        }

        It 'skips the render of a changed output whose stamp is the hash of its body, when its writer is not due' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
            $script:due = @()
            Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md' }
            Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md' }
            Mock Get-GeneratedTrackedPath -ModuleName Catzc.Base.QualityGates { [Catzc.Base.Variants.GeneratedTarget]::new('docs/drs/index.md', 'Build-DrsIndex', 'rollable') }

            $result = Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder
            $result.IssueCount | Should -Be 0
            Should -Invoke Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
            Should -Invoke Build-DrsIndex -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        }

        It 'passes a generator change whose output was re-rendered, and does not run a writer none of the changed paths touch' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
            Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { ConvertTo-RepoRelativePath (Join-Path (Get-CatzcModuleRoot -Module Catzc.Base.Drs) 'Build-DrsIndex.ps1'); 'docs/drs/index.md' }

            $result = Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder
            $result.IssueCount | Should -Be 0
            Should -Invoke Build-DrsIndex -ModuleName Catzc.Base.QualityGates -Times 1
            Should -Invoke Build-GitKeep -ModuleName Catzc.Base.QualityGates -Times 0
        }

        It 'with -StampOnly reads the changed set''s stamps, asks no due rows and renders no writer while every stamp holds' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
            Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md' }
            Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'docs/drs/index.md' }
            Mock Get-GeneratedTrackedPath -ModuleName Catzc.Base.QualityGates { [Catzc.Base.Variants.GeneratedTarget]::new('docs/drs/index.md', 'Build-DrsIndex', 'rollable') }

            $result = Test-GeneratedFiles -Changed -StampOnly -PassThru -OutputFolder $script:reportFolder
            $result.IssueCount | Should -Be 0
            Should -Invoke Get-GeneratedWriterDue -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
            Should -Invoke Build-DrsIndex -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
            Should -Invoke Build-RootConfig -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
            Should -Invoke Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        }

        It 'refuses -StampOnly together with -Generator, which the parameter sets keep apart' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
            { Test-GeneratedFiles -StampOnly -Generator Build-DrsIndex -PassThru -OutputFolder $script:reportFolder } |
                Should -Throw '*Parameter set cannot be resolved*'
            Should -Invoke Get-GeneratedStampDrift -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        }

        It 'fails a generator change whose output was not re-rendered' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
            Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { ConvertTo-RepoRelativePath (Join-Path (Get-CatzcModuleRoot -Module Catzc.Base.Drs) 'Build-DrsIndex.ps1') }
            Mock Build-DrsIndex -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Path = 'docs/drs/index.md'; Changed = $true; DryRun = $true } }

            $result = Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder
            $result.Issues |
                Should -Contain 'docs/drs/index.md: stale — Build-DrsIndex would change it; regenerate with: Build-DrsIndex'
        }

        It 'runs only the writers the due rows name, and no writer when none is due' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
            Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'widget/anything.txt' }
            $script:due = @('Build-RootConfig')
            Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder | Out-Null
            Should -Invoke Build-RootConfig -ModuleName Catzc.Base.QualityGates -Times 1
            Should -Invoke Build-DrsIndex -ModuleName Catzc.Base.QualityGates -Times 0

            $script:due = @()
            Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder | Out-Null
            Should -Invoke Build-RootConfig -ModuleName Catzc.Base.QualityGates -Times 1
        }
    }
}

Describe 'Test-GeneratedFiles — a widget writer over a fixture tree' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
    BeforeAll {
        # The stub the widget writer's mock attaches to; the gate calls a writer by its row's name, and only the mock ever answers.
        function global:Build-Widget {
            param([switch] $DryRun, [switch] $PassThru, [switch] $Silent)
            throw "Build-Widget is the widget writer's stub, called unmocked with -DryRun:$DryRun -PassThru:$PassThru -Silent:$Silent."
        }
        $script:root = Join-Path $TestDrive 'widget-tree'
        foreach ($folder in 'widget', 'gadget') {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:root $folder)) | Out-Null
        }
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#')
        $script:warning = (Get-Config -Config generated-head).warning
        # What the widget writer composes for a path: the body under the head the one head renderer stamps.
        $script:render = {
            param([string] $Path, [string] $Body)
            $hash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf((Get-CodeMetaState -Text $Body -Form $script:form).Rest)
            Format-CodeMetaHead -Text $Body -Form $script:form -Immutable ([ordered]@{ warning = $script:warning; regenerate = "Build-Widget -Path $Path"; with_body_sha = $hash })
        }
        $script:write = {
            param([string] $Relative, [string] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:root $Relative), $Text, [System.Text.UTF8Encoding]::new($false))
        }
        $body = "widget: gadget`n"
        & $script:write 'widget/synced.yml' (& $script:render 'widget/synced.yml' $body)
        # A body edited by hand under the head of the body before it.
        & $script:write 'widget/stale.yml' ((& $script:render 'widget/stale.yml' $body).Replace('widget: gadget', 'widget: sprocket'))
        # A head edited by hand over the body it was stamped for, so its body sha still holds.
        & $script:write 'widget/edited.yml' ((& $script:render 'widget/edited.yml' $body).Replace('Build-Widget -Path widget/edited.yml', 'Build-Gadget'))
        # A head on a path no writer row declares, its stamp stale: an authored file as far as the gate is concerned.
        & $script:write 'gadget/notes.yml' ((& $script:render 'gadget/notes.yml' $body).Replace('widget: gadget', 'widget: cog'))
        & $script:write 'gadget/prices.json' "{}`n"
        $script:tracked = 'gadget/notes.yml', 'gadget/prices.json', 'widget/edited.yml', 'widget/stale.yml', 'widget/synced.yml'
    }

    AfterAll {
        Remove-Item -Path Function:\Build-Widget -ErrorAction Ignore
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:root }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { $script:tracked }
        Mock Get-GeneratedWriterOrder -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; outputs = @('widget/*.yml') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Update-Gadget', [ordered]@{ class = 'snapshot'; check = 'none'; outputs = @('gadget/prices.json') })
        }
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedTarget]::new('widget/*.yml', 'Build-Widget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('gadget/prices.json', 'Update-Gadget', 'snapshot')
        }
        Mock Get-GeneratedWriterDue -ModuleName Catzc.Base.QualityGates { [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new('Build-Widget', $false) }
        Mock Get-GeneratedGateDrift -ModuleName Catzc.Base.QualityGates { }
        # The widget writer's dry run: every output it would write, changed where the bytes on disk differ, head included.
        Mock Build-Widget -ModuleName Catzc.Base.QualityGates {
            foreach ($name in 'edited', 'stale', 'synced') {
                $relative = "widget/$name.yml"
                $expected = & $script:render $relative "widget: gadget`n"
                [pscustomobject]@{ Path = $relative; Changed = [System.IO.File]::ReadAllText((Join-Path $script:root $relative)) -cne $expected; DryRun = $true }
            }
        }
        $script:reportFolder = Join-Path $TestDrive 'generated-files'
    }

    It 'fails a stale body and a hand-edited head, passes the file in sync, and never reads a head on an undeclared path' {
        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            'widget/edited.yml: stale — Build-Widget would change it; regenerate with: Build-Widget'
            'widget/stale.yml: stale — Build-Widget would change it; regenerate with: Build-Widget'
        )
        $result.Facts['Tracked'] | Should -Be 4 -Because 'the registry declares three widget outputs and the gadget prices, and gadget/notes.yml on no output'
        Should -Invoke Build-Widget -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $DryRun -and $PassThru -and $Silent }
    }

    It 'reports a snapshot writer as skipped, never as a finding, and runs no dry run of it' {
        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Facts['Skipped'] | Should -Be @('Update-Gadget (snapshot)')
        $result.Issues | Should -Not -BeLike '*gadget/*'
    }

    It 'lists neither a gate-checked nor an untracked writer as skipped, and renders neither' {
        Mock Get-GeneratedWriterOrder -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; check = 'gate'; gate = 'Test-Widgets'; outputs = @('widget/*.yml') })
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Update-Gadget', [ordered]@{ class = 'untracked'; check = 'none'; outputs = @('gadget/prices.json') })
        }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Facts['Skipped'] | Should -BeNullOrEmpty
        $result.IssueCount | Should -Be 0
        Should -Invoke Build-Widget -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        Should -Invoke Get-GeneratedGateDrift -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Writer.name -ceq 'Build-Widget' }
    }

    It 'fails a gate-checked writer whose generated input was committed after its outputs, naming its regenerate command' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
        Mock Get-GeneratedWriterOrder -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{ class = 'rollable'; check = 'gate'; gate = 'Test-Widgets'; regenerate = 'Build-Widget -All'; outputs = @('widget/*.yml') })
        }
        Mock Get-GeneratedGateDrift -ModuleName Catzc.Base.QualityGates { 'Update-Gadget committed its output in abc1234 after the last commit of these outputs' }

        $result = Test-GeneratedFiles -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('widget/*.yml: stale — Update-Gadget committed its output in abc1234 after the last commit of these outputs; regenerate with: Build-Widget -All')
        Should -Invoke Get-GeneratedGateDrift -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly -ParameterFilter { $Generated.Count -eq 0 }
    }

    It 'with -Changed renders a writer that is not due when a changed output''s stamp misses' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'widget/stale.yml'; 'gadget/notes.yml' }

        $result = Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Contain 'widget/stale.yml: stale — Build-Widget would change it; regenerate with: Build-Widget'
        $result.Facts['Tracked'] | Should -Be 1
        Should -Invoke Build-Widget -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'with -Changed skips the render of a writer that is not due when every changed output''s stamp holds' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.QualityGates { 'widget/synced.yml'; 'gadget/notes.yml' }

        $result = Test-GeneratedFiles -Changed -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        Should -Invoke Build-Widget -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}

Describe 'Get-EnglishDictionaryDrift' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:assets = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:assets) | Out-Null
        $words = [System.Text.Encoding]::UTF8.GetBytes((@('gadget', 'widget', '') -join "`n"))
        [System.IO.File]::WriteAllBytes((Join-Path $script:assets 'english.txt.gz'),
            [Catzc.Base.QualityGates.GzipText]::Compress($words))
        $script:writeStamp = {
            param([string] $Cspell, [int] $WordCount)
            [System.IO.File]::WriteAllText((Join-Path $script:assets 'english.stamp'),
                (@{ cspell = $Cspell; word_count = $WordCount } | ConvertTo-Json))
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

Describe 'Test-GeneratedFiles — real tree' -Tag 'L2', 'integrity', 'source-only' {
    It 'Test-GeneratedFiles passes over the whole tree' -Tag 'ADR-AUTO-TEST-QUALITYGATE', 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $go = Resolve-ToolExecutable -Tool go
        if (-not ($go.Found -and $go.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_go_missing'; return
        }
        $result = Test-GeneratedFiles -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.Issues | Should -BeNullOrEmpty
        $result.IssueCount | Should -Be 0
    }
}

Describe 'Test-GeneratedFiles — shipped assets/english.txt.gz' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the committed word list and its stamp in the loaded QualityGates module' {
        $assets = [Catzc.Base.QualityGates.SpellingOracle]::AssetsFolder((Get-CatzcModuleRoot -Module Catzc.Base.QualityGates))
        [Catzc.Base.QualityGates.SpellingOracle]::DictionaryPath($assets) | Should -Exist
        [Catzc.Base.QualityGates.SpellingOracle]::DictionaryStampPath($assets) | Should -Exist
    }
}
