# Rewrite paths after a folder move

When decision records or the folders that hold them move, every reference to them in the tree has to follow. `Update-DrsCitation` rewrites
one file's references through two maps; this guide takes a list of moves to a tree whose references all resolve. What the command rewrites,
and how, is on its page ([Update-DrsCitation](../../references/pwsh/base-drs/update-drs-citation.md)); this guide restates none of it.

## Build the code map from the moves

Write the moves as a code map, one tab-separated row per move: `old_code`, `new_code`, `old_path`, `new_path`, `kind`, with paths relative
to `docs/drs/` and `-` for none. A rule that moves or collapses goes in the rule map instead.

- A **folder** row also maps the folder of its file. Name a file inside the folder (a child path), so the row moves that folder and nothing
  above it.
- Never write a folder row for a one-segment folder. A row like that maps the folder's parent, the whole tree, and rewrites paths that never
  moved.
- The one **root** row moves the root itself to a folder of the same depth; its two paths are repository-relative.

## Dry-run the whole tree first

`-Path` takes one file, so a tree-wide dry run is one pipeline that calls the command per tracked text file with `-DryRun`, grouped by path
(the command page's second example). Read the list before writing anything: a change outside the moved folders means a map row is too wide.

Leave out the files that are not the tree's current text: `.claude/CLAUDE.md` (the user's file), and the learnings and hindsight logs, which
record what was true when they were written. Overlay paths stay as they are.

## Write, then check

Run the same pipeline without `-DryRun`. A numbered citation comes back as an Unhandled change, for a person to resolve. Then run
`Format-Links` on the changed files and `Test-Links` on the tree; a string the maps cannot resolve, such as a test fixture's relative path,
is found by a search for the old folder name and fixed by hand.
