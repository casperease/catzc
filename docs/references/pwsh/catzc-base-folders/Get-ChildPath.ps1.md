# pwsh/Catzc.Base.Folders/Get-ChildPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the files and folders below a folder, to a bounded depth, without loading the tree.

### description

The one way to enumerate children and deeper. It walks lazily in .NET, stops at the depth, never follows a link, and prunes the named
folders while it walks, so a pruned folder is never entered. The result is full paths in ordinal order.

### parameter `Path`

The folder to list below. It must exist.

### parameter `Depth`

How many levels to list: 1 is the direct children only. The default is the folder-walk config's depth.

### parameter `Filter`

Simple wildcard patterns matched against each name; an entry is listed when any pattern matches. A folder that does not match is still
entered.

### parameter `Directory`

List folders only. With -File, or with neither, both are listed.

### parameter `File`

List files only. With -Directory, or with neither, both are listed.

### parameter `Exclude`

Folder names to prune. The default is the folder-walk config's exclude list.

### parameter `PruneVendor`

Whether the .vendor folder is pruned as well. The default is the folder-walk config's prune_vendor_in_searches, also readable as
global.folder-walk.prune_vendor_in_searches.

### outputs

`[string[]]` Full paths of the matching entries.

### example 1

```powershell
Get-ChildPath $modulePath -File -Filter '*.ps1'
```

### example 2

```powershell
Get-ChildPath $modulesRoot -Depth 3 -File -Filter '*.yml' -PruneVendor $true
```
