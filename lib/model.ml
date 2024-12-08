type key = string

type key_val = {
  key : key;
  value : string;
}

type config = key_val list

module KeyMap = Map.Make (String)

type value =
  | String of string
  | Nested of t

and t = value list KeyMap.t
