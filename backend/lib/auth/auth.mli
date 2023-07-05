type user = { username : string; password : string } [@@deriving yojson]
type users = user list [@@deriving yojson]

val show_all_users : unit -> Yojson.Safe.t Lwt.t

val add_user : user -> unit Lwt.t