module type DB

val dispatch: (Caqti_lwt.connection -> ('a, [< Caqti_error.t > `Connect_failed `Connect_rejected `Post_connect]) result Lwt.t) -> 'a Lwt.t