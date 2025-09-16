
-- first we will create database and we will call it Hotel

create database Hotel

-- we will switch to Hotel database from master 

use Hotel 

-- we will create tables one by one 
-- creating customer table 

create table customer (
Customer_ID int primary key identity(1,1),
Cus_Name varchar(150) not null,
Cus_Email varchar(200) not null,
country varchar(100) default 'Egypt',
city varchar(100) default 'cairo',
street varchar(100))

--creating Customer-Phones Table 

create table Cus_Phones(
customer_id int,
phone varchar(50),
constraint c1 primary key (customer_id,phone),
constraint c2 foreign key (customer_id) references customer(Customer_ID) on delete cascade on update cascade)  


-- creating Room Table 

create table room (
Room_ID int primary key identity(1,1),
capacity tinyint not null,
price int not null,
status varchar(200) check (status in ( 'Available' , 'Occupied', 'Under Maintenance')),
RoomType varchar(200) check (RoomType in ('Single','Double','Triple')))


-- creating Staff Table 

create table staff (
staff_ID int primary key identity(1,1),
Name varchar(200) not null,
role varchar(200) not null,
phone varchar(200) not null,
salary decimal(8,2) not null)

-- creating reservation table 

create table reservation(
reservation_id int primary key identity(1,1),
check_in_date datetime not null,
check_out_date datetime not null,
num_of_days as datediff(day,check_in_date,check_out_date),
status varchar(200) check( status in ('pending', 'Confirmed', 'Cancelled', 'Checked-in', 'Checked-out')),
customer_id int not null,
room_id int not null,
staff_id int,
constraint c4 foreign key (customer_id) references customer(Customer_ID) on delete cascade on update cascade,
constraint c5 foreign key (room_id) references room(room_ID) on delete cascade on update cascade,
constraint c6 foreign key (staff_id) references staff(staff_ID) on delete cascade on update cascade)



-- creating payment table 

create table payment(
Payment_ID int primary key identity(1,1),
Amount decimal(8,2) not null,
payment_date date not null,
method varchar(200),
reservation_Id int not null, 
constraint c3 foreign key (reservation_id) references reservation(reservation_id) on delete cascade on update cascade)

-- Staff salaries must always be positive numbers.

alter table staff add constraint c7 check(salary >0)


-- Views

-- Current_Occupied : Shows all currently occupied rooms with guest names.

create view Current_Occupied
as 
select m.Room_ID,c.Cus_Name from room m 
inner join reservation r 
on r.room_id = m.Room_ID 
inner join customer c
on r.customer_id = c.Customer_ID 
where getdate() between r.check_in_date and r.check_out_date 


-- CustomerHistory : Shows past stays and payments for each customer.

create view Customer_History 
as 
select c.Cus_Name ,p.Amount,r.check_in_date,r.check_out_date,r.num_of_days from reservation r
inner join customer c 
on r.customer_id = c.Customer_ID 
inner join payment p 
on r.reservation_id = p.reservation_Id
where r.check_out_date < getdate()
 

-- Stored Procedures

-- sp_MakeReservation(CustomerID, RoomID, CheckIn, CheckOut)
-- Checks availability and inserts reservation.

create proc sp_MakeReservation (@CustomerID int ,@RoomID int , @CheckIn datetime, @CheckOut datetime)
as 
  begin 
    if exists ( select * from reservation r 
      where r.room_id =@RoomID and (@CheckIn < r.check_out_date and @CheckOut > r.check_in_date))
        select 'The room is not avaiable for the selected dates'
    else 
      insert into reservation (customer_id,room_id,check_in_date,check_out_date) values 
      (@CustomerID,@RoomID,@CheckIn,@CheckOut)
    end 
        

-- sp_CheckIn(ReservationID, StaffID)
-- Marks reservation as "Checked-In" and assigns staff.
create proc sp_Check_In (@ReservationID int ,@StaffID int)
as 
   begin 
      if not exists ( select * from reservation where reservation_id = @ReservationID)  
          begin 
            select 'The Reservation not found'
            return 
          end 
      
      if exists ( select * from reservation where reservation_id = @ReservationID and status='Checked-in')
         begin 
            select 'The reservation already checked in'
            return
         end 
      
      update reservation set status='Checked-in',staff_id=@StaffID
      where reservation_id = @ReservationID 
    end 

-- sp_CheckOut(ReservationID)
-- Marks reservation as "Checked-Out" and generates invoice.

create proc sp_CheckOut (@ReservationID int) 
as 
   begin 
      if not exists( select * from reservation where reservation_id = @ReservationID )
       begin 
          select 'The reservation not found'
          return 
       end
      
      if exists( select * from reservation where reservation_id = @ReservationID and status = 'Checked-out')
        begin 
           select 'The reservation already checked out'
           return 
        end 

      update reservation set status ='Checked-out' where reservation_id =@ReservationID
      
      select  * from reservation where reservation_id = @ReservationID

    end 
     


-- Indexes

create nonclustered index f_in on reservation(check_in_date,check_out_date)

create nonclustered index s_in on payment(reservation_id)



-- Functions 

-- fn_CalculateStayDays(@CheckIn, @CheckOut) Scalar Function 
-- Returns number of nights.

create function fn_CalculateStayDays(@CheckIn date , @CheckOut date)
returns int 
as
begin 
     declare @diff int
     set @diff = datediff(day,@CheckIn,@CheckOut)
     return @diff
end 


-- fn_RoomAvailability(@RoomID, @Date)
-- Returns TRUE/FALSE if the room is free on given date.

create function fn_RoomAvailability (@RoomID int, @Date date)
returns bit 
as 
   begin 
      if not exists ( select * from room where room_id = @RoomID) 
         return 0 
      if exists (select * from reservation r inner join room m on r.room_id = m.Room_ID where r.room_id = @RoomID and @Date <= r.check_out_date and @Date >= r.check_in_date ) 
         return 0 
      return 1
    end 

-- Triggers

-- Trigger on reservation to prevent overlapping reservations 
   
create trigger ovlap_tr
on reservation 
instead of insert 
as 
   begin 
      insert into reservation (check_in_date,check_out_date,status,customer_id,room_id,staff_id)
      select i.check_in_date,i.check_out_date,i.status,i.customer_id,i.room_id,i.staff_id from inserted i where not Exists ( select * from reservation r where r.room_id = i.room_id and i.check_in_date < r.check_out_date and i.check_out_date > r.check_in_date)
   end 

     

-- trigger to save all changes on payment table 

drop table t_changespayment

create table t_changespayment( 
id int primary key identity (1,1),
paymentid int,
reservation_id int,
amount decimal(5,2),
ActionType varchar(100),
ActionDate datetime default getdate(),
ActionUser nvarchar(200) default suser_sname())




create trigger changes_payment
on payment
after insert, update, delete
as
begin
   
    if exists (select 1 from inserted) and not exists (select 1 from deleted)
    begin
        insert into t_changespayment (paymentid, reservation_id, amount, actiontype, actiondate, actionuser)
        select i.Payment_ID, i.reservation_id, i.Amount, 'insert', getdate(), suser_sname()
        from inserted i;
    end

    if exists (select 1 from inserted) and exists (select 1 from deleted)
    begin
        insert into t_changespayment (paymentid, reservation_id, amount, actiontype, actiondate, actionuser)
        select d.Payment_ID, d.reservation_id, d.Amount, 'update-old', getdate(), suser_sname()
        from deleted d;

   
        insert into t_changespayment (paymentid, reservation_id, amount, actiontype, actiondate, actionuser)
        select i.Payment_ID, i.reservation_id, i.Amount, 'update-new', getdate(), suser_sname()
        from inserted i;
    end

    if exists (select 1 from deleted) and not exists (select 1 from inserted)
    begin
        insert into t_changespayment (paymentid, reservation_id, amount, actiontype, actiondate, actionuser)
        select d.Payment_ID, d.reservation_id, d.Amount, 'delete', getdate(), suser_sname()
        from deleted d;
    end
end
