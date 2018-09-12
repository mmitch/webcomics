<?php
// Copyright (C) 2002-2008,2010,2014-2015   Christian Garbs <mitch@cgarbs.de>
// licensed under GNU GPL v3 or later

// import configuration
include_once('config.inc');
if ($database) {
  include_once('with_db.inc');
} else {
  include_once('without_db.inc');
}

// import variables (for register_globals=off)
//
// DIRTY HACK(?) AHEAD!
//
// As we do this only for shorter, cleaner code ($foo instead of $_GET['foo'])
// and the code below uses isset($foo) and expects these to be unset sometime,
// we take the crappy short route and ignore the "Undefined index" notices by
// throwing away ALL errors (using @).
// This should not be a security problem because there are no deeper checks
// anyway.  And something like this would be totally nuts:
// if (isset($_GET['foo']) { $foo = $_GET['foo'] } else { unset $foo };
$comic       = @$_GET['comic'];
$id          = @$_GET['id'];
$recache     = @$_GET['recache'];
$tag         = @$_GET['tag'];
$rev         = @$_GET['rev'];
$user        = @$_GET['user'];
$startid     = @$_GET['startid'];
$lastVisited = @$_COOKIE['lastVisited'];
$username    = @$_COOKIE['whoami'];

handle_cookies();

// set charset
header('Content-Type: text/html; charset=utf-8');
?>

<!DOCTYPE html>
<html>
  <head>
    <title>Mitchs PHP Comicbrowser</title>
    <meta charset="UTF-8">
<?php
if ($css) {
  echo "    <link rel=\"stylesheet\" href=\"$css\">\n";
}
?>
    <script src="js.js"></script>
  </head>
  <body onload="init();">
<?php
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
	    $newcomic['tag'] = $value;
	  } elseif ($key === "NAME") {
	    $newcomic['name'] = $value;
	  } elseif ($key === "HOME") {
	    $newcomic['home'] = $value;
	  }
	}
	
	if ($tag) {
	  $newcomic['file'] = dirname($file);
	  $newcomic['href'] = str_replace($localpath, $netpath, $newcomic['file']);
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

  echo "<section>";
  echo "<h2>subscribed comics with unread strips</h2>\n";
  echo "<ul>\n";

  $first = ' id="linknext"';

  reset ($comics);
  $unreadkey = array();
  $unreadcount = array();
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val['tag'];
    if (isset($lastVisited[$tag])) {
      $filename = $val['file'].'/index';
      $total = trim(`wc -l < $filename`) - 1;
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
    $tag = $val['tag'];
    printf('<li><a href="%s?comic=%s&amp;tag=%s&amp;id=%s"%s>%s</a>',
	   $myhref, $key, $tag, $lastVisited[$tag], $first, $val['name']);
    $first = '';
    echo " ($unread new)";
    if ($unread > 1) {
      if ($unread <= 32) {
	printf(' <small><a href="%s?comic=%s&amp;tag=%s&amp;id=%s&amp;startid=%s">show all new</a></small>',
	       $myhref, $key, $tag, ($lastVisited[$tag] + $unread), $lastVisited[$tag]);
      } else {
	printf(' <small><a href="%s?comic=%s&amp;tag=%s&amp;id=%s&amp;startid=%s">show next 32</a></small>',
	       $myhref, $key, $tag, ($lastVisited[$tag] + 32), $lastVisited[$tag]);
      }
    }
    echo "</li>\n";
  }

  echo "</ul>\n";
  echo "</section>";

  echo "<section>";
  echo "<h2>new comics</h2>\n";
  echo "<ul>\n";

  reset ($comics);
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val['tag'];
    if (! isset($lastVisited[$tag])) {
      printf('<li><a href="%s?comic=%s&amp;tag=%s&amp;id=0">%s</a> ',
	     $myhref, $key, $tag, $val['name']);
      echo "(<a href=\"$myhref?comic=$key&amp;tag=$tag&amp;id=-1\">don't subscribe</a>)";
      echo "</li>\n";
    }
  }

  echo "</ul>\n";
  echo "</section>";

  echo "<section>";
  echo "<h2>subscribed comics, no unread strips</h2>\n";
  echo "<ul>\n";

  $first = 1;

  reset ($comics);
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val['tag'];
    if (isset($lastVisited[$tag])) {
      $filename = $val['file'].'/index';
      $total = trim(`wc -l < $filename`) - 1;
      if ($lastVisited[$tag] >= $total) {
	printf('<li><a href="%s?comic=%s&amp;tag=%s&amp;id=%s">%s</a>',
	       $myhref, $key, $tag, $lastVisited[$tag], $val['name']);
        echo "</li>\n";
      }
    }
  }

  echo "</ul>\n";
  echo "</section>";

  echo "<section>";
  echo "<h2>unsubscribed comics</h2>\n";
  echo "<ul>\n";

  reset ($comics);
  while ( list ($key, $val) = each($comics) ) {
    $tag = $val['tag'];
    if (isset($lastVisited[$tag])) {
      if ($lastVisited[$tag] < 0) {
	printf('<li><a href="%s?comic=%s&amp;tag=%s&amp;id=0">%s</a>',
	       $myhref, $key, $tag, $val['name']);
        echo "</li>\n";
      }
    }
  }

  echo "</ul>\n";
  echo "</section>";
  change_login();
  echo "<section><br><small><a href=\"$myhref?recache=1\">rescan comics</a></small></section>\n";
}

function get_index($me)
// read a comic index file
{
  global $max, $files, $titles, $urls;

  $filename = $me['file'].'/index';
  $fp = fopen($filename, "r");
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

  $tag = $me['tag'];

  $premax = $max-1;
  $unsubref="$myhref?comic=$comic&amp;tag=$tag&amp;id=-1";
  $firstref="$myhref?comic=$comic&amp;tag=$tag&amp;id=0";
  $prevref="$myhref?comic=$comic&amp;tag=$tag&amp;id=".($id-1);
  $nextref="$myhref?comic=$comic&amp;tag=$tag&amp;id=".($id+1);
  $lastref="$myhref?comic=$comic&amp;tag=$tag&amp;id=$premax";

  if ($id >= $max) {
    $id = $premax;
  }

  echo "<article>";
  printf('<h2>%s <small><small>[%s/%s] ',
	 $me['name'], $id, $premax);
  printf('[<a href="%s">online</a>]',
	 $urls[$id] ? $urls[$id] : $me['home']);
  printf("</small></small><br>%s</h2>\n",
	 $titles[$id]);

  // upper navigation
  echo "<nav>";
  if ($id > 0) {
    echo "<a href=\"$firstref\">[&lt;&lt;]</a>\n";
    echo "<a href=\"$prevref\" id=\"linkprev\">[&lt;]</a>\n";
  }
  echo "<a href=\"$myhref?comic=$comic&amp;tag=$tag\">[list]</a>\n";
  if ($id < $premax) {
    echo "<a href=\"$myhref\">[comics]</a>\n";
    echo "<a href=\"$nextref\" id=\"linknext\">[&gt;]</a>\n";
    echo "<a href=\"$lastref\">[&gt;&gt;]</a>\n";
  } else {
    echo "<a href=\"$myhref\" id=\"linknext\">[comics]</a>\n";
  }
  echo "</nav>\n";

  // picture
  if ($id < $premax) {
    echo "<a href=\"$nextref\">";
  } else {
    echo "<a href=\"$myhref\">";
  }
  printf('<img src="%s/%s" alt="%s" title="%s" border="0">',
	 $me['href'], $files[$id], $titles[$id], $titles[$id]);
  echo "</a>\n";

  // liner's notes
  $file = preg_replace("/^.*\/([^\/]+)$/", "$1", $files[$id]);
  $file = preg_replace("/\.[^.]*$/", ".htm", $file);
  $file = $me['file'].'/'.$file;

  if ( file_exists($file) ) {
    $fp = fopen("$file", "r");

    if ($fp) {
      echo "<section>\n";
      while (! feof($fp)) {
        echo fgets($fp, 8192); // max 8k per line
      }
      echo "</section>\n";

      if (! fclose($fp)) {
        echo "<p><b>Error closing liner's notes!</b></p>\n";
      }
    } else {
      echo "<p><b>Error closing liner's notes!</b></p>\n";
    }
  }

  // lower navigation
  echo "<nav><br>";
  if ($id > 0) {
    echo "<a href=\"$firstref\">[&lt;&lt;]</a>\n";
    echo "<a href=\"$prevref\">[&lt;]</a>\n";
  }
  echo "<a href=\"$myhref?comic=$comic&amp;tag=$tag\">[list]</a>\n";
  echo "<a href=\"$myhref\">[comics]</a>\n";
  if ($id < $premax) {
    echo "<a href=\"$nextref\">[&gt;]</a>\n";
    echo "<a href=\"$lastref\">[&gt;&gt;]</a>\n";
  }
  echo "</nav>\n";
  echo "<section><small><a href=\"$unsubref\">[unsubscribe]</a></small></section>\n";
  echo "</article>";
}

function show_comic($me)
// show a whole comic
// THIS VIEW IS CRAP
{
  global $comic, $myhref, $rev;
  global $max, $files, $titles;

  $revrev = 1 - $rev;
  $tag = $me['tag'];

  echo "<section>";
  echo "<p><a href=\"$myhref\">[comicliste]</a></p>\n";
  printf("<h2>%s</h2>\n",
	 $me['name']);
  echo "<nav><a href=\"$myhref?comic=$comic&amp;tag=$tag&amp;rev=$revrev\">[reverse]</a></nav>\n";
  echo "<ul>\n";

  if ($rev) {
    for ($i = 0; $i < $max; $i++) {
      echo "<li><a href=\"$myhref?comic=$comic&amp;tag=$tag&amp;id=$i\">$titles[$i]</a></li>\n";
    }
  } else {
    for ($i = $max-1; $i >= 0 ; $i--) {
      echo "<li><a href=\"$myhref?comic=$comic&amp;tag=$tag&amp;id=$i\">$titles[$i]</a></li>\n";
    }
  }

  echo "</ul>\n";
  echo "<nav><a href=\"$myhref?comic=$comic&amp;rev=$revrev\">[reverse]</a></nav>\n";
  echo "</section>";
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

if (isset($comics[$comic])) {

  $selected = $comics[$comic];
  $files  = array();
  $titles = array();
  $max = 0;

  get_index($selected);

  if (isset($id)) {
    if (isset($startid)) {
      for ($i = $startid; $i <= $id; $i++) {
	show_strip($selected, $i);
      }
    } else {
      show_strip($selected, $id);
    }
  } else {
    show_comic($selected);
  }

} else {
    list_all_comics($comics);
}

close_db();

?>

    <footer>
      <hr>
      <address>brought to you by the <a href="http://github.com/mmitch/webcomics">webcomics</a> script</address>
    </footer>
  </body>
</html>
