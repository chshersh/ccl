open Angstrom

let space = char ' ' <|> char '\t' >>| fun _ -> ()
let blank = skip_many (space <|> end_of_line)
let from_chars chars = chars |> List.to_seq |> String.of_seq |> String.trim
let to_str chars = chars |> List.to_seq |> String.of_seq

let value_p =
  (* Ignore all leading spaces *)
  let* _ = many space in

  (* Recursive parser *)
  let value_line_p =
    fix (fun self ->
        let* current_line = many (not_char '\n') in
        let* opt_char = peek_char in

        match opt_char with
        (* End of input *)
        | None -> return current_line (* Return what's parsed *)
        | Some '\n' -> (
            let* () = end_of_line in
            let* spaces = many space in
            match spaces with
            (* Next line starts immediately from the start. Aborting. *)
            | [] -> return current_line
            (* Some spaces. Continue parsing value. *)
            | _ ->
                let* next = self in
                let prefix = List.init (List.length spaces) (fun _ -> ' ') in
                (* TODO: Quadratic behaviour; fix it. *)
                return (current_line @ [ '\n' ] @ prefix @ next))
        | Some c ->
            fail
              ("Error parsing value. Expecting \\n but got: " ^ String.make 1 c))
  in

  (* Call recursive function *)
  value_line_p

let key_val =
  let* _ = blank in
  let* key = many (not_char '=') >>| from_chars in
  let* _ = blank in
  let* _ = char '=' in
  let* value = value_p >>| to_str in
  let* _ = blank in
  return (key, value)

let kvs_p = many key_val

let parse str =
  match parse_string ~consume:All kvs_p str with
  | Ok v -> v
  | Error msg -> failwith msg
