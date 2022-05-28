
(* The type of tokens. *)

type token = 
  | TRNS
  | STTS
  | SSYMS
  | SCLN
  | RPAR
  | LPAR
  | LETTER of (char)
  | ISYMS
  | ISTT
  | ISTK
  | EOF
  | COMMA

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val automaton: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.automaton)
