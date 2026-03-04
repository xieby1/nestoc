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
  - Regular patterns: wait for this pattern to match in sequence
  - Fail patterns (prefix with !): fail immediately if any line matches

Example regex_file:
    hello
    !error
    goodbye
  This waits for "hello", then "goodbye", but fails if "error" appears anywhere.
"""

import sys
import re


def check_regex_order_line_by_line(regexes, fail_regexes):
    """
    Check if regexes appear in order by reading stdin line by line.
    Each line matches at most one regex.

    Args:
        regexes: List of compiled regex patterns to match in order
        fail_regexes: List of (compiled regex, original pattern) tuples that cause immediate failure

    Returns:
        True if all regexes match in order and no fail patterns match, False otherwise
    """
    current_regex_idx = 0

    for line in sys.stdin:
        # Check fail patterns first - these cause immediate failure
        for fail_regex, fail_pattern in fail_regexes:
            if fail_regex.search(line):
                print(f"Fail pattern matched: !{fail_pattern}", file=sys.stderr)
                print(f"Matched on line: {line.rstrip()}", file=sys.stderr)
                return False

        # Check if the current line matches the current regex
        if current_regex_idx < len(regexes):
            if regexes[current_regex_idx].search(line):
                current_regex_idx += 1

                # If we've matched all regexes, we're done
                if current_regex_idx == len(regexes):
                    return True

    # Check if we matched all regexes
    if current_regex_idx < len(regexes):
        print(f"Pattern {current_regex_idx} not found: {regexes[current_regex_idx].pattern}", file=sys.stderr)
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

    # Separate regular patterns from fail patterns (those starting with !)
    regular_patterns = []
    fail_patterns = []

    for pattern in regex_patterns:
        if pattern.startswith('!'):
            # Strip the ! prefix for fail patterns
            fail_patterns.append(pattern[1:])
        else:
            regular_patterns.append(pattern)

    # Compile regexes
    try:
        regexes = [re.compile(pattern) for pattern in regular_patterns]
        fail_regexes = [(re.compile(pattern), pattern) for pattern in fail_patterns]
    except re.error as e:
        print(f"Invalid regex pattern: {e}", file=sys.stderr)
        sys.exit(1)

    # Check if regexes appear in order
    if check_regex_order_line_by_line(regexes, fail_regexes):
        print("All regexes found in order")
        sys.exit(0)
    else:
        print("Regexes not found in order", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
