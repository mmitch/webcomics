function keypress(e)
{
        var keynum;
        if(e.which) { keynum = e.which; }// Netscape/Firefox/Opera
        else
        if(window.event) { keynum = e.keyCode; } // IE

        if (keynum == 37) { window.location = document.getElementById("linkprev").href; }
        else
        if (keynum == 39) { window.location = document.getElementById("linknext").href; }
}

