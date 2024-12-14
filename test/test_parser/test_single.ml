open Ccl.Parser

let mk_test_single ~name ~expected ~config () =
  let expected = [ expected ] in
  Alcotest.(check Test_extra.Testable.parse_result)
    name (Ok expected) (Ccl.Parser.parse config)

let mk_name config = Printf.sprintf "[Single] '%s'" (String.escaped config)

let mk_test ~expected config =
  let name = mk_name config in
  Test_extra.quick name (mk_test_single ~name ~expected ~config)

let test =
  let expected = { key = "key"; value = "val" } in
  mk_test ~expected

let test_empty_value =
  let expected = { key = "key"; value = "" } in
  mk_test ~expected

let test_empty_key =
  let expected = { key = ""; value = "val" } in
  mk_test ~expected

let test_empty_key_value =
  let expected = { key = ""; value = "" } in
  mk_test ~expected

let test_multiple_equality =
  let config = "a=b=c" in
  let expected = { key = "a"; value = "b=c" } in
  mk_test ~expected config

let test_multiple_equality2 =
  let config = "a = b = c" in
  let expected = { key = "a"; value = "b = c" } in
  mk_test ~expected config

let test_section =
  let config = "== Section 2 ==" in
  let expected = { key = ""; value = "= Section 2 ==" } in
  mk_test ~expected config

let test_comment =
  let config = "/= this is a comment" in
  let expected = { key = "/"; value = "this is a comment" } in
  mk_test ~expected config

let tests =
  [
    test "key=val";
    test "key = val";
    test "  key = val";
    test "key = val  ";
    test "  key  =  val  ";
    test "\nkey = val\n";
    test "key \n= val\n";
    test "  \n key  \n=  val  \n";
    test_empty_value "key =";
    test_empty_value "key =\n";
    test_empty_value "key =  ";
    test_empty_value "key =  \n";
    test_empty_key "= val";
    test_empty_key "  = val";
    test_empty_key "\n  = val";
    test_empty_key_value "=";
    test_empty_key_value "  =  ";
    test_empty_key_value "\n  =  \n";
    test_multiple_equality;
    test_multiple_equality2;
    test_section;
    test_comment;
  ]
