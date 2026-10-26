# pwsh/Base.MarkdownMeta/types/MarkdownDocument.cs

A Markdown text split into its front matter and its body, with the body hash that every carrier of a meta block stamps.

## Body hash

`BodyHash()` is the first 12 hex characters of the SHA-256 of the body, its line endings read as LF and its leading blank lines dropped. The
blank line that separates written front matter from the body is no part of the body, so imprinting never changes the hash it records.
