let mk_test_empty ~name config =
  Alcotest.(check Test_extra.Testable.parse_result)
    name (Ok []) (Ccl.Parser.parse config)

let mk_name config = Printf.sprintf "[Empty] '%s'" (String.escaped config)

let test config =
  let name = mk_name config in
  Test_extra.quick name (fun () -> mk_test_empty ~name config)

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
