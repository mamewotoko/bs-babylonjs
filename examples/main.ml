open Webapi
open Babylonjs

exception Not_found_error of string

let canvas_id = "renderCanvas"

let _ =
  match Dom.Document.getElementById canvas_id Dom.document with
    None -> raise (Not_found_error "canvas element is not found")
  | Some canvas ->
     let engine = Engine.(make canvas true
                            (param
                               ~preserveDrawingBuffer:true
                               ~stencil:true
                               ())) in
     let scene = Scene.make engine in
     let v =  Vector3.make 0.0 5.0 (~-.10.0) in
     let camera = FreeCamera.make "camera1" v scene in
     let _ = HemisphericLight.make "light1" (Vector3.make 0.0 1.0 1.0) scene in
     let sphere = MeshBuilder.Sphere.(create "sphere1"
                                        (param
                                           ~segments:16
                                           ~diameter:2
                                           ())
                                        scene) in
     let material = StandardMaterial.make "red" scene in
     material ## alpha #= 1.0;
     material ## diffuseColor #= (Color3.make 1.0 0. 0.);
     sphere ## material #= material;
     sphere ## position ## y #= 1.0;
     camera ## setTarget (Vector3.make 0.0 0.0 0.0);
     engine ## runRenderLoop (fun () -> scene ## render ());