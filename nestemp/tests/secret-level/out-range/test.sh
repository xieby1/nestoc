typst compile $(dirname $(realpath $0))/test.typ |& grep "Unknown secret-level" > /dev/null
