SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

INSERT INTO `campus` (`c_id`, `c_name`, `c_lat`, `c_lng`) VALUES
(1, 'St. James Campus', 43.6512279, -79.3693856),
(2, 'Casa Loma Campus', 43.6757552, -79.410208),
(3, 'Waterfront Campus', 43.643929, -79.367659);


INSERT INTO `permissions` (`p_id`, `p_desc`) VALUES
(0, "Regular user, can play game"),
(1, "Master Admin, has all the power ower game and players."),
(2, "Editor, can change add new tasks and teams"),
(3, "Admin, has ability that editor can do plus able to ban users"),
(4, "Banned User");


INSERT INTO `users` (`u_id`, `u_nicknme`, `u_fname`, `u_lastname`, `u_email`, `u_phone`, `s_num`) VALUES
(0, 'byuntaeng', 'Taeyeon', 'Kim', 'tkim@example.com', '6470010101', '100123456'),
(1, 'fany', 'Tiffany', 'Hwang', 'fany@example.com', '6470020202', '100987654'),
(2, 'sunny', 'Soonkyu', 'Lee', 'soonkyu@example.com', '4160030303', '100159753'),
(3, 'sica', 'Sooyeon', 'Jung', 'lazysica@example.com', '6470040404', '100456852'),
(4, 'seororo', 'Joohyun', 'Seo', 'seohyun@example.com', '6470050505', '100147896'),
(5, 'syoung', 'Sooyoung', 'Choi', 'dj.syoung@example.com', '6470060606', '100456963'),
(6, 'kwonyul', 'Yuri', 'Kwon', 'kyuri@example.com', '4160070707', '100987123'),
(7, 'hyoraengi', 'Hyoyeon', 'Kim', 'hyo@example.com', '6470080808', '100741963'),
(8, 'yoong', 'Yoona', 'Im', 'imyoona@example.com', '4160090909', '100793158');

INSERT INTO `login` (`login_name`, `login_pass`, `u_id`, `p_id`) VALUES
('hkim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 7, NULL),
('jseo', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 4, NULL),
('schoi', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 5, NULL),
('sjung', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 3, NULL),
('slee', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 2, NULL),
('thwang', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 1, NULL),
('tkim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 0, NULL),
('yim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 8, NULL),
('ykwon', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 6, NULL);

INSERT INTO `teams` (`t_id`, `t_name`, `t_chat_id`) VALUES
(0, 'TTS', 'TTS'),
(1, 'SJS', 'SJS'),
(2, 'YHY', 'YHY');

INSERT INTO `team_user` (`t_id`, `u_id`) VALUES
(0, 0),
(0, 1),
(1, 2),
(1, 3),
(0, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8);


INSERT INTO dic(`direction`,`audio`,`image`,`td_lat`,`td_lng`) VALUES
("Same as audio", "audiolocation.mp3", "imagelocation.jsp", 43.658965, -79.5647896),
("Same as audio 1", "audiolocation1.mp3", "imagelocation1.jsp", 43.657965, -79.5647896),
("Same as audio2", "audiolocation2.mp3", "imagelocation2.jsp", 43.658965, -79.5947896);

INSERT INTO tasks(`td_id`,`c_id`) VALUES
(1, 3),
(2, 3),
(3, 3);

INSERT INTO task_dic VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO question_type(`typ_desc`) VALUES
("Regular question answer type"),
("Multichoice question type");

INSERT INTO questions(`q_typ_id`,`q_text`) VALUES
(1, "task question will be placed here 1"),
(1, "task question will be placed here 2"),
(2, "task question will be placed here 3");

INSERT INTO answers(`q_id`,`answer`) VALUES
(1, "test"),
(2, "test1"),
(3, "test,sky,ground");

INSERT INTO task_question VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO game(`start_time`,`finis_time`) VALUES
('2013-1-28 13:15:23', '2013-2-18 13:15:23');

INSERT INTO team_game VALUES
(1, 1),
(2, 1);

INSERT INTO game_task(`tsk_id`,`g_id`) VALUES
(1, 1),
(2, 1),
(3, 1);
