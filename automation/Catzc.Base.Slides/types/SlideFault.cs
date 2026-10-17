/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Slides/types/SlideFault.cs
    folder: types
    name: slide-fault
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
---
*/

using System;

namespace Catzc.Base.Slides;

public sealed class SlideFault
{
    public string Path { get; }
    public string Field { get; }
    public string Message { get; }

    public SlideFault(string path, string field, string message)
    {
        if (string.IsNullOrWhiteSpace(message))
        {
            throw new ArgumentException("a fault carries a message", nameof(message));
        }

        Path = path ?? string.Empty;
        Field = field ?? string.Empty;
        Message = message;
    }

    public override string ToString()
    {
        string where = Path;
        if (Field.Length > 0)
        {
            where = where.Length > 0 ? Path + ": field '" + Field + "'" : "field '" + Field + "'";
        }

        return where.Length > 0 ? where + ": " + Message : Message;
    }
}
