open Testable

let test_empty () = Alcotest.(check (list key_val)) "Empty" [] (Ccl.Parser.parse "")

let tests =
  [
    ("test_empty", `Quick, test_empty);
  ]
