

INSERT INTO person (full_name, passport, birth_date)
VALUES ('Дарвин Иван', '4672 383773', '1990-01-01');

--ERROR:  повторяющееся значение ключа нарушает ограничение уникальности "person_passport_key"
--Ключ "(passport)=(4672 383773)" уже существует. 

--ОШИБКА:  повторяющееся значение ключа нарушает ограничение уникальности "person_passport_key"
--SQL state: 23505
--Detail: Ключ "(passport)=(4672 383773)" уже существует.

-- нет имени
INSERT INTO person (passport, birth_date)
VALUES ('4599 000002', '1990-01-01');

--ERROR:  значение NULL в столбце "full_name" отношения "person" нарушает ограничение NOT NULL
--Ошибочная строка содержит (7, null, 4599 000002, null, 1990-01-01). 

--ОШИБКА:  значение NULL в столбце "full_name" отношения "person" нарушает ограничение NOT NULL
--SQL state: 23502
--Detail: Ошибочная строка содержит (7, null, 4599 000002, null, 1990-01-01).

-- < 18 лет 
INSERT INTO person (full_name, passport, birth_date)
VALUES ('Малышев Петя', '4599 000001', '2015-01-01');

-- ставка кредита 30 максимум 25
INSERT INTO loan (contract_number, client_id, employee_id, product_type, amount, rate, term_months, issue_date)
VALUES ('CR-TEST-1', 1, 1, 'consumer', 100000, 30, 12, '2026-11-03');

-- ипотека на 30 лет вместо 25 term_months
INSERT INTO loan (contract_number, client_id, employee_id, product_type, amount, rate, term_months, issue_date)
VALUES ('MT-TEST-1', 2, 1, 'mortgage', 3000000, 10, 360, '2026-11-03');

-- ставка по кредиту 50%
UPDATE loan SET rate = 50 WHERE loan_id = 1;

-- FK у меня нет клиента 1000 номером
INSERT INTO loan (contract_number, client_id, employee_id, product_type, amount, rate, term_months, issue_date)
VALUES ('CR-TEST-2', 1000, 1, 'consumer', 100000, 10, 12, '2026-11-03');

-- уже есть  составной UNIQUE () первый пункт жоговора уже есть 
INSERT INTO payment_schedule (loan_id, payment_no, due_date, amount_due)
VALUES (1, 1, '2027-01-01', 1000);

-- повторная оплата рассрочки
INSERT INTO payment (schedule_id, paid_at, amount)
SELECT schedule_id, CURRENT_DATE, 10000
FROM payment_schedule WHERE loan_id = 3 AND payment_no = 1;

-- нельзя удалить клиента у которого есть договоры неоплаченные
DELETE FROM client WHERE client_id = 1;

