-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 16, 2019 at 12:05 PM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `bill` (IN `oid` INT)  begin
  DECLARE b int;
  DECLARE na int; 
  DECLARE tot_Amount int; 
  DECLARE tax1,disc float; 
  DECLARE tid varchar(8);
  DECLARE cid varchar(20);
  DECLARE cur1 CURSOR FOR SELECT sum(Amount) as tot_amount FROM Order_items where Order_id=oid group by Order_id ;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET b = 1;  
  set tid=(select Table_id from order_details where Order_id=oid);
  set cid=(select Cust_id from order_details where Order_id=oid);
  set disc=(SELECT Discount from bill where Order_id=oid);
   update table_master set booking_stat="not_booked" where table_id=tid;
    update table_master set booking_time=null where table_id=tid;
    update table_master set Cust_id=null  where table_id=tid;
  OPEN cur1;  
  SET b = 0;  
      FETCH cur1 INTO tot_amount;
        WHILE b = 0 DO
          set disc =10; 
          set tax1= tot_Amount *0.18;          
          set na = tot_Amount + tax1 - disc ;
           update bill set Amount=tot_Amount ,Net_amount=na,tax=tax1,Table_id=tid,Cust_id=cid where Order_id=oid; 
          
           FETCH cur1 INTO tot_Amount; 
         end while;
 CLOSE cur1; 
 
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `bill_display` ()  NO SQL
select customer.Cust_id,cust_fname,cust_lname,bill.Bill_no,payement.Payement_mode,payement.Paid_amount 
from customer join bill on customer.Cust_id=bill.cust_id join payement on bill.Bill_no=payement.Bill_no$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Discount` (IN `oid` INT)  begin 
    declare difftime,stime,etime,approxtime,apptime time;
    declare odate date;
    declare disc float;
 set stime=(select Start_time from Order_details where Order_id=oid);
                set etime=(select End_time from Order_details where Order_id=oid);
                set apptime=(select Approx_Prep_time from Order_details where Order_id=oid);

                set difftime=timediff(etime,stime);
                
         if(time(difftime)>time(apptime)) then
         set disc=300;
		   insert into bill(Discount,Order_id) values(300,oid);
		  else
          set disc=0;
            insert into bill(Discount,Order_id) values(0,oid);
          end if;
    
    
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `display_food` ()  SELECT food.category_id,categories.category_name,food.Food_id,food.Food_name,food.Price,food.Rate,food.Prep_time,food.Spice_level,food.Is_Jain,food.Food_description FROM food,categories where categories.category_id=food.category_id order BY category_id,spice_level asc$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `experience` ()  begin      
 declare emp varchar(10);      
 declare salary bigint;
 declare yr int;      
 declare hdate,bdate date;      
 declare b,tot_years_exp int;      
 declare rdate varchar(30);      
 declare cur1 cursor for select Emp_id , Emp_salary , hiring_date ,bdate from Employee;  
 declare continue handler for not found set b = 1;          
 open cur1; 
  set b=0;         
 fetch cur1 into emp ,salary,hdate,bdate; 
 while b = 0 Do 
                    set yr=(60 + year(bdate));
                    set rdate =concat(yr,'-',month(bdate),'-',day(bdate));
                    set tot_years_exp =year(curdate())-year(hdate);
                      

select emp ,salary,hdate,tot_years_exp ; 
fetch cur1 into emp ,salary,hdate,bdate;        
end while;     
close cur1;   
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Orderitems` (IN `cid` VARCHAR(8), IN `Foodname` VARCHAR(20), IN `quantity` INT, IN `jain` VARCHAR(3))  begin
  DECLARE b int;
  DECLARE p int; 
  DECLARE Amount,oid int; 
  DECLARE fid1 VARCHAR(8);
  DECLARE cur2 CURSOR FOR SELECT Price,Food_id FROM Food where food_name=foodname ;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET b = 1; 
  set oid=(select Order_id from order_details where cust_id=cid);
  OPEN cur2;  
  SET b = 0;  
      FETCH cur2 INTO p,fid1;
        WHILE b = 0 DO 
           set Amount = p * quantity ;         
         
           insert into Order_items values (p,quantity,Amount,fid1,Foodname,jain,oid,current_time);
           FETCH cur2 INTO p,fid1; 
         end while;
 CLOSE cur2; 
 update order_details set  Order_date=CURRENT_DATE where Cust_id=cid;
  update order_details set  End_time=NULL,Approx_Prep_time=NULL where Cust_id=cid;
  UPDATE order_status SET serve_status="Not served" where Order_id=oid;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payement` (IN `mode` VARCHAR(10), IN `billno` INT)  begin
DECLARE b int;
DECLARE paid_amount bigint;
DECLARE cur1 CURSOR FOR select net_Amount from bill where bill_no=billno;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET b = 1;  
  OPEN cur1;  
  SET b = 0;  
      FETCH cur1 INTO paid_amount;
        WHILE b = 0 DO
          insert into Payement values (curdate(),"",mode,paid_amount,billno);
     FETCH cur1 INTO paid_amount;
         end while;
 CLOSE cur1; 
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Table_allocation` (IN `members` INT, IN `custid` VARCHAR(8))  begin 
    declare difftime,stime,etime,approxtime,apptime time;
    declare b_s varchar(10);
    declare tid,tableid varchar(8);
    declare odate date;
    declare k,c int;
    declare cur1 cursor for select Table_id,capacity,Booking_stat from Table_master;
    declare continue handler for not found set k = 1; 

    open cur1;
         set k = 0;
         fetch cur1 into tid,c,b_s;
         while k = 0 do  
                if(c>=members && b_s="not_booked" && c<=8) then
set tableid=tid;                    
end if;
fetch cur1 into tid,c,b_s;
end while; 
    close cur1;
    select tableid as tid;
update Table_master set Booking_stat="booked" where Table_id=tableid ;
update Table_master set Cust_id=custid where Table_id=tableid ;
update Table_master set Booking_time=curtime() where Table_id=tableid ;
insert into order_details (Cust_id,Table_id,Start_time) VALUES (custid,tableid,CURTIME());

end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `Bill_no` int(11) NOT NULL,
  `Amount` bigint(20) DEFAULT NULL,
  `Net_amount` bigint(20) DEFAULT NULL,
  `Tax` float DEFAULT NULL,
  `Discount` float DEFAULT NULL,
  `Table_id` varchar(8) DEFAULT NULL,
  `Cust_id` varchar(8) DEFAULT NULL,
  `Order_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`Bill_no`, `Amount`, `Net_amount`, `Tax`, `Discount`, `Table_id`, `Cust_id`, `Order_id`) VALUES
(30, 200, 226, 36, 300, 'T02', 'C01', 16);

--
-- Triggers `bill`
--
DELIMITER $$
CREATE TRIGGER `booking_status` AFTER INSERT ON `bill` FOR EACH ROW update table_master set booking_stat="not_booked" where table_id=new.table_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` varchar(8) NOT NULL,
  `category_name` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
('1', 'maincourse'),
('2', 'street   food');

-- --------------------------------------------------------

--
-- Table structure for table `chef`
--

CREATE TABLE `chef` (
  `Chef_id` varchar(8) NOT NULL,
  `Chef_fname` varchar(10) DEFAULT NULL,
  `Chef_lname` varchar(10) DEFAULT NULL,
  `category_id` varchar(8) DEFAULT NULL,
  `bonus` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `chef`
--

INSERT INTO `chef` (`Chef_id`, `Chef_fname`, `Chef_lname`, `category_id`, `bonus`) VALUES
('E01', 'Akshat', 'Shah', '2', 0),
('E05', 'Jugal', 'Naik', '1', 500);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `Cust_id` varchar(8) NOT NULL,
  `Cust_fname` varchar(8) DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Cust_lname` varchar(8) DEFAULT NULL,
  `Pincode` varchar(6) DEFAULT NULL,
  `Contact_no` varchar(13) DEFAULT NULL,
  `Email_id` varchar(30) DEFAULT NULL,
  `State` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`Cust_id`, `Cust_fname`, `City`, `Address`, `Cust_lname`, `Pincode`, `Contact_no`, `Email_id`, `State`) VALUES
('C01', 'Maria', 'Surat', 'Vip road', 'Upadhyay', '390001', '9876294766', 'maria@gmail.com', 'gujarat'),
('C02', 'Tina', 'Ahmedabad', 'cg road', 'Sharma', '380001', '9876364766', 'tina@gmail.com', 'gujarat'),
('C03', 'Meena', 'Ahmedabad', 'mg road', 'Vyas', '380001', '9876235466', 'mena@gmail.com', 'gujarat'),
('C04', 'Riya', 'Ahmedabad', 'gandhi road', 'Parekh', '380009', '9876345676', 'riya@gmail.com', 'gujarat'),
('C05', 'Raj', 'Ahmedabad', 'ashram road', 'Jogi', '380008', '9876294666', 'raj@gmail.com', 'gujarat');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `Emp_id` varchar(8) NOT NULL,
  `Emp_fname` varchar(10) NOT NULL,
  `Designation` varchar(10) DEFAULT NULL,
  `Work_type` varchar(30) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `City` varchar(10) DEFAULT NULL,
  `Emp_lname` varchar(10) NOT NULL,
  `State` varchar(20) DEFAULT NULL,
  `Pincode` varchar(6) DEFAULT NULL,
  `Contact_no` varchar(13) DEFAULT NULL,
  `Emp_salary` float DEFAULT NULL,
  `hiring_date` date DEFAULT NULL,
  `bdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`Emp_id`, `Emp_fname`, `Designation`, `Work_type`, `Address`, `City`, `Emp_lname`, `State`, `Pincode`, `Contact_no`, `Emp_salary`, `hiring_date`, `bdate`) VALUES
('E01', 'Akshat', 'worker', 'taking feedback', 'ashram road', 'ahmedabad', 'Shah', 'gujrat', '380009', '9874561230', 11000, '2019-04-14', '1990-07-03'),
('E02', 'Vishal', 'worker', 'attending customer', 'sarma road', 'ahmedabad', 'Sharma', 'gujrat', '380009', '9874561230', 16000, '2019-04-14', '0000-00-00'),
('E03', 'Hardik', 'worker', 'taking order', 'gandhiroad', 'ahmedabad', 'Gajjar', 'gujrat', '380009', '9874561230', 12000, '2019-04-14', '1999-01-03'),
('E04', 'Brijesh', 'worker', 'serving food', 'cg road', 'ahmedabad', 'Gohil', 'gujrat', '380009', '9874561230', 15000, '2019-04-14', '1991-07-03'),
('E05', 'Jugal', 'worker', 'serving food', 'mg road', 'ahmedabad', 'Naik', 'gujrat', '380009', '9874561230', 15000, '2019-04-14', '1999-07-03');

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `emp_delete` BEFORE DELETE ON `employee` FOR EACH ROW begin
insert into left_employee values(old.Emp_id,current_timestamp());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `Food_id` varchar(8) NOT NULL,
  `Food_name` varchar(20) NOT NULL,
  `Price` int(11) DEFAULT NULL,
  `Rate` float DEFAULT NULL,
  `Prep_time` time DEFAULT NULL,
  `Spice_level` int(11) DEFAULT NULL,
  `Is_Jain` varchar(3) DEFAULT NULL,
  `Food_description` varchar(100) DEFAULT NULL,
  `category_id` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`Food_id`, `Food_name`, `Price`, `Rate`, `Prep_time`, `Spice_level`, `Is_Jain`, `Food_description`, `category_id`) VALUES
('F101', 'PavBhaji', 100, 4, '00:00:20', 3, 'yes', 'Famous item of Streets of india', '1'),
('F102', 'VadaPav', 40, 4, '00:00:10', 4, 'yes', 'Famous item of Mumbai', '2'),
('F103', 'PaniPuri', 60, 4.5, '00:00:20', 5, 'yes', 'Popular street food', '2'),
('F104', 'Frankie', 100, 4, '00:00:20', 2, 'yes', 'Delicious healthy food', '1'),
('F105', 'Sandwich', 90, 3.5, '00:01:59', 3, 'yes', 'with variety of sauces', '1'),
('F106', 'v.Burger', 120, 4.5, '00:00:20', 4, 'yes', 'pretty form of potato', '1');

--
-- Triggers `food`
--
DELIMITER $$
CREATE TRIGGER `food_update` BEFORE UPDATE ON `food` FOR EACH ROW begin
declare msg varchar(50); 
    if old.Price<>new.Price then
       insert into price_increase values(now(), 'Price', old.Price , new.Price ,FOOD.Food_id,FOOD.Food_name);
    elseif old.Rate<>new.Rate then
       insert into price_increase values(now(), 'Rate', old.Rate, new.Rate,FOOD.Food_id,FOOD.Food_name);  
    
  end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `left_employee`
--

CREATE TABLE `left_employee` (
  `user_name` varchar(8) DEFAULT NULL,
  `datetime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `Cust_id` varchar(8) DEFAULT NULL,
  `Order_date` date DEFAULT NULL,
  `Start_time` time DEFAULT NULL,
  `End_time` time DEFAULT NULL,
  `Approx_Prep_time` time DEFAULT NULL,
  `Table_id` varchar(8) DEFAULT NULL,
  `order_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`Cust_id`, `Order_date`, `Start_time`, `End_time`, `Approx_Prep_time`, `Table_id`, `order_id`) VALUES
('C01', '2019-04-16', '15:25:13', '15:25:53', '00:00:20', 'T02', 16);

--
-- Triggers `order_details`
--
DELIMITER $$
CREATE TRIGGER `order_status_insert_oid` AFTER INSERT ON `order_details` FOR EACH ROW BEGIN

	 insert into order_status values (new.order_id,'not_served');

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `Price` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `Food_id` varchar(8) NOT NULL,
  `Food_name` varchar(20) DEFAULT NULL,
  `Is_Jain` varchar(3) DEFAULT NULL,
  `Order_id` int(11) NOT NULL,
  `current_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`Price`, `Quantity`, `Amount`, `Food_id`, `Food_name`, `Is_Jain`, `Order_id`, `current_time`) VALUES
(40, 2, 80, 'F102', 'VadaPav', 'No', 16, '15:25:25'),
(60, 2, 120, 'F103', 'PANIPURI', 'No', 16, '15:25:47');

-- --------------------------------------------------------

--
-- Table structure for table `order_status`
--

CREATE TABLE `order_status` (
  `Order_id` int(11) NOT NULL,
  `serve_status` varchar(10) DEFAULT 'Not served'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_status`
--

INSERT INTO `order_status` (`Order_id`, `serve_status`) VALUES
(16, 'served');

--
-- Triggers `order_status`
--
DELIMITER $$
CREATE TRIGGER `Bonus_Calculation` BEFORE UPDATE ON `order_status` FOR EACH ROW begin
declare cid varchar(8);
declare oid int;
        declare  bonusamt float;
        declare stime,etime,approxtime time;
set oid=(select Order_id from Order_status where serve_status="C Served");

            set stime=(select Start_time from Order_details where Order_id=oid);
            set etime=(select End_time from Order_details where Order_id=oid);
            set approxtime=(select Approx_Prep_time from Order_details where Order_id=oid);
            set cid=(select category_id from Food join Order_items on Food.Food_id=Order_items.Food_id where Order_items.Order_id=oid group by category_id);
            set bonusamt=(select bonus from Chef where category_id=cid);

if(timediff(etime,stime)<time(approxtime)) then
set bonusamt=bonusamt+100;
update Chef set bonus=bonusamt where category_id=cid;
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `End_Time_Calculation` AFTER UPDATE ON `order_status` FOR EACH ROW begin
declare oid int;
declare approxtime time;
if(new.serve_status="C Served") then
set oid=(select Order_id from Order_status where serve_status="C Served");
update Order_details set End_time = curtime() where Order_id=oid;
         set approxtime=(select max(Prep_time)
         
from Food join Order_items on Food.Food_id=Order_items.Food_id
                        where Order_id=oid);
update Order_details set Approx_Prep_time=approxtime where Order_id=oid;
 end if;                            
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payement`
--

CREATE TABLE `payement` (
  `Date_of_payment` date DEFAULT NULL,
  `Payement_id` int(11) NOT NULL,
  `Payement_mode` varchar(10) DEFAULT NULL,
  `Paid_amount` bigint(20) DEFAULT NULL,
  `Bill_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payement`
--

INSERT INTO `payement` (`Date_of_payment`, `Payement_id`, `Payement_mode`, `Paid_amount`, `Bill_no`) VALUES
('2019-04-16', 6, 'paytm', 226, 30);

-- --------------------------------------------------------

--
-- Table structure for table `price_increase`
--

CREATE TABLE `price_increase` (
  `cur_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `field_name` varchar(20) DEFAULT NULL,
  `before_value` int(11) DEFAULT NULL,
  `after_value` int(11) DEFAULT NULL,
  `food_id` varchar(8) NOT NULL,
  `food_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `table_master`
--

CREATE TABLE `table_master` (
  `Table_id` varchar(8) NOT NULL,
  `capacity` int(11) DEFAULT NULL,
  `Booking_stat` varchar(10) DEFAULT NULL,
  `Booking_time` time DEFAULT NULL,
  `Emp_id` varchar(8) DEFAULT NULL,
  `Emp_fname` varchar(10) DEFAULT NULL,
  `Emp_lname` varchar(10) DEFAULT NULL,
  `cust_id` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `table_master`
--

INSERT INTO `table_master` (`Table_id`, `capacity`, `Booking_stat`, `Booking_time`, `Emp_id`, `Emp_fname`, `Emp_lname`, `cust_id`) VALUES
('T01', 8, 'Not_Booked', NULL, 'E05', 'Jugal', 'Naik', ''),
('T02', 8, 'not_booked', NULL, 'E04', 'Brijesh', 'Gohil', ''),
('T03', 6, 'Not_Booked', NULL, 'E03', 'Hardik', 'Gajjar', ''),
('T04', 6, 'not_booked', NULL, 'E02', 'Vishal', 'Sharma', ''),
('T05', 4, 'Not_Booked', NULL, 'E01', 'Akshat', 'Shah', ''),
('T06', 4, 'not_booked', NULL, 'E05', 'Jugal', 'Naik', ''),
('T07', 4, 'not_booked', NULL, 'E04', 'Brijesh', 'Gohil', ''),
('T08', 2, 'Not_Booked', NULL, 'E03', 'Hardik', 'Gajjar', ''),
('T09', 2, 'Not_Booked', NULL, 'E02', 'Vishal', 'Sharma', ''),
('T10', 2, 'Not_Booked', NULL, 'E01', 'Akshat', 'Shah', '');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`) VALUES
('manager', 'abc123'),
('staff', 'pqr123');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`Bill_no`),
  ADD KEY `Table_id` (`Table_id`),
  ADD KEY `Cust_id` (`Cust_id`),
  ADD KEY `Order_id` (`Order_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `chef`
--
ALTER TABLE `chef`
  ADD PRIMARY KEY (`Chef_id`),
  ADD KEY `Chef_id` (`Chef_id`,`Chef_fname`,`Chef_lname`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`Cust_id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`Emp_id`,`Emp_fname`,`Emp_lname`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`Food_id`,`Food_name`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `left_employee`
--
ALTER TABLE `left_employee`
  ADD PRIMARY KEY (`datetime`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `Table_id` (`Table_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`Food_id`,`Order_id`,`current_time`),
  ADD KEY `Food_id` (`Food_id`,`Food_name`);

--
-- Indexes for table `order_status`
--
ALTER TABLE `order_status`
  ADD PRIMARY KEY (`Order_id`);

--
-- Indexes for table `payement`
--
ALTER TABLE `payement`
  ADD PRIMARY KEY (`Payement_id`),
  ADD KEY `Bill_no` (`Bill_no`);

--
-- Indexes for table `price_increase`
--
ALTER TABLE `price_increase`
  ADD PRIMARY KEY (`cur_date`,`food_id`,`food_name`),
  ADD KEY `food_id` (`food_id`,`food_name`);

--
-- Indexes for table `table_master`
--
ALTER TABLE `table_master`
  ADD PRIMARY KEY (`Table_id`),
  ADD KEY `Emp_id` (`Emp_id`,`Emp_fname`,`Emp_lname`),
  ADD KEY `cust_id` (`cust_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `Bill_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `payement`
--
ALTER TABLE `payement`
  MODIFY `Payement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`Table_id`) REFERENCES `table_master` (`Table_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`Cust_id`) REFERENCES `customer` (`Cust_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chef`
--
ALTER TABLE `chef`
  ADD CONSTRAINT `chef_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `chef_ibfk_3` FOREIGN KEY (`Chef_id`,`Chef_fname`,`Chef_lname`) REFERENCES `employee` (`Emp_id`, `Emp_fname`, `Emp_lname`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `food`
--
ALTER TABLE `food`
  ADD CONSTRAINT `food_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`Table_id`) REFERENCES `table_master` (`Table_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`Food_id`,`Food_name`) REFERENCES `food` (`Food_id`, `Food_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payement`
--
ALTER TABLE `payement`
  ADD CONSTRAINT `payement_ibfk_1` FOREIGN KEY (`Bill_no`) REFERENCES `bill` (`Bill_no`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `table_master`
--
ALTER TABLE `table_master`
  ADD CONSTRAINT `table_master_ibfk_1` FOREIGN KEY (`Emp_id`,`Emp_fname`,`Emp_lname`) REFERENCES `employee` (`Emp_id`, `Emp_fname`, `Emp_lname`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
