open Js_of_ocaml

module In_canvas: sig
  type 'a t

  val use_canvas : (Dom_html.canvasElement Js.t) t
  val use_context : (Dom_html.canvasRenderingContext2D Js.t) t
  val use_canvas_size : (int * int) t

  (* Functor *)
  val fmap : ('a -> 'b) -> 'a t -> 'b t
  val (<$) : 'a -> 'b t -> 'a t

  (* Applicative *)
  val pure : 'a -> 'a t
  val (<*>) : ('a -> 'b) t -> 'a t -> 'b t
  val lift_a2: ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
  val ( *> ) : 'a t -> 'b t -> 'b t
  val ( <* ) : 'a t -> 'b t -> 'a t

  (* Monad *)
  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
  val ( >> ) : 'a t -> 'b t -> 'b t
  val return : 'a -> 'a t

  (* syntax sugars *)
  val (<$>) : ('a -> 'b) -> 'a t -> 'b t
  val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
  val ( and+ ) : 'a t -> 'b t -> ('a * 'b) t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t

  val run : string -> unit t -> unit
end = struct
  type global = {
    parent: Dom_html.canvasElement Js.t;
    context: Dom_html.canvasRenderingContext2D Js.t;
  }

  type 'a t = global -> 'a

  let use_canvas = (fun global -> global.parent)
  let use_context = (fun global -> global.context)
  let use_canvas_size = (fun _global -> 800, 600)

  let id x = x
  let const x _ = x

  (* Functor *)
  let fmap f t = (fun global -> f (t global))
  let (<$) x = x |> const |> fmap

  (* Applicative *)
  let pure a = (fun _ -> a)
  let (<*>) (f: ('a -> 'b) t) (t: 'a t): 'b t = (fun global -> (f global) (t global))
  let lift_a2 (f: 'a -> 'b -> 'c) (x: 'a t) = (<*>) (fmap f x)
  let ( *> ) a b = (id <$ a) <*> b
  let ( <* ) a b = lift_a2 const a b

  (* Monad *)
  let ( >>= ) t f = (fun global -> f (t global) global)
  let ( >> ) m k = m >>= (fun _ -> k)
  let return = pure

  let (<$>) = fmap
  let ( let+ ) t f = fmap f t
  let ( and+ ) a b = a >>= (fun a -> b >>= (fun b -> return (a,b)))
  let ( let* ) = ( >>= )

  let run canvas_id t =
    match Dom_html.getElementById_coerce canvas_id Dom_html.CoerceTo.canvas with
      | None -> System.fail (Printf.sprintf "Fatal error: Canvas (%s) did not exist" canvas_id)
      | Some canvas ->
        let context = canvas##getContext Dom_html._2d_ in
        let global = {parent=canvas; context} in
        Dom_html.addEventListener canvas (Dom_html.Event.mousemove) (Mousemove.handler) Js._false |> ignore;
        Dom_html.addEventListener canvas (Dom_html.Event.mouseup) (Mouseup.handler) Js._false |> ignore;
        ignore @@ Dom_html.window##setInterval (Js.wrap_callback (fun _ -> t global)) 15.
end
