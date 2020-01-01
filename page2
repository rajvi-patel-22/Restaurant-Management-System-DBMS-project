<?php
//Connection for database
include 'connect.php';
//Select Database
$sql = "SELECT * FROM order_status";
$result = $conn->query($sql);
?>
<!doctype html>
<html>
<body>
<h1 align="center">Order status </h1>
<table border="1" align="center" style="line-height:25px;">
<tr>
<th>Order ID</th>
<th>Serve Status</th>
</tr>
<?php
//Fetch Data form database
if($result->num_rows > 0){
 while($row = $result->fetch_assoc()){
 ?>
 <tr>
 <td><?php echo $row['order_id']; ?></td>
 <td><?php echo $row['serve_status']; ?></td>
 </tr>
 <?php
 }
}
else
{
 ?>
 <tr>
 <th colspan="2">There's No data found!!!</th>
 </tr>
 <?php
}
?>
</table>
</body>
</html>