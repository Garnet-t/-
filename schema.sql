
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS payment_schedule CASCADE;
DROP TABLE IF EXISTS loan CASCADE;
DROP TABLE IF EXISTS loan_product CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS person CASCADE;


CREATE TABLE person (
    person_id  SERIAL PRIMARY KEY,
    full_name  VARCHAR(150) NOT NULL,
    passport   VARCHAR(20)  NOT NULL UNIQUE,
    phone      VARCHAR(20)  UNIQUE,
    birth_date DATE         NOT NULL,
	CHECK (EXTRACT(YEAR FROM age(birth_date)) >= 18)
);

CREATE TABLE client (
    client_id     SERIAL PRIMARY KEY,
    person_id     INT  NOT NULL UNIQUE
                  REFERENCES person(person_id) ON DELETE RESTRICT,
    registered_at DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    person_id   INT  NOT NULL UNIQUE
                REFERENCES person(person_id) ON DELETE RESTRICT,
    hired_at    DATE NOT NULL DEFAULT CURRENT_DATE,
    salary      NUMERIC(10,2) NOT NULL CHECK (salary > 0)
);


CREATE TABLE loan (
    loan_id         SERIAL PRIMARY KEY,
    contract_number VARCHAR(30) NOT NULL UNIQUE,
    client_id       INT NOT NULL REFERENCES client(client_id)     ON DELETE RESTRICT,
    employee_id     INT NOT NULL REFERENCES employee(employee_id) ON DELETE RESTRICT,
    product_type    VARCHAR(20) NOT NULL
                    CHECK (product_type IN ('consumer', 'mortgage', 'installment')),
    amount          NUMERIC(14,2) NOT NULL CHECK (amount > 0),
    rate            NUMERIC(5,2)  NOT NULL CHECK (rate BETWEEN 0 AND 40),
    term_months     INT NOT NULL CHECK (term_months >= 6),
    issue_date      DATE NOT NULL DEFAULT CURRENT_DATE,
    status          VARCHAR(10) NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active', 'closed')),
 

    CONSTRAINT loan_product_rules CHECK (
        (product_type = 'consumer'  AND rate <= 25 AND term_months BETWEEN 6  AND 120) OR
        (product_type = 'mortgage'  AND rate <= 40 AND term_months BETWEEN 60 AND 300) OR
        (product_type = 'installment' AND rate = 0   AND term_months = 6)
    )
);


CREATE TABLE payment_schedule (
    schedule_id SERIAL PRIMARY KEY,
    loan_id     INT NOT NULL REFERENCES loan(loan_id) ON DELETE CASCADE,
    payment_no  INT NOT NULL CHECK (payment_no > 0),
    due_date    DATE NOT NULL,
    amount_due  NUMERIC(14,2) NOT NULL CHECK (amount_due > 0),
    UNIQUE (loan_id, payment_no)         
);


CREATE TABLE payment (
    payment_id  SERIAL PRIMARY KEY,
    schedule_id INT NOT NULL UNIQUE
                REFERENCES payment_schedule(schedule_id) ON DELETE RESTRICT,
    paid_at     DATE NOT NULL DEFAULT CURRENT_DATE,
    amount      NUMERIC(14,2) NOT NULL CHECK (amount > 0)
);
