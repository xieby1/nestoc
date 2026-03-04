#!/bin/bash
# Test the fail pattern feature of check_regex_order.py
# Fail patterns (!) are consumed sequentially: each checks exactly the next line.

SCRIPT=$(dirname $(realpath $0))/../../check_regex_order.py
set -e

# Test 1: fail pattern triggers when the very next line matches -> must exit non-zero
# Patterns: hello, !error, goodbye
# Input:    hello / error / goodbye  <- "error" is the line right after "hello"
printf 'hello\nerror\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\ngoodbye\n') \
    && exit 1 || true

# Test 2: fail pattern does NOT trigger when the next line is safe -> must succeed
# Patterns: hello, !error, goodbye
# Input:    hello / safe / goodbye   <- "safe" does not match "!error", consumed; then "goodbye" matches
printf 'hello\nsafe\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\ngoodbye\n')

# Test 3: fail pattern only checks the next line, not later ones -> must succeed
# Patterns: hello, !error, goodbye
# Input:    hello / safe / error / goodbye  <- "error" appears later but fail pattern already consumed
printf 'hello\nsafe\nerror\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\ngoodbye\n')

# Test 4: multiple consecutive fail patterns each check successive lines -> must exit non-zero
# Patterns: hello, !error, !warning, goodbye
# Input:    hello / safe / warning / goodbye  <- second fail pattern catches "warning"
printf 'hello\nsafe\nwarning\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\n!warning\ngoodbye\n') \
    && exit 1 || true

# Test 5: multiple consecutive fail patterns, both lines safe -> must succeed
# Patterns: hello, !error, !warning, goodbye
# Input:    hello / safe / okay / goodbye
printf 'hello\nsafe\nokay\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\n!warning\ngoodbye\n')

echo "All fail-pattern tests passed"
