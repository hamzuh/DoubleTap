DOUBLE-TAP / DUBBLETAP
Infinite wave-based twin stick shooter. Kill zombies, buy perks and open the map to reach higher and higher rounds!

Consider how to keep player engaged in later rounds once set up. Can go more extreme with effects and destruction 
in 2D, so allow the player to attain a crazy level of power.

Emphasise the perfect run. One completely independent mode where all is gained or lost in one playthrough.

TO DO:
	- You also swap weapons when doing the stun kick
		_ Study RE5 and rethink the control scheme
	- You can punch enemies through walls, not a feature
	- Fix up collision layers and masks
		- Add collision layer for coins
	- Replace collision shape disabled with set_deferred("disabled", false)
	- VITAL:
		- Finish enemy state machine
			- Make player take damage on enemy hit
	- Hitstop function should return something / call back to the caller when it's over
		- After hitstop sfx etc.
	- Set all texture import to nearest
	- Coin bugfixes
		- It stays after being shot and can recollide
			- Maybe don't do this, copy ultrakill and random bounce the shot
	- Add debug functions for opening doors and giving money
		- Easier testing
		- Maybe in the autoload instead of the player directly
			- Separate autoload file...
	- Finish organising colliders into layers and masks
	- Despawn Powerups after 10 seconds *
	- Fix enemy following variation on player position
		- If the varied position is through a wall the enemy will go the wrong way
	- Powerups
		- Double Points
		- Instakill
		- Max Ammo
			- Reload only reserve ammo? Like old COD
		- Nuke
			- Call enemy nuke death function instead
			- Give points to player directly
		- Fire Sale
	- VFX
		- Make tracer it's own class, spawn as child when needed
			- Useful for concurrent tracers
			- Ultrakill start wide and then thin to nothing
		- Enemy Animations
			- Idle
			- Walk
			- Regular death
			- Nuke death
			- Surprise
				- on nearby event, could look funny during hitstop
			- Stun
			- Spawning
			- Banging / ripping barriers
			- Knockback / hit
				- Particle2D or sprite for blood?
		- Lerp to hitstop slowdown?
		- Who doesn't love some cray cray UI (LERP)
		- Gun smoke
		- Improve Muzzle Flash
		- +Points on HUD counter when earning
		- When turning on the power, keep the canvas modulate (or lessen it) but flick on the lights in the level, send signal to custom function for level
	- SFX
		- Swish on melee miss, thwack on hit
		- Powerup pickup
		- Power switch on
		- Make Attack a custom class state, add sound effect resource
		- Array of sounds for gunshot variety
	- Gun mechanics
		- Swapping
			- Equipping
			- Keep track of ammo
		- Reloading
			- Display reload bar on HUD, use animation progress to track
			- Timer for walk slowdown on shooting
		- Shotgun
			- Hitscan version, for x in concurrent bullets shoot rays
		- Projectile weapons
			- On resource for the projectile bool, when toggled open a submenu to put in the projectile scene
	- Buyable doors
		- Display buy text when next to door
		- Button hold to buy door
			- is just pressed, start timer. pressed, count down timer. released, reset timer
			- navigationobstacle on doors
	- Enemy spawns
		- Use spawns closest to player
		- Consider throughput when deciding how many spawns to use
		- Distribute out enemies to spawners
		- Consider which doors are open when setting suitable spawners
			- Maybe stick a signal emit for room_change on any new room and do the array from there
	- Buying doors changes the nav system
	- Round counter / system
	- Stumbling walk system for enemies / zombies
	
	- Create moveable and aimable player character, kbm and controller
	- Create map with collisions
	- Spawn weapon
		- Ammo system
	- Buyable weapons
		- Laser
		- Sniper
		- Grenade
	- Power-Ups
		- Insta-Kill
		- Nuke
		- Double Points
	- Buyable doors
	- Player attributes
		- Health
		- Money
		- Points
	- Enemy Mechanics
		- Circling
		- Swipe range
			- Circle collider in which the player can be slashed at (placed only in front?)
		- Map navigation
		- Enemy spawner
	- Minimum Viable HUD
		- points
		- ammo (bombs?)
	- func hit / func die in player
	- Bullet lifetime or bullet on screen count
	- Sound effects
	- Graphics
		- Doors
		- Player Character
		- Enemies
	- Outer wall colliders
	- Decouple camera from player character
	- Refine player state machine
	- Design and code stronger movelist
	- Fix character movement jitter on 144Hz display
		- Camera on process_physics?
		- Lock framerate to 60FPS?
	- Figure out how to pass damage information to enemy
		- Make Hitboxes a custom class like State
			- Subclasses inherit their parent's signals
			- Could do the same for Attacks
	- Add attack and punch sound effects
	- When far away enemies use navigation mesh, when closer / in same room swap to direct follow
		- For certain melee characters maybe switch into circling mode
		- For gun characters just swarm
		- ray cast to check if wall is in way so you dont just walk into it at close range
	
POTENTIAL IDEAS:
	- Setting
		- Action Heroes / Worthy Fighters
		- City Map
			- New York
				- Landmarks
					- The Lot Radio
					- Mi Sabor Cafe
					- Chinatown
					- Koreatown (?)
					- Roosevelt Island
						- Gondola like MOTD!!
					- MOMA
					- Halal Food Carts
					- Times Square
						- Kinokuniya
				- Portal to London #popcryptreference
				- COTD but with musicians
				- Instruments are Wonder Weapons
			- Manchester
				- Platt Fields Park
				- Hobgoblin Music
				- Victoria Park Mosque
				- Metrolink like Tranzit
				- Boombox guy is a secret boss
				- Banh Mi heals HP
		- Fast Food restaurant
			- Some guy is stuck in the toilets
		- Mall (Trafford Centre ripoff)
			- Dead Rising
			- Food Court
			- Cinema section could be like Kino Der Toten but markedly less Nazi paraphernalia
		- Strangeways prison
			- Like Alcatraz from MOTD but more insensitive
	- Characters
		- COWBOY
			- Regular fire - Spray 6 shooters by fanning the hammer
			- Alt fire - Aim down, move slowly and send one super bullet that penetrates more enemies 
		- NINJA
			- Regular fire - Throw shurikens wildly in wavy arcs
			- Alt fire - hmmm.
		- SWORDSMAN
			- Samurai type?
				- Lock on to enemy and take circle strafe stance, you can't move fast, you can roll to dodge
				- Hold the blade inside the sheath with a button, when the enemy starts to attack only then can you let go to kill them in one swipe
				- Otherwise you bounce off and leave yourself very wide open
		- WRESTLER
			- booyaka booyaka 619
			- Mask De Smith / Armor King
		- Alan Wake
			- Flashlight enemies to weaken them

CORE TENETS:
	Skilled movement and evasion, grouping of enemies
	Point optimisation
	Punishing but consistent
	Quick, uncomplicated, arcadey fun
	Mystery and exploration
	I-frame exploitation

INSPIRATIONS:
	COD Zombies / Dead Ops Arcade
	HYPER DEMON / DEVIL DAGGERS
	Vampire Survivor JOKES
	SAS Zombie Assault
	Geometry Wars
	Risk of Rain 2
	Pocky & Rocky
	Enter the Gungeon? Kinda don't like that game
	Spikeout
	Ninja Gaiden
	God Hand
	Devil May Cry
