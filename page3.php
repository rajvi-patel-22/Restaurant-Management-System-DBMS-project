<?php
$duser ='root';
	$dpass ='';
	$db = 'restaurant';
	$con = new mysqli('localhost',$duser,$dpass,$db) or die("Unable to connect..!!");
	$query="select * from order_status";
	$result=mysqli_query($con,$query);
	
     if(isset($_POST['menu']))/*Display menu*/
	{
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		mysqli_select_db($con,'restaurant');
				
		$q = "call display_food()";
		$result=mysqli_query($con,$q);
	
		if(mysqli_num_rows($result))
		{
			echo "<h1 >&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Menu</h1>";
			echo " 	category_id	&emsp;	category name &emsp; food id &emsp; food name &emsp; price &emsp; rate &emsp; prep_time &emsp; spice_level &emsp; is_jain &emsp; food_description &emsp;<br/>";
			while($row=mysqli_fetch_array($result))
			{
				echo "<br/>&emsp;&emsp;&emsp;".$row['category_id'];
				echo "&emsp;&emsp;&emsp;".$row['category_name'];				
				echo "&emsp;&emsp;&emsp;".$lname=$row['Food_id'];
				echo "&emsp;&emsp;&emsp;".$city=$row['Food_name'];
				echo "&emsp;&emsp;".$cno=$row['Prep_time'];
				echo "&emsp;&emsp;&emsp;".$salary=$row['Spice_level'];
				echo "&emsp;&emsp;&emsp;".$state=$row['Is_Jain'];				
				echo "&emsp;&emsp;".$address=$row['Price'];
				echo "&emsp;&emsp;".$pcode=$row['Rate'];
				echo "&emsp;&emsp;".$state=$row['Food_description'];
				echo "<br/>";
				
			}
				
		}
		else
		{
			echo 'Data is not found ...!!';
		}
	   header("refresh:5; url=page2.php");
	}
	else if(isset($_POST['book']))/*book table*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$var1= $_POST['custid'];
	    $var2= $_POST['mem'];
		$query2 = "call Table_allocation('$var2','$var1')";
		$res=mysqli_query($con,$query2);
	
		if(mysqli_num_rows($res))
		{
				$row1=mysqli_fetch_array($res);
				echo " Your Table id is: " .$row1['tid'];	
		}
		else
		{
			echo 'Data is not found ...!!';
		}
	   header("refresh:9; url=page2.php");
	}
	else if(isset($_POST['served']))/*order status*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$var3= $_POST['orderid1'];
		$query2 = "update order_status set serve_status='C served' where Order_id=$var3";
		$res1=mysqli_query($con,$query2);
		
		
		$query3 = "update order_status set serve_status='served' where serve_status='C served'";
		$res2=mysqli_query($con,$query3);
		if(mysqli_affected_rows($con)>0)
		{
			echo "Order Served";
		}
		else
		{
			echo "Order not Served";
		}	
		
	   header("refresh:2; url=page2.php");
	}
	else if(isset($_POST['Calculatedis']))/*cal disc*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$var4= $_POST['orderid2'];
		$query4 = "select Discount('$var4')";
		$res4=mysqli_query($con,$query4);
		
		if(mysqli_num_rows($res4))
		{
			while($row5=mysqli_fetch_array($res4))
			{
					echo "Discount calculated successfully" ;	
					
			}
			
		}
		else
		{
			echo 'Data is not found ...!!';
		}
	   header("refresh:10; url=page2.php");
	}
	else if(isset($_POST['Calculatebill']))/*cal bill*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$var8= $_POST['orderid2'];
		$query5 = "call bill('$var8')";
		$res5=mysqli_query($con,$query5);
		if(mysqli_affected_rows($con)>=0)
		{
				echo "Bill calculated successfully";	
		}
		else
		{
			echo 'Data is not found ...!!';
		}
	   header("refresh:10; url=page2.php");
	}
	else if(isset($_POST['paybill']))/*pay bill*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$var11= $_POST['method'];
		$var12= $_POST['billno2'];
		$query8 = "call payement('$var11','$var12')";
		$res8=mysqli_query($con,$query8);
		if(mysqli_affected_rows($con)>=0)
		{
				echo 'Payment successfully done..';	
		}
		else
		{
			echo 'Payment not done..';
		}
	   header("refresh:10; url=page2.php");
	}
	else if(isset($_POST['place']))/*place order*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$var15= $_POST['cid'];
		$var17= $_POST['fname'];
		$var18= $_POST['quantity'];
		$var19= $_POST['jain'];
		$query9 = "call Orderitems('$var15','$var17','$var18','$var19')";
		$res9=mysqli_query($con,$query9);
		if(mysqli_affected_rows($con)>=0)
		{
				echo 'Order placed  successfully ..';	
		}
		else
		{
			echo 'Order not placed ..';
		}
	   header("refresh:10; url=page2.php");
	}
	else if(isset($_POST['gete']))/*get emp data*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$query10 = "call experience()";
		$res10=mysqli_query($con,$query10);
		if(mysqli_num_rows($res10))
		{
			while($row=mysqli_fetch_array($res10))
			{
				echo "<br/> Emp id: "   .$row['emp'];
				echo "<br/>Salary: " .$row['salary'];				
				echo "<br/>Hiring date: ".$row['hdate'];
				echo "<br/>Total year of experience: ".$row['tot_years_exp'];
				
			}
				
		}
	   header("refresh:10; url=page2.php");
	}
	else if(isset($_POST['varyprice']))/*price variation*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$query10 = "select * from price_increase";
		$res10=mysqli_query($con,$query10);
		if(mysqli_num_rows($res10))
		{
			echo "<br/> Date of inc/dec: &emsp;&emsp; field name: &emsp;&emsp; before value :  &emsp;&emsp;after value: ";
			while($row=mysqli_fetch_array($res10))
			{
				echo "<br/>&emsp;&emsp;&emsp;"   .$row['cur_date'];
				echo "&emsp;&emsp;&emsp;" .$row['field_name'];				
				echo "&emsp;&emsp;&emsp;&emsp;&emsp;".$row['before_value'];
				echo "&emsp;&emsp;&emsp;&emsp;&emsp;".$row['after_value'];
				echo "<br/>";
			}
				
		}
	   header("refresh:10; url=page2.php");
	   
	}
	else if(isset($_POST['leftemp']))/*employee left*/
	{
		
		$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		
		mysqli_select_db($con,'restaurant');
		
		$query11 = "select * from left_employee";
		$res11=mysqli_query($con,$query11);
		if(mysqli_num_rows($res11))
		{
			echo "<br/> username &emsp;&emsp; date & time  ";
			while($row=mysqli_fetch_array($res11))
			{
				echo "<br/>&emsp;"   .$row['user_name'];
				echo "&emsp;&emsp;&emsp;" .$row['datetime'];		
				echo "<br/>";
			}
				
		}
	   header("refresh:10; url=page2.php");
	}
?>