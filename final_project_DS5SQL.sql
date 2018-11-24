CREATE TABLE product (maker VARCHAR(1), model serial PRIMAL KEY, type VARCHAR(20) NOT NULL);
INSERT INTO product VALUES ('B', '1121', 'PC');
INSERT INTO product VALUES ('A', '1232', 'PC');
INSERT INTO product VALUES ('A', '1233', 'PC');
INSERT INTO product VALUES ('E', '1260', 'PC');
INSERT INTO product VALUES ('A', '1276', 'Printer');
INSERT INTO product VALUES ('D', '1288', 'Printer');
INSERT INTO product VALUES ('A', '1298', 'Laptop');
INSERT INTO product VALUES ('C', '1321', 'Laptop');
INSERT INTO product VALUES ('A', '1401', 'Printer');
INSERT INTO product VALUES ('A', '1408', 'Printer');
INSERT INTO product VALUES ('D', '1433', 'Printer');
INSERT INTO product VALUES ('E', '1434', 'Printer');
INSERT INTO product VALUES ('B', '1750', 'Laptop');
INSERT INTO product VALUES ('A', '1752', 'Laptop');
INSERT INTO product VALUES ('E', '2113', 'PC');
INSERT INTO product VALUES ('E', '2112', 'PC');

CREATE TABLE pc (code serial PRIMAL KEY, model bigint, speed bigint, ram bigint, hd bigint, cd VARCHAR(5), price bigint);
INSERT INTO pc VALUES ('1', '1232', '500', '64', '5.0', '12x', '600.0000');
INSERT INTO pc VALUES ('2', '1121', '750', '128', '14.0', '40x', '850.0000');
INSERT INTO pc VALUES ('3', '1233', '500', '64', '5.0', '12x', '600.0000');
INSERT INTO pc VALUES ('4', '1121', '600', '128', '14.0', '40x', '850.0000');
INSERT INTO pc VALUES ('5', '1121', '600', '128', '8.0', '40x', '850.0000');
INSERT INTO pc VALUES ('6', '1233', '750', '128', '20.0', '50x', '950.0000');
INSERT INTO pc VALUES ('7', '1232', '500', '32', '10.0', '12x', '400.0000');
INSERT INTO pc VALUES ('8', '1232', '450', '64', '8.0', '24x', '350.0000');
INSERT INTO pc VALUES ('9', '1232', '450', '32', '10.0', '24x', '350.0000');
INSERT INTO pc VALUES ('10', '1260', '500', '32', '10.0', '12x', '350.0000');
INSERT INTO pc VALUES ('11', '1233', '900', '128', '40.0', '40x', '980.0000');
INSERT INTO pc VALUES ('12', '1233', '800', '128', '20.0', '50x', '970.0000');

CREATE TABLE laptop (code serial PRIMAL KEY, model bigint, speed bigint, ram bigint, hd bigint, price bigint, screen bigint);
INSERT INTO laptop VALUES ('1', '1298', '350', '32', '4.0', '700.0000', '11');
INSERT INTO laptop VALUES ('2', '1321', '500', '64', '8.0', '970.0000', '12');
INSERT INTO laptop VALUES ('3', '1750', '750', '128', '12.0', '1200.0000', '14');
INSERT INTO laptop VALUES ('4', '1298', '600', '64', '10.0', '1050.0000', '15');
INSERT INTO laptop VALUES ('5', '1752', '750', '128', '10.0', '1150.0000', '14');
INSERT INTO laptop VALUES ('6', '1298', '450', '64', '10.0', '950.0000', '12');

CREATE TABLE printer (code serial PRIMAL KEY, model bigint, color VARCHAR(1), type VARCHAR(20), price bigint);
INSERT INTO printer VALUES ('6', '1288', 'n', 'Laser', '400.0000');
INSERT INTO printer VALUES ('5', '1408', 'n', 'Matrix', '270.0000');
INSERT INTO printer VALUES ('4', '1401', 'n', 'Matrix', '150.0000');
INSERT INTO printer VALUES ('3', '1434', 'y', 'Jet', '290.0000');
INSERT INTO printer VALUES ('2', '1433', 'y', 'Jet', '270.0000');
INSERT INTO printer VALUES ('1', '1276', 'n', 'Laser', '400.0000');


--1
SELECT model, ram, screen FROM laptop WHERE price>1000;

--2 Модель, скорость, hdd ПК ценой менее 600 и CD приводом 12x или 24x скорости
SELECT model, speed, hd FROM PC WHERE cd ='12x'AND price<600 OR cd = '24x' AND price<600;

--3 Производитель и скорость ноутбуков с объемом hdd не менее 10
SELECT DISTINCT maker,speed FROM Product JOIN Laptop ON Product.model=Laptop.model WHERE hd>=10;

--4 Все изделия производителя B
SELECT Laptop.model,price FROM Laptop INNER JOIN Product ON Laptop.model=Product.model WHERE maker ='B'
UNION
SELECT PC.model,price FROM PC INNER JOIN Product ON PC.model=Product.model WHERE maker ='B'
UNION
SELECT Printer.model,price FROM Printer INNER JOIN Product ON Printer.model=Product.model WHERE maker ='B';

--5 Производитель ПК но не ноутбуков
SELECT DISTINCT maker FROM Product INNER JOIN PC on Product.model=PC.model
EXCEPT
SELECT DISTINCT maker FROM Product INNER JOIN Laptop on Product.model=Laptop.model;

--6* Самые дорогие принтеры
SELECT model,price FROM Printer WHERE price = (SELECT MAX (price) FROM Printer);

--7 Средняя скорость компьютеров производителя A
SELECT AVG(speed) AS A_prod_avg_speed FROM PC JOIN Product ON PC.model=Product.model WHERE maker = 'A';

--8* Производители только одного типа продукции с более чем одной моделью
WITH 
tmp_tbl2 AS
(SELECT COUNT(model) AS qty_model, maker,type FROM Product GROUP BY maker, type),
tmp_tbl AS
(SELECT COUNT(type) AS qty_type, maker FROM tmp_tbl2 GROUP BY maker)
SELECT tmp_tbl.maker, type
FROM tmp_tbl2 JOIN tmp_tbl ON tmp_tbl2.maker=tmp_tbl.maker
WHERE qty_type=1 AND qty_model>1;

--9 Найдите размеры жестких дисков, совпадающих у двух и более PC
SELECT hd FROM PC GROUP BY hd HAVING COUNT(code)> 1;

--10* Моделеи PC, имеющих одинаковые скорость и RAM.
WITH PC1 AS (SELECT model, ram, speed FROM PC)
SELECT DISTINCT PC.model, PC1.model, PC.speed, PC.ram FROM PC,PC1 
 	WHERE PC.ram=PC1.ram AND PC.speed=PC1.speed AND PC.model>PC1.model ORDER BY PC.model DESC







