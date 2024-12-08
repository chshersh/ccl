module Model = Ccl.Model

let pp_key_val fmt ({ key; value } : Model.key_val) =
  Format.fprintf fmt "{ key = \"%s\"; value = \"%s\" }" key value

let key_val = Alcotest.testable pp_key_val ( = )
let config = Alcotest.list key_val

let pp_parser_error fmt = function
  | `Parser msg -> Format.fprintf fmt "ParserError[%s]" msg

let parser_error : Ccl.Parser.error Alcotest.testable =
  Alcotest.testable pp_parser_error ( = )

let parse_result = Alcotest.result config parser_error
