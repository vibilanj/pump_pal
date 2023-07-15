type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]
type workout = exercise list [@@deriving yojson]

(* read queries *)
type workout_from_db = {id: int; date: int64; username: string; workout: string} [@@deriving yojson]
type workouts_from_db = workout_from_db list [@@deriving yojson]
val read_all_workouts : unit -> Yojson.Safe.t Lwt.t
val read_workouts_for_user : string -> Yojson.Safe.t Lwt.t

(* write queries *)
type workout_to_db = { time : int64; username : string; workout : string }
type add_workout_request = { username : string; workout : string } [@@deriving yojson]
val add_workout : add_workout_request -> unit Lwt.t


