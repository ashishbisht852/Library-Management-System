-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books
Values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
-- Task 2: Update an Existing Member's Address----

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

- Task 3:--- Delete a Record from the Issued Status Table--- 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
where issued_Id ='IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

---Task 5: List Members Who Have Issued More Than One Book----
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
    ist.issued_emp_id,
     e.emp_name,COUNT(ist.issued_id)
   
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
GROUP BY 1, 2
HAVING COUNT(ist.issued_id) > 1

----- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
 CREATE TABLE book_cnts
 AS
 select  b.isbn,
    b.book_title,count(ist.issued_id)
	from books AS b
	join issued_status as ist
	ON ist.issued_book_isbn = b.isbn
	group by 1 , 2
-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'Classic'

    
-- Task 8: Find Total Rental Income by Category:


SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

---TASK 9 List Members Who Registered in the Last 180 Days----

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'    

-- task 10 List Employees with Their Branch Manager's Name and their branch details:----
SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN employees as e2
ON b.manager_id = e2.emp_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven

-- Task 12: Retrieve the List of Books Not Yet Returned----

SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL












