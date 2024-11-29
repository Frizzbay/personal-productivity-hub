/*

Task Dependencies Query
Purpose: Retrieves task dependency relationships for visualization
Used by: Network diagram visualization of task dependencies

This query joins the task_dependencies table with the tasks table
to show how tasks are related to each other, including their statuses.

*/

SELECT 
    td.dependency_id,
    td.dependent_task_id,
    td.prerequisite_task_id,
    t1.title as dependent_task_title,
    t1.status as dependent_task_status,
    t2.title as prerequisite_task_title,
    t2.status as prerequisite_task_status
FROM task_dependencies td
JOIN tasks t1 ON td.dependent_task_id = t1.task_id
JOIN tasks t2 ON td.prerequisite_task_id = t2.task_id;