
/* 
Задача 1. Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]
*/
USE vk;
 
CREATE VIEW Groupcount AS
SELECT id, CONCAT(firstname, ' ', lastname) AS owner, COUNT(id)
FROM users
JOIN users_communities ON users.id = users_communities.user_id
GROUP BY id
ORDER by COUNT(id) DESC;

/* 
Задача 2. Выведите данные, используя написанное представление [SELECT]
*/
SELECT * 
FROM Groupcount;

/*
Задача 3. Удалите представление [DROP VIEW]
*/
DROP VIEW  Groupcount;

/*
Задача 4. *Сколько новостей (записей в таблице media) у каждого пользователя? 
Вывести поля: news_count (количество новостей), user_id (номер пользователя), user_email (email пользователя). 
Попробовать решить с помощью CTE или с помощью обычного JOIN.
*/
WITH media_count AS (
	SELECT COUNT(media.id) AS news_count, user_id
	FROM media
    GROUP BY user_id
)
SELECT 
	news_count,
	user_id,
	email
FROM media_count AS m
JOIN users AS u ON u.id = m.user_id 
GROUP BY user_id;
