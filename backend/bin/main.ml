let exercises _ =
  let%lwt res = Storage.read_exercises () in
  Dream.json res

let users _ =
  let%lwt res = Auth.show_all_users () in
  Dream.json @@ Yojson.Safe.to_string res

let add_user request =
  let%lwt body = Dream.body request in
  let message =
    let input_message =
      body |> Yojson.Safe.from_string |> Auth.user_of_yojson
    in
    match input_message with
    | Ok message -> message
    | Error error -> raise (Invalid_argument error)
  in
  let%lwt () = Auth.add_user message in
  Dream.respond ~status:`OK "Added User"

  let workouts _ =
    let%lwt res = Workouts.read_all_workouts () in
    Dream.json @@ Yojson.Safe.to_string res

let () =
  Dream.run 
  @@ Dream.logger 
  @@ Dream.origin_referrer_check
  @@ Dream.router [
    Dream.get "/exercises" exercises;
    Dream.get "/users" users;
    Dream.post "/users" add_user;
    Dream.get "/workouts" workouts;
  ]
