---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/types/VscodeLaunchProfile.cs.md
    kind: comment-page
    body_sha: "0b7ac8e9c6e1"
---

# automation/Catzc.Base.VSCode/types/VscodeLaunchProfile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One debug launch profile of configs/vscode-launch.yml (an entry of `configurations:`), rendered verbatim into the
managed .vscode/launch.json. A profile carries VS Code's own launch keys (camelCase — script, cwd, args, …), so
besides the three it must carry, the type keeps the profile's full key -> value map in authored order (`fields`)
for the renderer. Constructing one MAPS and VALIDATES the entry: it is a mapping carrying non-empty 'name',
'type', and 'request' strings; every violation is reported in one throw.
```
