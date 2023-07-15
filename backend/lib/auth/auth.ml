type user = { username : string; password : string } [@@deriving yojson]
type users = user list [@@deriving yojson]

(* migrations *)
let drop_table =
  [%rapper execute {sql|
          DROP TABLE IF EXISTS users;
        |sql}] ()

let () = Db.dispatch drop_table |> Lwt_main.run

let ensure_table_exists =
  [%rapper
    execute
      {sql|
        CREATE TABLE IF NOT EXISTS users (
          username VARCHAR PRIMARY KEY NOT NULL,
          password VARCHAR NOT NULL
        );
      |sql}]
    ()

let () = Db.dispatch ensure_table_exists |> Lwt_main.run

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
  let%lwt users = Db.dispatch show_all in
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
  Db.dispatch (add user)

(* insert testing data *)
(* let insert_user1 =
  [%rapper
  execute
    {sql|
      INSERT INTO users
      VALUES('jerri', 'jerri123')
    |sql}
    ] ()

let insert_user2 =
  [%rapper
  execute
    {sql|
      INSERT INTO users
      VALUES('vibilan', 'vibilan123')
    |sql}
    ] ()
    
let () = Db.dispatch insert_user1 |> Lwt_main.run
let () = Db.dispatch insert_user2 |> Lwt_main.run *)