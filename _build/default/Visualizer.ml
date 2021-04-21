
open TreeSamples

let to_dot_node (t: 'a tree) : string = match t with 
  | Empty -> "" 
  | Node(_,x,_) -> "{N"^x^"[label=\"" ^x^"\"]}"
  | Leaf x ->      "{L"^x^"[shape=circle,label=\"" ^x^ "\"]}";;
 
let edge (n1: 'a tree ) (n2 : 'a tree ) : string = (to_dot_node n1)^"--"^(to_dot_node n2)^"\n";;

let rec tree_to_dot (acc : string) (t : 'a tree) : string = 
  match t with 
  | Empty -> acc
  | Leaf _ as leaf ->   acc ^ (to_dot_node leaf)
  | Node( (Node (_,_,_) as n) , _,  (Leaf _ as leaf)) 
  | Node( Leaf _ as leaf, _, (Node (_,_,_) as n))     ->
      (edge t n) ^ (edge t leaf) ^(tree_to_dot acc n)
  | Node( ( Node(_,_,_)  as n) , _,  Empty)
  | Node( Empty, _, (Node(_,_,_) as n))    ->
      (edge t n) ^ (tree_to_dot acc n)
  | Node( ( Leaf _  as leaf), _, Empty) 
  | Node( Empty, _,(Leaf _ as leaf))   -> 
      (edge t leaf) 
  | Node( (Leaf _ as left), _, (Leaf _ as right)) ->
      (edge t left) ^ (edge t right)
  | Node( Empty, _, Empty) ->
      acc
  | Node( (Node (_,_,_) as nl) , _, (Node(_,_,_) as nr)) -> 
      (edge t nl)^(edge t nr)^(tree_to_dot acc nl)^(tree_to_dot acc nr);;

let tree_to_dotfile t file = 
  let dot_tree = "graph tree {\n"^(tree_to_dot " " t)^"}" in
  let channel = open_out file in
  output_string channel dot_tree;
  close_out channel;;


