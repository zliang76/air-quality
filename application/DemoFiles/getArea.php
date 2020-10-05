<h1>Search the location of a site</h1>

    <form method="post">

    <label for="local_site_name">Enter Site Name</label>
    <input type="text" name="local_site_name" id="local_site_name" placeholder="ex. Sunrise Acres">
    
    <input type="submit" name="submit" value="Submit">
    </form>

    <p></p>
    <a href="http://localhost/DemoFiles/index.html">Home</a>

<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $local_site_name = $_POST['local_site_name'];

      $query = "SELECT * FROM area_info WHERE local_site_name = :local_site_name LIMIT 1" ;
  
    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':local_site_name', $local_site_name, PDO::PARAM_STR);
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
          <th>Site Number</th>
          <th>Address</th>
          <th>City</th>
          <th>County</th>
          <th>County Code</th>
          <th>State</th>
          <th>State Code</th>
          <th>CBSA</th>
		</tr>
      </thead>
      <tbody>
  
<?php foreach ($result as $row) { ?>
      
      <tr>
        <td><?php echo $row["local_site_name"]; ?></td>
        <td><?php echo $row["site_num"]; ?></td>
        <td><?php echo $row["address"]; ?></td>
        <td><?php echo $row["city_name"]; ?></td>
        <td><?php echo $row["county_name"]; ?></td>
        <td><?php echo $row["county_code"]; ?></td>
        <td><?php echo $row["state_name"]; ?></td>
        <td><?php echo $row["state_code"]; ?></td>
        <td><?php echo $row["cbsa_name"]; ?></td>
        
      </tr>
<?php } ?>
      </tbody>
  </table>
  
<?php } else { ?>
    > No results found for <?php echo $_POST['local_site_name']; ?>.
  <?php }
} ?>


