# pwsh/Base.QualityGates/private/Get-LinkScope.ps1

Lists the repository-relative files the link engine reads: every tracked file, or the files of the given paths, minus every file the content
tools leave as written. No list of its own decides that; a new class is declared in the .gitattributes source.

## help

### synopsis

Lists the repository-relative files the link engine reads.

### description

With no -Path, every git-tracked file (Get-GitTrackedPath) — the repository as committed, not whatever lies untracked in the working folder.
With -Path, the given files and the files under the given folders, from the filesystem. Either way a file the content tools leave as written
(Get-ContentExemptPath: vendored, generated, fixture, or contract asset) is never aligned. No list of its own: a new class is declared in
the .gitattributes source.

### parameter `RepositoryRoot`

The repository root the returned paths are relative to.

### parameter `Path`

Optional files or folders (absolute or relative to the current location) to limit the scope to.

### outputs

`[string[]]` repository-relative, '/'-separated paths.

## never a whole drive

Neither the repository root nor a `-Path` may be a disk root (`C:\`, `/`, a UNC share root). A relative `-Path` resolves against the current
location, so `.` run from `C:\` would be all of `C:`. The function throws instead of scanning a drive.

## folder depth

A folder `-Path` is listed up to ten levels deep. Tracked files reach nine levels below the root, so ten leaves one level of headroom.
