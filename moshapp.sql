DROP TABLE IF EXISTS user_options;
DROP TABLE IF EXISTS login;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS team_user;
DROP TABLE IF EXISTS responses;
DROP TABLE IF EXISTS progress;
DROP TABLE IF EXISTS task_question;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS clue_question;
DROP TABLE IF EXISTS clue;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS team_game;
DROP TABLE IF EXISTS game_task;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS task_dic;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS dic;
DROP TABLE IF EXISTS campus;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS question_type;
DROP TABLE IF EXISTS clue_type;


CREATE TABLE users(
u_id INT AUTO_INCREMENT PRIMARY KEY,
u_nicknme VARCHAR(30) NOT NULL,
u_fname VARCHAR(30),
u_lastname VARCHAR(30),
u_email VARCHAR(100),
u_phone VARCHAR(10),
s_num VARCHAR(9) NOT NULL,
UNIQUE (u_nicknme),
UNIQUE (s_num),
UNIQUE (u_email)
);

/* TEST DATA */
INSERT INTO users(`u_nicknme`,`u_fname`,`u_lastname`,`u_email`,`u_phone`,`s_num`) values("TestUser","Test","Test","test@test.com","0000000000","000000000"),
("TestUser1","Test1","Test1","test1@test.com","0000000001","000000001"),("TestUser2","Test2","Test2","test2@test.com","0000000002","000000002"),
("TestUser3","Test3","Test3","test3@test.com","0000000003","000000003"),("TestUser4","Test4","Test4","test4@test.com","0000000004","000000004");


CREATE TABLE user_options(
u_id INT,
p_vsbl_tm TINYINT(1),
e_vsbl_tm TINYINT(1),
FOREIGN KEY (u_id) REFERENCES users(u_id),
UNIQUE (u_id)
);


CREATE TABLE permissions(
p_id INT PRIMARY KEY,
p_desc VARCHAR(100)
);

<<<<<<< HEAD
/* TEST DATA */
INSERT INTO permissions values(0,"Regular user, can play game"),(1,"Master Admin, has all the power ower game and players."),(2,"Editor, can change add new tasks and teams"),
(3,"Admin, has ability that editor can do plus able to ban users"),(4,"Banned User");

=======
>>>>>>> f8c97e77c6d4511dedd7665e60d4a4c5283712cb

CREATE TABLE login(
login_name VARCHAR(30) NOT NULL,
login_pass VARCHAR(64) NOT NULL,
u_id INT,
p_id INT DEFAULT 0,
FOREIGN KEY (u_id) REFERENCES users(u_id),
FOREIGN KEY (p_id) REFERENCES permissions(p_id),
UNIQUE (login_name),
UNIQUE (u_id)
);
<<<<<<< HEAD
/* TEST DATA */
INSERT INTO login(`login_name`,`login_pass`,`u_id`) values("harme","6460662E217C7A9F899208DD70A2C28ABDEA42F128666A9B78E6C0C064846493","1"),
("test","6460662E217C7A9F899208DD70A2C28ABDEA42F128666A9B78E6C0C064846493","2"),("test1","6460662E217C7A9F899208DD70A2C28ABDEA42F128666A9B78E6C0C064846493","3"),
("test2","6460662E217C7A9F899208DD70A2C28ABDEA42F128666A9B78E6C0C064846493","4"),("test3","6460662E217C7A9F899208DD70A2C28ABDEA42F128666A9B78E6C0C064846493","5");
=======
>>>>>>> f8c97e77c6d4511dedd7665e60d4a4c5283712cb


CREATE TABLE teams(
t_id INT AUTO_INCREMENT PRIMARY KEY,
t_name VARCHAR(30) NOT NULL,
t_chat_id VARCHAR(24) NOT NULL,
UNIQUE (t_name),
UNIQUE (t_chat_id)
);
/* TEST DATA */
INSERT INTO teams(`t_name`,`t_chat_id`) values('Team 1','team1chat'),('Team 2','team2chat');

CREATE TABLE team_user(
t_id INT,
u_id INT,
FOREIGN KEY (t_id) REFERENCES teams(t_id),
FOREIGN KEY (u_id) REFERENCES users(u_id)
);

ALTER TABLE team_user
ADD CONSTRAINT pk_team_user PRIMARY KEY (t_id,u_id);

/* TEST DATA */
INSERT INTO team_user values(1,1),(1,2),(1,3),(2,4),(2,5);


CREATE TABLE campus(
c_id INT AUTO_INCREMENT PRIMARY KEY,
c_name VARCHAR(30) NOT NULL,
c_lat REAL,
c_lng REAL
);
<<<<<<< HEAD
/* TEST DATA */
INSERT INTO campus(`c_name`,`c_lat`,`c_lng`) values("St. James Campus",43.6512279,-79.3693856),("Casa Loma Campus",43.6757552,-79.410208),("Waterfront Campus",43.643929,-79.367659);


=======

/*Changed but not added yet */
>>>>>>> f8c97e77c6d4511dedd7665e60d4a4c5283712cb
CREATE TABLE dic(
td_id INT AUTO_INCREMENT PRIMARY KEY,
direction TEXT(1000),
audio TEXT(1000),
image TEXT(1000),
td_lat REAL,
td_lng REAL
);
/* TEST DATA */
INSERT INTO dic(`direction`,`audio`,`image`,`td_lat`,`td_lng`) values("Same as audio","audiolocation.mp3","imagelocation.jsp",43.658965,-79.5647896),
("Same as audio 1","audiolocation1.mp3","imagelocation1.jsp",43.657965,-79.5647896),("Same as audio2","audiolocation2.mp3","imagelocation2.jsp",43.658965,-79.5947896);


CREATE TABLE tasks(
tsk_id INT AUTO_INCREMENT PRIMARY KEY,
td_id INT,
c_id INT,
FOREIGN KEY (td_id) REFERENCES dic(td_id),
FOREIGN KEY (c_id) REFERENCES campus(c_id)
);
/* TEST DATA */
INSERT INTO tasks(`td_id`,`c_id`) values(1,3),(2,3),(3,3);

CREATE TABLE task_dic(
tsk_id INT,
td_id INT,
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (td_id) REFERENCES dic(td_id)
);

ALTER TABLE task_dic
ADD CONSTRAINT pk_task_dic PRIMARY KEY (tsk_id,td_id);

/* TEST DATA */
INSERT INTO task_dic values(1,1),(2,2),(3,3);

CREATE TABLE question_type(
q_typ_id INT AUTO_INCREMENT PRIMARY KEY,
typ_desc TEXT(1000)
);

/* TEST DATA */
INSERT INTO question_type(`typ_desc`) values("Regular question answer type"),("Multichoice question type");

CREATE TABLE questions(
q_id INT AUTO_INCREMENT PRIMARY KEY,
q_typ_id INT,
q_text TEXT(1000),
FOREIGN KEY (q_typ_id) REFERENCES question_type(q_typ_id)
);
/* TEST DATA */
INSERT INTO questions(`q_typ_id`,`q_text`) values(1,"task questin will be placed here 1"),(1,"task questin will be placed here 2"),(2,"task questin will be placed here 3");

CREATE TABLE answers(
a_id INT AUTO_INCREMENT PRIMARY KEY,
q_id INT,
answer TEXT(250),
FOREIGN KEY (q_id) REFERENCES questions(q_id)
);
/* TEST DATA */
INSERT INTO answers(`q_id`,`answer`) values(1,"test"),(2,"test1"),(3,"test,sky,ground");


CREATE TABLE task_question(
tsk_id INT,
q_id INT,
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (q_id) REFERENCES questions(q_id)
);

ALTER TABLE task_question
ADD CONSTRAINT pk_task_question PRIMARY KEY (tsk_id,q_id);

/* TEST DATA */
INSERT INTO task_question values(1,1),(2,2),(3,3);


CREATE TABLE clue_type(
clue_typ_id INT AUTO_INCREMENT PRIMARY KEY,
typ_desc TEXT(1000)
);

CREATE TABLE clue(
clue_id INT AUTO_INCREMENT PRIMARY KEY,
clue_typ_id INT,
clue_text TEXT(1000),
clue_audio TEXT(1000),
clue_image TEXT(1000),
FOREIGN KEY (clue_typ_id) REFERENCES clue_type(clue_typ_id)
);


CREATE TABLE clue_question(
clue_id INT,
q_id INT,
FOREIGN KEY (clue_id) REFERENCES clue(clue_id),
FOREIGN KEY (q_id) REFERENCES questions(q_id)
);

ALTER TABLE clue_question
ADD CONSTRAINT pk_clue_question PRIMARY KEY (clue_id,q_id);


CREATE TABLE game(
g_id INT AUTO_INCREMENT PRIMARY KEY,
start_time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
finis_time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL
);
/* TEST DATA */
INSERT INTO game(`start_time`,`finis_time`) values('2013-1-28 13:15:23','2013-2-8 13:15:23');

CREATE TABLE team_game(
t_id INT,
g_id INT,
FOREIGN KEY (t_id) REFERENCES teams(t_id),
FOREIGN KEY (g_id) REFERENCES game(g_id)
);

ALTER TABLE team_game
ADD CONSTRAINT pk_team_game PRIMARY KEY (t_id,g_id);
/* TEST DATA */
INSERT INTO team_game values(1,1),(2,1);


CREATE TABLE game_task(
tsk_id INT,
g_id INT,
prv_tsk_id INT,
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (prv_tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (g_id) REFERENCES game(g_id)
);

ALTER TABLE game_task
ADD CONSTRAINT pk_team_game PRIMARY KEY (tsk_id,g_id);
/* TEST DATA */
INSERT INTO game_task(`tsk_id`,`g_id`) values(1,1),(2,1),(3,1);


CREATE TABLE progress(
t_id INT,
u_id INT,
tsk_id INT,
status INT,
currenttime TIMESTAMP,
FOREIGN KEY (t_id) REFERENCES teams(t_id),
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (u_id) REFERENCES users(u_id)
);

CREATE TABLE responses(
r_id INT AUTO_INCREMENT PRIMARY KEY,
t_id INT,
u_id INT,
tsk_id INT,
response TEXT(1000),
location TEXT(1000),
FOREIGN KEY (t_id) REFERENCES teams(t_id),
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (u_id) REFERENCES users(u_id)
);
