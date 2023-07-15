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

let workouts_for_user request =
  let username = Dream.param request "username" in
  let%lwt res = Workouts.read_workouts_for_user username in
  Dream.json @@ Yojson.Safe.to_string res

let add_workout request = 
  let%lwt body = Dream.body request in
  let message =
    let input_message =
      body |> Yojson.Safe.from_string |> Workouts.add_workout_request_of_yojson
    in
    match input_message with
    | Ok message -> message
    | Error error -> raise (Invalid_argument error)
  in
  let%lwt () = Workouts.add_workout message in
  Dream.respond ~status:`OK "Added Workout"

let () =
  Dream.run 
  @@ Dream.logger 
  (* @@ Dream.origin_referrer_check *)
  @@ Dream.router [
    Dream.get "/exercises" exercises;
    Dream.get "/users" users;
    Dream.post "/users" add_user;
    Dream.get "/workouts" workouts;
    Dream.get "/workouts/:username" workouts_for_user;
    Dream.post "/workouts" add_workout;
  ]
