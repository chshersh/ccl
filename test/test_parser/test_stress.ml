let check ~name ~expected ~config =
  Alcotest.(check Test_extra.Testable.parse_result)
    name (Ok expected) (Ccl.Parser.parse config)

let test_stress name =
  let expected = Test_extra.Stress.kvs in
  let config = Test_extra.Stress.text in
  check ~name ~expected ~config

let test name test = Test_extra.quick name (fun () -> test name)
let tests = [ test "[Stress] Stress test on a big example" test_stress ]
