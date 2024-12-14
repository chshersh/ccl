module Model = Ccl.Model
module Parser = Ccl.Parser

let pp_key_val fmt ({ key; value } : Parser.key_val) =
  Format.fprintf fmt "{ key = \"%s\"; value = \"%s\" }" key value

let key_val = Alcotest.testable pp_key_val ( = )
let config = Alcotest.list key_val

let pp_parser_error fmt = function
  | `Parse_error msg -> Format.fprintf fmt "ParserError[%s]" msg

let parser_error : Ccl.Parser.error Alcotest.testable =
  Alcotest.testable pp_parser_error ( = )

let parse_result = Alcotest.result config parser_error

let rec pp_model_t fmt (Model.Fix map) =
  map
  |> Model.KeyMap.to_seq
  |> Format.pp_print_seq
       (fun fmt (key, value) ->
         Format.pp_print_string fmt "( ";
         Format.pp_print_string fmt key;
         Format.pp_print_string fmt ", ";
         pp_model_t fmt value;
         Format.pp_print_string fmt " )")
       fmt

let model_t =
  Alcotest.testable pp_model_t (fun t1 t2 -> Model.compare t1 t2 = 0)
