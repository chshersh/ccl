Produce sample
  $ cat >sample1.ccl <<EOF
  > numbers =
  >   foo = 12341234
  >   bar = 12341233
  >   baz = 12341236
  > EOF

Produce more sample
  $ cat >sample2.ccl <<EOF
  > numbers =
  >   baz = 123
  >   foo = 1
  > somekey = someval
  > this =
  >   that =
  >   foo =
  >   bar = baz
  > EOF

Merge
  $ cclq sample1.ccl sample2.ccl --
  numbers =
    bar =
      12341233 =
    baz =
      123 =
      12341236 =
    foo =
      1 =
      12341234 =
  somekey =
    someval =
  this =
    bar =
      baz =
    foo =
    that =
  

Merge and query
  $ cclq sample1.ccl sample2.ccl -- numbers=foo
  1 =
  12341234 =
  

Merge and queries
  $ cclq sample1.ccl sample2.ccl -- numbers=foo somekey this=bar
  1 =
  12341234 =
  
  someval =
  
  baz =
  
