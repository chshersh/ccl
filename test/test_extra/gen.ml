module Model = Ccl.Model
module Parser = Ccl.Parser
module Gen = QCheck2.Gen

let char_small = Gen.char_range 'a' 'c'
let key = Gen.(string_size ~gen:char_small (int_bound 3))

let value =
  Gen.(
    let raw_value_gen = string_size ~gen:char_small (int_bound 3) in
    sized
    @@ fix (fun self n ->
           match n with
           | 0 -> raw_value_gen
           | n ->
               let nested_value_gen =
                 let* key = key in
                 let* value = self (n / 2) in
                 return (key ^ " = " ^ value)
               in
               frequency [ (1, raw_value_gen); (2, nested_value_gen) ]))

let key_val =
  Gen.(
    let* key = key in
    let* value = value in
    return Parser.{ key; value })

let config = Gen.(list_size (int_bound 100) key_val)

type test_ccl = {
  original : string;
  model : Model.t;
}

let test_ccl =
  Gen.(
    let* config = config in
    let original =
      config
      |> List.map (fun Parser.{ key; value } ->
             Printf.sprintf "'%s = %s'" key value)
      |> String.concat "\n"
    in
    let model = Model.fix config in
    return { original; model })

let print_test_ccl { original; model } =
  Printf.sprintf "Original:\n%s\n\nPretty-printed:\n%s" original
    (Model.pretty model)
