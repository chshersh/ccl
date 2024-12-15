module Model = Ccl.Model
module Extra_gen = Test_extra.Gen

let test_roundtrip =
  let pretty = Model.pretty in
  let parse = Ccl.decode in

  QCheck2.Test.make ~count:100 ~print:Extra_gen.print_test_ccl
    ~name:"[Roundtrip] parse ∘ pretty ≡ id" Extra_gen.test_ccl
    (fun Extra_gen.{ model = t_old; _ } ->
      let t_new = t_old |> pretty |> parse in
      match t_new with
      | Error _ -> QCheck2.assume_fail ()
      | Ok t_new -> Model.compare t_new t_old = 0)

let tests = [ QCheck_alcotest.to_alcotest test_roundtrip ]
