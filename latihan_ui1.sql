-- Tampilkan email, nama depan, dan nama organisasi untuk member yang memiliki
-- email dengan akhiran '@gmail.com’ dan merupakan anggota dari sebuah organisasi.
-- Urutkan hasil berdasarkan nama depan sesuai abjad.
select *
from anggota;
select *
from `member`;

select a.email_member, nama_depan, nama_org
from anggota a
join `member` me
on a.email_member=me.email_member
where a.email_member like '%@gmail.com%';





-- Tampilkan nama organisasi, serta prefix dan nama depan dari member
-- yang memiliki peran sebagai ‘Owner’ dari organisasi tersebut.
select *
from `member`;
select *
from anggota;

select a.nama_org, m.prefix, m.nama_depan
from anggota a
join `member` m
on a.email_member=m.email_member
where a.nama_peran = 'Owner';





-- Tampilkan nama depan, no HP (apabila lebih dari satu, dipisahkan dengan koma), dan
-- kota/kabupaten dari alamat tempat tinggal (alamat dengan jenis ‘Alamat tempat
-- tinggal’) untuk member yang memiliki prefix ‘Dr.’
select *
from no_hp_member;
select *
from alamat;
select *
from `member`;

select m.nama_depan, group_concat(distinct nhm.no_hp separator ', ') no_hp, a.kota_kabupaten
from `member` m
join alamat a
on m.email_member=a.email_member
join no_hp_member nhm
on m.email_member=nhm.email_member
where m.prefix = 'Dr.' and
a.jenis = 'Alamat tempat tinggal'
group by nama_depan, a.kota_kabupaten;





-- Tampilkan email dan nama depan member yang belum pernah melakukan
-- pembelian pada rentang waktu 10 Maret 2023 hingga 10 April 2023 (inclusive).
-- Urutkan berdasarkan email sesuai abjad.
select *
from `member`;
select *
from pembelian
order by tanggal_bayar;

select email_member, nama_depan
from `member`
where email_member not in
(select email_member
from pembelian
where tanggal_bayar between '2023-03-10' and '2023-04-10')
order by email_member;





-- Tampilkan nomor akun, nama organisasi, nama bank, pemegang akun, serta nama
-- yang disimpan pada pemegang akun tersebut. Untuk pemegang akun individu, nama
-- depan dan nama belakang digabung, contoh: ‘John Doe’.
-- (tips: dapat menggunakan Conditional Expression_
select *
from individu;
select *
from informasi_keuangan;

select ik.nomor_akun, ik.nama_organisasi, ik.nama_bank, ik.pemegang_akun,
case
	when pemegang_akun = 'Individu' then concat(i.nama_depan,' ',i.nama_belakang)
    when pemegang_akun = 'Perusahaan' then nama_organisasi
end nama_pemegang_akun
from informasi_keuangan ik
left join individu i
on ik.nomor_akun=i.nomor_akun;





-- Tampilkan email member dan blog untuk member yang pernah melakukan
-- pembelian dengan metode selain 'Kartu Kredit'
select *
from `member`;
select *
from pembelian;

select distinct m.email_member, m.blog
from `member` m
join pembelian p
on m.email_member=p.email_member
where p.metode !='Kartu Kredit';





-- Untuk setiap member, tampilkan email member dan banyaknya (berapa kali)
-- pembelian yang pernah dilakukan oleh member tersebut. Urutkan berdasarkan
-- banyaknya pembelian. (tetap tampilkan member yang belum pernah melakukan
-- pembelian)
select *
from `member`;
select *
from pembelian;

select m.email_member, count(p.email_member) jumlah_pembelian
from `member` m
left join pembelian p
on m.email_member=p.email_member
group by m.email_member, p.email_member
order by jumlah_pembelian desc;





-- Tampilkan nama event, nama organisasi, dan harga zona untuk
-- event yang memiliki harga zona paling mahal.
select *
from `event`;
select *
from zona;

select e.nama, e.org_nama, z.harga
from `event` e
join zona z
on e.org_nama=z.nama_organisasi
order by z.harga desc
limit 2;

select e.nama, e.org_nama, z.harga
from `event` e
join zona z
on e.org_nama=z.nama_organisasi
where z.harga = 
(select max(harga)
from zona);



-- Dari setiap metode pembayaran, tampilkan nama metode, banyaknya (berapa kali)
-- pembelian yang dilakukan menggunakan metode tersebut, dan rata-rata harga zona
-- dari setiap pembelian.
select *
from pembelian;
select *
from zona;
select *
from ticket_seat;

with cte1 as
(
select nama_organisasi, no_event, nama_zona, tanggal_bayar_pembelian, metode
from ticket_seat ts
join pembelian p
on ts.email = p.email_member
and ts.tanggal_bayar_pembelian = p.tanggal_bayar
)
select metode, count(metode) jumlah_transaksi, round(avg(harga)) avg_pembelian
from cte1 cte1
join zona z
on z.nama = cte1.nama_zona
and z.no_event = cte1.no_event
and z.nama_organisasi = cte1.nama_organisasi
group by metode
order by avg_pembelian desc;


-- Tampilkan email member, pekerjaan, dan paypal id untuk member yang pernah
-- melakukan pembelian dengan metode pembayaran ‘Paypal’ dan melakukan
-- akumulasi/total harga pembelian lebih dari 7000000
select *
from `member`;
select *
from paypal;
select *
from pembelian;
select *
from ticket_seat;
select *
from zona;

with cte1 as
(select p.email_member, sum(harga) total_pembelian
from pembelian p
join ticket_seat ts
on p.email_member=ts.email
join zona z
on ts.nama_zona=z.nama
and ts.no_event=z.no_event
where p.metode = 'Paypal'
group by p.email_member
having sum(harga)> 7000000)
select cte1.email_member, m.pekerjaan, pp.paypal_id
from cte1
join `member` m
on cte1.email_member=m.email_member
join paypal pp
on cte1.email_member=pp.email_member;

select m.email_member, m.pekerjaan, pp.paypal_id
from `member` m
join paypal pp on m.email_member = pp.email_member
where exists (
  select email_member
  from pembelian p
  join ticket_seat ts on p.email_member = ts.email
  join zona z on ts.nama_zona = z.nama and ts.no_event = z.no_event
  where p.metode = 'Paypal'
    and p.email_member = m.email_member
  group by p.email_member
  having sum(z.harga) > 7000000
);