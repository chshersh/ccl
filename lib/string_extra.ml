let of_chars chars = chars |> List.to_seq |> String.of_seq
let of_chars_trimmed chars = chars |> of_chars |> String.trim

let rtrim str =
  let len = String.length str in
  let last_index = len - 1 in

  let rec find_last_non_space i =
    if i < 0 then -1
    else
      match str.[i] with
      | ' ' | '\t' | '\n' -> find_last_non_space (i - 1)
      | _ -> i
  in

  let last_non_space = find_last_non_space (len - 1) in
  if last_non_space = last_index then str
  else String.sub str 0 (last_non_space + 1)
