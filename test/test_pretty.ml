module Edsl = Ccl.Edsl
open Ccl.Model

let check ~name ~input ~expected =
  let expected_string = String.trim expected in
  let actual_string = input |> Edsl.run |> pretty |> String.trim in
  Alcotest.(check string) name expected_string actual_string

let test_empty name =
  let input = Edsl.finish in
  let expected = "" in
  check ~name ~input ~expected

let test_single_empty name =
  let input = Edsl.key "key" in
  let expected = "key =" in
  check ~name ~input ~expected

let test_single_key_val name =
  let input = Edsl.key_val "key" "val" in
  let expected = {|
key =
  val =
|} in
  check ~name ~input ~expected

let test_two_key_vals name =
  let input =
    Edsl.(
      let* _ = key_val "key1" "val1" in
      let* _ = key_val "key2" "val2" in
      finish)
  in
  let expected = {|
key1 =
  val1 =
key2 =
  val2 =
|} in
  check ~name ~input ~expected

let test_stress name =
  let input = Test_extra.Stress.edsl in
  let expected =
    {|
/ =
  This is a CCL document =
database =
  enabled =
    true =
  limits =
    cpu =
      1500mi =
    memory =
      10Gb =
  ports =
     =
      8000 =
      8001 =
      8002 =
title =
  CCL Example =
user =
  createdAt =
    2024-12-31 =
  guestId =
    42 =
  login =
    chshersh =
|}
  in
  check ~name ~input ~expected

let test name test =
  let name = Printf.sprintf "%s" name in
  Test_extra.quick name (fun () -> test name)

let tests =
  [
    test "Empty" test_empty;
    test "key =" test_single_empty;
    test "Single key = val" test_single_key_val;
    test "Two key-values" test_two_key_vals;
    test "Stress" test_stress;
  ]
