<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Format-GeneratedFileHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        # The fixture generators are no loaded functions; the resolver's own tests prove the lookup.
        Mock Get-GeneratorPath -ModuleName Catzc.Base.Languages { "automation/Catzc.Widget/$Name.ps1" }
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new(@{
                languages = [ordered]@{
                    widget = @{ extensions = @('.wdg'); no_formatter = 'widgets are never formatted' }
                    gadget = @{ extensions = @('.gdg'); no_formatter = 'gadgets are never formatted' }
                    stamp  = @{ extensions = @('.stp'); no_formatter = 'a stamp is written whole' }
                    data   = @{ extensions = @('.dat'); no_formatter = 'data is never formatted' }
                }
            })
        $script:carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{
                carriers = [ordered]@{
                    widget   = @{ carrier = 'comment-head'; line = '#' }
                    gadget   = @{ carrier = 'comment-head'; block = @('/*', '*/') }
                    stamp    = @{ carrier = 'none'; reason = 'written whole' }
                    data     = @{ carrier = 'property'; property = '//' }
                    sprocket = @{ files = @('**/sprocket'); carrier = 'comment-head'; line = '//' }
                    schema   = @{ files = @('**/*.schema.dat'); carrier = 'property'; property = '$comment'; strip = @('GENERATED FILE') }
                }
            })
    }

    It 'writes the unified head with the generator and the source, in the comment style of the file language' {
        $text = Format-GeneratedFileHead -Text "widget body`n" -Path 'docs/gen.wdg' -Generator New-Widget -Source 'docs/widget.yml' -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeExactly "# ---`n# catzc:`n#   derived:`n#     path: docs/gen.wdg`n#     source: docs/widget.yml`n#     kind: generated-from-source`n#     generator: automation/Catzc.Widget/New-Widget.ps1`n# ---`n`nwidget body`n"
    }

    It 'leaves the generator and the source out when the file has none, and lists several sources' {
        $bare = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -Carriers $script:carriers -Languages $script:languages
        $bare | Should -BeExactly "/*`n---`ncatzc:`n  derived:`n    path: docs/gen.gdg`n    kind: generated-from-source`n---`n*/`n`nbody`n"

        $many = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -Generator New-Gadget -Source 'a/one.yml', 'a/two.yml' -Carriers $script:carriers -Languages $script:languages
        $many | Should -BeLike "*    source:`n      - a/one.yml`n      - a/two.yml`n    kind: generated-from-source`n    generator: automation/Catzc.Widget/New-Gadget.ps1`n---*"
    }

    It 'writes the tracked kind for a file git tracks' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.wdg' -Tracked -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeLike '*    kind: tracked-generated-from-source*'
    }

    It 'is stable: a second run over its own output changes nothing' {
        $arguments = @{ Path = 'docs/gen.wdg'; Generator = 'New-Widget'; Source = 'docs/widget.yml'; Carriers = $script:carriers; Languages = $script:languages }
        $once = Format-GeneratedFileHead -Text "body`n" @arguments
        Format-GeneratedFileHead -Text $once @arguments | Should -BeExactly $once
    }

    It 'uses a named carrier for a file whose class has no language, such as a dotfile' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket -Generator New-Sprocket -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeLike "// ---`n// catzc:*`n// ---`n`nbody`n"
        { Format-GeneratedFileHead -Text 'body' -Path 'sprocket' -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*has no file language*-Carrier*'
    }

    It 'writes a property carrier into JSON, replacing an old banner its carrier strips' {
        $text = Format-GeneratedFileHead -Text "{`n  `"`$comment`": `"GENERATED FILE - do not edit.`",`n  `"type`": `"object`"`n}`n" -Path 'docs/gen.schema.dat' -Carrier schema -Generator New-Schema -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeExactly "{`n  `"`$comment`": `"catzc:\n  derived:\n    path: docs/gen.schema.dat\n    kind: generated-from-source\n    generator: automation/Catzc.Widget/New-Schema.ps1`",`n  `"type`": `"object`"`n}`n"
    }

    It 'refuses a carrier that holds no head, and an undeclared carrier' {
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.stp' -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*of kind None*'
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.wdg' -Carrier gizmo -Carriers $script:carriers -Languages $script:languages } | Should -Throw "*names the carrier 'gizmo'*"
    }
}
