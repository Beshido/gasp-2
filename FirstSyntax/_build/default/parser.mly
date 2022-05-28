(* Analyseur syntaxique pour automates à pile *)

%{
  open Ast
%}

%token <char> LETTER

%token LPAR RPAR COMMA SCLN
%token ISYMS SSYMS STTS ISTT ISTK TRNS
%token EOF

%start automaton

%type <Ast.automaton> automaton

%%

automaton:
  decl = decl; TRNS; trns = trns*; EOF {{decl = decl; trns = trns}}
;

decl:
  ISYMS; isyms = separated_list(COMMA, LETTER);
  SSYMS; ssyms = separated_list(COMMA, LETTER);
  STTS; stts = separated_list(COMMA, LETTER);
  ISTT; istt = LETTER; ISTK; istk = LETTER
  {{isyms = isyms; ssyms = ssyms; stts = stts; istt = istt; istk = istk}}
;

trns:
  LPAR; c_stt = LETTER; COMMA; n_ltr = LETTER?; COMMA; c_stk = LETTER; COMMA;
  n_stt = LETTER; COMMA; n_stk = separated_list(SCLN, LETTER); RPAR
  {{c_stt = c_stt; n_ltr = n_ltr; c_stk = c_stk; n_stt = n_stt; n_stk = n_stk}}
;