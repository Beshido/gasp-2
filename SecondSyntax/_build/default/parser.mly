(* Analyseur syntaxique pour automates à pile *)

%{
  open Ast
%}

%token <char> LETTER

%token COMMA COLON
%token ISYMS SSYMS STTS ISTT ISTK PROG
%token BEGIN END
%token CS CT CN
%token POP PUSH CHANGE REJECT
%token EOF

%start automaton

%type <Ast.automaton> automaton

%%

automaton:
  decl = decl; PROG; prog = prog; EOF {{decl = decl; prog = prog}}
;

decl:
  ISYMS; isyms = separated_list(COMMA, LETTER);
  SSYMS; ssyms = separated_list(COMMA, LETTER);
  STTS; stts = separated_list(COMMA, LETTER);
  ISTT; istt = LETTER; ISTK; istk = LETTER
  {{isyms = isyms; ssyms = ssyms; stts = stts; istt = istt; istk = istk}}
;

prog:
  | CS; stt_list = stts* {CS stt_list}
  | CT; stk_list = stks* {CT stk_list}
  | CN; ltr_list = ltrs* {CN ltr_list}
  | POP {Pop}
  | PUSH; l = LETTER {Push l}
  | CHANGE; l = LETTER {Change l}
  | REJECT {Reject}
;

stts: l = LETTER; COLON; BEGIN; prog = prog; END {l, prog};
stks: l = LETTER; COLON; BEGIN; prog = prog; END {l, prog};
ltrs: l = LETTER; COLON; prog = prog {l, prog};