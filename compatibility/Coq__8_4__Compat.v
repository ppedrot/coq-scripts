Ltac shelve_unifiable := idtac.
Ltac shelve := idtac.

(** [set (x := y)] is about 50x slower than it needs to be in Coq 8.4,
    but is about 4x faster than the alternatives in 8.5.  See
    https://coq.inria.fr/bugs/show_bug.cgi?id=3280 (comment 13) for
    more details. *)
Ltac fast_set' x y :=
  pose y as x;
  first [ progress change y with x
        | progress repeat match goal with
                          | [ |- appcontext G[?e] ]
                            => constr_eq y e;
                               let G' := context G[x] in
                               change G'
                          end ].
Ltac fast_set'_in x y H :=
  pose y as x;
  first [ progress change y with x in H
        | progress repeat match type of H with
                          | appcontext G[?e]
                            => constr_eq y e;
                               let G' := context G[x] in
                               change G' in H
                          end ].
Tactic Notation "fast_set" "(" ident(x) ":=" constr(y) ")" := fast_set' x y.
Tactic Notation "fast_set" "(" ident(x) ":=" constr(y) ")" "in" hyp(H) := fast_set'_in x y H.

(** Add Coq 8.5 notations, so that we don't accidentally make use of Coq 8.4-only notations *)
Require Coq.Lists.List.
Require Coq.Vectors.VectorDef.
Module Export Coq.
Module Export Lists.
Module List.
Module ListNotations.
Export Coq.Lists.List.ListNotations.
Notation " [ x ; y ; .. ; z ] " := (cons x (cons y .. (cons z nil) ..)) : list_scope.
End ListNotations.
End List.
End Lists.
Module Export Vectors.
Module VectorDef.
Module VectorNotations.
Export Coq.Vectors.VectorDef.VectorNotations.
Notation " [ x ; y ; .. ; z ] " := (VectorDef.cons _ x _ (VectorDef.cons _ y _ .. (VectorDef.cons _ z _ (VectorDef.nil _)) ..)) : vector_scope.
End VectorNotations.
End VectorDef.
End Vectors.
End Coq.
Export Lists.List.ListNotations.
