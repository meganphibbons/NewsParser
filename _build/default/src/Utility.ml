(* 
 * Utility Class - Mostly Print Methods but some useful things
 * Authors: Megan Phibbons
 * To use, include 'open Utility' at the top of a file
 *)

exception NoneOptionError of string
exception BadListError of string
exception BadTokenError of string
exception InputError of string

(* We should always check if something is None before calling this unwrap *)
let unwrap opt = 
  match opt with
  | Some a -> a
  | None -> (raise (NoneOptionError "Option shouldn't be None here"))
;;

(* Printing for testing purposes *)
let rec print_int_list = function 
    | [] -> ()
    | e::l -> print_string (string_of_int e) ; print_string ", " ; print_int_list l
;;

(* Printing for testing purposes *)
let rec print_list = function 
    | [] -> ()
    | e::[] -> print_string "and "; print_string e; print_string "! "
    | e::l -> print_string e ; print_string ", " ; print_list l
;;

(* Code to print a generic hashtable *)
let print_table table = 
  Hashtbl.iter (fun key value -> Printf.printf "%s -> %d\n" key value) table
;;

(* Code to print a priority queue of tuples *)
let rec print_pq = function 
    | [] -> ()
    | (key, value)::l -> print_string key; print_string "-> "; print_string (string_of_int value); print_string "\n" ; print_pq l
;;

(* Code to reverse a list *)
let rev_list l =
  let rec rev_acc acc = function
    | [] -> acc
    | hd::tl -> rev_acc (hd::acc) tl
  in 
  rev_acc [] l

(* Whitespace for tokenizing and splitting text *)
let whitespace = Str.regexp " \\|\n\\|\t"
