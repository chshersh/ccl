module Model = Ccl.Model
open Ccl.Parser

let check ~name ~expected ~kvs =
  Alcotest.(check Test_extra.Testable.model_t) name expected (Model.fix kvs)

let test_empty name =
  let kvs = [] in
  let expected = Model.empty in
  check ~name ~expected ~kvs

let test_single name =
  let kvs = [ { key = "key"; value = "val" } ] in
  let expected = Model.key_val "key" "val" in
  check ~name ~expected ~kvs

let test_double name =
  let kvs =
    [ { key = "key1"; value = "val1" }; { key = "key2"; value = "val2" } ]
  in
  let expected =
    Model.(of_list [ key_val "key1" "val1"; key_val "key2" "val2" ])
  in
  check ~name ~expected ~kvs

let test_stress name =
  let kvs = Test_extra.Stress.kvs in
  let expected = Test_extra.Stress.edsl in
  check ~name ~expected ~kvs

let test name test =
  let name = Printf.sprintf "%s" name in
  Test_extra.quick name (fun () -> test name)

let tests =
  [
    test "Empty" test_empty;
    test "Single key=val" test_single;
    test "Two different key-value pairs" test_double;
    test "Stress" test_stress;
  ]
