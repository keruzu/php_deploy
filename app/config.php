<?php

function readKeyValueFile($filename) {
    $keyValuePairs = [];

    if (file_exists($filename)) {
        $lines = file($filename, FILE_IGNORE_NEW_LINES);

        foreach ($lines as $line) {
            $parts = explode('=', $line, 2);
            if (count($parts) == 2) {
                $key = trim($parts[0]);
                $value = trim($parts[1]);
                $keyValuePairs[$key] = $value;
            }
        }
    }

    return $keyValuePairs;
}

$filename = '/var/www/config.txt';
$config = readKeyValueFile($filename);

$servername = $config["hostname"];
$username = $config["username"];
$password = $config["password"];
$dbname = $config["dbname"];

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
