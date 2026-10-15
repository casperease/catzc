# automation/Catzc.Base.Folders/Get-ChildPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one way to enumerate children and deeper. It walks lazily in .NET, stops at the depth, never follows a link, and prunes
the named folders while it walks, so a pruned folder is never entered. The result is full paths in ordinal order.
```

## comment:2

Section `.PARAMETER Filter` of the comment-based help.

```text
Simple wildcard patterns matched against each name; an entry is listed when any pattern matches. A folder that does not match is
still entered.
```

## comment:3

Section `.PARAMETER PruneVendor` of the comment-based help.

```text
Whether the .vendor folder is pruned as well. The default is the folder-walk config's prune_vendor_in_searches, also readable as
global.folder-walk.prune_vendor_in_searches.
```
