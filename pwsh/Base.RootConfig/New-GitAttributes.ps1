function New-GitAttributes {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $placeholder = '{{file-kind-attributes}}'
    $width = 118

    $templatePath = Get-CatzcModuleRoot 'assets/root/.gitattributes-template'
    Assert-PathExist $templatePath
    $template = [System.IO.File]::ReadAllText($templatePath) -replace "`r`n", "`n"

    $placeholderLines = @($template -split "`n" | Where-Object { $_ -eq $placeholder })
    if ($placeholderLines.Count -ne 1) {
        throw "The .gitattributes template must hold the line '$placeholder' exactly once, found $($placeholderLines.Count): $templatePath"
    }

    $blocks = [System.Collections.Generic.List[string]]::new()
    $addBlock = {
        param([string] $Why, [string[]] $Globs, [string[]] $Attributes)
        $lines = [System.Collections.Generic.List[string]]::new()
        $current = '# catzc:'
        foreach ($word in ($Why -split '\s+' | Where-Object { $_ })) {
            if (($current.Length + 1 + $word.Length) -gt $width -and $current -ne '#') {
                $lines.Add($current)
                $current = '#'
            }
            $current += " $word"
        }
        $lines.Add($current)
        foreach ($glob in $Globs) {
            $lines.Add("$glob $($Attributes -join ' ')")
        }
        $blocks.Add($lines -join "`n")
    }
    foreach ($kind in (Get-Config -Config file-kinds).kinds) {
        foreach ($entry in @($kind.subkinds) + $kind) {
            if (@($entry.gitAttributes).Count -gt 0) {
                & $addBlock $entry.gitWhy @($entry.files) @($entry.gitAttributes)
            }
        }
    }
    # A track type that declares attributes gives them to every file under each place of each track of that type.
    $trackTypes = Get-Config -Config track-types
    foreach ($track in @(Get-Track)) {
        $type = $trackTypes.TypeOf($track.type)
        if ($type -and @($type.gitAttributes).Count -gt 0) {
            & $addBlock $type.gitWhy @($track.places | ForEach-Object { "$_/**" }) @($type.gitAttributes)
        }
    }

    $generatedPlaceholder = '{{generated-files}}'
    if (@($template -split "`n" | Where-Object { $_ -eq $generatedPlaceholder }).Count -ne 1) {
        throw "The .gitattributes template must hold the line '$generatedPlaceholder' exactly once: $templatePath"
    }
    $anchor = { param([string] $Glob) if ($Glob.StartsWith('**/', [System.StringComparison]::Ordinal)) {
            $Glob
        }
        else {
            "/$Glob"
        } }
    $generated = [System.Collections.Generic.List[string]]::new()
    foreach ($writer in @(Get-GeneratedWriterOrder | Where-Object { -not $_.expands -and $_.class -cne 'untracked' })) {
        foreach ($output in $writer.outputs) {
            $generated.Add("$(& $anchor $output.path) linguist-generated")
        }
    }
    foreach ($file in @((Get-Config -Config rootconfig).files | Where-Object { $_.committed })) {
        $generated.Add("$(& $anchor $file.target) linguist-generated")
    }

    $template.Replace($placeholder, ($blocks -join "`n`n")).Replace($generatedPlaceholder,
        (@($generated | Select-Object -Unique) -join "`n"))
}
