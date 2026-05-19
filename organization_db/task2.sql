-- Задача 2: Как задача 1 + количество задач и количество прямых подчинённых
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT 
    eh.EmployeeID,
    eh.Name AS EmployeeName,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
     FROM Projects p WHERE p.DepartmentID = eh.DepartmentID) AS ProjectNames,
    (SELECT GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
     FROM Tasks t WHERE t.AssignedTo = eh.EmployeeID) AS TaskNames,
    (SELECT COUNT(*) FROM Tasks t WHERE t.AssignedTo = eh.EmployeeID) AS TotalTasks,
    (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = eh.EmployeeID) AS TotalSubordinates
FROM EmployeeHierarchy eh
JOIN Departments d ON eh.DepartmentID = d.DepartmentID
JOIN Roles r ON eh.RoleID = r.RoleID
ORDER BY eh.Name;
