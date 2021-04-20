open Tokens
open KeywordGenerator

exception NoneOptionError of string
exception BadListError of string
exception BadTokenError of string

(* Record to keep track of json data so that it is easily accessible throughout the rest of the project *)
(* Fields that I opted to not include but can be added later if desired *)
(* deleted: bool option; *)
(* by: string option; *)
(* time: int option; *)
(* dead: bool option; *)
(* poll: string option; *)
(* url: string option; *)
(* score: int option; *)
(* parts: int list option; *)
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

(* Make sure that the token following a keyword is an index and return the token after the colon *)
let rec next token_check = function 
  | [] -> (raise (InputError "Bad JSON Formatting - empty"))
  | h::t when h = token_check -> t
  | _ -> (raise (InputError "Bad JSON Formatting - tokens in bad format"))
;; 

(* We should always check if something is None before calling this unwrap *)
let unwrap opt = 
  match opt with
  | Some a -> a
  | None -> (raise (NoneOptionError "Option shouldn't be None here"))
;;

(* Make a list of INT tokens based on the json data *)
let rec make_list curr_list = function 
  | [] -> (raise (BadListError "Make sure your list is surrounded by brackets!"))
  | h::t when h = LEFT_SQUARE -> (raise (BadListError "Shouldn't have another bracket"))
  | h::t when h = RIGHT_SQUARE -> (curr_list, t);
  | h::t when h = COMMA -> make_list curr_list t;
  | h::t -> make_list (h::curr_list) t;
  | _ -> (raise (BadListError "Shouldn't reach this catch-all for lists"))
;;

(* Used for the call to map when converting a list of INT tokens to a list of ints *)
let int_of_token = function
  | INT(t) -> t
  | _ -> (raise (BadTokenError "not an int"))

(* Given an existing record (initially empty) and list of tokens, populate the json record *)
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
  | h::t when h = KIDS -> 
    let nh::nt = (next COLON t) in 
    let (int_list, remaining) = make_list [] nt in
    (populate_json ({curr_json_rec with kids = Some(List.map int_of_token int_list)}) remaining)
  | h::t when h = TITLE ->
    let STRING(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with title = Some(nh)}) nt)
  | h::t when h = DESCENDANTS ->
    let INT(nh)::nt = (next COLON t) in 
    (populate_json ({curr_json_rec with descendants = Some(nh)}) nt)
  | h::t -> populate_json curr_json_rec t
  | _ -> curr_json_rec
;;

(* Necessary to be able to reverse a list because the tokens are stored in reverse order *)
let rev_list l =
  let rec rev_acc acc = function
    | [] -> acc
    | hd::tl -> rev_acc (hd::acc) tl
  in 
  rev_acc [] l

(* Function called externally - this is the only one necessary to call if trying to get the json object *)
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

(* Printing for testing purposes *)
let rec print_list = function 
    | [] -> ()
    | e::l -> print_string (string_of_token e) ; print_string "\n" ; print_list l
;;

(* Printing for testing purposes *)
let rec print_int_list = function 
    | [] -> ()
    | e::l -> print_string (string_of_int e) ; print_string ", " ; print_int_list l
;;

(* Printing for testing purposes *)
let print_json json =  
  print_string "id: "; if(json.id <> None) then print_int (unwrap json.id); print_string "\n"; 
  print_string "post type: "; if(json.post_type <> None) then print_string (unwrap json.post_type); print_string "\n"; 
  print_string "text: "; if(json.text <> None) then print_string (unwrap json.text); print_string "\n"; 
  print_string "parent: "; if(json.parent <> None) then print_int (unwrap json.parent); print_string "\n"; 
  print_string "kids: "; if(json.kids <> None) then print_int_list (unwrap json.kids); print_string "\n"; 
  print_string "title: "; if(json.title <> None) then print_string (unwrap json.title); print_string "\n"; 
  print_string "descendants: "; if(json.descendants <> None) then print_int (unwrap json.descendants); print_string "\n"
;;

(* Testing data and work - this just ensures that the tokenizer works as intended and the parser works *)
let () = 
  let json1 = "{
    \"by\" : \"justin\",
    \"id\" : 192327,
    \"score\" : 6,
    \"text\" : \"Justin.tv is the biggest live video site online. We serve hundreds of thousands of video streams a day, and have supported up to 50k live concurrent viewers. Our site is growing every week, and we just added a 10 gbps line to our colo. Our unique visitors are up 900% since January.<p>There are a lot of pieces that fit together to make Justin.tv work: our video cluster, IRC server, our web app, and our monitoring and search services, to name a few. A lot of our website is dependent on Flash, and we're looking for talented Flash Engineers who know AS2 and AS3 very well who want to be leaders in the development of our Flash.<p>Responsibilities<p><pre><code>    * Contribute to product design and implementation discussions\n    * Implement projects from the idea phase to production\n    * Test and iterate code before and after production release \n</code></pre>\nQualifications<p><pre><code>    * You should know AS2, AS3, and maybe a little be of Flex.\n    * Experience building web applications.\n    * A strong desire to work on website with passionate users and ideas for how to improve it.\n    * Experience hacking video streams, python, Twisted or rails all a plus.\n</code></pre>\nWhile we're growing rapidly, Justin.tv is still a small, technology focused company, built by hackers for hackers. Seven of our ten person team are engineers or designers. We believe in rapid development, and push out new code releases every week. We're based in a beautiful office in the SOMA district of SF, one block from the caltrain station. If you want a fun job hacking on code that will touch a lot of people, JTV is for you.<p>Note: You must be physically present in SF to work for JTV. Completing the technical problem at <a href=\\\"http://www.justin.tv/problems/bml\\\" rel=\\\"nofollow\\\">http://www.justin.tv/problems/bml</a> will go a long way with us. Cheers!\",
    \"time\" : 1210981217,
    \"title\" : \"Justin.tv is looking for a Lead Flash Engineer!\",
    \"type\" : \"job\",
    \"url\" : \"\"
  }" in
  let json2 = 
  "{
    \"by\" : \"dhouston\",
    \"descendants\" : 71,
    \"id\" : 8863,
    \"kids\" : [ 8952, 9224, 8917, 8884, 8887, 8943, 8869, 8958, 9005, 9671, 8940, 9067, 8908, 9055, 8865, 8881, 8872, 8873, 8955, 10403, 8903, 8928, 9125, 8998, 8901, 8902, 8907, 8894, 8878, 8870, 8980, 8934, 8876 ],
    \"score\" : 111,
    \"time\" : 1175714200,
    \"title\" : \"My YC app: Dropbox - Throw away your USB drive\",
    \"type\" : \"story\",
    \"url\" : \"http://www.getdropbox.com/u/2/screencast.html\"
  }" in
  print_string "JSON 1 Data:\n";
  (print_json (parse json1));
  print_string "\n JSON 2 Data:\n";
  (print_json (parse json2));
  (generate_keywords (unwrap (parse json1).text))
  (* Test Tokenizer: print_list (rev_list (tokenize json)) *)
;;

