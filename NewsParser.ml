(* 
 * Main File
 * Authors: Annie Lu, Dorian Barber, Megan Phibbons
 * To run, call dune exec ./NewsParser.exe - this will build and run the code in the project. 
 *)

open JSONSamples
open Parser
open NewsCrawler

(* Main Function *)
let () = 
  print_keywords json1 5;
  print_keywords json2 4;
;;


(* for testing NewsCrawler

match build_json_tree 8863 with
  | Leaf _ -> print_endline("Wrong\n")
  | Node a -> print_json a.value *)
