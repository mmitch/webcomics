<?
// $Id: without_db.inc,v 1.2 2006-12-26 23:24:14 mitch Exp $

//################ Internal functions for only this mode

//################ Public functions for both modes

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

function close_db()
{
}

?>
