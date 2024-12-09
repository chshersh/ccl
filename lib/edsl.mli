(** A module to provide nice eDSL for constructing CCL maps manually. Useful for
testing or configuring some hardcoded values by circumventing parsing. *)

(** Abstract type for a temporary value containing the description of producing
[Model.t]. *)
type 'a t

(** Create [Model.t] from [t]. This function never fails. However, if [t]
constructed in a such way that existing values are overriden, they'll be
overriden. *)
val run : _ t -> Model.t

(** Action that finishes constructing the map. *)
val finish : unit t

(** Add a new key to the existing Map. *)
val add : string -> unit t

(** Create a nested map. *)
val zoom : string -> 'a t -> 'a t

(** Monadic binding operator to compose value of [t]. *)
val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
