open Ccl.Model

let check ~name ~expected ~config =
  Alcotest.(check Alcotest_extra.Testable.parse_result)
    name (Ok expected) (Ccl.Parser.parse config)

let test_single_line name =
  let config = {|
key =
  val
|} in
  let expected = [ { key = "key"; value = "\n  val" } ] in
  check ~name ~expected ~config

let test_multi_line name =
  let config = {|
key =
  line1
  line2
|} in
  let expected = [ { key = "key"; value = "\n  line1\n  line2" } ] in
  check ~name ~expected ~config

let test_multi_line_skip name =
  let config = {|
key =
  line1

  line2
|} in
  let expected = [ { key = "key"; value = "\n  line1\n\n  line2" } ] in
  check ~name ~expected ~config

let test_nested_key_value name =
  let config = {|
key =
  field1 = value1
  field2 = value2
|} in
  let expected =
    [ { key = "key"; value = "\n  field1 = value1\n  field2 = value2" } ]
  in
  check ~name ~expected ~config

let test_deep_nested_key_value name =
  let config =
    {|
key =
  field1 = value1
  field2 =
    subfield = x
    another = y
|}
  in
  let expected =
    [
      {
        key = "key";
        value =
          "\n  field1 = value1\n  field2 =\n    subfield = x\n    another = y";
      };
    ]
  in
  check ~name ~expected ~config

let test name test =
  let name = Printf.sprintf "[Nested] %s" name in
  Alcotest_extra.quick name (fun () -> test name)

let tests =
  [
    test "Single-line nested value" test_single_line;
    test "Multi-line nested value" test_multi_line;
    test "Multi-line with an empty line" test_multi_line_skip;
    test "Nested key-value pairs" test_nested_key_value;
    test "Deep nested key-value pairs" test_nested_key_value;
  ]
