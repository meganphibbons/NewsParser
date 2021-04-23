(* 
 * Main File
 * Authors: Annie Lu, Dorian Barber, Megan Phibbons
 * To run, call dune exec ./NewsParser.exe - this will build and run the code in the project. 
 *)

open JSONSamples
open Parser
open NewsCrawler
open Tree
open Visualizer


let gen_tree id num = 
  let root = build_json_tree id in
  tree_to_dotfile root ("dot_files/tree" ^ (string_of_int num) ^ ".dot")
;;

let rec gen_trees num = function
  | [] -> ()
  | h::t -> gen_tree h num; gen_trees (num + 1) t
;;

(* Main Function *)
let () = 
  (* let ids = [8863; 192327; 121003; 3676776; 1490932; 416961; 6051377; 7738293] in
  gen_trees 0 ids *)
  let ids = [7821431; 2555349; 5521675; 1916133] in 
  gen_trees 8 ids
;;
