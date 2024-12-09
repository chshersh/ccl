(* This is just a state monad with State being the map itself *)
type 'a t = { run_state : Model.t -> 'a * Model.t }

let run { run_state } = snd (run_state Model.empty)
let finish = { run_state = (fun state -> ((), state)) }

let key key =
  Model.
    {
      run_state =
        (fun state ->
          let new_map = Fix (KeyMap.singleton key empty) in
          let new_state = merge new_map state in
          ((), new_state));
    }

let nested key nested =
  Model.
    {
      run_state =
        (fun state ->
          let a, nested_map = nested.run_state empty in
          let zoomed_state = Fix (KeyMap.singleton key nested_map) in
          let new_state = merge state zoomed_state in
          (a, new_state));
    }

let key_val k v = nested k (key v)

let bind { run_state } f =
  {
    run_state =
      (fun state ->
        let a, new_state = run_state state in
        let { run_state } = f a in
        run_state new_state);
  }

let ( let* ) = bind
