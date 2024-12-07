(** CCL type definitions and high-level functions to work with the parsed interface. *)

(** A key is just a string. *)
type key = string

(** A single CCL entry is just a pair of key and value *)
type key_val = {
  key : key;
  value : string;
}

(** A full CCL config is just a list key-value pairs*)
type config = key_val list

(** A module for Map from keys to values *)
module KeyMap : Map.S with type key = key

(** Actual parsed value and the type of the Key-Value map *)
type value =
  | String of string
  | Nested of t

and t = value KeyMap.t
