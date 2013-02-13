START TRANSACTION;

DROP PROCEDURE IF EXISTS GetUser;
DROP PROCEDURE IF EXISTS GetLoginUser;
DROP PROCEDURE IF EXISTS GetTeam;
DROP PROCEDURE IF EXISTS GetTeamWithUser;

-- Stored Procedures
DELIMITER //

-- Retrieves user information, given a User ID
CREATE PROCEDURE GetUser(IN UserId int(11))
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
CREATE PROCEDURE GetLoginUser(IN LoginName varchar(30))
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
CREATE PROCEDURE GetTeam(IN TeamId int(11))
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
CREATE PROCEDURE GetTeamWithUser(IN UserId int(11))
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

DELIMITER ;

COMMIT;
