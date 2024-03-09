CREATE USER nai
IDENTIFIED BY cali;

REM Dar los privilegios necesarios a el nuevo usuario
GRANT create session, create table,
create sequence, create view
TO nai with ADMIN OPTION;

CREATE TABLE review ( id VARCHAR2(50),
updated_at TIMESTAMP, 
created_at TIMESTAMP, 
user_id VARCHAR2(50), 
place_id VARCHAR2(50),
text VARCHAR2(255));

CREATE TABLE "User" ( id VARCHAR2(50),
updated_at TIMESTAMP,
created_at TIMESTAMP,
email VARCHAR2(255), 
password VARCHAR2(255),
first_name VARCHAR2(100),
last_name VARCHAR2(100));

CREATE TABLE Amenity ( id VARCHAR2(50),
updated_at TIMESTAMP, 
created_at TIMESTAMP,
name VARCHAR2(255)); 

CREATE TABLE PlaceAmenity ( amenity_id VARCHAR2(50),
place_id VARCHAR2(50) ); 

CREATE TABLE State ( id VARCHAR2(50),
updated_at TIMESTAMP,
created_at TIMESTAMP);

CREATE TABLE City ( id VARCHAR2(50),
updated_at TIMESTAMP,
created_at TIMESTAMP,
state_id VARCHAR2(50),
name VARCHAR2(255) );

CREATE TABLE Place ( id VARCHAR2(50),
updated_at TIMESTAMP,
created_at TIMESTAMP,
user_id VARCHAR2(50),
name VARCHAR2(255), 
city_id VARCHAR2(50),
description VARCHAR2(1000),
number_rooms INTEGER, 
number_bathrooms INTEGER,
max_guest INTEGER, 
price_by_night NUMBER,
latitude FLOAT, 
longitude FLOAT );

--
ALTER TABLE review
ADD CONSTRAINT pk_review PRIMARY KEY (id);

ALTER TABLE review
ADD CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES "User" (id);

ALTER TABLE review
ADD CONSTRAINT fk_review_place FOREIGN KEY (place_id) REFERENCES Place (id);

--
ALTER TABLE "User"
ADD CONSTRAINT pk_user PRIMARY KEY (id);

-- Tabla Amenity
ALTER TABLE Amenity
ADD CONSTRAINT pk_amenity PRIMARY KEY (id);

-- Tabla PlaceAmenity
ALTER TABLE PlaceAmenity
ADD CONSTRAINT fk_placeamenity_amenity FOREIGN KEY (amenity_id) REFERENCES Amenity (id);

ALTER TABLE PlaceAmenity
ADD CONSTRAINT fk_placeamenity_place FOREIGN KEY (place_id) REFERENCES Place (id);

-- Tabla State
ALTER TABLE State
ADD CONSTRAINT pk_state PRIMARY KEY (id);

-- Tabla City
ALTER TABLE City
ADD CONSTRAINT pk_city PRIMARY KEY (id);

ALTER TABLE City
ADD CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES State (id);

-- Tabla Place
ALTER TABLE Place
ADD CONSTRAINT pk_place PRIMARY KEY (id);

ALTER TABLE Place
ADD CONSTRAINT fk_place_user FOREIGN KEY (user_id) REFERENCES "User" (id);

ALTER TABLE Place
ADD CONSTRAINT fk_place_city FOREIGN KEY (city_id) REFERENCES City (id);
