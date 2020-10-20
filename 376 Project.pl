/* Define our custom stuff */
:- dynamic my_loc/1, door/2.

my_loc(lobby).

/* Rooms - room(<name>, <desc>). */
room(lobby, 'The lobby of ATS. There are several chairs, a nice big doormat, and a variety of science-related decorations.').
room(hall_down, 'The main hallway on the first floor of ATS. It is lined with doors to various classrooms.').
room(hall_up, 'The second floor hallway is home to the computer science department of SRU, beware of the robotic creatures that dwell there.').
room (stairway, 'The staircase is how students maneuver from the floor to floor of ATS.')
room(auditorium, 'The aduditorium of ATS is one of the largest rooms in the building and can hold large class sizes due to its ample seating. Due to the number of students that may use the room throughout the day, objects may be left in the room by them that could assit you in the game.').
room(bathroom_down, 'The bathroom of the first floor contains multiple sinks, soap and paper towel dispensers, and several stalls that can be used to hide in.').
room(classroom_down, 'classroom_down.').
room(bathroom_up, 'The second floor bathroom contains multiple sinks, soap and paper towel dispensers, and several stalls that can be used to hide in.').
room(classroom230, 'classroom230.').
room(classroom232, 'classroom232.').
room(conference_room , 'The conference room of the computer science department is where many students go to study, work on assignments or projects, and meet with friends. Objects may be found here left by students.').
room(lair, 'The computer science department offices once held the offices of several department faculty members, now it is the lair of a mad computer scienist.').

/* Doors - door(<room1>, <room2>). */
door(lobby, hall_down).
door(hall_down, auditorium).
door(hall_down, bathroom_down).
door(hall_down, classroom_down).
door(hall_down, stairway).
door(stairway, hall_up).
door(hall_up, bathroom_up).
door(hall_up, classroom230).
door(hall_up, classroom232).
door(hall_up, conference_room).
door(hall_up, lair).

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
