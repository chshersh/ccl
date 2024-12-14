open Ccl.Parser

let check ~name ~expected ~config =
  Alcotest.(check Test_extra.Testable.parse_result)
    name expected (parse_value config)

let unchanged = Error (`Parse_error ": Unchanged")

let test_empty name =
  let config = "" in
  let expected = Ok [] in
  check ~name ~expected ~config

let test_spaces name =
  let config = "   " in
  let expected = unchanged in
  check ~name ~expected ~config

let test_eol name =
  let config = "\n" in
  let expected = Ok [] in
  check ~name ~expected ~config

let test_just_string name =
  let config = "val" in
  let expected = unchanged in
  check ~name ~expected ~config

let test_multi_line_plain name =
  let config = "val\n  next" in
  let expected = unchanged in
  check ~name ~expected ~config

let test_multi_line_plain_nested name =
  let config = {|
val
  next|} in
  let expected = Error (`Parse_error ": end_of_input") in
  check ~name ~expected ~config

let test_kv_single name =
  let config = {|
key = val
|} in
  let expected = [ { key = "key"; value = "val" } ] in
  check ~name ~expected:(Ok expected) ~config

let test_kv_multiple name =
  let config = {|
key1 = val1
key2 = val2
|} in
  let expected =
    [ { key = "key1"; value = "val1" }; { key = "key2"; value = "val2" } ]
  in
  check ~name ~expected:(Ok expected) ~config

let test_kv_multiple_indented name =
  let config = {|
    key1 = val1
    key2 = val2
|} in
  let expected =
    [ { key = "key1"; value = "val1" }; { key = "key2"; value = "val2" } ]
  in
  check ~name ~expected:(Ok expected) ~config

let test_kv_multiple_nested name =
  let config = {|
key1 = val1
  inner = some
key2 = val2
|} in
  let expected =
    [
      { key = "key1"; value = "val1\n  inner = some" };
      { key = "key2"; value = "val2" };
    ]
  in
  check ~name ~expected:(Ok expected) ~config

let test name test =
  let name = Printf.sprintf "[Value] %s" name in
  Test_extra.quick name (fun () -> test name)

let tests =
  [
    test "Empty" test_empty;
    test "Spaces" test_spaces;
    test "LineBreak" test_eol;
    test "val" test_just_string;
    test "Multi line plain" test_multi_line_plain;
    test "Multi line plain nested" test_multi_line_plain_nested;
    test "Single nested key=val" test_kv_single;
    test "Multiple plain" test_kv_multiple;
    test "Multiple indented" test_kv_multiple_indented;
    test "Multiple nested" test_kv_multiple_nested;
  ]
