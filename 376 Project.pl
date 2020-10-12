/* Rooms - room(<name>, <desc>). */
room(lobby, '').
room(hall_down, '').

/* Doors - door(<room1>, <room2>). */
door(lobby, hall_down).

/* Doors aren't one-way */
:- forall(door(X,Y), assert(door(Y,X))).

move(Room) :-
  my_loc(Here),
  door(Here, Room),
  retract(my_loc(Here)),
  assert(my_loc(Room))!.
  
move(_) :-