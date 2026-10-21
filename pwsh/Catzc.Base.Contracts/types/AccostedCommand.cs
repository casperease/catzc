/*
---
catzc:
  immutable:
    with_body_sha: "94c99a030087"
  edges:
    cites:
      - ADR-AUTO-ACCOSTED-COMMANDFORM
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

// One command of an accosted run
// ([ADR-AUTO-ACCOSTED-COMMANDFORM](/docs/adr/automation/accosted-language.md#rule-adr-auto-accosted-commandform)): a contracted command's
// normal-form name and its literal arguments.
public sealed class AccostedCommand
{
    private static readonly Regex NormalName = new Regex("^[a-z][a-z0-9]*(_[a-z0-9]+)*$");

    public string name { get; }

    // Argument name -> literal value (string, bool, integer, or a list of these), in the order written.
    public IReadOnlyDictionary<string, object> arguments { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Reads one command written as a one-key mapping, { <name>: { <argument>: <literal>, ... } }; where says where it sits, for messages.
    public AccostedCommand(object raw, string where)
    {
        IDictionary entry = raw as IDictionary;
        if (entry == null || entry.Count != 1)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: a command is one mapping, its contracted command's name to its arguments", where));
        }
        object key = null;
        foreach (object k in entry.Keys) { key = k; }
        name = Convert.ToString(key, CultureInfo.InvariantCulture);
        if (!NormalName.IsMatch(name))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: '{1}' is not a command name in the repository normal form (verb_noun)", where, name));
        }

        Dictionary<string, object> values = new Dictionary<string, object>(StringComparer.Ordinal);
        arguments = values;
        object body = entry[key];
        if (body == null)
        {
            return;
        }
        IDictionary map = body as IDictionary;
        if (map == null)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: the arguments of '{1}' are a mapping of parameter name to literal", where, name));
        }
        foreach (object argumentKey in map.Keys)
        {
            string argument = Convert.ToString(argumentKey, CultureInfo.InvariantCulture);
            if (!NormalName.IsMatch(argument))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "{0}: '{1}' of '{2}' is not a parameter name in the repository normal form", where, argument, name));
            }
            values[argument] = Literal(map[argumentKey], where, name, argument);
        }
    }

    // A literal, or a list of literals: no mapping, since a command line holds nothing a reader must evaluate.
    private static object Literal(object value, string where, string command, string argument)
    {
        if (value == null || value is string || value is bool || value is int || value is long)
        {
            return value;
        }
        if (value is IDictionary)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: '{1}' of '{2}' is a mapping; an argument is a literal or a list of literals", where, argument, command));
        }
        IEnumerable list = value as IEnumerable;
        if (list != null)
        {
            List<object> items = new List<object>();
            foreach (object item in list)
            {
                if (item is IDictionary || (item is IEnumerable && !(item is string)))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "{0}: '{1}' of '{2}' nests a list or mapping; a list holds literals only", where, argument, command));
                }
                items.Add(item);
            }
            return items.ToArray();
        }
        return Convert.ToString(value, CultureInfo.InvariantCulture);
    }
}
