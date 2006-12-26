<?
// $Id: without_db.inc,v 1.1 2006-12-26 18:09:09 mitch Exp $

function handle_cookies()
{
  global $comic, $id, $tag;

  if (isset($comic) && isset($id) && isset($tag)) {
    setcookie("lastVisited[$tag]", $id, time()+( 3600 * 24 * 365 * 5));
  }
}

function change_login()
{
}

function print_login()
{
}

?>
