/* Define our custom stuff */
:- dynamic my_loc/1, door/2.

my_loc(lobby).

/* Rooms - room(<name>, <desc>). */
room(lobby, 'The lobby of ATS. There are several chairs, a nice big doormat, and a variety of science-related decorations.').
room(hall_down, 'The main hallway on the first floor of ATS. It is lined with doors to various classrooms.').
room(hall_up, 'Hallway').
room(auditorium, 'Auditorium').
room(bathroom, 'Bathroom').

/* Doors - door(<room1>, <room2>). */
door(lobby, hall_down).
door(hall_down, hall_up).
door(hall_down, auditorium).
door(hall_down, bathroom).

/* Doors aren't one-way */
:- forall(door(X,Y), assert(door(Y,X))).

move(Room) :-
  room_exists(Room),
  my_loc(Here), !,
  connection_exists(Here, Room),
  retract(my_loc(Here)),
  asserta(my_loc(Room)),
  print_room_info.
  
room_exists(Room) :-
  room(Room, _).
  
room_exists(_) :-
  nl, write("D'oh! No such room exists."), nl, !, fail.
  
connection_exists(Here, Room) :-
  door(Here, Room).
  
connection_exists(Here, Room) :-
  nl, write("D'oh! You can't get to that room from here."), nl, !, fail.
  
print_room_info :- 
  my_loc(Here),
  describe_room(Here),
  list_doors(Here).
  
describe_room(Here) :-
  room(Here, X),
  nl, write(X), nl.
  
list_doors(Here) :-
  door(Here, ConnectedRoom),
  nl, write(X), nl, fail.
