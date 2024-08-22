# Bike Sharing App Database
The bike sharing database system is designed to efficiently manage the operations and
data associated with a bike sharing service. This system aims to provide a seamless
experience for users, administrators, and managers involved in the bike sharing process.

This project is implemented in oracle 11g as a lab project for ***CSE 3110: Database Systems Laboratory***. There is a attached project proposal pdf file too.

# Design
The bike sharing database system is designed using a star schema approach, which is
well-suited for data warehousing and analytical purposes. This design allows for efficient
querying and analysis of data, providing valuable insights into bike sharing operations.
In the star schema design, the central fact table represents the core data of the system,
surrounded by tables that provide additional context and details. This design
simplifies queries and allows for fast aggregation of data

# Schema
![Screenshot 2024-05-02 113758](https://github.com/user-attachments/assets/6eebfe50-978e-42c3-a132-e5c1d76866ab)


# Tables
There are five tables in this database
  1. **Bike Rides:** Tracks information about the rides taken by users, including rider id, start station
  id, end station id, byke type, start time, end time. It has a one to many relationship
  with Riders table.
  2. **Riders:** Stores information about the users registered in the system, including rider ID,
  name, email, phone number, and other relevant details. It is the center table in the
  database system connected to all the tables other than Bike Amounts table.
  3. **Bike Types:** Stores information about different types of bikes available in the system, including
  bike type ID, name. It has a one to many relationship with tabl Bike Amounts table.
  4. **Stations:** Contains information about the bike stations, including station ID, name, location
  etc. It has a one to many table Bike Amounts table.
  5. **Bike Amounts:** Keeps track of the number of bikes available, broken down by bike type and
  stations. The linking table which connects Stations and Bike Types table

# Featurs
Some core featuers of this database systems are 
  * Use of different constraints such as-

      1. Primary Constraint
      2. Unique Constraint
      3. Non Null Constraint
      4. Check Constraint

  * Relationships used:

      1. one to many
      2. many to many
         
  * Use of Triggers-
  
      1. **bike_rides_on_insert:**  auto incrementation of primary keys in Bike
      Rides table and Riders Table as they would be updated all the time with new rides or user
      data. Only in oracle we have to do this. In other sql languages like mysql you do not have go
      through this lengthy process.
      2. **update_bike_amounts:** It is triggered when a new row is inserted in the rides table. The amount bike would
      increase in end station and decrease in start station for corresponding bike type
      
# CONCLUSION:
  The bike sharing database system represents a comprehensive solution for efficiently
  managing bike sharing operations and data. By implementing a star schema design using
  Oracle 11g, we have created a robust and scalable database system that meets the needs
  of various stakeholders involved in bike sharing services.

