pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- todo: can you do different colors based on speed, fast moving stars become lines, and multiple bullets?
-- next: https://www.youtube.com/watch?v=2httrC7c1m0&ab_channel=LazyDevs
function _init()
 	cls(0)
	mode="start"
	blinkt=1
	splashcnt=0
end
-- update to account for using the drawspr for the ship.
-- using the improved loop
-- spawn multiple enemies (try 5 or 10 over time)
-- Different types of enemies
function start_game()
	mode="splash"	

	 --ship vars
	ship={x=40,y=40,spr=17}

 	--bullet vars
 	bulx=-10
 	buly=-10
 	bulspr=5

 	--muzzle
 	muzzle=0

 	--game state
 	score=30000
 	lives=3
 	bombs=2

	--star mapping
	stars={}

	
	for i=1,100 do
		local newstar={}
		newstar.x=flr(rnd(128))
		newstar.y=flr(rnd(128))
		newstar.spd=rnd(1.5)+0.5
		add(stars,newstar)
	end
	
	-- Bullets
	buls={}
	
	-- Enemies
	enemies={}

	local nenemy={}
	nenemy.x=60
	nenemy.y=5
	nenemy.spr=20

	add(enemies,nenemy)
end

function _draw()
	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		-- start screen
		draw_start()
	elseif mode=="splash" then
		draw_splash()
	elseif mode=="over" then
		draw_over()
	end
end

function draw_game()
	cls(0)
	starfield()
	spr(ship.spr,ship.x,ship.y)

	for i=1,#buls do
		local mybul=buls[i]
		drawspr(mybul)
	end
	
	if muzzle>0 then
		circfill(ship.x+3,ship.y-2,muzzle,7)
	end
	
	--ui
	print("score: "..score, 30,1,12)
	-- lives
	for i=1,3 do
		if lives>=i then
			spr(11,i*9-8,1)
		else
			spr(12,i*9-8,1)
		end
	end

	-- bombs
	for i=1,3 do
		if bombs>=i then
			spr(27,100+i*9-8,1)
		else
			spr(28,100+i*9-8,1)
		end
	end
	
	-- enemies
	for i=1,#enemies do
		local myen=enemies[i]
		drawspr(myen)
	end

	animatestars()
end

function draw_start()
	cls(1)
	print("new schmup game", 30, 40, 12)
	print("press any key to start", 30, 80, blink())
end

function draw_splash()
	cls(1)
	print("level 1!", 30, 40, blink())
end

function draw_over()
	cls(8)
	print("game over", 30, 40, 12)
	print("press any key to continue", 30, 80, blink())
end

function _update()
	blinkt+=1
	splashcnt+=1
	if mode=="game" then
		-- run game
		update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="splash" then
		update_splash()
	elseif mode=="over" then
		update_over()
	end
end

function update_splash()
	if splashcnt<20 then
		mode="splash"
	else
		mode="game"
		splashcnt=0
	end
	
end

function update_over()
	if btnp(4) or btnp(5) then
		mode="start"
		splashcnt=0
	end
end

function update_start()
	if btnp(4) or btnp(5) then
		start_game()
	end
end

-->8
function starfield()
	for i=1,#stars do
		starcolor=7
		if (i%2==0) then
			starcolor=10
		end
		pset(stars[i].x,stars[i].y,starcolor)
	end
end

function animatestars()
	for i=1,#stars do
		local mystar=stars[i]
		mystar.y=mystar.y+mystar.spd
		if mystar.y>128 then
			mystar.y=mystar.y-128
		end
	end
end

function blink()
	local banim={5,5,6,6,7,7,6,6,5,5}

	if blinkt > #banim then 
		blinkt=1
	end
	return banim[blinkt]
end

function drawspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y)
end

function col(a,b)
	local a_left=a.x
	local a_top=a.y
	local a_right=a.x+7
	local a_bottom=a.y+7

	local b_left=b.x
	local b_top=b.y
	local b_right=b.x+7
	local b_bottom=b.y+7

	if a_top >b_bottom then return false end
	if b_top >a_bottom then return false end
	if a_left >b_right then return false end
	if b_left >a_right then return false end	

	return true
end

-->8
function update_game()
	xspeed=0
 	yspeed=0
 	ship.spr=17
	
	if btn(0) then
		xspeed=-2
		ship.spr=16
	end
	
	if btn(1) then
		xspeed=2
		ship.spr=18	
	end
	
	if btn(2) then
		yspeed=-2
	end

	if btn(3) then
		yspeed=2
	end
	
	if btn(4) then
		mode="over"
	end

	--fire bullet
	if btn(5) then
		local newbul={}
		newbul.x=ship.x
		newbul.y=ship.y-3
		newbul.spr=bulspr
		add(buls,newbul)

		muzzle=5
	end
	
	--moving the ship
	ship.x=ship.x+xspeed
	ship.y=ship.y+yspeed
	
	--move the bullets
	for i=#buls,1,-1 do
		local mybul=buls[i]
		mybul.y=mybul.y-3

		if mybul.y<-8 then
			del(buls,mybul)
		end
	end
	
	--moving enemies
	for myen in all(enemies) do
		myen.y+=1
		myen.spr+=.1
		if myen.spr > 24 then
			myen.spr=20
		end
		if myen.y>128 then
			del(enemies,myen)
		end
	end

	-- collision detection
	for myen in all(enemies) do
		if col(myen,ship) then
			lives-=1
			sfx(1)
		end
	end
	-- Maybe spawn double enemies everytime an enemy gets killed?

	if muzzle>0 then
		muzzle=muzzle-1
	end

	if ship.x>120 then 
		ship.x=120
	end
	
	if ship.x<0 then
		ship.x=0
	end
	
	if ship.y>120 then 
		ship.y=120
	end
	
	if ship.y<0 then
		ship.y=0
	end
end
__gfx__
00000000000000000099990000000000000000000009900000000000077777700000000000000000000000000880088008800880000000000000000000000000
0000000000000000099a9990000cc00080777708009aa90007000070778888770088880000000000000000008888888880088008000000000000000000000000
007007000700007099a9999900c11c0008777780009aa90070700707788778870807708000000000000000008888888880000008000000000000000000000000
00077000007007009a99999900c11c000787787009aaaa9008077080788778870870078000000000000000008888888880000008000000000000000000000000
0007700000800800999999990cc11cc00777777009aaaa9070788707788778870870078000000000000000000888888008000080000000000000000000000000
007007000000000099999999cccccccc07777770090aa09007077070078888700807708000000000000000000088880000800800000000000000000000000000
000000000700070009999990c000000c070770700009900000077000007887000088880000000000000000000008800000088000000000000000000000000000
00000000007770000099990000000000000000000000000000000000000770000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000080000008000000000000000000000000000000000087000000870000000000000000000000000000
000c1000000cc0000001c00000000000007777008077770880777708807777080000000000000000000000000000700000007000000000000000000000000000
0011c10000c11c00001c110000000000087777800877778008777780087777800000000000000000000000000088880000888800000000000000000000000000
0011c10000c11c00001c110000000000078778700787787007877870078778700000000000000000000000000880888008070080000000000000000000000000
0c77cc100cc77cc001cc77c000000000077777700777777007777770077777700000000000000000000000000808888008700080000000000000000000000000
0cccccc1cccccccc1cccccc000000000077777700777777007777770077777700000000000000000000000000888888008000080000000000000000000000000
0c0990c1c009900c1c0990c000000000070770700707707007077070070770700000000000000000000000000888888008000080000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088880000888800000000000000000000000000
__sfx__
0001000037050360503405033050310502f050330502b05029050290502605023050220501f05016050190500405017050150500f0500c0500905006050020500105000000000010000000000010000500004000
00030000316302e6302b630236302662021620226201b6201d6201963016630126300462001620000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
