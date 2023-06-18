type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]

let json_file = "exercises.json"

(* let read_exercises () =
   Lwt_io.with_file ~mode:Input json_file (fun input_chan ->
       let%lwt exercises_string =
         Lwt_io.read_lines input_chan |> Lwt_stream.to_list
       in
       let exercises_json =
         Yojson.Safe.from_string (String.concat "\n" exercises_string)
       in
       match [%of_yojson: exercise list] exercises_json with
       | Ok exercises -> Lwt.return exercises
       | Error error -> raise (Invalid_argument error)) *)

let read_exercises () = 
  Lwt_io.with_file ~mode:Input json_file (fun input_chan ->
      let%lwt exercises_string_list =
        Lwt_io.read_lines input_chan |> Lwt_stream.to_list
      in
      let exercises_string =
        String.concat "\n" exercises_string_list
      in Lwt.return exercises_string)
