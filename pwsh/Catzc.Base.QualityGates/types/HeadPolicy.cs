namespace Catzc.Base.QualityGates;

public enum HeadPolicy
{
    Required,
    Optional,
    Forbidden,
    // The block holds only its authored config part: no kind imprints, and a file with no config part carries none.
    Config,
}
