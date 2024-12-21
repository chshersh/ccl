module KeyMap = Map.Make (String)

type value_entry =
  | String of string
  | Nested of entry_map

and entry_map = value_entry list KeyMap.t

type t = Fix of t KeyMap.t

let rec compare (Fix map1) (Fix map2) = KeyMap.compare compare map1 map2
let empty = Fix KeyMap.empty

let rec merge (Fix map1) (Fix map2) =
  Fix
    (KeyMap.merge
       (fun _key t1 t2 ->
         match (t1, t2) with
         | None, t2 -> t2
         | t1, None -> t1
         | Some t1, Some t2 -> Some (merge t1 t2))
       map1 map2)

let rec fix_entry_map entry_map =
  let normalise_entry = function
    | String v -> Fix (KeyMap.singleton v empty)
    | Nested entry_map -> fix_entry_map entry_map
  in
  let normalise entries =
    entries |> List.map normalise_entry |> List.fold_left merge empty
  in
  Fix (KeyMap.map normalise entry_map)

let rec add_key_val key_map ({ key; value } : Parser.key_val) =
  let value =
    match Parser.parse_value value with
    (* Parsing error: Ignore, just return the value unchanged *)
    | Error _ -> String value
    | Ok key_values -> Nested (of_key_vals key_values)
  in
  KeyMap.update key
    (function
      | None -> Some [ value ]
      | Some old_value -> Some (old_value @ [ value ]))
    key_map

and of_key_vals key_vals = List.fold_left add_key_val KeyMap.empty key_vals

let fix key_vals = key_vals |> of_key_vals |> fix_entry_map

let pretty ccl =
  let rec go indent buf (Fix map) =
    map
    |> KeyMap.iter (fun key value ->
           let prefix = String.make indent ' ' in

           Buffer.add_string buf prefix;
           Buffer.add_string buf key;
           Buffer.add_string buf " =\n";
           go (indent + 2) buf value)
  in

  (* Create initial buffer with some approximate initial size. *)
  let buf = Buffer.create 32 in
  go 0 buf ccl;
  Buffer.contents buf

(* ---- *)
(* eDSL *)
(* ---- *)

let key k = Fix (KeyMap.singleton k empty)
let key_val k v = Fix (KeyMap.singleton k (key v))
let of_list = List.fold_left merge empty
let nested k vals = Fix (KeyMap.singleton k (of_list vals))
let ( =: ) = key_val
