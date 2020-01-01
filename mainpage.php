
<html>
<head>
	<title>Welcome to the Khana Khazana Restaurant</title>
	<style>
body {
  font-family: Arial;
  color: black;
}

.split {
  height: 90%;
  width: 50%;
  position: fixed;
  z-index: 1;
  top: 10%;
  overflow-x: hidden;
  padding-top: 20px;
}

.left {
  left: 0;
  background-color: #AFEEEE;
}

.right {
  right: 0;
  background-color: #AFEEEE;
}

label{
display:inline-block;
width:400px;
margin-right:200px;
text-align:right;
}

input{

}

fieldset{
border:none;
width:200px;
margin:0px auto;
}
h3{
background-color: #008B8B
}
</style>
</head>

<body>
	<form action="page1.php" method="post">
	<h3 align="center" ><br/> View Menu <input type="submit" name="menu" value="View menu"><br/><br/> </h3> 
	<div class="split left">
	<h4 align="center"> Data of Employee : </h4><br/> 
	<fieldset>
	<label for="id">ID  : <input type="text" name="id" > <br/><br/>
	<label for="fname">First Name  :  <input type="text" name="fname" ><br/><br/>
	<label for="lname">Last Name   :  <input type="text" name="lname"> <br/><br/>
    <label for="desi">designation :  <input type="text" name="desi"> <br/><br/>
	<label for="wtype">work type   :  <input type="text" name="wtype"> <br/><br/>
	<label for="address">address     :  <input type="text" name="address"> <br/><br/>
	<label for="city">city        :  <input type="text" name="city"> <br/><br/>
	<label for="state">state       :  <input type="text" name="state"> <br/><br/>
	<label for="pcode">pincode     :  <input type="text" name="pcode"> <br/><br/>
	<label for="cno">contact no  :  <input type="text" name="cno"> <br/><br/>
	<label for="salary">Salary      :  <input type="float" name="salary"> <br/><br/>
	</fieldset>
	<div align="center">
	<input type="submit" name="employeeadd" value="add"> 
	<input type="submit" name="employeedelete" value="delete">
	<input type="submit" name="employeesearch" value="search">
	</div>
	</div>
	
	<div class="split right">
	<h4 align="center">Data of Customer :  </h4><br/> 
	<fieldset>
	<label for="cid">ID  : <input type="text" name="cid"> <br/><br/>
	<label for="cfname">First Name  :  <input type="text" name="cfname"> <br/><br/>
	<label for="clname">Last Name   :  <input type="text" name="clname"> <br/><br/>
	<label for="caddress">address     :  <input type="text" name="caddress"> <br/><br/>
	<label for="ccity">city        :  <input type="text" name="ccity"> <br/><br/>
	<label for="cstate">state       :  <input type="text" name="cstate"> <br/><br/>
	<label for="cpcode">pincode     :  <input type="text" name="cpcode"> <br/><br/>
	<label for="ccno">contact no  :  <input type="text" name="ccno"> <br/><br/>
	<label for="cemailid">email id :  <input type="text" name="cemailid"> <br/><br/>
	</fieldset>
	<div align="center">	
	<input type="submit" name="customeradd" value="add">
	<input type="submit" name="customerdelete" value="delete">
	<input type="submit" name="customersearch" value="search"><br/><br/><br/><br/><br/>
	<input type="submit" name="prev" value="prev">
	<input type="submit" name="next" value="next">
	</div>
	</div>
	</form>
</body>

</html>
