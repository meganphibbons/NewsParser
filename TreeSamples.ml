type 'a tree = Empty | Leaf of 'a | Node of 'a tree * 'a * 'a tree;;

let t1 = Node (
              Node (
                    Leaf "0", 
                    "1", 
                    Leaf "2"), 
              "3", 
              Node (
                    Leaf "4", 
                    "5", 
                    Leaf "6"
              ) 
         );;