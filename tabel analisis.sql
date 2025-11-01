CREATE TABLE `rakamin-kf-analytics-476406.kimia_farma.tabel_analisis` AS
SELECT
  t.transaction_id,
  t.date,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  t.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,

  -- Persentase Gross Laba berdasarkan price
  CASE
    WHEN p.price <= 50000 THEN 0.10 
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS percentage_gross_laba,

  -- Harga setelah diskon
  (p.price * (1 - t.discount_percentage / 100.0)) AS nett_sales,

  -- Profit
  (p.price * (1 - t.discount_percentage / 100.0)) *
  CASE
    WHEN p.price <= 50000 THEN 0.10 
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-476406.kimia_farma.kf_final_transaction` t
JOIN `rakamin-kf-analytics-476406.kimia_farma.kf_kantor_cabang` kc
  ON t.branch_id = kc.branch_id
JOIN `rakamin-kf-analytics-476406.kimia_farma.kf_product` p
  ON t.product_id = p.product_id;
