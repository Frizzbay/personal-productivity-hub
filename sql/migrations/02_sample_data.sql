-- Insert some inital categories

INSERT INTO categories (name, description) VALUES
('Work', 'Professional tasks and Projects'),
('Personal', 'Personal life and errands'),
('Learning','Educational goals and study tasks');

-- Insert some common tags

INSERT INTO tags (name) VALUES
('urgent'),
('deepwork'),
('quick-win'),
('waiting'),
('meeting');

-- Insert some sample tasks

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
        (SELECT category_id FROM categories WHERE name = 'Learning'),
        CURRENT_TIMESTAMP + INTERVAL '1 week',
        INTERVAL '4 hours'
    ),

    (
        'Weekly Planning Session',
        'Review and plan tasks for the upcoming week',
        'not_started',
        'medium',
        (SELECT category_id FROM categories WHERE name = 'Work'),
        CURRENT_TIMESTAMP + INTERVAL '1 day',
        INTERVAL '30 minutes'

    ),

    (   
        'Grocery Shopping',
        'Buy groceries for the week',
        'not_started',
        'medium',
        (SELECT category_id FROM categories WHERE name = 'Personal'),
        CURRENT_TIMESTAMP + INTERVAL '2 days',
        INTERVAL '1 hour'

    );

-- Add tags to tasks (using subqueries to get ID's)

INSERT INTO task_tags (task_id, tag_id)