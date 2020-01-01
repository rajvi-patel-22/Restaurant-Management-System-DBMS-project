<?php
    if(isset($_POST['username']))
	{
	$uname = $_POST['username'];
	$pwd1 =$_POST['password'];
	$con = mysqli_connect('localhost','root','');
		if(!$con)
		{
			die('Unable to connect..!!');
		}
		mysqli_select_db($con,'project');
	
	
		$q = "select * from user where username='$uname' and password='$pwd1'";
		$result=mysqli_query($con,$q);
		$num=mysqli_num_rows($result);
		
		if($num==1)
		{
			echo 'Login Successfully...!!';
			header("refresh:2; url=mainpage.html");
		}
		else
		{
			echo 'Failed to login';	
		}
	}
	
	


?>