pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
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
	if t<lockout then
		return
	end

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
	if t<lockout then
		return
	end

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
			local newbul=make_spr()
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
		myen.aniframe+=0.4
		if flr(myen.aniframe)>#myen.ani then
			myen.aniframe=1
		end
		myen.spr=myen.ani[flr(myen.aniframe)]

		if myen.y>128 then			
			del(enemies,myen)
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
		lockout=t+30
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

	-- check if wave is over
	if #enemies==0 and mode=="game" then
		nextwave()
	end
end