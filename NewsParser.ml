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

(* Good IDs That Show Details:
 * Wide breadth with little depth: 8863 (tree0 in current data)
 * Single node with keywords: 192327 (tree1 in current data)
 * Absurdly large file: 3676776 (tree3 in current data)
 * Simpler tree - easier for actually reading entire thing: 1490932 (tree4 in current data)
 * Single node with no keywords: 416961 (tree5 in current data)
 * Tree that has one path with a bunch of single children: 1916133 (tree11 in current data)
*)


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
