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

function start_game()	
	mode="splash"	

	 --ship vars
 	shipx=40
 	shipy=40
 	hspeed=1
 	vspeed=1
 	shipspr=17
 	--bullet vars
 	bulx=-10
 	buly=-10
 	bulspr=5
 	--muzzle
 	muzzle=0

 	--game state
 	score=30000
 	lives=1
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
	spr(shipspr,shipx,shipy)
	spr(bulspr,bulx,buly)
	
	if muzzle>0 then
		circfill(shipx+3,shipy-2,muzzle,7)
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
	if splashcnt<100 then
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
-->8
function update_game()
	xspeed=0
 	yspeed=0
 	shipspr=17
	
	if btn(0) then
		xspeed=-2
		shipspr=16
	end
	
	if btn(1) then
		xspeed=2
		shipspr=18	
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
		buly=shipy-3
		bulx=shipx
		sfx(0)
		muzzle=5
	end
	
	--moving the ship
	shipx=shipx+xspeed
	shipy=shipy+yspeed
	
	--move the bullet
	buly=buly-3
	
	if muzzle>0 then
		muzzle=muzzle-1
	end

	if shipx>120 then 
		shipx=120
	end
	
	if shipx<0 then
		shipx=0
	end
	
	if shipy>120 then 
		shipy=120
	end
	
	if shipy<0 then
		shipy=0
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000087000000870000000000000000000000000000
000c1000000cc0000001c00000000000000000000000000000000000000000000000000000000000000000000000700000007000000000000000000000000000
0011c10000c11c00001c110000000000000000000000000000000000000000000000000000000000000000000088880000888800000000000000000000000000
0011c10000c11c00001c110000000000000000000000000000000000000000000000000000000000000000000880888008070080000000000000000000000000
0c77cc100cc77cc001cc77c000000000000000000000000000000000000000000000000000000000000000000808888008700080000000000000000000000000
0cccccc1cccccccc1cccccc000000000000000000000000000000000000000000000000000000000000000000888888008000080000000000000000000000000
0c0990c1c009900c1c0990c000000000000000000000000000000000000000000000000000000000000000000888888008000080000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088880000888800000000000000000000000000
__sfx__
0001000037050360503405033050310502f050330502b05029050290502605023050220501f05016050190500405017050150500f0500c0500905006050020500105000000000010000000000010000500004000
