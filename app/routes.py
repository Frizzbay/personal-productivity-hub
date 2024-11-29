"""
Personal Productivity Hub
API routes and request handling
"""
from flask import render_template, current_app
import psycopg2
from psycopg2.extras import RealDictCursor
from app import db

def init_app(app):
    @app.route('/task-network')
    def task_network():
        # Connect to your database
        conn = psycopg2.connect('postgresql://wdcdo:1337@localhost:5432/personal_productivity_hub')
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Use our existing query to get task dependencies
        cur.execute("""
            SELECT
                t1.title as dependent_task_title,
                t1.status as dependent_task_status,
                t2.title as prerequisite_task_title,
                t2.status as prerequisite_task_status
            FROM task_dependencies td
            JOIN tasks t1 ON td.dependent_task_id = t1.task_id
            JOIN tasks t2 ON td.prerequisite_task_id = t2.task_id
        """)
        
        dependencies = cur.fetchall()
        cur.close()
        conn.close()
        
        return render_template('task_network.html', dependencies=dependencies)