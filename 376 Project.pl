% Reset assertions so there isn't exponential growth of doors between rooms...
:- retractall(my_loc(_)), retractalll(door(_, _, _)), retractall(in_bag(_, _)), retractall(item(_, _, _)).

% Define our custom stuff
:- dynamic my_loc/1, door/3, in_bag/2, item/3.

% Give the user some direction
:- write("Use 'instructions' to learn how to interact with the world and begin your adventure.").

% Rooms - room(<name>, <desc>).
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

% Doors - door(<room1>, <room2>).
door("Lobby", "Hall_Down", '0').
door("Hall_Down", "Auditorium", '1').
door("hall_Down", "Bathroom_Down", '2'). % Possibly find a way to lock the door
door("hall_down", "Classroom_Down", '3').
door("hall_down", "Stairway", '4').
door("Stairway", "Hall_Up", '5').
door("Hall_Up", "Bathroom_Up", '6') .% Possibly find a way to lock the door
door("Hall_Up", "Classroom230", '7').
door("Hall_Up", "Classroom232", '8').
door("Hall_Up", "Conference_Room", '9').
door("Hall_Up", "Lair", '10'). % Possibly find a way to lock the door

/* Doors aren't one-way */
:- forall(door(X,Y,Z), assert(door(Y,X,Z))).

% Furniture - furn(<furn_name>, <location>, <amount>).
furn("Dinosaur Statue", "Lobby", 2).
furn("Bookcase", "Classroom230", 1).
furn("Bench", "Hall_Up", 2).
furn("Functional PC", "Classroom232", 5).
furn("Broken PC", "Classroom232", 10).
furn("White Board", "Classroom_Down", 3).
furn("Table", "Conference_Room", 1).
furn("Sink", "Bathroom_Down", 8).
furn("Desk", "Classroom_Down", 10).
furn("Water Fountain", "Hall_Down", 1).
furn("Chair", "Auditorium", 5).

% Items - item(<item_name>, <description>, (<location-room>, <location-furniture>, <which-furniture>), <in-bag?>).
item("Used chewing gum", "It's chewing gum", ("Lobby", "Dinosaur Statue", 1), false).
item("Coffee maker", "Eveyone likes coffee, maybe even a mad professor?", ("Conference_Room", "Table", 1), false).
item("Eraser", "You notice that on the white board 'JAVASCRIPT IS AWESOME!!!!!" is written. You should probably erase that before a certain unstable computer sicentist sees it...", ("Classroom_Down", "White Board",  1), false).
item("Downstairs bathroom key", "Can be used to unlock the downstairs bathroom.", ("Classroom_Down", 'Desk' 2), false).
item("Lair key", "Can be used to unlock the the door to the computer science department offices otherwise known as the mad professor's lair!", ("Auditorium", 'Chair' 2), false).

% These are just test items for defeating the boss, feel free to name them whatever fits with the story. I think them being Javascript related would be hilarious and perfect
% Also, we should have each of the items be hidden behind either a puzzle or an enemy that also requires some item to defeat them.
item("Robot killer 1", "desc", ("room", "furniture", "which")).
item("Robot killer 2", "desc", ("room", "furniture", "which")).
item("Robot killer 3", "desc", ("room", "furniture", "which")).
item("'JavaScript: The Definitive Guide' by David Flanagan", "A book with a somewhat disturbing aura... You feel a sense of dread just looking upon it.", ("Classroom230", 'Bookcase', 1), false).
item("Laptop", "A personal laptop that looks to be left in haste by a fleeing student. It still works!", ("Hall_Up", 'Bench', 1), false).
item("USB Flash Drive", "A standard 16GB flash drive. A particular professor was crazy about these...", ("Classroom232", 'Functional PC', 4), false).
item("Hand mirror", "A small cracked hand mirror that can be used to deflect lasers...", ("Bathroom_Down", 'Sink', 3), false).
item("Water bottle", "Looks like a student left their water bottle behind. Hey it's full too!", ("Hall_Down", 'Water Fountain', 1), false).

% Enemy - enemy(<name>, <item-to-defeat>, (<appearance>, <location>)).
enemy("Laser Turret", "Hand mirror", ("A dark shape rests at the top of the stairway. In the dim light, you can see that it is a turret of some kind.", "Stairway")).
enemy("Robotic Spider", "Water bottle", ("You hear a metalic clicking sound against the floor tiles, out of the shadows appears a huge spider with massive metal pinchers", "Auditorium")).
enemy("Turtle-Bot", "Used chewing gum", ("Large tire skid marks can be seen all over the floor, you hear the buzzing a motor, form behind a desk a turtle-bot speeds with its gaint wheels", "Classroom232")).
enemy("Robo-Sam", "Boss name", ("Once a professor from SRU, the Dr. Sam everyone knew is now a half humanoid-robot bent on terrorizing the computing students of SRU! ", "Boss location")).
%The killing items from the boss are the javascript book, laptop, and USB drive

% Death(ways to die) - death(<enemy/environment>, <death-message>, <avoidance-hint>).
death("Laser Turret", "You charge the turret. You hear a high-pitched noise and there's no time to react as the muzzle swings around and guns you down with sick looking laser beams. Sick, though they may be, you are no less dead.", "Before dying, you notice one of the laser beams bounce of the reflective window.").
death("Robotic Spider", "You attempt to flee, but the nasty thing catches you by the pant leg and pulls you to the floor. You're vision starts to blur as you see the spider come toward you, pinchers dripping with venom.", "Before falling unconscious, you see the bright lights and exposed circuits of the spider, probably dosen't wanna get those wet!").
death("Turtle-Bot", "As you make to run, you are quickly swept away by the Turtle-Bot's massive wheels...", "If only you had something sticky to stop it from charging.").
death("Robo-Sam", "Before you can even take a breath,  the once Dr. Sam blinds you his stock pile of red ink. Now incompacitated, Robo-Sam can turn you into a humanoid just like him...", "Regardless of his appearance, Robo-Sam still hates one thing more than anything else... Javascript.").

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
connection_exists(_, _) :-
  nl, write("D'oh! You can't get to that room from here."), nl, !, fail.
  
% ----- Handles describing the player's surroundings ----- %

observe :-
  my_loc(Here),
  nl, describe_room(Here), !,
  nl, list_furniture(Here), !,
  nl, list_doors(Here), !,
  nl, list_enemies(Here), !, fail.
  
inspect(Furniture, Which) :-
  my_loc(Here), !,
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
  enemy(Enemy, _, (Desc, Here),
  nl, write('>'),write(Enemy),write(" is guarding this room. You will need to kill it before doing anything here (including moving anywhere except from whence you came).").
list_enemies(_).
  
% ----- Handles interacting with items ----- %
  
pickup(Item, Furn, Which) :-
  my_loc(Here), !,
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
  enemy(Enemy, Item, (_, Here)), !,
  nl, write("You used "),write(Item),write(" to kill "),write(Enemy),write("!"), !.
kill(Enemy) :-
  die(Enemy), !.
  
kill(Item) :-
  my_loc(Here),
  item(Item, _, (Here, _, _), _)),
  nl, write("Are you feeling well? You can't kill "),write(Item),write("..."), !, fail.
kill(Furniture) :-
  my_loc(Here),
  furn(Furniture, Here, _)),
  nl, write("Are you feeling well? You can't kill "),write(Furniture),write("..."), !, fail.
kill(_) :-
  nl, write("You must be seeing things, there is no "),write(Enemy),write(" here."), !, fail.
  
% ----- Game state logic ----- %

start :-
  nl, write("This is an example intro that might be used to describe the situation in the game world."),
  asserta(my_loc("Lobby")), !,
  observe.
  
die(Enemy) :-
  enemy(Enemy, _, _),
  death(Enemy, Desc, Hint),
  nl, write(Desc), nl, write(Hint), nl, write("Use 'start' to begin again."),
  retractall(my_loc(_)),
  forall(item(Item, Desc, (Here, Furn, Which), true), asserta(item(Item, Desc, (Here, Furn, Which), false))), !, fail.
  
% ----- Misc ----- %

instructions :-
  nl, write("Possible commands (use regular Prolog syntax):"),
  nl, write("start: begin the adventure!"),
  nl, write("move(<room>): move to a connected room"),
  nl, write("pickup(<item>, <furniture>, <which>): pick up an item from some piece of furniture"),
  nl, write("kill(<enemy>): attempt to kill an enemy"),
  nl, write("\t'Furniture' is broadly used to describe any uninteractable object, and cannot be picked up"),
  nl, write("observe: get information about your surroundings"),
  nl, write("inspect: look closer at a piece of furniture"),
  nl, write("bag: list the contents of your bag").
