
(* The type of tokens. *)

type token = 
  | STTS
  | SSYMS
  | REJECT
  | PUSH
  | PROG
  | POP
  | LETTER of (char)
  | ISYMS
  | ISTT
  | ISTK
  | EOF
  | END
  | CT
  | CS
  | COMMA
  | COLON
  | CN
  | CHANGE
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val automaton: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.automaton)
