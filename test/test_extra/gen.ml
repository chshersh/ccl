module Model = Ccl.Model
module Parser = Ccl.Parser
module Gen = QCheck2.Gen

let char_small = Gen.char_range 'a' 'c'
let key = Gen.(string_size ~gen:char_small (int_bound 3))
let value = Gen.(string_size ~gen:char_small (int_bound 3))

let key_val =
  Gen.(
    let* key = key in
    let* value = value in
    return Parser.{ key; value })

let config = Gen.(list_size (int_bound 100) key_val)

let model_t =
  Gen.(
    let* config = config in
    return (Model.fix config))
