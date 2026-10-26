# pwsh/Base.Files/types/InputStamp.cs

The compiled fingerprint of a set of input files, behind `Get-InputStamp` and the generated-file writers' stamps: one SHA-256 over the
sorted (path, identity) of every file.

## Identity

The identity of a file is either its content hash or its last write and size:

- **Content** stamps the same on every checkout. Carriage returns are removed before hashing, so a clone, a snapshot, a CRLF checkout and a
  touch all stamp the same.
- **Metadata** is cheaper, and a touch only ever makes the stamp differ.

## Paths and excludes

A path under the root is named relative to it with `/` separators, a path outside it in full. An exclude is a wildcard (`*` and `?`, a
backtick escapes the next character) matched against the full path with `/` separators, ignoring case.

## Many sets at once

`ComputeMany` gives one stamp per path set, each the stamp `Compute` gives that set alone. A file named in several sets is read once for all
of them, and every named path is stat'ed once, in parallel.
