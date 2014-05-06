// Copyright (C) 2002-2008,2010,2014   Christian Garbs <mitch@cgarbs.de>
// licensed under GNU GPL v3 or later

function keypress(e)
{
    var keynum;

    if (e.which) // Netscape/Firefox/Opera
    {
	keynum = e.which;
    }
    else if (window.event) // IE
    {
	keynum = e.keyCode;
    } 

    if (keynum == 37)
    {
	window.location = document.getElementById("linkprev").href;
    }
    else if (keynum == 39)
    {
	window.location = document.getElementById("linknext").href;
    }
}
