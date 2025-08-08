module KeyMap = Map.Make (String)

type value_entry =
  | String of string
  | Nested of entry_map

and entry_map = value_entry list KeyMap.t

type t = Fix of t KeyMap.t

let rec is_empty (Fix t) =
  KeyMap.is_empty t
  || KeyMap.for_all (fun k v -> k = "" && is_empty v) t

let rec compare t1 t2 =
  if is_empty t1 && is_empty t2 then
    0
  else
    let (Fix map1) = t1 in
    let (Fix map2) = t2 in
    KeyMap.compare compare map1 map2

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

let is_end_val (Fix t) =
  KeyMap.cardinal t = 1
  && KeyMap.for_all (fun _  v -> is_empty v) t

let pretty ccl =
  if is_end_val ccl then
    let (Fix ccl) = ccl in
    let ((v, _), _) = Option.get (Seq.uncons (KeyMap.to_seq ccl)) in
    v ^ "\n"
  else begin
    let buf = Buffer.create 32 in
    let rec go indent (Fix map) =
      map
      |> KeyMap.iter (fun key value ->
          if is_end_val value then begin
             Buffer.add_string buf indent;
             Buffer.add_string buf key;
             Buffer.add_string buf " = ";
             let (Fix value) = value in
             let ((v, _), _) = Option.get (Seq.uncons (KeyMap.to_seq value)) in
             Buffer.add_string buf v;
             Buffer.add_char buf '\n'
          end else begin
             Buffer.add_string buf indent;
             Buffer.add_string buf key;
             Buffer.add_string buf " =\n";
             go (indent ^ "  ") value
          end)
    in
    go "" ccl;
    Buffer.contents buf
  end

(* ---- *)
(* eDSL *)
(* ---- *)

let key k = Fix (KeyMap.singleton k empty)
let key_val k v = Fix (KeyMap.singleton k (key v))
let of_list = List.fold_left merge empty
let nested k vals = Fix (KeyMap.singleton k (of_list vals))
let ( =: ) = key_val
