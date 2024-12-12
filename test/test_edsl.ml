module Edsl = Ccl.Edsl
open Ccl.Model

let check ~name ~expected ~ccl =
  Alcotest.(check Test_extra.Testable.model_t) name expected (Edsl.run ccl)

let test_empty name =
  let ccl = Edsl.finish in
  let expected = empty in
  check ~name ~expected ~ccl

let test_single name =
  let ccl =
    Edsl.(
      let* _ = key "key" in
      finish)
  in
  let expected = KeyMap.of_list [ ("key", empty) ] in
  check ~name ~expected:(Fix expected) ~ccl

let test_double name =
  let ccl =
    Edsl.(
      let* _ = key "key1" in
      let* _ = key "key2" in
      finish)
  in
  let expected = KeyMap.of_list [ ("key1", empty); ("key2", empty) ] in
  check ~name ~expected:(Fix expected) ~ccl

let test_single_override name =
  let ccl =
    Edsl.(
      let* _ = key "key" in
      let* _ = key "key" in
      finish)
  in
  let expected = KeyMap.of_list [ ("key", empty) ] in
  check ~name ~expected:(Fix expected) ~ccl

let test_nested_empty name =
  let ccl =
    Edsl.(
      let* _ = nested "key" finish in
      finish)
  in
  let expected = KeyMap.of_list [ ("key", empty) ] in
  check ~name ~expected:(Fix expected) ~ccl

let test_key_val name =
  let ccl =
    Edsl.(
      let* _ = key_val "key" "nested" in
      finish)
  in
  let expected =
    KeyMap.of_list [ ("key", Fix (KeyMap.of_list [ ("nested", empty) ])) ]
  in
  check ~name ~expected:(Fix expected) ~ccl

let test_nested_double name =
  let ccl =
    Edsl.(
      let* _ =
        nested "key"
        @@
        let* _ = key "nested1" in
        let* _ = key "nested2" in
        finish
      in
      finish)
  in
  let expected =
    KeyMap.of_list
      [
        ("key", Fix (KeyMap.of_list [ ("nested1", empty); ("nested2", empty) ]));
      ]
  in
  check ~name ~expected:(Fix expected) ~ccl

let test_stress name =
  let ccl = Test_extra.Stress.edsl in
  let expected = Fix Test_extra.Stress.key_map in
  check ~name ~expected ~ccl

let test name test =
  let name = Printf.sprintf "%s" name in
  Test_extra.quick name (fun () -> test name)

let tests =
  [
    test "Empty" test_empty;
    test "Singleton map" test_single;
    test "Double map" test_double;
    test "Singleton map with override" test_single_override;
    test "Single nested empty" test_nested_empty;
    test "Nested with single nested" test_key_val;
    test "Nested with two nested" test_nested_double;
    test "Stress test" test_stress;
  ]
