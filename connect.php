<?php

	$duser ='root';
	$dpass ='';
	$db = 'project';
	$con = new mysqli('localhost',$duser,$dpass,$db) or die("Unable to connect..!!");
	
	echo "connected..!!";



?>