SELECT SUM(ROUND(table1.TIV_2012, 2)) FROM Insurance table1
INNER JOIN (
  SELECT TIV_2011 FROM Insurance
  GROUP BY TIV_2011
  HAVING COUNT(*) > 1
) table2 on table1.TIV_2011 = table2.TIV_2011
INNER JOIN (
  SELECT lat, lon FROM Insurance
  GROUP BY lat, lon
  HAVING COUNT(*) = 1
) table3 on table1.lat = table3.lat AND table1.lon = table3.lon
