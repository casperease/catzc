<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/Build-VSCodeExtension.ps1
    name: build-vs-code-extension
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.VSCode/tests/Build-VSCodeExtension.Tests.ps1
  config:
    synopsis: Packs one extension folder, the one that holds a package.json, into a .vsix the editor installs.
    description: |-
      A .vsix is a zip of the folder under `extension/`, with an `extension.vsixmanifest` that names the identity (publisher, name, version)
      and the editor engine, and a `[Content_Types].xml` that types each file extension. This writes that zip from the folder's
      package.json alone, so no node tooling is needed, and the editor writes its own registry entry when it installs the file.

      The package is written to `<output>/vsix/<name>-<version>.vsix` and replaces an older file of that name.
    parameters:
      Path: The extension folder, absolute or relative to the repository root. It must hold a package.json with name, version and publisher.
      OutputDirectory: 'The folder the .vsix is written to. Default: the vsix folder under the output root.'
    outputs: '[string] The full path of the .vsix.'
    examples:
      - Build-VSCodeExtension .vscode/catzc-compiled-info
---
#>

function Build-VSCodeExtension {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $OutputDirectory = (Join-Path (Get-OutputRoot) 'vsix')
    )

    $folder = [System.IO.Path]::GetFullPath($Path, (Get-RepositoryRoot))
    $manifestPath = Join-Path $folder 'package.json'
    Assert-PathExist $manifestPath
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    # The manifest is read under strict mode, so an absent field is looked up, never dotted.
    $read = { param($Node, [string] $Field) if ($null -ne $Node -and $Node.PSObject.Properties[$Field]) { $Node.$Field } }
    foreach ($field in 'name', 'version', 'publisher') {
        Assert-NotNull (& $read $manifest $field) -ErrorText "Build-VSCodeExtension: '$manifestPath' has no '$field'."
    }
    $engine = (& $read (& $read $manifest 'engines') 'vscode') ?? '*'
    $displayName = (& $read $manifest 'displayName') ?? $manifest.name
    $description = (& $read $manifest 'description') ?? ''
    $escape = { param([string] $Value) [System.Security.SecurityElement]::Escape($Value) }

    $files = @(Get-ChildItem -LiteralPath $folder -Recurse -File)
    $contentTypes = @{ '.vsixmanifest' = 'text/xml'; '.json' = 'application/json'; '.js' = 'application/javascript'; '.md' = 'text/markdown' }
    $extensions = @($files | ForEach-Object { $_.Extension.ToLowerInvariant() } | Where-Object { $_ } | Sort-Object -Unique) + '.vsixmanifest' | Sort-Object -Unique
    $defaults = foreach ($extension in $extensions) {
        $type = if ($contentTypes.ContainsKey($extension)) {
            $contentTypes[$extension]
        }
        else {
            'application/octet-stream'
        }
        "  <Default Extension=`"$extension`" ContentType=`"$type`"/>"
    }
    $typesXml = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<Types xmlns=`"http://schemas.openxmlformats.org/package/2006/content-types`">`n$($defaults -join "`n")`n</Types>`n"
    $manifestXml = @"
<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">
  <Metadata>
    <Identity Language="en-US" Id="$(& $escape $manifest.name)" Version="$(& $escape $manifest.version)" Publisher="$(& $escape $manifest.publisher)"/>
    <DisplayName>$(& $escape $displayName)</DisplayName>
    <Description xml:space="preserve">$(& $escape $description)</Description>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code" Version="$(& $escape $engine)"/>
  </Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true"/>
  </Assets>
</PackageManifest>

"@ -replace "`r`n", "`n"

    $null = New-Item -ItemType Directory -Path $OutputDirectory -Force
    $vsix = Join-Path (Resolve-Path -LiteralPath $OutputDirectory).Path "$($manifest.name)-$($manifest.version).vsix"
    if (Test-Path -LiteralPath $vsix) {
        Remove-Item -LiteralPath $vsix
    }

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $zip = [System.IO.Compression.ZipFile]::Open($vsix, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        $addBytes = {
            param([string] $EntryName, [byte[]] $Bytes)
            $stream = $zip.CreateEntry($EntryName).Open()
            try {
                $stream.Write($Bytes, 0, $Bytes.Length)
            }
            finally {
                $stream.Dispose()
            }
        }
        & $addBytes '[Content_Types].xml' $utf8.GetBytes($typesXml)
        & $addBytes 'extension.vsixmanifest' $utf8.GetBytes($manifestXml)
        foreach ($file in $files) {
            $relative = [System.IO.Path]::GetRelativePath($folder, $file.FullName) -replace '\\', '/'
            & $addBytes "extension/$relative" ([System.IO.File]::ReadAllBytes($file.FullName))
        }
    }
    finally {
        $zip.Dispose()
    }

    $vsix
}
