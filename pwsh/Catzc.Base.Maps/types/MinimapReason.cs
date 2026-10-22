namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Subject), nameof(Basis), nameof(Requested))]
public sealed class MinimapReason
{
    // What lights the cell: a file path or an ADR code; null when the basis needs none.
    public string Subject { get; }

    // How the subject lights the cell, such as path, citation or concern.
    public string Basis { get; }

    // The request the subject answers, such as the ADR code a diagram asked for; null when the subject was asked for itself.
    public string Requested { get; }

    // A short free-text qualifier; null when there is none.
    public string Note { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MinimapReason(string subject, string basis, string requested, string note)
    {
        Subject = subject;
        Basis = basis ?? "";
        Requested = requested;
        Note = note;
    }
}
