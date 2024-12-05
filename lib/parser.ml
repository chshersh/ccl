open Angstrom

let from_chars chars = chars |> List.to_seq |> String.of_seq |> String.trim
let space = char ' ' <|> char '\t' >>| fun _ -> ()
let blank = skip_many (space <|> end_of_line)
let value_p = many (not_char '\n') >>| from_chars

let key_val =
  let ( let* ) = ( >>= ) in
  let* _ = blank in
  let* key = many (not_char '=') >>| from_chars in
  let* _ = blank in
  let* _ = char '=' in
  let* _ = blank in
  let* value = value_p in
  let* _ = blank in
  return (key, value)

let kvs_p = many key_val

let parse str =
  match parse_string ~consume:All kvs_p str with
  | Ok v -> v
  | Error msg -> failwith msg
