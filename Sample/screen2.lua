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

-- Main function - MUST return a display.newGroup()
function new()
	local localGroup = display.newGroup()
	
	-- Background
	local background = display.newImage("background.png")
	localGroup:insert(background)
	
	local clickSND = audio.loadSound("click.wav")
	
	-- Back Button
	local backBTN = movieclip.newAnim({"back.png", "back2.png"})
	backBTN.x = 240
	backBTN.y = 280
	localGroup:insert(backBTN)
	
	--- ********************************************************* ---
	---							BUTTONS							  ---	
	--- ********************************************************* ---
	
	-->> Set Up "Back" Button with required variables
	
	--Custom function to execute on began press state
	local function backBeganFunction()
		print("Back Began State Executed")
	end
	
	--Custom function to execute on released press state
	local function backReleasedFunction()
		print("Back Released State Executed")
	end
	
	backBTN = movieclip.newAnim({"back.png", "back2.png"}) -- The sequence of images : Should contain a default and pressed state image
	backBTN.x = display.contentWidth / 2 			-- The x position of the button
	backBTN.y = 280 								-- The y position of the button
	backBTN.sound = clickSND						-- The pointer to the button sound effect (each button can have it's own unique sound effect
	backBTN.beganFunction = backBeganFunction       -- The pointer to the custom function to execute on button began state (If any) Optional
	backBTN.releasedFunction = backReleasedFunction -- The pointer to the custom function to execute on button began state (If any) Optional
	backBTN.removeListenerOnTouch = true            -- If true the library will automatically remove the event listener for you when it is done.
	--Sometimes you may not want this behavior and wish to remove the listener yourself at thee appropraiate place.
	
	--The Two below variables are not required if you are not using the director class
	backBTN.sceneChangesTo = "screen1"				-- The required scene to change to on touch
	backBTN.sceneChangesWithEffect = "crossfade"	-- The required effects to apply to the scene change

	localGroup:insert(backBTN)

	backBTN:addEventListener("touch", uiButton.handleEvent)		
	
	-- MUST return a display.newGroup()
	return localGroup
end
