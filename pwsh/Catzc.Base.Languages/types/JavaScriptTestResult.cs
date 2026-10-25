/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/JavaScriptTestResult.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Languages;

public sealed class JavaScriptTestResult
{
    // A test whose name starts with this reads the shipped artifacts and is `integrity`.
    public const string IntegrityPrefix = "integrity:";

    private static readonly string[] Outcomes = { "pass", "fail", "skip" };

    // The test file's path inside its test folder, '/'-separated (evaluate.test.js, or nested/widget.test.js).
    public string Package { get; }

    // The test's name, as its test() call declares it (e.g. "claims a widget").
    public string Name { get; }

    // pass | fail | skip.
    public string Outcome { get; }

    // The elapsed time node reported, in seconds.
    public double DurationSeconds { get; }

    // The failure or skip message.
    public string Output { get; }

    // integrity when the name starts with "integrity:", else logic.
    public string Category { get; }

    public JavaScriptTestResult(string package, string name, string outcome, double durationSeconds, string output)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(package) || !package.EndsWith(".test.js", StringComparison.Ordinal) || package.IndexOf('\\') >= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Package '{0}' is not a '/'-separated .test.js file path", package));
        }
        if (string.IsNullOrWhiteSpace(name) || name.Trim() != name)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Name '{0}' is not a JavaScript test name (non-empty, no leading or trailing space)", name));
        }
        if (Array.IndexOf(Outcomes, outcome) < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Outcome '{0}' is not one of: {1}", outcome, string.Join(", ", Outcomes)));
        }
        if (double.IsNaN(durationSeconds) || durationSeconds < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "DurationSeconds '{0}' must be zero or more", durationSeconds));
        }
        if (errors.Count > 0) { throw new ArgumentException("JavaScript test result validation failed:\n" + string.Join("\n", errors)); }

        Package = package;
        Name = name;
        Outcome = outcome;
        DurationSeconds = durationSeconds;
        Output = output ?? "";
        Category = name.StartsWith(IntegrityPrefix, StringComparison.Ordinal) ? "integrity" : "logic";
    }

    public override string ToString()
    {
        return string.Format(CultureInfo.InvariantCulture, "{0} {1}: {2}", Package, Name, Outcome);
    }
}
