type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]
type workout = exercise list [@@deriving yojson]
type workout_stored = {id: int; date: string; username: string; workout: string} [@@deriving yojson]
type workouts_stored = workout_stored list [@@deriving yojson]

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
          date VARCHAR NOT NULL,
          username VARCHAR NOT NULL,
          workout JSON NOT NULL
        );
      |sql}]
    ()

let () = Db.dispatch ensure_table_exists |> Lwt_main.run

(* queries *)
let read_all_workouts () =
  let show_all =
    [%rapper
      get_many
        {sql| 
          SELECT @int{id}, @string{date}, @string{username}, @string{workout}
          FROM workouts
        |sql}
        record_out]
      ()
  in
  let%lwt workouts = Db.dispatch show_all in
  workouts_stored_to_yojson workouts |> Lwt.return

let insert_workout =
    [%rapper
    execute
      {sql|
        INSERT INTO workouts
        VALUES(default, '2022-01-01', 'jerri', '[{"name":"bench","sets":[{"weight":60,"reps":10},{"weight":70,"reps":10},{"weight":80,"reps":10}]},{"name":"squat","sets":[{"weight":80,"reps":10},{"weight":100,"reps":10},{"weight":120,"reps":10}]},{"name":"deadlift","sets":[{"weight":120,"reps":10},{"weight":150,"reps":10},{"weight":150,"reps":8}]}]')
      |sql}
      ] ()
      
let () = Db.dispatch insert_workout |> Lwt_main.run