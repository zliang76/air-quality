<h1> Search Observation by Site or Year</h1>

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

    $query = "SELECT * FROM observation WHERE year = :year OR local_site_name = :local_site_name" ;

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
          <th>Observation count</th>
          <th>Observation percent</th>
          <th>Completeness indicator</th>
          <th>Valid day count</th>
          <th>Required day count</th>
          <th>Null data count</th>
          <th>Certification indicator</th>
		</tr>
      </thead>
      <tbody>
  
<?php foreach ($result as $row) { ?>
      
      <tr>
        <td><?php echo $row["local_site_name"]; ?></td>
		<td><?php echo $row["year"]; ?></td>
        <td><?php echo $row["observation_count"]; ?></td>
        <td><?php echo $row["observation_percent"]; ?></td>
        <td><?php echo $row["completeness_indicator"]; ?></td>
        <td><?php echo $row["valid_day_count"]; ?></td>
        <td><?php echo $row["required_day_count"]; ?></td>
        <td><?php echo $row["null_day_count"]; ?></td>
        <td><?php echo $row["certification_indicator"]; ?></td>
      </tr>
<?php } ?>
      </tbody>
  </table>
  
<?php } else { ?>
    > No results found for <?php echo $_POST['local_site_name']; ?> <?php echo $_POST['year']; ?>.
  <?php }
} ?>





