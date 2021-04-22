(*
 * HackerNews API NewsCrawler
 * Authors: Dorian Barber
 * main function(s):
 * - build_json_tree -> int (HackerNews item id) -> json_data tree (tree with json_data object as values)
 * - find_parent_id -> int (HackerNews item id) -> option int (the id for the root of the tree which contains this item)
 *)

open Lwt
open Cohttp
open Cohttp_lwt_unix
open Parser
open KeywordGenerator
open Tree

let base_string = "https://hacker-news.firebaseio.com/v0/item/"
let max_item_string = "https://hacker-news.firebaseio.com/v0/maxitem.json"

let title_kw_count = 5
let text_kw_count = 3

let get_item_from_id id =
  Client.get (Uri.of_string (base_string ^ string_of_int(id) ^ ".json")) >>= fun (_, body) ->
  (*let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code; *)
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body

let get_random_item = 
  Client.get (Uri.of_string (max_item_string)) >>= fun (_, body) -> 
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Random.int (int_of_string(body))

(* Example call to find_parent_id 
match find_parent_id 8969 with
  | Some id -> print_int id
  | None -> print_int (0) *)

let rec find_parent_id id = 
  let curr = Lwt_main.run (get_item_from_id id) in 
  let curr_json = parse (curr) in
  match curr_json.parent with
  | Some pid -> find_parent_id (pid)
  | None -> curr_json.id

let get_keywords_from_json json =
  match json.text with
  | Some text -> get_keywords text text_kw_count
  | None -> match json.title with 
    | Some title -> get_keywords title title_kw_count
    | None -> ""

(* Example call to build_json_tree
match build_json_tree 8863 with
  | Leaf _ -> print_endline("Wrong\n")
  | Node a -> print_json a.value *)

let rec build_json_tree id = 
  let curr = Lwt_main.run (get_item_from_id id) in 
  let curr_json = parse (curr) in
  match curr_json.kids with
  | Some kids -> Node {value = get_keywords_from_json (curr_json); children = List.map build_json_tree kids}
  | None -> Leaf (get_keywords_from_json (curr_json))

