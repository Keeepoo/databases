-- Задача 1: Мотоциклы с мощностью >150 л.с., ценой <20000, тип Sport
SELECT v.maker, m.model
FROM Motorcycle m
JOIN Vehicle v ON m.model = v.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;
