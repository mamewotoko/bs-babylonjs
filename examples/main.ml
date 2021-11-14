open Webapi
open Babylonjs

external showWorldAxis: float -> Scene.t -> unit = "showWorldAxis" [@@bs.val]

let use_video = false

exception Not_found_error of string

let pi = 2. *. asin 1.
let canvas_id = "renderCanvas"

(* TODO: use Dom.EventTarget.addEventListener *)
external addEventListener: string -> (unit -> unit) -> bool -> unit = "" [@@bs.val][@@bs.scope "document"]

let add_video scene =
     let texture = VideoTexture.make "video" "movie/deinter_mini10.mp4" scene false in
     (* let texture = VideoTexture.(createFromWebCam scene ignore (param ~maxWidth:512 ~maxHeight:512 ())) in *)
     let video_material = StandardMaterial.make "video_material" scene in
     let width = 12. in
     let height = 9. in
     let plane = MeshBuilder.Plane.(create "plane"
                                      (param
                                         ~width:width
                                         ~height:height
                                         ~updatable:true
                                         ())
                                      scene) in

     video_material ## diffuseColor #= (Color3.make 1. 1. 1.);
     video_material ## diffuseTexture #= (texture :> Texture.t);
     plane ## material #= video_material;
     plane ## position ## z #= 5.;
     plane ## position ## y #= (height /. 2.0);
     addEventListener "click" (fun _ ->
         if texture ## video ## paused then
           texture ## video ## play ()
         else
           texture ## video ## pause ()
       ) false
;;

let main _ =
  match Dom.Document.getElementById canvas_id Dom.document with
    None -> raise (Not_found_error "canvas element is not found")
  | Some canvas ->
     let engine = Engine.(make canvas true
                            (param
                               ~preserveDrawingBuffer:true
                               ~stencil:true
                               ())) in
     let scene = Scene.make engine in
     let v =  Vector3.make 0. 1. (~-.10.0) in
     (* let camera = FreeCamera.make "camera1" v scene in *)
     let camera = DeviceOrientationCamera.make "camera1" v scene in
     let _ = HemisphericLight.make "light1" (Vector3.make 0.0 10.0 (~-.5.0)) scene in
     let sphere = MeshBuilder.Sphere.(create "sphere1"
                                        (param
                                           ~segments:16
                                           ~diameter:2.
                                           ())
                                        scene) in
     let material = StandardMaterial.make "red" scene in

     scene ## clearColor #= (Color3.make 1. 1. 1.);
     material ## alpha #= 1.0;
     material ## diffuseColor #= (Color3.make 1.0 0. 0.);
     sphere ## material #= material;
     sphere ## position ## y #= 1.0;
     sphere ## position ## x #= 5.0;

     camera ## setTarget (Vector3.make 0.0 4.0 0.0);
     camera ## attachControl true;
     camera ## speed #= 0.1;
     (* camera ## position ## y #= 8.; *)

     if use_video then
         add_video scene;

     showWorldAxis 100. scene;
     engine ## runRenderLoop (fun () -> scene ## render ());
     (* Dom.EventTarget.asEventTarget Dom.document *)
;;

let _ =
  Dom.Window.addEventListener "DOMContentLoaded" main Dom.window

(* let _ =
 *   Dom.Window.addPopStateEventListener
 *     (Dom.PopStateEvent.make "resize")
 *     fun () ->  *)
