# pwsh/Base.CodeMeta/types/CommentPagesConfig.cs

The typed record of `configs/comment-pages.yml`: the ordered `pages:` list of `CommentPageMap` entries, the `articles:` list of authored
pages that no source file has, and the `exclude:` list of folders whose files have no page, such as vendored scripts we ship but do not
write. With no `pages:` key it holds the built-in default maps, and a given `pages:` list must be non-empty.

## Validation

Construction rejects an unknown key (allowed: `pages`, `articles`, `exclude`), an `articles` entry that is not a `/`-separated `.md` path
under `docs/`, and an `exclude` entry that is not a repository-relative `/`-separated folder with no pattern.

## Page to source

The page of a file is the page of the first map that covers it, and `exclude` removes a file before any map is asked. The projection runs
forward only, because the normal form cannot be read back to a file name. To go from a page to its sources the tracked files map forward
once and the result is inverted (`PageIndex`). Each page lists every source that renders to it, a module folder for its article, and two or
more sources on one page is a collision.
