# pwsh/Catzc.Base.QualityGates/private/Get-CatzcBundleFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The bundle meta kind's fact: the smallest built bundle that holds the module a file is in.

### description

A bundle is a profile of the exporter registry, resolved to its module set by Get-ModuleProfile, and the larger bundles hold every module of
the smaller ones. The module is the folder under the pwsh track's root, so the infrastructure folders such as `.internal` count, and the
fact names the bundle with the fewest modules that holds it: `minimal` for a core module, `full` for one only the full bundle ships. A file
in no module of a bundle, such as a document or a pipeline, gets an empty value, so the key is left out of its head. The bundles are data in
the exporter registry, never a list in this function
([ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config-varyingbehaviourisconfig)).
The member lists are kept for as long as the exporter registry object is the same one.

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
