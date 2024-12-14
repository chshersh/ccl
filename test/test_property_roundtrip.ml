module Model = Ccl.Model

let test_roundtrip =
  let pretty = Model.pretty in
  let parse = Ccl.decode in

  QCheck2.Test.make ~count:100 ~print:Model.pretty ~name:"Roundtrip : parse ∘ pretty ≡ id"
    Test_extra.Gen.model_t (fun t_old ->
      let t_new = t_old |> pretty |> parse in
      match t_new with
      | Error _ -> QCheck2.assume_fail ()
      | Ok t_new -> Model.compare t_new t_old = 0)

let tests = [ QCheck_alcotest.to_alcotest test_roundtrip ]
