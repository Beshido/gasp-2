open Ast

exception Wrong_initial_state
exception Wrong_initial_stack
exception Not_deterministic
exception Empty_stack
exception Non_empty_stack
exception No_transitions

let check_initial_stt_stk decl =
  let b1 = List.mem decl.istt decl.stts in
  let b2 = List.mem decl.istk decl.ssyms in
  if b1 && b2 then
    ()
  else if not b1 then
    raise Wrong_initial_state
  else
    raise Wrong_initial_stack

let epsilon_to_char opt =
  match opt with
  | None -> '?'
  | Some l -> l

let rec spec_mem (c_stt, n_ltr, c_stk) list =
  match list with
  | [] -> false
  | (stt, ltr, stk) :: q ->
    let b = ltr = '?' || n_ltr = '?' || ltr = n_ltr in
    b && stt = c_stt && stk = c_stk || (spec_mem (c_stt, n_ltr, c_stk) q)

let rec check_deterministic trns seen =
  match trns with
  | [] -> ()
  | h :: q ->
    let tri = (h.c_stt, epsilon_to_char h.n_ltr, h.c_stk) in
    if spec_mem tri seen then
      raise Not_deterministic
    else
      check_deterministic q (tri :: seen)

let rec make_trns trns (c_stt, c_stk) l =
  if c_stk = [] then
    raise Empty_stack
  else
    let rec match_trns trns =
      match trns with
      | [] -> raise No_transitions
      | h :: q ->
        if h.c_stt = c_stt && h.c_stk = List.hd c_stk then
          if h.n_ltr = Some l then
            (h.n_stt, List.rev_append h.n_stk (List.tl c_stk))
          else if h.n_ltr = None then
            make_trns trns (h.n_stt, List.rev_append h.n_stk (List.tl c_stk)) l
          else
            match_trns q
        else
          match_trns q in
    match_trns trns

let rec end_trns trns (c_stt, c_stk) =
  let rec match_trns trns =
    match trns with
    | [] -> raise Non_empty_stack
    | h :: q ->
      if h.n_ltr = None && h.c_stt = c_stt && h.c_stk = List.hd c_stk then
        let n_stk = List.rev_append h.n_stk (List.tl c_stk) in
        if n_stk = [] then
          ()
        else
          end_trns trns (h.c_stt, n_stk)
      else
        match_trns q in
  match_trns trns

let interp word automaton =
  let decl = automaton.decl in
  let trns = automaton.trns in
  let c_stt = decl.istt in
  let c_stk = [decl.istk] in
  check_initial_stt_stk decl;
  check_deterministic trns [];
  let f_stt, f_stk = String.fold_left (make_trns trns) (c_stt, c_stk) word in
  if f_stk <> [] then
    end_trns trns (f_stt, f_stk)
  else
    ()