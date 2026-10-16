<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Modules/Get-CatzcModule.ps1
    name: get-catzc-module
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Modules
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1
    cites:
      - ADR-AUTO-MODULE#1
      - ADR-AUTO-MODULE#2
      - ADR-PWSH-ENUM#3
  config:
    synopsis: Returns the modules of the deployable tracks, resolved through their track.
    description: |-
      The one resolver of a module ([ADR-AUTO-MODULE#1](/docs/adr/automation/module-model.md#rule-adr-auto-module1)). For each deployable
      track (Get-Track, by its track type) it takes the module types the track type admits, finds the modules those types place under the
      track's places, and returns each as a Catzc.Base.Modules.Module: name, track, module type, place, root, shape, files, languages,
      engines and the files the layout does not place. A module exists when its files stand in the layout, so nothing registers it
      ([ADR-AUTO-MODULE#2](/docs/adr/automation/module-model.md#rule-adr-auto-module2)). No track root is spelled here: the places come
      from the track, and the code track is anchored on the loaded code root (Get-CatzcModulesRoot) unless -RepositoryRoot names a tree.

      A folder under a place is a module unless its name starts with a dot. The modules a nested place holds (the internal modules under
      the code track) are left out unless -IncludeInternal asks for them. Modules come in the track's declared order, then in ordinal order
      of their names. A module's languages are those of its live files (the layout marks tests and READMEs not live). A module is laid out, and its unplaced files are reported, only when its track's primary language (the first it
      declares) owns layout rows in languages.yml.
    parameters:
      Name: The module name(s) to return. A name no module has returns nothing for it.
      Track: The deployable track name(s) to look in. Defaults to every deployable track. An unknown track throws.
      TrackType: Only the tracks of these track types ('modules' is the code track). Defaults to every deployable track type.
      IncludeInternal: Also return the modules of nested places, such as the internal modules under the code track.
      RepositoryRoot: |-
        The tree to resolve in, holding the tracks' places. Defaults to the loaded code root for the code track and the repository root
        for any other; pass a fixture tree to isolate a logic test.
    outputs: '[Catzc.Base.Modules.Module] One per module.'
    examples:
      - '(Get-CatzcModule).name                              # -> every module of the deployable tracks'
      - '(Get-CatzcModule -TrackType modules).name           # -> the code track''s modules, the ones the dependency graph orders'
      - '(Get-CatzcModule -Name Catzc.Base.Modules).languages  # -> csharp, markdown, powershell'
      - 'Get-CatzcModule | Where-Object { $_.unplaced }       # -> the modules with a file in no layout row'
---
#>

function Get-CatzcModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Modules.Module])]
    param(
        [ArgumentCompleter({ Get-CatzcModule | ForEach-Object name })]
        [string[]] $Name,

        [ArgumentCompleter({ Get-Track | ForEach-Object name })]
        [string[]] $Track,

        [ArgumentCompleter({ (Get-Config -Config track-types).types.id })]
        [string[]] $TrackType,

        [switch] $IncludeInternal,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $anchored = -not $PSBoundParameters.ContainsKey('RepositoryRoot')
    $trackTypes = Get-Config -Config track-types
    $moduleTypes = Get-Config -Config module-types
    $languages = Get-Config -Config languages
    $byName = [System.Comparison[Catzc.Base.Modules.Module]] { param($a, $b) [string]::CompareOrdinal($a.name, $b.name) }

    $tracks = $Track ? @(Get-Track -Name $Track) : @(Get-Track)
    if ($TrackType) {
        $tracks = @($tracks.Where({ $TrackType -ccontains $_.type }))
    }
    foreach ($trackEntry in $tracks) {
        $typeEntry = $trackTypes.TypeOf($trackEntry.type)
        if ($null -eq $typeEntry -or $typeEntry.role -cne 'deployable') {
            continue
        }

        # A module is laid out when its track's primary language, the first it declares, owns layout rows.
        $primary = $trackEntry.languages.Count -gt 0 ? @($languages.languages.Where({ $_.name -ceq $trackEntry.languages[0] })) : @()
        $laidOut = $primary.Count -gt 0 -and $primary[0].layout.Count -gt 0

        $found = [System.Collections.Generic.List[Catzc.Base.Modules.Module]]::new()
        foreach ($moduleType in $moduleTypes.types.Where({ $typeEntry.admits -ccontains $_.id })) {
            foreach ($place in $moduleType.places) {
                $trackPlace = @($trackEntry.places.Where({ $place.root -ceq $_ -or $place.root.StartsWith("$_/", [System.StringComparison]::Ordinal) }))
                if ($trackPlace.Count -eq 0 -or ($place.root -cne $trackPlace[0] -and -not $IncludeInternal)) {
                    continue
                }

                $directory = if ($anchored -and $typeEntry.id -ceq 'modules') {
                    $tail = $place.root.Substring($trackPlace[0].Length).TrimStart('/')
                    $tail ? (Join-Path (Get-CatzcModulesRoot) $tail) : (Get-CatzcModulesRoot)
                }
                else {
                    Join-Path $RepositoryRoot $place.root
                }
                if (-not (Test-Path -LiteralPath $directory -PathType Container)) {
                    continue
                }

                foreach ($entry in Get-PlaceModuleEntry -Place $place -Directory $directory) {
                    if ($Name -and $Name -cnotcontains $entry.Name) {
                        continue
                    }

                    $files = [System.Collections.Generic.List[string]]::new()
                    if ($entry.Shape -ceq 'file') {
                        $files.Add($entry.Root.Substring($place.root.Length + 1))
                    }
                    else {
                        # A whole module tree is listed on purpose (ADR-PWSH-ENUM#3): tests nest fixtures up to six levels below the module.
                        $prefixLength = $entry.Folder.TrimEnd('\', '/').Length + 1
                        foreach ($path in Get-ChildPath $entry.Folder -File -Depth 8) {
                            $files.Add($path.Substring($prefixLength).Replace('\', '/'))
                        }
                    }

                    $languageNames = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
                    $unplaced = [System.Collections.Generic.List[string]]::new()
                    foreach ($file in $files) {
                        $row = $laidOut -and $entry.Shape -ceq 'folder' ? $languages.PlaceOf($file) : $null
                        if ($laidOut -and $entry.Shape -ceq 'folder' -and $null -eq $row) {
                            $unplaced.Add($file)
                        }
                        # The languages of a module are those of its live files: a test, or a README, is no second tech-stack.
                        $language = $null -eq $row -or $row.live ? $languages.ForPath($file) : $null
                        if ($language) {
                            [void] $languageNames.Add($language.name)
                        }
                    }

                    $found.Add([Catzc.Base.Modules.Module]::new(
                            $entry.Name, $trackEntry.name, $moduleType.id, $place.root, $entry.Root, $entry.Shape,
                            $files.ToArray(), [string[]]$languageNames, [string[]]$trackEntry.EnginesOf($entry.Name), $unplaced.ToArray()))
                }
            }
        }

        $found.Sort($byName)
        $found
    }
}
