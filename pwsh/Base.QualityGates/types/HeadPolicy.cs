namespace Catzc.Base.QualityGates;

public enum HeadPolicy
{
    // The block holds the facts the kinds produce, and a file whose facts are all empty carries none.
    Facts,
    Forbidden,
    // The block holds only its authored config part: no kind imprints, and a file with no config part carries none.
    Config,
}
