/* Rooms - room(<name>, <desc>). */
room(lobby, '').
room(hall_down, '').

/* Doors - door(<room1>, <room2>). */
door(lobby, hall_down).

/* Doors aren't one-way */
:- forall(door(X,Y), assert(door(Y,X))).

move(Room) :-
  room_exists(Room),
  my_loc(Here) !,
  connection_exists(Here, Room),
  retract(my_loc(Here)),
  asserta(my_loc(Room)),
  print_room_info.
  
room_exists(Room) :-
  room(Room, _).
  
room_exists(_) :-
  nl, print("D'oh! No such room exists."), nl, !, fail.
  
connection_exists(Here, Room) :-
  door(Here, Room).
  
connection_exists(Here, _) :-
  nl, print("D'oh! You can't get to that room from here."), nl, !, fail.
