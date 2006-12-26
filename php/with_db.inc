<?
// $Id: with_db.inc,v 1.1 2006-12-26 18:09:09 mitch Exp $

function handle_cookies()
{
  global $user, $username;

  if (isset($user)) {
    setcookie('whoami', $user, time()+( 3600 * 24 * 365 * 5));
    $username = $user;
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
}

?>
