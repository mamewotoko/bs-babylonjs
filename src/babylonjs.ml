
open Webapi
open Canvas

module rec Vector3:
sig
  class type _vector3 =
    object
      method x: float [@@bs.set] [@@bs.get]
      method y: float [@@bs.set] [@@bs.get]
      method z: float [@@bs.set] [@@bs.get]
    end [@bs]
  type t = _vector3 Js.t
  (* use @bs.module *)
  external zero: unit -> t = "BabylonJs.MeshBuilder.CreateSphere" [@@bs.val]
  external make: float -> float -> float -> t = "Vector3" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = Vector3

module rec Color3:
sig
  class type _color3 =
    object
      method r: float [@@bs.set] [@@bs.get]
      method g: float [@@bs.set] [@@bs.get]
      method b: float [@@bs.set] [@@bs.get]
      (* method add: t -> t *)
    end [@bs]
  type t = _color3 Js.t
  external make: float -> float -> float -> t = "Color3" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]

end = Color3

module rec Engine:
  sig
    class type _engine =
      object
        method runRenderLoop: (unit -> unit) -> unit
        method resize: unit -> unit
        method endFrame: unit -> unit
      end [@bs]
  type param = {
      preserveDrawingBuffer: bool [@bs.optional];
      stencil: bool [@bs.optional];
    } [@@bs.deriving abstract]
  type t = _engine Js.t
  external make: Dom.Element.t (* canvas *)
                 -> bool (* antialias *)
                 -> param
                 -> t = "Engine" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = Engine

module rec Scene:
  sig
    class type _scene =
      object
        method render: unit -> unit
      end [@bs]
    type t = _scene Js.t
    external make: Engine.t
                   -> t = "Scene" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = Scene

module rec FreeCamera:
sig
  class type _freecamera =
    object
      method attachControl: bool -> unit
      method setTarget: Vector3.t -> unit
    end [@bs]
  type t = _freecamera Js.t
  external make: string -> Vector3.t -> Scene.t -> t = "FreeCamera" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = FreeCamera

module rec DeviceOrientationCamera:
sig
  class type _camera =
    object
      method attachControl: bool -> unit
      method setTarget: Vector3.t -> unit
      method speed: float [@@bs.set] [@@bs.get]
    end [@bs]
  type t = _camera Js.t
  external make: string -> Vector3.t -> Scene.t -> t = "DeviceOrientationCamera" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = DeviceOrientationCamera

module rec DynamicTexture:
sig
  class type _dynamictexture =
    object
      method getCotext: unit -> Canvas2d.t
      method hasAlpha: bool [@@bs.set] [@@bs.get]
      method drawText: string -> float -> float -> string (* font *) -> Color3.t -> string -> bool -> unit
    end [@bs]
  type t = _dynamictexture Js.t
  type param = {
      width: float [@bs.optional];
      height: float [@bs.optional];
    } [@@bs.deriving abstract]
  external make: string -> param -> Scene.t -> t = "DynamicTexture" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = DynamicTexture

module rec HemisphericLight:
sig
  type t
  external make: string -> Vector3.t -> Scene.t -> t = "HemisphericLight" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = HemisphericLight

(* material *)
module rec StandardMaterial:
sig
  class type _standard_material =
    object
      method alpha: float [@@bs.set] [@@bs.get]
      method diffuseColor: Color3.t [@@bs.set] [@@bs.get]
    end [@bs]
  type t = _standard_material Js.t
  external make: string -> Scene.t -> t = "StandardMaterial" [@@bs.new] [@@bs.module "babylonjs/babylon.js"]
end = StandardMaterial

(* mesh *)
module rec MeshBuilder:
sig
  (* todo: check document and type*)
  class type _mesh =
    object
      method position: Vector3.t [@@bs.get]
      (* TODO: modify type to material*)
      method material: StandardMaterial.t [@@bs.set] [@@bs.get]
    end [@bs]
  type t = _mesh Js.t

  (* separate module to define params for each shape *)
  module Sphere:
  sig
    type param = {
        segments: int [@bs.optional];
        diameter: float [@bs.optional];
        (* sideOrientation: *)
      } [@@bs.deriving abstract]

    (* TODO add "MeshBuilder" as submodule *)
    (* TODO ... do not use BabylonJS... *)
    external create: string -> param -> Scene.t -> t = "BabylonJs.MeshBuilder.CreateSphere" [@@bs.val]
  end

  module Lines:
  sig
    type param = {
        points: Vector3.t Js.Array.t
      } [@@bs.deriving abstract]
    external create: string -> param -> Scene.t -> t = "BabylonJs.MeshBuilder.CreateLines" [@@bs.val]
  end

  module Plane:
  sig
    type param = {
        size: float [@bs.optional];
        width: float [@bs.optional];
        height: float [@bs.optional];
        updatable: bool [@bs.optional];
        (* sizeOrientation: float [@bs.optional]; *)
        (* sourcePlane: float [@bs.optional]; *)
        (* frontUVs: float [@bs.optional]; *)
        (* backUVs: float [@bs.optional]; *)
      } [@@bs.deriving abstract]
    external create: string -> param -> Scene.t -> t = "BabylonJs.MeshBuilder.CreatePlane"  [@@bs.val]
  end
end = MeshBuilder
