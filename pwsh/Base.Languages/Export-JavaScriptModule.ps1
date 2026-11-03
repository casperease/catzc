function Export-JavaScriptModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $Destination,

        [switch] $Silent
    )

    $repositoryRoot = Get-RepositoryRoot
    $moduleRelative = if ([System.IO.Path]::IsPathRooted($Module)) {
        [System.IO.Path]::GetRelativePath($repositoryRoot, $Module)
    }
    else {
        $Module
    }
    $moduleRelative = $moduleRelative.Replace('\', '/').TrimEnd('/')

    # Only what git tracks ships, and no test
    # ([ADR-AUTO-BUNDLE-EVERYLANGUAGE](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)).
    $files = [System.Collections.Generic.List[string]]::new()
    $files.AddRange([string[]]@(Get-ModuleShippedFile $moduleRelative))
    # Sorted ordinally, so a rebuild writes the same bytes
    # ([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
    $files.Sort([System.StringComparer]::Ordinal)
    $moduleFolder = [System.IO.Path]::Combine($repositoryRoot, $moduleRelative)
    $null = [System.IO.Directory]::CreateDirectory($Destination)

    # An extension declares the editor engine in its package.json; any other module ships as source.
    $manifestPath = [System.IO.Path]::Combine($moduleFolder, 'package.json')
    $package = $null
    if ($files.Contains('package.json') -and [System.IO.File]::Exists($manifestPath)) {
        $package = [System.IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json
    }

    $rendered = $null
    $render = Get-Command Export-VsCodeExtensionFolder -ErrorAction Ignore
    if ($null -eq $package -and -not $files.Contains('package.json') -and $null -ne $render) {
        $scratch = [System.IO.Path]::Combine($Destination, ".render-$([guid]::NewGuid().ToString('N'))")
        try {
            $folder = & $render -Module $moduleRelative -OutputDirectory $scratch
            if (-not [string]::IsNullOrEmpty($folder)) {
                $rendered = [System.Collections.Generic.Dictionary[string, byte[]]]::new([System.StringComparer]::Ordinal)
                foreach ($path in @(Get-ChildPath $folder -File -Depth 16 -Exclude @() -PruneVendor $false)) {
                    $rendered[[System.IO.Path]::GetRelativePath($folder, $path).Replace('\', '/')] = [System.IO.File]::ReadAllBytes($path)
                }
            }
        }
        finally {
            if ([System.IO.Directory]::Exists($scratch)) {
                [System.IO.Directory]::Delete($scratch, $true)
            }
        }
        if ($null -ne $rendered -and $rendered.ContainsKey('package.json')) {
            $files.Clear()
            $files.AddRange($rendered.Keys)
            $files.Sort([System.StringComparer]::Ordinal)
            $package = [System.Text.Encoding]::UTF8.GetString($rendered['package.json']) | ConvertFrom-Json
        }
        else {
            $rendered = $null
        }
    }
    $isExtension = $null -ne $package -and $null -ne $package.PSObject.Properties['engines'] -and
    $null -ne $package.engines.PSObject.Properties['vscode']

    if (-not $isExtension) {
        foreach ($file in $files) {
            $target = [System.IO.Path]::Combine($Destination, $file)
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target))
            [System.IO.File]::Copy([System.IO.Path]::Combine($moduleFolder, $file), $target, $true)
        }
        if (-not $Silent) {
            Write-Message "Packaged javascript module $moduleRelative -> $Destination ($($files.Count) files)"
        }
        return [pscustomobject]@{
            Module      = $moduleRelative
            Destination = $Destination
            Form        = 'source'
            Files       = $files.Count
            Artifact    = $null
        }
    }

    $fields = @{}
    foreach ($field in 'publisher', 'name', 'version') {
        $property = $package.PSObject.Properties[$field]
        if ($null -eq $property -or [string]::IsNullOrWhiteSpace("$($property.Value)")) {
            throw "Export-JavaScriptModule: the package.json of '$moduleRelative' declares no '$field'."
        }
        $fields[$field] = "$($property.Value)"
    }
    $escape = { param($Text) [System.Security.SecurityElement]::Escape($Text) }
    $displayName = if ($null -ne $package.PSObject.Properties['displayName']) {
        "$($package.displayName)"
    }
    else {
        $fields['name']
    }
    $description = if ($null -ne $package.PSObject.Properties['description']) {
        "$($package.description)"
    }
    else {
        ''
    }
    $packageManifest = @(
        '<?xml version="1.0" encoding="utf-8"?>'
        '<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">'
        '  <Metadata>'
        "    <Identity Language=`"en-US`" Id=`"$(& $escape $fields['name'])`" Version=`"$(& $escape $fields['version'])`" Publisher=`"$(& $escape $fields['publisher'])`" />"
        "    <DisplayName>$(& $escape $displayName)</DisplayName>"
        "    <Description xml:space=`"preserve`">$(& $escape $description)</Description>"
        '    <Properties>'
        "      <Property Id=`"Microsoft.VisualStudio.Code.Engine`" Value=`"$(& $escape "$($package.engines.vscode)")`" />"
        '    </Properties>'
        '  </Metadata>'
        '  <Installation>'
        '    <InstallationTarget Id="Microsoft.VisualStudio.Code" />'
        '  </Installation>'
        '  <Assets>'
        '    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true" />'
        '  </Assets>'
        '</PackageManifest>'
    ) -join "`n"

    $types = @{ '.vsixmanifest' = 'text/xml' }
    $known = @{ '.json' = 'application/json'; '.js' = 'application/javascript'; '.svg' = 'image/svg+xml'; '.md' = 'text/markdown'
        '.png' = 'image/png'; '.txt' = 'text/plain'; '.yml' = 'text/plain'
    }
    foreach ($file in $files) {
        $extension = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
        if ($extension.Length -gt 0) {
            $types[$extension] = if ($known.ContainsKey($extension)) {
                $known[$extension]
            }
            else {
                'application/octet-stream'
            }
        }
    }
    $contentTypes = @(
        '<?xml version="1.0" encoding="utf-8"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        foreach ($extension in ($types.Keys | Sort-Object { $_ } -CaseSensitive)) {
            "  <Default Extension=`"$extension`" ContentType=`"$($types[$extension])`" />"
        }
        '</Types>'
    ) -join "`n"

    # A fixed timestamp and sorted entries make two exports byte-identical
    # ([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
    $stamp = [System.DateTimeOffset]::new(1980, 1, 1, 0, 0, 0, [System.TimeSpan]::Zero)
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $entries = [System.Collections.Generic.SortedDictionary[string, byte[]]]::new([System.StringComparer]::Ordinal)
    $entries['[Content_Types].xml'] = $utf8.GetBytes($contentTypes + "`n")
    $entries['extension.vsixmanifest'] = $utf8.GetBytes($packageManifest + "`n")
    foreach ($file in $files) {
        $entries["extension/$file"] = if ($null -ne $rendered) {
            $rendered[$file]
        }
        else {
            [System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($moduleFolder, $file))
        }
    }
    $stream = [System.IO.MemoryStream]::new()
    $archive = [System.IO.Compression.ZipArchive]::new($stream, [System.IO.Compression.ZipArchiveMode]::Create, $true)
    try {
        foreach ($name in $entries.Keys) {
            $entry = $archive.CreateEntry($name, [System.IO.Compression.CompressionLevel]::Optimal)
            $entry.LastWriteTime = $stamp
            $entryStream = $entry.Open()
            try {
                $entryStream.Write($entries[$name], 0, $entries[$name].Length)
            }
            finally {
                $entryStream.Dispose()
            }
        }
    }
    finally {
        $archive.Dispose()
    }
    $artifact = [System.IO.Path]::Combine($Destination, "$($fields['publisher']).$($fields['name'])-$($fields['version']).vsix")
    [System.IO.File]::WriteAllBytes($artifact, $stream.ToArray())
    $stream.Dispose()

    if (-not $Silent) {
        Write-Message "Packaged javascript extension $moduleRelative -> $artifact ($($files.Count) files)"
    }
    [pscustomobject]@{
        Module      = $moduleRelative
        Destination = $Destination
        Form        = 'vsix'
        Files       = $files.Count
        Artifact    = $artifact
    }
}
