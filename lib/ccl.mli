(** Type definitions to work with the actual CCL model. *)
module Model = Model

(** Parser of the configuration. *)
module Parser = Parser

(** A module to construct CCL config values in pure OCaml without going through
the configuration. It uses the embeded Domain-Specific Language (eDSL) approach.

Useful for testing of defining default values.
*)
module Edsl = Edsl

(** This function converts a list of key-value pairs into [value Model.KeyMap.t].

This function parses values of the input list using the same parser as for the
top-level config modulo common space prefix. This function continues parsing
keys recursively and stops only when the parsing doesn't change the output
(that's why it's a fix-point combinator)

The intended usage is the following:

{[
let example () =
  let filepath = "test.ccl" in
  let contents =In_channel.with_open_bin filename In_channel.input_all in

  match Ccl.Parser.parse contents with
  | Error (`Parse_error error) ->
    Printf.printf "Error %s\n%!" msg;
    exit (-1)
  | Ok key_values ->
    let ccl = Ccl.fix key_values in
    ...
]}

*)
val fix : Model.key_val list -> Model.t

(** Decode contents of a string as [Model.t] or return a parsing failure. *)
val decode : string -> (Model.t, Parser.error) result

(** Read the file contents and run [decode] on them.

NOTE: This function throws all the exceptions as reading the file. *)
val decode_file : string -> (Model.t, Parser.error) result
