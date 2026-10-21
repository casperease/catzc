Describe 'Format-GeneratedFileHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        # The fixture generators are no loaded functions; the resolver's own tests prove the lookup.
        Mock Get-GeneratorPath -ModuleName Catzc.Base.Languages { "widgets/Catzc.Widget/$Name.ps1" }
        # The role of the file is what the caller read from the file-kinds registry, so a fixture stands for it here.
        $script:role = [pscustomobject]@{ role = 'widget'; subkind = $null }
        $script:narrowRole = [pscustomobject]@{ role = 'gadget'; subkind = 'cog' }
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
                    schema   = @{ files = @('**/*.schema.dat'); carrier = 'property'; property = '$comment'; strip = @((Get-Config -Config generated-head).warning) }
                }
            })
        $script:warning = (Get-Config -Config generated-head).warning
    }

    It 'writes the one declared warning into every head, whatever the carrier' {
        $arguments = @{ FileKind = $script:role; Carriers = $script:carriers; Languages = $script:languages }
        $heads = @(
            Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.wdg' @arguments
            Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' @arguments
            Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket @arguments
            Format-GeneratedFileHead -Text "{`n  `"a`": 1`n}`n" -Path 'docs/gen.dat' @arguments
        )
        foreach ($head in $heads) {
            $head | Should -BeLike "*warning: *$script:warning*"
        }
        $script:warning | Should -BeExactly ([Catzc.Base.Languages.GeneratedHeadConfig]::DefaultWarning)
    }

    It 'writes the unified head with the generator and the source, in the comment style of the file language' {
        $text = Format-GeneratedFileHead -Text "widget body`n" -Path 'docs/gen.wdg' -Generator New-Widget -Source 'docs/widget.yml' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeExactly "# ---`n# catzc:`n#   immutable:`n#     with_body_sha: `"9534a2e15c8b`"`n#     warning: `"$script:warning`"`n#     role: widget`n#     track: docs`n#     generator: widgets/Catzc.Widget/New-Widget.ps1`n#     source: docs/widget.yml`n# ---`n`nwidget body`n"
    }

    It 'never writes an inputs stamp: the body hash is the head''s one currency fact' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $head = Format-GeneratedFileHead -Text "widget body`n" -Path 'docs/gen.wdg' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $head | Should -BeLike "# ---`n# catzc:`n#   immutable:`n#     with_body_sha: *`n#     warning: `"$script:warning`"`n#     role: widget`n*"
        $head | Should -Not -BeLike '*with_inputs_sha*'
        (Get-Command Format-GeneratedFileHead).Parameters.Keys | Should -Not -Contain 'InputsSha'
    }

    It 'leaves the generator and the source out when the file has none, and lists several sources' {
        $bare = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $bare | Should -BeExactly "/*`n---`ncatzc:`n  immutable:`n    with_body_sha: `"9e2ec912af5d`"`n    warning: `"$script:warning`"`n    role: widget`n    track: docs`n---`n*/`n`nbody`n"

        $many = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -Generator New-Gadget -Source 'a/one.yml', 'a/two.yml' -FileKind $script:narrowRole -Carriers $script:carriers -Languages $script:languages
        $many | Should -BeLike "*    role: gadget`n    track: docs`n    generator: widgets/Catzc.Widget/New-Gadget.ps1`n    source:`n      - a/one.yml`n      - a/two.yml`n---*"
    }

    It 'leaves the track out for a root file, which no track holds' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $text | Should -Not -BeLike '*track:*'
    }

    It 'names the track and no other place fact, since each is derived on demand' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/gen.wdg" -FileKind $script:narrowRole -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeLike "*#     role: gadget`n#     track: pwsh`n# ---*"
        foreach ($key in 'repo_status', 'path', 'subkind', 'language', 'filetype', 'tracktype', 'vendor', 'module', 'moduletype') {
            $text | Should -Not -BeLike "*#     ${key}:*"
        }
    }

    It 'opens the head with the hash of the body, which the head itself and the line endings never move' {
        $arguments = @{ Path = 'docs/gen.wdg'; FileKind = $script:role; Carriers = $script:carriers; Languages = $script:languages }
        $once = Format-GeneratedFileHead -Text "body`n" @arguments
        # The block renderer quotes a value YAML would not read back as the same string, so a hash that opens with a digit is quoted.
        $once | Should -BeLike "*#   immutable:`n#     with_body_sha: `"9e2ec912af5d`"`n#     warning: `"$script:warning`"`n#     role: widget`n*"
        Format-GeneratedFileHead -Text $once @arguments | Should -BeLike '*with_body_sha: "9e2ec912af5d"*'
        Format-GeneratedFileHead -Text "body`r`n" @arguments | Should -BeLike '*with_body_sha: "9e2ec912af5d"*'
        Format-GeneratedFileHead -Text "other`n" @arguments | Should -Not -BeLike '*with_body_sha: "9e2ec912af5d"*'
    }

    It 'is stable: a second run over its own output changes nothing' {
        $arguments = @{ Path = 'docs/gen.wdg'; Generator = 'New-Widget'; Source = 'docs/widget.yml'; FileKind = $script:role; Carriers = $script:carriers; Languages = $script:languages }
        $once = Format-GeneratedFileHead -Text "body`n" @arguments
        Format-GeneratedFileHead -Text $once @arguments | Should -BeExactly $once
    }

    It 'uses a named carrier for a file whose class has no language, such as a dotfile' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket -Generator New-Sprocket -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeLike "// ---`n// catzc:*`n// ---`n`nbody`n"
        { Format-GeneratedFileHead -Text 'body' -Path 'sprocket' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*has no file language*-Carrier*'
    }

    It 'writes a property carrier into JSON, replacing an old banner its carrier strips' {
        $json = "{`n  `"`$comment`": `"$script:warning`",`n  `"type`": `"object`"`n}`n"
        $bare = Format-PropertyMetaHead -Text $json -Property '$comment' -Strip @($script:warning) -Immutable ([ordered]@{})
        $hash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($bare)
        $text = Format-GeneratedFileHead -Text $json -Path 'docs/gen.schema.dat' -Carrier schema -Generator New-Schema -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeExactly "{`n  `"`$comment`": `"catzc:\n  immutable:\n    with_body_sha: \`"$hash\`"\n    warning: \`"$script:warning\`"\n    role: widget\n    track: docs\n    generator: widgets/Catzc.Widget/New-Schema.ps1`",`n  `"type`": `"object`"`n}`n"
    }

    It 'refuses a carrier that holds no head, and an undeclared carrier' {
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.stp' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*of kind None*'
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.wdg' -Carrier gizmo -FileKind $script:role -Carriers $script:carriers -Languages $script:languages } | Should -Throw "*names the carrier 'gizmo'*"
    }
}
