(* Analyseur lexical pour automates *)

{
  open Lexing
  open Parser

  exception Lexing_error of string
}

let space = [' ' '\t']
let letter = ['a'-'z' 'A'-'Z' '0'-'9']
let return = ['\n' '\r' ]

rule token = parse
  | space+ {token lexbuf}
  | return+ {Lexing.new_line lexbuf; token lexbuf}
  | '(' {LPAR}
  | ')' {RPAR}
  | ',' {COMMA}
  | ';' {SCLN}
  | "input symbols:" {ISYMS}
  | "stack symbols:" {SSYMS}
  | "states:" {STTS}
  | "initial state:" {ISTT}
  | "initial stack:" {ISTK}
  | "transitions:" {TRNS}
  | letter as l {LETTER l}
  | eof {EOF}
  | _ {raise (Lexing_error "Unknown character")}