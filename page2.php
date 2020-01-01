<?php
$duser ='root';
	$dpass ='';
	$db = 'restaurant';
	$con = new mysqli('localhost',$duser,$dpass,$db) or die("Unable to connect..!!");
	$query="select * from order_status";
	$result=mysqli_query($con,$query);
	?>
<!doctype html>
<html>
<head>
<style>
h2{
background-color: #008B8B
}

</style>
</head>
<body ><form action="page3.php" method="post">
<h2 align="center" ba >View Menu </h2>To View Menu click here.. <input  type="submit" name="menu" value="menu"> 

<h2 align="center">Book Table  :</h2>
Customer Id:      <input type="text" name="custid"> 
Members    :      <input type="number" name="mem">
			   <input  type="submit" name="book" value="book">
			   
<h2 align="center">Place Order  :</h2>
Customer Id:      <input type="text" name="cid">
Food name    :      <input type="text" name="fname">
Quantity    :      <input type="text" name="quantity"> 
Jain?    :      <input type="text" name="jain">

			   <input  type="submit" name="place" value="place">
			   

<h2 align="center">Track Order status </h2>
<table border="1"  style="line-height:30px;">
<tr>
<th>Order ID</th>
<th>Serve Status</th>
</tr>

<?php
//Fetch Data form database
if(mysqli_num_rows($result)){
 while($row=mysqli_fetch_array($result)){
 ?>
 <tr>
 <td><?php echo $row['Order_id']; ?></td>
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
<h4 >Update Status:</h4>
Order Id:      <input type="text" name="orderid1"> 
			   <input  type="submit" name="served" value="Served">
<h2 align="center">Discount Calculation  </h2>
Order Id:      <input type="text" name="orderid2"> 
			   <input  type="submit" name="Calculatedis" value="Calculate">
<h2 align="center">Bill Calculation  </h2>
Order Id:      <input type="text" name="orderid2">
			   <input  type="submit" name="Calculatebill" value="Calculate">
<h2 align="center">Pay Bill </h2>
Bill no:		  <input type="text" name="billno2">
Method:		<input type="text" name="method">
			   <input  type="submit" name="paybill" value="Pay">
<h2 align="center">Get Employee basic data</h2>
			   <input  type="submit" name="gete" value="get data">
 <h2 align="center">Price variation of food  :</h2>
			   <input  type="submit" name="varyprice" value="See">
 <h2 align="center">Left employee   :</h2>
			   <input  type="submit" name="leftemp" value="Get data">
</form>
</body>
</html>

