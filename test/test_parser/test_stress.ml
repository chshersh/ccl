open Ccl.Model

let check ~name ~expected ~config =
  Alcotest.(check Alcotest_extra.Testable.parse_result)
    name (Ok expected) (Ccl.Parser.parse config)

let config =
  {|
/= This is a CCL document
title = CCL Example

database =
  enabled = true
  ports =
    = 8000
    = 8001
    = 8002
  limits =
    cpu = 1500mi
    memory = 10Gb

user =
  guestId = 42

user =
  login = chshersh
  createdAt = 2024-12-31
|}

let expected =
  [
    { key = "/"; value = "This is a CCL document" };
    { key = "title"; value = "CCL Example" };
    {
      key = "database";
      value =
        {|
  enabled = true
  ports =
    = 8000
    = 8001
    = 8002
  limits =
    cpu = 1500mi
    memory = 10Gb|};
    };
    { key = "user"; value = "\n  guestId = 42" };
    { key = "user"; value = "\n  login = chshersh\n  createdAt = 2024-12-31" };
  ]

let test_stress name = check ~name ~expected ~config
let test name test = Alcotest_extra.quick name (fun () -> test name)
let tests = [ test "[Stress] Stress test on a big example" test_stress ]
