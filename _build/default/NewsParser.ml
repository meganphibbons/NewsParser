(* 
 * Main File
 * Authors: Annie Lu, Dorian Barber, Megan Phibbons
 * To run, call dune exec ./NewsParser.exe - this will build and run the code in the project. 
 *)

open JSONSamples
open Parser
open Visualizer
open TreeSamples


(* Main Function *)
let () = 
  print_keywords json1 5;
  print_keywords json2 4;
  tree_to_dotfile t1 "tree.dot"
;;
