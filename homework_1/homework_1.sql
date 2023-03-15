/*1. Создайте таблицу с мобильными телефонами, используя графический интерфейс. Необходимые поля таблицы: product_name (название товара), manufacturer (производитель), product_count (количество), price (цена). Заполните БД произвольными данными.
*/ 

CREATE TABLE `homework_1`.`phone_shop` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NULL,
  `manufacturer` VARCHAR(45) NULL,
  `product_count` INT NULL,
  `price` DOUBLE NULL,
  PRIMARY KEY (`id`))

INSERT INTO `homework_1`.`phone_shop` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('1', 'iPhone 14', 'Apple', '10', '79990');
INSERT INTO `homework_1`.`phone_shop` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('2', 'iPhone X', 'Apple', '2', '45990');
INSERT INTO `homework_1`.`phone_shop` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('3', 'Galaxy Tab S8', 'Samsung', '3', '60999 ');
INSERT INTO `homework_1`.`phone_shop` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('4', 'Galaxy S23', 'Samsung', '4', '74999');


/*2. Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2
*/ 
SELECT product_name, manufacturer, price, product_count
FROM `homework_1`.`phone_shop`
WHERE product_count > 2; 


/*3. Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
*/ 
SELECT * FROM `homework_1`.`phone_shop`
WHERE manufacturer = 'Samsung';

/*4.*  С помощью SELECT-запроса с оператором LIKE найти:
	4.1.* Товары, в которых есть упоминание "Iphone"
	4.2.* Товары, в которых есть упоминание "Samsung"
	4.3.* Товары, в названии которых есть ЦИФРЫ
	4.4.* Товары, в названии которых есть ЦИФРА "8"  
*/

SELECT * FROM `homework_1`.`phone_shop`
WHERE product_name LIKE '%iPhone%';

SELECT * FROM `homework_1`.`phone_shop`
WHERE manufacturer LIKE '%Samsung%';
                                                                                         
SELECT * FROM `homework_1`.`phone_shop`
WHERE product_name REGEXP '[0-9]';

SELECT * FROM `homework_1`.`phone_shop`
WHERE product_name LIKE '%8%';



