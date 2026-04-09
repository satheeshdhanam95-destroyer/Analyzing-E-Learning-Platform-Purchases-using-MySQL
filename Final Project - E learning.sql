create database E_Learning;
use E_learning;

create table Learners (
Learner_id int auto_increment primary key,
Full_name varchar(100),
Country varchar(100)
);

create table Courses(
Course_Id int auto_increment primary key,
Course_name varchar (100),
Category varchar(50),
Unit_price decimal (10,2)
);

create table Purchases(
Purchase_id int auto_increment primary key,
Learner_id int,
Course_id int,
Quantity int,
Purchase_date Date default(current_date()),
foreign key (Learner_id) references Learners(Learner_id),
foreign key (Course_id) references Courses(Course_id)
);


INSERT INTO Learners(Full_name,Country) VALUES
("Satheesh","India"),
("Manimegalai","Canada"),
("Preeth","Paris"),
("Saravanan","Thailand"),
("Nagaleswaran","America"),
("Rameshwari","America"),
("Ramakrishnan","America"),
("Dhanalakshmi","Thailand"),
("Jishnu","Singapore"),
("Mounish","China"),
("Shiva","India"),
("Tamilselvi","Canada"),
("Suhasini","Canada"),
("Viju","Thailand"),
("Kiran","Singapore"),
("Rajeesh","Paris"),
("Adarsh","Singapore"),
("MohanKumar","china"),
("Uma","Paris"),
("Kalai","Singapore");

insert into Courses(Course_name,Category,Unit_price) values 
("Data Science Basics","D Science",19.99),
("Python for Beginners","Programming",49.99),
("Advanced_Machine_Learning","AI",150.00),
("Digital_Marketing101","Marketing",29.99),
("React Web Development","Web Development",99.99),
("UX Design Fundamentals","Design",79.99),
("Project Management Professional","Business",120.00),
("Cybersecurity Essentials","IT",199.99),
("Cloud Computing with AWS","IT",149.99),
("Financial Modeling","Finance",89.99),
("Social Media Strategy","Marketing",39.99),
("Data Analytics with SQL","Data Science",69.99),
("Artificial Intelligence Basics","AI",110.00),
("Full Stack Development","Web Development",250.00),
("Mobile App Development","Web Development",180.00),
("Human Resources Management","Business",45.00),
("Language Learning ","Spanish Languages",25.00),
("Mathematics for Data Science","Data Science",95.00
);

Insert into Purchases (Learner_id,Course_id,Quantity,Purchase_date)  VALUES
(1,1,1,"2024-01-15"),
(2,2,2,"2024-01-16"),
(3,3,1,"2024-01-16"),
(4,4,5,"2024-01-17"),
(6,6,1,"2024-01-18"),
(7,7,1,"2024-01-20"),
(8,8,3,"2024-01-21"),
(10,10,2,"2024-01-22"),
(11,11,1,"2024-01-23"),
(12,12,1,"2024-01-24"),
(13,13,1,"2024-01-25"),
(14,14,1,"2024-01-26"),
(15,15,1,"2024-01-26"),
(16,16,4,"2024-01-27"),
(17,17,1,"2024-01-28"),
(18,18,2,"2024-01-29"),
(19,5,1,"2024-01-30"),
(20,7,1,"2024-01-31");



select * from purchases;
select * from courses;
select * from learners;


#data exploration using joins
# format currency values to decimal places
select course_name,round(unit_price,2) as formatted_price from courses;	

#●	Use aliases for column names (e.g., AS total_revenue).
select course_name as course,unit_price as price from courses;

#Sort by total_spent (highest first)
SELECT 
    l.full_name as learner_name,
    c.course_name as course_name,
    p.quantity as quantity,
    format(c.Unit_price * p.Quantity, 2) as total_spent
from purchases p
join learners l on p.Learner_id = l.Learner_id
join courses c on p.Course_id = c.Course_id
order by quantity desc;


#Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to

#	Combine learner, course, and purchase data
select
    l.full_name as learner_name,
    l.country as country,
    c.course_name as course_name,
    c.Category as course_category,
    p.Quantity as quantity,
    format(c.Unit_price, 2) as unit_price,
    format(c.Unit_price * p.Quantity, 2) as total_spent
from Purchases p
inner join Learners l 
on p.Learner_id = l.Learner_id
inner join Courses c 
on p.Course_id = c.Course_id
order by (c.Unit_price * p.Quantity) DESC;


# Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date

select
    l.Full_name as learner_name,
    c.Course_name as course_name,
    c.Category as category,
    p.Quantity as quantity,
	format (c.Unit_price * p.Quantity, 2) as total_amount,
    p.Purchase_date as purchase_date
from Purchases p
join Learners l 
on p.Learner_id = l.Learner_id
join Courses c 
on p.Course_id = c.Course_id
order by (c.Unit_price * p.Quantity) DESC;

select 
    l.Full_name as learner_name,
    l.Country as country,
    format(sum(c.Unit_price * p.Quantity), 2) as total_spending
from Purchases p
join Learners l 
    on p.Learner_id = l.Learner_id
join Courses c 
    on p.Course_id = c.Course_id
group by l.Learner_id, l.Full_name, l.Country
order by sum(c.Unit_price * p.Quantity) desc;

#Find the top 3 most purchased courses based on total quantity sold

select
    c.Course_name as course_name,
    c.Category as category,
    sum(p.Quantity) as total_quantity_sold
from Purchases p
join Courses c 
    on p.Course_id = c.Course_id
group by c.Course_id, c.Course_name, c.Category
order by total_quantity_sold desc
limit 3;

#Show each course category’s total revenue and the number of unique learners who purchased from that category

select
c.Category as category,
format(SUM(c.Unit_price * p.Quantity), 2) as total_revenue,
count(distinct p.Learner_id) as unique_learners
from Purchases p
join Courses c 
on p.Course_id = c.Course_id
group by c.Category
order by sum(c.Unit_price * p.Quantity) desc;

#List all learners who have purchased courses from more than one category.

SELECT 
    l.learner_id,
    l.full_name,
count(distinct c.category) as category_count
from Purchases p
join Learners l 
on p.Learner_id = l.Learner_id
join Courses c 
on p.Course_id = c.Course_id
group by l.Learner_id, l.Full_name
having count(distinct c.category) > 1;

#Identify courses that have not been purchased at all

SELECT 
    c.course_id,
    c.course_name,
    c.category
from courses c
left join Purchases p 
on c.course_id = p.course_id
where p.Course_id is null;











