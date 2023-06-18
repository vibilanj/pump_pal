type set = { weight : float; reps : int } [@@deriving yojson]
type exercise = { name : string; sets : set list } [@@deriving yojson]

val read_exercises : unit -> string Lwt.t
