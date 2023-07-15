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

(* queries *)
type workout_stored = {id: int; date: int64; username: string; workout: string} [@@deriving yojson]
type workouts_stored = workout_stored list [@@deriving yojson]

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
  workouts_stored_to_yojson workouts |> Lwt.return


type user = { username : string }
let read_workouts_for_user user =
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
  let%lwt workouts = Db.dispatch (read_for_user  { username = user }) in
  workouts_stored_to_yojson workouts |> Lwt.return

type workout_added = { time : int64; username : string; workout : string }
type workout_for_user = { username : string; workout : string } [@@deriving yojson]

let add_workout workout_for_user =
  let time = Int64.of_float @@ Unix.time () in
  let workout_added = { time = time; username = workout_for_user.username ; workout = workout_for_user.workout } in
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
