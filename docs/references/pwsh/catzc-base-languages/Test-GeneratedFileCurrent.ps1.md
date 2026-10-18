# automation/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tells whether a generated file was written from exactly the inputs a stamp describes.

### description

Reads the `with_inputs_sha` the file's head carries (Format-GeneratedFileHead -InputsSha) and compares it with the stamp of the inputs as
they are now (Get-InputStamp). Equal means the generator would write the same file, so it can return without reading its inputs. A file that
does not exist, has no head, or carries no inputs stamp is not current.

Only the start of the file is read, however large it is, and the key is found by its name, so the one check holds for every carrier (front
matter, a comment head, a property).

It rests on [ADR-PRIN-ONELIVE](../../../adr/principles/one-living-version.md).

### parameter `Path`

The generated file to check.

### parameter `InputsSha`

The stamp of the inputs as they are now, from Get-InputStamp.

### outputs

`[bool]` $true when the file exists and its with_inputs_sha equals -InputsSha; $false otherwise.

### example 1

```powershell
Test-GeneratedFileCurrent -Path (Resolve-RepoPath 'docs/adr/glossary.md') -InputsSha $stamp
```
