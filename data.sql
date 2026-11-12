
TRUNCATE payment, payment_schedule, loan, employee, client, person RESTART IDENTITY CASCADE;

INSERT INTO person (full_name, passport, phone, birth_date) VALUES
('Петров Иван Алексеевич',       '4672 383773', '+79851650791',   '1985-03-12'),  
('Ямская Евгения Сергеевна',     '4399 938318', '+79017586602',   '1992-07-25'),  
('Первомайский Олег Дмитриевич', '4142 978362', '+7926896469',    '1978-11-22'),  
('Илуб Виктор Александрович',    '4504 597181', '+7980288674555', '1988-01-30'),  
('Новиков Артём Павлович',       '4505 555555', '+79038469085',   '2007-05-10'); 


INSERT INTO client (person_id, registered_at) VALUES
(1, '2019-01-10'),   
(2, '2023-12-07'),   
(4, '2025-04-05'),   
(5, '2026-08-01');   


INSERT INTO employee (person_id, hired_at, salary) VALUES
(3, '2020-06-01', 85000.00),   
(4, '2022-09-15', 78000.00);   


INSERT INTO loan (contract_number, client_id, employee_id, product_type, amount, rate, term_months, issue_date) VALUES
('CR-2026-001', 1, 1, 'consumer',     120000.00, 18.00, 12, '2026-01-15'),  
('MT-2026-001', 2, 2, 'mortgage',    3000000.00, 15.00, 60, '2026-03-01'),  
('IN-2026-001', 3, 1, 'installment',   60000.00,  0.00,  6, '2026-04-01'),  
('CR-2026-002', 4, 2, 'consumer',      80000.00, 10.00,  6, '2026-10-20');  


INSERT INTO payment_schedule (loan_id, payment_no, due_date, amount_due)
SELECT l.loan_id,   
       n,
       l.issue_date + make_interval(months => n),
       ROUND(l.amount * (1 + l.rate / 100 * l.term_months / 12.0) / l.term_months, 2)
FROM loan l, generate_series(1, l.term_months) AS n;


INSERT INTO payment (schedule_id, paid_at, amount)
SELECT s.schedule_id, s.due_date, s.amount_due
FROM payment_schedule s
WHERE (s.loan_id = 1 AND s.payment_no <= 3)   
   OR (s.loan_id = 2 AND s.payment_no = 1)    
   OR (s.loan_id = 3);                        

UPDATE loan SET status = 'closed' WHERE loan_id = 3;


SELECT (SELECT COUNT(*) FROM person)           AS person,
       (SELECT COUNT(*) FROM client)           AS client,
       (SELECT COUNT(*) FROM employee)         AS employee,
       (SELECT COUNT(*) FROM loan)             AS loan,
       (SELECT COUNT(*) FROM payment_schedule) AS schedule,
       (SELECT COUNT(*) FROM payment)          AS payment;
