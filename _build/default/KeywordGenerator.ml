open Tokens
open AvoidedWords

let prune key = 
  let no_html = (Str.global_replace (Str.regexp "<[^>]*>") "" key) in
  (Str.global_replace (Str.regexp"[\\?\\!:,()+\\\"*]") "" no_html)

let rec populate_table table = function 
  | [] -> table
  | h::t -> let new_key = String.lowercase_ascii (prune h) in
            if (Hashtbl.mem table new_key) 
            then (Hashtbl.replace table new_key ((Hashtbl.find table new_key) + 1))
            else (Hashtbl.add table new_key 1);
            populate_table table t
;;

let rec print_table table = 
  Hashtbl.iter (fun key value -> Printf.printf "%s -> %d\n" key value) table
;;

let rec print_pq = function 
    | [] -> ()
    | (key, value)::l -> print_string key; print_string "-> "; print_string (string_of_int value); print_string "\n" ; print_pq l
;;

let rec print_list = function 
    | [] -> ()
    | e::l -> print_string e ; print_string "\n" ; print_list l
;;

let rec add_to_pq (key, value) pq = 
  match pq with  
  | [] -> (key, value)::[]
  | (hkey, hval)::t when value > hval -> (key, value)::pq
  | (hkey, hval)::t when value == hval && ((String.length key) > (String.length hkey)) -> (key, value)::pq
  | h::t -> h::(add_to_pq (key, value) t)
;;

let rec make_pq pq = function 
  | [] -> pq
  | (k, v)::t -> make_pq (add_to_pq (k, v) pq) t
;;

let make_pair_list table = 
  Hashtbl.fold (fun k v acc -> (k, v) :: acc) table []
;;

let rec is_common word = function 
  | [] -> false
  | h::t when h = word -> true
  | h::t -> is_common word t
;;

let rec trim_pq pq = match pq with 
  | [] -> pq
  | (hkey, hval)::t -> if is_common hkey avoided then trim_pq t else (hkey, hval)::(trim_pq t)
;;

let rec top_n_keywords top_n n = function
  | (hkey, hval)::t when n > 0 -> (hkey::top_n_keywords top_n (n - 1) t)
  | _ -> top_n

let generate_keywords article_text n = 
  let table = Hashtbl.create 500 in
  (* val my_hash : (string, int) Hashtbl.t;; map from string to num occurrences *)
  let word_list = (Str.split whitespace (Str.global_replace (Str.regexp "\.") " " article_text)) in 
  let table = (populate_table table word_list) in 
  let pair_list = (make_pair_list table) in
  (top_n_keywords [] n (trim_pq (make_pq [] pair_list)))
;;
