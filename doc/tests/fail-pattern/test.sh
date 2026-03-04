#!/bin/bash
# Test the fail pattern feature of check_regex_order.py
# A line prefixed with ! in the regex file causes immediate failure if matched.

SCRIPT=$(dirname $(realpath $0))/../../check_regex_order.py
set -e

# Test 1: fail pattern triggers on matching input -> must exit non-zero
printf 'hello\nerror\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\ngoodbye\n') \
    && exit 1 || true

# Test 2: fail pattern does NOT trigger when the bad line is absent -> must succeed
printf 'hello\ngoodbye\n' \
    | python3 "$SCRIPT" <(printf 'hello\n!error\ngoodbye\n')

echo "All fail-pattern tests passed"
