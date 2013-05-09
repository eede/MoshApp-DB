START TRANSACTION;

-- Stored Procedures
DELIMITER //

-- Creates a new user
DROP PROCEDURE IF EXISTS CreateUser //
CREATE PROCEDURE CreateUser (IN FirstName VARCHAR(30), IN LastName VARCHAR(30), IN Email VARCHAR(100), IN Phone VARCHAR(10), IN StudentNumber VARCHAR(9), OUT UserId INT)
BEGIN
  INSERT INTO users(u_fname, u_lastname, u_email, u_phone, s_num) VALUES
    (FirstName, LastName, Email, Phone, StudentNumber);

  SET UserId = LAST_INSERT_ID();

  INSERT INTO user_options VALUES
    (UserId, TRUE, TRUE);
END //

-- Creates login credentials for a user
DROP PROCEDURE IF EXISTS CreateLoginUser //
CREATE PROCEDURE CreateLoginUser (IN UserId INT, IN LoginName VARCHAR(30), IN Password VARCHAR(64))
BEGIN
  INSERT INTO login(u_id, login_name, login_pass) VALUES
    (UserId, LoginName, Password);
END //

-- Retrieves user information, given a User ID
DROP PROCEDURE IF EXISTS GetUser //
CREATE PROCEDURE GetUser(IN UserId INT)
BEGIN
  SELECT
    users.*,
    user_options.p_vsbl_tm, user_options.e_vsbl_tm
  FROM
    users
      INNER JOIN user_options ON users.u_id = user_options.u_id
  WHERE users.u_id = UserId;
END //

-- Retrieves login and user information given their login name
DROP PROCEDURE IF EXISTS GetLoginUser //
CREATE PROCEDURE GetLoginUser(IN LoginName VARCHAR(30))
BEGIN
  SELECT
    users.*,
    user_options.p_vsbl_tm, user_options.e_vsbl_tm,
    login.login_name, login.login_pass
  FROM
    login
      INNER JOIN users ON login.u_id = users.u_id
      INNER JOIN user_options ON users.u_id = user_options.u_id
  WHERE
    login.login_name = LoginName;
END //

-- Retrieves all information in a team, given a Team ID
DROP PROCEDURE IF EXISTS GetTeam //
CREATE PROCEDURE GetTeam(IN TeamId INT)
BEGIN
  SELECT
    teams.*, users.*, user_options.*
  FROM
    users
      INNER JOIN user_options ON users.u_id = user_options.u_id
      INNER JOIN team_user ON team_user.u_id = users.u_id
      INNER JOIN teams ON team_user.t_id = teams.t_id
  WHERE
    teams.t_id = TeamId;
END //

-- Retrieves all information in a team, given a User ID
DROP PROCEDURE IF EXISTS GetTeamWithUser //
CREATE PROCEDURE GetTeamWithUser(IN UserId INT)
BEGIN
  SELECT
    users.*, teams.*, user_options.*
  FROM
    team_user
      INNER JOIN teams ON team_user.t_id = teams.t_id
      INNER JOIN users ON team_user.u_id = users.u_id
      INNER JOIN user_options ON users.u_id = user_options.u_id,
        (SELECT
           team_user.t_id AS Team,
           team_user.u_id AS User
         FROM
           team_user) TeamMember
  WHERE
    TeamMember.Team = team_user.t_id AND
    TeamMember.User = UserId;
END //

-- Checks if a given login name exists in the database, and if so, returns FALSE
DROP FUNCTION IF EXISTS CheckLoginNameAvailable //
CREATE FUNCTION CheckLoginNameAvailable(LoginName VARCHAR(30))
RETURNS BOOLEAN
BEGIN
  DECLARE LNExists INT;
  SELECT COUNT(login_name) INTO LNExists FROM login WHERE login_name = LoginName;

  IF LNExists > 0 THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END //

-- ------------------------------------------------------ --
-- Begin stored procedures taken from Emrah's PHP service --
-- ------------------------------------------------------ --

-- Updates the given user's phone/email visibility options
DROP PROCEDURE IF EXISTS UpdateUserOption //
CREATE PROCEDURE UpdateUserOption (IN UserId INT, IN PhoneVisible BOOLEAN, IN EmailVisible BOOLEAN)
BEGIN
  UPDATE user_options
  SET
    p_vsbl_tm = PhoneVisible,
    e_vsbl_tm = EmailVisible
  WHERE
    u_id = UserId;
END //

DROP PROCEDURE IF EXISTS GetUserInitInfo //
CREATE PROCEDURE GetUserInitInfo (IN UserId INT)
BEGIN
  SELECT
    user_options.p_vsbl_tm, user_options.e_vsbl_tm,
    teams.t_id, teams.t_name,
    team_game.g_id,
    game.start_time, game.finis_time,
    tasks.tsk_id, tasks.tsk_name, tasks.secret_id,
    campus.c_id, campus.c_name, campus.c_lat, campus.c_lng,
    dic.td_id, dic.direction, dic.audio, dic.image, dic.td_lat, dic.td_lng,
    questions.q_id, questions.q_typ_id, questions.q_text,
    (SELECT MAX(progress.status) FROM progress WHERE progress.tsk_id = tasks.tsk_id AND progress.u_id = UserId) status,
    responses.q_status,
    answers.answer
  FROM
    tasks
      LEFT OUTER JOIN campus       ON tasks.c_id = campus.c_id
      LEFT OUTER JOIN task_dic     ON task_dic.tsk_id = tasks.tsk_id
      LEFT OUTER JOIN dic          ON task_dic.td_id = dic.td_id
      LEFT OUTER JOIN dic_question ON dic_question.td_id = dic.td_id
      LEFT OUTER JOIN questions    ON dic_question.q_id = questions.q_id
      INNER JOIN user_options      ON user_options.u_id = UserId
      LEFT OUTER JOIN team_user    ON team_user.u_id = user_options.u_id
      LEFT OUTER JOIN teams        ON teams.t_id = team_user.t_id
      LEFT OUTER JOIN team_game    ON team_game.t_id = teams.t_id
      LEFT OUTER JOIN game         ON game.g_id = team_game.g_id
      LEFT OUTER JOIN progress     ON progress.status = 1 AND progress.u_id = UserId AND tasks.tsk_id = progress.tsk_id
      LEFT OUTER JOIN responses    ON responses.q_id =questions.q_id AND responses.q_status = 1 AND responses.u_id = UserId
      LEFT OUTER JOIN answers      ON answers.q_id = questions.q_id
  ORDER BY progress.status DESC;
END //

DROP PROCEDURE IF EXISTS GetTeamMemberDetails //
CREATE PROCEDURE GetTeamMemberDetails (IN UserId INT)
BEGIN
  SELECT
      u.u_nickname,
      t.t_name,
      tsk.tsk_name,
      (SELECT MAX(p.status) FROM progress p WHERE p.tsk_id = tsk.tsk_id AND p.u_id = UserId) status,
      (SELECT TIME_TO_SEC(TIMEDIFF(pf.currenttime, (SELECT ps.currenttime FROM progress ps WHERE ps.u_id = pf.u_id AND ps.tsk_id = pf.tsk_id AND ps.status = 1))) time_spent FROM progress pf WHERE pf.status = 2 AND pf.tsk_id = tsk.tsk_id AND pf.u_id = UserId) time_spent
  FROM users u
      INNER JOIN teams t ON t.t_id = (SELECT t_id FROM team_user WHERE u_id = UserId)
      INNER JOIN game_task gt ON gt.g_id = (SELECT g_id FROM team_game tg WHERE tg.t_id = t.t_id)
      INNER JOIN tasks tsk ON tsk.tsk_id = gt.tsk_id
  WHERE u.u_id = UserId;
END //

DROP PROCEDURE IF EXISTS GetContact //
CREATE PROCEDURE GetContact (IN UserId INT)
BEGIN
  SELECT
    users.u_id,
    users.u_nickname,
    users.u_fname,
    users.u_lastname,
    users.u_email,
    users.u_phone,
    user_options.p_vsbl_tm,
    user_options.e_vsbl_tm
  FROM
    users
      INNER JOIN team_user ON team_user.u_id = users.u_id
      INNER JOIN user_options ON user_options.u_id = users.u_id
  WHERE team_user.t_id = (SELECT t_id FROM team_user WHERE u_id = UserId) AND team_user.u_id != UserId;
END //

DROP PROCEDURE IF EXISTS GetTeams //
CREATE PROCEDURE GetTeams ()
BEGIN
  SELECT
    t.t_id,
    t.t_name,
    (SELECT COUNT(pc.tsk_id) FROM progress pc WHERE pc.u_id = pf.u_id AND pc.t_id = pf.t_id AND pc.status = 2) solved,
    TIME_TO_SEC(TIMEDIFF(pf.currenttime, (SELECT ps.currenttime FROM progress ps WHERE ps.u_id = pf.u_id AND ps.tsk_id = pf.tsk_id AND ps.status = 1))) time_spent
  FROM teams t
    LEFT OUTER JOIN progress pf ON pf.status = 2 AND pf.t_id = t.t_id
  ORDER BY t.t_name, solved, time_spent;
END //

DROP PROCEDURE IF EXISTS GetAllAvailableTasks //
CREATE PROCEDURE GetAllAvailableTasks (IN UserId INT, IN GameId INT)
BEGIN
  SELECT
    gt.prv_tsk_id,
    tsk.tsk_id,
    (SELECT MAX(p.status) FROM progress p WHERE p.tsk_id = tsk.tsk_id AND p.u_id = UserId) status,
    tsk.tsk_name,
    c.c_id,
    c.c_name,
    c.c_lat,
    c.c_lng
  FROM tasks tsk
    INNER JOIN game_task gt ON tsk.tsk_id = gt.tsk_id
    INNER JOIN campus c ON c.c_id = tsk.c_id
  WHERE gt.g_id = GameId AND SYSDATE() < (SELECT finis_time FROM game WHERE g_id = GameId);
END //

DROP PROCEDURE IF EXISTS GetTaskDetail //
CREATE PROCEDURE GetTaskDetail (IN TaskId INT)
BEGIN
  SELECT
    tsk.tsk_name,
    c.c_lat,
    c.c_lng,
    c.c_name,
    td.td_id dictionary,
    (SELECT COUNT(dq.td_id) FROM dic_question dq WHERE dq.td_id = td.td_id) questions
  FROM
    task_dic td
      INNER JOIN tasks tsk ON td.tsk_id = tsk.tsk_id AND tsk.tsk_id = TaskId
      INNER JOIN campus c ON c.c_id = tsk.c_id;
END //

DROP PROCEDURE IF EXISTS GetTeamMembers //
CREATE PROCEDURE GetTeamMembers (IN TeamId INT)
BEGIN
SELECT
  t.t_name,
  u.u_id,
  u.u_nickname,
  (SELECT SUM(TIME_TO_SEC(TIMEDIFF(pf.currenttime, (SELECT ps.currenttime FROM progress ps WHERE ps.u_id = pf.u_id AND ps.tsk_id = pf.tsk_id AND ps.status = 1)))) time_spent FROM progress pf WHERE pf.status = 2 AND pf.u_id = u.u_id) time_spent
FROM
  team_user tu
    INNER JOIN users u ON u.u_id = tu.u_id
    INNER JOIN teams t ON t.t_id = tu.t_id
WHERE
  tu.t_id = TeamId
ORDER BY
  time_spent;
END //

DELIMITER ;

COMMIT;
