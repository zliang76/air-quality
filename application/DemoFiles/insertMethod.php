<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $year = $_POST['year'];
    $local_site_name = $_POST['local_site_name'];
    $method_name = $_POST['method_name'];
    $metric_used = $_POST['metric_used'];

    $query = "INSERT INTO method (methodID, year, local_site_name,method_name,metric_used)
              VALUES (DEFAULT, :year, :local_site_name, :method_name, :metric_used)";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':year', $year, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':local_site_name', $local_site_name, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':method_name', $method_name, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':metric_used', $metric_used, PDO::PARAM_STR);
      $prepared_stmt->execute();
    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}
?>



<style>
label {
  display: block;
  margin: 5px 0;
}

a {
  color: #64a19d;
  text-decoration: none;
  background-color: transparent;
}
a:hover {
  color: #467370;
  text-decoration: underline;
}

html {
  font-family: sans-serif;
  line-height: 1.15;
  -webkit-text-size-adjust: 100%;
  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}
</style>

<h1> Insert Method </h1>

<form method="post">
  <label for="year">Year</label>
	<input type="text" name="year" id="year" placeholder='ex. 2020'> 

	<label for="local_site_name">Site</label>
	<input type="text" name="local_site_name" id="local_site_name" placeholder='ex. Lawrenceville'>

	<label for="method_name">Method</label>
	<input type="text" name="method_name" id="method_name" placeholder ='ex. Ultraviolet'>

  <label for="metric_used">Metric</label>
  <input type="text" name="metric_used" id="metric_used" placeholder='ex. Observed Values'>
    	
  <input type="submit" name="submit" value="Submit">
</form>

<p></p>
    <a href="http://localhost/DemoFiles/index.html">Home</a>
  
