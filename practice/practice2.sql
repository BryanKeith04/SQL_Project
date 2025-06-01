create schema universitas;

create table dosen (
id_dosen varchar(15) primary key,
nama_dosen varchar(50)not null,
pendidikan varchar(10) not null);

create table mahasiswa (
npm char(10) primary key,
nama_mahasiswa varchar(50) not null,
tahun_masuk int not null,
id_pembimbing varchar(15),
foreign key (id_pembimbing) references dosen(id_dosen) on delete restrict on update cascade);

create table mata_kuliah (
id_mk char(10) primary key,
nama_mk varchar(30) not null,
kredit int not null,
id_dosen varchar(15),
foreign key (id_dosen) references dosen(id_dosen) on delete restrict on update cascade);

create table mata_kuliah_diambil (
npm char(10),
id_mk char(10),
nilai numeric(5,2),
primary key(npm, id_mk),
foreign key (npm) references mahasiswa(npm) on delete restrict on update cascade,
foreign key (id_mk) references mata_kuliah(id_mk) on delete restrict on update cascade);

select *
from dosen;
select *
from mahasiswa;
select *
from mata_kuliah;
select *
from mata_kuliah_diambil;

alter table mahasiswa
add column
(email varchar(50) unique);

select *
from mahasiswa;

insert into mahasiswa values ('2106637366', 'kathleen', 2019, null, null);

update mahasiswa
set email = 'kathleen@example.com'
where npm = '2106637366';

delete from mahasiswa
where tahun_masuk = '2019';
