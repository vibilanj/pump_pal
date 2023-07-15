type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]
type workout = exercise list [@@deriving yojson]
type workout_stored = {id: int; date: string; username: string; workout: string} [@@deriving yojson]
type workouts_stored = workout_stored list [@@deriving yojson]

val read_all_workouts : unit -> Yojson.Safe.t Lwt.t

