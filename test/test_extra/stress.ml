module Edsl = Ccl.Edsl
open Ccl.Model

let text =
  {|
/= This is a CCL document
title = CCL Example

database =
  enabled = true
  ports =
    = 8000
    = 8001
    = 8002
  limits =
    cpu = 1500mi
    memory = 10Gb

user =
  guestId = 42

user =
  login = chshersh
  createdAt = 2024-12-31
|}

let kvs =
  Ccl.Parser.
    [
      { key = "/"; value = "This is a CCL document" };
      { key = "title"; value = "CCL Example" };
      {
        key = "database";
        value =
          {|
  enabled = true
  ports =
    = 8000
    = 8001
    = 8002
  limits =
    cpu = 1500mi
    memory = 10Gb|};
      };
      { key = "user"; value = "\n  guestId = 42" };
      { key = "user"; value = "\n  login = chshersh\n  createdAt = 2024-12-31" };
    ]

let key_map =
  KeyMap.of_list
    [
      ("/", Fix (KeyMap.of_list [ ("This is a CCL document", empty) ]));
      ("title", Fix (KeyMap.of_list [ ("CCL Example", empty) ]));
      ( "database",
        Fix
          (KeyMap.of_list
             [
               ("enabled", Fix (KeyMap.of_list [ ("true", empty) ]));
               ( "ports",
                 Fix
                   (KeyMap.of_list
                      [
                        ( "",
                          Fix
                            (KeyMap.of_list
                               [
                                 ("8000", empty);
                                 ("8001", empty);
                                 ("8002", empty);
                               ]) );
                      ]) );
               ( "limits",
                 Fix
                   (KeyMap.of_list
                      [
                        ("cpu", Fix (KeyMap.of_list [ ("1500mi", empty) ]));
                        ("memory", Fix (KeyMap.of_list [ ("10Gb", empty) ]));
                      ]) );
             ]) );
      ( "user",
        Fix
          (KeyMap.of_list
             [
               ("guestId", Fix (KeyMap.of_list [ ("42", empty) ]));
               ("login", Fix (KeyMap.of_list [ ("chshersh", empty) ]));
               ("createdAt", Fix (KeyMap.of_list [ ("2024-12-31", empty) ]));
             ]) );
    ]

let edsl =
  Edsl.(
    let* _ = key_val "/" "This is a CCL document" in
    let* _ = key_val "title" "CCL Example" in
    let* _ =
      nested "database"
      @@
      let* _ = key_val "enabled" "true" in
      let* _ =
        nested "ports"
        @@
        let* _ = key_val "" "8000" in
        let* _ = key_val "" "8001" in
        let* _ = key_val "" "8002" in
        finish
      in
      let* _ =
        nested "limits"
        @@
        let* _ = key_val "cpu" "1500mi" in
        let* _ = key_val "memory" "10Gb" in
        finish
      in
      finish
    in
    let* _ = nested "user" (key_val "guestId" "42") in
    let* _ =
      nested "user"
      @@
      let* _ = key_val "login" "chshersh" in
      let* _ = key_val "createdAt" "2024-12-31" in
      finish
    in
    finish)
