# Hotel Reservation System Database

This project provides a comprehensive database solution for a hotel reservation system, designed and implemented in Microsoft SQL Server. It includes a detailed schema, advanced database objects, and scripts to manage hotel operations, such as customer information, room inventory, reservations, payments, and staff management.

## Project Files

* **`Hotel_Reservation_System_Specification.pdf`**: This document provides a complete overview of the database design, including functional requirements, business rules, and a detailed breakdown of the schema, views, stored procedures, functions, and triggers. 
* **`Pro_Hotel.drawio.png`**: An Entity-Relationship (ER) diagram illustrating the relationships between the main entities in the system: **Customer**, **Room**, **Reservation**, **Staff**, and **Payment**.
* **`RelationalModel.drawio.png`**: A relational model diagram showing the tables, their primary keys (PK), and foreign keys (FK) that enforce the relationships.
* **`Pro2.sql`**: The SQL script for creating and populating the database. It contains the complete T-SQL code for all tables, constraints, views, stored procedures, functions, and triggers.

## Database Overview

The database is named `Hotel` and is designed to ensure operational efficiency and data integrity. The system's core functions include:

* Storing and managing customer contact information.
* Maintaining a room inventory with pricing and status tracking.
* Processing reservations with check-in and check-out functionality.
* Recording payments linked to reservations.
* Managing staff information and assignments.
* Preventing double-booking of rooms.
* Tracking the status of reservations throughout the customer journey.

## Schema and Tables

The database schema is structured around several key tables:

* **`Customer`**: Stores personal details of customers.It includes a primary key `Customer_ID` and defaults for `country` ('Egypt') and `city` ('cairo').
* **`Cus_Phones`**: A table designed to handle multiple phone numbers for each customer.It uses a composite primary key of `customer_id` and `phone`.
* **`Room`**: Defines properties for each room, such as `capacity`, `price`, `status`, and `RoomType`.It includes `CHECK` constraints to ensure valid values for `status` ('Available', 'Occupied', 'Under Maintenance') and `RoomType` ('Single', 'Double', 'Triple').
* **`Staff`**: Contains information about hotel staff, including their `salary`.A `CHECK` constraint ensures all salaries are positive.
* **`Reservation`**: The central table for tracking reservations.It includes foreign keys to the `Customer`, `Room`, and `Staff`.The `num_of_days` field is a computed column based on the check-in and check-out dates.
* **`Payment`**: Records financial transactions related to reservations.
* **`t_changespayment`**: An audit table that automatically tracks all `INSERT`, `UPDATE`, and `DELETE` operations on the `Payment` table, including the action type, date, and user.

## Advanced Database Objects

The project leverages several advanced SQL Server features to ensure data integrity and functionality:

### Views
* **`Current_Occupied`**: Displays all rooms that are currently occupied, along with the guest's name.
* **`Customer_History`**: Provides a historical view of past stays and payments for each customer.

### Stored Procedures
* **`sp_MakeReservation`**: A procedure that checks a room's availability and creates a new reservation if there are no date conflicts.
* **`sp_Check_In`**: Updates a reservation's status to 'Checked-in' and assigns a staff member.
* **`sp_CheckOut`**: Updates a reservation's status to 'Checked-out' and displays the reservation details.

### Functions
* **`fn_CalculateStayDays`**: A scalar function that computes the number of nights between two dates.
* **`fn_RoomAvailability`**: A scalar function that returns a bit value (`1` or `0`) indicating whether a specific room is available on a given date.

### Triggers
* **`ovlap_tr`**: An `INSTEAD OF INSERT` trigger on the `Reservation` table that prevents new reservations from being created if they overlap with an existing booking for the same room.
* **`changes_payment`**: An `AFTER INSERT, UPDATE, DELETE` trigger on the `Payment` table. It logs all changes to the `t_changespayment` audit table.

## Installation and Setup

1.  Open **Microsoft SQL Server Management Studio (SSMS)**.
2.  Connect to your SQL Server instance.
3.  Open the `Pro2.sql` file.
4.  Execute the script. It will create the `Hotel` database, all necessary tables, constraints, views, stored procedures, functions, and triggers.
5.  You can then start using the database to manage hotel reservations.
