type user = { username : string; password : string } [@@deriving yojson]

exception Query_failed of string

val show_all_users : unit -> string Lwt.t

val add_user : user -> unit Lwt.t