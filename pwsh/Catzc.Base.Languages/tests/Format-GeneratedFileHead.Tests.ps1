Describe 'Format-GeneratedFileHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
    BeforeAll {
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
        $script:arguments = @{ Carriers = $script:carriers; Languages = $script:languages }
    }

    BeforeEach {
        # Whether git tracks the path: a tracked path comes back from the index read, an untracked one does not; a
        # fixture stands for it here.
        $script:tracked = $true
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { if ($script:tracked) {
                $Path
            } }
    }

    It 'writes the one declared warning into every head, whatever the carrier' {
        $heads = @(
            Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.wdg' -Carriers $script:carriers -Languages $script:languages
            Format-GeneratedFileHead -Text "body`n" -Path 'docs/gen.gdg' -Carriers $script:carriers -Languages $script:languages
            Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket -Carriers $script:carriers -Languages $script:languages
            Format-GeneratedFileHead -Text "{`n  `"a`": 1`n}`n" -Path 'docs/gen.dat' -Carriers $script:carriers -Languages $script:languages
        )
        foreach ($head in $heads) {
            $head | Should -BeLike "*warning: *$script:warning*"
        }
        $script:warning | Should -BeExactly ([Catzc.Base.Languages.GeneratedHeadConfig]::DefaultWarning)
    }

    It 'writes the body hash of a tracked file and the warning, and nothing else, in the comment style of the file language' {
        $text = Format-GeneratedFileHead -Text "widget body`n" -Path 'docs/gen.wdg' -Carriers $script:carriers -Languages $script:languages
        $text |
            Should -BeExactly "# ---`n# catzc:`n#   immutable:`n#     with_body_sha: `"9534a2e15c8b`"`n#     warning: `"$script:warning`"`n# ---`n`nwidget body`n"
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Languages -Times 1 -ParameterFilter { $Path -contains 'docs/gen.wdg' }
    }

    It 'opens the immutable part with the body hash, so the head reads immutable for this body, whatever the carrier' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        foreach ($path in 'docs/gen.wdg', 'docs/gen.gdg') {
            $text = Format-GeneratedFileHead -Text "body`n" -Path $path -Carriers $script:carriers -Languages $script:languages
            $text |
                Should -Match '(?m)^\W*immutable:\r?\n\W*with_body_sha: ' -Because "the first key under immutable in $path is the body hash"
        }
    }

    It 'writes the warning only on a file git does not track' {
        $script:tracked = $false
        $text = Format-GeneratedFileHead -Text "widget body`n" -Path 'docs/gen.wdg' -Carriers $script:carriers -Languages $script:languages
        $text |
            Should -BeExactly "# ---`n# catzc:`n#   immutable:`n#     warning: `"$script:warning`"`n# ---`n`nwidget body`n"
    }

    It 'writes no place fact, no generator, no source and no edge: each is derived on demand' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path "$(Get-CatzcModulesFolder)/Catzc.Base.Docs/gen.wdg" -Carriers $script:carriers -Languages $script:languages
        foreach ($key in 'role', 'track', 'generator', 'source', 'with_inputs_sha', 'docs', 'edges') {
            $text | Should -Not -BeLike "*#     ${key}:*"
            $text | Should -Not -BeLike "*#   ${key}:*"
        }
        foreach ($parameter in 'Generator', 'Source', 'FileKind', 'Pages', 'InputsSha') {
            (Get-Command Format-GeneratedFileHead).Parameters.Keys | Should -Not -Contain $parameter
        }
    }

    It 'hashes the body only, which the head itself and the line endings never move' {
        $arguments = @{ Path = 'docs/gen.wdg' } + $script:arguments
        $once = Format-GeneratedFileHead -Text "body`n" @arguments
        # The block renderer quotes a value YAML would not read back as the same string, so a hash that opens with a
        # digit is quoted.
        $once | Should -BeLike "*#     with_body_sha: `"9e2ec912af5d`"`n*"
        Format-GeneratedFileHead -Text $once @arguments | Should -BeLike '*with_body_sha: "9e2ec912af5d"*'
        Format-GeneratedFileHead -Text "body`r`n" @arguments | Should -BeLike '*with_body_sha: "9e2ec912af5d"*'
        Format-GeneratedFileHead -Text "other`n" @arguments | Should -Not -BeLike '*with_body_sha: "9e2ec912af5d"*'
    }

    It 'is stable: a second run over its own output changes nothing, tracked or not' -ForEach @(@{ Exit = 0 }, @{ Exit = 1 }) {
        $script:tracked = $Exit -eq 0
        $arguments = @{ Path = 'docs/gen.gdg' } + $script:arguments
        $once = Format-GeneratedFileHead -Text "body`n" @arguments
        Format-GeneratedFileHead -Text $once @arguments | Should -BeExactly $once
    }

    It 'uses a named carrier for a file whose class has no language, such as a dotfile' {
        $text = Format-GeneratedFileHead -Text "body`n" -Path 'sprocket' -Carrier sprocket -Carriers $script:carriers -Languages $script:languages
        $text | Should -BeLike "// ---`n// catzc:*`n// ---`n`nbody`n"
        { Format-GeneratedFileHead -Text 'body' -Path 'sprocket' -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*has no file language*-Carrier*'
    }

    It 'writes a property carrier into JSON, replacing an old banner its carrier strips' {
        $json = "{`n  `"`$comment`": `"$script:warning`",`n  `"type`": `"object`"`n}`n"
        $bare = Format-PropertyMetaHead -Text $json -Property '$comment' -Strip @($script:warning) -Immutable ([ordered]@{})
        $hash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($bare)
        $text = Format-GeneratedFileHead -Text $json -Path 'docs/gen.schema.dat' -Carrier schema -Carriers $script:carriers -Languages $script:languages
        $text |
            Should -BeExactly "{`n  `"`$comment`": `"catzc:\n  immutable:\n    with_body_sha: \`"$hash\`"\n    warning: \`"$script:warning\`"`",`n  `"type`": `"object`"`n}`n"
    }

    It 'refuses a carrier that holds no head, and an undeclared carrier' {
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.stp' -Carriers $script:carriers -Languages $script:languages } | Should -Throw '*of kind None*'
        { Format-GeneratedFileHead -Text 'body' -Path 'docs/gen.wdg' -Carrier gizmo -Carriers $script:carriers -Languages $script:languages } | Should -Throw "*names the carrier 'gizmo'*"
    }
}
