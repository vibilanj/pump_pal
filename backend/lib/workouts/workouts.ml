type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]
type workout = exercise list [@@deriving yojson]

(* migrations *)
let drop_table =
  [%rapper execute {sql|
          DROP TABLE IF EXISTS workouts;
        |sql}] ()

let () = Db.dispatch drop_table |> Lwt_main.run

let ensure_table_exists =
  [%rapper
    execute
      {sql|
        CREATE TABLE IF NOT EXISTS workouts (
          id SERIAL PRIMARY KEY NOT NULL,
          date BIGINT NOT NULL,
          username VARCHAR NOT NULL,
          workout JSON NOT NULL
        );
      |sql}]
    ()

let () = Db.dispatch ensure_table_exists |> Lwt_main.run

(* read queries *)
type workout_from_db = {id: int; date: int64; username: string; workout: string} [@@deriving yojson]
type workouts_from_db = workout_from_db list [@@deriving yojson]

let read_all_workouts () =
  let read_all =
    [%rapper
      get_many
        {sql| 
          SELECT @int{id}, @int64{date}, @string{username}, @string{workout}
          FROM workouts
        |sql}
        record_out]
      ()
  in
  let%lwt workouts = Db.dispatch read_all in
  workouts_from_db_to_yojson workouts |> Lwt.return


type read_workouts_for_user_request = { username : string }
let read_workouts_for_user username =
  let read_for_user =
    [%rapper
      get_many
        {sql| 
          SELECT @int{id}, @int64{date}, @string{username}, @string{workout}
          FROM workouts
          WHERE username = %string{username} 
        |sql}
        record_in record_out]
  in
  let%lwt workouts = Db.dispatch (read_for_user { username }) in
  workouts_from_db_to_yojson workouts |> Lwt.return

(* write queries *)
type workout_to_db = { time : int64; username : string; workout : string }
type add_workout_request = { username : string; workout : string } [@@deriving yojson]

let add_workout {username; workout} =
  let time = Int64.of_float @@ Unix.time () in
  let workout_added = { time; username ; workout } in
  let add = 
    [%rapper
      execute
        {sql|
          INSERT INTO workouts
          VALUES(default, %int64{time}, %string{username}, %string{workout})
        |sql}
        record_in]
  in
  Db.dispatch (add workout_added)
