/*1. �������� ������� � ���������� ����������, ��������� ����������� ���������. ����������� ���� �������: product_name (�������� ������), manufacturer (�������������), product_count (����������), price (����). ��������� �� ������������� �������.
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


/*2. �������� SELECT-������, ������� ������� �������� ������, ������������� � ���� ��� �������, ���������� ������� ��������� 2
*/ 
SELECT product_name, manufacturer, price, product_count
FROM `homework_1`.`phone_shop`
WHERE product_count > 2; 


/*3. �������� SELECT-�������� ���� ����������� ������� ����� �Samsung�
*/ 
SELECT * FROM `homework_1`.`phone_shop`
WHERE manufacturer = 'Samsung';

/*4.*  � ������� SELECT-������� � ���������� LIKE �����:
	4.1.* ������, � ������� ���� ���������� "Iphone"
	4.2.* ������, � ������� ���� ���������� "Samsung"
	4.3.* ������, � �������� ������� ���� �����
	4.4.* ������, � �������� ������� ���� ����� "8"  
*/

SELECT * FROM `homework_1`.`phone_shop`
WHERE product_name LIKE '%iPhone%';

SELECT * FROM `homework_1`.`phone_shop`
WHERE manufacturer LIKE '%Samsung%';
                                                                                         
SELECT * FROM `homework_1`.`phone_shop`
WHERE product_name REGEXP '[0-9]';

SELECT * FROM `homework_1`.`phone_shop`
WHERE product_name LIKE '%8%';



