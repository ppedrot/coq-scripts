(** See https://coq.inria.fr/bugs/show_bug.cgi?id=4319 for updates *)

(** https://coq.inria.fr/bugs/show_bug.cgi?id=4461 *)
Require Coq.Classes.RelationClasses.
Global Arguments Coq.Classes.RelationClasses.Antisymmetric A eqA {_} _.
Global Arguments Coq.Classes.RelationClasses.symmetry {A} {R} {_} [x] [y] _.
Global Arguments Coq.Classes.RelationClasses.asymmetry {A} {R} {_} [x] [y] _ _.
Global Arguments Coq.Classes.RelationClasses.transitivity {A} {R} {_} [x] [y] [z] _ _.

(** [set (x := y)] is about 50x slower than it needs to be in Coq 8.4,
    but is about 4x faster than the alternatives in 8.5.  See
    https://coq.inria.fr/bugs/show_bug.cgi?id=3280 (comment 13) for
    more details. *)
Ltac fast_set' x y := set (x := y).
Ltac fast_set'_in x y H := set (x := y) in H.
Tactic Notation "fast_set" "(" ident(x) ":=" constr(y) ")" := fast_set' x y.
Tactic Notation "fast_set" "(" ident(x) ":=" constr(y) ")" "in" hyp(H) := fast_set'_in x y H.


Require Coq.Lists.List.
Module Export Coq.
Module Export Lists.
Module List.
Module ListNotations.
Include Coq.Lists.List.ListNotations.
Notation " [ x ; .. ; y ] " := (cons x .. (cons y nil) ..) : list_scope.
End ListNotations.
End List.
End Lists.
End Coq.
Export List.ListNotations.
