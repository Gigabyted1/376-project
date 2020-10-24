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
room(classroom_down, 'A fairly large room filled with several student desks and a project playing an eerie news clip about an mad SRU professor.').
room(bathroom_up, 'The second floor bathroom contains multiple sinks, soap and paper towel dispensers, and several stalls that can be used to hide in.').
room(classroom230, 'classroom230.').
room(classroom232, 'classroom232.').
room(conference_room , 'The conference room of the computer science department is where many students go to study, work on assignments or projects, and meet with friends. Objects may be found here left by students.').
room(lair, 'The computer science department offices once held the offices of several department faculty members, now it is the lair of a mad computer scienist.').

/* Doors - door(<room1>, <room2>). */
door(lobby, hall_down, '0').
door(hall_down, auditorium, '1').
door(hall_down, bathroom_down, '2').
door(hall_down, classroom_down, '3').
door(hall_down, stairway, '4').
door(stairway, hall_up, '5').
door(hall_up, bathroom_up, '6').
door(hall_up, classroom230, '7').
door(hall_up, classroom232, '8').
door(hall_up, conference_room, '9').
door(hall_up, lair, '10').

/* Doors aren't one-way */
:- forall(door(X,Y,Z), assert(door(Y,X,Z))).

move(Room) :-
  room_exists(Room),
  my_loc(Here), !,
  connection_exists(Here, Room), !,
  retract(my_loc(Here)),
  asserta(my_loc(Room)),
  observe, !.
  
room_exists(Room) :-
  room(Room, _).
room_exists(_) :-
  nl, write("D'oh! No such room exists."), nl, !, fail.
  
connection_exists(Here, Room) :-
  door(Here, Room, _).
connection_exists(Here, Room) :-
  nl, write("D'oh! You can't get to that room from here."), nl, !, fail.
  
observe :- 
  my_loc(Here),
  describe_room(Here), !,
  list_doors(Here), !.
  
describe_room(Here) :-
  room(Here, X, _),
  nl, write(X), nl.
  
list_doors(Here) :-
  forall(door(Here, ConnectedRoom, _), (nl, write(ConnectedRoom), nl)).

instructions :-
  nl, write("Possible commands (use regular Prolog syntax):"),
  nl, write("start: begin the adventure!"),
  nl, write("move(<room>): move to a connected room"),
  nl, write("observe: get information about your surroundings").
