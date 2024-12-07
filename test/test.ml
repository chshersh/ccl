let () =
  Alcotest.run "CCL: Categorical Configuration Language"
    [ ("Parser", Test_parser.tests) ]
