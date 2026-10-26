# pwsh/Base.Languages/configs/generated-head.yml

The keys of the generated-file head, in writing order. `Format-GeneratedFileHead` reads them to compose the head of a generated file.

## Order

The hash of the body the head is immutable with comes first, written only while git tracks the file, so the head reads "immutable for this
body". The do-not-edit warning follows it.
