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
open TreeSamples


(* Main Function *)
let () = 
  let root = build_json_tree 8863 in
  print_tree 0 root;
  tree_to_dotfile root "dot_files/tree.dot";

  let root1 = build_json_tree 192327 in
  print_tree 0 root;
  tree_to_dotfile root1 "dot_files/tree1.dot";

  let root2 = build_json_tree 121003 in
  print_tree 0 root;
  tree_to_dotfile root2 "dot_files/tree2.dot"
;;
