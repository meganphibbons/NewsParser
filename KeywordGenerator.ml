open Tokens

let prune key = 
  let no_html = (Str.global_replace (Str.regexp "<[^>]*>") "" key) in
  (Str.global_replace (Str.regexp"[:,()+\\\"*]") "" no_html)

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

let rec add_to_pq (key, value) pq = 
  match pq with  
  | [] -> (key, value)::[]
  | (hkey, hval)::t when value > hval -> (key, value)::pq
  | h::t -> h::(add_to_pq (key, value) t)
;;

let rec make_pq pq = function 
  | [] -> pq
  | (k, v)::t -> make_pq (add_to_pq (k, v) pq) t
;;

let make_pair_list table = 
  Hashtbl.fold (fun k v acc -> (k, v) :: acc) table []
;;

let generate_keywords article_text = 
  let table = Hashtbl.create 500 in
  (* val my_hash : (string, int) Hashtbl.t;; map from string to num occurrences *)
  let word_list = (Str.split whitespace (Str.global_replace (Str.regexp "\.") " " article_text)) in 
  let table = (populate_table table word_list) in 
  let pair_list = (make_pair_list table) in
  print_pq (make_pq [] pair_list)
;;
