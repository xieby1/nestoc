#!/usr/bin/env python3
# By claude, enhanced by copilot
"""
Check if a list of regexes appear in order in stdin.
Each line matches at most one regex.

Usage:
    python check_regex_order.py <regex_file> < input.txt
    echo "some text" | python check_regex_order.py <regex_file>

Where regex_file contains one regex pattern per line.

Pattern types:
  - Regular patterns: skip lines until this pattern matches, then advance
  - Fail patterns (prefix with !): consume the next line; fail immediately if it matches

Patterns are consumed one by one in the order they appear in the regex file.
Each fail pattern checks exactly the next line of input, then advances regardless.
Multiple consecutive fail patterns each check successive lines sequentially.

Example regex_file:
    hello
    !error
    !warning
    goodbye
  After "hello" matches, the next line is checked against "!error" (fail if it matches),
  then the following line is checked against "!warning" (fail if it matches),
  then waits for "goodbye".
"""

import sys
import re


def check_regex_order_line_by_line(patterns):
    """
    Check patterns against stdin line by line using a unified sequential queue.

    Each pattern is a tuple of ('match', compiled_regex, original_str) or
    ('fail', compiled_regex, original_str).

    Regular ('match') patterns: skip lines until one matches, then advance.
    Fail ('fail') patterns: consume the next line; fail immediately if it matches,
    advance to next pattern regardless.

    Args:
        patterns: List of (kind, compiled_regex, original_str) tuples in queue order

    Returns:
        True if all patterns are satisfied without failure, False otherwise
    """
    idx = 0

    for line in sys.stdin:
        if idx >= len(patterns):
            break

        kind, regex, original = patterns[idx]
        if kind == 'fail':
            # Each fail pattern consumes exactly this one line
            if regex.search(line):
                print(f"Fail pattern matched: !{original}", file=sys.stderr)
                print(f"Matched on line: {line.rstrip()}", file=sys.stderr)
                return False
            idx += 1
        else:
            # 'match' pattern: advance only when line matches
            if regex.search(line):
                idx += 1

    # At end of input: drain any remaining fail patterns (no line left to check)
    while idx < len(patterns):
        kind, regex, original = patterns[idx]
        if kind == 'fail':
            idx += 1
        else:
            print(f"Pattern {idx} not found: {regex.pattern}", file=sys.stderr)
            return False

    return True


def main():
    if len(sys.argv) != 2:
        print("Usage: python check_regex_order.py <regex_file>", file=sys.stderr)
        print("  Reads regexes from file (one per line) and checks if they appear in order in stdin", file=sys.stderr)
        sys.exit(1)

    regex_file = sys.argv[1]

    # Read regexes from file
    try:
        with open(regex_file, 'r') as f:
            regex_patterns = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"Error: File '{regex_file}' not found", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"Error reading file '{regex_file}': {e}", file=sys.stderr)
        sys.exit(1)

    if not regex_patterns:
        print("Error: No regex patterns found in file", file=sys.stderr)
        sys.exit(1)

    # Build unified pattern list preserving order from regex file
    try:
        patterns = []
        for raw in regex_patterns:
            if raw.startswith('!'):
                original = raw[1:]
                patterns.append(('fail', re.compile(original), original))
            else:
                patterns.append(('match', re.compile(raw), raw))
    except re.error as e:
        print(f"Invalid regex pattern: {e}", file=sys.stderr)
        sys.exit(1)

    # Check if regexes appear in order
    if check_regex_order_line_by_line(patterns):
        print("All regexes found in order")
        sys.exit(0)
    else:
        print("Regexes not found in order", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
