


![library](https://github.com/user-attachments/assets/dfa4a56d-a813-41ca-9984-0757b241dee3)

Go to: https://dbdiagram.io/d/library-66c80a26a346f9518cdbb92c
## SQL Queries

### 1. List all books along with their authors and publishers. Sort the list by the number of available copies in descending order.
```sql
SELECT 
    b.book_id,
    b.book_name,
    p.name_publisher,
    a.author_name,
    b.available_copies
FROM books b
INNER JOIN publishers p USING (publisher_id)
INNER JOIN author_books ab USING (book_id)
INNER JOIN authors a USING (author_id)
ORDER BY b.available_copies DESC;
```
### 2.Find the member with the highest total number of borrows and list the details of their borrow history, including the book titles and return dates.
```sql
select b.book_name, br.return_date
from users u
inner join members m using (user_id)
inner join borrows br using (member_id)
inner join books b using (book_id)
where 
	m.member_id=(
		select b1.member_id
		from borrows b1
		group by member_id
		order by count(*) desc
		limit 1	
	)
```
### 3. List all books that are overdue for return, along with their categories and the total number of fines issued. Only display books with 5 or more fines
```sql
select 
 	b.book_id,
    b.book_name,
    c.category_name,
    count(f.fines_id) AS total_fines
from categories c
inner join categories_books ca using (category_id)
inner join books b using (book_id)
inner join borrows br using (book_id)
inner join fines f using (borrow_id)
where br.status='OVERDUE'
group by b.book_id,c.category_name
having count(f.fines_id) >= 2
```
### 4. Query the list of publishers and the number of books they have published. Sort the list by the number of books in descending order, showing only publishers with more than 5 books.
```sql
select
    p.publisher_id,
    p.name_publiser,
    count(b.book_id) AS number_of_books
from publishers p
left join books b ON p.publisher_id = b.publisher_id
group by p.publisher_id, p.name_publiser
having count(b.book_id) > 5
order by number_of_books DESC;
```
### 5. List all borrow transactions from the most recent month, along with the member's name, the borrow details, the fines they incurred, and the due date. Sort the results by the due date.
```sql
select  
	br.borrow_id,
    m.member_id,
    u.firstname AS member_firstname,
    u.lastname AS member_lastname,
    b.book_name,
    br.borrow_date,
    br.due_date,
    f.amount AS fine_amount
from users u 
inner join members m using(user_id)
inner join borrows br using (member_id)
inner join books b using (book_id)
left join fines f using (borrow_id)
where 
	extract(YEAR FROM br.borrow_date) = extract(YEAR from CURRENT_DATE)
	AND extract(month from br.borrow_date) = extract(month from current_date)
order by br.due_date
```
### 6. Find books whose total copies are higher than the average total copies of all books within their category. List the book titles, total copies, and category names.
```sql
select b.book_name, b.total_copy, c.category_name
from categories c
inner join categories_books cb using (category_id)
inner join books b using (book_id)
where b.total_copy > (
	select avg(b2.total_copy)
	from books b2
	inner join categories_books cb2 using (book_id)
	where cb2.category_id=cb.category_id
)
```
### 7. List all employees and the total number of borrow transactions they have handled. Show only employees who have handled more than 10 transactions, sorted by the total number of borrows in descending order.
```sql
select e.username, count(b.borrow_id) as total_borrows
from borrows b
inner join employees e using (employee_id)
group by b.employee_id, e.username
having count(b.borrow_id)>10
order by total_borrows desc
```
### 8. List members who have paid fines for overdue books at least 3 times. Display their names, the total amount paid, and the number of overdue borrows they had.
```sql
select u.firstname, sum(f.amount) as total_amount, count(f.fines_id)
from users u
inner join members m using (user_id)
inner join borrows br using(member_id)
inner join fines f using (borrow_id)
group by br.member_id, u.firstname
having count(f.fines_id)> 3
```
### 9. List all books along with their categories, the total number of borrows, and the average fine amount for each book. Only show books that have been borrowed 5 or more times, and sort by the number of borrows in descending order.
```sql
select b.book_id, b.book_name, count(br.borrow_id) as sum_borrow, avg(f.amount) as avg_amount
from categories c 
inner join categories_books cb using (category_id)
inner join books b using (book_id)
left join borrows br using (book_id)
left join fines f using(borrow_id)
group by b.book_id, b.book_name
having count(br.borrow_id) > 5
```
### 10. Find members who have never returned a borrowed book late (no overdue status) and display their member card number, name, and contact information.
```sql
select m.member_card_number, u.firstname||' '|| u.lastname as fullname
from users u
inner join members m using (user_id)
inner join borrows b using (member_id)
where m.member_id not in (
	select distinct b.member_id
	from borrows b
	where b.status='OVERDUE'
)
```
### 11. List all books with a borrow status of 'OVERDUE', along with member details, the fines they have incurred, and the employee who handled the borrow transaction. Sort the results by the fine amount in descending order.

```sql
select
    b.book_name,
    m.member_id,
    u_m.firstname as member_firstname,
    u_m.lastname as member_lastname,
    e.employee_id,
    u_e.firstname as employee_firstname,
    u_e.lastname as employee_lastname,
    f.amount as fine_amount
from borrows br
inner join books b using(book_id) 
inner join members m using(member_id) 
inner join users u_m using(user_id)
inner join employees e using(employee_id) 
inner join users u_e on e.user_id = u_e.user_id 
inner join fines f using(borrow_id) 
where br.status = 'OVERDUE'
order by f.amount desc;
```
### 12. Query the list of authors along with their books and the total number of borrows for each book. Only show authors who have written 2 or more books and sort by the total number of borrows in descending order.

```sql
select 
	a.author_id, 
	a.author_name,
	b.book_name, 
	count(br.book_id) as total_borrows
from authors a
inner join author_books ab using (author_id)
inner join books b using(book_id)
left join borrows br using (book_id)
where a.author_id in (
	select ab.author_id
	from author_books ab
	group by ab.author_id
	having count(ab.book_id) >=2 
)
group by a.author_id, a.author_name,b.book_name
order by count(br.book_id) desc
```
### 13. List member names and the total number of books they have borrowed within a specific category, sorted by the total number of borrows in descending order.
```sql
select  u.firstname || ' ' || u.lastname as fullname, count(br.borrow_id)
from users u
inner join members m using (user_id)
inner join borrows br using (member_id)
inner join books b using (book_id)
inner join categories_books cb using (book_id)
where cb.category_id=2
group by u.firstname, u.lastname
order by count(br.borrow_id) desc
```
### 14. Find books with an available copy count lower than the average available copy count of all books. List the book titles, available copies, and publisher names.
```sql
select 
	books.book_name, 
	books.available_copies, 
	publishers.name_publiser
from books 
inner join publishers using (publisher_id)
where books.available_copies < (
	select avg(available_copies) 
	from books
)
```
### 15. List all borrow transactions along with the fines incurred, member details, and employee details. Only display transactions with fines greater than $10 and sort by the fine amount.
```sql
select 
	f.fines_id, 
	m.member_id, 
	e.employee_id, 
	f.amount
from members m 
inner join borrows br using (member_id)
inner join employees e using (employee_id)
inner join fines f using (borrow_id)
where f.amount > 10
order by f.amount
```
