module Testable = Testable

let quick : string -> (unit -> unit) -> unit Alcotest.test_case =
 fun name test -> (name, `Quick, test)
