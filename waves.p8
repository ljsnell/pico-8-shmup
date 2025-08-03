pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function spawnen(entype)

	local myen=make_spr()
	myen.x=rnd(120)
	myen.y=-8

	if entype==nil or entype==1 then
		-- green alien
		myen.spr=20
		myen.hp=5
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
	spawnen(wave)
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