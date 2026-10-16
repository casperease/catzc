<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
    folder: tests
    name: get-file-language-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
    cites:
      - ADR-DSGN-TRACK#{1,3,6}
---
#>

Describe 'Get-FileLanguage' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{
                languages = [ordered]@{
                    widget = [ordered]@{ extensions = @('.wdg', '.widget'); formatter = 'prettier'; adr_folder = 'widgets' }
                    gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'binary gadgets' }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'languages' } { $script:fixture }
    }

    It 'returns every file language in declared order on the zero-argument call' {
        $languages = @(Get-FileLanguage)
        $languages[0] | Should -BeOfType [Catzc.Base.Languages.FileLanguage]
        $languages.name | Should -Be @('widget', 'gadget')
    }

    It 'returns the named file languages' {
        (Get-FileLanguage -Name widget).formatter | Should -Be 'prettier'
        @(Get-FileLanguage -Name gadget, widget).name | Should -Be @('gadget', 'widget')
    }

    It 'throws on an unknown name, naming the config file and the declared languages' {
        { Get-FileLanguage -Name gizmo } | Should -Throw "*Unknown file language 'gizmo'*languages.yml*widget, gadget*"
    }

    It 'returns the file language of a known extension, in any case and at any depth' {
        (Get-FileLanguage -Path 'widget/Get-Widget.wdg').name | Should -Be 'widget'
        (Get-FileLanguage -Path 'widget\deep\nested\Gadget.Sprocket.WIDGET').name | Should -Be 'widget'
        (Get-FileLanguage -Path 'gadget.gdg').name | Should -Be 'gadget'
    }

    It 'returns nothing, never throwing, for an unknown extension, a dotfile, no extension, and an empty path' {
        Get-FileLanguage -Path 'widget/gizmo.gzm' | Should -BeNullOrEmpty
        Get-FileLanguage -Path 'widget/.gitkeep' | Should -BeNullOrEmpty
        Get-FileLanguage -Path 'widget/.wdg' | Should -BeNullOrEmpty
        Get-FileLanguage -Path 'widget/WIDGET' | Should -BeNullOrEmpty
        Get-FileLanguage -Path '' | Should -BeNullOrEmpty
    }
}

Describe 'Get-FileLanguage — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:tracked = @(Get-GitTrackedPath '.')
        $script:tracks = @(Get-Track)
        $script:aspectTracks = (Get-Config -Config variants).aspects

        $script:globRegex = {
            param([string] $Glob)
            $builder = [System.Text.StringBuilder]::new('^')
            $i = 0
            while ($i -lt $Glob.Length) {
                $c = $Glob[$i]
                if ($c -eq '*' -and $i + 1 -lt $Glob.Length -and $Glob[$i + 1] -eq '*') {
                    if ($i + 2 -lt $Glob.Length -and $Glob[$i + 2] -eq '/') {
                        [void] $builder.Append('(?:.*/)?')
                        $i += 3
                    }
                    else {
                        [void] $builder.Append('.*')
                        $i += 2
                    }
                }
                elseif ($c -eq '*') {
                    [void] $builder.Append('[^/]*')
                    $i++
                }
                elseif ($c -eq '?') {
                    [void] $builder.Append('[^/]')
                    $i++
                }
                else {
                    [void] $builder.Append([regex]::Escape([string] $c))
                    $i++
                }
            }
            [void] $builder.Append('$')
            $builder.ToString()
        }

        $script:isLive = {
            param([string] $File, $Track)
            if ($Track.type -in 'verification', 'vendored-code') {
                return $false
            }
            $relative = $File.Substring($Track.PlaceLengthOf($File) + 1)
            if ($null -eq $script:aspectTracks -or -not $script:aspectTracks.ContainsKey($Track.name)) {
                return $true
            }
            $slash = $relative.IndexOf('/')
            $unitRelative = $slash -lt 0 ? $relative : $relative.Substring($slash + 1)
            foreach ($aspect in Get-Aspect -Track $Track.name) {
                foreach ($pattern in $aspect.Patterns) {
                    if ($unitRelative -match (& $script:globRegex $pattern)) {
                        return $aspect.Name -eq 'live'
                    }
                }
            }
            $false
        }
    }

    It 'declares a track for every root folder git tracks a file under, except out/' {
        $roots = @($script:tracked | Where-Object { $_.Contains('/') } | ForEach-Object { $_.Split('/')[0] } |
                Sort-Object -Unique | Where-Object { $_ -ne 'out' })
        $roots.Count | Should -BeGreaterThan 0
        $undeclared = @($roots | Where-Object { $null -eq (Get-Track -Path $_) })
        $undeclared | Should -BeNullOrEmpty -Because 'every root folder with tracked files is a track (ADR-DSGN-TRACK#1)'
    }

    It 'registers every file language a track declares' {
        $registered = @(Get-FileLanguage | ForEach-Object name)
        $unknown = @(foreach ($track in $script:tracks) {
                foreach ($language in $track.languages) {
                    if ($language -notin $registered) {
                        "$($track.name): $language"
                    }
                }
            })
        $unknown | Should -BeNullOrEmpty -Because 'a track declares its tech-stack in registered file languages (ADR-DSGN-TRACK#6)'
    }

    It 'names an existing ADR folder for every file language that declares one' {
        $missing = @(Get-FileLanguage | Where-Object { $null -ne $_.adr_folder } |
                Where-Object { -not (Test-Path -LiteralPath (Join-Path (Get-RepositoryRoot) "docs/adr/$($_.adr_folder)") -PathType Container) } |
                ForEach-Object { "$($_.name): docs/adr/$($_.adr_folder)" })
        $missing | Should -BeNullOrEmpty
    }

    It "keeps every live file of a track in the track's declared file languages" {
        $violations = [System.Collections.Generic.SortedDictionary[string, System.Collections.Generic.List[string]]]::new([System.StringComparer]::Ordinal)
        foreach ($file in $script:tracked) {
            $slash = $file.IndexOf('/')
            if ($slash -lt 0) {
                continue
            }
            $track = Get-Track -Path $file
            if ($null -eq $track -or -not (& $script:isLive $file $track)) {
                continue
            }
            $extension = [Catzc.Base.Languages.LanguagesConfig]::ExtensionOf($file)
            if ($null -eq $extension) {
                continue
            }
            $language = Get-FileLanguage -Path $file
            if ($null -ne $language -and $language.name -in $track.languages) {
                continue
            }
            $key = '{0} {1} ({2})' -f $track.name, $extension, ($null -eq $language ? 'no file language' : $language.name)
            if (-not $violations.ContainsKey($key)) {
                $violations[$key] = [System.Collections.Generic.List[string]]::new()
            }
            $violations[$key].Add($file)
        }
        $report = @(foreach ($key in $violations.Keys) {
                '{0}: {1} file(s), e.g. {2}' -f $key, $violations[$key].Count, $violations[$key][0]
            })
        $report | Should -BeNullOrEmpty -Because 'a live file outside its track''s file languages is a second tech-stack (ADR-DSGN-TRACK#3)'
    }
}
