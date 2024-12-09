(* This is just a state monad with State being the map itself *)
type 'a t = { run_state : Model.t -> 'a * Model.t }

let run { run_state } = snd (run_state Model.empty)
let finish = { run_state = (fun state -> ((), state)) }

let add key =
  Model.
    {
      run_state =
        (fun (Fix map) ->
          let new_state = Fix (KeyMap.add key empty map) in
          ((), new_state));
    }

let zoom key nested =
  Model.
    {
      run_state =
        (fun state ->
          let a, nested_map = nested.run_state empty in
          let zoomed_state = Fix (KeyMap.singleton key nested_map) in
          let new_state = merge state zoomed_state in
          (a, new_state));
    }

let bind { run_state } f =
  {
    run_state =
      (fun state ->
        let a, new_state = run_state state in
        let { run_state } = f a in
        run_state new_state);
  }

let ( let* ) = bind
