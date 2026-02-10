#import "../../lib.typ" as nestemp
#show: nestemp.secret-level.with(n:0)

secret-level is 0

#{
  show: nestemp.secret-level.with(n:1)

  [secret-level is 1]
}

secret-level is 0, due to the we get out of secret-level *scope*
