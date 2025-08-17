pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function spawnen(entype,enx,eny)

	local myen=make_spr()
	myen.x=enx
	myen.y=eny-66

	myen.posx=enx
	myen.posy=eny
	
	myen.mission="flyin"

	if entype==nil or entype==1 then
		-- green alien
		myen.spr=20
		myen.hp=3
		myen.ani={20,21,22,23}
	elseif entype==2 then
		-- red flame
		myen.spr=148
		myen.hp=5
		myen.ani={148,149}
	elseif entype==3 then
		-- spinning ship
		myen.spr=184
		myen.hp=5
		myen.ani={184,185,186,187}
	elseif entype==4 then
		-- boss
		myen.spr=208
		myen.hp=5
		myen.ani={208,210}
		myen.sprh=2
		myen.sprw=2
		myen.colh=16
		myen.colw=16
	end
	
	add(enemies,myen)
end

--waves and enemies
function spawnwave()
	if wave==1 then
		placens({
			{1,1,1,1,1,1,1,1,1,0},
			{1,1,1,1,1,1,1,1,1,0},
			{1,1,1,1,1,1,1,1,1,0},
			{1,1,1,1,1,1,1,1,1,0}
		})
	elseif wave==2 then
		placens({
			{1,1,2,2,3,3,2,2,1,1},
			{1,1,2,2,1,1,2,2,1,1},
			{3,1,2,2,1,1,2,2,1,3},
			{2,2,2,2,2,2,2,2,0,2}
		})
	elseif wave==3 then
		placens({
			{1,1,2,2,3,3,2,2,1,1},
			{1,1,2,2,1,1,2,2,1,1},
			{3,1,2,2,1,1,2,2,1,3},
			{2,2,2,2,2,2,2,2,0,2}
		})	-- spawnen(wave)
	elseif wave==4 then
		placens({
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,4,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0}
		})
	end
end

function placens(lvl)
	for y=1,4 do
		local myline=lvl[y]
		for x=1,10 do
			if myline[x]!=0 then
				spawnen(myline[x],x*12-6,4+y*12)
			end
		end
	end
end

function nextwave()
	wave+=1

	if wave>4 then
		mode="win"
		lockout=t+30
	else
		wavetime=80
		mode="wavetext"
	end
end