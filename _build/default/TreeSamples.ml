type 'a tree = 
  | Leaf of 'a
  | Node of 'a node
and 'a node = {
  value: 'a;
  children: 'a tree list  
}
