extends Node

@export var playtest = [
"Thank you for playing our game!",
"If we had time to make a form, please fill it out!"
]
@export var playtestspeaker = [
"Team Kronos",
"Team Kronos"
]
@export var manorwalkie = [
"Bzzzzzzz (Static Sounds)...",
"Do you read me! This is Sheriff Thompson, Over!",
"(Hey! That sounds like one of the officers I met when I tried entering the Manor.)",
"... Dang it! I'm still not getting anything from Officer Thomas Lankey.",
"He said he would investigate the place and be out by the next hour. At this rate I may have to call for backup.",
"(Officer Thomas Lankey huh? Maybe he's still inside the mansion, or maybe...)"]
@export var manorwalkiespeaker = [
"Walkie Talkie",
"Unknown Voice",
"Logan","Sheriff Thompson",
"Sheriff Thompson",
"Logan"]

@export var intro = [
"(So THIS is the mansion that everybody has been talking about? It’s big, but otherwise doesn't look too special to me.)",
"(Wait… Police? I guess that's a solid ‘yes’ on if the police are trying to get involved.)",
"(They seem to be talking to each other about something. Let’s give it the ole’ reporter eavesdrop…)",
"*Yawn*",
"Sheriff, do you REALLY think that this mansion is haunted? This feels ridiculous.",
"Nothing has come in or out of those doors for hours. Shouldn’t we be spending our time on more important things?",
"Drewinsky, every job requires a degree of patience. Good things come to those who wait, after all.",
"Nobody has ever even lived in this house! We’re waiting for ghosts!",
"We have lost enough of our officers trying to investigate the mansion. Unless you want to become a ghost?",
"(So I’m not the first person to look into this, huh? That’s some good info to write down.)",
"(Also this deputy seems really impatient. Fortunately for both of us, I don’t feel like waiting.)",
"Excuse me! Logan Ace for the Timely Reports, what are the police investigating with the mansion?",
"Hey! No press is permitted past this point! Move along!",
"Are the reports of people disappearing into the mansion true? Are there plans for a search team to go inside?",
"Did you not hear what I said!? Press is not permitted!",
"You heard the man. This is an active police scene, nobody is allowed in at the moment.",
"(Yeah, that’s mostly what I was expecting. I highly doubt I’m going to get any fruitful responses from them.)",
"(No big deal, I’ve gotten around the police before. And they just so happen to have left a spot exposed for me to slither through!)"]
@export var introspeaker = [
"Logan",
"Logan",
"Logan",
"Junior Drewinsky",
"Junior Drewinsky",
"Junior Drewinsky",
"Sheriff Thompson",
"Junior Drewinsky",
"Sheriff Thompson",
"Logan",
"Logan",
"Logan",
"Junior Drewinsky",
"Logan",
"Junior Drewinsky",
"Sheriff Thompson",
"Logan",
"Logan"]

@export var grugidentity = [
"Welcome to me home!",
"Hey Grug, I wanted to ask you something.",
"Do you by chance know a guy by name of Thomas Lankey?",
"Thomas...Lankey...",
"He used to work for the local police station and was sent to investigate this place.",
"A police man, sound familiar?",
"Police man? Investigation?",
"I remember now. My real name is Thomas Lankey and I was sent to investigate here.",
"(It worked!)",
"What happened to me? Who are you?",
"My name is Logan Ace! Here from Timely Reports to investigate this place for our latest story!",
"As for your situation I got no clue, you seem to went Coo- Coo when entering this place.",
"I see, normal I wouldn't let this slide but if wasn't for you I probably still be stuck here. You seem alright, still I need to look around this place. In the meantime, you can go on ahead.",
"You trust me to keep going through here?",
"More hands are better then one right, the others are little less lenient but not me.",
"You can use that key to enter the room in the middle of the mansion, let me know if you need any extra help."
]
@export var grugidentityspeaker = [
"Grug",
"Logan",
"Logan",
"Grug",
"Logan",
"Logan",
"Grug",
"Grug",
"Logan",
"Thomas Lankey",
"Logan",
"Logan",
"Thomas Lankey",
"Logan",
"Thomas Lankey",
"Thomas Lankey"
]

@export var markhaterarc = [
"*Chug* *Chug* *Chug*",
"Bleeehhh!!",
"He tosses the bottle, making a loud crack.",
"This isn't anything that I *hic* asked for!",
"This is no different from that *hic* damn bartender serves to me!",
"I want something better!! Not this wack-ass bull-*hic*"
]

@export var markhaterarcspeaker = [
"Mark",
"Mark",
"",
"Mark",
"Mark",
"Mark",
]

@export var markgivekey = [
"‘Chug’ ‘Chug’ ‘Chug’",
"Yeehaw!! Now that’s some good “hic” whiskey! Just one sip of that and it made my day!",
"Then how about we make a trade, I’ll give you the whole bottle if you hand me that key?",
"What do you say?",
"I like “hic” the way you think! You got yourself a deal!"

]
@export var markgivekeyspeaker = [
"Mark",
"Mark",
"Logan",
"Logan",
"Mark"
]

@export var unlock_safe = [
"The safe is unlocked. Let's see what's in it!",
"There's a nice bottle of wine...",
"And a record. Huh.",
"I'll take them both."
]
@export var unlock_safe_speaker = [
"",
"",
"",
""
]
@export var jukebox = [
"Hmm, where's that music coming from? Did someone fiddle with the jukebox? Hold on boys I'm gonna go check real fast, don't play with me.",
"(Yessss! Now's my chance!)",
"(I better hide so I avoid any trouble.)",
"Yeah, that looks like that was the case. Someone changed the track without my permission.",
"Whatever, I'll just change it back.",
"(There he goes, back to the table...)",
""
]
@export var jukeboxspeaker = [
"Dealer",
"Curly",
"Logan",
"Dealer",
"Dealer",
"Logan",
""
]
@export var jukebox2 = [
"Alright let's get back to this, looks like Curly has made an unexpected comeback from the looks of things.",
"(Some time passes.)",
"We have a winner with Curly taking it with an impressive comeback!",
"Alright!"
]
@export var jukeboxspeaker2 = [
"Dealer",
"",
"Dealer",
"Curly"
]
@export var recordfail = [
"Nothing happens...",
"Really?",
"Yes, nothing happens. The jukebox needs money to operate."
]
@export var recordfailspeaker = [
"",
"Logan",
""
]

@export var jukeboxkey = "jukeboxkey"
@export var jukeboxkey2 = "jukeboxkey2"
@export var unlock_safe_key = "unlocksafekey"
@export var markgivekeykey = "markgivekeykey"
@export var nothing = "Nothing happens."
@export var give_dog_bone = "The dog yips happily! Perhaps I can take the bone now..."
@export var unlock_saloon_door = "The door unlocks. Nice."
@export var unlock_casino_door = "The key worked. Let's go in."
