// Copyright (C) 2002-2008,2010,2014   Christian Garbs <mitch@cgarbs.de>
// licensed under GNU GPL v3 or later

// "use strict;"

// Initialization
function init()
{
    document.getElementById('linknext').focus()

    addEventHandler('touchstart', handleTouchStart);
    addEventHandler('touchend', handleTouchEnd);
    addEventHandler('touchleave', handleTouchEnd);
    addEventHandler('touchcancel', handleTouchCancel);
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
    var keynum;

    if ( e.which ) // Netscape/Firefox/Opera
    {
	keynum = e.which;
    }
    else if ( window.event ) // IE
    {
	keynum = e.keyCode;
    } 

    if ( keynum == 37 )
    {
	navigate_prev();
    }
    else if ( keynum == 39 )
    {
	navigate_next();
    }
}


// ****************** Swipe navigation *******************
// very very loosely based on the buggy example from http://stackoverflow.com/a/23230280

var xDown = null;
var yDown = null;

// minimum pixel distance to trigger swipe effect
var xThreshold = 100;
var yThreshold = 100;

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
function handleTouchEnd(evt)
{
    if ( ! xDown || ! yDown )
    {
        return;
    }

    if (evt.changedTouches.length == 0)
    {
	return;
    }

    var xUp = evt.changedTouches[0].clientX
    var yUp = evt.changedTouches[0].clientY;

    var xDiff = xDown - xUp;
    var yDiff = yDown - yUp;

    if ( Math.abs( xDiff ) > Math.abs( yDiff ) ) /*most significant*/
    { 
        if ( xDiff >= xThreshold )
	{
            /* left swipe */
	    navigate_next();
        }
	else if ( xDiff <= -xThreshold )
	{
            /* right swipe */
	    navigate_prev();
        }                       
    }
    else
    {
        if ( yDiff >= yThreshold )
	{
            /* up swipe */
        }
	else if (yDiff <= -yThreshold )
	{ 
            /* down swipe */
	}
    }
    /* reset values */
    handleTouchReset();
}

function handleTouchCancel(evt)
{
    xDown = null;
    yDown = null;
}

function handleTouchMove(evt)
{
    // prevent additional mouse events besides the initial click
    // TODO: check if needed, remove?
    evt.preventDefault();
}

