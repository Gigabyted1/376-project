:- retractall(my_loc(_)), retractall(door(_, _, _, _)), retractall(item(_, _, _, _)).

:- dynamic my_loc/1, door/4, item/4, enemy/4.

:- write("Use 'instructions' to learn how to interact with the world and begin your adventure.").

room("Tower", "A room constructed of stone blocks. A single window looks out on a vast wasteland.").
room("Stairway", "A spiral staircase connecting the tower to the castle.").
room("Base", "The space at the base of the tower. It's a round room with various decrepit trappings of a now-absent army.").
room("Outside", "Freedom! You've escaped the extremely difficult demonstration world!").

door("Tower", "Stairway", "locked", "Shiny key").
door("Stairway", "Base", "unlocked", "").
door("Base", "Outside", "unlocked", "").

:- forall(door(X,Y,Z,A), assert(door(Y,X,Z,A))).

furn("Drawers", "Tower", 1).
furn("Wardrobe", "Tower", 1).
furn("Rug", "Tower", 1).
furn("Bedroll", "Tower", 1).
furn("Very obvious hidey hole", "Stairway", 1).
furn("Wall", "Tower", 1).

item("Painting", "It's a painting of...", ("Tower", "Wall", 1), false).
item("Shiny key", "Well that was obvious...", ("Tower", "Rug", 1), false).
item("Orange pants", "Obnoxiously orange pants. Who would wear these??", ("Tower", "Wardrobe", 1), false).
item("Journal", "It's your journal.", ("Tower", "Drawers", 1), false).
item("Crossbow", "A loaded crossbow in good repair. Your captor doesn't seem very smart...", ("Stairway", "Very obvious hidey hole", 1), false).

enemy("Guard", "Crossbow", ("You see a big man guarding the exit. He is dressed in chainmail from head to toe with a heavy steel helmet. You see the hilt of a longsword peeking over his left shoulder.", "Base"), false).

death("Guard", "The guard is roused! He draws his longsword and charges you. During his charge, he trips, drops his longsword, and crashes into you. You are impaled on a sharp edge of his left spaulder and quickly bleed to death.", "Try looking for a weapon to assist you!").

% ----------------------------------------------------------------

move(Room) :-
  my_loc(Here),
  enemy_dead(Here), !,
  room_exists(Room), !,
  connection_exists(Here, Room), !,
  door_unlocked(Room), !,
  retract(my_loc(Here)),
  asserta(my_loc(Room)),
  observe, !.
  
room_exists(Room) :-
  room(Room, _).
room_exists(_) :-
  nl, write("D'oh! No such room exists."), nl, !, fail.
  
connection_exists(Here, Room) :-
  door(Here, Room, _, _).
connection_exists(_, _) :-
  nl, write("D'oh! You can't get to that room from here."), nl, !, fail.
  
door_unlocked(Room) :-
  my_loc(Here),
  door(Here, Room, "unlocked", _).
door_unlocked(Room) :-
  my_loc(Here),
  door(Here, Room, "locked", Key),
  item(Key, _, _, true),
  retract(door(Here, Room, "locked", Key)),
  asserta(door(Here, Room, "unlocked", Key)),
  write("You unlocked the door.").
door_unlocked(Room) :-
  my_loc(Here),
  door(Here, Room, "locked", _),
  write("That door is locked! You will need a key to get through."), !, fail.
  
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
inspect(_, _) :-
  write("There is no such furniture here"), !, fail.
  
describe_room(Here) :-
  room(Here, Desc),
  nl, write(Desc), nl.
  
list_furniture(Here) :-
  write('The room contains: '), !,
  forall(furn(Name, Here, Amount), (nl, write('>'),write(Amount),write(' '),write(Name))).
  
list_doors(Here) :-
  nl, write('There are doors to: '),
  forall(door(Here, ConnectedRoom, _, _), (nl, write('>'),write(ConnectedRoom))).
  
list_enemies(Here) :-
  enemy(Enemy, _, (_, Here), false),
  nl, write('>'),write(Enemy),write(" is guarding this room. You will need to kill him before doing anything here.").
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
  enemy(Enemy, Item, (Desc, Here), false), !,
  item(Item, _, _, true),
  retract(enemy(Enemy, Item, (Desc, Here), false)),
  asserta(enemy(Enemy, Item, (Desc, Here), true)),
  nl, write("You used "),write(Item),write(" to kill "),write(Enemy),write("!").
kill(Enemy) :-
  my_loc(Here),
  enemy(Enemy, _, (_, Here), true), !,
  nl, write("You can't kill a corpse..."), !, fail.
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
kill(Enemy) :-
  !,
  die(Enemy).
  
% ----- Game state logic ----- %

start :-
  nl, write("You wake up in an unfamiliar stone room. Not again..."),
  retractall(my_loc(_)),
  forall(item(A, B, (C, D, E), true), asserta(item(A, B, (C, D, E), false))), !,
  forall(item(A, B, (C, D, E), true), retract(item(A, B, (C, D, E), true))), !,
  forall(enemy(A, B, (C, D), true), asserta(enemy(A, B, (C, D), false))), !,
  forall(enemy(A, B, (C, D), true), retract(enemy(A, B, (C, D), true))), !,
  asserta(my_loc("Tower")), !,
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
