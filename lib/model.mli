(** CCL type definitions and high-level functions to work with the parsed interface. *)

(** A helper module for a map from keys to values where the key is [string]. *)
module KeyMap : Map.S with type key = string

(** The actual type of the configuration. It's represented a dictionary from string to itself. *)
type t = Fix of t KeyMap.t

val compare : t -> t -> int

(** Self-explainable. *)
val empty : t

(** Merge two maps recursively. Keys from both Maps are preserved *)
val merge : t -> t -> t

(** Convert a list of key-value pairs to the structured representation of map.

The way it works is that the function parses values with [Parser.parse_value]
recursively calls itself while parsing is possible. Thus, becoming a fixed point
over the list of key-value pairs. *)
val fix : Parser.key_val list -> t
