type declaration = {
  isyms : char list;
  ssyms : char list;
  stts : char list;
  istt : char;
  istk : char;
}

type transition = {
  c_stt : char;
  n_ltr : char option;
  c_stk : char;
  n_stt : char;
  n_stk : char list
}

type automaton = {
  decl : declaration;
  trns : transition list
}