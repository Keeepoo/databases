-- Задача 3: Менеджеры, у которых есть подчинённые (включая косвенных)
WITH RECURSIVE SubordinateCount AS (
    SELECT ManagerID AS SupervisorID, EmployeeID AS SubordinateID, 1 AS depth
    FROM Employees
    WHERE ManagerID IS NOT NULL
    UNION ALL
    SELECT sc.SupervisorID, e.EmployeeID, sc.depth + 1
    FROM SubordinateCount sc
    JOIN Employees e ON e.ManagerID = sc.SubordinateID
),
TotalSubordinates AS (
    SELECT SupervisorID, COUNT(DISTINCT SubordinateID) AS total_sub
    FROM SubordinateCount
    GROUP BY SupervisorID
)
SELECT 
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
     FROM Projects p WHERE p.DepartmentID = e.DepartmentID) AS ProjectNames,
    (SELECT GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
     FROM Tasks t WHERE t.AssignedTo = e.EmployeeID) AS TaskNames,
    COALESCE(ts.total_sub, 0) AS TotalSubordinates
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r ON e.RoleID = r.RoleID
LEFT JOIN TotalSubordinates ts ON e.EmployeeID = ts.SupervisorID
WHERE r.RoleName = 'Менеджер'
  AND COALESCE(ts.total_sub, 0) > 0
ORDER BY e.EmployeeID;
