module Edsl = Ccl.Edsl
open Ccl.Model

let check ~name ~expected ~ccl =
  Alcotest.(check Alcotest_extra.Testable.model_t) name expected (Edsl.run ccl)

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
  let ccl =
    Edsl.(
      let* _ = key_val "/" "This is a CCL document" in
      let* _ = key_val "title" "CCL Example" in
      let* _ =
        nested "database"
        @@
        let* _ = key_val "enabled" "true" in
        let* _ =
          nested "ports"
          @@
          let* _ = key_val "" "8000" in
          let* _ = key_val "" "8001" in
          let* _ = key_val "" "8002" in
          finish
        in
        let* _ =
          nested "limits"
          @@
          let* _ = key_val "cpu" "1500mi" in
          let* _ = key_val "memory" "10Gb" in
          finish
        in
        finish
      in
      let* _ = nested "user" (key_val "guestId" "42") in
      let* _ =
        nested "user"
        @@
        let* _ = key_val "login" "chshersh" in
        let* _ = key_val "createdAt" "2024-12-31" in
        finish
      in
      finish)
  in

  let expected =
    KeyMap.of_list
      [
        ("/", Fix (KeyMap.of_list [ ("This is a CCL document", empty) ]));
        ("title", Fix (KeyMap.of_list [ ("CCL Example", empty) ]));
        ( "database",
          Fix
            (KeyMap.of_list
               [
                 ("enabled", Fix (KeyMap.of_list [ ("true", empty) ]));
                 ( "ports",
                   Fix
                     (KeyMap.of_list
                        [
                          ( "",
                            Fix
                              (KeyMap.of_list
                                 [
                                   ("8000", empty);
                                   ("8001", empty);
                                   ("8002", empty);
                                 ]) );
                        ]) );
                 ( "limits",
                   Fix
                     (KeyMap.of_list
                        [
                          ("cpu", Fix (KeyMap.of_list [ ("1500mi", empty) ]));
                          ("memory", Fix (KeyMap.of_list [ ("10Gb", empty) ]));
                        ]) );
               ]) );
        ( "user",
          Fix
            (KeyMap.of_list
               [
                 ("guestId", Fix (KeyMap.of_list [ ("42", empty) ]));
                 ("login", Fix (KeyMap.of_list [ ("chshersh", empty) ]));
                 ("createdAt", Fix (KeyMap.of_list [ ("2024-12-31", empty) ]));
               ]) );
      ]
  in

  check ~name ~expected:(Fix expected) ~ccl

let test name test =
  let name = Printf.sprintf "%s" name in
  Alcotest_extra.quick name (fun () -> test name)

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
