module Model = Model
module Parser = Parser

let read filename =
  In_channel.with_open_bin filename (fun channel ->
      let contents = In_channel.input_all channel in
      Parser.parse contents)

let main () =
  let file = "test.ccl" in
  print_endline "Started parsing...";
  let kvs = read file in
  ListLabels.iter kvs ~f:(fun ({ key; value } : Model.key_val) ->
      Printf.printf "%s = %s\n%!" key value)
