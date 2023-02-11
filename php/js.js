// Copyright (C) 2002-2008,2010,2014   Christian Garbs <mitch@cgarbs.de>
// licensed under GNU GPL v3 or later

// "use strict;"

// Initialization
function init()
{
    var elementToFocus = document.getElementById('linknext');
    if (elementToFocus) {
	elementToFocus.focus()
    }

    addEventHandler('touchstart', handleTouchStart);
    addEventHandler('touchmove', handleTouchMove);
    addEventHandler('keydown', keypress);
}

// Cross-Browser event handling
function addEventHandler(eventType, handler)
{
    var element = document;
    if (element.addEventListener) // sane browsers
    {
	element.addEventListener(eventType, handler, false);
    }
    else if (element.attachEvent) // IE < 10
    {
	element.attachEvent('on'+eventType, handler);
    }
}

// Navigation commands
function navigate_prev()
{
    window.location = document.getElementById("linkprev").href;
}

function navigate_next()
{
    window.location = document.getElementById("linknext").href;
}

// Keyboard navigation
function keypress(e)
{
    switch (e.key) {
    case "ArrowLeft":
    case "a":
	navigate_prev();
	break;

    case "ArrowRight":
    case "d":
	navigate_next();
	break;
    }
}


// ****************** Swipe navigation *******************
// based on the example from http://stackoverflow.com/a/23230280

var xDown = null;
var yDown = null;

// remember start position of swipe
function handleTouchStart(evt)
{
    if (evt.touches.length > 0)
    {
	xDown = evt.touches[0].clientX;
	yDown = evt.touches[0].clientY;
    }
}

// check end position of swipe
function handleTouchMove(evt)
{
    if ( ! xDown || ! yDown )
    {
        return;
    }

    if (evt.touches.length == 0)
    {
	return;
    }

    var xUp = evt.touches[0].clientX
    var yUp = evt.touches[0].clientY;

    var xDiff = xDown - xUp;
    var yDiff = yDown - yUp;

    if ( Math.abs( xDiff ) > Math.abs( yDiff ) ) /*most significant*/
    { 
        if ( xDiff > 0 )
	{
            /* left swipe */
	    navigate_next();
        }
	else
	{
            /* right swipe */
	    navigate_prev();
        }                       
    }
    else
    {
        if ( yDiff > 0 )
	{
            /* up swipe */
        }
	else
	{ 
            /* down swipe */
	}
    }
    /* reset values */
    xDown = null;
    yDown = null;
}

