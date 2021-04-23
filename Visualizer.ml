
open Tree



let to_dot_node (t: 'a tree) : string = match t with 
  | Node x -> "{N"^(x.value)^"[label=\"" ^x.value^"\"]}"
  | Leaf x ->      "{L"^(x)^"[shape=circle,label=\"" ^x^ "\"]}";;
 
let edge (n1: 'a tree ) (n2 : 'a tree ) : string = (to_dot_node n1)^"--"^(to_dot_node n2)^"\n";;


let rec length lst = 
  match lst with
  | [] -> 0
  | h::t -> 1 + (length t);;

let rec tree_to_dot (acc : string) (t : 'a tree) : string = 
  match t with 
  | Leaf _ as leaf ->   acc ^ (to_dot_node leaf)
  | Node node -> 
    let mini curr_node = acc ^ (edge t curr_node) ^ (tree_to_dot acc curr_node) in
    String.concat "" (List.map mini node.children);;
  
    (* for i = 0 to ((length node.children)-1) do 
        let curr_node = (List.nth node.children i) in 
            let acc ^ (edge t curr_node) ^ (tree_to_dot acc curr_node)
        (* (let _ = acc ^ (edge t curr_node)
        let _ = tree_to_dot acc curr_node
        ) *)
    done;; *)
        
            (* s^(tree_to_dot acc n.children.nth(i))
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
      (edge t nl)^(edge t nr)^(tree_to_dot acc nl)^(tree_to_dot acc nr);; *)

(* let rec tree_to_dot (acc : string) (t : 'a tree) : string = 
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
      (edge t nl)^(edge t nr)^(tree_to_dot acc nl)^(tree_to_dot acc nr);; *)

let tree_to_dotfile t file = 
  let dot_tree = "graph tree {\n"^(tree_to_dot " " t)^"}" in
  let channel = open_out file in
  output_string channel dot_tree;
  close_out channel;;


