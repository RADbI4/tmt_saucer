/* 
Общее текстовое описание БД и решаемых ею задач.
База данных для PLM (Product Life-Cycle Managment) проекта, 
используемая в мелко, серийных и крупносерийных производствах простых и сложных изделий.

I

БД содержит, добавляет и оперирует следующими таблицами:
1.	Общая таблица главных изделий, сборок, деталей нормалей используемых на предприятии.
2.	Таблица инструмента, оборудования, специализированной оснастки, необходимых для изготовления конкретной детали. 
3.	Общая таблица материала и сортамента.
4.	Таблица применяемости инструмента на конкертном изделии. Один и тот же инструмент может использоваться для разных деталей.
Так, например, один и тот же молоток может использоваться для забивания разных гвоздей.
5.	Таблица применяемости материалов на конкретные детали и сборки. 
Один и тот же матриал может применятся для различных деталей
6.	Таблица главных изделий.
7.	Таблица содержания главного изделия (таблица главных сборок) 
Так, общее количество подсборок в главной сборке (в Яхте): Корпус, такелаж, мат.часть, силовая 
установка, трансмиссия, система управления, система жизнеобеспечения, система связи-навигации, электросистема, мебель, 
иснтрументы и другое мелкое оборудование- которое идёт вместе с покупкой яхты). 
8.	Таблица содержания главных сборок для главных изделий. Одна и та же главная сборка может применяться 
для разных главных изделий* 
9.	Таблица содержания подсборок (таблица подсборок и деталей, входящих в главную сборку)
На примере данного проекта будет рассматриваться структура подсборок корпус, такелаж, мат.часть, силовая 
установка, трансмиссия, система управления, система жизнеобеспечения, система связи-навигации, электросистема, мебель, 
иснтрументы и другое мелкое оборудование- которое идёт вместе с покупкой яхты).
10. Таблица применения подсборок для главных сборок. Одна и та же подсборка может применятся для разных главных сборок
11. Таблица сборок. 
12. Таблица содержания сборок в подсборках. одна и та же сборка может быть в разных подсборках
13.	Таблица деталей. Детали могут применяться для главных изделий и для главных сборок, и для под сборок, и для сборок.
14. Таблица применяемости деталей на главном изделии, главной сборке, подсборке и сборке.
Одна и та же деталь может применятся в совершенно разных комбинациях сборок/подсборок и т.д.
15. Таблица нормалей (болты, гайки, заклёпки, фурнитура, гвозди, винты и .т. и т.п. всё, что изготавливается по ГОСТ, ОСТ и ТУ,
другим нормативным документациям.
16. Таблица применяемости нормалей на главном изделии, главной сборке, подсборке и сборке, детали
Может входить в самых разных комбинациях и количествах. 
17. Таблица типов данных для файлов документации, необходимых для изготовления детали.
Сюда входят чертежи, тех. процессы, инструкции, ГОСТы, ОСТы, ТУ, видео-материалы и т.д.
18. Таблица документации. Сюда входят чертежи, тех. процессы, инструкции, ГОСТы, ОСТы, ТУ, видео-материалы и т.д.
19. Таблица применяемости технической документации для изготовления детали. 
Некотороя техническая документация может распространяться на несколько деталей. 
В частности нормо-документы. зачастую, один чертёж/тех процесс идёт под одну и ту же деталь.

II

База данных реашет следующие задачи:
1)Добавление новых главных изделий, подсборок, деталей, нормалей, материалов, инструмента, специализированной
оснастки, оборудования, технологических процессов.
2)Подача необходимых данных в PLM приложение.
3)Сбор новых таблиц, в автоматическом режиме формирование таблиц подсборок, деталей.
4)БД позволяет хранить все необходимые данные для производства главного изделия. Отражает данные в реальном времени.
5)Хранение данных новых главных изделий, подсборок, деталей, нормалей, материалов, инструмента, специализированной
оснастки, оборудования, технологических процессов.
6)Предоставление необходимых данных по запросам.

Данная база данных будет представлена на примере изготовления главного изделия "Яхта модели 0001".
*/
DROP DATABASE The_Core;
CREATE DATABASE The_Core;
USE The_Core; 

/*
 1. Общая таблица главных изделий, сборок, деталей нормалей используемых на предприятии.
 Необходима, чтобы анализировать количество номеклатуры производимым предприятием, отслеживать наличие на складе а так же.
 Следующая главная цель- формировать новые сборки и подсборки из имеющихся деталь при использовании старых детлей для
 нового главного изделия.
 */
DROP TABLE IF EXISTS product_range;
CREATE TABLE product_range (
	/* Собственно имя изделия, не может быть не задано, не уникально. 
	 * Могут встречаться изделия с одинаковыми именами, например "Кронштейн" или "Болт" */
	name VARCHAR(100) NOT NULL,	
	/*Заводской шифр изделия, уникален, не может иметь пустое значение, по сути- самое главное значение в этой БД
	 вокруг заводского шифра строится вся БД*/
	cipher VARCHAR(100) UNIQUE NOT NULL PRIMARY KEY, 		
	/*Тип продукта, может принимать только эти значения: Главный продукт, главная сборка, подсборка, сборка, деталь, нормаль*/
	type_of_product ENUM('MAIN PRODUCT', 'MAIN ASSEMBLY', 'UNDER ASSEMBLY', 'ASSEMBLY', 'DETAIL', 'NORMAL') NOT NULL,		
	/*Где складиуертся? ID склада, может нигде не складироваться, если изделия нет физически*/
	stoaraged INT DEFAULT NULL,		
	/* Сколько складируется? может нисколько, если изделия нет физически */
	stoarage_count INT DEFAULT NULL,		
	/*Фактическое время производства, по умолчанию налл, поскольку деталь ещё ни разу не изготовлялась*/
	manufacturing_time_fact VARCHAR(100) DEFAULT NULL,	
	/*Теоретичесоке время изготовления- на основе тех процессов на изготовление, либо предполагаемое, не может быть не задано */
	manufacturing_time_theor VARCHAR(100) NOT NULL,	
	/* Уникальный штрих-код изделия для привязки физического объекта к БД*/
	product_barcode INT DEFAULT NULL
	);


/*
2. Общая таблица инструмента, оборудования, оснастки используемого на предприятии.
Такая таблица необходима компании-предприятию, чтобы 
1)Знать какой вообще инструмент использует предприятие, чтобы планировать закупки быстроизнашиваемого инструмента
в зависимости от скорости его расхода. послько постольку она будет разной и какой то инструмент надо покупать в первую 
очередь, а какой-то во вторую и т.д.
2)Вытаскивать какой необходим инструмент для конкретной детали, подсборки, главного изделия.
3)Анализировать расходуемость инструмента, чтобы оптимизировать его качество (выбрать других, более качественных 
поставщиков или вообще выбрать инструмент другой фирмы)
4)Отслеживать стоймость предприятия, обородуования
5)Проверять загруженность оборудования
и др.
 */

-- DROP TABLE IF EXISTS total_tools;
CREATE TABLE total_tools (
	/* Собственно ID инструмента, уникален, является номеклатурным номером предмета*/
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 	
	/* Название инструмента, уникально, не может быть не задано, т.к. у каждлого инструмента есть своё название */
	name VARCHAR(100) NOT NULL,	
	/* Тип иструмента, мб всё, что угодно, за один раз не перечислишь всё: Станок, технологическая оснастка, 
	 * режущий инструмент, слесарный инструмент, обслуживающий инструмент и т.д. и т.п. */
	type_of_tool ENUM('MACHINE', 'RIG_TOOL', 'CUTTING_TOOL', 'HAND_TOOL', 'MAINTAIN_TOOL'),		/*
	 Брэнд инструмента: брэнд станка, режущего инструмента, технологической оснастки и т.д.*/
	tool_brand VARCHAR(100) NOT NULL,	
	/* Количество инструмента на предприятии */
	ammount_of INT DEFAULT NULL,	
	/* Цена 1шт инструмента */
	price_per_one INT DEFAULT  NULL,
	/* Общая цена инструмента*/
	ammount_price INT DEFAULT NULL,	
	/* Штрих-код инструмента */
	tool_barcode INT DEFAULT NULL
	);

/*
 3.Общая таблица материала и сортамента.
 */
-- DROP TABLE IF EXISTS raw_material;
CREATE TABLE raw_material(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	/* Марка материала. Всё, что угодно, какой угодно материал, пластик, металл, не металл, клей и т.д. и т.п.. 
	 * За один раз не перечислишь всё, надо постоянно обновлять*/
	material_stamp ENUM('METALL_ALLOY', 'POLYMER', 'COMPOSITE', 'NON_METAL') NOT NULL,
	/* Вид поставки. За один раз не перечислишь всё, надо постоянно обновлять.*/
	form ENUM('TUBE', 'CUBE', 'STOVE', 'POWDER', 'LIQUID', 'PREPREG', 'SEMI-FIFNSHED-PRODUCT') NOT NULL,
	/* Нормо-документ вид поставки (ГОСТ, ОСТ, ТУ и т.д.) */
	nd_of_form VARCHAR(100) NOT NULL,
	/* Норо-документ на марку мтариала (ГОСТ, ОСТ, ТУ и т.д.)*/
	nd_of_material_stamp VARCHAR(100) NOT NULL,
	/* Штрих-код материала*/
	material_barcode INT NOT NULL
	); 


/*
 4.Таблица применяемости инструмента на конкертном изделии. Один и тот же инструмент может использоваться для разных деталей.
 Так, например, один и тот же молоток может использоваться для забивания разных гвоздей.
 */

-- DROP TABLE IF EXISTS tool_applicability; 
CREATE TABLE tool_applicability (
	tool_id INT UNSIGNED NOT NULL, 
	cipher VARCHAR(100) NOT NULL, 
	KEY (tool_id),
	KEY (cipher),
	FOREIGN KEY (tool_id) REFERENCES total_tools (id), 
	FOREIGN KEY (cipher) REFERENCES product_range (cipher)
	);

/* 5.Таблица применяемости материалов на конкретные детали и сборки. 
 * Один и тот же матриал может применятся для различных деталей */
-- DROP TABLE IF EXISTS material_applicability; 
CREATE TABLE material_applicability (
	material_id INT UNSIGNED NOT NULL,
	cipher VARCHAR(100) NOT NULL,
	KEY  (material_id),
	KEY (cipher),
	FOREIGN KEY (material_id) REFERENCES raw_material (id),
	FOREIGN KEY (cipher) REFERENCES product_range (cipher) 
	);


-- 6.Таблица главных изделий. -- 
-- DROP TABLE IF EXISTS main_product;
CREATE TABLE main_product(
	id INT NOT NULL, 
	/* Собственно, имя главного продукта */
	name VARCHAR(100) NOT NULL,
	/* Заводской шифр модели главного продукта, обязательно должен быть заполнен */
	model_cipher VARCHAR(100) NOT NULL PRIMARY KEY UNIQUE,
	/*Модель главного изделия, модельного ряда*/
	model INT UNSIGNED NOT NULL, 
	/*Комплектация главного изделия */
	equipment VARCHAR(100) NOT NULL,
	/*Цена главного изделия в $ */
	price INT UNSIGNED NOT NULL, 
	FOREIGN KEY (model_cipher) REFERENCES product_range (cipher)
	);

/* 
 11. Таблица сборок.
 */ 
-- DROP TABLE IF EXISTS assembly;
CREATE TABLE assembly(
	assembly_cipher VARCHAR(100)NOT NULL UNIQUE PRIMARY KEY,
	name VARCHAR(100) NOT NULL
	);

/*12. Таблица содержания сборок в подсборках. одна и та же сборка может быть в разных подсборках*/
-- DROP TABLE IF EXISTS assembly_applicability;
CREATE TABLE assembly_applicability(
	assembly_cipher VARCHAR(100) NOT NULL,
	under_assembly_cipher VARCHAR(100) NOT NULL,
	KEY (under_assembly_cipher),
	KEY (assembly_cipher),
	FOREIGN KEY (assembly_cipher) REFERENCES assembly(assembly_cipher),
	FOREIGN KEY (under_assembly_cipher) REFERENCES under_assembly(under_assembly_cipher)
	);

/*13.Таблица деталей. Детали могут применяться для главных изделий и для главных сборок, и для под сборок, и для сборок. */
DROP TABLE IF EXISTS detail;
CREATE TABLE detail(
	detail_cipher VARCHAR(100)NOT NULL UNIQUE PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	FOREIGN KEY (detail_cipher) REFERENCES product_range(cipher) 
	);

/*14. Таблица применяемости деталей на главном изделии, главной сборке, подсборке и сборке.
 * Одна и та же деталь может применятся в совершенно разных комбинациях сборок/подсборок и т.д. */
DROP TABLE IF EXISTS detail_applicability;
CREATE TABLE detail_applicability(
	detail_cipher VARCHAR(100)NOT NULL,
	applicability_cipher VARCHAR(100)NOT NULL,
	KEY(detail_cipher),
	FOREIGN KEY (detail_cipher) REFERENCES product_range(cipher),
	FOREIGN KEY (applicability_cipher) REFERENCES product_range(cipher)
	);


/* 15. Таблица нормалей (болты, гайки, заклёпки, фурнитура, гвозди, винты и .т. и т.п. всё, что изготавливается по ГОСТ, ОСТ и ТУ,
 * другим нормативным документациям */
-- DROP TABLE IF EXISTS normal_elements;
CREATE TABLE normal_elements (
	/* Шифр детали по НД*/
	normal_cipher VARCHAR(100) NOT NULL PRIMARY KEY, 
	/* Тип детали по НД, всё сразу не перечислить: гайка, болт, заклёпка, винт, гвоздь и т.д. и т.п. 
	 * солдбец придётся постоянно обновлять*/
	type_of_normal ENUM('NUT', 'BOLT', 'RIVET', 'SCREW', 'NAIL'),
	/* Нормативный документ на нормаль, т.е. сам ГОСТ, ОСТ, ТУ и т.д. и т.п.*/
	nd_of_normal VARCHAR(100) NOT NULL,
	FOREIGN KEY (normal_cipher) REFERENCES product_range(cipher)
	);

/* 16. Таблица применяемости нормалей на главном изделии, главной сборке, подсборке и сборке, детали
Может входить в самых разных комбинациях и количествах */
-- DROP TABLE IF EXISTS normal_applicability;
CREATE TABLE normal_applicability (
	normal_cipher VARCHAR(100) NOT NULL,
	detail_cipher VARCHAR(100) NOT NULL,
	model_cipher VARCHAR(100) DEFAULT NULL,
	main_assembly_cipher VARCHAR(100) DEFAULT NULL,
	under_assembly_cipher VARCHAR(100) DEFAULT NULL,
	assembly_cipher VARCHAR(100) DEFAULT NULL,
	KEY(normal_cipher),
	FOREIGN KEY (normal_cipher) REFERENCES normal_elements(normal_cipher), 
	FOREIGN KEY (detail_cipher) REFERENCES product_range(cipher),
	FOREIGN KEY (model_cipher) REFERENCES main_product(model_cipher),
	FOREIGN KEY (main_assembly_cipher) REFERENCES main_assembly(main_assembly_cipher),
	FOREIGN KEY (under_assembly_cipher) REFERENCES under_assembly(under_assembly_cipher),
	FOREIGN KEY (assembly_cipher) REFERENCES assembly(assembly_cipher)
	);

/* 17. Таблица типов данных для файлов документации, необходимых для изготовления детали.
 * Сюда входят чертежи, тех. процессы, инструкции, ГОСТы, ОСТы, ТУ, видео-материалы и т.д. */
-- DROP TABLE IF EXISTS type_tech_data;
CREATE TABLE type_tech_data(
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	type_of_file ENUM('PICTURE', 'PDF', 'TEXT', 'VIDEO', 'G-CODE', 'EXCEL') NOT NULL,
	file_format ENUM ('.jpeg', '.pdf', '.txt', '.mp4', '.gcode', '.excl') NOT NULL
	); 

/*18. Таблица документации. Сюда входят чертежи, тех. процессы, инструкции, ГОСТы, ОСТы, ТУ, видео-материалы и т.д.*/
-- DROP TABLE IF EXISTS tech_data;
CREATE TABLE tech_data (
	tech_data_cipher VARCHAR(100) NOT NULL PRIMARY KEY, 
	type_of ENUM ('BLUEPRINT', 'TECH PROCESS', 'INSTRUCTION', 
	'VIDEO TECH PROCESS', 'CNC PROGRAM', 'RIG TOOL BLUEPRINT', 'ND') NOT NULL,
	file_id INT UNSIGNED NOT NULL,
	file_name VARCHAR(100) NOT NULL,
	FOREIGN KEY (file_id) REFERENCES type_tech_data(id)
	);

/* 19. Таблица применяемости технической документации для изготовления детали. 
 * Некотороя техническая документация может распространяться на несколько деталей. 
 * В частности нормо-документы. зачастую, один чертёж идёт под одну и ту же деталь. */
-- DROP TABLE IF EXISTS tech_data_applicability;
CREATE TABLE tech_data_applicability ( 
	tech_cipher VARCHAR(100) NOT NULL,
	used_for_product VARCHAR (100) NOT NULL,
	KEY (used_for_product),
	KEY (tech_cipher),
	FOREIGN KEY (used_for_product) REFERENCES product_range(cipher) 
	);


/*20. Таблица применмости шифра в главном изделии. В таблице будет информация по всем ДСЕ, применяемых на конкертном продукте*/
-- DROP TABLE IF EXISTS main_product_total;
CREATE TABLE main_product_total (
	main_product_cipher VARCHAR(100) NOT NULL,
	cipher_total  VARCHAR(100) NOT NULL,
	KEY (main_product_cipher),
	KEY (cipher_total),
	FOREIGN KEY (main_product_cipher) REFERENCES main_product(model_cipher),
	FOREIGN KEY (cipher_total) REFERENCES product_range(cipher) 
	);

/*Заполняем базу данных для производства яхты
 * Корпус, такелаж, мат.часть, силовая 
установка, трансмиссия, система управления, система жизнеобеспечения, система связи-навигации, электросистема, мебель, 
иснтрументы и другое мелкое оборудование- которое идёт вместе с покупкой яхты)
В данном примере рассмотрим изготовление Корпуса лодки.
*/
INSERT INTO product_range (name, 
						   cipher, 
						   type_of_product, 
						   manufacturing_time_theor)						   
VALUES 
('ТМТ-1 БЯ', 'Я.00000.00000', 'MAIN PRODUCT', '147421427252:10:13'), -- Собственно модель Яхты.
('Корпус', 'Я.01000.00000', 'MAIN ASSEMBLY', '14531:12:14' ), -- Тут перечислен состав Яхты, из чего она сделана 
('Такелаж', 'Я.02000.00000', 'MAIN ASSEMBLY', '14561:45:31' ),
('Мат.часть', 'Я.03000.00000', 'MAIN ASSEMBLY', '54146:26:35' ),
('Силовая установка', 'Я.04000.00000', 'MAIN ASSEMBLY', '45416:54:24' ),
('Трансмиссия', 'Я.05000.00000', 'MAIN ASSEMBLY', '54416:45:41' ),
('Система управления', 'Я.06000.00000', 'MAIN ASSEMBLY', '65412:54:44' ),
('Система жизнеобеспечения', 'Я.07000.00000', 'MAIN ASSEMBLY', '89513:41:42' ),
('Система связи-навигации', 'Я.08000.00000', 'MAIN ASSEMBLY', '614516:45:21' ),
('Электросистема', 'Я.09000.00000', 'MAIN ASSEMBLY', '4617:52:14' ),
('Мебель', 'Я.10000.00000', 'MAIN ASSEMBLY', '64548:51:34' ),
('Бортовой инструмент', 'Я.11000.00000', 'MAIN ASSEMBLY', '146476:14:33' ),
('Силовой набор в сборе', 'Я.00100.00000', 'UNDER ASSEMBLY', '45645:45:55' ), -- Силовой набор в сборе входит в состав Корпуса лодки.
('Закладная под трансмиссию', 'Я.00100.00100', 'ASSEMBLY', '154:15:54' ), -- Ассемблы входят в состав Силового набора
('Закладная под шверт', 'Я.00100.00200', 'ASSEMBLY', '645:41:12' ),
('Закладная под бушприт', 'Я.00100.00300', 'ASSEMBLY', '2164:12:31' ),
('Закладная под каюту', 'Я.00100.00400', 'ASSEMBLY', '5214:45:13' ),
('Закладная под кухню', 'Я.00100.00500', 'ASSEMBLY', '456:11:12' ),
('Закладная под туалет', 'Я.00100.00600', 'ASSEMBLY', '654:12:31' ),
('Закладная под холодильник', 'Я.00100.00700', 'ASSEMBLY', '841:12:31' ),
('Закладная под мостик', 'Я.00100.00800', 'ASSEMBLY', '514:32:45' ),
('Закладная мачты', 'Я.00100.00900', 'ASSEMBLY', '621:15:54' ),
('Закладная под рубку', 'Я.00100.01000', 'ASSEMBLY', '7465:45:32' ),
('1 Шпангоут', 'Я.00100.00001', 'DETAIL', '651:13:00' ), -- Детали входящие в состав силового набора
('2 Шпангоут', 'Я.00100.00002', 'DETAIL', '2994:41:31'),
('3 Шпангоут', 'Я.00100.00003', 'DETAIL', '456:20:13' ),
('4 Шпангоут', 'Я.00100.00004', 'DETAIL', '665:41:12' ),
('5 Шпангоут', 'Я.00100.00005', 'DETAIL', '698:45:13' ),
('6 Шпангоут', 'Я.00100.00006', 'DETAIL', '798:43:55' ),
('7 Шпангоут', 'Я.00100.00007', 'DETAIL', '988:13:14' ),
('8 Шпангоут', 'Я.00100.00008', 'DETAIL', '659:58:00' ),
('Киль', 'Я.00100.00009', 'DETAIL', '199:23:12' ),
('Стрингер левый', 'Я.00100.00010', 'DETAIL', '312:15:13' ),
('Стрингер правый', 'Я.00100.00011', 'DETAIL', '312:15:13' ),
('Рубка', 'Я.00200.00000', 'UNDER ASSEMBLY', '1474:56:45' ), -- Рубка входит в состав Корпуса лодки.
('Стрингер левый нижний', 'Я.00200.00010', 'DETAIL', '145:16:22' ), -- Детали, входящие в рубку
('Стрингер правый нижний', 'Я.00200.00011', 'DETAIL', '145:16:22' ),
('Ребро', 'Я.00200.00012', 'DETAIL', '15:35:44'),
('Ребро', 'Я.00200.00013', 'DETAIL', '15:35:44'),
('Ребро', 'Я.00200.00014', 'DETAIL', '15:35:44'),
('Стрингер левый верхний', 'Я.00200.00015', 'DETAIL', '145:16:22'),
('Стрингер правый верхний', 'Я.00200.00016', 'DETAIL', '145:16:22' ),
('Доска палубная левая', 'Я.01000.00001', 'DETAIL', '14:12:44' ), -- Детали для Корпуса лодки совместно с силовым набором и рубкой
('Доска палубная правая', 'Я.01000.00002', 'DETAIL', '15:16:44' ),
('Доска корпусная левая', 'Я.01000.00003', 'DETAIL', '11:56:54' ),
('Доска палубная левая', 'Я.01000.00004', 'DETAIL', '15:16:44' ),
('Доска палубная', 'Я.01000.00005', 'DETAIL', '15:16:44' ),
('Доска палубная', 'Я.01000.00006', 'DETAIL', '15:16:44' ),
('Доска рубки палубная', 'Я.01000.00007', 'DETAIL', '15:16:44' ),
('Доска рубки боковая правая', 'Я.01000.00008', 'DETAIL', '15:16:44' ),
('Доска рубки боковая левая', 'Я.01000.00009', 'DETAIL', '15:16:44' ),
('Доска мостика палубная', 'Я.01000.00010', 'DETAIL', '15:16:44' ),
('Доска-стенка мостика', 'Я.01000.00011', 'DETAIL', '15:16:44' );
/**/
	
/*Задаём профиль главного продукта*/
INSERT INTO main_product (id, name, model_cipher, model, equipment, price)
VALUES (1, 'ТМТ-1БЯ', 'Я.00000.00000', 1, 'Базовая', 50000);

/*Задаём главные сборки Яхты*/
/*Задаём состав главных сборок главного изделия- Яхты */
INSERT INTO main_assembly (name, main_assembly_cipher, id)
VALUES 
('Корпус', 'Я.01000.00000', 1),
('Такелаж', 'Я.02000.00000',  2),
('Мат.часть', 'Я.03000.00000', 3),
('Силовая установка', 'Я.04000.00000', 4),
('Трансмиссия', 'Я.05000.00000', 5),
('Система управления', 'Я.06000.00000', 6),
('Система жизнеобеспечения', 'Я.07000.00000', 7),
('Система связи-навигации', 'Я.08000.00000', 8),
('Электросистема', 'Я.09000.00000', 9),
('Мебель', 'Я.10000.00000', 10),
('Бортовой инструмент', 'Я.11000.00000', 11);

/*Задаём состав главных сборок главного изделия- Яхты */
INSERT INTO main_assembly_applicability (main_assembly_cipher, main_product_cipher)
VALUES 
('Я.01000.00000', 'Я.00000.00000'),
('Я.02000.00000', 'Я.00000.00000'),
('Я.03000.00000', 'Я.00000.00000'),
('Я.04000.00000', 'Я.00000.00000'),
('Я.05000.00000', 'Я.00000.00000'),
('Я.06000.00000', 'Я.00000.00000'),
('Я.07000.00000', 'Я.00000.00000'),
('Я.08000.00000', 'Я.00000.00000'),
('Я.09000.00000', 'Я.00000.00000'),
('Я.10000.00000', 'Я.00000.00000'),
('Я.11000.00000', 'Я.00000.00000');

/*Задаём подсборки главных сборок на данный момент это силовой набор, рубка*/
INSERT INTO under_assembly (id, name, under_assembly_cipher)
VALUES 
(1, 'Силовой набор в сборе', 'Я.00100.00000'),
(2, 'Рубка', 'Я.00200.00000');

/*Задаём примеяемость подсборок. Силовой набор и рубка как подсборки необходимы для изготовления Корпуса лодки*/
INSERT INTO under_assembly_applicability (under_assembly_cipher, main_assembly_cipher)
VALUES 
('Я.00100.00000', 'Я.01000.00000'),
('Я.00200.00000', 'Я.01000.00000');

/*Зададим сборки, необходимые для изготовления корпуса в этот раз несколько иным способом. 
 * Таким образом, в этой таблице сосредоточены все сборки для изготовления
 * корпуса лодки в целом. */
INSERT INTO assembly 
SELECT cipher, name FROM product_range WHERE type_of_product = 'ASSEMBLY';

/*Зададим применяемости сборoк на подсборки и гланую сборку "Корпус"*/
INSERT INTO assembly_applicability (assembly_cipher, under_assembly_cipher)
VALUES 
('Я.00100.00100', 'Я.00100.00000'), -- Сборки входящие в Силовой набор. Рубка состоит целиком из деталей, сборок в ней нет.
('Я.00100.00200', 'Я.00100.00000'),
('Я.00100.00300', 'Я.00100.00000'),
('Я.00100.00400', 'Я.00100.00000'),
('Я.00100.00500', 'Я.00100.00000'),
('Я.00100.00600', 'Я.00100.00000'),
('Я.00100.00700', 'Я.00100.00000'),
('Я.00100.00800', 'Я.00100.00000'),
('Я.00100.00900', 'Я.00100.00000'),
('Я.00100.01000', 'Я.00100.00000');

/*Зададим детали необходимые для изготовления, как Корпуса лодки (Главная сборка), 
 * так и силового набора и рубки (подсборок) и их ассемблов, на данный момент детали ассемблов не были 
 * введенны, введём их позже.*/
INSERT INTO detail 
SELECT cipher, name FROM product_range WHERE type_of_product = 'DETAIL';

/*Зададим применямости деталей на Главную сборку-  Корпус, подсборки- Силовой набор и Рубка*/ 
INSERT INTO detail_applicability (detail_cipher, applicability_cipher)
VALUES 
('Я.01000.00001', 'Я.01000.00000'), -- Детали, совместно с силовым набором и рубкой составляют Корпус.
('Я.01000.00002', 'Я.01000.00000'),
('Я.01000.00003', 'Я.01000.00000'),
('Я.01000.00004', 'Я.01000.00000'),
('Я.01000.00005', 'Я.01000.00000'),
('Я.01000.00006', 'Я.01000.00000'),
('Я.01000.00007', 'Я.01000.00000'),
('Я.01000.00008', 'Я.01000.00000'),
('Я.01000.00009', 'Я.01000.00000'),
('Я.01000.00010', 'Я.01000.00000'),
('Я.01000.00011', 'Я.01000.00000'),
('Я.00100.00001', 'Я.00100.00000'), -- Детали, своместно со сборками составляют силовой набор.
('Я.00100.00002', 'Я.00100.00000'),
('Я.00100.00003', 'Я.00100.00000'),
('Я.00100.00004', 'Я.00100.00000'),
('Я.00100.00005', 'Я.00100.00000'),
('Я.00100.00006', 'Я.00100.00000'),
('Я.00100.00007', 'Я.00100.00000'),
('Я.00100.00008', 'Я.00100.00000'),
('Я.00100.00009', 'Я.00100.00000'),
('Я.00100.00010', 'Я.00100.00000'),
('Я.00100.00011', 'Я.00100.00000'),
('Я.00200.00010', 'Я.00200.00000'),-- Детали, составляющие рубку
('Я.00200.00011', 'Я.00200.00000'),
('Я.00200.00012', 'Я.00200.00000'),
('Я.00200.00013', 'Я.00200.00000'),
('Я.00200.00014', 'Я.00200.00000'),
('Я.00200.00015', 'Я.00200.00000'),
('Я.00200.00016', 'Я.00200.00000');

/*Зададим материал деталей, нужно отметить, что материал применим только к деталям и нормалям. 
 * Материал = (марка материала +НД на марку) + (вид поставки + НД на вид поставки)
 * Так как рассматриваем только доски и бруски из дерева то будут соответственно только эти строки
 * на самом деле в реальном проекте производства изделия их будет крайне много*/
INSERT INTO raw_material (material_stamp, form, nd_of_form, nd_of_material_stamp, material_barcode)
VALUES 
('METALL_ALLOY', 'STOVE', 'ГОСТ103-76', 'ГОСТ4543-71', '6911473');

-- INSERT INTO raw_material (material_stamp, form, nd_of_form, nd_of_material_stamp, material_barcode)
-- VALUES 
-- ('METALL_ALLOY', 'STOVE', 'ГОСТ103-76', 'ГОСТ4543-71', '6911473');

/*Зададим инструменты для производства изделий*/
INSERT INTO total_tools (name, type_of_tool, tool_brand)
VALUES 
('Прессформа для выкладки шпангоута 1', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 2', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 3', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 4', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 5', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 6', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 7', 'RIG_TOOL', 'Собственное производство'),
('Прессформа для выкладки шпангоута 8', 'RIG_TOOL', 'Собственное производство'),
('Вертикально-сверлильный станок', 'MACHINE', 'СТАН'),
('Гидравлический пресс', 'MACHINE', 'СТАН'),
('Ручной пресс', 'MACHINE', 'СТАН'),
('Автоклав', 'MACHINE', 'MAGNABOSCO'),
('Станок раскройный', 'MACHINE', 'PORTATEC'),
('Молоток слесарный', 'HAND_TOOL', 'GIGANT'),
('Кувалда', 'HAND_TOOL', 'GIGANT'),
('Кисть широкая', 'HAND_TOOL', 'BEST KIST`'),
('Валик', 'HAND_TOOL', 'BEST VALIK'),
('Ленточная пила', 'CUTTING_TOOL', 'REZON'),
('Фреза концевая 20R4L100B4', 'CUTTING_TOOL', 'SGS'),
('Стапель для сборки корпуса', 'RIG_TOOL', 'Собственное производство');

/*Зададим применяемость инструмента и оборудования на детали*/
INSERT INTO tool_applicability (tool_id, cipher)
VALUES 
(1, 'Я.00100.00001'),
(2, 'Я.00100.00002'),
(3, 'Я.00100.00003'),
(4, 'Я.00100.00004'),
(5, 'Я.00100.00005'),
(6, 'Я.00100.00006'),
(7, 'Я.00100.00007'),
(8, 'Я.00100.00008'),
(9, 'Я.01000.00010'),
(9, 'Я.01000.00011'),
(10, 'Я.00100.00001'),
(10, 'Я.00100.00002'),
(10, 'Я.00100.00003'),
(10, 'Я.00100.00004'),
(10, 'Я.00100.00005'),
(10, 'Я.00100.00006'),
(10, 'Я.00100.00007'),
(10, 'Я.00100.00008'),
(12, 'Я.00100.00001'),
(12, 'Я.00100.00002'),
(12, 'Я.00100.00003'),
(12, 'Я.00100.00004'),
(12, 'Я.00100.00005'),
(12, 'Я.00100.00006'),
(12, 'Я.00100.00007'),
(12, 'Я.00100.00008'),
(13, 'Я.00100.00001'),
(13, 'Я.00100.00002'),
(13, 'Я.00100.00003'),
(13, 'Я.00100.00004'),
(13, 'Я.00100.00005'),
(13, 'Я.00100.00006'),
(13, 'Я.00100.00007'),
(13, 'Я.00100.00008'),
(14, 'Я.00100.00001'),
(14, 'Я.00100.00002'),
(14, 'Я.00100.00003'),
(14, 'Я.00100.00004'),
(14, 'Я.00100.00005'),
(14, 'Я.00100.00006'),
(14, 'Я.00100.00007'),
(14, 'Я.00100.00008'),
(16, 'Я.00100.00001'),
(16, 'Я.00100.00002'),
(16, 'Я.00100.00003'),
(16, 'Я.00100.00004'),
(16, 'Я.00100.00005'),
(16, 'Я.00100.00006'),
(16, 'Я.00100.00007'),
(16, 'Я.00100.00008'),
(17, 'Я.00100.00001'),
(17, 'Я.00100.00002'),
(17, 'Я.00100.00003'),
(17, 'Я.00100.00004'),
(17, 'Я.00100.00005'),
(17, 'Я.00100.00006'),
(17, 'Я.00100.00007'),
(17, 'Я.00100.00008'),
(18, 'Я.00100.00001'),
(18, 'Я.00100.00002'),
(18, 'Я.00100.00003'),
(18, 'Я.00100.00004'),
(18, 'Я.00100.00005'),
(18, 'Я.00100.00006'),
(18, 'Я.00100.00007'),
(18, 'Я.00100.00008'),
(19, 'Я.00100.00001'),
(19, 'Я.00100.00002'),
(19, 'Я.00100.00003'),
(19, 'Я.00100.00004'),
(19, 'Я.00100.00005'),
(19, 'Я.00100.00006'),
(19, 'Я.00100.00007'),
(19, 'Я.00100.00008'),
(20, 'Я.01000.00000');

/*Задаём типы данных для технической документации*/
INSERT INTO type_tech_data (type_of_file, file_format)
VALUES 
('PICTURE', '.jpeg'),
('PDF', '.pdf'),
('TEXT', '.txt'),
('VIDEO', '.mp4'),
('G-CODE', '.gcode'),
('EXCEL', '.excl');

/*Задаём техническую документацию для изготовления деталей*/
INSERT INTO tech_data (tech_data_cipher, type_of, file_id, file_name)
VALUES 
('Я.00100.00001', 'BLUEPRINT', '2', 'Чертеж 1 шпангоут'),
('717.03142.11447', 'TECH PROCESS', '2', 'Техпроцесс на изготовление 1 шпангоута'),
('718.03142.11447', 'VIDEO TECH PROCESS', '4', 'Видео Техпроцесс на изготовление 1 шпангоута'),
('83780.02345.0000', 'RIG TOOL BLUEPRINT', '2', 'Чертеж Прессформы для выкладки шпангоута 1'),
('ГОСТ4543-71', 'ND', '2', 'ГОСТ на прокат из стали0 легированной'),
('Я.00100.00002', 'BLUEPRINT', '2', 'Чертеж 2 шпангоут'),
('717.03142.11448', 'TECH PROCESS', '2', 'Техпроцесс на изготовление 2 шпангоута'),
('718.03142.11448', 'VIDEO TECH PROCESS', '4', 'Видео Техпроцесс на изготовление 2 шпангоута'),
('83780.02346.0000', 'RIG TOOL BLUEPRINT', '2', 'Чертеж Прессформы для выкладки шпангоута 2'
);
/*Тут я столкнулся с тем, что я не могу задать применяемость чертежа на изготовление прессформы для прессформы, поэтому нужно
 * задать внешний ключ на инструмент и оборудование*/

/*Применяемость технической документации для изготовления 1 и 2 шпангоута.*/
INSERT INTO tech_data_applicability (tech_cipher, used_for_product)
VALUES 
('Я.00100.00001', 'Я.00100.00001'),
('717.03142.11447', 'Я.00100.00001'),
('718.03142.11447', 'Я.00100.00001'),
('Я.00100.00002', 'Я.00100.00002'),
('717.03142.11448', 'Я.00100.00002'),
('718.03142.11448', 'Я.00100.00002');

SELECT * FROM product_range;

SELECT id, name, model_cipher FROM main_product;

SELECT * FROM main_product;

SELECT main_assembly_cipher, main_product_cipher  FROM main_assembly_applicability;

SELECT * FROM assembly_applicability;

SELECT * FROM under_assembly_applicability;

SELECT * FROM detail_applicability;

SELECT * FROM tool_applicability;

SELECT * FROM total_tools;

SELECT * FROM raw_material;

SELECT * FROM tech_data;

SELECT * FROM tech_data_applicability;

SELECT * FROM product_range;

-- Для изготовления изделия ТМТ-1БЯ необходимы следующие сборки и детали:
SELECT 
main_product.name AS 'Название', 
main_product.model_cipher 'Модель',
main_assembly_applicability.main_assembly_cipher AS 'Главные сборки',
under_assembly_applicability.under_assembly_cipher AS 'Подсборки',
assembly_applicability.assembly_cipher AS 'Сборки',
detail_applicability.detail_cipher AS 'Деталь'
FROM main_product
JOIN main_assembly_applicability
ON model_cipher = main_product_cipher
LEFT JOIN under_assembly_applicability 
ON under_assembly_applicability.main_assembly_cipher = main_assembly_applicability.main_assembly_cipher 
LEFT JOIN assembly_applicability
ON assembly_applicability.under_assembly_cipher = under_assembly_applicability.under_assembly_cipher
JOIN detail_applicability
ON detail_applicability.applicability_cipher = main_product.model_cipher 	
OR detail_applicability.applicability_cipher = under_assembly_applicability.main_assembly_cipher
OR detail_applicability.applicability_cipher = assembly_applicability.under_assembly_cipher
WHERE main_product.id = 1
;

-- Из них, главных сборок:
SELECT 
main_product.name AS 'Название', 
main_product.model_cipher 'Модель',
COUNT(main_assembly_applicability.main_assembly_cipher) AS 'Главные сборки'
FROM main_product
JOIN main_assembly_applicability
WHERE main_product.id = 1
GROUP BY main_product.name, main_product.model_cipher 
;

-- Из них, подсборок:
SELECT 
main_product.name AS 'Название', 
main_product.model_cipher 'Модель',
COUNT(under_assembly_applicability.under_assembly_cipher) AS 'Подсборки'
FROM main_product
JOIN main_assembly_applicability
ON model_cipher = main_product_cipher
LEFT JOIN under_assembly_applicability 
ON under_assembly_applicability.main_assembly_cipher = main_assembly_applicability.main_assembly_cipher
WHERE main_product.id = 1
GROUP BY main_product.name, main_product.model_cipher 
;

-- Из них, сборок:
SELECT 
main_product.name AS 'Название', 
main_product.model_cipher 'Модель',
COUNT(assembly_applicability.assembly_cipher) AS 'Сборки'
FROM main_product
JOIN main_assembly_applicability
ON model_cipher = main_product_cipher
LEFT JOIN under_assembly_applicability 
ON under_assembly_applicability.main_assembly_cipher = main_assembly_applicability.main_assembly_cipher 
LEFT JOIN assembly_applicability
ON assembly_applicability.under_assembly_cipher = under_assembly_applicability.under_assembly_cipher
WHERE main_product.id = 1
GROUP BY main_product.name, main_product.model_cipher 
;


-- Необходимые инструменты и тех документация для изготовления того или иного продукта:
SELECT 
tool_applicability.cipher AS 'Применимость',
total_tools.name AS 'Имя инструмента',
total_tools.type_of_tool AS 'Тип инструмента',
tech_data_applicability.tech_cipher AS 'Документация',
tech_data.type_of AS 'Тип документации'
FROM total_tools
JOIN tool_applicability
ON total_tools.id = tool_applicability.tool_id
LEFT JOIN tech_data_applicability
ON tech_data_applicability.used_for_product = tool_applicability.cipher
LEFT JOIN tech_data
ON tech_data.tech_data_cipher = tech_data_applicability.tech_cipher 
;


-- Представление таблицы для пользователей прогрмаммы "Только чтение" не конфиденциальных даных.
CREATE OR REPLACE VIEW prr_vertical AS
SELECT name AS 'Название',
cipher AS 'Шифр',
type_of_product AS 'Тип'  
FROM product_range;


-- Представление таблицы для пользователей прогрмаммы "Только чтение" не конфиденциальных даных.
CREATE OR REPLACE VIEW tools_vertical AS c
SELECT 
name AS 'Наименование',
tool_brand AS 'Брэнд',
CASE 
	WHEN type_of_tool = 'RIG_TOOL' THEN 'Оснастка'
	WHEN type_of_tool = 'MACHINE' THEN 'Станок'
	WHEN type_of_tool = 'HAND_TOOL' THEN 'Ручной инструмент'
	WHEN type_of_tool = 'CUTTING_TOOL' THEN 'Режущий инструмент'
END AS 'Тип'
FROM total_tools;


ALTER TABLE product_range MODIFY COLUMN manufacturing_time_theor VARCHAR(100) DEFAULT NULL;

SHOW CREATE TABLE product_range;

DROP TRIGGER IF EXISTS mp_auto_fill_product_range;

-- Триггер для автоматического добавления в продакт рэйнж нового главного продукта
DROP TRIGGER IF EXISTS mp_auto_fill_product_range;

CREATE TRIGGER mp_auto_fill_product_range AFTER INSERT ON main_product 
FOR EACH ROW 
BEGIN
 INSERT INTO product_range (name, cipher, type_of_product) VALUES (NEW.name, NEW.model_cipher, 'MAIN PRODUCT');
END;

-- Триггер для автоматического добавления в продакт рэйнж новой главной сборки 
DROP TRIGGER IF EXISTS mp_auto_fill_product_range;
CREATE TRIGGER ma_auto_fill_product_range AFTER INSERT ON main_assembly
FOR EACH ROW
BEGIN 
	INSERT INTO product_range (name, cipher, type_of_product) VALUES (NEW.name, NEW.main_assembly_cipher, 'MAIN ASSEMBLY');
END;

-- Триггер для автоматического добавления в продакт рэйнж новой подсборки
DROP TRIGGER IF EXISTS mp_auto_fill_product_range;
CREATE TRIGGER ua_auto_fill_product_range AFTER INSERT ON under_assembly
FOR EACH ROW
BEGIN 
	INSERT INTO product_range (name, cipher, type_of_product) VALUES (NEW.name, NEW.under_assembly_cipher, 'UNDER ASSEMBLY');
END;

-- Триггер для автоматического добавления в продакт рэйнж новой сборки
DROP TRIGGER IF EXISTS assembly;
CREATE TRIGGER a_auto_fill_product_range AFTER INSERT ON assembly
FOR EACH ROW
BEGIN 
	INSERT INTO product_range (name, cipher, type_of_product) VALUES (NEW.name, NEW.assembly_cipher, 'ASSEMBLY');
END;

-- Триггер для автоматического добавления в продакт рэйнж новой детали
DROP TRIGGER IF EXISTS detail;
CREATE TRIGGER d_auto_fill_product_range AFTER INSERT ON detail 
FOR EACH ROW
BEGIN 
	INSERT INTO product_range (name, cipher, type_of_product) VALUES (NEW.name, NEW.detail_cipher, 'DETAIL');
END;




