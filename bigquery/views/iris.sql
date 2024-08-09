SELECT 
   variety, 
   AVG(petalLength) AS avg_petal_length
FROM 
   `tw-rd-tam-jameslu.test.iris`
GROUP BY 
   variety
