-- Membuat tabel baru bernama 'tabel_analisis' di dataset 'kimia_farma'
CREATE TABLE `rakamin-kf-analytics-476406.kimia_farma.tabel_analisis` AS

-- Memilih data dari hasil join 3 tabel
SELECT
  -- ID transaksi unik
  t.transaction_id,

  -- Tanggal transaksi
  t.date,

  -- Nama cabang tempat transaksi dilakukan
  kc.branch_name,

  -- Kota lokasi cabang
  kc.kota,

  -- Provinsi lokasi cabang
  kc.provinsi,

  -- Rating cabang dari tabel kantor cabang
  kc.rating AS rating_cabang,

  -- Nama customer yang melakukan transaksi
  t.customer_name,

  -- ID produk yang dibeli
  p.product_id,

  -- Nama produk yang dibeli
  p.product_name,

  -- Harga asli produk sebelum diskon
  p.price AS actual_price,

  -- Persentase diskon yang diberikan pada transaksi
  t.discount_percentage,

  -- Menghitung persentase estimasi gross laba berdasarkan harga produk
  CASE
    WHEN p.price <= 50000 THEN 0.10 
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS percentage_gross_laba,

  -- Menghitung harga setelah diskon (nett sales)
  (p.price * (1 - t.discount_percentage / 100.0)) AS nett_sales,

  -- Menghitung estimasi profit berdasarkan harga diskon dan margin laba
  (p.price * (1 - t.discount_percentage / 100.0)) *
  CASE
    WHEN p.price <= 50000 THEN 0.10 
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  -- Rating transaksi dari customer terhadap produk atau layanan
  t.rating AS rating_transaksi

-- Mengambil data dari tabel transaksi final
FROM `rakamin-kf-analytics-476406.kimia_farma.kf_final_transaction` t

-- Menggabungkan data cabang berdasarkan branch_id
JOIN `rakamin-kf-analytics-476406.kimia_farma.kf_kantor_cabang` kc
  ON t.branch_id = kc.branch_id

-- Menggabungkan data produk berdasarkan product_id
JOIN `rakamin-kf-analytics-476406.kimia_farma.kf_product` p
  ON t.product_id = p.product_id;

