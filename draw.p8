pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

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

	if lives>0 then
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
	
	-- drawing enemies
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

function draw_over()
	draw_game()
	print("game over",48,40,2)
	print("press any key to continue")
end

function draw_win()
	cls(11)
	print("a winner is u!", 30, 40, 12)
	print("press any key to continue", 30, 80, blink())
end