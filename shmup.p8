pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- todo: can you do different colors based on speed, fast moving stars become lines, and multiple bullets?
-- next: https://www.youtube.com/watch?v=2httrC7c1m0&ab_channel=LazyDevs
-- change enemy sprite when hit/explosion
function _init()
 	cls(0)
	mode="start"
	blinkt=1
	t=0
	bultimer=0
	splashcnt=0
	wavetime=70
end
-- update to account for using the drawspr for the ship.
-- using the improved loop
-- spawn multiple enemies (try 5 or 10 over time)
-- Different types of enemies
function start_game()
	wave=0
	t=0
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
	score=0
	lives=4
	invul=0
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
	
	-- bullets
	buls={}
	-- explosions
	explosionarr={}
	-- particles
	parts={}
	shwaves={}
	
	nextwave()
end

function spawnen()
	-- Enemies
	enemies={}

	local nenemy={}
	nenemy.x=rnd(120)
	nenemy.y=-8
	nenemy.spr=20
	nenemy.hp=5
	nenemy.flash=0

	add(enemies,nenemy)
end

--waves and enemies
function spawnwave()
	spawnen()
end

function nextwave()
	wave+=1

	if wave>4 then
		mode="win"
	else
		wavetime=80
		mode="wavetext"
	end
end

function explode(expx,expy,isblue)
	-- local myex={}
	-- myex.x=expx
	-- myex.y=expy
	-- myex.age=1

	-- add(explosionarr, myex)
	local myp={}
	myp.x=expx
	myp.y=expy
	myp.sx=0
	myp.sy=0
	myp.age=0
	myp.size=8
	myp.maxage=0
	myp.blue=isblue
	add(parts,myp)

	for i=1,20 do
		local myp={}
		myp.x=expx
		myp.y=expy
		myp.sy=(rnd()-0.5)*10
		myp.sx=(rnd()-0.5)*10
		myp.age=rnd(5)
		myp.size=1+rnd(2)
		myp.maxage=30+rnd(20)
		myp.blue=isblue
		myp.spark=true

		add(parts,myp)
	end
	big_shwave(expx,expy)
end

function smol_shwave(shx,shy)
	local mysw={}
	mysw.x=shx
	mysw.y=shy
	mysw.r=1
	mysw.tr=5
	mysw.col=9
	mysw.speed=1
	add(shwaves,mysw)
end

function big_shwave(shx,shy)
	local mysw={}
	mysw.x=shx
	mysw.y=shy
	mysw.r=1
	mysw.tr=30
	mysw.col=9
	mysw.speed=3
	add(shwaves,mysw)
end

function smol_spark(sx,sy)
	local myp={}
	myp.x=sx
	myp.y=sy
	myp.sy=(rnd()-1)*3
	myp.sx=(rnd()-0.5)*8
	myp.age=rnd(5)
	myp.size=1+rnd(2)
	myp.maxage=30+rnd(20)
	myp.blue=isblue
	myp.spark=true

	add(parts,myp)
end

function _draw()
	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		-- start screen
		draw_start()
	elseif mode=="splash" then
		draw_splash()
	elseif mode=="wavetext" then
		draw_wavetext()
	elseif mode=="over" then
		draw_over()
	elseif mode=="win" then
		draw_win()
	end
end

function draw_game()
	cls(0)
	starfield()

	if invul<=0 then
		drawspr(ship)
	else
		--invul state
		if sin(t/5)<0.1 then
			drawspr(ship)
		end
	end

	for i=1,#buls do
		local mybul=buls[i]
		drawspr(mybul)
	end
	
	if muzzle>0 then
		circfill(ship.x+3,ship.y-2,muzzle,7)
	end

	-- drawing swaves
	for mysw in all(shwaves) do
		circ(mysw.x,mysw.y,mysw.r,mysw.col)
		mysw.r+=mysw.speed
		if mysw.r>mysw.tr then
			del(shwaves,mysw)
		end
	end
	
	-- drawing explosions
	-- 1. spawn enemies with color/pallatte swaps (pal())
	-- 2. apply flashing to when the player gets hit
	-- 3. bullet explosion on impact
	

	-- drawing particles
	for myp in all(parts) do
		local pc=page_red(myp.age)
		if myp.blue then
			pc=page_blue(myp.age)
		else
			pc=page_red(myp.age)
		end

		if myp.spark then
			pset(myp.x,myp.y,7)
		else
			circfill(myp.x,myp.y,myp.size,pc)
		end
		myp.x+=myp.sx
		myp.y+=myp.sy
		
		myp.sx=myp.sx*0.85
		myp.sy=myp.sy*0.85

		myp.age+=1

		if myp.age>myp.maxage then
			myp.size-=0.5
			if myp.size<0 then				
				del(parts,myp)
			end
		end
	end
	--ui
	print("score: "..score, 30,1,12)
	-- lives
	for i=1,4 do
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
	for myen in all(enemies) do
		if myen.flash>0 then
			myen.flash-=1
			for i=1,15 do
				pal(i, 14)
			end
		end
		drawspr(myen)
		pal()
	end

	animatestars()
end

function page_red(page)
	if page>5 then
		pc=10
	end
	if page>10 then
		pc=9
	end
	if page>15 then
		pc=2
	end
	return pc
end

function page_blue(page)
	if page>5 then
		pc=6
	end
	if page>10 then
		pc=13
	end
	if page>15 then
		pc=1	
	end
	return pc
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

function draw_wavetext()
	draw_game()
	print("wave "..wave,56,40,blink())
end

function draw_win()
	cls(11)
	print("a winner is u!", 30, 40, 12)
	print("press any key to continue", 30, 80, blink())
end

function _update()
	blinkt+=1
	t+=1
	splashcnt+=1
	if mode=="game" then
		-- run game
		update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="splash" then
		update_splash()
	elseif mode=="wavetext" then
		update_wavetext()
	elseif mode=="over" then
		update_over()
	elseif mode=="win" then
		update_win()
	end
end

function update_splash()
	if splashcnt<20 then
		mode="splash"
	else
		mode="wavetext"
		splashcnt=0
	end
	
end

function update_over()
	if btn(4)==false and btn(5)==false then
		btnreleased=true
	end

	if btnreleased then
		if btnp(4) or btnp(5) then
			mode="start"
			splashcnt=0
			btnreleased=false
		end
	end
end

function update_win()
	if btn(4)==false and btn(5)==false then
		btnreleased=true
	end

	if btnreleased then
		if btnp(4) or btnp(5) then
			mode="start"
			splashcnt=0
			btnreleased=false
		end
	end
end

function update_wavetext()
	 update_game()
	 wavetime-=1
	 if wavetime<=0 then
		mode="game"
		spawnwave()
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

	end

	--fire bullet
	if btn(5) then
		if bultimer<=0 then
			local newbul={}
			newbul.x=ship.x
			newbul.y=ship.y-3
			newbul.spr=bulspr
			add(buls,newbul)		
			sfx(0)
			bultimer=6
			muzzle=5
		end
	end
	bultimer-=1
	
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
			spawnen()
		end
	end

	-- collision enemies x bullets
	for myen in all(enemies) do
		for mybul in all(buls) do
			if col(myen,mybul) then
				del(buls, mybul)
				smol_shwave(mybul.x+4, mybul.y+4)
				smol_spark(myen.x+4, myen.y+4)
				myen.hp-=1
				sfx(3)
				myen.flash=5

				if myen.hp<=0 then
					explode(myen.x+4,myen.y+4)
					del(enemies, myen)
					sfx(2)
					score+=100

					if #enemies==0 then
						nextwave()
					end
				end
			end
		end
	end

	-- collision detection
	if invul<=0 then
		for myen in all(enemies) do
			if col(myen,ship) then
				explode(ship.x+4, ship.y+4, true)
				lives-=1
				sfx(1)
				invul=45
				-- del(enemies,myen)
			end
		end
	else
		invul-=1
	end
	-- check if died
	if lives <=0 then
		mode="over"
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000555505555500000055550555550000000555050000000000000000000000000000000000000000000000000000000
00007000700000000000799999900000005665656566550000566565656655000000000000000000000000000000000000000000000000000000000000000000
000000000000700000099aaaaaa97000056888888886650005555555559665000000000000000000000000000000000000000000000000000000000000000000
000099000900000000099aaaaaaa9000556899999988865055655855855996505500000000000050000000000000000000000000000000000000000000000000
0000aaa99a000000009aaaa77aaaa9005689aaa99a9988655669aaa8555955655605556600006665000000000000000000000000000000000000000000000000
0000aa7aaaaa0000009aaa77777aa9005689aa7aaaaa9865566555558a5555655605556655556600000000000000000000000000000000000000000000000000
0000a77777a90000009aa777777aa9005689aa777aa998655655aa55585559655005550055555000000000000000000000000000000000000000000000000000
0000a77777a00000009aa77777aaa9005899aa77aaa9886558858599898589655000066655555000000000000000000000000000000000000000000000000000
00000a7a77a00000009aaa7a777aa9005689aaaaaaa9865556655558558996555006666655555000000000000000000000000000000000000000000000000000
0000070aa00000000099aaaaa7aaa90056899aaaaa99855056659a558a9595505006666655555000000000000000000000000000000000000000000000000000
000070000070000000099aaaaaaa9000568999999998550056699999555555005006665500000000000000000000000000000000000000000000000000000000
0007000000000000000799aaaa990000056888888886650005555aa55aa665000000055500000000000000000000000000000000000000000000000000000000
00000000000000000000099999990000056565556565500005656555656550000000055500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000005550005050000000555000505000000055500050500000000000000000000000000000000000000000000000000000
__sfx__
0001000037050360503405033050310502f050330502b05029050290502605023050220501f05016050190500405017050150500f0500c0500905006050020500105000000000010000000000010000500004000
00030000316302e6302b630236302662021620226201b6201d6201963016630126300462001620000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000256500c6500a6501a650126500e6500865004650026500065000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000121201b120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
