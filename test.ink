VAR current_name = ""

player: Hello, { current_name } # HELLO1
npc: Hey! That's not my name! # HELLO2
player: It isn't? # HELLO3
~ current_name = "{~Walter|Emma|Tobi|Mike}"
npc: No! It's {current_name}! # HELLO4
player: Oh, hello { current_name } # HELLO5

* [Nice to see you]

player: Hello { current_name }. It's so nice to see you. # HELLO6

* [Weird name]

player: What a weird name. # HELLO7

-

>> say player HELLO8:"Oooo wiieee!"
