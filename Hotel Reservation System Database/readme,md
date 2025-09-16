# Hotel Reservation System Database

This project provides a comprehensive database solution for a hotel reservation system, designed and implemented in Microsoft SQL Server. It includes a detailed schema, advanced database objects, and scripts to manage hotel operations, such as customer information, room inventory, reservations, payments, and staff management.

## Project Files

* [cite_start]**`Hotel_Reservation_System_Specification.pdf`**: This document provides a complete overview of the database design, including functional requirements, business rules, and a detailed breakdown of the schema, views, stored procedures, functions, and triggers. [cite: 1]
* **`Pro_Hotel.drawio.png`**: An Entity-Relationship (ER) diagram illustrating the relationships between the main entities in the system: **Customer**, **Room**, **Reservation**, **Staff**, and **Payment**.
* **`RelationalModel.drawio.png`**: A relational model diagram showing the tables, their primary keys (PK), and foreign keys (FK) that enforce the relationships.
* **`Pro2.sql`**: The SQL script for creating and populating the database. It contains the complete T-SQL code for all tables, constraints, views, stored procedures, functions, and triggers.

## Database Overview

[cite_start]The database is named `Hotel` and is designed to ensure operational efficiency and data integrity[cite: 6, 8]. The system's core functions include:

* [cite_start]Storing and managing customer contact information[cite: 11].
* [cite_start]Maintaining a room inventory with pricing and status tracking[cite: 12].
* [cite_start]Processing reservations with check-in and check-out functionality[cite: 13].
* [cite_start]Recording payments linked to reservations[cite: 14].
* [cite_start]Managing staff information and assignments[cite: 15].
* [cite_start]Preventing double-booking of rooms[cite: 16].
* [cite_start]Tracking the status of reservations throughout the customer journey[cite: 17].

## Schema and Tables

The database schema is structured around several key tables:

* **`Customer`**: Stores personal details of customers. [cite_start]It includes a primary key `Customer_ID` and defaults for `country` ('Egypt') and `city` ('cairo')[cite: 27, 29, 33].
* **`Cus_Phones`**: A table designed to handle multiple phone numbers for each customer. [cite_start]It uses a composite primary key of `customer_id` and `phone`[cite: 34, 36].
* **`Room`**: Defines properties for each room, such as `capacity`, `price`, `status`, and `RoomType`. [cite_start]It includes `CHECK` constraints to ensure valid values for `status` ('Available', 'Occupied', 'Under Maintenance') and `RoomType` ('Single', 'Double', 'Triple')[cite: 38, 42, 43].
* **`Staff`**: Contains information about hotel staff, including their `salary`. [cite_start]A `CHECK` constraint ensures all salaries are positive[cite: 47, 50].
* **`Reservation`**: The central table for tracking reservations. [cite_start]It includes foreign keys to the `Customer`, `Room`, and `Staff` tables[cite: 52, 58]. [cite_start]The `num_of_days` field is a computed column based on the check-in and check-out dates[cite: 55].
* [cite_start]**`Payment`**: Records financial transactions related to reservations[cite: 59].
* [cite_start]**`t_changespayment`**: An audit table that automatically tracks all `INSERT`, `UPDATE`, and `DELETE` operations on the `Payment` table, including the action type, date, and user[cite: 63, 64, 66].

## Advanced Database Objects

The project leverages several advanced SQL Server features to ensure data integrity and functionality:

### Views
* [cite_start]**`Current_Occupied`**: Displays all rooms that are currently occupied, along with the guest's name[cite: 75, 76].
* [cite_start]**`Customer_History`**: Provides a historical view of past stays and payments for each customer[cite: 79, 80].

### Stored Procedures
* [cite_start]**`sp_MakeReservation`**: A procedure that checks a room's availability and creates a new reservation if there are no date conflicts[cite: 84, 87].
* [cite_start]**`sp_Check_In`**: Updates a reservation's status to 'Checked-in' and assigns a staff member[cite: 88, 90].
* [cite_start]**`sp_CheckOut`**: Updates a reservation's status to 'Checked-out' and displays the reservation details[cite: 92, 94].

### Functions
* [cite_start]**`fn_CalculateStayDays`**: A scalar function that computes the number of nights between two dates[cite: 97, 98].
* [cite_start]**`fn_RoomAvailability`**: A scalar function that returns a bit value (`1` or `0`) indicating whether a specific room is available on a given date[cite: 102, 103, 105].

### Triggers
* [cite_start]**`ovlap_tr`**: An `INSTEAD OF INSERT` trigger on the `Reservation` table that prevents new reservations from being created if they overlap with an existing booking for the same room[cite: 108, 111].
* **`changes_payment`**: An `AFTER INSERT, UPDATE, DELETE` trigger on the `Payment` table. [cite_start]It logs all changes to the `t_changespayment` audit table[cite: 113, 115, 117].

## Installation and Setup

1.  Open **Microsoft SQL Server Management Studio (SSMS)**.
2.  Connect to your SQL Server instance.
3.  Open the `Pro2.sql` file.
4.  Execute the script. It will create the `Hotel` database, all necessary tables, constraints, views, stored procedures, functions, and triggers.
5.  You can then start using the database to manage hotel reservations.
