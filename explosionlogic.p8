pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
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