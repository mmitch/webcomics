<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Mitchs PHP Comicbrowser</title>
  </head>

  <body>
    <h1>Mitchs PHP Comicbrowser</h1>


<?
    $myhref="/pub/mitch/MIRROR/php/index.php";
    
    $comics = array("megatokyo" => array(
					 "name" => "Megatokyo",
					 "href" => "/pub/mitch/MIRROR/www.megatokyo.com",
					 "file" => "/home/pub/mitch/MIRROR/www.megatokyo.com"
					 ),
		    "sexylosers" => array (
					 "name" => "Sexy Losers",
					 "href" => "/pub/mitch/MIRROR/www.sexylosers.com",
					 "file" => "/home/pub/mitch/MIRROR/www.sexylosers.com"
					 ),
		    "azumanga" => array (
					 "name" => "Azumanga Daioh",
					 "href" => "/pub/mitch/MIRROR/www.manga-takarajima.mangafan.net",
					 "file" => "/home/pub/mitch/MIRROR/www.manga-takarajima.mangafan.net"
					 ),
		    "userfriendly" => array (
					 "name" => "Userfriendly",
					 "href" => "/pub//mitch/MIRROR/www.userfriendly.org",
					 "file" => "/home/pub/mitch/MIRROR/www.userfriendly.org"
					 ),
		    "freefall" => array (
					 "name" => "Freefall",
					 "href" => "/pub/mitch/MIRROR/www.purrsia.com/freefall",
					 "file" => "/home/pub/mitch/MIRROR/www.purrsia.com/freefall"
					 )
		    );

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
		$files[$max] = $f;
		$titles[$max] = $t;
		$max++;
	    }
	}
	
	if (! fclose($fp)) {
	    echo "<p><b>Error closing index file!</b></p>\n";
	}
	
    } else {
	echo "<p><b>Error opening index file!</b></p>\n";
    }
    
    if ($file) {

        #
        # Single Image   
        #   

	echo "<p><a href=\"$myhref\">[comicliste]</a></p>\n";
	
	echo "<h2>$me[name]</h2>\n";

	echo "<img src=\"$me[href]/$file\">\n";

    } else {
	
        #
        # List of one Comic
        #

	echo "<p><a href=\"$myhref\">[comicliste]</a></p>\n";
	
	echo "<h2>$me[name]</h2>\n";

	$revrev = 1 - $rev;

	echo "<p><a href=\"$myhref?comic=$comic&rev=$revrev\">[reverse]</a></p>\n";

	echo "<ul>\n";

	if ($rev) {
	    for ($i = $max-1; $i >= 0 ; $i--) {
		echo "<li><a href=\"$myhref?comic=$comic&file=$files[$i]\">$titles[$i]</a></li>\n";
	    }
	} else {
	    for ($i = 0; $i < $max; $i++) {
		echo "<li><a href=\"$myhref?comic=$comic&file=$files[$i]\">$titles[$i]</a></li>\n";
	    }
	}

	echo "</ul>\n";
	
	echo "<p><a href=\"$myhref?comic=$comic&rev=$reverv\">[reverse]</a></p>\n";

    }

} else {

    #
    # List of all Comics
    #

    echo "<h2>Liste der Comics</h2>\n";
    echo "<ul>\n";

    reset ($comics);
    while ( list ($key, $val) = each($comics) ) {
#	echo "$key<br>\n";
#	echo "$val[name]<br>\n";
#	echo "$val[href]<br>\n";
#	echo "$val[file]<br>\n";
	
	echo "<li><a href=\"$myhref?comic=$key\">$val[name]</li></a>\n";
    }

    echo "</ul>\n";
}

?>



    <hr>
    <address><a href="mailto:mitch@yggdrasil.mitch.h.shuttle.de">Christian Garbs [Master Mitch]</a></address>
<!-- Created: Sat Jul 20 18:51:57 CEST 2002 -->
<!-- hhmts start -->
Last modified: Sat Jul 20 22:41:17 CEST 2002
<!-- hhmts end -->
  </body>
</html>
