let mk_test_empty ~name config =
  Alcotest.(check Alcotest_extra.Testable.config)
    name [] (Ccl.Parser.parse config)

let test config =
  let name = Printf.sprintf "'%s'" (String.escaped config) in
  Alcotest_extra.quick name (fun () -> mk_test_empty ~name config)

let tests =
  [
    test "";
    test " ";
    test "   ";
    test "\n";
    test "  \n";
    test "\n\n";
    test "  \n  \n  ";
  ]
