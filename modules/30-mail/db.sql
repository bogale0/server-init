use mail;
create table domains (
    id int auto_increment primary key,
    domain varchar(189) unique not null
);
create table users (
    id int auto_increment primary key,
    username varchar(64) not null,
    password varchar(255) not null,
    domain_id int not null,
    unique (username, domain_id),
    foreign key (domain_id) references domains(id) on delete cascade
);
create table aliases (
    id int auto_increment primary key,
    username varchar(64) not null,
    domain_id int not null,
    dest_user_id int not null,
    unique (username, domain_id),
    foreign key (domain_id) references domains(id) on delete cascade,
    foreign key (dest_user_id) references users(id) on delete cascade
);
