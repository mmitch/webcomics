<?
    if (isset($comic) && isset($id)) {
	setcookie("lastVisited[$comic]", $id, time()+( 3600 * 24 * 365));
    }
?>

<?
    # Edit these variables for your system.
    #
    # Where are the files stored locally?
    $localpath="/home/mitch/pub/MIRROR";
    #
    # How can the files accessed by http?
    $netpath="/MIRROR";
    #
    # How can this very file be accessed by http?
    $myhref="$netpath/php/index.php";
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Mitchs PHP Comicbrowser</title>
  </head>

  <body>
<!--    <h1>Mitchs PHP Comicbrowser</h1> -->


<?

    # dynamically create $comics array
    $filesfound = popen("find $localpath -type f -name COMIC", "r");
    if ($filesfound) {
    	while (! feof($filesfound)) {

	    # parse COMIC file
	    $file = rtrim(fgets($filesfound, 8192)); # max 8k per line
	    $newcomic = array();
	    $fp = fopen($file, "r");
	    $tag = 0;
	    if ($fp) {
	        while (! feof($fp)) {

		    $line = rtrim(fgets($fp, 8192)); # max 8k per line
		    list($key, $value) = explode(": ", $line, 2);
		    if ($key === "TAG") {
		        $tag = $value;
		    } elseif ($key === "NAME") {
		        $newcomic[name] = $value;
		    } elseif ($key === "HOME") {
		        $newcomic[home] = $value;
		    }
		}

		if ($tag) {
		    $newcomic[file] = dirname($file);
		    $newcomic[href] = str_replace($localpath, $netpath, $newcomic[file]);
		    $comics[$tag] = $newcomic;
		}
		fclose($fp);
	    }
	}
        pclose($filesfound);
    }



if ($comics[$comic]) {

    $me = $comics[$comic];

    #
    # Read whole comic
    #

    $max = 0;

    $fp = fopen("$me[file]/index", "r");
    if ($fp) {
	
	while (! feof($fp)) {
	    $line = fgets($fp, 4096);
	    if (! preg_match('/^\s*$/', $line)) {
		list ($f, $t) = preg_split('/\t/', $line);
		$files[$max] = chop($f);
		$titles[$max] = chop($t);
		$max++;
	    }
	}
	
	if (! fclose($fp)) {
	    echo "<p><b>Error closing index file!</b></p>\n";
	}
	
    } else {
	echo "<p><b>Error opening index file!</b></p>\n";
    }

    if (isset($id)) {

        #
        # Single Image
        #

	if ($id < 0) {
	    $id = 0;
	}

	$premax = $max-1;
	$firstref="$myhref?comic=$comic&id=0";
	$prevref="$myhref?comic=$comic&id=".($id-1);
	$nextref="$myhref?comic=$comic&id=".($id+1);
	$lastref="$myhref?comic=$comic&id=$premax";

	if ($id >= $max) {
	    $id = $premax;
	}

	echo "<h2>$me[name] <small><small>[$id/$premax] [<a href=\"$me[home]\">online]</a></small></small><br>$titles[$id]</h2>\n";

	# upper navigation
	echo "<table><tr><td align=\"left\">";
	if ($id > 0) {
	    echo "<a href=\"$firstref\">[&lt;&lt;]</a>\n";
	    echo "<a href=\"$prevref\">[&lt;]</a>\n";
	}
	echo "<a href=\"$myhref?comic=$comic\">[list]</a>\n";
	echo "<a href=\"$myhref\">[comics]</a>\n";
	if ($id < $premax) {
	    echo "<a href=\"$nextref\">[&gt;]</a>\n";
	    echo "<a href=\"$lastref\">[&gt;&gt;]</a>\n";
	}
	echo "<br>\n";
	
	# picture
	if ($id < $premax) {
	    echo "<a href=\"$nextref\">";
	} else {
	    echo "<a href=\"$myhref\">";
	}
	echo "<img src=\"$me[href]/$files[$id]\" alt=\"$titles[$id]\" title=\"$titles[$id]\" border=\"0\">";
	echo "</a>\n";

	# liner's notes
        $file = preg_replace("/^.*\/([^\/]+)$/", "$1", $files[$id]);
        $file = preg_replace("/\.[^.]*$/", ".htm", $file);
	$file = "$me[file]/$file";

	if ( file_exists($file) ) {
	    $fp = fopen("$file", "r");

	    if ($fp) {
		echo "<p>\n";
		while (! feof($fp)) {
		    echo fgets($fp, 8192); # max 8k per line
		}
		echo "</p>\n";

		if (! fclose($fp)) {
		    echo "<p><b>Error closing liner's notes!</b></p>\n";
		}
	    } else {
		echo "<p><b>Error closing liner's notes!</b></p>\n";
	    }
	}

	# lower navigation
	echo "<br><br>";
	if ($id > 0) {
	    echo "<a href=\"$firstref\">[&lt;&lt;]</a>\n";
	    echo "<a href=\"$prevref\">[&lt;]</a>\n";
	}
	echo "<a href=\"$myhref?comic=$comic\">[list]</a>\n";
	echo "<a href=\"$myhref\">[comics]</a>\n";
	if ($id < $premax) {
	    echo "<a href=\"$nextref\">[&gt;]</a>\n";
	    echo "<a href=\"$lastref\">[&gt;&gt;]</a>\n";
	}
	echo "</td></tr></table>\n";
	

    } else {
	
        #
        # List of one Comic
        # THIS VIEW IS CRAP
	#

	echo "<p><a href=\"$myhref\">[comicliste]</a></p>\n";
	
	echo "<h2>$me[name]</h2>\n";

	$revrev = 1 - $rev;

	echo "<p><a href=\"$myhref?comic=$comic&rev=$revrev\">[reverse]</a></p>\n";

	echo "<ul>\n";

	if ($rev) {
	    for ($i = $max-1; $i >= 0 ; $i--) {
		echo "<li><a href=\"$myhref?comic=$comic&id=$i\">$titles[$i]</a></li>\n";
	    }
	} else {
	    for ($i = 0; $i < $max; $i++) {
		echo "<li><a href=\"$myhref?comic=$comic&id=$i\">$titles[$i]</a></li>\n";
	    }
	}

	echo "</ul>\n";
	
	echo "<p><a href=\"$myhref?comic=$comic&rev=$reverv\">[reverse]</a></p>\n";

    }

} else {

    #
    # List of all Comics
    #

    echo "<h2>Available Comics</h2>\n";
    echo "<ul>\n";

    reset ($comics);
    while ( list ($key, $val) = each($comics) ) {
	if (isset($lastVisited[$key])) {
	    $total = trim(`wc -l < $val[file]/index`) - 1;
	    echo "<li><a href=\"$myhref?comic=$key&id=$lastVisited[$key]\">$val[name]</a>";
	    if ($lastVisited[$key] < $total) {
		echo " (".($total-$lastVisited[$key])." new)";
	    }
	    echo "</li>\n";
	} else {
	    echo "<li><a href=\"$myhref?comic=$key&id=0\">$val[name]</a></li>\n";
	}
    }

    echo "</ul>\n";
}

?>



    <hr>
    <address><a href="mailto:comicbrowser@cgarbs.de">Christian Garbs [Master Mitch]</a></address>
    <p><small>$Revision: 1.34 $<br>$Date: 2005-03-05 00:36:44 $</small></p>
  </body>
</html>
