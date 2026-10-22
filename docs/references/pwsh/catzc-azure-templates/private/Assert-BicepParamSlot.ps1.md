# pwsh/Catzc.Azure.Templates/private/Assert-BicepParamSlot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Throws unless a .bicepparam slot file is one its template can take.

### description

A template's slot is either a yml config or a hand-written .bicepparam; Get-BicepTemplates and Assert-BicepTemplate call this for each
.bicepparam slot they find. The slot is refused, with an error naming the template and the file, when:

1. the template ships a PrePost hook: the hook prepares a yml slot's parameters, so a template that has one takes yml slots only;
2. the file has no `using '<path>'` line, the line that names the template it fills;
3. its using path, resolved from the file's own folder, is not the template's main.bicep (compared ignoring case).

### parameter `File`

The .bicepparam slot file.

### parameter `Main`

The template's main.bicep the slot must use.

### parameter `Template`

The template name, for the error text.

### parameter `HasPrePost`

Whether the template ships a PrePost hook.

### example 1

```powershell
Assert-BicepParamSlot -File $file -Main $main -Template widget -HasPrePost $false
```
