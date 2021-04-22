type 'a tree = 
  | Leaf of 'a
  | Node of 'a node

and 'a node = {
  value: 'a;
  children: 'a tree list  
}

let rec print_tree level t =
  match t with
  | Leaf content -> print_endline ((String.make level '\t') ^ content)
  | Node node -> print_endline ((String.make level '\t') ^ node.value); List.iter (print_tree (level + 1)) node.children 


