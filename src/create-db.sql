#! /bin/sh
exec sh -c "mkdir -p .data/backup && mv ./.data/data.db ./.data/backup/data-$(date +%s).db  || true && tail -n +3 $0 | sqlite3 .data/data.db"

PRAGMA foreign_keys=ON;

BEGIN TRANSACTION;
CREATE TABLE account (
  service_name TEXT,
  username TEXT,
  url TEXT
);

INSERT INTO account (service_name, username, url)
VALUES
  ('linkedin',' hwprins',' https://www.linkedin.com/in/hwprins'),
  ('github',' harryvederci',' https://www.github.com/harryvederci');

create table country (
  id integer primary key,
  name text
);

insert into country (name)
values
  ('The Netherlands'),
  ('Germany');

create table city (
  id integer primary key,
  name text,
  country_id integer,
  foreign key (country_id) references country(id)
    on update cascade
    on delete restrict
);

insert into city (name, country_id)
values
  ('Groningen',1),
  ('Frankfurt',2),
  ('Rotterdam',1),
  ('The Hague',1),
  ('Delft',1);

CREATE TABLE project (
  id INTEGER PRIMARY KEY,
  nickname TEXT,
  job_title TEXT,
  employer TEXT,          -- TODO: create employer table, with id + name columns. Refer to id here.
  employer_city INTEGER,
  -- TODO: add work_city column for Groningen-PoR-Munich type situations?
  client TEXT,            -- TODO: add comment explaining difference between employer and client.
  client_city TEXT,
  description TEXT,
  time_period TEXT,        -- TODO: break up in start_date and end_date (mm YYYY)
  foreign key (employer_city) references city(id)
    on update cascade
    on delete restrict
);

INSERT INTO project (nickname, job_title, employer, employer_city, client, client_city, description, time_period)
VALUES
  ('RWS Harvester','Backend Developer','IBM CIC Benelux',1,'RWS (Dutch Directorate-General for Public Works and Water Management)',5,'I created an application that retrieves sensor measurements, transforms them, and writes them to a database that is used by a publicly available service.','jan 2020 - now'),
  ('Harvester PoC','Backend Developer','IBM CIC Benelux',1,'RWS',5,'As a Proof of Concept, I created and demonstrated a "Harvester" application that retrieves sensor measurements, transforms them, and writes them to a database that is used by a publicly available service. The Proof of Concept was a success, and was directly followed up by a 6-figure project.','nov 2019 - dec 2019'),
  ('MuxProxy','Backend Developer','IBM CIC Benelux',1,'RWS',5,'For Rijkswaterstaat (the Dutch Directorate-General for Public Works and Water Management) I created an application that forwards incoming sensor data in a non-blocking way. I added a feature to compress messages and send them as a batch, to lower the application its bandwidth usage.','aug 2019 - nov 2019'),
  ('CE/DR','DevOps Engineer','IBM CIC Benelux',1,null,null,'I containerized a Meteor/MongoDB application, configured Red Hat Enterprise Linux servers, and deployed the application using Docker Swarm. I also added an Nginx service to proxy requests and provide TLS/SSL support.','jun 2019 - aug 2019'),
  ('CIC Websites','Full Stack Developer','IBM CIC Benelux',1,null,null,'I merged 9 applications (database, backend, and frontend) into one, enabling a smoother deployment process while cutting down hosting costs. I added new features, pushed them to production, and moved the application to the ibm.com domain.','dec 2018 - jun 2019'),
  ('PoR Microservices','Backend Developer','IBM CIC Benelux',1,'Port of Rotterdam',3,'I was involved in the creation of several Java microservices for an award winning Port of Rotterdam enterprise IoT application. My team independently designed solutions and took care of the DevOps process.','apr 2018 - dec 2018'),
  ('PoR GUI','Front End Developer','IBM CIC Benelux',1,'Port of Rotterdam',3,'I improved the quality, structure and development workflow of an enterprise IoT application for Port of Rotterdam. I did this by unit testing and refactoring existing code, adding new features, and reviewing the code of other developers. I also added a test validation script to ensure reviewers that new code will not break existing features.','jan 2018 - apr 2018'),
  ('EA VAT','Front End Developer','IBM CIC Benelux',1,null,null,'For IBM, I was involved in the development of a tool that clients and consultants can use to assess the value of enterprise applications.','dec 2017 - dec 2017'),
  ('SportInnovator','Full Stack Developer','IBM CIC Benelux',1,'SportInnovator',4,'I added new features to a government-owned Ruby on Rails application about innovation in sports. I deployed changes to production myself.','jul 2017 - dec 2017'),
  ('PoR PoC Munich','Front End Developer','IBM CIC Benelux',1,'Port of Rotterdam',3,'As a Proof of Concept, I created the front end of an application that visualises data collected by sensors in the Port of Rotterdam. The Proof of Concept was a success, and was followed up by a big enterprise project spanning multiple years.','aug 2017 - jul 2017'),
  ('Apple-style Microsite','Front End Developer','IBM CIC Benelux',1,null,null,'To impress an important potential client for IBM, I created a beautiful Apple-style microsite.','jul 2017 - aug 2017'),
  ('Watson Bank','Front End Developer','IBM CIC Benelux',1,null,2,'For a major German bank, I went to Frankfurt to create the front end of an IBM Watson application. With a rapidly approaching deadline, I made creative solutions to overcome the limitations of a very restricted developing environment.','jun 2017 - jul 2017'),
  ('Biometry Law Evaluation','Student-Researcher (graduation project)','University of Groningen',null,null,null,'For an official law evaluation, I wrote a Python application to analyze if Dutch government agencies acted in compliance with the law when collecting biometric data from foreigners.','jun 2016 - jan 2017');


create table technology
(
   id INTEGER PRIMARY KEY,
   name TEXT NOT NULL
);

insert into technology (name)
values
  ('Spring Boot'),
  ('SQL'),
  ('SQL (Oracle)'),
  ('Netty'),
  ('Docker'),
  ('Nginx'),
  ('RHEL'),
  ('Java'),
  ('Vimscript'),
  ('React'),
  ('Python'),
  ('Angular 2+'),
  ('TypeScript'),
  ('Ansible'),
  ('Shell Scripting'),
  ('Node.js'),
  ('Ruby on Rails'),
  ('Haskell'),
  ('Clojure'),
  ('Scala');


create table project_technologies
(
   id INTEGER PRIMARY KEY,
   project_id INTEGER,
   technology_id INTEGER,
   FOREIGN KEY (project_id) REFERENCES project(id)
     ON UPDATE CASCADE
     ON DELETE CASCADE,
   FOREIGN KEY (technology_id) REFERENCES technology(id)
     ON UPDATE CASCADE
     ON DELETE CASCADE
);

insert into project_technologies (project_id, technology_id)
values
  (1,8),
  (1,1),
  (1,3),
  (2,8),
  (2,1),
  (2,3),
  (3,8),
  (3,1),
  (3,4),
  (5,12),
  (7,12),
  (10,12),
  (11,12),
  (13,11),
  (4, 5),
  (4, 6),
  (4, 7),
  (5, 8),
  (5, 1),
  (5, 9),
  (6, 8),
  (6, 1),
  (8, 10),
  -- TODO: add HTML/CSS/JS to project 12
  (9, 17);



CREATE TABLE skill
(
   level INTEGER, -- Level, on a scale from 1 to 5.
   technology_id INTEGER,
   FOREIGN KEY (technology_id) REFERENCES technology(id)
     ON UPDATE CASCADE
     ON DELETE CASCADE
);

INSERT INTO skill (level, technology_id)
VALUES
  (4,1),
  (4,8),
  (4,5),
  (4,12),
  (4,2),
  (4,13),
  (3,14),
  (3,15),
  (3,16),
  (3,11),
  (3,17),
  (3,10),
  (2,18),
  (1,19),
  (1,20);


COMMIT;

