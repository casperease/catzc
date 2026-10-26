namespace Catzc.Base.CodeMeta;

// What must stay above a head, since a shebang or an XML prolog stops working once anything comes before it.
public enum HeadAnchor
{
    Start,
    AfterShebang,
    AfterProlog,
    AfterPreamble,
}
