% Reset assertions so there isn't exponential growth of doors between rooms...
:- retractall(my_loc(_)), retractall(door(_, _, _)), retractall(in_bag(_, _)), retractall(item(_, _, _, _)).

% Define our custom stuff
:- dynamic my_loc/1, door/3, in_bag/2, item/4.

% Give the user some direction
:- write("Use 'instructions' to learn how to interact with the world and begin your adventure.").

% Rooms - room(<name>, <desc>).
room("Lobby", 'The lobby of ATS. There are several chairs, a nice big doormat, and a variety of science-related decorations.').
room("Downstairs Left Wing", 'The left wing of the hallway on the first floor of ATS.').
room("Downstairs Right Wing", 'The right wing of the hallway on the first floor of ATS.').
room("Upstairs Left Wing", 'The left wing of the second-floor hallway.').
room("Upstairs Right Wing", 'The right wing of the second-floor hallway. It is completely blocked by rubble.').
room("Stairway 1", 'The stairway connects the first and second floors of ATS.').
room("Stairway 2", 'The stairway connects the second and third floors of ATS. It is completely blocked by rubble.').
room("Auditorium", 'The auditorium of ATS is one of the largest rooms in the building.').
room("Downstairs Bathroom", 'The downstairs bathroom.').
room("Room 130", 'A fairly large classroom. There is a project playing an eerie news clip about a mad SRU professor.').
room("Upstairs Bathroom", 'The upstairs bathroom.').
room("Room 230", 'One of the computer science classrooms.').
room("Room 232", 'One of the computer science classrooms.').
room("Conference Room" , 'The conference room of the computer science department is where many students go to study, work on assignments or projects, and meet with friends. Objects may be found here left by students.').
room("CS Department", 'The computer science department once held the offices of several department faculty members. Now it is the lair of a mad computer scientist.').

% Doors - door(<room1>, <room2>).
door("Lobby", "Downstairs Left Wing", '0').
door("Lobby", "Downstairs Right Wing", '0').
door("Downstairs Right Wing", "Downstairs Bathroom", '2'). % Possibly find a way to lock the door
door("Downstairs Right Wing", "Room 130", '3').
door("Downstairs Left Wing", "Stairway", '4').
door("Downstairs Left Wing", "Auditorium", "unlocked").
door("Stairway", "Upstairs Hallway", '5').
door("Upstairs Left Wing", "Upstairs Bathroom", '6') .% Possibly find a way to lock the door
door("Upstairs Left Wing", "Room 230", '7').
door("Upstairs Left Wing", "Room 232", '8').
door("Upstairs Left Wing", "Conference Room", '9').
door("Upstairs Left Wing", "CS Department", '10'). % Possibly find a way to lock the door
door("Upstairs Left Wing", "Stairway 2", '8').

/* Doors aren't one-way */
:- forall(door(X,Y,Z), assert(door(Y,X,Z))).

% Furniture - furn(<furn_name>, <location>, <amount>).
furn("Dinosaur Statue", "Lobby", 2).
furn("Doormat", "Lobby", 2).
furn("Chair", "Lobby", 8).

furn("Water Fountain", "Downstairs Right Wing", 1).
furn("Bench", "Downstairs Left Wing", 2).
furn("Bench", "Downstairs Right Wing", 2).

furn("White Board", "Room 130", 1).
furn("Trash Can", "Room 130", 1).
furn("Desk", "Room 130", 10).
furn("Chair", "Room 130", 20).
furn("Podium", "Room 130", 1).

furn("Trash Can", "Auditorium", 1).
furn("Chair", "Auditorium", 90).
furn("Podium", "Auditorium", 1).

furn("Sink", "Downstairs Bathroom", 4).
furn("Toilet Stall", "Downstairs Bathroom", 4).
furn("Mirror", "Downstairs Bathroom", 4).

furn("Bench", "Upstairs Left Wing", 2).
furn("Water Fountain", "Upstairs Left Wing", 1).

furn("Trash Can", "Room 230", 1).
furn("Whiteboard", "Room 230", 1).
furn("Bookcase", "Room 230", 1).
furn("Functional PC", "Room 230", 2).
furn("Broken PC", "Room 230", 13).

furn("Trash Can", "Room 232", 1).
furn("Whiteboard", "Room 232", 1).
furn("Bookcase", "Room 232", 1).
furn("Functional PC", "Room 232", 5).
furn("Broken PC", "Room 232", 10).

furn("Table", "Conference Room", 1).
furn("Coffee Maker", "Conference Room", 1).
furn("Chair", "Conference Room", 6).
furn("Desk", "Conference Room", 3).
furn("Functional PC", "Conference Room", 1).
furn("Broken PC", "Conference Room", 1).
furn("Whiteboard", "Conference Room", 1).
furn("Microwave", "Conference Room", 1).

furn("Sink", "Upstairs Bathroom", 4).
furn("Toilet Stall", "Upstairs Bathroom", 4).
furn("Mirror", "Upstairs Bathroom", 4).

% Items - item(<item_name>, <description>, (<location-room>, <location-furniture>, <which-furniture>), <in-bag?>).
item("Used chewing gum", "It's chewing gum", ("Lobby", "Dinosaur Statue", 1), false).
item("Downstairs bathroom key", "Can be used to unlock the downstairs bathroom.", ("Room 130", "Desk", 2), false).
item("Lair key", "Can be used to unlock the the door to the computer science department offices otherwise known as the mad professor's lair!", ("Auditorium", "Chair", 2), false).

% Also, we should have each of the items be hidden behind either a puzzle or an enemy that also requires some item to defeat them.
item("'JavaScript: The Definitive Guide' by David Flanagan", "A book with a somewhat disturbing aura... You feel a sense of dread just looking upon it.", ("Room 230", "Bookcase", 1), false).
item("Laptop", "A personal laptop that looks to be left in haste by a fleeing student. It still works!", ("Auditorium", "Bench", 1), false).
item("USB flash drive", "A standard 16GB flash drive. A particular professor was crazy about these...", ("Room 232", "Functional PC", 4), false).
item("A+ Sticker", "A stack of stickers that read 'A+'.", ("Room 130", "Podium", 1), false).
item("Hand mirror", "A small cracked hand mirror.", ("Downstairs Bathroom", "Sink", 3), false).
item("Water bottle", "Looks like a student left their water bottle behind. Hey, it's full, too!", ("Downstairs Right Wing", "Water Fountain", 1), false).

% Enemy - enemy(<name>, <item-to-defeat>, (<appearance>, <location>), <dead?>).
enemy("Laser Turret", "Hand mirror", ("A dark shape rests at the top of the stairway. In the dim light, you can see that it is a turret of some kind.", "Stairway"), false).
enemy("Robospider", "Water bottle", ("You hear fans whirring, electronic beeps, and a metallic clicking sound. Down on the stage, you see a huge robotic spider.", "Auditorium"), false).
enemy("Gazebo 3000", "A+ Sticker", ("You see what seems to be an oddly shaped chair that rests on a set of treads.", "Room 232"), false).
enemy("Robo-Sam", "JavaScript Payload USB Stick", ("You can see him, no, 'it', bent over the fresh corpse of a student. Robotic limbs, wires crisscrossing across its chest, and yet a fully human face and head. You recognize that face... it's Dr. Sam.", "CS Department"), false).
%The killing items from the boss are the javascript book, laptop, and USB drive

% Death(ways to die) - death(<enemy/environment>, <death-message>, <avoidance-hint>).
death("Laser Turret", "You hear a high-pitched noise and there's no time to react as the muzzle swings around and guns you down with sick looking laser beams. Sick, though they may be, you are no less dead...", "As your vision fades, you notice one of the laser beams bounce of the reflective window.").
death("Robospider", "The massive arachnid catches you by the pant leg and pulls you to the floor. A robot it may be, but it seems you are no less spider food...", "As you lay there awaiting your fate, you see the bright lights and exposed circuitry of the spider.").
death("Gazebo 3000", "All at once, a set of arms spring from the back of the chair and a set of sensors from the top. Attached to the arms are various elements of torture. As it speeds toward you, faster almost than comprehension, you too late see the word, 'GAZEBO' printed across the front. The arms trap you into the chair and your punishment begins...", "You noticed the contraption pause expectantly just before beginning its dark function. Perhaps if you showed it something...?").
death("Robo-Sam", "Before you can even take a breath, the once Dr. Sam blinds you with his stock pile of red ink. Now incapacitated, Robo-Sam can turn you into a humanoid just like him...", "Robotic though he may be, he is still partly human. What does Dr. Sam hate the most...?").

% ----- Handles moving throughout the map ----- %

move(Room) :-
  my_loc(Here),
  enemy_dead(Here), !,
  room_exists(Room), !,
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
connection_exists(_, _) :-
  nl, write("D'oh! You can't get to that room from here."), nl, !, fail.
  
enemy_dead(Here) :-
  enemy(Enemy, _, (_, Here), false), !,
  die(Enemy).
enemy_dead(Here) :-
  enemy(_, _, (_, Here), true).
enemy_dead(_).
  
  
% ----- Handles describing the player's surroundings ----- %

observe :-
  my_loc(Here),
  nl, describe_room(Here), !,
  nl, list_furniture(Here), !,
  nl, list_doors(Here), !,
  nl, list_enemies(Here), !, fail.
  
inspect(Furniture, Which) :-
  my_loc(Here), !,
  enemy_dead(Here),
  forall(item(Item, Desc, (Here, Furniture, Which), false), (nl, write(Item),write(' - '),write(Desc))).
  
describe_room(Here) :-
  room(Here, Desc),
  nl, write(Desc), nl.
  
list_furniture(Here) :-
  write('The room contains: '), !,
  forall(furn(Name, Here, Amount), (nl, write('>'),write(Amount),write(' '),write(Name))).
  
list_doors(Here) :-
  nl, write('There are doors to: '),
  forall(door(Here, ConnectedRoom, _), (nl, write('>'),write(ConnectedRoom))).
  
list_enemies(Here) :-
  enemy(Enemy, _, (_, Here), false),
  nl, write('>'),write(Enemy),write(" is guarding this room. You will need to kill it before doing anything here (including moving anywhere except from whence you came).").
list_enemies(_).
  
% ----- Handles interacting with items ----- %
  
pickup(Item, Furn, Which) :-
  my_loc(Here), !,
  enemy_dead(Here),
  item(Item, Desc, (Here, Furn, Which), false), !,
  retract(item(Item, Desc, (Here, Furn, Which), false)),
  asserta(item(Item, Desc, (Here, Furn, Which), true)),
  nl, write("You picked up "),write(Item).
pickup(_, _, _) :-
  nl, write("There is no such item within reach."), !, fail.
  
bag :-
  write('Your bag contains: '), !,
  forall(item(Item, Desc, (_, _, _), true), (nl, write('>'),write(Item),write(' - '),write(Desc))).
    
% ----- Enemy interaction logic ----- %

kill(Enemy) :-
  my_loc(Here),
  in_bag(Item, _),
  enemy(Enemy, Item, (Desc, Here), false), !,
  retract(enemy(Enemy, Item, (Desc, Here), false)),
  asserta(enemy(Enemy, Item, (Desc, Here), true)),
  nl, write("You used "),write(Item),write(" to kill "),write(Enemy),write("!"), !.
kill(Enemy) :-
  die(Enemy), !.
  
kill(Item) :-
  my_loc(Here),
  item(Item, _, (Here, _, _), _),
  nl, write("Are you feeling well? You can't kill "),write(Item),write("..."), !, fail.
kill(Furniture) :-
  my_loc(Here),
  furn(Furniture, Here, _),
  nl, write("Are you feeling well? You can't kill "),write(Furniture),write("..."), !, fail.
kill(Nothing) :-
  nl, write("You must be seeing things, there is no "),write(Nothing),write(" here."), !, fail.
  
% ----- Game state logic ----- %

start :-
  nl, write("This is an example intro that might be used to describe the situation in the game world."),
  asserta(my_loc("Lobby")), !,
  observe.
  
die(Enemy) :-
  enemy(Enemy, _, _, _),
  death(Enemy, Desc, Hint), !,
  nl, write(Desc), nl, write(Hint), nl, write("Use 'start' to begin again."),
  retractall(my_loc(_)),
  forall(item(A, B, (C, D, E), true), asserta(item(A, B, (C, D, E), false))), !,
  forall(item(A, B, (C, D, E), true), retract(item(A, B, (C, D, E), true))), !,
  forall(enemy(A, B, (C, D), true), asserta(enemy(A, B, (C, D), false))), !,
  forall(enemy(A, B, (C, D), true), retract(enemy(A, B, (C, D), true))), !, fail.
  
% ----- Misc ----- %

instructions :-
  nl, write("Possible commands (use regular Prolog syntax):"),
  nl, write("start: begin the adventure!"),
  nl, write("move(<room>): move to a connected room"),
  nl, write("pickup(<item>, <furniture>, <which>): pick up an item from some piece of furniture"),
  nl, write("\t'Furniture' is broadly used to describe any uninteractable object, and cannot be picked up"),
  nl, write("kill(<enemy>): attempt to kill an enemy"),
  nl, write("observe: get information about your surroundings"),
  nl, write("inspect: look closer at a piece of furniture"),
  nl, write("bag: list the contents of your bag").
