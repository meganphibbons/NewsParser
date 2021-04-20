open Tokens

let rec populate_table table = function 
  | [] -> table
  | h::t -> if (Hashtbl.mem table h) 
            then (Hashtbl.replace table h ((Hashtbl.find table h) + 1))
            else (Hashtbl.add table h 1);
            populate_table table t
;;

let rec print_table table = 
  Hashtbl.iter (fun key value -> Printf.printf "%s -> %d\n" key value) table;;

let generate_keywords article_text = 
  let table = Hashtbl.create 500 in
  (* val my_hash : (string, int) Hashtbl.t;; map from string to num occurrences *)
  let word_list = (Str.split whitespace article_text) in 
  print_table (populate_table table word_list)
;;
