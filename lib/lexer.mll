{
open Lexing
open Parser

exception SyntaxError of string
}

(* let spaces     = [' ' '\t']+ *)
let spaces = [' ' '\t']*
let newline = '\r' | '\n' | "\r\n"

let key = [ ^ '=' ' ' '\t' '\n' '\r']+

rule read =
  parse
  | spaces   { read lexbuf }
  | newline  { new_line lexbuf; read lexbuf }
  | "key"    { KEY "key"}
  | "val"    { VAL "val"}
  | '='      { EQUALITY }
  | eof      { EOF }
  | _        { raise (SyntaxError ("Unexpected lexeme: " ^ Lexing.lexeme lexbuf)) }
