let expected_key_val : Ccl.Model.key_val = { key = "key"; value = "val" }

let mk_test_single ~name config =
  let expected = [ expected_key_val ] in
  Alcotest.(check Alcotest_extra.Testable.config)
    name expected (Ccl.Parser.parse config)

let test config =
  let name = Printf.sprintf "'%s'" config in
  Alcotest_extra.quick name (fun () -> mk_test_single ~name config)

let tests = [ test "key=val" ]
