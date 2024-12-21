module Model = Model
module Parser = Parser

let read filename = In_channel.with_open_bin filename In_channel.input_all
let decode str = str |> Parser.parse |> Result.map Model.fix
let decode_file path = path |> read |> decode
