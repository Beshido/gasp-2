(* Analyseur lexical pour automates *)

{
  open Lexing
  open Parser

  exception Lexing_error of string
}

let space = [' ' '\t']
let letter = ['a'-'z' 'A'-'Z' '0'-'9']
let return = ['\n' '\r']

rule token = parse
  | space+ {token lexbuf}
  | return+ {Lexing.new_line lexbuf; token lexbuf}
  | ',' {COMMA}
  | "input symbols:" {ISYMS}
  | "stack symbols:" {SSYMS}
  | "states:" {STTS}
  | "initial state:" {ISTT}
  | "initial stack:" {ISTK}
  | "program:" {PROG}
  | "begin" {BEGIN}
  | "end" {END}
  | "case state of" {CS}
  | "case top of" {CT}
  | "case next of" {CN}
  | "pop" {POP}
  | "push" {PUSH}
  | "change" {CHANGE}
  | "reject" {REJECT}
  | ':' {COLON}
  | letter as l {LETTER l}
  | eof {EOF}
  | _ {raise (Lexing_error "Unknown character")}