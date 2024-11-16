/* 
Sample Data for Personal Productivity Hub
Initial test data to populate and verify database functionality
*/

/* Add initial categories for task organization */
INSERT INTO categories (name, description) VALUES
('Personal', 'Personal life and errands'),
('Learning', 'Educational goals and study tasks'),
('Work', 'Work-related tasks')
ON CONFLICT (name) DO NOTHING;

/* Add commonly used tags for task labeling */
INSERT INTO tags (name) VALUES
('urgent'),
('deepwork'),
('quick-win'),
('waiting'),
('meeting')
ON CONFLICT (name) DO NOTHING;

/* Add sample tasks with various properties */
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
        'Learn PostgreSQL Basics',
        'Master fundamental PostgreSQL concepts including CRUD operations',
        'in_progress',
        'high',
        (SELECT category_id FROM categories WHERE name = 'Learning' LIMIT 1),
        CURRENT_TIMESTAMP + INTERVAL '1 week',
        INTERVAL '4 hours'
    ),
    (
        'Weekly Planning Session',
        'Review and plan tasks for the upcoming week',
        'not_started',
        'medium',
        (SELECT category_id FROM categories WHERE name = 'Work' LIMIT 1),
        CURRENT_TIMESTAMP + INTERVAL '1 day',
        INTERVAL '30 minutes'
    ),
    (  
        'Grocery Shopping',
        'Buy groceries for the week',
        'not_started',
        'medium',
        (SELECT category_id FROM categories WHERE name = 'Personal' LIMIT 1),
        CURRENT_TIMES