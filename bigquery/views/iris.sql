SELECT 
   variety, 
   AVG(petalLength) AS avg_petal_length,
   AVG(petalWidth) AS avg_petal_width,
   MAX(petalLength) AS max_petal_length,
   -- MIN(petalLength) AS min_petal_length,
   MAX(petalWidth) AS max_petal_width,
   MIN(petalWidth) AS min_petal_width
FROM 
   `tw-rd-tam-jameslu.test.iris`
GROUP BY 
   variety
