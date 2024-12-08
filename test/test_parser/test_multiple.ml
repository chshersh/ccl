open Ccl.Model

let check ~name ~expected ~config =
  Alcotest.(check Alcotest_extra.Testable.config)
    name expected (Ccl.Parser.parse config)

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

let test name test =
  let name = Printf.sprintf "[Multiple] %s" name in
  Alcotest_extra.quick name (fun () -> test name)

let tests =
  [
    test "Two key-value pairs" test_two;
    test "Config with trailing and leading" test_untrimmed;
    test "Real-life-like" test_real;
  ]
