
create Database university 

use university

create table instructor ( 
is_id int primary key identity (1,1) ,
inadd nvarchar(50) check(inadd in('Alex','Cairo')),
hiredate date default getdate(),
bd date,
fname nvarchar(100) not null,
lname nvarchar(100) not null,
sal decimal(8,2) check(sal between 1000 and 5000)  default 3000 ,
overtime decimal(8,2) unique,
netsal as sal+overtime persisted,
age as year(getdate())-year(bd))

create table course (
cid int primary key identity (1,1),
cname nvarchar(150),
duration time unique )

create table teach_crs (
ins_id int ,
cid int ,
constraint c1 primary key (ins_id ,cid),
constraint c2 foreign key (ins_id) references instructor(is_id) on delete cascade on update cascade ,
constraint c3 foreign key (cid) references course(cid) on delete cascade on update cascade)


create table lab ( 
cid int ,
lid int ,
location nvarchar (100),
capacity int check(capacity <20),
constraint c4 primary key(cid,lid),
constraint c5 foreign key (cid) references course (cid) on delete cascade on update cascade )





