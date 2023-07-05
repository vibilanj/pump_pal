module type DB = Rapper_helper.CONNECTION

exception Query_failed of string
(* database setup *)
let connection_url = "postgresql://pumppal:pumppal@localhost:5432/pumppal"

let pool =
  match Caqti_lwt.connect_pool ~max_size:10 (Uri.of_string connection_url) with
  | Ok pool -> pool
  | Error error -> failwith (Caqti_error.show error)

let dispatch f =
  let%lwt result = Caqti_lwt.Pool.use f pool in
  match result with
  | Ok data -> Lwt.return data
  | Error error -> Lwt.fail (Query_failed (Caqti_error.show error))