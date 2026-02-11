typst compile $(dirname $(realpath $0))/test.typ |& grep "secret-level violated" > /dev/null
