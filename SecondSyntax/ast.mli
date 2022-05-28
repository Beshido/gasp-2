type declaration = {
  isyms : char list;
  ssyms : char list;
  stts : char list;
  istt : char;
  istk : char;
}

type program =
  | CS of (char * program) list
  | CT of (char * program) list
  | CN of (char * program) list
  | Pop
  | Push of char
  | Change of char
  | Reject

type automaton = {
  decl : declaration;
  prog : program
}