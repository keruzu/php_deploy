<?php
$servername = "db";
$username = "app_user";
$password = "s3kr3ts3kr3ts3kr3t";
$dbname = "example_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
