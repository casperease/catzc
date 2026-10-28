function Get-SlidePictureFinding {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Slides.SlideFault])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [pscustomobject] $Slide,

        # The slide file as its findings name it, repository-relative.
        [Parameter(Mandatory)]
        [string] $Relative,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # A slide has a picture when its head names picture.source; a slide without one is text-only and has nothing to check here.
    $picture = $Slide.Picture
    if ($picture -isnot [System.Collections.IDictionary] -or -not $picture.Contains('source') -or
        [string]::IsNullOrWhiteSpace("$($picture['source'])")) {
        return
    }
    $folder = [System.IO.Path]::GetDirectoryName($Slide.Path)
    $source = [System.IO.Path]::GetFullPath((Join-Path $folder "$($picture['source'])"))
    $sourceRelative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $source).Replace('\', '/')
    $suffix = '.drawio.png'
    if ($sourceRelative.StartsWith('../', [System.StringComparison]::Ordinal) -or
        -not $sourceRelative.EndsWith($suffix, [System.StringComparison]::Ordinal)) {
        [Catzc.Base.Slides.SlideFault]::new($Relative, 'picture',
            "the picture's source '$sourceRelative' is no catalogue diagram, an .assets/<name>$suffix in the repository")
        return
    }
    if (-not [System.IO.File]::Exists($source)) {
        [Catzc.Base.Slides.SlideFault]::new($Relative, 'picture', "the picture's source '$sourceRelative' does not exist")
        return
    }

    # The picture shows a diagram only when the diagram's declaration cites the slide's rule, the code its eyebrow names.
    $cited = (Get-Config -Config drs).CodeForm.Cited
    $eyebrow = if ($Slide.Source.Fields.ContainsKey('eyebrow')) {
        @($Slide.Source.Fields['eyebrow'].Texts()) -join ' '
    }
    else {
        ''
    }
    $rules = [string[]] @([regex]::Matches($eyebrow, "(?<![\w-])$cited(?![\w#-]|:\d)") | ForEach-Object Value |
            Select-Object -Unique)
    $text = Get-DiagramDeclarationText -Stem $sourceRelative.Substring(0, $sourceRelative.Length - $suffix.Length) -RepositoryRoot $RepositoryRoot
    if ($null -eq $text) {
        [Catzc.Base.Slides.SlideFault]::new($Relative, 'picture',
            "the picture's source '$sourceRelative' has no declaration (its .drawio.yml, or one ``yml drawio`` block above its image)")
    }
    elseif ($rules.Count -eq 0) {
        [Catzc.Base.Slides.SlideFault]::new($Relative, 'eyebrow',
            'the slide shows a picture, so its eyebrow names the rule code the picture''s diagram cites; it names none')
    }
    else {
        $declaration = ConvertFrom-Yaml -Yaml $text -Ordered
        $about = if ($declaration -is [System.Collections.IDictionary] -and $declaration.Contains('about')) {
            $declaration['about']
        }
        $aboutRules = [string[]] @(if ($about -is [System.Collections.IDictionary] -and $about.Contains('rules')) {
                $about['rules']
            })
        $covered = @(foreach ($rule in $rules) {
                foreach ($aboutRule in $aboutRules) {
                    if ([Catzc.Base.Maps.CitationScanner]::Covers($rule, $aboutRule)) {
                        $rule
                    }
                }
            })
        if ($covered.Count -eq 0) {
            $cites = if ($aboutRules.Count) {
                $aboutRules -join ', '
            }
            else {
                'no rule'
            }
            [Catzc.Base.Slides.SlideFault]::new($Relative, 'picture',
                "the picture's source '$sourceRelative' cites $cites, never the slide's $($rules -join ', '); show a diagram whose about.rules cites it, or no picture")
        }
    }

    # The picture is made from its source, so a source drawn since is a stale picture.
    if (-not $Slide.Source.Fields.ContainsKey('image')) {
        [Catzc.Base.Slides.SlideFault]::new($Relative, 'image',
            'the head names a picture, so ## Image holds one markdown link to it, [<stem>](<path>)')
        return
    }
    # A field that is no one link is the render's finding; the age is read only of a picture the link names.
    $image = @($Slide.Source.Fields['image'].Items | ForEach-Object Target | Where-Object { $_ })
    if ($image.Count -ne 1) {
        return
    }
    $shown = Join-Path $folder $image[0]
    if ([System.IO.File]::Exists($shown) -and
        [System.IO.File]::GetLastWriteTimeUtc($shown) -lt [System.IO.File]::GetLastWriteTimeUtc($source)) {
        [Catzc.Base.Slides.SlideFault]::new($Relative, 'image',
            "the picture '$($image[0])' is older than its source '$sourceRelative'; make it again with slide_png.py picture")
    }
}
