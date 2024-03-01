drop table if exists book;
drop table if exists author;
drop table if exists book_author;

create table book
(
	book_id int primary key,
	title text not null,
	isbn text not null
);

create table author
(
	author_id int primary key,
	full_name text not null,
	rating real
);

create table book_author 
(
	book_id int references book(book_id),
	author_id int references author(author_id),	
	constraint book_author_pkey primary key (book_id, author_id)
);