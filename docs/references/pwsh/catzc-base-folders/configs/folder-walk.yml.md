# pwsh/Catzc.Base.Folders/configs/folder-walk.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `exclude: [.git, node_modules, out, __pycache__, .pytest_cache, .ruff_cache,...`, written with `#`.

```text
The folders a walk never enters, replacing the type's default (.git, node_modules, out): the tool caches a language leaves inside a
module or a track, which are never its files.
```
