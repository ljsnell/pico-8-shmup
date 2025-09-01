pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

--bullets
function fire(myen)
	local myebul=make_spr()
	myebul.spr=32
	myebul.x=myen.x
	myebul.y=myen.y
	myebul.ani={32,33,34,33}
	myebul.anispd=0.4
	myebul.sy=1
	add(ebuls,myebul)
end