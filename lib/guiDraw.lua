local lg=love.graphics
local lp=love.graphics.print
local lf=love.graphics.printf
require "lib/guiData"
require "assets/data/rooms"
require("assets.data.Color")
local font = love.graphics.newFont("assets/font/myfont.ttf", 20)
local text = love.graphics.newText(font,"")
local gui = {}
function guiDraw()
	local color={}
	for i, v in pairs( guiData ) do
		if v.visible and v.type=="txt"then
			gui.text(v)
		elseif v.visible and v.type=="image" then
			gui.image(v)
		elseif v.visible and v.type=="bar" then
			gui.bar(v)
		elseif v.visible and v.type=="long" then
			gui.long(v)
		elseif v.visible and v.type=="dialog" then
			gui.dialog(v)
		elseif v.visible and v.type=="map" then
			gui.map(v)
		elseif v.visible and v.type=="shop" then
			gui.shop(v)
		elseif v.visible and v.type=="skill" then
			gui.skill(v)
		end
	end
end
--  不同的gui部件。
gui.text = function(v)
	local color=Color[v.color] or {255,255,255,255}
	text:set({color,v.contant})
	love.graphics.draw(text,v.x,v.y)
end
gui.image = function(v)
	local dir="assets/graphics/Faces/"
	local image = love.graphics.newImage(dir .. v.image)
	love.graphics.draw(image,v.x,v.y)
end
gui.bar = function(v)
	local maxHP=v["contant"]
	-- lg.print(v["contant"])
	local color=Color[v.color] or {255,255,255,255}
	text:set({color,v.title ..":"})
	love.graphics.draw(text,v.x,v.y)
	bar(maxHP,maxHP,v.x+50,v.y+26)
end
gui.long = function(v)
	local alpha = v.alpha or 128
	local color=Color[v.color] or {255,255,255,255}
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", v.x, v.y, v.width, v.height,10)
	love.graphics.setColor(255, 255, 255, 255)
	text:setf({color,v.contant},v.width,"left")
	love.graphics.draw(text,v.x,v.y)
end
gui.dialog = function(v)
	local dir="assets/graphics/Faces/"
	local image = love.graphics.newImage(dir .. v.image)
	love.graphics.draw(image,v.x-image:getWidth(),v.y)
	local alpha = v.alpha or 128
	local color=Color[v.color] or {255,255,255,255}
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", v.x, v.y, v.width, v.height,10)
	love.graphics.setColor(255, 255, 255, 255)
	text:setf({color,v.contant},v.width,"left")
	love.graphics.draw(text,v.x,v.y)
end
gui.map = function(v)
	local alpha = v.alpha or 128
	local color=Color[v.color] or {255,255,255,255}
	love.graphics.print(v.title or "地图", v.x, v.y)
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", v.x, v.y+20, v.width, v.height,10)
	love.graphics.setColor(255, 255, 255, 255)
end
gui.shop = function(v)

	local alpha = v.alpha or 200
	local color=Color[v.color] or {255,255,255,255}
	-- 底色
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", v.x, v.y, v.width, v.height,10)
	-- 边框
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line",v.x,v.y,v.width,v.height/4,10)
	love.graphics.rectangle("line",v.x,v.y,100,v.height/4,10)
	love.graphics.rectangle("line",v.x,v.y+100,v.width,v.height/4,10)
	love.graphics.rectangle("line",v.x,v.y+200,v.width,v.height/4,10)
	love.graphics.rectangle("line",v.x,v.y+300,v.width,v.height/4,10)
	-- 文字信息
	--love.graphics.setColor(255,255,255,255)
	love.graphics.print(v.title or "商铺", v.x+108, v.y)
	-- 图片 头像、物品图标
	local dir="assets/graphics/Faces/"
	local image = love.graphics.newImage(dir .. "41.png")
	love.graphics.draw(image,v.x+7,v.y+7)
end
gui.skill = function(v)
	local alpha = v.alpha or 128
	local color=Color[v.color] or {255,255,255,255}
	love.graphics.setColor(255, 255, 255, alpha)
	love.graphics.rectangle("fill", v.x, v.y, v.width, v.height,10)
	love.graphics.setColor(255, 255, 255, 255)
	text:setf({color,v.contant},v.width,v.align)
	love.graphics.draw(text,v.x,v.y+4)
end

--  table data
function guiUpdata(actor,dt)
	guiData["头像"].image=actor.faceImg
	-- guiData["姓名"].contant=actor["姓名"]
	-- guiData["名称"].contant=actor["名称"]
	guiData["名称"].contant=actor.name
	guiData["称号"].contant=actor.epithet
	guiData["世家"].contant=actor.clan

	-- gui["身份"].contant=actor["身份"]
	guiData["气血"].contant=actor.hp
	guiData["真气"].contant=actor.mp
	guiData["区域"].contant=actor.region
	guiData["地图"].title=actor.region
	guiData["房间"].contant=actor.room
	local text = string.format("%d:%d",actor.x,actor.y)
	guiData["坐标"].contant =  text
	if rooms[actor.room] and #actor.room>2 then
		guiData["描述"].contant=rooms[actor.room]["description"]
	else
		guiData["描述"].contant=""
	end

	guiData["对话"].image=actor.faceImg
	guiData["商铺"].image = actor.faceImg
	guiData["发现"].contant=actor.target
	guiData["信息"].contant="测试信息测试信息"

	-- gui["精力"].contant=actor["精力"]
	-- gui["食物"].contant=actor["食物"]
	-- gui["饮水"].contant=actor["饮水"]
end
-- rec eg.hp,mp
function bar(nowHP,maxHP,x,y)
	love.graphics.rectangle("line",x,y-16,100,8)
	local nowHP = math.max(0,nowHP)
	local color = {r=255-nowHP*255/maxHP,g=nowHP*255/maxHP,b=0,a=255}
	love.graphics.setColor(color.r,color.g,color.b,color.a)
	love.graphics.rectangle("fill",x,y-16,nowHP*100/maxHP,8)
	love.graphics.setColor(255,255,255,255)
end
-- tonumber
