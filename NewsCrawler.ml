open Lwt
open Cohttp
open Cohttp_lwt_unix

let base_string = "https://hacker-news.firebaseio.com/v0/item/"
let max_item_string = "https://hacker-news.firebaseio.com/v0/maxitem.json"


let get_item_from_id id =
  Client.get (Uri.of_string (base_string ^ string_of_int(id) ^ ".json")) >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body

let get_random_item = 
  Client.get (Uri.of_string (max_item_string)) >>= fun (_, body) -> 
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Random.int (int_of_string(body))

let () =
  let res = Lwt_main.run (get_item_from_id 8863) and
  rando = Lwt_main.run (get_random_item) in
  print_endline ("Received \n" ^ res ^ (Str.replace_first r "\\1" "hello world") ^ string_of_int(rando))