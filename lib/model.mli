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
type value_entry =
  | String of string
  | Nested of entry_map

and entry_map = value_entry list KeyMap.t

(** Normalised value. With each key, after merging all individual entries, there
could be associated a list of plain strings (old values) and a (potentially
empty) nested map.

This value is obtained from [entry-map]:

* All [String] values inside [entry_map] are combined into a single list
* All [Nested] maps are merged. *)
type t = Fix of t KeyMap.t

(** Normalise deep entry map into the canonical representation. *)
val fix : entry_map -> t
