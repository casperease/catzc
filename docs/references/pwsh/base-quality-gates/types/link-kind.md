# pwsh/Base.QualityGates/types/LinkKind.cs

The two kinds of link, fixed by the file a link lives in
([ADR-REPO-LINK-KINDBYFILE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-kindbyfile)): a markdown link lives in a
rendered `.md` file, and a code link in a comment of any other tracked text file.

The enum is `[Flags]`, so `Both` is `Code | Markdown` and the engine tests `HasFlag` instead of special-casing `Both`. A parameter typed as
this enum binds `-Kind Code`, `-Kind Markdown` or `-Kind Both` and tab-completes the fixed set.
