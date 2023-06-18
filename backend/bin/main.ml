let exercises = (fun _ -> 
  let%lwt res = (Storage.read_exercises ()) 
  in Dream.json res)

let () =
  Dream.run 
  @@ Dream.logger
  @@ Dream.origin_referrer_check
  @@ Dream.router [

    Dream.get "/exercises" exercises

    ]