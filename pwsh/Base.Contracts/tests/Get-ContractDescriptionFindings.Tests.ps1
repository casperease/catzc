Describe 'Get-ContractDescriptionFindings' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS' {
    BeforeAll {
        $script:find = {
            param([hashtable] $Splat)
            InModuleScope Catzc.Base.Contracts -Parameters @{ Splat = $Splat } {
                param($Splat)
                @(Get-ContractDescriptionFindings @Splat)
            }
        }
    }

    It 'passes a plain description that equals the stripped synopsis' {
        & $script:find @{ AssetPath = 'w/get_widget.command.yml'; Key = 'description'; Description = 'Returns the widget.'
            Synopsis = 'Returns the [widget](widget.md) (ADR-WIDGET-RULE).' } | Should -BeNullOrEmpty
    }

    It 'passes a plain schema $comment with no synopsis to equal' {
        & $script:find @{ AssetPath = 'w/gadget.schema.json'; Key = '$comment'; Description = 'The shape of a gadget.' } | Should -BeNullOrEmpty
    }

    It 'names a missing description' {
        & $script:find @{ AssetPath = 'w/gadget.schema.json'; Key = '$comment'; Description = '' } |
            Should -Be @("'w/gadget.schema.json': `$comment is missing; one plain sentence says what the contract guarantees")
    }

    It 'names a description that is no plain scalar' {
        & $script:find @{ AssetPath = 'w/gadget.schema.json'; Key = '$comment'; Description = 'Shape: the gadget.' } |
            Should -BeLike "*'w/gadget.schema.json': `$comment holds a character other than*"
    }

    It 'names a description that differs from the synopsis and writes the one it should hold' {
        & $script:find @{ AssetPath = 'w/get_widget.command.yml'; Key = 'description'; Description = 'Returns a widget.'
            Synopsis = 'Returns the widget.' } |
            Should -Be @("'w/get_widget.command.yml': description is not the command's synopsis as plain text; write 'Returns the widget.', or change the synopsis on its comment page")
    }
}
