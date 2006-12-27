<?
// $Id: with_db.inc,v 1.4 2006-12-27 00:06:33 mitch Exp $

//################ Internal functions for only this mode

function get_db_handle()
{
  global $mysql_host, $mysql_user, $mysql_password, $mysql_database, $mysql_connection;

  if ($mysql_connection) {
    return;
  }

  // these are the extended mysql functions (MySQL Improved Extension) for MySQL 4.1 or better!
  $mysql_connection = mysql_connect($mysql_host, $mysql_user, $mysql_password)
    or die('Could not connect: ' . mysql_error());
  mysql_select_db($mysql_database) or die('Could not select database');
}

function quote_smart($value)
// Quote variable to make safe (aus der PHP-dokumentation)
{
  // Stripslashes
  if (get_magic_quotes_gpc()) {
    $value = stripslashes($value);
  }
  // Quote if not a number or a numeric string
  if (!is_numeric($value)) {
    $value = "'" . mysql_real_escape_string($value) . "'";
  }
  return $value;
}


//################ Public functions for both modes

function handle_cookies()
{
  global $user, $username, $id, $tag, $comic, $mysql_connection, $lastVisited;

  if (isset($user)) {
    setcookie('whoami', $user, time()+( 3600 * 24 * 365 * 5));
    $username = $user;
  }

  if (! (isset($username) && $username) ) {
    // guest login
    return;
  }

  get_db_handle();

  $readall = 1;
  if (isset($comic) && isset($id) && isset($tag)) {
    $query = sprintf("INSERT INTO bookmark (user, comic, current) VALUES(%s, %s, %s) ON DUPLICATE KEY UPDATE current = %s",
		     quote_smart($username),
		     quote_smart($tag),
		     quote_smart($id),
		     quote_smart($id)
		     );
    mysql_query($query, $mysql_connection) or die('Query failed: ' . mysql_error());

    if ($id > 0) {
      $readall = 0;
    }
  }

  if ($readall) {
    $query = sprintf("SELECT comic, current FROM bookmark WHERE user = %s",
		     quote_smart($username)
		     );

    $result = mysql_query($query, $mysql_connection) or die('Query failed: ' . mysql_error());

    $lastVisited = array();

    while ($row = mysql_fetch_assoc($result)) {
      $lastVisited[$row['comic']] = $row['current'];
    }

    mysql_free_result($result);
  }
}

function change_login()
{
  global $myhref;

  echo '<p><form action="'.$myhref.'" method=\"post\">Change login: <input type="text" name="user" /><input type="submit" name="submit" value="Change!" /></form></p>';
  echo "\n";
}

function print_login()
{
  global $username;

  if ($username) {
    echo '<p>Welcome, '.htmlspecialchars($username).'</p>';
  } else {
    echo '<p>You are not logged in.</p>';
  }
  echo "\n";

  get_db_handle();
}

function close_db()
{
     global $mysql_connection;

     if ($mysql_connection) {
       mysql_close($mysql_connection);   
     }
}
?>
