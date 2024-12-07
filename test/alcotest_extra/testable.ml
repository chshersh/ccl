module Model = Ccl.Model

let pp_key_val fmt ({ key; value } : Model.key_val) =
  Format.fprintf fmt "{ key = \"%s\"; value = \"%s\" }" key value

let key_val = Alcotest.testable pp_key_val ( = )
let config = Alcotest.list key_val
