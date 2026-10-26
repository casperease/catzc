Describe 'Test-Formatting' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                languages = [ordered]@{
                    widget   = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' }
                    gadget   = [ordered]@{ extensions = @('.gdg'); formatter = 'gofmt' }
                    csharp   = [ordered]@{ extensions = @('.cs'); no_formatter = 'no layout engine yet' }
                    sprocket = [ordered]@{ extensions = @('.spr'); no_formatter = 'binary sprockets' }
                }
            })
        $script:carriers = [Catzc.Base.Languages.FileCarriersConfig]::new([ordered]@{
                carriers = [ordered]@{
                    gizmo = [ordered]@{ files = @('**/.gizmo-keep'); carrier = 'none'; reason = 'a placeholder with nothing to format' }
                }
            })
        $script:root = Get-RepositoryRoot
        $script:widgetFile = Join-Path $script:root 'docs/widget.wdg'
        $script:gadgetFile = Join-Path $script:root 'gadgets/catzc-widget/gadget.gdg'
        $script:typeFile = Join-Path $script:root "$(Get-CatzcModulesFolder)/Widget/types/Gadget.cs"
        $script:blockFile = Join-Path $script:root "$(Get-CatzcModulesFolder)/Widget/types/Gizmo.cs"
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-carriers' } { $script:carriers }
        Mock Format-Code -ModuleName Catzc.Base.QualityGates { }
        Mock Get-FormatScope -ModuleName Catzc.Base.QualityGates { , [string[]] @() }
        $script:reportFolder = Join-Path $TestDrive 'formatting'
    }

    It 'passes a tree the formatting leaves unchanged, running every language with a formatter in report-only mode, and no step by name' -Tag 'ADR-AUTO-TEST-QUALITYGATE', 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        { Test-Formatting -OutputFolder $script:reportFolder } | Should -Not -Throw
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            ($Language -join ',') -eq 'widget,gadget' -and $DryRun -and $PassThru
        }
    }

    It 'throws once listing every unformatted file, repository-relative, with the command that fixes it' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        Mock Format-Code -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', [string[]] @($script:widgetFile),
                [string[]] @($script:widgetFile), $true)
            [Catzc.Base.QualityGates.FormatResult]::new('gadget', 'gofmt', [string[]] @($script:gadgetFile,
                    $script:typeFile, $script:blockFile), [string[]] @($script:gadgetFile, $script:typeFile), $true,
                @{ $script:blockFile = "block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'" })
        }

        $thrown = { Test-Formatting -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Formatting failed: 4 issue(s)*'
        $result = Test-Formatting -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'formatting'
        $result.Facts['Languages'] | Should -Be 4
        $result.Issues | Should -Be @(
            'docs/widget.wdg: not formatted — run Format-Code -Language widget'
            'gadgets/catzc-widget/gadget.gdg: not formatted — run Format-Code -Language gadget'
            "$(Get-CatzcModulesFolder)/Widget/types/Gadget.cs: not formatted — run Format-Code -Language gadget"
            "$(Get-CatzcModulesFolder)/Widget/types/Gizmo.cs: block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
        )
    }

    It 'proves named files are in the form: it checks only those paths and fails on a file the formatting would change' -Tag 'TDR-NORMALFORM-UNCONTESTED' {
        Mock Format-Code -ModuleName Catzc.Base.QualityGates -ParameterFilter { @($Path) -contains 'docs/widget.wdg' } {
            [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', [string[]] @($script:widgetFile),
                [string[]] @($script:widgetFile), $true)
        }
        $result = Test-Formatting -Path 'docs/widget.wdg' -PassThru -OutputFolder $script:reportFolder
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            ($Path -join ',') -eq 'docs/widget.wdg' -and $DryRun -and $PassThru
        }
        $result.Facts['Paths'] | Should -Be 1
        $result.Issues | Should -Be @('docs/widget.wdg: not formatted — run Format-Code -Language widget')
    }

    It 'checks only the selected languages, and skips Format-Code when none of them has a formatter' {
        $result = Test-Formatting -Language gadget -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        $result.Facts['Languages'] | Should -Be 1
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { ($Language -join ',') -eq 'gadget' }

        $null = Test-Formatting -Language csharp, sprocket -PassThru -OutputFolder $script:reportFolder
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'reports a file no language or file class claims, and counts a stated no_formatter reason or a declared file class as covered' -Tag 'ADR-AUTO-TEST-QUALITYGATE', 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $loose = Join-Path $script:root 'docs/widget.txt'
        $placeholder = Join-Path $script:root 'docs/gadgets/.gizmo-keep'
        $widget = $script:widgetFile
        $type = $script:typeFile
        Mock Get-FormatScope -ModuleName Catzc.Base.QualityGates { , [string[]] @($widget, $loose, $type,
                $placeholder) }.GetNewClosure()

        $result = Test-Formatting -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            'docs/widget.txt: no Format-* command covers it — neither a file language in languages.yml nor a file class in file-carriers.yml claims it'
        )

        $null = Test-Formatting -Language widget -PassThru -OutputFolder $script:reportFolder
        Should -Invoke Get-FormatScope -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'throws on an undeclared language' {
        { Test-Formatting -Language gizmo -OutputFolder $script:reportFolder } |
            Should -Throw "*unknown file language 'gizmo'*"
    }
}

Describe 'Repository formatting integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'formatting leaves the repository unchanged (Test-Formatting)' {
        $go = Resolve-ToolExecutable -Tool go
        $uv = Resolve-ToolExecutable -Tool uv
        $python = Resolve-ToolExecutable -Tool python
        if (-not (Get-Command prettier -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_prettier_missing'
            return
        }
        if (-not ($go.Found -and $go.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_go_missing'
            return
        }
        if (-not ($uv.Found -and $uv.VersionOk -and $python.Found -and $python.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_uv_missing'
            return
        }
        $result = Test-Formatting -PassThru -OutputFolder (Join-Path $TestDrive 'formatting')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
