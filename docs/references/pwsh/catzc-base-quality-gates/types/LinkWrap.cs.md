# pwsh/Base.QualityGates/types/LinkWrap.cs

How the link aligner treats a comment line that outgrows its line limit once a citation becomes a code link
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)). It is configured in
`links.yml`.

- **`Break`** continues the comment on a new line before the link, never inside it, with the same comment prefix and indent. It is the
  default.
- **`Off`** leaves the line long and reports it.
