<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
    kind: test
---
#>

# A contract asset's note is the header comment its file can carry without changing what its check compares
# ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): a YAML asset's leading '#' lines,
# a schema's "$comment", and nothing for every other asset. Fixtures are a widget repository in TestDrive
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-ContractAssetNote' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {
    BeforeAll {
        # The lines of a fixture file, each ended by LF.
        function Join-Line {
            param([AllowEmptyString()] [string[]] $Line)
            ($Line -join "`n") + "`n"
        }

        function Get-Note {
            param([string] $Path, [string] $Content)
            $file = Join-Path $script:root "contracts/widget/0.0.0/Catzc.Widget/$Path"
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
            $asset = Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path $Path
            InModuleScope Catzc.Base.Contracts -Parameters @{ Root = $script:root; Asset = $asset } {
                param($Root, $Asset)
                Get-ContractAssetNote -RepositoryRoot $Root -Asset $Asset
            }
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
    }

    It 'joins the leading comment lines of a YAML fragment into one line' {
        $note = Get-Note '.widget/flows/build.yml' (Join-Line -Line '# The keys the gadget host reads:', '#   the `widget` root.', '#', 'widget:', '  gadget:')
        $note | Should -BeExactly 'The keys the gadget host reads: the `widget` root.'
    }

    It 'ends the note at the first line that is not a comment, a blank line included' {
        $note = Get-Note '.widget/flows/build.yml' (Join-Line -Line '# The widget note.', '', '# Not the note.', 'widget:')
        $note | Should -BeExactly 'The widget note.'
    }

    It 'reads the note of a YAML sample payload' {
        Get-Note 'gadget.sample.yml' (Join-Line -Line '# A gadget the widget produces.', 'widget: gadget') | Should -BeExactly 'A gadget the widget produces.'
    }

    It 'gives nothing for a YAML asset that opens with no comment' {
        Get-Note '.widget/flows/build.yml' "widget:`n  # an inner comment`n  gadget:`n" | Should -BeNullOrEmpty
    }

    It 'reads the $comment of a schema' {
        $note = Get-Note '.widget/gadget.json.schema.json' '{ "$comment": "The gadget  shape.", "type": "object" }'
        $note | Should -BeExactly 'The gadget shape.'
    }

    It 'gives nothing for a schema with no $comment, and for one that does not parse' {
        Get-Note '.widget/gadget.json.schema.json' '{ "type": "object" }' | Should -BeNullOrEmpty
        Get-Note '.widget/widget.json.schema.json' '{ "type": ' | Should -BeNullOrEmpty
    }

    It 'gives nothing for an asset that cannot carry a comment without changing what it pins' {
        Get-Note '.widget/README.md' '' | Should -BeNullOrEmpty
        Get-Note '.widget/notes.md' "# The widget heading`n" | Should -BeNullOrEmpty
        Get-Note '.widget/gadget.json' '{ "$comment": "pinned, not a note", "widget": null }' | Should -BeNullOrEmpty
        Get-Note 'gadget.sample.json' '{ "$comment": "payload, not a note" }' | Should -BeNullOrEmpty
    }
}
