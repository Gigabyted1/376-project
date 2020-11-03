likes(emma, coffee).
not(likes(emma, spider)).

family(Person) :-
  forall(parent(Person, Parent), write(Parent),
  forall(sibling(Person, Sibling), write(Sibling)).

grandparent(Person1, Person2) :-
  parent(Person1, Parent),
  parent(Parent, Person2).
  
likes(emma, coffee).
not(likes(emma, spiders)).
door(bedroom, hallway).
team(bad(‘The Pittsburgh Steelers’)).

mother(alicia, rebecca).
father(alicia, joseph).
parents(alicia, rebecca, joseph).

