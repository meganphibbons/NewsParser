(* 
 * JSON Parser (not including Tokenizer)
 * Authors: Megan Phibbons
 * To use, include 'open Parser' at the top of a file
 * Useful Functions: 
 * - parse -> string [raw json text] -> json_data [parsed record] 
 * - print_keywords -> string -> int -> [no output]
 *)

open Tokens
open KeywordGenerator
open Utility

(* Record to keep track of json data so that it is easily accessible throughout the rest of the project *)
(* Fields that I opted to not include but can be added later if desired *)
(* deleted: bool option; *)
(* by: string option; *)
(* time: int option; *)
(* dead: bool option; *)
(* poll: string option; *)
(* url: string option; *)
(* score: int option; *)
(* parts: int list option; *)
type json_data = 
  {
    id : int option;
    post_type: string option;
    text: string option;
    parent: int option;
    kids: int list option;
    title: string option;
    descendants: int option;
  }

(* Make sure that the token following a keyword is an index and return the token after the colon *)
let rec next token_check = function 
  | [] -> (raise (InputError "Bad JSON Formatting - empty"))
  | h::t when h = token_check -> t
  | _ -> (raise (InputError "Bad JSON Formatting - tokens in bad format"))
;; 

(* Make a list of INT tokens based on the json data *)
let rec make_list curr_list = function 
  | [] -> (raise (BadListError "Make sure your list is surrounded by brackets!"))
  | h::t when h = LEFT_SQUARE -> (raise (BadListError "Shouldn't have another bracket"))
  | h::t when h = RIGHT_SQUARE -> (curr_list, t);
  | h::t when h = COMMA -> make_list curr_list t;
  | h::t -> make_list (h::curr_list) t;
  | _ -> (raise (BadListError "Shouldn't reach this catch-all for lists"))
;;

(* Used for the call to map when converting a list of INT tokens to a list of ints *)
let int_of_token = function
  | INT(t) -> t
  | _ -> (raise (BadTokenError "not an int"))

(* Given an existing record (initially empty) and list of tokens, populate the json record *)
let rec populate_json curr_json_rec = function  
  | [] -> curr_json_rec
  | h::t when h = ID -> 
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with id = Some(nh)}) nt)
  | h::t when h = TYPE ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with post_type = Some(nh)}) nt)
  | h::t when h = TEXT ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with text = Some(nh)}) nt)
  | h::t when h = PARENT ->
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with parent = Some(nh)}) nt)
  | h::t when h = KIDS -> 
    let nh::nt = (next COLON t) in 
    let (int_list, remaining) = make_list [] nt in
    (populate_json ({curr_json_rec with kids = Some(List.map int_of_token int_list)}) remaining)
  | h::t when h = TITLE ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with title = Some(nh)}) nt)
  | h::t when h = DESCENDANTS ->
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with descendants = Some(nh)}) nt)
  | h::t -> populate_json curr_json_rec t
  | _ -> curr_json_rec
;;

(* Function called externally - this is the only one necessary to call if trying to get the json object *)
let parse raw_json = 
  let token_list = (tokenize raw_json) in 
  let data_rec = 
    {
      id = None;
      post_type = None;
      text = None;
      parent = None;
      kids = None;
      title = None;
      descendants = None
    } in
  (populate_json data_rec (rev_list token_list))
;;

(* Function called externally - this is the function to call when looking for general keywords of an article *)
let print_keywords raw_json n = 
  let record = (parse raw_json) in
  print_string "Main Keywords of ";
  print_string (unwrap record.title);
  print_string ": ";
  print_string (get_keywords (unwrap record.text) n); 
  print_string "\n";
;;

(* Printing for testing purposes *)
let rec print_token_list = function 
    | [] -> ()
    | e::l -> print_string (string_of_token e) ; print_string "\n" ; print_token_list l
;;

(* Printing for testing purposes *)
let print_json json =  
  print_string "id: "; if(json.id <> None) then print_int (unwrap json.id); print_string "\n"; 
  print_string "post type: "; if(json.post_type <> None) then print_string (unwrap json.post_type); print_string "\n"; 
  print_string "text: "; if(json.text <> None) then print_string (unwrap json.text); print_string "\n"; 
  print_string "parent: "; if(json.parent <> None) then print_int (unwrap json.parent); print_string "\n"; 
  print_string "kids: "; if(json.kids <> None) then print_int_list (unwrap json.kids); print_string "\n"; 
  print_string "title: "; if(json.title <> None) then print_string (unwrap json.title); print_string "\n"; 
  print_string "descendants: "; if(json.descendants <> None) then print_int (unwrap json.descendants); print_string "\n"
;;
