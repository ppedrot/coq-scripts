(** See https://coq.inria.fr/bugs/show_bug.cgi?id=4319 for updates *)

Require Coq.Program.Tactics.
Ltac rapply term := Coq.Program.Tactics.rapply term; shelve_unifiable.

(** https://coq.inria.fr/bugs/show_bug.cgi?id=4461 *)
Require Coq.Classes.RelationClasses.
Global Arguments Antisymmetric A {eqA} _ _.
Global Arguments symmetry {A} {R} {_} [x] [y] _.
Global Arguments asymmetry {A} {R} {_} [x] [y] _ _.
Global Arguments transitivity {A} {R} {_} [x] [y] [z] _ _.
