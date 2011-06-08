--- ******************************************************************************************************************** ----
--
-- MovieClip Buttons library from www.infuseddreams.com V0.1
-- Better than using the ui.lua library and also works better with the director class.
-- Shows default and over button images/states, playing a sound on button press.
-- Removes the button listener on touch completion to prevent the director class from crashing between scene transitions
--[[
____________
Features : 
____________

1) Each button can have it's own unique sound effect.

2) The button's touch listener is removed after successful execition of the button press. This prevents crashing and code from getting executed
more times than it is required to.

3) The library handles everything for you so you only have to set up a few variables and the rest is done.

4) Each button can have its own custom function executed for "began" and "released" states.

________
Usage : 
________

Please see included samples (screen1.lua or screen2.lua) or continue reading below

In your main.lua file include these lines : 

local movieclip = require("movieclip")
uiButton = require("buttonLib")

Then you set up buttons like so : 

	newGameBTN = movieclip.newAnim({"newGame.png", "newGame2.png"}) -- The sequence of images : Should contain a default and pressed state image
	newGameBTN.x = display.contentWidth / 2 		-- The x position of the button
	newGameBTN.y = 140 								-- The y position of the button
	newGameBTN.sound = clickSND						-- The pointer to the button sound effect (each button can have it's own unique sound effect
	
	--The Two below variables are not required if you are not using the director class
	newGameBTN.sceneChangesTo = "screen2"					-- The required scene to change to on touch
	newGameBTN.sceneChangesWithEffect = "moveFromRight"		-- The required effects to apply to the scene change
	newGameBTN.beganFunction = newGameBeganFunction		-- The pointer to the custom function to execute on button began state (If any) Optional
	newGameBTN.releasedFunction = newGameReleasedFunction -- The pointer to the custom function to execute on button began state (If any) 
	newGameBTN.removeListenerOnTouch = true  	-- If true the library will automatically remove the event listener for you when it is done.
	
	localGroup:insert(newGameBTN)
	
	--Add the event listener for the button
	newGameBTN:addEventListener("touch", uiButton.handleEvent)
	
After that the library handles everything else for you.

________
Support
________

You can get in touch with me on the corona forums, or alternativly contact me on my site www.retroemu.com or www.infuseddreams.com

--]]
--- ******************************************************************************************************************** ----

module(..., package.seeall)

-- If you are using the director class, leave this value set at true. If you don't use the director class, set it to false
local usingDirector = true

--Function to handle buttons
function handleEvent(event)		
		
	-- Set focus on the button
	display.getCurrentStage():setFocus(event.target)
		
	--Set up button bounds
	local bounds = event.target.contentBounds
	local x, y = event.x, event.y
	local isWithinBounds = 
	bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
		
	if event.phase == "began" then
		--Change the displayed frame to the "Clicked / Down" image
		event.target:nextFrame()
		event.target:stopAtFrame(2)
		
		--If the touch is within the buttons bounds execute required actions
		if isWithinBounds then			
			--If the target has a began function execute it
			if event.target.beganFunction then
				event.target.beganFunction()
			end
		end
			
	elseif event.phase == "ended" then
		--Remove focus from the button
		display.getCurrentStage():setFocus(nil)
		
		--Change the displayed frame to the "Default" image
		event.target:previousFrame()
		event.target:stopAtFrame(1)
		
		--If the touch is within the buttons bounds execute required actions
		if isWithinBounds then			
			--Play the sound upon click (if it exists)
			if event.target.sound then
				audio.play(event.target.sound)
			else
				print("Error : Either the sound doesn't exist or you have not specified a sound to play on touch")
			end
			
			--If the target has a released function execute it
			if event.target.releasedFunction then
				event.target.releasedFunction()
			end
			
			--Remove the button listener to prevent crashing the game upon scene change (when using director class)
			if event.target.removeListenerOnTouch == true then
				event.target:removeEventListener("touch", handleEvent)
			end		
				
			-- Change director scene or execute required action (if using it)
			if usingDirector == true then
				if event.target.sceneChangesTo and event.target.sceneChangesWithEffect then
					director:changeScene(event.target.sceneChangesTo, event.target.sceneChangesWithEffect)
				end
			end
		end
	end
end
	