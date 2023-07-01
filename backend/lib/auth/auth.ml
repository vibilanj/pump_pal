(* types *)
module type DB = Rapper_helper.CONNECTION

exception Query_failed of string

type user = { username : string; password : string } [@@deriving yojson]
type users = user list [@@deriving yojson]

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

(* migrations *)
(* let drop_table =
  [%rapper execute {sql|
          DROP TABLE IF EXISTS users;
        |sql}] ()

let () = dispatch drop_table |> Lwt_main.run *)

let ensure_table_exists =
  [%rapper
    execute
      {sql|
        CREATE TABLE IF NOT EXISTS users (
          username VARCHAR PRIMARY KEY NOT NULL,
          password VARCHAR
        );
      |sql}]
    ()

let () = dispatch ensure_table_exists |> Lwt_main.run

(* queries *)
let show_all_users () =
  let show_all =
    [%rapper
      get_many
        {sql| 
          SELECT @string{username}, @string{password}
          FROM users
        |sql}
        record_out]
      ()
  in
  let%lwt users = dispatch show_all in
  users_to_yojson users |> Lwt.return

let add_user user =
  let add =
    [%rapper
      execute
        {sql|
          INSERT INTO users
          VALUES(%string{username}, %string{password})
        |sql}
        record_in]
  in
  dispatch (add user)
