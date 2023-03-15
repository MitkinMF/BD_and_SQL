/*
1.Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY]
*/
USE vk;

SELECT DISTINCT firstname
  FROM users
 ORDER BY firstname;
 
/*
2.Выведите количество мужчин старше 35 лет [COUNT].
*/

SELECT COUNT(gender)
  FROM profiles
 WHERE gender = 'm' AND TIMESTAMPDIFF(YEAR, birthday, NOW()) > 35;

/*
3.Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]
*/
SELECT COUNT(status), status
  FROM friend_requests
 GROUP BY status;
         
/*
4.Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT].
*/

SELECT initiator_user_id
  FROM (SELECT initiator_user_id, COUNT(initiator_user_id) AS cnt
		 FROM friend_requests
        GROUP BY initiator_user_id
		ORDER BY cnt DESC
        LIMIT 1) AS temp;

/*
5.* Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE].
*/      

SELECT id, name
  FROM communities
 WHERE name LIKE '_____';