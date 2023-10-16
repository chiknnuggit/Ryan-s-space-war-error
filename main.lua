--	Space War 1.0
--  author : Debugger
--  developed using : lua + lovve 2d 
--  
--  github repo link: https://github.com/bhattsameer/space-war
--
--  Licence = MIT

local math = require 'math'
require 'conf'

local score = 0
local t = 0
-- love is one of the category in github site and the graphics are the images that are obtained from that love category section,
-- and i think the getdefaultFilter(nearest, nearest) mean to basically get those images like enemy.png into this script
love.graphics.getDefaultFilter('nearest','nearest')
-- these are table basically made for the enemies that will be added
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}

-- load enemy image
enemies_controller.image = love.graphics.newImage('graphics/enemy.png')

--
--particle_systems = {}
--particle_systems.list = {}
--particle_systems.image = love.graphics.newImage('graphics/enemy_particle.png')
--local ps = {}
--function particle_systems:spawn(x, y)

--  ps.ps = love.graphics.newParticleSystem(particle_systems.image, 32)
--	ps.x = x
--	ps.y = y
--	ps.ps:setParticleLifetime(2,4)
--	ps.ps:setEmissionRate(5)
--	ps.ps:setSizeVariation(1)
--	ps.ps:setLinearAcceleration(-20, -20, 20, 20)
--	ps.ps:setColors(100,255,100, 255, 0, 255, 0, 255)
--	table.insert(particle_systems.list, ps)
--end

--function particle_systems:draw()
--	for _, v in pairs(particle_systems.list) do
--		love.graphics.draw(v.ps, v.x, v.y)
--	end
--end

--function particle_systems:update(dt)
--	for _, v in pairs(particle_systems.list) do
--		v.ps:update(dt)
--	end
--end
name = 1
-- this is function to basically check if the bullet hit the enemy, and if it did, it'll do the following command
function checkCollisions(enemies, bullets)
	-- this is basically making the variable explosion to have this audio called sound/explosion mp3
	explosion = love.audio.newSource('sound/explosion.mp3', 'stream')
	for i, e in ipairs(enemies) do
		for j, b in pairs(bullets) do
			if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
				love.audio.play(explosion)
				--particle_systems:spawn(e.x, e.y)
				table.remove(enemies, i)
				table.remove(bullets, j)
				score = score + 1
				-- more enemies
				if score < 490 then	
					w = math.random(0, 700)
					enemies_controller:spawnEnemy(w , 0)
				end

				-- boss
				if score == 10 then
					enemies_controller.image = love.graphics.newImage('graphics/enemy_particle.png')
					for i=1,10 do
						enemies_controller:spawnEnemy(i*75,0)
						enemies_controller:spawnEnemy(i*75,35)
						enemies_controller:spawnEnemy(i*75,70)
						enemies_controller:spawnEnemy(i*75,105)
						enemies_controller:spawnEnemy(i*75,140)
					end
				end
			end
		end
	end
end

function love.load()
	--	x = 0
	--	y = 0
	-- game music
	local game_music = love.audio.newSource('sound/game_music.mp3', 'stream')
	game_music:setLooping(true)
	love.audio.play(game_music)
	game_over = false
	game_win = false
	backgroundImage = love.graphics.newImage('graphics/starfield.png')
	--player and fire details
	player = {}
	dragging = {}
	player.x = 0
	player.y = 550
	player.width = 110
	player.height = 110
	dragging.active = false
	dragging.x = 0
	dragging.y = 0
	player.bullets = {}
	player.cooldown = 20
	player.speed = 10
	
	--load player image
	player.image = love.graphics.newImage('graphics/player.png')
	player.fire_sound = love.audio.newSource('sound/laser_gun.wav', 'stream')
	player.fire = function()
		if player.cooldown <= 0 then
			love.audio.play(player.fire_sound)
			player.cooldown = 1
			bullet = {}
			bullet.x = player.x + 11.5
			bullet.y = player.y
			table.insert(player.bullets, bullet)
		end
	end
	
	-- S
	--enemies_controller:spawnEnemy(160 ,  40)   -- e.h = 20 e.w= 40
	--enemies_controller:spawnEnemy(160 ,  10)
	--enemies_controller:spawnEnemy(120,  10)
	--enemies_controller:spawnEnemy(80 ,  10)
	--enemies_controller:spawnEnemy(80 ,  10)
	--enemies_controller:spawnEnemy(80 ,  40)
	--enemies_controller:spawnEnemy(80 ,  80)
	--enemies_controller:spawnEnemy(120 , 100)
	--enemies_controller:spawnEnemy(160 , 105)
	--enemies_controller:spawnEnemy(160 , 145)
	--enemies_controller:spawnEnemy(160 , 180)
	--enemies_controller:spawnEnemy(120 , 180)
	--enemies_controller:spawnEnemy(80 , 180)
	--enemies_controller:spawnEnemy(80 ,  140)
	
	
	for i = 0, 10 do
		enemies_controller:spawnEnemy(i * 75 , 0)
		--enemies_controller:spawnEnemy(i * 75 , 40)
	end
end
-- this is for controlling the property of enemies like their size and their speed and where they're at
function enemies_controller:spawnEnemy(x, y)
	enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.width = 40
 	enemy.height = 20  
	enemy.bullets = {}
	enemy.cooldown = 1
	enemy.speed = 2
	table.insert(self.enemies, enemy)
end
-- function target is set to enemy
function enemy:fire()
	if self.cooldown <= 0 then
		self.cooldown = 20
		bullet = {}
		bullet.x = self.x + 35
		bullet.y = self.y
		table.insert(self.bullets, bullet)
	end
end
-- this is for updating the look of the game, like when it wins or loses or when bullet gets fired
function love.update(dt)
	player.cooldown = player.cooldown - 1
	
	--keyboard process
	if love.keyboard.isDown('right') then
		--x = x + 1 
		if player.x < 760.5 then
			player.x = player.x + player.speed
		end
	end
	if love.keyboard.isDown('left') then
		--x = x - 1
		if player.x > 0 then
			player.x = player.x - player.speed
		end
	end
	--if love.keyboard.isDown('up') then
	--	if player.y > 0 then
	--		player.y = player.y - player.speed
	--	end
	--end
	--if love.keyboard.isDown('down') then
	--	if player.y < 550 then
	--		player.y = player.y + player.speed
	--	end
	--end

	-- mouse controller

	if dragging.active then
		if player.x > 0  or player.x < 760.5 then
			player.x = (love.mouse.getX() - dragging.x) - player.speed
		end
		if player.y > 0 or player.y < 550 then
			player.y = (love.mouse.getY() - dragging.y) - player.speed
		end
	end

--	if love.keyboard.isDown("space") then
	if game_over == false then		
    	player.fire()
    end
--	end
-- this is for when enemy count = 0, game win
	if #enemies_controller.enemies == 0 then
		game_win = true
	end
-- this is when enemy touch the bottom of screen
	for _,e in pairs(enemies_controller.enemies) do
		if e.y >= love.graphics.getHeight()/2 + 215 then
			game_over = true
		end
		e.y = e.y + 1 * e.speed
	end
-- if player bullet go high up where it can't be seen on screen, it gets removed
	for i,b in ipairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end
		b.y =b.y - 10
	end
	
	checkCollisions(enemies_controller.enemies, player.bullets)
end

function love.draw()
	--draw background
	love.graphics.draw(backgroundImage)
	
	-- font size
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)
	-- score board
	love.graphics.print('Your score: ' ..score, 340, 583)

	-- win - loose statements 
	if game_over then
		love.graphics.print('Game Over!', 340, 10)
		love.graphics.setColor(0,255,0)-- setting color to green
		love.graphics.rectangle("fill", 300, 200, 200, 50)
		love.graphics.setColor(255,255,255)-- setting color back to white
		love.graphics.print('Restart?', 370, 220)
		return
	elseif game_win then
		love.graphics.print('You Won!', 340, 10)
		love.graphics.setColor(0,255,0)-- setting color to green
		love.graphics.rectangle("fill", 300, 200, 200, 50)
		love.graphics.setColor(255,255,255)-- setting color back to white
		love.graphics.print('Restart?', 370, 220)
	end
	
	-- draw player
	love.graphics.setColor(255,255,255)
	love.graphics.draw(player.image, player.x, player.y)
	
	--draw enemies
	love.graphics.setColor(255,255,255)
	for _,e in pairs(enemies_controller.enemies) do
		love.graphics.draw(enemies_controller.image, e.x, e.y)
	end
	
	--draw fire
	love.graphics.setColor(255,255,255)
	for _,v in pairs(player.bullets) do
		love.graphics.rectangle("fill", v.x, v.y, 10, 10)
	end
end

-- this is for dragging the shooting ship
function love.mousepressed(x, y, button, istouch)
	if game_over or game_win then
		if button == 1 and x > 300 and x < 500 and y > 200 and y < 250 then
			restartGame()
		end
	elseif button == 1 and x > player.x and x < player.x + player.width and y < player.y + player.height then
		dragging.active = true
		dragging.x = x - player.x 
		dragging.y = y - player.y
	end
end

function restartGame()
	player.x = 0
	player.y = 550
	score = 0
	enemies_controller.enemies = {}
	game_over = false
	game_win = false

	-- spawning initial enemies ( you can adjust this as per your requirement)
	for i = 0, 10 do
		enemies_controller:spawnEnemy(i * 75, 0)
	end
end
-- this is for not being able to move the shooting ship if the mouse is released from being held
function love.mousereleased(x, y, button)
	if button == 1 then
		dragging.active = false
	end
end

