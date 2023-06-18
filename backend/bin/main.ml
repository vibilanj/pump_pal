let exercises_handler _ = 
  Storage.read_exercises () |> Lwt_main.run |> Dream.json


let () =
  Dream.run 
  @@ Dream.logger
  @@ Dream.origin_referrer_check
  @@ Dream.router [

    Dream.get "/exercises" exercises_handler

    ]