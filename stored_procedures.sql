-- Stored Procedures

DELIMITER //

-- Retrieves user information, given a User ID
CREATE PROCEDURE GetUser(IN UserId int(11))
BEGIN
  SELECT *
  FROM users
  WHERE u_id = UserId;
END //

-- Retrieves login and user information given their login name
CREATE PROCEDURE GetLoginUser(IN LoginName varchar(30))
BEGIN
  SELECT
    users.*, login.login_name, login.login_pass
  FROM
    login
      INNER JOIN users ON login.u_id = users.u_id
  WHERE
    login.login_name = LoginName;
END //

-- Retrieves all information in a team, given a Team ID
CREATE PROCEDURE GetTeam(IN TeamId int(11))
BEGIN
  SELECT
    teams.*, users.*
  FROM
    users
      INNER JOIN team_user ON team_user.u_id = users.u_id
      INNER JOIN teams ON team_user.t_id = teams.t_id
  WHERE
    teams.t_id = TeamId;
END //

-- Retrieves all information in a team, given a User ID
CREATE PROCEDURE GetTeamWithUser(IN UserId int(11))
BEGIN
  SELECT
    users.*, teams.*
  FROM
    team_user
      INNER JOIN teams ON team_user.t_id = teams.t_id
      INNER JOIN users ON team_user.u_id = users.u_id,
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

