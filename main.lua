local Fluid = require("fluid").init({
   useEvents = true
})
local Entity    = Fluid.entity
local Component = Fluid.component
local System    = Fluid.system

local Game = Fluid.instance()
Fluid.addInstance(Game)

local Position = Component(function(e, x, y)
   e.x = x
   e.y = y
end)

local Rectangle = Component(function(e, w, h)
   e.w = w
   e.h = h
end)

local Circle = Component(function(e, r)
   e.r = r
end)

local Color = Component(function(e, r, g, b, a)
   e.r = r
   e.g = g
   e.b = b
   e.a = a
end)

local RectangleRenderer = System({Position, Rectangle})
function RectangleRenderer:draw()
   for _, e in ipairs(self.pool.numerical) do
      local position  = e:get(Position)
      local rectangle = e:get(Rectangle)
      local color     = e:get(Color)

      love.graphics.setColor(255, 255, 255)
      if color then
         love.graphics.setColor(color.r, color.g, color.b, color.a)
      end

      love.graphics.rectangle("fill", position.x, position.y, rectangle.w, rectangle.h)
   end
end

local CircleRenderer = System({Position, Circle})
function CircleRenderer:draw()
   for _, e in ipairs(self.pool.numerical) do
      local position = e:get(Position)
      local circle   = e:get(Circle)
      local color    = e:get(Color)

      love.graphics.setColor(255, 255, 255)
      if color then
         love.graphics.setColor(color.r, color.g, color.b, color.a)
      end

      love.graphics.circle("fill", position.x, position.y, circle.r)
   end
end

local RandomRemover = System({})
RandomRemover.time = 0

function RandomRemover:update(dt)
   RandomRemover.time = RandomRemover.time + dt

   if RandomRemover.time >= 0.125 then
      RandomRemover.time = 0

      if self.pool.size > 0 then
         local i = love.math.random(1, self.pool.size)

         Game:removeEntity(self.pool.numerical[i])
      end
   end
end

Game:addSystem(RandomRemover, "update")
Game:addSystem(RectangleRenderer, "draw")
Game:addSystem(CircleRenderer, "draw")

for i = 1, 50 do
   local e = Entity()
   e:give(Position, love.math.random(0, 700), love.math.random(0, 700))
   e:give(Rectangle, love.math.random(5, 20), love.math.random(5, 20))

   if love.math.random(0, 1) == 0 then
      e:give(Color, love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255), 255)
   end

   Game:addEntity(e)
end

for i = 1, 50 do
   local e = Entity()
   e:give(Position, love.math.random(0, 700), love.math.random(0, 700))
   e:give(Circle, love.math.random(5, 20))

   if love.math.random(0, 1) == 0 then
      e:give(Color, love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255), 255)
   end

   Game:addEntity(e)
end