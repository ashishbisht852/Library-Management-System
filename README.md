# Library-Management-System
My SQL project where I built a Library Management System and practiced database creation, queries, and procedures.

# Library Management System using SQL

## Project Overview

This is my Library Management System project built using SQL.  
In this project, I created a database and performed different SQL operations like creating tables, inserting data, updating records, and writing advanced queries.

Database name: `library_db`

---

## Database Structure

I created the following tables:

- branch  
- employees  
- members  
- books  
- issued_status  
- return_status  

---

## Database Creation

```sql
CREATE DATABASE library_db;
```

---

## Tables Created

```sql
CREATE TABLE branch(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);

CREATE TABLE employees(
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(30),
    position VARCHAR(30),
    salary DECIMAL(10,2),
    branch_id VARCHAR(10),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE members(
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(30),
    reg_date DATE
);

CREATE TABLE books(
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10,2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(30)
);

CREATE TABLE issued_status(
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(30),
    issued_book_name VARCHAR(80),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(10),
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn)
);

CREATE TABLE return_status(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(30),
    return_book_name VARCHAR(80),
    return_date DATE,
    return_book_isbn VARCHAR(50),
    FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
```

---

## Basic SQL Operations (CRUD)

### 1. Insert a New Book

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

### 2. Update Member Address

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

### 3. Delete Issued Record

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

---

## Queries and Analysis

### 4. Books Issued by a Specific Employee

```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
```

### 5. Members Who Issued More Than One Book

```sql
SELECT issued_emp_id, COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;
```

---

## CTAS (Create Table As Select)

### 6. Book Issue Count Table

```sql
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status ist
JOIN books b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

---

## More SQL Tasks

### 7. Books in a Specific Category

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

### 8. Total Rental Income by Category

```sql
SELECT b.category,
       SUM(b.rental_price),
       COUNT(*)
FROM issued_status ist
JOIN books b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;
```

### 9. Members Registered in Last 180 Days

```sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

### 10. Employees with Branch and Manager Details

```sql
SELECT e1.emp_id,
       e1.emp_name,
       e1.position,
       e1.salary,
       b.*,
       e2.emp_name AS manager
FROM employees e1
JOIN branch b ON e1.branch_id = b.branch_id
JOIN employees e2 ON e2.emp_id = b.manager_id;
```

---

### 11. Create Table for Expensive Books

```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;
```

---

### 12. Books Not Yet Returned

```sql
SELECT *
FROM issued_status ist
LEFT JOIN return_status rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```

---

### 13. Members with Overdue Books (More than 30 Days)

```sql
SELECT ist.issued_member_id,
       m.member_name,
       bk.book_title,
       ist.issued_date,
       CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status ist
JOIN members m ON m.member_id = ist.issued_member_id
JOIN books bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;
```

---

### 14. Procedure to Update Book Status on Return

```sql
CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(10),
    p_issued_id VARCHAR(10),
    p_book_quality VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_isbn VARCHAR(50);
BEGIN
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT issued_book_isbn
    INTO v_isbn
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;
END;
$$;
```

---

### 15. Branch Performance Report

```sql
CREATE TABLE branch_reports AS
SELECT b.branch_id,
       b.manager_id,
       COUNT(ist.issued_id) AS number_book_issued,
       COUNT(rs.return_id) AS number_of_book_return,
       SUM(bk.rental_price) AS total_revenue
FROM issued_status ist
JOIN employees e ON e.emp_id = ist.issued_emp_id
JOIN branch b ON e.branch_id = b.branch_id
LEFT JOIN return_status rs ON rs.issued_id = ist.issued_id
JOIN books bk ON ist.issued_book_isbn = bk.isbn
GROUP BY 1,2;
```

---

### 16. Active Members (Last 2 Months)

```sql
CREATE TABLE active_members AS
SELECT *
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month'
);
```

---

### 17. Top Employees by Books Issued

```sql
SELECT e.emp_name,
       b.branch_id,
       COUNT(ist.issued_id) AS no_book_issued
FROM issued_status ist
JOIN employees e ON e.emp_id = ist.issued_emp_id
JOIN branch b ON e.branch_id = b.branch_id
GROUP BY 1,2;
```

---

## Conclusion

In this project, I learned:

- Creating and managing databases  
- Writing SQL queries  
- Using JOIN, GROUP BY, HAVING  
- Creating tables using CTAS  
- Writing stored procedures  

This project helped me improve my SQL skills and understand how a real library system works using a database.
