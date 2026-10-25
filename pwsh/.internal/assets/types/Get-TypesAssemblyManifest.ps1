$script:typesAliasAttribute = 'Catzc.Base.Objects.PSTypeAliasAttribute'
$script:typesDisplayAttribute = 'Catzc.Base.Objects.ConsoleDisplayAttribute'

function Get-TypesAssemblyManifest {
    # .SYNOPSIS
    #     Lists the public types of a combined types assembly with the facts the importer registers for them, reading metadata only.
    # .DESCRIPTION
    #     For each public top-level type: its full name, the PSTypeAlias names it declares, and the ConsoleDisplay properties that
    #     apply to it (its own, else the nearest base type's in the same assembly, as the attribute is inherited). The file is read
    #     into memory and parsed with System.Reflection.Metadata, so the assembly is never loaded and the file never locked.
    # .PARAMETER Path
    #     The assembly file to read.
    # .OUTPUTS
    #     [pscustomobject] with Types: the types sorted ordinally by Name, each with Name, Aliases and Display (string arrays).
    # .EXAMPLE
    #     (Get-TypesAssemblyManifest -Path $dll).Types
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not [System.IO.File]::Exists($Path)) {
        throw "Cannot read the types assembly: '$Path' does not exist."
    }

    $tokens = [System.Reflection.Metadata.Ecma335.MetadataTokens]
    $rows = @{}
    $stream = [System.IO.MemoryStream]::new([System.IO.File]::ReadAllBytes($Path))
    $peReader = [System.Reflection.PortableExecutable.PEReader]::new($stream)
    try {
        $reader = [System.Reflection.Metadata.PEReaderExtensions]::GetMetadataReader($peReader)
        foreach ($handle in $reader.TypeDefinitions) {
            $definition = $reader.GetTypeDefinition($handle)
            $aliases = [System.Collections.Generic.List[string]]::new()
            $display = $null
            foreach ($attributeHandle in $definition.GetCustomAttributes()) {
                $attribute = $reader.GetCustomAttribute($attributeHandle)
                if ($attribute.Constructor.Kind -ne [System.Reflection.Metadata.HandleKind]::MethodDefinition) {
                    continue
                }
                $constructor = $reader.GetMethodDefinition($tokens::MethodDefinitionHandle($tokens::GetRowNumber($attribute.Constructor)))
                $attributeType = $reader.GetTypeDefinition($constructor.GetDeclaringType())
                $attributeName = $reader.GetString($attributeType.Namespace) + '.' + $reader.GetString($attributeType.Name)
                if ($attributeName -ne $script:typesAliasAttribute -and $attributeName -ne $script:typesDisplayAttribute) {
                    continue
                }
                $blob = $reader.GetBlobReader($attribute.Value)
                [void] $blob.ReadUInt16()
                if ($attributeName -eq $script:typesAliasAttribute) {
                    $aliases.Add($blob.ReadSerializedString())
                }
                else {
                    $display = [System.Collections.Generic.List[string]]::new()
                    $count = $blob.ReadInt32()
                    for ($i = 0; $i -lt $count; $i++) {
                        $display.Add($blob.ReadSerializedString())
                    }
                }
            }
            $base = $null
            if ($definition.BaseType.Kind -eq [System.Reflection.Metadata.HandleKind]::TypeDefinition) {
                $base = $tokens::GetRowNumber($definition.BaseType)
            }
            $rows[$tokens::GetRowNumber($handle)] = [pscustomobject]@{
                Name    = $reader.GetString($definition.Namespace) + '.' + $reader.GetString($definition.Name)
                Public  = ($definition.Attributes -band [System.Reflection.TypeAttributes]::VisibilityMask) -eq [System.Reflection.TypeAttributes]::Public
                Aliases = $aliases
                Display = $display
                Base    = $base
            }
        }
    }
    finally {
        $peReader.Dispose()
        $stream.Dispose()
    }

    $types = foreach ($row in $rows.Values) {
        if (-not $row.Public) {
            continue
        }
        $effective = $row
        while ($null -eq $effective.Display -and $null -ne $effective.Base -and $rows.ContainsKey($effective.Base)) {
            $effective = $rows[$effective.Base]
        }
        $displayNames = [string[]] @()
        if ($null -ne $effective.Display) {
            $displayNames = [string[]] $effective.Display.ToArray()
        }
        [pscustomobject]@{
            Name    = $row.Name
            Aliases = [string[]] @($row.Aliases)
            Display = $displayNames
        }
    }
    $sorted = [object[]] @($types)
    [System.Array]::Sort($sorted, [System.Comparison[object]] { param($a, $b) [System.StringComparer]::Ordinal.Compare($a.Name, $b.Name) })
    [pscustomobject]@{ Types = $sorted }
}
