#! /bin/sh
exec sh -c "mkdir -p .data/backup && mv .data/data.db .data/backup/data-$(date +%s).db 2> /dev/null; tail -n +3 $0 | sqlite3 .data/data.db"
pragma foreign_keys=on;
begin transaction;
-- NOTE: sqlite changes `varchar(N)` to `text`, so it *will* allow more characters.



-- TODO: decide how to handle conflicts, such as unique constraint conflicts. Default=abort (https://sqlite.org/lang_conflict.html)



create table account (
  service_name text,
  username text,
  url text
);

insert into account (service_name, username, url)
values
  ('linkedin',' hwprins',' https://www.linkedin.com/in/hwprins'),
  ('github',' harryvederci',' https://www.github.com/harryvederci');

create table country (
  id integer primary key not null,
  name text not null unique,
  code varchar(2) unique
);

insert into country (name, code)
values
  ('The Netherlands', 'NL'),
  ('Germany', 'DE');

create table city (
  id integer primary key not null,
  name text not null,
  country_id integer not null,
  foreign key (country_id) references country(id)
    on update cascade
    on delete restrict,
  unique (name, country_id) -- TODO: Check if countries exist that do have multiple cities with same name.
);

insert into city (name, country_id)
values
  ('Groningen',1),
  ('Frankfurt',2),
  ('Rotterdam',1),
  ('The Hague',1),
  ('Delft',1);

create table organisation (
  id integer primary key not null,
  name text not null,
  unabbreviated_name text, -- optional: full name if normal name is abbreviated
  city_id integer not null,
  foreign key (city_id) references city(id)
    on update cascade
    on delete restrict,
  unique (name, city_id)
);

insert into organisation (name, unabbreviated_name, city_id)
values
  ('University of Groningen',null,1),
  ('IBM CIC Benelux',null,1),
  ('(confidential)',null,2),
  ('Port of Rotterdam',null,3),
  ('SportInnovator',null,4),
  ('RWS','Dutch Directorate-General for Public Works and Water Management',5);


create table job (
  id integer primary key not null,
  title text not null
);

insert into job (title) values
  ('DevOps Engineer'),
  ('Backend Developer'),
  ('Full Stack Developer'),
  ('Front End Developer'),
  ('Student-Researcher (graduation project)');


create table project (
  -- TODO: decide which columns can be null
  -- TODO: add work_city column for Groningen-PoR-Munich type situations.
  -- TODO: add comment explaining difference between employer and client.
  id integer primary key not null,
  nickname text,
  job_id integer not null,
  employer_id integer,
  client_id integer,
  time_period text, -- TODO: break up into start_date and end_date (mm YYYY)
  description text,
  foreign key (job_id) references job(id)
    on update cascade
    on delete restrict,
  foreign key (employer_id) references organisation(id)
    on update cascade
    on delete restrict,
  foreign key (client_id) references organisation(id)
    on update cascade
    on delete restrict
);

insert into project (nickname, job_id, employer_id, client_id, time_period, description)
values
  ('RWS Harvester',2,2,6,'jan 2020 - now','I created an application that retrieves sensor measurements, transforms them, and writes them to a database that is used by a publicly available service.'),
  ('Harvester PoC',2,2,6,'nov 2019 - dec 2019','As a Proof of Concept, I created and demonstrated a "Harvester" application that retrieves sensor measurements, transforms them, and writes them to a database that is used by a publicly available service. The Proof of Concept was a success, and was directly followed up by a 6-figure project.'),
  ('MuxProxy',2,2,6,'aug 2019 - nov 2019','For Rijkswaterstaat (the Dutch Directorate-General for Public Works and Water Management) I created an application that forwards incoming sensor data in a non-blocking way. I added a feature to compress messages and send them as a batch, to lower the application its bandwidth usage.'),
  ('CE/DR',1,2,2,'jun 2019 - aug 2019','I containerized a Meteor/MongoDB application, configured Red Hat Enterprise Linux servers, and deployed the application using Docker Swarm. I also added an Nginx service to proxy requests and provide TLS/SSL support.'),
  ('CIC Websites',3,2,2,'dec 2018 - jun 2019','I merged 9 applications (database, backend, and frontend) into one, enabling a smoother deployment process while cutting down hosting costs. I added new features, pushed them to production, and moved the application to the ibm.com domain.'),
  ('PoR Microservices',2,2,4,'apr 2018 - dec 2018','I was involved in the creation of several Java microservices for an award winning Port of Rotterdam enterprise IoT application. My team independently designed solutions and took care of the DevOps process.'),
  ('PoR GUI',4,2,4,'jan 2018 - apr 2018','I improved the quality, structure and development workflow of an enterprise IoT application for Port of Rotterdam. I did this by unit testing and refactoring existing code, adding new features, and reviewing the code of other developers. I also added a test validation script to ensure reviewers that new code will not break existing features.'),
  ('EA VAT',4,2,2,'dec 2017 - dec 2017','For IBM, I was involved in the development of a tool that clients and consultants can use to assess the value of enterprise applications.'),
  ('SportInnovator',3,2,5,'jul 2017 - dec 2017','I added new features to a government-owned Ruby on Rails application about innovation in sports. I deployed changes to production myself.'),
  ('PoR PoC Munich',4,2,4,'aug 2017 - jul 2017','As a Proof of Concept, I created the front end of an application that visualises data collected by sensors in the Port of Rotterdam. The Proof of Concept was a success, and was followed up by a big enterprise project spanning multiple years.'),
  ('Apple-style Microsite',4,2,2,'jul 2017 - aug 2017','To impress an important potential client for IBM, I created a beautiful Apple-style microsite.'),
  ('Watson Bank',4,2,3,'jun 2017 - jul 2017','For a major German bank, I went to Frankfurt to create the front end of an IBM Watson application. With a rapidly approaching deadline, I made creative solutions to overcome the limitations of a very restricted developing environment.'),
  ('Biometry Law Evaluation',5,1,1,'jun 2016 - jan 2017','For an official law evaluation, I wrote a Python application to analyze if Dutch government agencies acted in compliance with the law when collecting biometric data from foreigners.');


create table technology
(
   id integer primary key not null,
   name text not null
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
   id integer primary key not null,
   project_id integer not null,
   technology_id integer not null,
   foreign key (project_id) references project(id)
     on update cascade
     on delete cascade,
   foreign key (technology_id) references technology(id)
     on update cascade
     on delete cascade
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



create table skill
(
   level integer not null check("level" in (1, 2, 3, 4, 5)),
   technology_id integer not null,
   foreign key (technology_id) references technology(id)
     on update cascade
     on delete cascade
);

insert into skill (level, technology_id)
values
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


create table feedback (
  year varchar(4), -- Year the feedback was received (Q: Why not a full date? A: Privacy. This gives accurate enough estimate of how recent it was, yet makes it harder to deduce exactly who made the comment.).
  content text not null, -- NOTE: DB can't ensure anonimity of sender by content, so make sure to edit it yourself to keep it anonymous (if necessary)
  sender_info text, -- NOTE: only include sender if sender is okay with it being published.
  project_id integer, -- feedback can be linked to a project, but does not have to be.
  foreign key (project_id) references project(id)
    on update cascade
    on delete restrict,
  unique (year, content)
);

insert into feedback (year, content, sender_info)
values
  ('2019', 'Lorem ipsum.', 'John')
;


create view vw_organisation
as
select
  organisation.id as id,
  organisation.name as name,
  city.name as city_name,
  country.name as country_name
from
  organisation
inner join city on city.id = city_id
inner join country on country.id = country_id;


create view vw_project
as
select
  project.id,
  -- organisation.name as employer_name,
  organisation.name as client_name,
  city.name as employer_city,
  project.time_period,
  job.title as job_title,
  project.description
from
  project
-- inner join organisation on organisation.id = project.employer_id
inner join organisation on organisation.id = project.client_id
inner join job on job.id = project.job_id
inner join city on city.id = organisation.city_id;





commit;

