/*
Project Development Data.

Populating the database with project development tasks and their relationships.

This file adds capability for managing software development projects
while maintaining flexibility for general task management use cases.
*/

-- Additional Categories
-- Adding project-specific yet broadly applicable categories

INSERT INTO categories (name, description) VALUES
    ('Infrastructure', 'System and platform setup tasks'),
    ('Documentation', 'Project documentation and knowledge base'),
    ('Testing', 'Quality assurance and testing activities'),
    ('Design', 'System design and architecture tasks'),
    ('Security', 'Security-related tasks and improvements')
ON CONFLICT (name) DO NOTHING;

INSERT INTO tags(name) VALUES 
    ('blocking'),           -- Indicates a task blocking other progress
    ('enhancement'),        -- Improvements to existing features
    ('documentation'),      -- Documentation-related tasks
    ('technical-debt'),     -- Tasks addressing technical debt
    ('optimization'),       -- Performance improvement tasks
    ('security'),          -- Security-related tasks
    ('user-experience'),    -- UX-focused tasks
    ('foundation'),         -- Core infrastructure tasks
    ('maintenance'),        -- Regular maintenance tasks
    ('review-required')     -- Tasks needing review before completion
ON CONFLICT (name) DO NOTHING;

-- Project Development Tasks
-- Core infrastructure and setup tasks

INSERT INTO tasks (
    title,
    description,
    status,
    priority,
    category_id,
    due_date,
    estimated_duration
) VALUES
    (
        'Database Schema Design',
        'Design and implement initial database schema with proper relations and constraints',
        'completed',
        'high',
        (SELECT category_id FROM categories WHERE name = 'Infrastructure'),
        CURRENT_TIMESTAMP - INTERVAL '2 weeks',
        INTERVAL '8 hours'
    ),
    (
        'Security Role Implementation',
        'Implement database roles and access control',
        'in_progress',
        'high',
        (SELECT category_id FROM categories WHERE name = 'Security'),
        CURRENT_TIMESTAMP + INTERVAL '1 week',
        INTERVAL '4 hours'
    ),
    (
        'Task Network Visualization',
        'Develop interactive visualization of task dependencies',
        'in_progress',
        'high',
        (SELECT category_id FROM categories WHERE name = 'Development'),
        CURRENT_TIMESTAMP + INTERVAL '3 days',
        INTERVAL '6 hours'
    ),
    (
        'API Documentation',
        'Create comprehensive API documentation with examples',
        'not_started',
        'medium',
        (SELECT category_id FROM categories WHERE name = 'Documentation'),
        CURRENT_TIMESTAMP + INTERVAL '2 weeks',
        INTERVAL '5 hours'
    ),
    (
        'Unit Test Suite',
        'Implement comprehensive unit test coverage',
        'not_started',
        'high',
        (SELECT category_id FROM categories WHERE name = 'Testing'),
        CURRENT_TIMESTAMP + INTERVAL '1 week',
        INTERVAL '8 hours'
    ),
    (
        'User Interface Design',
        'Design intuitive interface for task management',
        'in_progress',
        'high',
        (SELECT category_id FROM categories WHERE name = 'Design'),
        CURRENT_TIMESTAMP + INTERVAL '4 days',
        INTERVAL '6 hours'
    )
    
ON CONFLICT (title) DO NOTHING;

INSERT INTO task_tags (task_id, tag_id)
SELECT tasks.task_id, tags.tag_id
FROM tasks
CROSS JOIN tags
WHERE 
    (tasks.title = 'Database Schema Design' AND tags.name IN ('foundation', 'completed', 'blocking'))
    OR (tasks.title = 'Security Role Implementation' AND tags.name IN ('security', 'blocking'))
    OR (tasks.title = 'Task Network Visualization' AND tags.name IN ('enhancement', 'user-experience'))
    OR (tasks.title = 'API Documentation' AND tags.name IN ('documentation', 'review-required'))
    OR (tasks.title = 'Unit Test Suite' AND tags.name IN ('technical-debt', 'foundation'))
    OR (tasks.title = 'User Interface Design' AND tags.name IN ('user-experience', 'enhancement'))
ON CONFLICT (task_id, tag_id) DO NOTHING;

INSERT INTO time_entries (task_id, start_time, end_time, notes)
SELECT 
    tasks.task_id,
    CURRENT_TIMESTAMP - INTERVAL '2 weeks',
    CURRENT_TIMESTAMP - INTERVAL '2 weeks' + INTERVAL '6 hours',
    'Initial implementation compelted'
FROM tasks 
WHERE tasks.title = 'Database Schema Design';   

-- Define task dependencies
-- Creating relationships between tasks that must be completed in a specific order
INSERT INTO task_dependencies (dependent_task_id, prerequisite_task_id)
SELECT 
    dependent_tasks.task_id,
    prerequisite_tasks.task_id
FROM tasks dependent_tasks
CROSS JOIN tasks prerequisite_tasks
WHERE 
    (dependent_tasks.title = 'Security Role Implementation' AND prerequisite_tasks.title = 'Database Schema Design')
    OR (dependent_tasks.title = 'Task Network Visualization' AND prerequisite_tasks.title = 'Database Schema Design')
    OR (dependent_tasks.title = 'API Documentation' AND prerequisite_tasks.title = 'Security Role Implementation')
    OR (dependent_tasks.title = 'Unit Test Suite' AND prerequisite_tasks.title = 'Task Network Visualization')
ON CONFLICT (dependent_task_id, prerequisite_task_id) DO NOTHING;

-- Add task completion tracking
-- Recording time spent on completed tasks
INSERT INTO time_entries (task_id, start_time, end_time, notes)
SELECT 
    tasks.task_id,
    CURRENT_TIMESTAMP - INTERVAL '2 weeks',
    CURRENT_TIMESTAMP - INTERVAL '2 weeks' + INTERVAL '6 hours',
    'Initial implementation completed'
FROM tasks 
WHERE tasks.title = 'Database Schema Design';