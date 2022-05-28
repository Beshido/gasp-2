
(* Fichier principal de l'interprète Petit Java *)

open Format
open Lexing

(* Nom du fichier source et mot à vérifier *)
let ifw = ref []

let set r s = r := s :: !r

(* Les options du compilateur que l'on affiche avec --help *)
let options = []

let usage = "Usage : Word first then file"

(* Localise une erreur en indiquant la ligne et la colonne *)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" (List.hd !ifw) l (c-1) c

let () =
  (* Parsing de la ligne de commande *)
  Arg.parse options (set ifw) usage;

  (* On vérifie que les arguments ont été fournis *)
  if List.length !ifw <> 2 then begin
    eprintf "File and word are mandatory\n@?";
    exit 1
  end;

  (* Ouverture du fichier source en lecture *)
  let f = open_in (List.hd !ifw) in

  (* Création d'un tampon d'analyse lexicale *)
  let buf = Lexing.from_channel f in

  try
    (* Parsing: la fonction Parser.file transforme le tampon lexical en un
       arbre de syntaxe abstraite si aucune erreur (lexicale ou syntaxique)
       n'est détectée.
       La fonction Lexer.token est utilisée par Parser.file pour obtenir
       le prochain token. *)
    let _ = Parser.automaton Lexer.token buf in
    close_in f

  with
  | Lexer.Lexing_error c ->
    (* Erreur lexicale. On récupère sa position absolue et
       	   on la convertit en numéro de ligne *)
    localisation (Lexing.lexeme_start_p buf);
    eprintf "Erreur lexicale: %s@." c;
    exit 1
  | Parser.Error ->
    (* Erreur syntaxique. On récupère sa position absolue et on la
       	   convertit en numéro de ligne *)
    localisation (Lexing.lexeme_start_p buf);
    eprintf "Erreur syntaxique@.";
    exit 1
