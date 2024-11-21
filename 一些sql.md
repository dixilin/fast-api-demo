```sql
-- create database practice;

show databases;

use practice;
show tables;

create table tb1(
	id int,
	name varchar(10),
	age int
)

-- DROP TABLE practice.tb1;

create table tb2(
	id int primary key,
	name varchar(100),
	age int
)

create table tb3(
	id int not null auto_increment primary key,
	name varchar(100),
	age int
)
ALTER TABLE practice.tb3 MODIFY COLUMN name varchar(20) NULL;
ALTER TABLE practice.tb3 ADD phone varchar(20) NULL;
ALTER TABLE practice.tb3 CHANGE phone phone_number varchar(20) NULL;

-- ALTER TABLE practice.tb3 DROP COLUMN phone_number;

insert into practice.tb3(name, age, phone_number) values('Dicky', 18, 17666666666);
insert into practice.tb3(name, age, phone_number) values('Abby', 20, 13333333333);
insert into practice.tb3(name, age, phone_number) values('Tom', 21, 13333333334),('Mary', 22, 13333333331);

insert into practice.tb1 values(1, 'a', 18);
update practice.tb1 set name=concat(name,'666'),age=19 where id=1;
delete from practice.tb1 where id='1';

select * from practice.tb3;
select id,name from practice.tb3;

create table users(
	id int not null auto_increment primary key,
	username varchar(20),
	password varchar(20)
)

create table students(
	id int not null auto_increment primary key,
	name varchar(32) not null,
	password varchar(64) not null,
	gender enum('male', 'female') not null,
	email varchar(64),
	amount decimal(10,2) not null default 0,
	create_time datetime DEFAULT CURRENT_TIMESTAMP,
	update_time datetime DEFAULT CURRENT_TIMESTAMP
)


insert into practice.students(name, password, gender, amount) values('A', 123456, 'male', 1000);
insert into practice.students(name, password, gender, amount) values('B', 123456, 'female', 1100);
insert into practice.students(name, password, gender, amount) values('C', 123456, 'female', 1200);
insert into practice.students(name, password, gender, amount) values('D', 123456, 'male', 1300);
insert into practice.students(name, password, gender, amount) values('E', 123456, 'male', 1400);

update practice.students set gender='male' where id > 2
update practice.students set amount= amount + 1000;
delete from practice.students where gender='male'



```

```sql
# 条件
use db1;
create table depart(
	id int auto_increment primary key,
	title varchar(20) not null
);

insert into db1.depart(title) values('前端');
insert into db1.depart(title) values('后端');
insert into db1.depart(title) values('测试');
insert into db1.depart(title) values('产品');
insert into db1.depart(title) values('ui');

create table info(
	id int auto_increment primary key,
	name varchar(20) not null,
	age tinyint not null,
	email varchar(32) not null,
	depart_id int,
	foreign key (depart_id) references db1.depart(id) 
);
-- 外键也可以额外设置 	
-- alter table db1.info add foreign key (depart_id) references db1.depart(id);


insert into db1.info(name,age,email, depart_id) values('Dicky', 20, '1@qq.com', 1);
insert into db1.info(name,age,email, depart_id) values('Tom', 20, '2@qq.com', 2);
insert into db1.info(name,age,email, depart_id) values('Mary', 21, '3@qq.com', 3);
insert into db1.info(name,age,email, depart_id) values('Jack', 22, '4@qq.com', 4);
insert into db1.info(name,age,email, depart_id) values('Mark', 21, '5@qq.com', 4);
insert into db1.info(name,age,email, depart_id) values('Jane', 23, '5@qq.com', 5);
insert into db1.info(name,age,email, depart_id) values('KangKang', 33, '8@qq.com', 1);
insert into db1.info(name,age,email, depart_id) values('Michael', 32, '9@qq.com', 1);
insert into db1.info(name,age,email, depart_id) values('Maria', 41, '10@qq.com', 2);

select * from db1.info where id between 2 and 4;
select * from db1.info where depart_id = 4 and name='Jack';
select * from db1.info where depart_id = 4 or name='Mark';
select * from db1.info where (depart_id = 4 and name='Mark') or name='Jane';
select * from db1.info where id in (1,2,3);

-- not exists 用于判断不存在
select * from db1.info where not exists (select * from db1.depart where id=6);
select * from (select * from db1.info where id>2) as T where T.age > 21;


# 通配符
-- 模糊搜索，数量少采用
select * from db1.info where name like "%c%";
select * from db1.info where name like "%y";
select * from db1.info where name like "J%";
select * from db1.info where email like "_@qq.com";
select * from db1.info where name like "J_ne";


# 映射

select id, name as NM from db1.info;

-- 效率低，用的少
select id, name ,(select title from db1.depart where db1.depart.id=info.depart_id) as depart_name from db1.info;

select id,name, case depart_id when 1 then '最牛的部门' else '其他的垃圾部门' end bm from db1.info;


# 排序、limit

select * from db1.info order by age desc;
select * from db1.info order by age asc;
-- 年龄降序，如果age相等则按照部门id降序排列
select * from db1.info order by age desc, depart_id desc; 

select * from db1.info where age > 20 order by age desc, depart_id desc; 

-- 分页
select * from db1.info where age > 20 order by age desc, depart_id desc limit 2 offset 0; 
select * from db1.info where age > 20 order by age desc, depart_id desc limit 2 offset 2;

-- 分组
select age,count(1) from db1.info group by age;
select depart_id,count(1) from db1.info group by depart_id;
-- 使用group by聚合条件要用having
select depart_id,count(1) from db1.info group by depart_id having count(1) >= 2;

-- 优先级 ：left join > where > group by > having > order by > limit


# 连表
-- 主表 left outer join 从表 on 主表.x = 从表.id，可以简写：left join，左连接，有连接为right join，主从表对调	
-- 展示用户信息和部门名称
select db1.info.id,db1.info.name,db1.info.age,db1.depart.title as depart_name from db1.info left outer join db1.depart on db1.info.depart_id = db1.depart.id 

-- 内连接 inner join，没有关联的数据不展示

-- 联合
select id, title from db1.depart union select id, name from db1.info;

```


```sql
use db;
# 创建数据
insert into db.class(caption) values('三年一班');
insert into db.class(caption) values('一年一班');
insert into db.class(caption) values('三年二班');

insert into db.student(name, gender, class_id) values('zs', 'male', 10000);
insert into db.student(name, gender, class_id) values('ls', 'female', 10001);
insert into db.student(name, gender, class_id) values('ww', 'male', 10002);
insert into db.student(name, gender, class_id) values('ww', 'female', 10001);

insert into db.teacher(name) values('波多');
insert into db.teacher(name) values('小泽');
insert into db.teacher(name) values('松岛');

insert into db.course(course_name, tearch_id) values('生物', 1);
insert into db.course(course_name, tearch_id) values('户外', 2);
insert into db.course(course_name, tearch_id) values('家政', 3);

insert into db.score(course_id, student_id,score) values(1, 10000, 60);
insert into db.score(course_id, student_id,score) values(2, 10000, 70);
insert into db.score(course_id, student_id,score) values(3, 10000, 88);
insert into db.score(course_id, student_id,score) values(1, 10001, 98);
insert into db.score(course_id, student_id,score) values(2, 10001, 99);
insert into db.score(course_id, student_id,score) values(3, 10001, 87);
insert into db.score(course_id, student_id,score) values(1, 10002, 45);
insert into db.score(course_id, student_id,score) values(2, 10002, 55);
insert into db.score(course_id, student_id,score) values(3, 10002, 63);

-- 查询波xx，小xx老师个数
select count(1) from db.teacher where name like '波%';
select name, count(1) from db.teacher group by name having name like '小%';

-- 查询z..的学生名单
select name,gender,caption from db.student left join db.class on db.student.class_id = db.class.cid where name like 'z%';

-- 性别统计
select gender, count(1) from db.student group by gender;

-- 学生重名统计
select name, count(1) from db.student group by name having count(1) > 1;

-- 一年一班的所有学生
select * from db.student where class_id = (select cid from db.class where caption='一年一班');

-- 连表，班级名称和学生人数
select caption, count(1) from (select * from db.student left join db.class on db.student.class_id = db.class.cid) as T group by caption;

-- 成绩小于60的学生姓名、性别、学号、成绩、课程
select 
	sid,
	name,
	gender,
	score,
	course_name 
from
	db.score 
	left join db.student on db.student.sid = db.score.student_id
	left join db.course on db.course.id = db.score.course_id 
where score < 60;
	
	
-- 选生物课的所有学生id、姓名、成绩
select student_id,name,score from db.score left join db.student on db.student.sid = db.score.student_id where course_id = 1;

-- 选生物课的且低于60分的学生id、姓名、成绩
select student_id,name,score from db.score left join db.student on db.student.sid = db.score.student_id where course_id = 1 and score < 60;
	
```