# pwsh/Base.Folders/types/FolderWalker.cs

The compiled, bounded walker behind `Get-ChildPath` and `PathSet`: it lists below a folder to a depth, prunes named folders while it walks
and never follows a link.

## Walking files and folders in one pass

`WalkRelative` lists the files and the folders apart in one pass, each relative to `relativeTo` with `/` separators. A caller that needs both
would otherwise make the walk twice, then cut the paths one by one.
