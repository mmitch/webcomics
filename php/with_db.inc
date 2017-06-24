<?php
// $Id: with_db.inc,v 1.5 2006-12-28 09:37:02 mitch Exp $

//################ Internal functions for only this mode

function get_db_handle()
{
  global $pdo_dsn, $pdo_user, $pdo_password, $pdo_connection;

  if ($pdo_connection) {
    return;
  }

  // these are the extended mysql functions (MySQL Improved Extension) for MySQL 4.1 or better!
  $pdo_connection = new PDO($pdo_dsn, $pdo_user, $pdo_password);
}

//################ Public functions for both modes

function handle_cookies()
{
  global $user, $username, $id, $tag, $comic, $pdo_connection, $lastVisited;

  if (isset($user)) {
    setcookie('whoami', $user, time()+( 3600 * 24 * 365 * 5));
    $username = $user;
  }

  if (! (isset($username) && $username) ) {
    // guest login
    $lastVisited = array();
    return;
  }

  get_db_handle();

  $readall = 1;
  if (isset($comic) && isset($id) && isset($tag)) {
    $stmt = $pdo_connection->prepare('INSERT INTO bookmark (user, comic, current) VALUES(:user, :comic, :current ) ON DUPLICATE KEY UPDATE current = :current');
    $stmt->bindValue(':user',    $username, PDO::PARAM_STR);
    $stmt->bindValue(':comic',   $tag,      PDO::PARAM_STR);
    $stmt->bindValue(':current', $id,       PDO::PARAM_STR);
    $stmt->execute();

    if ($id > 0) {
      $readall = 0;
    }
  }

  if ($readall) {
    $stmt = $pdo_connection->prepare('SELECT comic, current FROM bookmark WHERE user = :user');
    $stmt->bindValue(':user', $username, PDO::PARAM_STR);
    $stmt->execute();

    $lastVisited = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
      $lastVisited[$row['comic']] = $row['current'];
    }

  }
}

function change_login()
{
  global $myhref;

  echo '<section><form action="'.$myhref.'" method=\"post\">Change login: <input type="text" name="user" /><input type="submit" name="submit" value="Change!" /></form></section>';
  echo "\n";
}

function print_login()
{
  global $username;

  if ($username) {
    echo '<section>Welcome, '.htmlspecialchars($username).'</section>';
  } else {
    echo '<section>You are not logged in.</section>';
  }
  echo "\n";

  get_db_handle();
}

function close_db()
{
     global $pdo_connection;

     if ($pdo_connection) {
       $pdo_connection = null;
     }
}
?>
