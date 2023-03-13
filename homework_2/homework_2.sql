/*
1.Создать БД vk, исполнив скрипт _vk_db_creation.sql (в материалах к уроку)
*/
DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	foreign key (admin_user_id) references users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file blob,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

/*
2.Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы 
(с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)
*/

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE photo_albums (
    id       SERIAL,
	name     varchar(255),
	user_id  BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE photos (
    id       SERIAL,
	album_id BIGINT unsigned,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    id   SERIAL,
	name varchar(255) NOT NULL);

ALTER TABLE profiles ADD COLUMN city_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE `profiles` ADD CONSTRAINT fk_profiles_city_id
FOREIGN KEY (city_id) REFERENCES cities(id);

/*
Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
*/

INSERT INTO users (firstname, lastname, email, phone) 
VALUES ('Reuben', 'Nienow', 'arlo50@example.org', 9374071116),
       ('Frederik', 'Upton', 'terrence.cartwright@example.org', 9127498182),
	   ('Unique', 'Windler', 'rupert55@example.org', 9921090703),
       ('Norene', 'West', 'rebekah29@example.net', 9592139196),
       ('Frederick', 'Effertz', 'von.bridget@example.net', 9909791725),
       ('Victoria', 'Medhurst', 'sstehr@example.net', 9456642385);

INSERT INTO media_types (name)
VALUES ('photo');


INSERT INTO media (media_type_id, user_id, body)
VALUES ('1','1','foo'),
	   ('1','2','foo'),
       ('1','3','foo'),
       ('1','4','foo'),
	   ('1','5','foo'),
       ('1','6','foo');

INSERT INTO likes (user_id, media_id, created_at)
VALUES 
('1','1','1988-10-14 18:47:39'),
('2','1','1988-09-04 16:08:30'),
('3','1','1994-07-10 22:07:03'),
('4','1','1991-05-12 20:32:08'),
('5','2','1978-09-10 14:36:01'),
('6','2','1992-04-15 01:27:31'); 

INSERT INTO cities (name)
VALUES
('Kaelynside'),
('South Matildaburgh'),
('New Susana'),
('Williamsonmouth'),
('Schaeferborough'),
('Port Maraberg');

INSERT INTO profiles (user_id, gender, birthday, photo_id, created_at, hometown, city_id)
VALUES
('1','m','1996-08-16','1','2017-03-21 22:21:57','Kaelynside','1'),
('2','m','1996-01-06','2','2012-05-27 01:51:06','South Matildaburgh','2' ),
('3','m','2021-07-06','3','2003-03-05 03:46:29','New Susana','3'),
('4','m','1972-02-14','4','2009-04-10 01:40:31','Williamsonmouth','4'),
('5','f','1981-07-20','5','2006-12-24 05:12:48','Schaeferborough','5'),
('6','m','2018-01-13','6','1986-01-24 03:23:56','Port Maraberg','6');

INSERT INTO messages (from_user_id, to_user_id, body, created_at)
VALUES 
(1,2,'Debitis et cum et sint temporibus accusantium.','2021-09-01 06:25:10'),
(2,1,'Sunt perspiciatis dignissimos quaerat assumenda aperiam non.','1986-10-15 20:05:16'),
(2,3,'Et mollitia dolor minus beatae.','2016-12-05 04:42:38'),
(3,4,'Repellendus corporis atque sed voluptatibus voluptas.','2012-07-31 05:59:39'),
(4,5,'Vero inventore ea aspernatur dolore placeat tempore.','1985-08-16 17:43:15'),
(5,6,'Voluptatem esse possimus ipsam nobis nobis libero eum sit.','2021-07-17 13:16:31'),
(6,5,'Nulla consequatur atque porro aut quos aut quo.','1998-12-13 07:13:08'),
(5,4,'Vel et laboriosam cumque rerum veniam placeat.','2021-01-26 15:30:16');


------------------ Задача 3.
/*
4.* Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true).
При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0) (ALTER TABLE + UPDATE)
*/
-- добавим поле is_active 
ALTER TABLE vk.profiles 
 ADD COLUMN is_active BIT DEFAULT 1;

-- сделать невовершеннолетних неактивными
UPDATE profiles
   SET is_active = 0
 WHERE (birthday + INTERVAL 18 YEAR) > NOW();

-- проверим не активных
SELECT user_id, birthday, is_active
  FROM profiles
 WHERE is_active = 0
 ORDER BY birthday;

-- проверим активных
SELECT user_id, birthday, is_active
  FROM profiles
 WHERE is_active = 1
 ORDER BY birthday;

/*
5.* Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)
*/

-- добавим флаг is_deleted 
ALTER TABLE messages 
 ADD COLUMN is_deleted BIT DEFAULT 0;

-- отметим пару сообщений неправильной датой
UPDATE messages
   SET created_at = NOW() + INTERVAL 1 YEAR
 LIMIT 2;

-- отметим, как удаленные, сообщения "из будущего"
UPDATE messages
   SET is_deleted = 1
 WHERE created_at > NOW();

-- проверим
SELECT id, created_at, is_deleted
  FROM messages
 WHERE created_at > NOW()
 ORDER BY created_at DESC;

/*
-- физически удалим сообщения "из будущего"
DELETE FROM messages
WHERE created_at > NOW()
*/