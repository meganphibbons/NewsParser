type tokens = 
  INT of int |
  FLOAT of float |
  STRING of string |
  TRUE |
  FALSE | 
  NULL |
  LEFT_CURL | 
  RIGHT_CURL | 
  LEFT_SQUARE |
  RIGHT_SQUARE | 
  COLON | 
  COMMA |
  ID |
  DELETED |
  TYPE | 
  BY | 
  TIME | 
  TEXT | 
  DEAD | 
  PARENT |
  POLL | 
  KIDS | 
  URL | 
  SCORE | 
  TITLE | 
  PARTS | 
  DESCENDANTS
;;

let string_of_token = function
| INT a -> string_of_int a
| FLOAT a -> string_of_float a
| STRING a -> a
| TRUE -> "true"
| FALSE -> "false"
| NULL -> "null"
| LEFT_CURL -> "{"
| RIGHT_CURL -> "}"
| LEFT_SQUARE -> "["
| RIGHT_SQUARE -> "]"
| COLON -> ":"
| COMMA -> ","
| ID -> "id"
| DELETED -> "deleted"
| TYPE -> "type"
| BY -> "by"
| TIME -> "time"
| TEXT -> "text"
| DEAD -> "dead"
| PARENT -> "parent"
| POLL -> "poll"
| KIDS -> "kids"
| URL -> "url"
| SCORE -> "score"
| TITLE -> "title"
| PARTS -> "parts"
| DESCENDANTS -> "descendants"

let int_reg = "[0-9]+"
let float_reg = "[0-9]+\\.[0-9]+"
let string_reg = "\"[^\"\\\\]*\\(\\\\.[^\"\\\\]*\\)*\""
let true_reg = "true"
let false_reg = "false"
let null_reg = "null"
let lcurl_reg = "{"
let rcurl_reg = "}"
let lsq_reg = "\\["
let rsq_reg = "\\]"
let colon_reg = ":"
let comma_reg = ","

let id_reg = "\"id\""
let deleted_reg = "\"deleted\""
let type_reg = "\"type\""
let by_reg = "\"by\""
let time_reg = "\"time\""
let text_reg = "\"text\""
let dead_reg = "\"dead\""
let parent_reg = "\"parent\""
let poll_reg = "\"poll\""
let kids_reg = "\"kids\""
let url_reg = "\"url\""
let score_reg = "\"score\""
let title_reg = "\"title\""
let parts_reg = "\"parts\""
let descendants_reg = "\"descendants\""

let whitespace = Str.regexp " \\|\n\\|\t"

let int_func value = 
  INT(int_of_string(value))
;;

let float_func value = 
  FLOAT(float_of_string(value))
;;

let string_func value = 
  STRING(value)
;;

let token_func token_type _ = 
  token_type
;;

let token_map = 
  [
    (Str.regexp id_reg, token_func ID);
    (Str.regexp deleted_reg, token_func DELETED);
    (Str.regexp type_reg, token_func TYPE);
    (Str.regexp by_reg, token_func BY);
    (Str.regexp time_reg, token_func TIME);
    (Str.regexp text_reg, token_func TEXT);
    (Str.regexp dead_reg, token_func DEAD);
    (Str.regexp parent_reg, token_func PARENT);
    (Str.regexp poll_reg, token_func POLL);
    (Str.regexp kids_reg, token_func KIDS);
    (Str.regexp url_reg, token_func URL);
    (Str.regexp score_reg, token_func SCORE);
    (Str.regexp title_reg, token_func TITLE);
    (Str.regexp parts_reg, token_func PARTS);
    (Str.regexp descendants_reg, token_func DESCENDANTS);
    (Str.regexp int_reg, int_func);
    (Str.regexp float_reg, float_func);
    (Str.regexp true_reg, token_func TRUE);
    (Str.regexp false_reg, token_func FALSE);
    (Str.regexp null_reg, token_func NULL);
    (Str.regexp lcurl_reg, token_func LEFT_CURL);
    (Str.regexp rcurl_reg, token_func RIGHT_CURL);
    (Str.regexp lsq_reg, token_func LEFT_SQUARE);
    (Str.regexp rsq_reg, token_func RIGHT_SQUARE);
    (Str.regexp colon_reg, token_func COLON);
    (Str.regexp comma_reg, token_func COMMA);
    (Str.regexp string_reg, string_func); 
  ]

let max_token index json (longest, token) (regex, current_token_func) =  
  if Str.string_match regex json index then 
    let matched = Str.matched_string json in 
    let len = String.length matched in 
    if len > longest then 
      (len, Some(current_token_func matched))
    else (longest, token)
  else (longest, token)

exception InputError of string

let tokenize json = 
  let rec tokenize index acc = 
    if index >= (String.length json) then acc
    else if (Str.string_match whitespace json index) then (tokenize (index + 1) acc)
    else 
      let (length, token) = (List.fold_left(max_token index json) (0, None) token_map) in
      match token with 
      | None -> (raise (InputError "Bad JSON Formatting"))
      | Some(token) -> (tokenize (index + length) (token::acc))
  in
  tokenize 0 []
;;
