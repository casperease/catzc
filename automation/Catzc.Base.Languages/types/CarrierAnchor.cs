// What must stay above a comment head: nothing, a shebang, an XML or HTML prolog, or a fixed number of preamble lines.
// ADR-REPO-FILEMETA#1 [comment:1](/docs/references/automation/catzc-base-languages/types/CarrierAnchor.cs.md#comment1)

namespace Catzc.Base.Languages;

public enum CarrierAnchor
{
    Start,
    AfterShebang,
    AfterProlog,
    AfterPreamble,
}
