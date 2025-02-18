(* simple queries for ccl *)

(* compatibility with ocaml.5.1 *)
exception Index_found of int
let array_find_index predicate arr =
  try
    for idx = 0 to Array.length arr - 1 do
      if predicate (Array.get arr idx) then raise (Index_found idx)
    done;
    None
  with
    | Index_found idx -> Some idx

module Params
: sig
  val files : string Seq.t
  val queries : string list list
end
= struct
  let files, queries =
    match Sys.argv with
    | [| name; "--help" |] ->
        Format.printf
          "%s [file [file ..]] <query>\n\
           %s [file [file ..]] -- [query [query ..]]\n\
           Query values in CCL files.\n\
           Queries are '='-separated list of keys."
          name name;
        exit 0
    | [| _ |] ->
      (Seq.return "/dev/stdin", [[]])
    | [| _; query |] ->
      let query = String.split_on_char '=' query in
      (Seq.return "/dev/stdin", [query])
    | _ -> match array_find_index (String.equal "--") Sys.argv with
      | None ->
        let files = Array.to_seq (Array.sub Sys.argv 1 (Array.length Sys.argv - 2)) in
        let query = String.split_on_char '=' Sys.argv.(Array.length Sys.argv - 1) in
        (files, [query])
      | Some i ->
        let files = Array.to_seq (Array.sub Sys.argv 1 (i - 1)) in
        let queries =
          if i = Array.length Sys.argv - 1 then
            (* no queries: default query is print all *)
            [[]]
          else
            Array.sub Sys.argv (i + 1) (Array.length Sys.argv - i - 1)
            |> Array.to_list
            |> List.map (String.split_on_char '=')
        in
        (files, queries)
end

let load files =
  files
  |> Seq.map Ccl.decode_file
  |> Seq.map Result.get_ok
  |> Seq.fold_left Ccl.Model.merge Ccl.Model.empty

let rec query keys ccl =
  match keys with
  | [] -> ccl
  | key :: keys ->
      let (Ccl.Model.Fix ccl) = ccl in
      match Ccl.Model.KeyMap.find_opt key ccl with
      | None -> raise Not_found
      | Some ccl -> query keys ccl

let () =
  let ccl = load Params.files in
  List.iter
    (fun q ->
      ccl
      |> query q
      |> Ccl.Model.pretty
      |> print_endline)
    Params.queries
