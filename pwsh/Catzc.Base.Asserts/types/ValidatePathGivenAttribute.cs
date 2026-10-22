using System.Collections;
using System.Management.Automation;

namespace Catzc.Base.Asserts;

// A -Path given but empty, or holding only empty strings, is refused at binding: an empty list never means the whole tree; leaving -Path out says that.
public sealed class ValidatePathGivenAttribute : ValidateArgumentsAttribute
{
    public const string Message = "-Path is empty: an empty path list never means the whole tree; leave -Path out for that";

    protected override void Validate(object arguments, EngineIntrinsics engineIntrinsics)
    {
        if (!HasPath(arguments)) { throw new ValidationMetadataException(Message); }
    }

    // True when the argument names at least one path that is not empty or whitespace.
    public static bool HasPath(object arguments)
    {
        object value = arguments is PSObject wrapped ? wrapped.BaseObject : arguments;
        if (value == null) { return false; }
        if (value is string text) { return !string.IsNullOrWhiteSpace(text); }
        if (value is IEnumerable items)
        {
            foreach (object item in items)
            {
                object inner = item is PSObject element ? element.BaseObject : item;
                if (inner != null && !string.IsNullOrWhiteSpace(inner.ToString())) { return true; }
            }
            return false;
        }
        return true;
    }
}
