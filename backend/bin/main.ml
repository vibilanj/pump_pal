let () =
  Dream.run 
  @@ Dream.logger
  @@ Dream.origin_referrer_check
  @@ Dream.router [

    Dream.get "/exercises" (fun _ -> 
      (* Dream.json "[{\"exercise\":\"bench\",\"sets\":[{\"weight\":60,\"reps\":10},{\"weight\":70,\"reps\":10},{\"weight\":80,\"reps\":10}]},{\"exercise\":\"squat\",\"sets\":[{\"weight\":80,\"reps\":10},{\"weight\":100,\"reps\":10},{\"weight\":120,\"reps\":10}]},{\"exercise\":\"deadlift\",\"sets\":[{\"weight\":120,\"reps\":10},{\"weight\":150,\"reps\":10},{\"weight\":150,\"reps\":8}]}]" *)
      Dream.json (Storage.read_exercises ())
      )  
  
  ]
