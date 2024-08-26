CREATE TABLE "Member" (
  "member_id" integer PRIMARY KEY,
  "member_card_number" varchar,
  "firstname" varchar,
  "lastname" varchar,
  "email" varchar,
  "phone" varchar,
  "address" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Book" (
  "book_id" integer PRIMARY KEY,
  "author_id" integer,
  "category_id" integer,
  "book_name" varchar,
  "author" varchar,
  "published_year" integer,
  "deposit" float,
  "total_copie" interger,
  "available_copies" integer,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Borrows" (
  "brorrow_id" integer PRIMARY KEY,
  "user_id" integer,
  "book_id" integer,
  "borrow_date" date,
  "due_date" date,
  "employee_id" integer,
  "return_date" date,
  "status" "enum(BRORROWING,PAID,OVERDUE )"
);

CREATE TABLE "Fines" (
  "fines_id" integer PRIMARY KEY,
  "user_id" integer,
  "brorrow_id" integer,
  "amount" float,
  "fine_date" date,
  "status" enum(unpaid,paid),
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Author" (
  "author_id" integer PRIMARY KEY
);

CREATE TABLE "Author_Book" (
  "author_id" integer,
  "book_id" integer,
  PRIMARY KEY ("author_id", "book_id")
);

CREATE TABLE "Publisher" (
  "publisher_id" integer PRIMARY KEY,
  "name_publiser" varchar,
  "address" varchar,
  "phone" varchar
);

CREATE TABLE "Categories" (
  "category_id" integer PRIMARY KEY,
  "name_category" varchar
);

CREATE TABLE "Employee" (
  "employee_id" integer PRIMARY KEY,
  "username" varchar,
  "password" varchar,
  "firstname" varchar,
  "lastname" varchar,
  "email" varchar,
  "phone" varchar,
  "address" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

ALTER TABLE "Borrows" ADD FOREIGN KEY ("user_id") REFERENCES "Member" ("member_id");

ALTER TABLE "Borrows" ADD FOREIGN KEY ("book_id") REFERENCES "Book" ("book_id");

ALTER TABLE "Fines" ADD FOREIGN KEY ("fines_id") REFERENCES "Member" ("member_id");

ALTER TABLE "Fines" ADD FOREIGN KEY ("fines_id") REFERENCES "Borrows" ("book_id");

ALTER TABLE "Book" ADD FOREIGN KEY ("author_id") REFERENCES "Categories" ("category_id");

ALTER TABLE "Book" ADD FOREIGN KEY ("author_id") REFERENCES "Publisher" ("publisher_id");

ALTER TABLE "Author_Book" ADD FOREIGN KEY ("author_id") REFERENCES "Author" ("author_id");

ALTER TABLE "Author_Book" ADD FOREIGN KEY ("book_id") REFERENCES "Book" ("book_id");

ALTER TABLE "Borrows" ADD FOREIGN KEY ("employee_id") REFERENCES "Employee" ("employee_id");
