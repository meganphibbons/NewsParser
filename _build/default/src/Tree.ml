type 'a tree = 
  | Leaf of int * 'a
  | Node of 'a node

and 'a node = {
  id: int;
  value: 'a;
  children: ('a tree) list  
}

(* 
 * int -> string tree -> unit (ie it just prints stuff) 
 * prints a tree structure with each level being tabbed by the level number 
 * inital call should be print_tree 0
 *)
let rec print_tree level t =
  match t with
  | Leaf (id,content) -> print_endline ((String.make level '\t') ^ (string_of_int id) ^ ": " ^ content)
  | Node node -> print_endline ((String.make level '\t') ^ (string_of_int node.id) ^ ": " ^ node.value); List.iter (print_tree (level + 1)) node.children 

