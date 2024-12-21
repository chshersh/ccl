(** Type definitions to work with the actual CCL model. *)
module Model = Model

(** Parser of the configuration. *)
module Parser = Parser

(** [decode_file path] Read the file contents and runs {!decode} on the result.

Internally, this function parse the string into a list of key-value pairs and
then recursively parses values.

This function parses values of the input list using the same parser as for the
top-level config modulo common space prefix. This function continues parsing
keys recursively and stops only when the parsing doesn't change the output
(that's why it's a fix-point combinator)

Usage example:

{[
let example () =
  let filepath = "example.ccl" in

  match Ccl.decode_file filepath with
  | Error (`Parse_error msg) ->
    Printf.printf "Error: %s\n%!" msg
  | Ok ccl ->
    print_endline (Ccl.Model.pretty ccl)
]}

NOTE: This function throws all the exceptions as reading the file. *)
val decode_file : string -> (Model.t, Parser.error) result

(** Decode contents of a string as [Model.t] or return a parsing failure. *)
val decode : string -> (Model.t, Parser.error) result
