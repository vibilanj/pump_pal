let count = ref 0

let count_requests (inner_handler: Dream.handler) (request: Dream.request) : Dream.response Lwt.t =
  count := !count + 1;
  inner_handler request

let () =
  Dream.run 
  @@ Dream.logger
  @@ count_requests
  @@ Dream.router [
         Dream.get "/" (fun _ 
          -> Dream.html (Printf.sprintf "Saw %i request(s)!" !count));
       ]