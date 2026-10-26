# pwsh/Base.Slides/tests/Move-Diagram.Tests.ps1

The tests of `Move-Diagram`: they move a diagram, and an article-carried diagram, inside a fixture repository.

## Why it is L2

The fixture repository is made and the diagram moved with real git (`git init`, `git mv`, `git ls-files`), so the point of the file is the
launch. The carrier re-key runs the kit's own editor (`declaration.py rekey`) through uv, so the repository's kit edits the fixture tree's
`drawio.yml`.
