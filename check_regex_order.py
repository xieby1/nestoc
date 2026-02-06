#!/usr/bin/env python3
# By claude
"""
Check if a list of regexes appear in order in stdin.
Each line matches at most one regex.

Usage:
    python check_regex_order.py <regex_file> < input.txt
    echo "some text" | python check_regex_order.py <regex_file>

Where regex_file contains one regex pattern per line.
"""

import sys
import re


def check_regex_order_line_by_line(regexes):
    """
    Check if regexes appear in order by reading stdin line by line.
    Each line matches at most one regex.

    Args:
        regexes: List of compiled regex patterns

    Returns:
        True if all regexes match in order, False otherwise
    """
    current_regex_idx = 0

    for line in sys.stdin:

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

    # Compile regexes
    try:
        regexes = [re.compile(pattern) for pattern in regex_patterns]
    except re.error as e:
        print(f"Invalid regex pattern: {e}", file=sys.stderr)
        sys.exit(1)

    # Check if regexes appear in order
    if check_regex_order_line_by_line(regexes):
        print("All regexes found in order")
        sys.exit(0)
    else:
        print("Regexes not found in order", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
