<h1> Search Max by Site or Year</h1>

    <form method="post">

    <label for="local_site_name">Search by Site</label>
    <input type="text" name="local_site_name" id="local_site_name" placeholder="ex. Sunrise Acres">
    <div></div>
    <label for="year">Search by Year</label>
    <input type="text" name="year" id="year" placeholder="ex. 2014">
    	
    <input type="submit" name="submit" value="Submit">
    </form>

    <p></p>
    <a href="http://localhost/DemoFiles/index.html">Home</a>

    
<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $local_site_name = $_POST['local_site_name'];
    $year = $_POST['year'];

    $query = "SELECT * FROM max_values WHERE local_site_name = :local_site_name OR year = :year" ;

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':local_site_name', $local_site_name, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':year', $year, PDO::PARAM_INT);
      $prepared_stmt->execute();
      $result = $prepared_stmt->fetchAll();

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

table {
  border-collapse: collapse;
  border-spacing: 0;
}

td, th {
  padding: 5px 30px 5px 30px;
  border-bottom: 1px solid #aaa;
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

<?php
if (isset($_POST['submit'])) {
  if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
    <h2>Results</h2>

    <table>
      <thead>
		<tr>
          <th>Site</th>
          <th>Year</th>
          <th>1st max value</th>
          <th>1st max datetime</th>
          <th>2nd max value</th>
          <th>2nd max datetime</th>
          <th>3rd max value</th>
          <th>3rd max datetime</th>
          <th>4th max value</th>
          <th>4th max datetime</th>
          <th>1st non-overlapping max value</th>
          <th>1st non-overlapping max datetime</th>
          <th>2nd non-overlapping max value</th>
          <th>2nd non-overlapping max datetime</th>
		</tr>
      </thead>
      <tbody>
  
<?php foreach ($result as $row) { ?>
      
      <tr>
        <td><?php echo $row["local_site_name"]; ?></td>
		    <td><?php echo $row["year"]; ?></td>
        <td><?php echo $row["first_max_value"]; ?></td>
        <td><?php echo $row["first_max_datetime"]; ?></td>
        <td><?php echo $row["second_max_value"]; ?></td>
        <td><?php echo $row["second_max_datetime"]; ?></td>
        <td><?php echo $row["third_max_value"]; ?></td>
        <td><?php echo $row["third_max_datetime"]; ?></td>
        <td><?php echo $row["fourth_max_value"]; ?></td>
        <td><?php echo $row["fourth_max_datetime"]; ?></td>
        <td><?php echo $row["first_max_non_overlapping_value"]; ?></td>
        <td><?php echo $row["first_no_max_datetime"]; ?></td>
        <td><?php echo $row["second_max_non_overlapping_value"]; ?></td>
        <td><?php echo $row["second_no_max_datetime"]; ?></td>
      </tr>
<?php } ?>
      </tbody>
  </table>
  
<?php } else { ?>
    > No results found for <?php echo $_POST['local_site_name']; ?> <?php echo $_POST['year']; ?>.
  <?php }
} ?>


