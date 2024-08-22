-------------FOR VISUALIZATION------------
alter session set nls_date_format = 'dd/MON/yyyy hh24:mi:ss';
set pagesize 100;
set linesize 200;
--
--SELECT 
--    id,
--    rider_id,
--    bike_id,
--    start_station,
--    end_station,
--    start_time,
--    end_time,
--    (24 * 60 * 60) * (end_time - start_time) AS ride_duration_seconds
--FROM 
--    bike_rides;

--select  * from stations join (select station_id,SUM(bike_amount) FROM bike_amounts GROUP BY station_id ORDER BY SUM(bike_amount) DESC) second_table on second_table.station_id=stations.station_id WHERE ROWNUM=1; 
SELECT AVG((end_time - start_time) * 24 * 60 * 60) AS "Average Duration (in seconds)"
FROM bike_rides;
SELECT COUNT(*) AS "Rides before 12 PM"
FROM bike_rides
WHERE EXTRACT(HOUR FROM start_time) < 12;


/*


---------------CREATING TABLE-----------------------
DROP TABLE bike_rides;
DROP TABLE bike_amounts;
DROP TABLE riders;
DROP TABLE stations;
DROP TABLE bike_types;
DROP SEQUENCE bike_rides_sequence;
DROP SEQUENCE riders_sequence;

CREATE TABLE bike_types(
   bike_id INTEGER PRIMARY KEY,
   bike_type VARCHAR2(40) NOT NULL
   );

CREATE TABLE stations(
    station_id INTEGER PRIMARY KEY,
    street_name VARCHAR2(40) NOT NULL,
    post_box_number INTEGER,
    upazila VARCHAR2(40),
    district VARCHAR2(40) 
   );

CREATE TABLE riders(
    rider_id INTEGER PRIMARY KEY,
    rider_name VARCHAR2(40) NOT NULL,
    phone_no INTEGER UNIQUE NOT NULL,
    building_number INTEGER,
    street_name VARCHAR2(60),
    post_box_number INTEGER,
    upazila VARCHAR2(40),
    district VARCHAR2(40),
    postal_code INTEGER
   );

CREATE TABLE bike_amounts(
    bike_id INTEGER NOT NULL,
    station_id INTEGER NOT NULL,
    bike_amount INTEGER NOT NULL CHECK(bike_amount>=0),  
    FOREIGN KEY(bike_id) REFERENCES bike_types(bike_id),
    FOREIGN KEY(station_id) REFERENCES stations(station_id)
    );

CREATE TABLE bike_rides(
   id INTEGER PRIMARY KEY,
   rider_id INTEGER NOT NULL,
   bike_id INTEGER NOT NULL,
   start_station INTEGER NOT NULL,
   end_station INTEGER NOT NULL,
   start_time DATE NOT NULL,
   end_time DATE NOT NULL,
   FOREIGN KEY(rider_id) REFERENCES riders(rider_id) ON DELETE CASCADE,
   FOREIGN KEY(bike_id) REFERENCES bike_types(bike_id),
   FOREIGN KEY(start_station) REFERENCES stations(station_id),
   FOREIGN KEY(end_station) REFERENCES stations(station_id),
   CONSTRAINT check_date_time CHECK(
   end_time > start_time
   )
  );


-------------------ADDING TRIGGERS----------------------

--creating sequences for auto incrementation primary key in bike_rides and riders table
CREATE SEQUENCE bike_rides_sequence;
CREATE SEQUENCE riders_sequence;

CREATE OR REPLACE TRIGGER bike_rides_on_insert
  BEFORE INSERT ON bike_rides
  FOR EACH ROW
BEGIN
  SELECT bike_rides_sequence.nextval
  INTO :new.id
  FROM dual;
END;

CREATE OR REPLACE TRIGGER riders_on_insert
  BEFORE INSERT ON riders
  FOR EACH ROW
BEGIN
  SELECT riders_sequence.nextval
  INTO :new.rider_id
  FROM dual;
END;

-- a trigger which will update the bike_amounts depending on the new bike_rides record
SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER update_bike_amounts
AFTER INSERT ON bike_rides 
FOR EACH ROW
Declare
start_station_id bike_rides.start_station%type;
end_station_id bike_rides.end_station%type;
bike_id BIKE_RIDES.BIKE_ID%type;
BEGIN
    start_station_id := :new.start_station;
    end_station_id := :new.end_station;
    bike_id := :new.bike_id;
    
    UPDATE bike_amounts set bike_amount=bike_amount+1 WHERE station_id=end_station_id AND bike_id = bike_id;
    UPDATE bike_amounts set bike_amount=bike_amount-1 WHERE station_id=start_station_id AND bike_id = bike_id;
--   dbms_output.put_line('START STATION: '||start_station_id|| ' END STATION: ' || end_station_id);
END;
/

-----------------------INSERTING DATA---------------------------
-- Populate bike_types table
INSERT INTO bike_types (bike_id, bike_type)
VALUES (1, 'Mountain Bike');

INSERT INTO bike_types (bike_id, bike_type)
VALUES (2, 'Road Bike');

INSERT INTO bike_types (bike_id, bike_type)
VALUES (3, 'Hybrid Bike');

-- Populate stations table
INSERT INTO stations (station_id, street_name, post_box_number, upazila, district)
VALUES (1, 'Station 1 Street', 1234, 'Upazila 1', 'District 1');

INSERT INTO stations (station_id, street_name, post_box_number, upazila, district)
VALUES (2, 'Station 2 Street', 5678, 'Upazila 2', 'District 2');

INSERT INTO stations (station_id, street_name, post_box_number, upazila, district)
VALUES (3, 'Station 3 Street', 91011, 'Upazila 3', 'District 3');

-- Populate riders table
INSERT INTO riders (rider_id, rider_name, phone_no, building_number, street_name, post_box_number, upazila, district, postal_code)
VALUES (1, 'Rider 1', 1234567890, 101, 'Rider Street 1', 1111, 'Rider Upazila 1', 'Rider District 1', 12345);

INSERT INTO riders (rider_id, rider_name, phone_no, building_number, street_name, post_box_number, upazila, district, postal_code)
VALUES (2, 'Rider 2', 9876543210, 202, 'Rider Street 2', 2222, 'Rider Upazila 2', 'Rider District 2', 54321);

INSERT INTO riders (rider_id, rider_name, phone_no, building_number, street_name, post_box_number, upazila, district, postal_code)
VALUES (3, 'Rider 3', 1237894560, 303, 'Rider Street 3', 3333, 'Rider Upazila 3', 'Rider District 3', 67890);

-- Populate bike_amounts table
INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (1, 1, 10);
INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (1, 2, 15);
INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (1, 3, 12);

INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (2, 2, 15);
INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (2, 3, 25);
INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (2, 1, 6);

INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (3, 3, 20);

INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (3, 1, 22);

INSERT INTO bike_amounts (bike_id, station_id, bike_amount)
VALUES (3, 2, 11);

-- Populate bike_rides table
INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (1, 1, 1, 2, TO_DATE('2024-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (2, 2, 2, 3, TO_DATE('2024-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 13:35:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (3, 3, 1, 2, TO_DATE('2024-04-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (1, 1, 3, 2, TO_DATE('2024-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 11:55:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (2, 2, 3, 3, TO_DATE('2024-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (3, 3, 2, 1, TO_DATE('2024-04-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 16:15:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (1, 1, 2, 2, TO_DATE('2024-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 11:16:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (2, 2, 2, 3, TO_DATE('2024-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (3, 3, 2, 1, TO_DATE('2024-04-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 15:35:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (1, 1, 3, 2, TO_DATE('2024-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 11:55:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (2, 2, 1, 3, TO_DATE('2024-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 13:35:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (3, 3, 1, 1, TO_DATE('2024-04-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 15:34:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (1, 1, 3, 2, TO_DATE('2024-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (2, 2, 1, 3, TO_DATE('2024-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (3, 3, 2, 1, TO_DATE('2024-04-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO bike_rides (rider_id, bike_id, start_station, end_station, start_time, end_time)
VALUES (1, 1, 2, 2, TO_DATE('2024-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));

*/
