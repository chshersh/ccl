module Model = Model
module Parser = Parser
module KeyMap = Model.KeyMap

let rec add_key_val key_map ({ key; value } : Model.key_val) =
  let value =
    match Parser.parse_value value with
    (* Parsing error: Ignore, just return the value unchanged *)
    | Error _ -> Model.String value
    | Ok key_values -> Nested (of_key_vals key_values)
  in
  KeyMap.update key
    (function
      | None -> Some [ value ]
      | Some old_value -> Some (old_value @ [ value ]))
    key_map

and of_key_vals key_vals = List.fold_left add_key_val KeyMap.empty key_vals

let fix key_vals = key_vals |> of_key_vals |> Model.fix

let read filename =
  In_channel.with_open_bin filename (fun channel ->
      let contents = In_channel.input_all channel in
      Parser.parse contents)

let main () =
  let file = "test.ccl" in
  print_endline "Started parsing...";
  let kvs = read file in
  match kvs with
  | Error (`Parse_error msg) -> Printf.printf "Error %s\n%!" msg
  | Ok kvs ->
      ListLabels.iter kvs ~f:(fun ({ key; value } : Model.key_val) ->
          Printf.printf "%s = %s\n%!" key value)
