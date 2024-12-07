(** CCL type definitions and high-level functions to work with the parsed interface. *)

type key = string
(** A key is just a string. *)

type key_val = { key : key; value : string }
(** A single CCL entry is just a pair of key and value *)

type config = key_val list
(** A full CCL config is just a list key-value pairs*)

module KeyMap : Map.S with type key = key
(** A module for Map from keys to values *)

(** Actual parsed value and the type of the Key-Value map *)
type value = String of string | Nested of t

and t = value KeyMap.t
