
open Tree

let num = ref 0

let fresh = num := !num + 1; !num

let to_dot_node (t: 'a tree) : string = match t with 
  | Node x -> (string_of_int x.id) ^ "[shape=circle, label=\"" ^x.value^"\"]\n"
  | Leaf (id,x) -> (string_of_int id) ^ "[shape=circle, label=\"" ^ x ^ "\"]\n";;
  
let node_id = function
    | Node x -> x.id
    | Leaf(id, _) -> id

let edge (n1: 'a tree ) (n2 : 'a tree ) : string = (string_of_int (node_id n1)) ^ "->" ^ (string_of_int (node_id n2)) ^ "\n";;


let rec tree_node_preamble t = 
    match t with
    | Leaf _ as leaf -> (to_dot_node leaf)
    | Node node -> 
    List.fold_left (fun acc h -> (tree_node_preamble h) ^ acc) (to_dot_node (Node node)) node.children
;;

let rec tree_node_connections t =
    match t with
    | Leaf _ as leaf -> ""
    | Node node -> 
    List.fold_left (fun acc h -> (tree_node_connections h) ^ (edge t h) ^ acc) "" node.children


let rec length lst = 
  match lst with
  | [] -> 0
  | h::t -> 1 + (length t);;

let tree_to_dotfile t file = 
  let dot_tree = "digraph tree {\n"^( tree_node_preamble t) ^ (tree_node_connections t) ^ "}" in
  let channel = open_out file in
  output_string channel dot_tree;
  close_out channel;;