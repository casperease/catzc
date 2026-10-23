Describe 'Write-InsideVsCodeNotice' -Tag 'L0', 'logic' {
    BeforeAll {
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
        Import-InternalModule Importer -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    }

    It 'says what was left undone and the command to run from a terminal outside the editor, in one line' {
        Mock Write-ImporterMessage { } -ModuleName Catzc.Internal.Importer

        InModuleScope Catzc.Internal.Importer {
            Write-InsideVsCodeNotice -Subject 'Widget parts' -State 'gadget stale, not built' -Command 'Build-Widget'
        }

        Should -Invoke Write-ImporterMessage -ModuleName Catzc.Internal.Importer -Times 1 -Exactly -ParameterFilter {
            $Message -ceq 'Widget parts: gadget stale, not built from inside VS Code — run Build-Widget from a terminal outside the editor.' -and $ForegroundColor -eq 'Yellow'
        }
    }
}
