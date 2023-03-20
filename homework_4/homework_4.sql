
/* 
Задача 1. Подсчитать количество групп, в которые вступил каждый пользователь. 
*/
USE vk;
 
SELECT id, CONCAT(firstname, ' ', lastname) AS user, COUNT(id)
  FROM users
       JOIN users_communities ON users.id = users_communities.user_id
 GROUP BY id
 ORDER BY COUNT(id) DESC;

/* 
Задача 2. Подсчитать количество пользователей в каждом сообществе.
*/
SELECT COUNT(user_id), communities.name
  FROM users_communities 
       JOIN communities ON users_communities.community_id = communities.id
 GROUP BY communities.id

/*
Задача 3. Пусть задан некоторый пользователь. Из всех пользователей соц.сети 
найдите человека, который больше всех общался с выбранным пользователем.
*/
SELECT from_user_id, CONCAT(users.firstname, ' ', users.lastname) AS user, COUNT(FROM_user_id) 
  FROM messages 
       JOIN users ON users.id = messages.FROM_user_id
 WHERE to_user_id = 21
 GROUP BY from_user_id
 ORDER BY COUNT(*) desc
 LIMIT 1;

/*
Задача 4. *Подсчитать общее количество лайков, которые получили пользователи младше 18 лет.
*/
SELECT COUNT(likes.id) 
  FROM likes
       JOIN media ON likes.media_id = media.id
       JOIN profiles ON profiles.user_id = media.user_id
 WHERE YEAR(CURDATE()) - YEAR(birthday) < 18;

/* 
Задача 5. Определить: кто больше поставил лайков (всего) - мужчины или женщины. 
*/
SELECT gender, COUNT(likes.id)
  FROM likes
       JOIN profiles ON likes.user_id = profiles.user_id 
 GROUP BY gender
 LIMIT 1;



