open Ccl.Model

let check ~name ~expected ~config =
  Alcotest.(check Test_extra.Testable.parse_result)
    name (Ok expected) (Ccl.Parser.parse config)

let test_two name =
  let config = "key1 = val1\nkey2 = val2" in
  let expected =
    [ { key = "key1"; value = "val1" }; { key = "key2"; value = "val2" } ]
  in
  check ~name ~expected ~config

let test_untrimmed name =
  let config = {|
key1 = val1
key2 = val2
|} in
  let expected =
    [ { key = "key1"; value = "val1" }; { key = "key2"; value = "val2" } ]
  in
  check ~name ~expected ~config

let test_real name =
  let config =
    {|
name = Dmitrii Kovanikov
login = chshersh
language = OCaml
date = 2024-05-25
|}
  in
  let expected =
    [
      { key = "name"; value = "Dmitrii Kovanikov" };
      { key = "login"; value = "chshersh" };
      { key = "language"; value = "OCaml" };
      { key = "date"; value = "2024-05-25" };
    ]
  in
  check ~name ~expected ~config

let test_list_like name =
  let config = {|
= 3
= 1
= 2
|} in
  let expected =
    [
      { key = ""; value = "3" };
      { key = ""; value = "1" };
      { key = ""; value = "2" };
    ]
  in
  check ~name ~expected ~config

let test_array_like name =
  let config = {|
1 =
2 =
3 =
|} in
  let expected =
    [
      { key = "1"; value = "" };
      { key = "2"; value = "" };
      { key = "3"; value = "" };
    ]
  in
  check ~name ~expected ~config

let test name test =
  let name = Printf.sprintf "[Multiple] %s" name in
  Test_extra.quick name (fun () -> test name)

let tests =
  [
    test "Two key-value pairs" test_two;
    test "Config with trailing and leading" test_untrimmed;
    test "Real-life-like" test_real;
    test "List-like" test_list_like;
    test "Array-like" test_array_like;
  ]
