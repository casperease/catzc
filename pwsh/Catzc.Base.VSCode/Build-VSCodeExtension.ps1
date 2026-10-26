<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/Build-VSCodeExtension.ps1.md"
  header: "generated"
---
#>

function Build-VsCodeExtension {
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
    $text = Get-Content -LiteralPath $manifestPath -Raw
    # Every rendered manifest is held against the extension manifest contract before it is packed; a mismatch stops the build.
    $repositoryRoot = Get-RepositoryRoot
    $contract = @(Get-Contract catzc -Group catzc.base.vs_code -Path package.schema.json -RepositoryRoot $repositoryRoot)
    Assert-True ($contract.Count -eq 1) -ErrorText 'Build-VsCodeExtension: the extension manifest contract (contracts/catzc/0.1.0/catzc.base.vs_code/package.schema.json) is missing.'
    $schema = ConvertTo-BclValue ([System.IO.File]::ReadAllText((Join-Path $repositoryRoot $contract[0].AssetPath)) | ConvertFrom-Json -AsHashtable -NoEnumerate)
    $findings = @([Catzc.Base.Contracts.ContractSchema]::Validate($schema, (ConvertTo-BclValue ($text | ConvertFrom-Json -AsHashtable -NoEnumerate))))
    Assert-True ($findings.Count -eq 0) -ErrorText "Build-VsCodeExtension: '$manifestPath' breaks the extension manifest contract:`n$($findings -join "`n")"
    $manifest = $text | ConvertFrom-Json
    # The manifest is read under strict mode, so an absent field is looked up, never dotted.
    $read = { param($Node, [string] $Field) if ($null -ne $Node -and $Node.PSObject.Properties[$Field]) {
            $Node.$Field
        } }
    $engine = (& $read (& $read $manifest 'engines') 'vscode') ?? '*'
    $displayName = (& $read $manifest 'displayName') ?? $manifest.name
    $description = (& $read $manifest 'description') ?? ''
    $escape = { param([string] $Value) [System.Security.SecurityElement]::Escape($Value) }

    $files = @(Get-ChildPath $folder -File -Depth 16 -Exclude @() -PruneVendor $false)
    $contentTypes = @{ '.vsixmanifest' = 'text/xml'; '.json' = 'application/json'; '.js' = 'application/javascript'; '.md' = 'text/markdown'; '.svg' = 'image/svg+xml' }
    $extensions = @($files | ForEach-Object { [System.IO.Path]::GetExtension($_).ToLowerInvariant() } | Where-Object { $_ } | Sort-Object -Unique) + '.vsixmanifest' | Sort-Object -Unique
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
    $packagePath = Join-Path (Resolve-Path -LiteralPath $OutputDirectory).Path "$($manifest.name)-$($manifest.version).vsix"
    if (Test-Path -LiteralPath $packagePath) {
        Remove-Item -LiteralPath $packagePath
    }

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $zip = [System.IO.Compression.ZipFile]::Open($packagePath, [System.IO.Compression.ZipArchiveMode]::Create)
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
            $relative = [System.IO.Path]::GetRelativePath($folder, $file) -replace '\\', '/'
            & $addBytes "extension/$relative" ([System.IO.File]::ReadAllBytes($file))
        }
    }
    finally {
        $zip.Dispose()
    }

    $packagePath
}
