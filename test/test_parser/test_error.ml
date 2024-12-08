let check ~name ~expected ~config =
  Alcotest.(check Alcotest_extra.Testable.parse_result)
    name (Error expected) (Ccl.Parser.parse config)

let test_no_value name =
  let config = "key" in
  let expected = `Parse_error ": end_of_input" in
  check ~name ~expected ~config

let test name test =
  let name = Printf.sprintf "[Error] %s" name in
  Alcotest_extra.quick name (fun () -> test name)

let tests = [ test "Just key" test_no_value ]
