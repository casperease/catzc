# pwsh/Base.TypesSystem/configs/generated.yml

The writer rows of the types system. `Get-GeneratedTarget` reads every module's `generated.yml`.

## Writers

What the types system writes: the combined types build, each module group's types surface, the IDE-only project's build output, and the
compiled agent hooks. The types surface is committed and rendered back from the tree, so its writer is `rollable`; every other output is
`untracked`.
