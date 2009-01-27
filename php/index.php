<?
// 2002-2008 (C) by Christian Garbs <mitch@cgarbs.de>
// licensed under GNU GPL v2 and no later versions

// import configuration
include_once('config.inc');
if ($database) {
  include_once('with_db.inc');
} else {
  include_once('without_db.inc');
}

// import variables (for register_globals=off)
$comic       = $_GET['comic'];
$id          = $_GET['id'];
$recache     = $_GET['recache'];
$tag         = $_GET['tag'];
$rev         = $_GET['rev'];
$user        = $_GET['user'];
$lastVisited = $_COOKIE['lastVisited'];
$username    = $_COOKIE['whoami'];

handle_cookies();

// set charset
header('Content-Type: text/html; charset=utf-8');
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Mitchs PHP Comicbrowser</title>
<?
if ($css) {
  echo "<link rel=\"stylesheet\" href=\"$css\">\n";
}
?>
  </head>
  <body onload="document.getElementById('linknext').focus();" onkeydown="keypress(event);">

<script type="text/javascript">
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
</script>


<?
#echo "<h1>tag=$tag <br>id=$id <br>comic=$comic <br>lV=$lastVisited</h1>";
#echo "<h3>";
#echo serialize($lastVisited);
#echo "</h3>";

function create_cache()
// dynamically create $comics array
{
  global $localpath, $netpath;
  $comics = array();

  $find = popen("find $localpath -type f -name COMIC", "r");
  if ($find) {
    while (! feof($find)) {

      // parse COMIC file
      $file = rtrim(fgets($find, 8192)); // max 8k per line
      $newcomic = array();
      $fp = fopen($file, "r");
      $tag = 0;
      if ($fp) {
	while (! feof($fp)) {

	  $line = rtrim(fgets($fp, 8192)); // max 8k per line
	  list($key, $value) = explode(": ", $line, 2);
	  if ($key === "TAG") {
	    $tag = $value;
	    $newcomic[tag] = $value;
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
    pclose($find);
  }


  sort($comics);

  return $comics;
}

function open_cache()
// read cache
{
  global $cachefile;
  return unserialize( file_get_contents( $cachefile ) );
}

function write_cache($comics)
// save cache
{
  global $cachefile;
  $cache = fopen($cachefile, "w");
  if ($cache) {
    fwrite($cache, serialize($comics));
    fclose($cache);
  }
}

function list_all_comics($comics)
// show a list of all comics
{
  global $lastVisited, $myhref;

  print_login();

  echo "<h2>subscribed comics with unread strips</h2>\n";
  echo "<ul>\n";

  $first = 1;

  reset ($comics);
  $unreadkey = array();
  $unreadcount = array();
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val[tag];
    if (isset($lastVisited[$tag])) {
      $total = trim(`wc -l < $val[file]/index`) - 1;
      if ($lastVisited[$tag] < $total && $lastVisited[$tag] >= 0) {
        array_push($unreadkey, $key);
        array_push($unreadcount, $total-$lastVisited[$tag]);
      }
    }
  }
  array_multisort($unreadcount, $unreadkey);
  while ( list (, $key) = each($unreadkey) ) {
    $unread = array_shift($unreadcount);
    $val = $comics[$key];
    $tag = $val[tag];
    if ($first) {
      echo "<li><a href=\"$myhref?comic=$key&tag=$tag&id=$lastVisited[$tag]\" id=\"linknext\">$val[name]</a>";
      $first = 0;
    } else {
      echo "<li><a href=\"$myhref?comic=$key&tag=$tag&id=$lastVisited[$tag]\">$val[name]</a>";
    }
    echo " ($unread new)";
    echo "</li>\n";
  }

  echo "</ul>\n";

  echo "<h2>new comics</h2>\n";
  echo "<ul>\n";

  reset ($comics);
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val[tag];
    if (! isset($lastVisited[$tag])) {
      echo "<li><a href=\"$myhref?comic=$key&tag=$tag&id=0\">$val[name]</a> ";
      echo "(<a href=\"$myhref?comic=$key&tag=$tag&id=-1\">don't subscribe</a>)";
      echo "</li>\n";
    }
  }

  echo "</ul>\n";

  echo "<h2>subscribed comics, no unread strips</h2>\n";
  echo "<ul>\n";

  $first = 1;

  reset ($comics);
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val[tag];
    if (isset($lastVisited[$tag])) {
      $total = trim(`wc -l < $val[file]/index`) - 1;
      if ($lastVisited[$tag] >= $total) {
	echo "<li><a href=\"$myhref?comic=$key&tag=$tag&id=$lastVisited[$tag]\">$val[name]</a>";
        echo "</li>\n";
      }
    }
  }

  echo "</ul>\n";

  echo "<h2>unsubscribed comics</h2>\n";
  echo "<ul>\n";

  reset ($comics);
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val[tag];
    if (isset($lastVisited[$tag])) {
      if ($lastVisited[$tag] < 0) {
	echo "<li><a href=\"$myhref?comic=$key&tag=$tag&id=0\">$val[name]</a>";
        echo "</li>\n";
      }
    }
  }

  echo "</ul>\n";
  change_login();
  echo "<p><br><small><a href=\"$myhref?recache=1\">rescan comics</a></small></p>\n";
}

function get_index($me)
// read a comic index file
{
  global $max, $files, $titles, $urls;

  $fp = fopen("$me[file]/index", "r");
  if ($fp) {

    while (! feof($fp)) {
      $line = fgets($fp, 4096);  // max 4k per line
      if (! preg_match('/^\s*$/', $line)) {
	list($f, $t) = explode("\t", $line, 2);
	$files[$max] = chop($f);
	if (preg_match('/\t/', $t)) {
	  list($u, $t) = explode("\t", $t, 2);
	  $urls[$max] = chop($u);
	}
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
}

function show_strip($me, $id)
// show a single comic strip
{
  global $comic, $myhref;
  global $max, $files, $titles, $urls;

  if ($id < 0) {
    $id = 0;
  }

  $tag = $me[tag];

  $premax = $max-1;
  $unsubref="$myhref?comic=$comic&tag=$tag&id=-1";
  $firstref="$myhref?comic=$comic&tag=$tag&id=0";
  $prevref="$myhref?comic=$comic&tag=$tag&id=".($id-1);
  $nextref="$myhref?comic=$comic&tag=$tag&id=".($id+1);
  $lastref="$myhref?comic=$comic&tag=$tag&id=$premax";

  if ($id >= $max) {
    $id = $premax;
  }

  echo "<h2>$me[name] <small><small>[$id/$premax] ";
  if ($urls[$id]) {
    echo "[<a href=\"$urls[$id]\">online</a>]";
  } else {
    echo "[<a href=\"$me[home]\">online</a>]";
  }
  echo "</small></small><br>$titles[$id]</h2>\n";

  // upper navigation
  echo "<table><tr><td align=\"left\">";
  if ($id > 0) {
    echo "<a href=\"$firstref\">[&lt;&lt;]</a>\n";
    echo "<a href=\"$prevref\" id=\"linkprev\">[&lt;]</a>\n";
  }
  echo "<a href=\"$myhref?comic=$comic&tag=$tag\">[list]</a>\n";
  if ($id < $premax) {
    echo "<a href=\"$myhref\">[comics]</a>\n";
    echo "<a href=\"$nextref\" id=\"linknext\">[&gt;]</a>\n";
    echo "<a href=\"$lastref\">[&gt;&gt;]</a>\n";
  } else {
    echo "<a href=\"$myhref\" id=\"linknext\">[comics]</a>\n";
  }
  echo "<br>\n";

  // picture
  if ($id < $premax) {
    echo "<a href=\"$nextref\">";
  } else {
    echo "<a href=\"$myhref\">";
  }
  echo "<img src=\"$me[href]/$files[$id]\" alt=\"$titles[$id]\" title=\"$titles[$id]\" border=\"0\">";
  echo "</a>\n";

  // liner's notes
  $file = preg_replace("/^.*\/([^\/]+)$/", "$1", $files[$id]);
  $file = preg_replace("/\.[^.]*$/", ".htm", $file);
  $file = "$me[file]/$file";

  if ( file_exists($file) ) {
    $fp = fopen("$file", "r");

    if ($fp) {
      echo "<p>\n";
      while (! feof($fp)) {
	echo fgets($fp, 8192); // max 8k per line
      }
      echo "</p>\n";

      if (! fclose($fp)) {
	echo "<p><b>Error closing liner's notes!</b></p>\n";
      }
    } else {
      echo "<p><b>Error closing liner's notes!</b></p>\n";
    }
  }

  // lower navigation
  echo "<br><br>";
  if ($id > 0) {
    echo "<a href=\"$firstref\">[&lt;&lt;]</a>\n";
    echo "<a href=\"$prevref\">[&lt;]</a>\n";
  }
  echo "<a href=\"$myhref?comic=$comic&tag=$tag\">[list]</a>\n";
  echo "<a href=\"$myhref\">[comics]</a>\n";
  if ($id < $premax) {
    echo "<a href=\"$nextref\">[&gt;]</a>\n";
    echo "<a href=\"$lastref\">[&gt;&gt;]</a>\n";
  }
  echo "</td></tr><tr><td>\n";
  echo "<small><a href=\"$unsubref\">[unsubscribe]</a></small>\n";
  echo "</td></tr></table>\n";
}

function show_comic($me)
// show a whole comic
// THIS VIEW IS CRAP
{
  global $comic, $myhref, $rev;
  global $max, $files, $titles;

  $revrev = 1 - $rev;
  $tag = $me[tag];

  echo "<p><a href=\"$myhref\">[comicliste]</a></p>\n";
  echo "<h2>$me[name]</h2>\n";
  echo "<p><a href=\"$myhref?comic=$comic&tag=$tag&rev=$revrev\">[reverse]</a></p>\n";
  echo "<ul>\n";

  if ($rev) {
    for ($i = 0; $i < $max; $i++) {
      echo "<li><a href=\"$myhref?comic=$comic&tag=$tag&id=$i\">$titles[$i]</a></li>\n";
    }
  } else {
    for ($i = $max-1; $i >= 0 ; $i--) {
      echo "<li><a href=\"$myhref?comic=$comic&tag=$tag&id=$i\">$titles[$i]</a></li>\n";
    }
  }

  echo "</ul>\n";
  echo "<p><a href=\"$myhref?comic=$comic&rev=$revrev\">[reverse]</a></p>\n";
}


// Einlesen des Caches
$comics = open_cache();
if ((! is_array($comics)) or (isset($recache))) {
  $comics = create_cache();
  write_cache($comics);
  echo "<p>Cache rebuilt.</p>\n";
}

// unsubscribe
if (isset($id) && ($id < 0)) {
  unset($comic, $id, $tag);
}

if ($comics[$comic]) {

  $selected = $comics[$comic];
  $files  = array();
  $titles = array();
  $max = 0;

  get_index($selected);

  if (isset($id)) {
    show_strip($selected, $id);
  } else {
    show_comic($selected);
  }

} else {
    list_all_comics($comics);
}

close_db();

?>

    <hr>
    <address><small>brought to you by the <a href="http://www.cgarbs.de/cgi-bin/gitweb.cgi/webcomics.git">webcomics</a> script</small></address>
  </body>
</html>
