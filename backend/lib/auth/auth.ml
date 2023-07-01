module type DB = Rapper_helper.CONNECTION

exception Query_failed of string

type user = { username : string; password : string } [@@deriving yojson]

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
  in let%lwt users = dispatch show_all in 
  users 
  |> List.map (fun user -> Yojson.Safe.to_string (user_to_yojson user))
  |> String.concat "\n"
  |> Lwt.return 
  (* TODO: fix this to json *)

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