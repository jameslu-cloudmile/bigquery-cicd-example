SELECT 
   variety, 
   AVG(petalLength) AS avg_petal_length,
   AVG(petalWidth) AS avg_petal_width
FROM 
   `tw-rd-tam-jameslu.test.iris`
GROUP BY 
   variety
