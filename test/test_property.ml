module Model = Ccl.Model
module Extra_gen = Test_extra.Gen

let test_roundtrip =
  let pretty = Model.pretty in
  let parse = Ccl.decode in

  QCheck2.Test.make ~count:100 ~print:Extra_gen.print_test_ccl
    ~name:"[Roundtrip    ] parse ∘ pretty ≡ id" Extra_gen.test_ccl
    (fun Extra_gen.{ model = t_old; _ } ->
      let t_new = t_old |> pretty |> parse in
      match t_new with
      | Error _ -> QCheck2.assume_fail ()
      | Ok t_new -> Model.compare t_new t_old = 0)

let test_associativity =
  let gen = Extra_gen.test_ccl in
  let pp = Extra_gen.print_test_ccl in
  let gen_triple = QCheck2.Gen.triple gen gen gen in
  let print = QCheck2.Print.triple pp pp pp in

  QCheck2.Test.make ~count:100 ~print
    ~name:"[Associativity] (x ⊕ y) ⊕ z ≡ x ⊕ (y ⊕ z)" gen_triple
    (fun (x, y, z) ->
      let x = x.Extra_gen.model in
      let y = y.Extra_gen.model in
      let z = z.Extra_gen.model in
      let left = Model.merge (Model.merge x y) z in
      let right = Model.merge x (Model.merge y z) in
      Model.compare left right = 0)

let test_left_empty =
  QCheck2.Test.make ~count:5 ~print:Extra_gen.print_test_ccl
    ~name:"[Left  Empty  ] ε ⊕ x ≡ x" Extra_gen.test_ccl (fun x ->
      let x = x.Extra_gen.model in
      let result = Model.(merge empty x) in
      Model.compare x result = 0)

let test_right_empty =
  QCheck2.Test.make ~count:5 ~print:Extra_gen.print_test_ccl
    ~name:"[Right Empty  ] x ⊕ ε ≡ x" Extra_gen.test_ccl (fun x ->
      let x = x.Extra_gen.model in
      let result = Model.(merge x empty) in
      Model.compare x result = 0)

let tests =
  [
    QCheck_alcotest.to_alcotest test_roundtrip;
    QCheck_alcotest.to_alcotest test_associativity;
    QCheck_alcotest.to_alcotest test_left_empty;
    QCheck_alcotest.to_alcotest test_right_empty;
  ]
