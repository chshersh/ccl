module Model = Ccl.Model

let check ~name ~expected ~ccl =
  Alcotest.(check Test_extra.Testable.model_t) name expected ccl

let test_key_val name =
  Model.(
    let ccl = key_val "key" "val" in
    let expected =
      KeyMap.of_list [ ("key", Fix (KeyMap.of_list [ ("val", empty) ])) ]
    in
    check ~name ~expected:(Fix expected) ~ccl)

let test_two_key_vals name =
  Model.(
    let ccl = of_list [ key_val "key1" "val1"; key_val "key2" "val2" ] in
    let expected =
      KeyMap.of_list
        [
          ("key1", Fix (KeyMap.of_list [ ("val1", empty) ]));
          ("key2", Fix (KeyMap.of_list [ ("val2", empty) ]));
        ]
    in
    check ~name ~expected:(Fix expected) ~ccl)

let test_two_same_key_vals name =
  Model.(
    let ccl = of_list [ key_val "key" "val"; key_val "key" "val" ] in
    let expected =
      KeyMap.of_list [ ("key", Fix (KeyMap.of_list [ ("val", empty) ])) ]
    in
    check ~name ~expected:(Fix expected) ~ccl)

let test_key_override name =
  Model.(
    let ccl = of_list [ key_val "key" "val1"; key_val "key" "val2" ] in
    let expected =
      KeyMap.of_list
        [ ("key", Fix (KeyMap.of_list [ ("val1", empty); ("val2", empty) ])) ]
    in
    check ~name ~expected:(Fix expected) ~ccl)

let test_nested_empty name =
  Model.(
    let ccl = nested "key" [] in
    let expected = KeyMap.of_list [ ("key", empty) ] in
    check ~name ~expected:(Fix expected) ~ccl)

let test_nested_double name =
  Model.(
    let ccl = nested "key" [ nested "nested1" []; nested "nested2" [] ] in
    let expected =
      KeyMap.of_list
        [
          ( "key",
            Fix (KeyMap.of_list [ ("nested1", empty); ("nested2", empty) ]) );
        ]
    in
    check ~name ~expected:(Fix expected) ~ccl)

let test_stress name =
  let ccl = Test_extra.Stress.edsl in
  let expected = Model.Fix Test_extra.Stress.key_map in
  check ~name ~expected ~ccl

let test name test =
  let name = Printf.sprintf "%s" name in
  Test_extra.quick name (fun () -> test name)

let tests =
  [
    test "Single key val" test_key_val;
    test "Two different key vals" test_two_key_vals;
    test "Two identical key vals" test_two_same_key_vals;
    test "Two same keys with different values" test_key_override;
    test "Single nested empty" test_nested_empty;
    test "Nested with two nested" test_nested_double;
    test "Stress test" test_stress;
  ]
