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
  print_keywords json1 5;
  print_keywords json2 4;

  let root = build_json_tree 8863 in
  print_tree 0 root;
  tree_to_dotfile root "tree2.dot"
;;
