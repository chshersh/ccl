type key_val = { k : string; v : string }
type config = key_val list

let read filename =
  In_channel.with_open_bin filename (fun channel ->
      let contents = In_channel.input_all channel in
      Parser.parse contents)

let main () =
  let file = "test.ccl" in
  print_endline "Started parsing...";
  let kvs = read file in
  ListLabels.iter kvs ~f:(fun (k, v) -> Printf.printf "%s = %s\n%!" k v)
