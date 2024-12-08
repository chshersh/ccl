(** Simple parsing function to parse the string representing key-value
configuration into the list of key-value pairs. *)
val parse : string -> Model.key_val list

(** Same as [parse] but with a slight modification: it calculates the biggest
prefix of spaces and considers all keys with this prefix (or less) to be
top-level. *)
val parse_value : string -> Model.key_val list
