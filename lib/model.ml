type key = string

type key_val = {
  key : key;
  value : string;
}

type config = key_val list

module KeyMap = Map.Make (String)

type value_entry =
  | String of string
  | Nested of entry_map

and entry_map = value_entry list KeyMap.t

type t = Fix of t KeyMap.t

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

let rec fix entry_map =
  let normalise_entry = function
    | String v -> Fix (KeyMap.singleton v empty)
    | Nested entry_map -> fix entry_map
  in
  let normalise entries =
    entries |> List.map normalise_entry |> List.fold_left merge empty
  in
  Fix (KeyMap.map normalise entry_map)
