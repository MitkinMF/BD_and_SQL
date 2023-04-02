
/* 
Задача 1. Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users.
Функция должна возвращать номер пользователя.
*/
USE vk;
 
DROP FUNCTION IF EXISTS func_del_user;

DELIMITER // 
CREATE FUNCTION func_del_user (check_user_id BIGINT UNSIGNED)
RETURNS BIGINT UNSIGNED DETERMINISTIC
  BEGIN
    SET FOREIGN_KEY_CHECKS=0; 
	DELETE FROM likes
	WHERE user_id = check_user_id;
    
    DELETE FROM media
	WHERE user_id = check_user_id;
    
    DELETE FROM messages
	WHERE from_user_id = check_user_id;
    
	DELETE FROM profiles
	WHERE user_id = check_user_id;
    
    DELETE FROM users
	WHERE id = check_user_id;
    
	DELETE FROM users_communities
	WHERE user_id = check_user_id;
    
	SET FOREIGN_KEY_CHECKS=1;
    RETURN check_user_id;
  END// 
DELIMITER ; 
--
SELECT func_del_user(2);

/* 
Задача 2. Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
*/
DROP PROCEDURE IF EXISTS func_del_user1;

DELIMITER // 
CREATE PROCEDURE func_del_user1 (check_user_id BIGINT UNSIGNED)
  BEGIN
  START TRANSACTION;
    SET FOREIGN_KEY_CHECKS=0; 
	DELETE FROM likes
	WHERE user_id = check_user_id;
    
    DELETE FROM media
	WHERE user_id = check_user_id;
    
    DELETE FROM messages
	WHERE from_user_id = check_user_id;
    
	DELETE FROM profiles
	WHERE user_id = check_user_id;
    
    DELETE FROM users
	WHERE id = check_user_id;
    
	DELETE FROM users_communities
	WHERE user_id = check_user_id;
    
	SET FOREIGN_KEY_CHECKS=1;
    COMMIT;
    -- ROLLBACK;
  END// 
DELIMITER ; 

call func_del_user1(5);

/*
Задача 3. * Написать триггер, который проверяет новое появляющееся сообщество. 
Длина названия сообщества (поле name) должна быть не менее 5 символов. 
Если требование не выполнено, то выбрасывать исключение с пояснением.
*/
DROP TRIGGER IF EXISTS check_community_name_length_before_update;

DELIMITER //

CREATE TRIGGER check_community_name_length_before_update BEFORE INSERT ON communities
FOR EACH ROW
begin
    IF LENGTH(NEW.name) < 5 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Обновление отменено. Длина названия сообщества должна быть не менее 5 символов.';
    END IF;
END//

DELIMITER ;


INSERT INTO communities(name)  values('new');


