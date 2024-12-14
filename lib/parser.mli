(** A single key-value pair. Keys are strings and values are strings. Nothing extraordinary. *)
type key_val = {
  key : string;
  value : string;
}

type error = [ `Parse_error of string ]

(** Simple parsing function to parse the string representing key-value
configuration into the list of key-value pairs. *)
val parse : string -> (key_val list, [> error ]) result

(** Same as [parse] but with a slight modification: it calculates the biggest
prefix of spaces and considers all keys with this prefix (or less) to be
top-level. *)
val parse_value : string -> (key_val list, [> error ]) result
