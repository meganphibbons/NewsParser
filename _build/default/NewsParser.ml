open Tokens

type json_data = 
  {
    id : int option;
    post_type: string option;
    text: string option;
    parent: int option;
    kids: int list option;
    title: string option;
    descendants: int option;
  }
  (* Fields that I opted to not include but can be added later if desired *)
  (* deleted: bool option; *)
  (* by: string option; *)
  (* time: int option; *)
  (* dead: bool option; *)
  (* poll: string option; *)
  (* url: string option; *)
  (* score: int option; *)
  (* parts: int list option; *)

  exception NoneOptionError of string

let rec next token_check = function 
  | [] -> (raise (InputError "Bad JSON Formatting - empty"))
  | h::t when h = token_check -> t
  | _ -> (raise (InputError "Bad JSON Formatting - tokens in bad format"))
;;

let unwrap opt = 
  match opt with
  | Some a -> a
  | None -> (raise (NoneOptionError "Option shouldn't be None here"))

  let rec populate_json curr_json_rec = function  
  | [] -> curr_json_rec
  | h::t when h = ID -> 
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with id = Some(nh)}) nt)
  | h::t when h = TYPE ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with post_type = Some(nh)}) nt)
  | h::t when h = TEXT ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with text = Some(nh)}) nt)
  | h::t when h = PARENT ->
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with parent = Some(nh)}) nt)
  (* | h::t when h = KIDS -> TODO: I am too lazy for this right now *)
  | h::t when h = TITLE ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with title = Some(nh)}) nt)
  | h::t when h = DESCENDANTS ->
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with descendants = Some(nh)}) nt)
  | h::t -> populate_json curr_json_rec t
  | _ -> curr_json_rec
;;

let print_json json =  
  print_string "id: "; if(json.id <> None) then print_int (unwrap json.id); print_string "\n"; 
  print_string "post type: "; if(json.post_type <> None) then print_string (unwrap json.post_type); print_string "\n"; 
  print_string "text: "; if(json.text <> None) then print_string (unwrap json.text); print_string "\n"; 
  print_string "parent: "; if(json.parent <> None) then print_int (unwrap json.parent); print_string "\n"; 
  (* if(json.kids <> None) then print_string "kids: "; print_int (unwrap json.kids); print_string "\n";  *)
  print_string "title: "; if(json.title <> None) then print_string (unwrap json.title); print_string "\n"; 
  print_string "descendants: "; if(json.descendants <> None) then print_int (unwrap json.descendants); print_string "\n"
;;

let rec print_list = function 
    | [] -> ()
    | e::l -> print_string (string_of_token e) ; print_string "\n" ; print_list l
;;

let rev_list l =
  let rec rev_acc acc = function
    | [] -> acc
    | hd::tl -> rev_acc (hd::acc) tl
  in 
  rev_acc [] l

let parse raw_json = 
  let token_list = (tokenize raw_json) in 
  let data_rec = 
    {
      id = None;
      post_type = None;
      text = None;
      parent = None;
      kids = None;
      title = None;
      descendants = None
    } in
  (populate_json data_rec (rev_list token_list))
;;

(* type json_val = 
  | Text: string
  | Number: int 
  | List: int list
;; *)

let () = 
  let json = "{
    \"by\" : \"justin\",
    \"id\" : 192327,
    \"score\" : 6,
    \"text\" : \"hi\",
    \"time\" : 1210981217,
    \"title\" : \"Justin.tv is the biggest live video site online. We serve hundreds of thousands of video streams a day, and have supported up to 50k live concurrent viewers. Our site is growing every week, and we just added a 10 gbps line to our colo. Our unique visitors are up 900% since January.<p>There are a lot of pieces that fit together to make Justin.tv work: our video cluster, IRC server, our web app, and our monitoring and search services, to name a few. A lot of our website is dependent on Flash, and we're looking for talented Flash Engineers who know AS2 and AS3 very well who want to be leaders in the development of our Flash.<p>Responsibilities<p><pre><code>    * Contribute to product design and implementation discussions\n    * Implement projects from the idea phase to production\n    * Test and iterate code before and after production release \n</code></pre>\nQualifications<p><pre><code>    * You should know AS2, AS3, and maybe a little be of Flex.\n    * Experience building web applications.\n    * A strong desire to work on website with passionate users and ideas for how to improve it.\n    * Experience hacking video streams, python, Twisted or rails all a plus.\n</code></pre>\nWhile we're growing rapidly, Justin.tv is still a small, technology focused company, built by hackers for hackers. Seven of our ten person team are engineers or designers. We believe in rapid development, and push out new code releases every week. We're based in a beautiful office in the SOMA district of SF, one block from the caltrain station. If you want a fun job hacking on code that will touch a lot of people, JTV is for you.<p>Note: You must be physically present in SF to work for JTV. Completing the technical problem at <a href=\\\"http://www.justin.tv/problems/bml\\\" rel=\\\"nofollow\\\">http://www.justin.tv/problems/bml</a> will go a long way with us. Cheers!\",
    \"type\" : \"job\",
    \"url\" : \"\"
  }" in
  (* print_list (rev_list (tokenize json)) *)
  (print_json (parse json))
;;

(* let get key json = 
  let index = (search json "\"" + key + "\"" + " : ")
  if index == -1 return "Key Not Found"


let search json_file regex = 
    try(Str.search_forward (Str.regexp regex) json_file 0) with 
      Not_found -> -1;

let is_comment json_file = 
  (find_type json_file "\"type\" : \"comment\"") != -1

let get_parent json_file =  *)
