type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]
type workout = exercise list [@@deriving yojson]

type workout_stored = {id: int; date: int64; username: string; workout: string} [@@deriving yojson]
type workouts_stored = workout_stored list [@@deriving yojson]

type workout_for_user = { username : string; workout : string } [@@deriving yojson]

val read_all_workouts : unit -> Yojson.Safe.t Lwt.t
val read_workouts_for_user : string -> Yojson.Safe.t Lwt.t
val add_workout : workout_for_user -> unit Lwt.t

