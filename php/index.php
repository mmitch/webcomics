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

    # old static $comics array was:
#    $comics = array("megatokyo500+" => array(
#					 "name" => "Megatokyo",
#					 "href" => "$netpath/www.megatokyo.com",
#					 "file" => "$localpath/www.megatokyo.com",
#					 "home" => "http://www.megatokyo.com"
#					 ),
		
    # dynamically create $comics array
    $files = popen("find $localpath -type f -name COMIC", "r");
    if ($files) {
    	while (! feof($files)) {

	    # parse COMIC file
	    $file = rtrim(fgets($files, 8192)); # max 8k per line
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
        pclose($files);
    }

    # Because there are so many comics, some of the comic strips have
    # been split up into different subdirectories.  Just make sure the
    # appropriate pictures and a corresponding index file are in the
    # directories.
    #
    # You could also remove the duplicates and put everything into a
    # single directory.


?>

<!-- 		    "sexylosers" => array ( -->
<!-- 					 "name" => "Sexy Losers", -->
<!-- 					 "href" => "$netpath/www.sexylosers.com", -->
<!-- 					 "file" => "$localpath/www.sexylosers.com", -->
<!-- 					 "home" => "http://www.sexylosers.com" -->
<!-- 					 ), -->
<!-- 		    "ctrlaltdel2005" => array ( -->
<!-- 					 "name" => "Ctrl+Alt+Del", -->
<!-- 					 "href" => "$netpath/www.ctrlaltdel-online.com", -->
<!-- 					 "file" => "$localpath/www.ctrlaltdel-online.com", -->
<!-- 					 "home" => "http://www.ctrlaltdel-online.com" -->
<!-- 					 ), -->
<!-- 		    "queenofwands2005" => array ( -->
<!-- 					 "name" => "Queen of Wands", -->
<!-- 					 "href" => "$netpath/www.queenofwands.net", -->
<!-- 					 "file" => "$localpath/www.queenofwands.net", -->
<!-- 					 "home" => "http://www.queenofwands.net" -->
<!-- 					 ), -->
<!-- 		    "w00t2005" => array ( -->
<!-- 					 "name" => "/usr/bin/w00t", -->
<!-- 					 "href" => "$netpath/www.w00t-comic.net", -->
<!-- 					 "file" => "$localpath/www.w00t-comic.net", -->
<!-- 					 "home" => "http://www.w00t-comic.net" -->
<!-- 					 ), -->
<!-- 		    "dilbert" => array ( -->
<!-- 					 "name" => "Dilbert", -->
<!-- 					 "href" => "$netpath/www.dilbert.com", -->
<!-- 					 "file" => "$localpath/www.dilbert.com", -->
<!-- 					 "home" => "http://www.dilbert.com" -->
<!-- 					 ), -->
<!-- 		    "machall200+" => array ( -->
<!-- 					 "name" => "Mac Hall", -->
<!-- 					 "href" => "$netpath/www.machall.com", -->
<!-- 					 "file" => "$localpath/www.machall.com", -->
<!-- 					 "home" => "http://www.machall.com" -->
<!-- 					 ), -->
<!-- 		    "nichtlustig" => array ( -->
<!-- 					 "name" => "Nichtlustig", -->
<!-- 					 "href" => "$netpath/www.nichtlustig.de", -->
<!-- 					 "file" => "$localpath/www.nichtlustig.de", -->
<!-- 					 "home" => "http://www.nichtlustig.de" -->
<!-- 					 ), -->
<!-- 		    "errantstory2005" => array ( -->
<!-- 					 "name" => "Errant Story", -->
<!-- 					 "href" => "$netpath/www.errantstory.com", -->
<!-- 					 "file" => "$localpath/www.errantstory.com", -->
<!-- 					 "home" => "http://www.errantstory.com" -->
<!-- 					 ), -->
<!-- 		    "exploitationnow" => array ( -->
<!-- 					 "name" => "Exploitation Now", -->
<!-- 					 "href" => "$netpath/www.exploitationnow.com", -->
<!-- 					 "file" => "$localpath/www.exploitationnow.com", -->
<!-- 					 "home" => "http://www.exploitationnow.com" -->
<!-- 					 ), -->
<!-- 		    "azumanga" => array ( -->
<!-- 					 "name" => "Azumanga Daioh", -->
<!-- 					 "href" => "$netpath/www.manga-takarajima.mangafan.net", -->
<!-- 					 "file" => "$localpath/www.manga-takarajima.mangafan.net", -->
<!-- 					 "home" => "http://www.manga-takarajima.mangafan.net/azumanga_daiou.htm" -->
<!-- 					 ), -->
<!-- 		    "dorktower" => array ( -->
<!-- 					 "name" => "Dorktower", -->
<!-- 					 "href" => "$netpath/www.dorktower.com", -->
<!-- 					 "file" => "$localpath/www.dorktower.com", -->
<!-- 					 "home" => "http://www.dorktower.com" -->
<!-- 					 ), -->
<!-- 		    "userfriendly" => array ( -->
<!-- 					 "name" => "Userfriendly 2005", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly2004" => array ( -->
<!-- 					 "name" => "Userfriendly 2004", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/2004", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/2004", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly2003" => array ( -->
<!-- 					 "name" => "Userfriendly 2003", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/2003", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/2003", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly2002" => array ( -->
<!-- 					 "name" => "Userfriendly 2002", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/2002", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/2002", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly2001" => array ( -->
<!-- 					 "name" => "Userfriendly 2001", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/2001", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/2001", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly2000" => array ( -->
<!-- 					 "name" => "Userfriendly 2000", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/2000", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/2000", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly1999" => array ( -->
<!-- 					 "name" => "Userfriendly 1999", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/1999", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/1999", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly1998" => array ( -->
<!-- 					 "name" => "Userfriendly 1998", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/1998", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/1998", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "userfriendly1997" => array ( -->
<!-- 					 "name" => "Userfriendly 1997", -->
<!-- 					 "href" => "$netpath/www.userfriendly.org/1997", -->
<!-- 					 "file" => "$localpath/www.userfriendly.org/1997", -->
<!-- 					 "home" => "http://www.userfriendly.org" -->
<!-- 					 ), -->
<!-- 		    "freefall" => array ( -->
<!-- 					 "name" => "Freefall 500-", -->
<!-- 					 "href" => "$netpath/freefall.purrsia.com", -->
<!-- 					 "file" => "$localpath/freefall.purrsia.com", -->
<!-- 					 "home" => "http://freefall.purrsia.com" -->
<!-- 					 ), -->
<!-- 		    "freefallupto500" => array ( -->
<!-- 					 "name" => "Freefall 1-499", -->
<!-- 					 "href" => "$netpath/freefall.purrsia.com/under500", -->
<!-- 					 "file" => "$localpath/freefall.purrsia.com/under500", -->
<!-- 					 "home" => "http://freefall.purrsia.com" -->
<!-- 					 ), -->
<!-- 		    "applegeeks100+" => array ( -->
<!-- 					 "name" => "Apple Geeks", -->
<!-- 					 "href" => "$netpath/www.applegeeks.com", -->
<!-- 					 "file" => "$localpath/www.applegeeks.com", -->
<!-- 					 "home" => "http://www.applegeeks.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade2005" => array ( -->
<!-- 					 "name" => "Penny Arcade", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade2004" => array ( -->
<!-- 					 "name" => "Penny Arcade 2004", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/2004", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/2004", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade2003" => array ( -->
<!-- 					 "name" => "Penny Arcade 2003", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/2003", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/2003", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade2002" => array ( -->
<!-- 					 "name" => "Penny Arcade 2002", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/2002", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/2002", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade2001" => array ( -->
<!-- 					 "name" => "Penny Arcade 2001", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/2001", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/2001", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade2000" => array ( -->
<!-- 					 "name" => "Penny Arcade 2000", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/2000", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/2000", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade1999" => array ( -->
<!-- 					 "name" => "Penny Arcade 1999", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/1999", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/1999", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "penny-arcade1998" => array ( -->
<!-- 					 "name" => "Penny Arcade 1998", -->
<!-- 					 "href" => "$netpath/www.penny-arcade.com/1998", -->
<!-- 					 "file" => "$localpath/www.penny-arcade.com/1998", -->
<!-- 					 "home" => "http://www.penny-arcade.com" -->
<!-- 					 ), -->
<!-- 		    "tsunamichan_anime_parody" => array ( -->
<!-- 					 "name" => "Tsunamichan: Anime Parody", -->
<!-- 					 "href" => "$netpath/tsunamichan.keenspace.com/anime_parody", -->
<!-- 					 "file" => "$localpath/tsunamichan.keenspace.com/anime_parody", -->
<!-- 					 "home" => "http://tsunamichan.keenspace.com/archive/parody.html" -->
<!-- 					 ), -->
<!-- 		    "tsunamichan_experimental_comic_kotone" => array ( -->
<!-- 					 "name" => "Tsunamichan: Experimental Comic Kotone", -->
<!-- 					 "href" => "$netpath/tsunamichan.keenspace.com/experimental_comic_kotone", -->
<!-- 					 "file" => "$localpath/tsunamichan.keenspace.com/experimental_comic_kotone", -->
<!-- 					 "home" => "http://tsunamichan.keenspace.com/archive/kotone.html" -->
<!-- 					 ), -->
<!-- 		    "tsunamichan_guest_strips" => array ( -->
<!-- 					 "name" => "Tsunamichan: Guest Strips", -->
<!-- 					 "href" => "$netpath/tsunamichan.keenspace.com/guest_strips", -->
<!-- 					 "file" => "$localpath/tsunamichan.keenspace.com/guest_strips", -->
<!-- 					 "home" => "http://tsunamichan.keenspace.com/archive/guest.html" -->
<!-- 					 ), -->
<!-- 		    "tsunamichan_katwalk_studio" => array ( -->
<!-- 					 "name" => "Tsunamichan: Katwalk Studio", -->
<!-- 					 "href" => "$netpath/tsunamichan.keenspace.com/katwalk_studio", -->
<!-- 					 "file" => "$localpath/tsunamichan.keenspace.com/katwalk_studio", -->
<!-- 					 "home" => "http://tsunamichan.keenspace.com/archive/katwalk.html" -->
<!-- 					 ), -->
<!-- 		    "tsunamichan_magical_mina" => array ( -->
<!-- 					 "name" => "Tsunamichan: Magical Mina", -->
<!-- 					 "href" => "$netpath/tsunamichan.keenspace.com/magical_mina", -->
<!-- 					 "file" => "$localpath/tsunamichan.keenspace.com/magical_mina", -->
<!-- 					 "home" => "http://tsunamichan.keenspace.com/archive/mina.html" -->
<!-- 					 ), -->
<!-- 		    ); -->

<?

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
    <p><small>$Revision: 1.32 $<br>$Date: 2005-03-05 00:06:20 $</small></p>
  </body>
</html>
