/* Define our custom stuff */
:- dynamic my_loc/1, door/2, in_bag/2.

/* Rooms - room(<name>, <desc>). */
room(lobby, 'The lobby of ATS. There are several chairs, a nice big doormat, and a variety of science-related decorations.').
room(hall_down, 'The main hallway on the first floor of ATS. It is lined with doors to various classrooms.').
room(hall_up, 'The second floor hallway is home to the computer science department of SRU, beware of the robotic creatures that dwell there.').
room(stairway, 'The staircase is how students maneuver from floor to floor of ATS.').
room(auditorium, 'The auditorium of ATS is one of the largest rooms in the building and can hold large class sizes due to its ample seating. Due to the number of students that may use the room throughout the day, objects may be left in the room by them that could assist you in the game.').
room(bathroom_down, 'The bathroom of the first floor contains multiple sinks, soap and paper towel dispensers, and several stalls that can be used to hide in.').
room(classroom_down, 'A fairly large room filled with several student desks and a project playing an eerie news clip about an mad SRU professor.').
room(bathroom_up, 'The second floor bathroom contains multiple sinks, soap and paper towel dispensers, and several stalls that can be used to hide in.').
room(classroom230, 'One of the many computer science department classrooms, look around there may be objects that will help you against an adversaries that you may come against.').
room(classroom232, 'One of the many computer science department classrooms, look around there may be objects that will help you against an adversaries that you may come against.').
room(conference_room , 'The conference room of the computer science department is where many students go to study, work on assignments or projects, and meet with friends. Objects may be found here left by students.').
room(lair, 'The computer science department offices once held the offices of several department faculty members. Now it is the lair of a mad computer scientist.').

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

/* Furniture - furn(<furn_name>, <location>, <amount>). */
furn('Dinosaur Statue', lobby, 2).
furn('Bookcase', classroom230, 1).
furn('Bench', hall_up, 2).
furn('Functional PC', classroom232, 5).
furn('Broken PC', classroom232, 10).
furn('White Board', classroom_down, 3).
furn('Table', conference_room, 1).


/* Items - item(<item_name>, <description>, (<location-room>, <location-furniture>, <which-furniture>)). */
item('Used chewing gum', 'It's chewing gum', (lobby, 'Dinosaur Statue', 1)).
item('Coffee Maker', 'Eveyone likes coffee, maybe even a mad professor?', (conference_room, 'Table', 1)).


% These are just test items for defeating the boss, feel free to name them whatever fits with the story. I think them being Javascript related would be hilarious and perfect
% Also, we should have each of the items be hidden behind either a puzzle or an enemy that also requires some item to defeat them.

item("'JavaScript: The Definitive Guide' by David Flanagan", "A book with a somewhat disturbing aura... You feel a sense of dread just looking upon it.", (classroom230, 'Bookcase', 1)).
item('Laptop', "A personal laptop that looks to be left in haste by a fleeing student. It still works!", (hall_up, 'Bench', 1)).
item('USB Flash Drive', "A standard 16GB flash drive. A particular professor was crazy about these...", (classroom232, 'Functional PC', 4)).

/* Doors aren't one-way */
:- forall(door(X,Y,Z), assert(door(Y,X,Z))).

% ----- Handles moving throughout the map ----- %

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
connection_exists(_) :-
  nl, write("D'oh! You can't get to that room from here."), nl, !, fail.
  
% ----- Handles describing the player's surroundings ----- %

observe :-
  my_loc(Here),
  describe_room(Here), !,
  list_furniture(Here), !,
  list_doors(Here), !.
  
inspect(Furniture, Which) :-
  my_loc(Here),
  forall(item(Item, Desc, (Here, Furniture, Which)), (nl, write(Item),write(' - '),write(Desc))).
  
describe_room(Here) :-
  room(Here, Desc, _),
  nl, write(Desc), nl.
  
list_furniture(Here) :-
  write('The room contains: '),
  forall(furn(Name, Here, Amount), (nl, write(Amount),write(' '),write(Name))).
  
list_doors(Here) :-
  nl, write('There are doors to: '),
  forall(door(Here, ConnectedRoom, _), (nl, write(ConnectedRoom))).
  
% ----- Handles interacting with items ----- %
  
pickup(Item, Furn) :-
  my_loc(Here), !,
  item(Item, Desc, (Here, Furn, Which)), !,
  retract(item(Item, Desc, (Here, Furn, Which))),
  asserta(in_bag(Item, Desc)),
  nl, write("You picked up "),write(Item).
pickup(_) :-
  nl, write("You either can't reach that item, or it doesn't exist."), !, fail.
  
% ----- Game state logic ----- %

start :-
  nl, write("This is an example intro that might be used to describe the situation in the game world."),
  my_loc(lobby).
  
% TODO: Give hints upon death as to what to do to avoid it next time
die :-
  nl, write("You have died... Sorry about that. Use command "start" to try again."),
  retractall(my_bag(_, _)), retractall(my_loc(_)).
  
% ----- Misc ----- %

instructions :-
  nl, write("Possible commands (use regular Prolog syntax):"),
  nl, write("start: begin the adventure!"),
  nl, write("move(<room>): move to a connected room"),
  nl, write("observe: get information about your surroundings"),
  nl, write("inspect: look closer at a piece of furniture").
