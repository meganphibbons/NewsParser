(* 
 * Keyword Generator
 * Authors: Megan Phibbons
 * To use, include 'open KeywordGenerator' at the top of a file
 * Useful Functions: 
 * - get_keywords -> string [article text] -> int [number of desired keywords] -> string [formatted keywords]
 *)

open Utility
open AvoidedWords

(* Helper function that removes HTML tags and symbols from the text *)
let prune key = 
  let no_html = (Str.global_replace (Str.regexp "<[^>]*>") "" key) in
  (Str.global_replace (Str.regexp"[\\?\\!:,()+\\\"*]") "" no_html)

(* Helper function that populates a hashtable from a list of keywords *)
let rec populate_table table = function 
  | [] -> table
  | h::t -> let new_key = String.lowercase_ascii (prune h) in
            if (Hashtbl.mem table new_key) 
            then (Hashtbl.replace table new_key ((Hashtbl.find table new_key) + 1))
            else (Hashtbl.add table new_key 1);
            populate_table table t
;;

(* Helper function that adds a singular tuple to a priority queue *)
(* Priority is based on number of occurrences with string length as a tiebreaker *)
let rec add_to_pq (key, value) pq = 
  match pq with  
  | [] -> (key, value)::[]
  | (hkey, hval)::t when value > hval -> (key, value)::pq
  | (hkey, hval)::t when value == hval && ((String.length key) > (String.length hkey)) -> (key, value)::pq
  | h::t -> h::(add_to_pq (key, value) t)
;;

(* Helper function that makes a priority queue out of an unordered list of tuples *)
let rec make_pq pq = function 
  | [] -> pq
  | (k, v)::t -> make_pq (add_to_pq (k, v) pq) t
;;

(* Helper function that makes a list of tuples out of a hashtable *)
let make_pair_list table = 
  Hashtbl.fold (fun k v acc -> (k, v) :: acc) table []
;;

(* Helper function that determines if a given word is in our avoid list or not *)
let rec is_common word = function 
  | [] -> false
  | h::t when h = word -> true
  | h::t -> is_common word t
;;

(* Helper function that removes common words from the priority queue *)
let rec trim_pq pq = match pq with 
  | [] -> pq
  | (hkey, hval)::t -> if is_common hkey avoided then trim_pq t else (hkey, hval)::(trim_pq t)
;;

(* Helper function that finds the top n keywords in a priority queue *)
let rec top_n_keywords top_n n = function
  | (hkey, hval)::t when n > 0 -> (hkey::top_n_keywords top_n (n - 1) t)
  | _ -> top_n

(* Helper function that generates keywords based on the text of an article *)
let generate_keywords article_text n = 
  let table = Hashtbl.create 500 in
  let word_list = (Str.split whitespace (Str.global_replace (Str.regexp "\.") " " article_text)) in 
  let table = (populate_table table word_list) in 
  let pair_list = (make_pair_list table) in
  (top_n_keywords [] n (trim_pq (make_pq [] pair_list)))
;;

(* External function that finds the keywords and formats them into a String representation *)
let get_keywords article_text n = 
  let keyword_list = generate_keywords article_text n in
  String.concat ", " keyword_list
;;
