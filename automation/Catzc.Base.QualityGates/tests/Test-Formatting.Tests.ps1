<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Test-Formatting.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/Test-Formatting.ps1
    adrs:
      - ADR-AUTO-TEST#{3,8,35}
      - ADR-PRIN-CONFIG#1
---
#>

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
        $script:root = Get-RepositoryRoot
        $script:widgetFile = Join-Path $script:root 'docs/widget.wdg'
        $script:gadgetFile = Join-Path $script:root 'gadgets/catzc-widget/gadget.gdg'
        $script:typeFile = Join-Path $script:root 'automation/Widget/types/Gadget.cs'
        $script:blockFile = Join-Path $script:root 'automation/Widget/types/Gizmo.cs'
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:languages }
        Mock Format-Code -ModuleName Catzc.Base.QualityGates { }
        $script:reportFolder = Join-Path $TestDrive 'formatting'
    }

    It 'passes a tree the formatting leaves unchanged, running every language with a formatter in report-only mode, and no step by name' -Tag 'ADR-AUTO-TEST#35', 'ADR-PRIN-CONFIG#1' {
        { Test-Formatting -OutputFolder $script:reportFolder } | Should -Not -Throw
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            ($Language -join ',') -eq 'widget,gadget' -and $DryRun -and $PassThru
        }
    }

    It 'throws once listing every unformatted file, repository-relative, with the command that fixes it' -Tag 'ADR-AUTO-TEST#35' {
        Mock Format-Code -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.QualityGates.FormatResult]::new('widget', 'prettier', [string[]] @($script:widgetFile), [string[]] @($script:widgetFile), $true)
            [Catzc.Base.QualityGates.FormatResult]::new('gadget', 'gofmt', [string[]] @($script:gadgetFile, $script:typeFile, $script:blockFile), [string[]] @($script:gadgetFile, $script:typeFile), $true, @{ $script:blockFile = "block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'" })
        }

        $thrown = { Test-Formatting -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Formatting failed: 4 issue(s)*'
        $result = Test-Formatting -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'formatting'
        $result.Languages | Should -Be 4
        $result.Issues | Should -Be @(
            'docs/widget.wdg: not formatted — run Format-Code -Language widget'
            'gadgets/catzc-widget/gadget.gdg: not formatted — run Format-Code -Language gadget'
            'automation/Widget/types/Gadget.cs: not formatted — run Format-Code -Language gadget'
            "automation/Widget/types/Gizmo.cs: block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
        )
    }

    It 'checks only the selected languages, and skips Format-Code when none of them has a formatter' {
        $result = Test-Formatting -Language gadget -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        $result.Languages | Should -Be 1
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { ($Language -join ',') -eq 'gadget' }

        $null = Test-Formatting -Language csharp, sprocket -PassThru -OutputFolder $script:reportFolder
        Should -Invoke Format-Code -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
    }

    It 'throws on an undeclared language' {
        { Test-Formatting -Language gizmo -OutputFolder $script:reportFolder } | Should -Throw "*unknown file language 'gizmo'*"
    }
}

Describe 'Repository formatting integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'formatting leaves the repository unchanged (Test-Formatting)' {
        $go = Resolve-ToolExecutable -Tool go
        $uv = Resolve-ToolExecutable -Tool uv
        $python = Resolve-ToolExecutable -Tool python
        $missing = if (-not (Get-Command prettier -ErrorAction Ignore)) {
            'tool_prettier_missing'
        }
        elseif (-not ($go.Found -and $go.VersionOk)) {
            'tool_go_missing'
        }
        elseif (-not ($uv.Found -and $uv.VersionOk -and $python.Found -and $python.VersionOk)) {
            'tool_uv_missing'
        }
        if ($missing) {
            Set-ItResult -Skipped -Because $missing
            return
        }
        $result = Test-Formatting -PassThru -OutputFolder (Join-Path $TestDrive 'formatting')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
