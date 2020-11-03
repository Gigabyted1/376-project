likes(emma, coffee).
not(likes(emma, spider)).

family(Person) :-
  mother(Person, Mother),
  nl, write(Mother),
  father(Person, Father),
  nl, write(Father),
  forall(sibling(Person, Sibling), write(Sibling)).
