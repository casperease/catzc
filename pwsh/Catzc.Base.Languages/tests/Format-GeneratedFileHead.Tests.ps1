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
        $text | Should -BeExactly "# ---`n# catzc:`n#   immutable:`n#     with_body_sha: `"9534a2e15c8b`"`n#     warning: `"$script:warning`"`n#     repo_status: locked`n#     path: docs/gen.wdg`n#     source: docs/widget.yml`n#     role: widget`n#     language: widget`n#     filetype: wdg`n#     track: docs`n#     tracktype: documentation`n#     generator: widgets/Catzc.Widget/New-Widget.ps1`n# ---`n`nwidget body`n"
    }

    It 'never writes an inputs stamp: the body hash is the head''s one currency fact' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $head = Format-GeneratedFileHead -Text "widget body`n" -Path 'docs/gen.wdg' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $head | Should -BeLike "# ---`n# catzc:`n#   immutable:`n#     with_body_sha: *`n#     warning: `"$script:warning`"`n#     repo_status: locked`n*"
        $head | Should -Not -BeLike '*with_inputs_sha*'
        (Get-Command Format-GeneratedFileHead).Parameters.Keys | Should -Not -Contain 'InputsSha'
    }

    It 'leaves the generator and the source out when the file has none, and lists several sources' {
        $bare = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $bare | Should -BeExactly "/*`n---`ncatzc:`n  immutable:`n    with_body_sha: `"9e2ec912af5d`"`n    warning: `"$script:warning`"`n    repo_status: locked`n    path: docs/gen.gdg`n    role: widget`n    language: gadget`n    filetype: gdg`n    track: docs`n    tracktype: documentation`n---`n*/`n`nbody`n"

        $many = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -Generator New-Gadget -Source 'a/one.yml', 'a/two.yml' -FileKind $script:narrowRole -Carriers $script:carriers -Languages $script:languages
        $many | Should -BeLike "*    source:`n      - a/one.yml`n      - a/two.yml`n    role: gadget`n    subkind: cog`n    language: gadget`n    filetype: gdg`n    track: docs`n    tracktype: documentation`n    generator: widgets/Catzc.Widget/New-Gadget.ps1`n---*"
    }

    It 'leaves the language, the track and the module out for a root file no language lists' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $text | Should -Not -BeLike '*language:*'
        $text | Should -Not -BeLike '*track:*'
        $text | Should -Not -BeLike '*tracktype:*'
        $text | Should -Not -BeLike '*module:*'
    }

    It 'names the track and, under pwsh/, the module the file is placed in' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/gen.wdg" -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeLike "*#     language: widget`n#     filetype: wdg`n#     track: pwsh`n#     tracktype: modules`n#     module: Catzc.Base.Docs`n#     moduletype: pwsh-folder`n# ---*"
        $docs = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.wdg' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $docs | Should -Not -BeLike '*module:*'
    }

    It 'writes the role the caller names, and the subkind only when the file has one' {
        $plain = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.wdg' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages
        $plain | Should -BeLike "*#     role: widget`n#     language:*"
        $plain | Should -Not -BeLike '*subkind:*'
        $sub = Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.wdg' -FileKind $script:narrowRole -Carriers $script:carriers -Languages $script:languages
        $sub | Should -BeLike "*#     role: gadget`n#     subkind: cog`n#     language:*"
    }

    It 'opens the head with the hash of the body, which the head itself and the line endings never move' {
        $arguments = @{ Path = 'docs/gen.wdg'; FileKind = $script:role; Carriers = $script:carriers; Languages = $script:languages }
        $once = Format-GeneratedFileHead -Text "body`n" @arguments
        # The block renderer quotes a value YAML would not read back as the same string, so a hash that opens with a digit is quoted.
        $once | Should -BeLike "*#   immutable:`n#     with_body_sha: `"9e2ec912af5d`"`n#     warning: `"$script:warning`"`n#     repo_status: locked`n#     path: docs/gen.wdg`n*"
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
        $text | Should -BeExactly "{`n  `"`$comment`": `"catzc:\n  immutable:\n    with_body_sha: \`"$hash\`"\n    warning: \`"$script:warning\`"\n    repo_status: locked\n    path: docs/gen.schema.dat\n    role: widget\n    language: data\n    filetype: dat\n    track: docs\n    tracktype: documentation\n    generator: widgets/Catzc.Widget/New-Schema.ps1`",`n  `"type`": `"object`"`n}`n"
    }

    It 'refuses a carrier that holds no head, and an undeclared carrier' {
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.stp' -FileKind $script:role -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*of kind None*'
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.wdg' -Carrier gizmo -FileKind $script:role -Carriers $script:carriers -Languages $script:languages } | Should -Throw "*names the carrier 'gizmo'*"
    }
}
