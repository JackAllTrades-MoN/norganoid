open Js_of_ocaml

type pos = float * float
type size = float * float

type t = {
  img: Dom_html.imageElement Js.t;
  frames: (pos * size) Array.t;
  idx: int;
}

type sprites = (String.t, t) Hashtbl.t

let loaded_sprites = Hashtbl.create 10

let load  (name: string) path ?(idx=0) ?(frames=[||]) k =
  let img = Dom_html.createImg Dom_html.document in
  img##.src := Js.string path;
  img##.onload := Dom_html.handler (fun _ ->
    let sprites = {img; frames; idx} in
    Hashtbl.add loaded_sprites name sprites;
    k ();
    Js._false
  )

let add_frame name frame =
  Hashtbl.find_opt loaded_sprites name
  |> Option.iter (fun sprites ->
    Hashtbl.remove loaded_sprites name;
    Hashtbl.add loaded_sprites name {sprites with frames = Array.append sprites.frames [|frame|]}
  )

let set_idx name idx =
  Hashtbl.find_opt loaded_sprites name
  |> Option.iter (fun sprites ->
    Hashtbl.remove loaded_sprites name;
    Hashtbl.add loaded_sprites name {sprites with idx}
  )

let next_idx name =
  let sprites = Hashtbl.find loaded_sprites name in
  (sprites.idx + 1) mod Array.length sprites.frames

let render ctx name x y w h =
  Hashtbl.find_opt loaded_sprites name
  |> Option.iter (fun t ->
    let (sx, sy), (sw, sh) = t.frames.(t.idx) in
    ctx##drawImage_full t.img sx sy sw sh x y w h
  )

let size_of name =
  let t = Hashtbl.find loaded_sprites name in
  let (_, size) = t.frames.(t.idx) in
  size
