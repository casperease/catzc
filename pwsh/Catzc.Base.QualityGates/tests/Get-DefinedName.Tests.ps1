<#
---
catzc:
  immutable:
    with_body_sha: "2d9d3f9567e7"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-DefinedName.ps1
    cites:
      - ADR-AUTO-IDIOM-HELDBYGATE
---
#>

Describe 'Get-DefinedName' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $files = [ordered]@{
            'widgets/Get-Widget.ps1'  = "function Get-Widget {`n    function Inner-Helper { }`n}`nfunction script:New-WidgetFixture { }`nclass WidgetPart { }`n"
            'widgets/gadget.py'       = "class GadgetPart:`n    def __init__(self):`n        pass`n`nasync def fetch_gadget():`n    pass`n"
            'widgets/gadget.go'       = "package gadget`n`ntype GadgetPart struct{}`n`nfunc (g GadgetPart) Size() int { return 0 }`n`nfunc requireGadget() {}`n"
            'widgets/notes.md'        = "def not_code():`n"
            'widgets/Plain.pln'       = "def plain():`n"
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $script:root $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            [System.IO.File]::WriteAllText($path, $files[$relative])
        }
        $script:fixture = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                    powershell = [ordered]@{ extensions = @('.ps1'); no_formatter = 'never'; naming = [ordered]@{ function = 'verb-noun'; type = 'pascal' } }
                    python     = [ordered]@{ extensions = @('.py'); no_formatter = 'never'; naming = [ordered]@{ function = 'snake'; type = 'pascal' } }
                    go         = [ordered]@{ extensions = @('.go'); no_formatter = 'never'; naming = [ordered]@{ function = 'pascal'; type = 'pascal' } }
                    plain      = [ordered]@{ extensions = @('.pln'); no_formatter = 'never'; naming = [ordered]@{ file = 'pascal' } }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'languages' } { $script:fixture }
    }

    It 'reads the functions and types each language defines: PowerShell by its parser, past a scope qualifier, Python and Go by their keywords' -Tag 'ADR-AUTO-IDIOM-HELDBYGATE' {
        $paths = @('widgets/Get-Widget.ps1', 'widgets/gadget.py', 'widgets/gadget.go', 'widgets/notes.md', 'widgets/Plain.pln', 'widgets/Missing.ps1')
        $found = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Paths = $paths; Root = $script:root } {
                param($Paths, $Root)
                Get-DefinedName -Path $Paths -RepositoryRoot $Root
            })
        @($found.ForEach({ "$($_.Path) $($_.Kind) $($_.Name)" })) | Should -Be @(
            'widgets/Get-Widget.ps1 function Get-Widget'
            'widgets/Get-Widget.ps1 function Inner-Helper'
            'widgets/Get-Widget.ps1 function New-WidgetFixture'
            'widgets/Get-Widget.ps1 type WidgetPart'
            'widgets/gadget.py function __init__'
            'widgets/gadget.py function fetch_gadget'
            'widgets/gadget.py type GadgetPart'
            'widgets/gadget.go function Size'
            'widgets/gadget.go function requireGadget'
            'widgets/gadget.go type GadgetPart'
        )
    }
}
