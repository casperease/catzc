# pwsh/Azure/configs/roles.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `roles:`, written with `#`.

```text
The Azure built-in roles the templates assign, each by its fixed role definition id: the one place these GUIDs are declared (guids.yml
names this file as a registry). A template names a role, and its slot addresses the id here.
```
