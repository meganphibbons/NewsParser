(* 
 * NewsParser Testing Suite
 * Authors: Megan Phibbons
 * Predominantly testing out the priority queue mechanics for determining keywords. 
 * Additionally, checking that the tokens and the JSON records work as expected. 
 * Note: The keywords are tested more extensively here because the functionality of the 
 * tokenizer and parser are demonstrated more clearly in the actual demo itself and 
 * the fact that they work with random data online. 
 *)

open OUnit2
open NewsParser.Tokens
open NewsParser.JSONSamples
open NewsParser.Utility
open NewsParser.Parser
open NewsParser.KeywordGenerator

let json1_tokens = [LEFT_CURL; BY; COLON; STRING "\"justin\""; COMMA; ID; COLON; INT 192327; COMMA; SCORE; COLON; INT 6; COMMA; TEXT; COLON; STRING "\"Justin.tv is the biggest live video site online. We serve hundreds of thousands of video streams a day, and have supported up to 50k live concurrent viewers. Our site is growing every week, and we just added a 10 gbps line to our colo. Our unique visitors are up 900% since January.<p>There are a lot of pieces that fit together to make Justin.tv work: our video cluster, IRC server, our web app, and our monitoring and search services, to name a few. A lot of our website is dependent on Flash, and we're looking for talented Flash Engineers who know AS2 and AS3 very well who want to be leaders in the development of our Flash.<p>Responsibilities<p><pre><code>    * Contribute to product design and implementation discussions\n    * Implement projects from the idea phase to production\n    * Test and iterate code before and after production release \n</code></pre>\nQualifications<p><pre><code>    * You should know AS2, AS3, and maybe a little be of Flex.\n    * Experience building web applications.\n    * A strong desire to work on website with passionate users and ideas for how to improve it.\n    * Experience hacking video streams, python, Twisted or rails all a plus.\n</code></pre>\nWhile we're growing rapidly, Justin.tv is still a small, technology focused company, built by hackers for hackers. Seven of our ten person team are engineers or designers. We believe in rapid development, and push out new code releases every week. We're based in a beautiful office in the SOMA district of SF, one block from the caltrain station. If you want a fun job hacking on code that will touch a lot of people, JTV is for you.<p>Note: You must be physically present in SF to work for JTV. Completing the technical problem at <a href=\\\"http://www.justin.tv/problems/bml\\\" rel=\\\"nofollow\\\">http://www.justin.tv/problems/bml</a> will go a long way with us. Cheers!\""; COMMA; TIME; COLON; INT 1210981217; COMMA; TITLE; COLON; STRING "\"Justin.tv is looking for a Lead Flash Engineer!\""; COMMA; TYPE; COLON; STRING "\"job\""; COMMA; URL; COLON; STRING "\"\""; RIGHT_CURL]
let json2_struct =  { id = Some 121003; post_type = Some "\"story\""; text = Some "\"<i>or</i> HN: the Next Iteration<p>I get the impression that with Arc being released a lot of people who never had time for HN before are suddenly dropping in more often. (PG: what are the numbers on this? I'm envisioning a spike.)<p>Not to say that isn't great, but I'm wary of Diggification. Between links comparing programming to sex and a flurry of gratuitous, ostentatious  adjectives in the headlines it's a bit concerning.<p>80% of the stuff that makes the front page is still pretty awesome, but what's in place to keep the signal/noise ratio high? Does the HN model still work as the community scales? What's in store for (++ HN)?\""; parent = None;  kids = Some [121168; 121109; 121016]; title = Some "\"Ask HN: The Arc Effect\"";  descendants = Some 16 }
let freq_string = "ocaml coding parsing plp fun ocaml coding parsing plp ocaml coding parsing ocaml coding ocaml"
let len_string = "ocaml haskell scheme ocaml haskell scheme ocaml haskell scheme"
let common_string = "and and and and and but but but i you me my ours we"
let partial_common_string = "me and my partners are smart"
let html_tags_string = "<p> filter <p> <p> testing <p>"
let different_cases_string = "oCaMl OCAML ocaml OcAmL haskell haskell haskell"

let test_tokens_list1 _ = assert_equal (rev_list (tokenize json1)) json1_tokens
let test_tokens_list2 _ = assert_equal (List.length (tokenize json2)) 43

let test_json1_record _ = assert_equal (parse json1).kids None
let test_json2_record _ = assert_equal json2_struct (parse json2)

let test_pq_freqs _ = assert_equal (get_keywords freq_string 3) "ocaml, coding, parsing"
let test_pq_len _ = assert_equal (get_keywords len_string 3) "haskell, scheme, ocaml"
let test_pq_n1 _ = assert_equal (get_keywords freq_string 1) "ocaml"
let test_pq_n4 _ = assert_equal (get_keywords freq_string 4) "ocaml, coding, parsing, plp"
let test_pq_n5 _ = assert_equal (get_keywords freq_string 5) "ocaml, coding, parsing, plp, fun"
let test_pq_n6 _ = assert_equal (get_keywords freq_string 6) "ocaml, coding, parsing, plp, fun"
let test_pq_large_n _ = assert_equal (get_keywords freq_string 25) "ocaml, coding, parsing, plp, fun"
let test_pq_filtering1 _ = assert_equal (get_keywords common_string 6) ""
let test_pq_filtering2 _ = assert_equal (get_keywords partial_common_string 3) "partners, smart"
let test_html_filtering _ = assert_equal (get_keywords html_tags_string 3) "testing, filter"
let test_pq_case_difference _ = assert_equal (get_keywords different_cases_string 1) "ocaml"

let suite =
  "parser_tests" >::: [
    "test_tokens_list1" >:: test_tokens_list1;
    "test_tokens_list2" >:: test_tokens_list2; 
    "test_json1_record" >:: test_json1_record;
    "test_json2_record" >:: test_json2_record;
    "test_pq_freqs" >:: test_pq_freqs;
    "test_pq_len" >:: test_pq_len;
    "test_pq_n1" >:: test_pq_n1;
    "test_pq_n4" >:: test_pq_n4;
    "test_pq_n5" >:: test_pq_n5;
    "test_pq_n6" >:: test_pq_n6;
    "test_pq_large_n" >:: test_pq_large_n;
    "test_pq_filtering1" >:: test_pq_filtering1;
    "test_pq_filtering2" >:: test_pq_filtering2;
    "test_html_filtering" >:: test_html_filtering;
    "test_pq_case_difference" >:: test_pq_case_difference;
  ]

let _ = run_test_tt_main suite
