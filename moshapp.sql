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
u_nickname VARCHAR(30) DEFAULT NULL,
u_fname VARCHAR(30),
u_lastname VARCHAR(30),
u_email VARCHAR(100),
u_phone VARCHAR(10),
s_num VARCHAR(9) NOT NULL,
UNIQUE (u_nicknme),
UNIQUE (s_num),
UNIQUE (u_email)
);

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

CREATE TABLE login(
login_name VARCHAR(30) NOT NULL,
login_pass VARCHAR(64) NOT NULL,
u_id INT NOT NULL,
p_id INT DEFAULT 0,
FOREIGN KEY (u_id) REFERENCES users(u_id),
FOREIGN KEY (p_id) REFERENCES permissions(p_id),
UNIQUE (login_name),
UNIQUE (u_id)
);

CREATE TABLE teams(
t_id INT AUTO_INCREMENT PRIMARY KEY,
t_name VARCHAR(30) NOT NULL,
t_chat_id VARCHAR(24) NOT NULL,
UNIQUE (t_name),
UNIQUE (t_chat_id)
);

CREATE TABLE team_user(
t_id INT,
u_id INT,
FOREIGN KEY (t_id) REFERENCES teams(t_id),
FOREIGN KEY (u_id) REFERENCES users(u_id)
);

ALTER TABLE team_user
ADD CONSTRAINT pk_team_user PRIMARY KEY (t_id,u_id);

CREATE TABLE campus(
c_id INT AUTO_INCREMENT PRIMARY KEY,
c_name VARCHAR(30) NOT NULL,
c_lat REAL,
c_lng REAL
);

CREATE TABLE dic(
td_id INT AUTO_INCREMENT PRIMARY KEY,
direction TEXT(1000),
audio TEXT(1000),
image TEXT(1000),
td_lat REAL,
td_lng REAL
);

CREATE TABLE tasks(
tsk_id INT AUTO_INCREMENT PRIMARY KEY,
tsk_name varchar(100),
c_id INT,
FOREIGN KEY (c_id) REFERENCES campus(c_id)
);

CREATE TABLE task_dic(
tsk_id INT,
td_id INT,
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (td_id) REFERENCES dic(td_id)
);

ALTER TABLE task_dic
ADD CONSTRAINT pk_task_dic PRIMARY KEY (tsk_id,td_id);


CREATE TABLE question_type(
q_typ_id INT AUTO_INCREMENT PRIMARY KEY,
typ_desc TEXT(1000)
);


CREATE TABLE questions(
q_id INT AUTO_INCREMENT PRIMARY KEY,
q_typ_id INT,
q_text TEXT(1000),
FOREIGN KEY (q_typ_id) REFERENCES question_type(q_typ_id)
);


CREATE TABLE answers(
a_id INT AUTO_INCREMENT PRIMARY KEY,
q_id INT,
answer TEXT(250),
FOREIGN KEY (q_id) REFERENCES questions(q_id)
);


CREATE TABLE task_question(
tsk_id INT,
q_id INT,
FOREIGN KEY (tsk_id) REFERENCES tasks(tsk_id),
FOREIGN KEY (q_id) REFERENCES questions(q_id)
);

ALTER TABLE task_question
ADD CONSTRAINT pk_task_question PRIMARY KEY (tsk_id,q_id);


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

CREATE TABLE team_game(
t_id INT,
g_id INT,
FOREIGN KEY (t_id) REFERENCES teams(t_id),
FOREIGN KEY (g_id) REFERENCES game(g_id)
);

ALTER TABLE team_game
ADD CONSTRAINT pk_team_game PRIMARY KEY (t_id,g_id);


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
