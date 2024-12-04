type token =
  | EQUALITY
  | KEY of string
  | VAL of string
  | EOF

type key_val =
  { k: string;
    v: string;
  }

type config = key_val list

open Lexer
open Lexing

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  Printf.fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.config Lexer.read lexbuf with
  | SyntaxError msg ->
    Printf.fprintf stderr "%a: %s\n" print_position lexbuf msg;
    exit (-1)
  | Parser.Error ->
    Printf.fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

let parse_and_print lexbuf =
  let config = parse_with_error lexbuf in
  ListLabels.iter config ~f:(fun (k, v) ->
    Printf.printf "%s = %s" k v;
  )

let loop filename =
  In_channel.with_open_bin filename (fun channel ->
    let lexbuf = Lexing.from_channel channel in
    lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
    parse_and_print lexbuf;
  )

let main () =
  let file = "test.ccl" in
  print_endline "Started parsing...";
  loop file
