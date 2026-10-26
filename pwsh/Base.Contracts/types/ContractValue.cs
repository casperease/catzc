/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/ContractValue.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Globalization;
using System.Numerics;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

// A parsed JSON or YAML value read as one of seven JSON kinds, compared by JSON equality.
public static class ContractValue
{
    private static readonly Regex PlainKey = new Regex("^[A-Za-z0-9_-]+$");

    // The JSON kind of a value: object, array, string, integer, number, boolean or null.
    public static string Kind(object value)
    {
        switch (value)
        {
            case null:
                return "null";
            case string:
                return "string";
            case bool:
                return "boolean";
            case int:
            case long:
                return "integer";
            case IDictionary:
                return "object";
            case IList:
                return "array";
        }
        if (IsIntegral(value))
        {
            return "integer";
        }
        if (value is float || value is double || value is decimal)
        {
            return HasNoFraction(value) ? "integer" : "number";
        }
        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
            "contract value: a {0} is not a JSON or YAML value", value.GetType().FullName));
    }

    // A finding's rendering of a value is cut at this many characters.
    public const int DescribeLimit = 80;

    public static string Describe(object value)
    {
        var text = new StringBuilder();
        Render(value, text);
        return text.Length <= DescribeLimit ? text.ToString() : text.ToString(0, DescribeLimit - 3) + "...";
    }

    private static void Render(object value, StringBuilder text)
    {
        switch (Kind(value))
        {
            case "null":
                text.Append("null");
                return;
            case "boolean":
                text.Append((bool)value ? "true" : "false");
                return;
            case "string":
                text.Append('\'').Append(Text(value)).Append('\'');
                return;
            case "object":
                text.Append('{');
                string separator = string.Empty;
                foreach (DictionaryEntry entry in (IDictionary)value)
                {
                    text.Append(separator).Append(Text(entry.Key)).Append(": ");
                    Render(entry.Value, text);
                    separator = ", ";
                }
                text.Append('}');
                return;
            case "array":
                text.Append('[');
                string comma = string.Empty;
                foreach (object element in (IList)value)
                {
                    text.Append(comma);
                    Render(element, text);
                    comma = ", ";
                }
                text.Append(']');
                return;
            default:
                text.Append(Convert.ToString(value, CultureInfo.InvariantCulture));
                return;
        }
    }

    // A key or a string value as invariant text.
    public static string Text(object value) => Convert.ToString(value, CultureInfo.InvariantCulture);

    // The JSONPath of a member of the value at `path`: .key for a plain key, ['key'] for any other.
    public static string MemberPath(string path, string key) =>
        PlainKey.IsMatch(key) ? path + "." + key : path + "['" + key + "']";

    // The value of the key named `key` in a dictionary, compared as invariant text, ordinally.
    public static bool TryGetMember(IDictionary map, string key, out object member)
    {
        foreach (DictionaryEntry entry in map)
        {
            if (string.Equals(Text(entry.Key), key, StringComparison.Ordinal))
            {
                member = entry.Value;
                return true;
            }
        }
        member = null;
        return false;
    }

    public static bool Equal(object left, object right)
    {
        if (left is int leftInt && right is int rightInt)
        {
            return leftInt == rightInt;
        }
        if (left is long leftLong && right is long rightLong)
        {
            return leftLong == rightLong;
        }
        if (left is bool leftBool && right is bool rightBool)
        {
            return leftBool == rightBool;
        }
        if (left is string leftText && right is string rightText)
        {
            return string.Equals(leftText, rightText, StringComparison.Ordinal);
        }
        string kind = Kind(left);
        string otherKind = Kind(right);
        bool numeric = (kind == "integer" || kind == "number") && (otherKind == "integer" || otherKind == "number");
        if (numeric)
        {
            return NumberEqual(left, right);
        }
        if (kind != otherKind)
        {
            return false;
        }
        switch (kind)
        {
            case "null":
                return true;
            case "boolean":
                return (bool)left == (bool)right;
            case "string":
                return string.Equals(Text(left), Text(right), StringComparison.Ordinal);
            case "array":
                return ArrayEqual((IList)left, (IList)right);
            default:
                return ObjectEqual((IDictionary)left, (IDictionary)right);
        }
    }

    private static bool ArrayEqual(IList left, IList right)
    {
        if (left.Count != right.Count)
        {
            return false;
        }
        for (int i = 0; i < left.Count; i++)
        {
            if (!Equal(left[i], right[i]))
            {
                return false;
            }
        }
        return true;
    }

    private static bool ObjectEqual(IDictionary left, IDictionary right)
    {
        if (left.Count != right.Count)
        {
            return false;
        }
        foreach (DictionaryEntry entry in left)
        {
            if (!TryGetMember(right, Text(entry.Key), out object other) || !Equal(entry.Value, other))
            {
                return false;
            }
        }
        return true;
    }

    private static bool IsIntegral(object value) =>
        value is sbyte || value is byte || value is short || value is ushort || value is int || value is uint ||
        value is long || value is ulong || value is BigInteger;

    private static bool HasNoFraction(object value)
    {
        switch (value)
        {
            case float single:
                return !float.IsInfinity(single) && !float.IsNaN(single) && Math.Floor(single) == single;
            case double real:
                return !double.IsInfinity(real) && !double.IsNaN(real) && Math.Floor(real) == real;
            default:
                return decimal.Truncate((decimal)value) == (decimal)value;
        }
    }

    // Two numbers by value: as decimals when both fit, else as doubles.
    private static bool NumberEqual(object left, object right)
    {
        if (TryDecimal(left, out decimal a) && TryDecimal(right, out decimal b))
        {
            return a == b;
        }
        return ToDouble(left) == ToDouble(right);
    }

    private static bool TryDecimal(object value, out decimal result)
    {
        try
        {
            result = value is BigInteger big ? (decimal)big : Convert.ToDecimal(value, CultureInfo.InvariantCulture);
            return true;
        }
        catch (OverflowException)
        {
            result = 0;
            return false;
        }
    }

    private static double ToDouble(object value) =>
        value is BigInteger big ? (double)big : Convert.ToDouble(value, CultureInfo.InvariantCulture);
}
